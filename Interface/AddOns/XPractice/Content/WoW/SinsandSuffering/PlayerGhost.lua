do	
	local super=XPRACTICE.Spell
	XPRACTICE.SINSANDSUFFERING.Spell_MoveGhosts=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Spell_MoveGhosts


	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Move Ghosts"
		self.icon="interface/icons/ability_rogue_sprint.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		self.basecastduration=0.0
		self.basechannelduration=nil
		self.basechannelticks=nil
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)			
	
		-- don't worry about "player's preferred role" -- too complicated for now
		
		local scenario=self.scenario
		local remainingpoints={unpack(scenario.solutionpoints)}	-- shallow copy
		for i=1,#remainingpoints do
			remainingpoints[i].realindex=i
		end
		local remainingplayers={self.scenario.player}
		for i=1,#self.scenario.ghosts do
			if(self.scenario.ghosts[i].enabled)then tinsert(remainingplayers,self.scenario.ghosts[i]) end
		end
		
		-- while remaining points>0 and remaining players>0
		local failsafe=10
		while(#remainingpoints>0 and #remainingplayers>0 and failsafe>0)do
			failsafe=failsafe-1
		-- get average of player positions
			local avg={x=0,y=0}
			for i=1,#remainingplayers do
				avg.x=avg.x+remainingplayers[i].position.x
				avg.y=avg.y+remainingplayers[i].position.y
			end
			avg.x=avg.x/#remainingplayers
			avg.y=avg.y/#remainingplayers
		-- what is the furthest point from average?
			local furthestdistsqr=nil
			local furthestpoint=nil
			for i=1,#remainingpoints do
				local distsqr=XPRACTICE.distsqr(avg.x,avg.y,remainingpoints[i].x,remainingpoints[i].y)
				if((not furthestdistsqr) or distsqr>furthestdistsqr)then
					furthestdistsqr=distsqr
					furthestpoint=i
				end
			end
		-- closest player to that point goes there
			local closestdistsqr=nil
			local closestplayer=nil
			for i=1,#remainingplayers do
				local distsqr=XPRACTICE.distsqr(remainingplayers[i].position.x,remainingplayers[i].position.y,remainingpoints[furthestpoint].x,remainingpoints[furthestpoint].y)
				if((not closestdistsqr) or distsqr<closestdistsqr)then
					closestdistsqr=distsqr
					closestplayer=i
				end
			end
			--assign point to player so we can track role
			remainingplayers[closestplayer].solutionpoint=remainingpoints[furthestpoint]
			--assign destination to player (if CPU controlled)
			if(remainingplayers[closestplayer].cpu)then 
				--print("Player",closestplayer,"to destination (",remainingpoints[furthestpoint].x,remainingpoints[furthestpoint].y," )")
				--remainingplayers[closestplayer].ai.targetposition={x=remainingpoints[furthestpoint].x,y=remainingpoints[furthestpoint].y,z=0}
				remainingplayers[closestplayer].destx=remainingpoints[furthestpoint].x
				remainingplayers[closestplayer].desty=remainingpoints[furthestpoint].y
				
				
				--after moving, face towards one of the other solutionpoints
				local otherpoints={1,2,3}
				tremove(otherpoints,remainingpoints[furthestpoint].realindex)
				local otherpoint
				if(math.random()>0.5)then otherpoint=otherpoints[1] else otherpoint=otherpoints[2] end
				--print("looking from",remainingpoints[furthestpoint].realindex,"to",otherpoint)				
				local angle=math.atan2(scenario.solutionpoints[otherpoint].y-scenario.solutionpoints[remainingpoints[furthestpoint].realindex].y,scenario.solutionpoints[otherpoint].x-scenario.solutionpoints[remainingpoints[furthestpoint].realindex].x)
				
				
				if(remainingplayers[closestplayer].cpu)then
					remainingplayers[closestplayer].destyaw=angle					
					remainingplayers[closestplayer].remainingreactiontime=math.random()*1.0+0.5					
					remainingplayers[closestplayer].remainingrolltime=remainingplayers[closestplayer].remainingreactiontime+math.random()*1.0+0.25					
					--print("Ghost",remainingplayers[closestplayer],"to",remainingplayers[closestplayer].destx,remainingplayers[closestplayer].desty)
					-- remainingplayers[closestplayer].ai.changeorientationtomovementdirection=true
					-- remainingplayers[closestplayer].ai.targetposition={x=remainingplayers[closestplayer].destx,y=remainingplayers[closestplayer].desty,z=0}
				end
			else
				--print("Player",closestplayer,"is player; skip")
			end
		-- remove that point and that player from list
			tremove(remainingpoints,furthestpoint)
			tremove(remainingplayers,closestplayer)
		end
		if(failsafe<=0)then
			--TODO LATER: crash gracefully
			print("PlayerGhost.lua assertion failed")
		end
		
		scenario:ClickButtonAfterDelay(scenario.announcerolebutton,0.5)
		
	end
end

do
	local super=XPRACTICE.Mob
	XPRACTICE.SINSANDSUFFERING.PlayerGhost=XPRACTICE.inheritsFrom(XPRACTICE.Mob)
	local class=XPRACTICE.SINSANDSUFFERING.PlayerGhost
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.targetghostalpha=0
		self.ghostalpha=0
		self.ghostalphamultiplier=0.75	
		self.enabled=false
	end	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)
		self.displayobject.drawable:SetModelByUnit("player")
	end	
	function class:CreateCombatModule()
		super.CreateCombatModule(self)
		local spell_roll=XPRACTICE.Spell_Roll.new()
		spell_roll:Setup(self.combatmodule)
		--TODO: don't hardcode roll.  it's already spellbook[1]
		self.combatmodule.spellbook.roll=spell_roll
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		if(self.remainingreactiontime and self.remainingreactiontime>0)then
			self.remainingreactiontime=self.remainingreactiontime-elapsed
			if(self.remainingreactiontime<=0)then
				self.remainingreactiontime=0
				self.ai:SetTargetPosition(self.destx,self.desty)
				self.orientation.yaw=self.destyaw
			end
		end
		if(self.remainingrolltime and self.remainingrolltime>0)then
			self.remainingrolltime=self.remainingrolltime-elapsed			
			if(self.remainingrolltime<=0)then
				--print("roll check")
				self.remainingrolltime=0
				local MINDIST=20
				if(self.ai.targetposition)then
					local distsqr=XPRACTICE.distsqr(self.ai.targetposition.x,self.ai.targetposition.y,self.position.x,self.position.y)
					--local dist=math.sqrt(distsqr)					
					if(distsqr>=MINDIST*MINDIST)then
						--print("dist:",dist)
						local spell_roll=self.combatmodule.spellbook.roll
						local queuepointer=spell_roll:NewQueue()
						queuepointer.castercombat=self.combatmodule
						local errorcode=self.combatmodule:TryQueue(queuepointer)
					end
					--TODO:
					-- self.ai.targetposition={x=self.destx,y=self.desty}
					-- self.orientation.yaw=self.destyaw
				end
			end
		end
		
		if(self.scenario and self.scenario.player)then
			-- local xdist=self.scenario.player.position.x-self.position.x
			-- local ydist=self.scenario.player.position.y-self.position.y
			-- local distsqr=xdist*xdist+ydist*ydist
			if(not self.enabled)then
				self.targetghostalpha=0
			else
				self.targetghostalpha=1
			end
			--print(self.targetghostalpha,self.ghostalpha)
			if(self.ghostalpha>self.targetghostalpha)then
				--self.ghostalpha=self.ghostalpha-elapsed*0.5
				self.ghostalpha=self.ghostalpha-elapsed*1.5
				if(self.ghostalpha<self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
			end
			if(self.ghostalpha<self.targetghostalpha)then
				self.ghostalpha=self.ghostalpha+elapsed*0.5
				if(self.ghostalpha>self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
			end			
		end
		self.alpha=self.ghostalpha*self.ghostalphamultiplier
	end

end

do	
	XPRACTICE.SINSANDSUFFERING.Spell_ToggleGhost={}
	for i=1,2 do
		local super=XPRACTICE.Spell
		XPRACTICE.SINSANDSUFFERING.Spell_ToggleGhost[i]=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.Spell_ToggleGhost[i]
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Toggle Ghost "..tostring(i)
			if(i==2)then
				self.icon="interface/icons/spell_magic_lesserinvisibilty.blp"
			else
				self.icon="interface/icons/spell_nature_invisibilty.blp"
			end
			self.activeicon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"

			self.usablewhilemoving=true
			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		
		function class:GetIcon()
			if(self.ghost.enabled==false)then
				return self.icon
			else
				return self.activeicon
			end
		end

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)				
			self.ghost.enabled=not self.ghost.enabled
			self.button:SetIcon(self:GetIcon())
			if(self.ghost.enabled)then
				self.ghost.position.x=self.scenario.player.position.x
				self.ghost.position.y=self.scenario.player.position.y
				self.ghost.position.z=5
				self.ghost.velocity={x=0,y=0,z=0}
				self.ghost:FreezeOrientation(self.scenario.player.target_orientation_displayed.yaw)
				--TODO LATER: ghostalpha=0 doesn't work, ghost appears at full alpha for one frame when rapidly resummoned
				--self.ghost.ghostalpha=0
			else
				--TODO LATER: maybe flying serpent kick back to player?
				--for now, try jumping
				if(self.ghost.position.z<=0)then
					if(#self.ghost.combatmodule.auras.forcedmovement==0)then
						if(self.ghost:IsIncapacitated()==false)then
							--TODO: move to AI?
							self.ghost.velocity.z=self.ghost.jumpvelocity.z
							self.ghost.animationmodule:PlayAnimation(XPRACTICE.AnimationList.JumpStart)
						end
					end
				end
			end
		end
	end
end

do	
	XPRACTICE.SINSANDSUFFERING.Spell_AllPlayerGhostsOff={}
	
	local super=XPRACTICE.Spell
	XPRACTICE.SINSANDSUFFERING.Spell_AllPlayerGhostsOff=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Spell_AllPlayerGhostsOff
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="All Player Ghosts Off"
		self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		self.basecastduration=0.0
		self.basechannelduration=nil
		self.basechannelticks=nil
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)					
		for i=1,2 do
			local ghost=self.scenario.ghosts[i]
			if(not ghost.cpu)then
				--TODO LATER: code reuse
				ghost.enabled=false				
				if(ghost.position.z<=0)then
					if(#ghost.combatmodule.auras.forcedmovement==0)then
						if(ghost:IsIncapacitated()==false)then
							ghost.velocity.z=ghost.jumpvelocity.z
							ghost.animationmodule:PlayAnimation(XPRACTICE.AnimationList.JumpStart)
						end
					end
				end			
			end
		end
		for i=1,2 do
			local button=self.scenario.toggleghostbutton[i]
			if(button)then
				button:SetIcon(self.scenario.spell_toggleghost[i]:GetIcon())
			end
		end
	end
end