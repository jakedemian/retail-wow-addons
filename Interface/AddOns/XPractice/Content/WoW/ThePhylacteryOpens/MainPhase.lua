do
	
	
	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.MainPhaseFloor=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.MainPhaseFloor
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4004611)	--9fx_raid2_KELTHUZADMULTIPLAYER_groundfog
		end
	end
	
	
	
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ChangePhase = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ChangePhase
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Enter the Phylactery"
			self.icon="interface/icons/ability_warlock_fireandbrimstonegreen.blp"

			self.requiresfacing=false		
			self.projectileclass=nil		
			self.basecastduration=0
			self.basechannelduration=nil		
			self.basechannelticks=nil
			self.tickonchannelstart=false
			self.usablewhilemoving=true
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)		
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local player=scenario.player
			--scenario.multiplayer:FormatAndSendCustom("CHANGE_PHASE")	
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase)
			if(#auras==0)then
				local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase,player.combatmodule,player.environment.localtime)
				aura.scenario=scenario
			end	
		end
	end
	
	do
		local super=XPRACTICE.Aura
		XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.baseduration=2.0
			self.tickdelay=0.0
			self.basetickrate=1.0
			self.tickcount=0
			self.actiontick=2
			local player=self.targetcombat.mob
			self.destination=not player.inphase
		end
		
		function class:OnTick(ticktime,percentage)
			super.OnTick(self,ticktime,percentage)			
			self.tickcount=self.tickcount+1			
			if(self.tickcount==self.actiontick-1)then				
				local player=self.targetcombat.mob
				local visual=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisual.new()	
				visual:Setup(player.environment)
				visual.player=player	
			elseif(self.tickcount==self.actiontick)then
				if(true)then
					local player=self.targetcombat.mob
					local scenario=self.scenario
					player.inphase=self.destination
					
					if(player.inphase)then
						player.position.x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3
						player.position.y=0
						player.position.z=0				
						player.velocity.x=0
						player.velocity.y=0
						player.velocity.z=0
						player:FreezeOrientation(0)
						player.timeinphase=0
						if(player==scenario.player)then
							player.environment.cameramanager.camera.orientation.pitch=math.pi*0.05							
						end
					else
						player.position={x=0,y=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-10,z=0}	
						player.orientation.yaw=-math.pi/2;player.orientation_displayed.yaw=player.orientation.yaw
						player.velocity.x=0;player.velocity.y=0;player.velocity.z=0
						player.timeinphase=0
						if(player==scenario.player)then
							player.environment.cameramanager.camera.orientation.pitch=math.pi*0.05	
						end
					end
					
					scenario.multiplayer:FormatAndSendCustom("CHANGE_PHASE",player.inphase)
					
					--TODO: only if player is scenario.player
					if(player==scenario.player)then
						player.environment.cameramanager.camera.orientation.yaw=player.orientation.yaw
					end
					player.floorbelow=true
				else
					local player=self.targetcombat.mob
					local scenario=self.scenario		
					player.position.x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3
					player.position.y=0
					player.position.z=0
					player.velocity.x=0
					player.velocity.y=0
					player.velocity.z=0
					player.ai.targetposition=nil
					player:FreezeOrientation(0)
					player.floorbelow=true
					player.timeinphase=0
					if(player==scenario.player)then
						player.environment.cameramanager.camera.orientation.pitch=math.pi*0.05							
						player.environment.cameramanager.camera.orientation.yaw=0
						for i=1,#scenario.swirls do
							local swirl=scenario.swirls[i]
							swirl.disarmed=true
							if(swirl.expirytime==nil)then							
								swirl.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
							end
						end		
						for i=1,#scenario.pools do
							local pool=scenario.pools[i]
							if(pool.expirytime>pool.environment.localtime+1.0)then
								pool.fadestarttime=pool.environment.localtime+0.0
								pool.expirytime=pool.environment.localtime+1.0
							end
						end	
						scenario.boss.combatmodule.castedspell=nil
						scenario.statuslabel:SetText("You escaped the phylactery.  Sort of.",3.0)
						scenario.exitportallocked=true
					end					
				end
			end
		end
		
	end
	
	do
		local super=XPRACTICE.Aura
		XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.baseduration=4.0
			self.tickdelay=0.0
			self.basetickrate=1.0
			self.tickcount=0
			self.actiontick=4
			local player=self.targetcombat.mob
			self.destination=false
			self.removeondeadingame=false
		end
		
		function class:OnTick(ticktime,percentage)
			super.OnTick(self,ticktime,percentage)
			self.tickcount=self.tickcount+1			
			if(self.tickcount==self.actiontick-1)then				
				local player=self.targetcombat.mob
				local visual=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisualForced.new()	
				--print("vis")
				visual:Setup(player.environment)
				visual.player=player	
			elseif(self.tickcount==self.actiontick)then
				if(true)then
					local player=self.targetcombat.mob
					local scenario=self.scenario
					player.inphase=self.destination					

					player.position={x=0,y=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-10,z=0}	
					player.orientation.yaw=-math.pi/2;player.orientation_displayed.yaw=player.orientation.yaw
					if(player==scenario.player)then
						player.environment.cameramanager.camera.orientation.pitch=math.pi*0.05	
					end
					player.velocity.x=0
					player.velocity.y=0
					player.velocity.z=0

					scenario.multiplayer:FormatAndSendCustom("CHANGE_PHASE",player.inphase)

					--TODO: only if player is scenario.player
					if(player==scenario.player)then
						player.environment.cameramanager.camera.orientation.yaw=player.orientation.yaw
					end
					player.floorbelow=true	
				end
			end
		end
		
	end	

	
	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisual=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisual
		function class:CreateDisplayObject()
			self.displayobject=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisualDisplayObject.new()
			self.displayobject:Setup(self)			
			self.displayobject.drawable:SetParent(self.environment.game.window.frame) --TODO: -- ???
			self.displayobject.drawable:SetAllPoints(self.environment.game.window.frame)
			self.displayobject.drawable:Show()
			self.displayobject.drawable:SetAlpha(1)
			self.displayobject.drawable:SetFrameLevel(254) -- ?
		end
		function class:Step(elapsed)
			super.Step(self,elapsed)			
			self.alivetime=self.alivetime or 0
			self.state=self.state or 0
			self.alivetime=self.alivetime+elapsed
			--print("vis",self.alivetime)
			if(self.alivetime>=0.65 and self.state==0)then
				self.state=self.state+1
				self.displayobject.actor:SetAnimation(158)
			elseif(self.alivetime>=1.0 and self.state==1)then
				self.state=self.state+1
				self.displayobject.actor:SetAnimation(159)
			elseif(self.alivetime>=1.65)then
				self:Die()
			end
			if(self.player:IsDeadInGame())then
				self:Die()
			end
		end
		-- function class:Draw(elapsed)
			-- --self.displayobject:SetPositionAndScale(self.position,self.scale)
			-- --self.displayobject.drawable:SetAllPoints(self.environment.game.window.frame)
		-- end	
	end
	
	do	
		local super=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisual
		XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisualForced=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisualForced
		function class:Step(elapsed)
			-- don't call super!  skip directly to gameobject instead, otherwise object will die when it detects player is deadingame
			XPRACTICE.GameObject.Step(self,elapsed)			
			self.alivetime=self.alivetime or 0
			self.state=self.state or 0
			self.alivetime=self.alivetime+elapsed
			--print("vis",self.alivetime)
			if(self.alivetime>=0.65 and self.state==0)then
				self.state=self.state+1
				self.displayobject.actor:SetAnimation(158)
			elseif(self.alivetime>=1.0 and self.state==1)then
				self.state=self.state+1
				self.displayobject.actor:SetAnimation(159)
			elseif(self.alivetime>=1.65)then
				self:Die()
			end
		end
		-- function class:Draw(elapsed)
			-- --self.displayobject:SetPositionAndScale(self.position,self.scale)
			-- --self.displayobject.drawable:SetAllPoints(self.environment.game.window.frame)
		-- end	
	end	
	
	
	do	
		local super=XPRACTICE.DisplayObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisualDisplayObject=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PhaseTransitionVisualDisplayObject
		
		function class:CreateDrawable()
			local f=XPRACTICE.ReusableModelSceneFrames:GetFrame()
			self.drawable=f
			self.drawable.owner=self
			tinsert(self.drawables,f)
			--f:SetAllPoints(UIParent);
			local a=XPRACTICE.ReusableModelSceneFrames:GetActor(f)
			a:SetModelByFileID(3622462) --9fx_corpserun_loadingscreenhold_camera_maldraxxus
			a:SetPosition(1,0,0)
			a:Show()			
			a:SetAlpha(0.5)
			a:SetAnimation(0) 	--TODO: should be in baseline resetactor
			self.actor=a
		end
		function class:Cleanup()
			--print("vis cleanup")
			XPRACTICE.ReusableModelSceneFrames:RemoveActor(self.drawable,self.actor)
			super.Cleanup(self)
		end
	end
	
	
	do
		local super=XPRACTICE.Mob
		XPRACTICE.KELTHUZADMULTIPLAYER.ScryingOrb=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.ScryingOrb
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(125825)	--scryingorb		
		end
		
		-- function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
			-- local radius=1.5
			-- local base=2
			-- local height=2.5
			-- displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
		-- end	
		
		function class:OnClick(player,environment,button)
			if((not player.portaldebuff) and (not player:IsDeadInGame()))then					
				if(self:IsInClickRange(player))then			
					self.scenario.spectating=true
					self.scenario.game.environment_gameplay.cameramanager.camera.focus=self.scenario.boss
				else
					self:CreateSpeechBubble("Too far away!")
				end
			end
		end
		
		--TODO: this might become a generic Mob function later?
		function class:IsInClickRange(player)
			local distx=player.position.x-self.position.x
			local disty=player.position.y-self.position.y
			local distsqr=distx*distx+disty*disty
			local dist=math.sqrt(distsqr)	
			return(dist<=5)
		end
	
	end
end