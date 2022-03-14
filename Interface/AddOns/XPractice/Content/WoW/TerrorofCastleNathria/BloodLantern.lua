local TELEGRAPH2HEIGHT=5

do
	local super=XPRACTICE.Mob
	XPRACTICE.TERROROFCASTLENATHRIA.BloodLantern = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodLantern
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.carried=false
		self.carriermob=nil
		self.previouscarriermob=nil
		self.scale=2
		self.nextapplyauratime=0
	end
	
	function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
		local radius=0.5
		local base=0
		local height=1.25
		displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
	end		
	
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3241180)	-- 9vm_vampire_lantern01
	end
	
	function class:CreateAssociatedObjects()
		local telegraph=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternTelegraph.new()
		telegraph:Setup(self.environment,self.position.x,self.position.y,0)
		telegraph.lantern=self
	end
	
	function class:OnClick(player,environment,button)
		if(not player:IsDeadInGame())then
			if(self.carried==false)then
				if(self:IsInClickRange(player))then
					self:ClearSpeechBubble()
					self.carried=true
					self.carriermob=player			
					self.previouscarriermob=player
					local telegraph2=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternTelegraph2.new()
					telegraph2:Setup(environment,player.position.x,player.position.y,TELEGRAPH2HEIGHT)
					telegraph2.lantern=self				
				else
					self:CreateSpeechBubble("Too far away!")
				end
			end
		end
	end		
	
	--TODO: this might become a generic Mob function later?
	function class:IsInClickRange(player)
		local distx=player.position.x-self.position.x
		local disty=player.position.y-self.position.y
		local distsqr=distx*distx+disty*disty
		return(distsqr<=4*4)
	end	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		local lightcenterx,lightcentery
		local lightradius
		if(self.carried)then
			local RADIUS=0.75
			lightradius=XPRACTICE.Config.Shriekwing.BloodLanternCarriedRadius
			lightcenterx=self.carriermob.position.x;	lightcentery=self.carriermob.position.y
			self.position.x=self.carriermob.position.x-RADIUS*math.cos(self.carriermob.orientation_displayed.yaw)
			self.position.y=self.carriermob.position.y-RADIUS*math.sin(self.carriermob.orientation_displayed.yaw)
			self.position.z=self.carriermob.position.z+1
			self.orientation_displayed.yaw=self.carriermob.orientation_displayed.yaw
			self.orientation.yaw=self.orientation_displayed.yaw
			self.orientation_displayed.pitch=0.5
			self.orientation_displayed.pitch=0.25
			if(self.carriermob:IsDeadInGame() or self.carriermob.dead)then				
				self.carried=false
				self.carriermob=nil
			end
		end
		if(self.carried==false)then
			lightradius=XPRACTICE.Config.Shriekwing.BloodLanternFloorRadius
			if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternActiveOnFloor==false)then
				lightradius=-1
			end
			lightcenterx=self.position.x;lightcentery=self.position.y
			self.position.z=0			
			self.orientation_displayed.pitch=0
		end
		
		if(lightradius>=0)then
			local player=self.scenario.player
			if(self.localtime>=self.nextapplyauratime)then
				if(player and not player:IsDeadInGame())then
					local distsqr=XPRACTICE.distsqr(player.position.x,player.position.y,lightcenterx,lightcentery)
					if(distsqr<=lightradius*lightradius)then
						local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.TERROROFCASTLENATHRIA.Aura_Bloodlight,player.combatmodule,player.localtime)
						self.nextapplyauratime=self.localtime+XPRACTICE.Config.Shriekwing.BloodlightApplicationRate
						--aura.scenario=spellinstancepointer.castercombat.mob.scenario
					end
				end		
			end
		end
	end
	
	function class:DropMe(x,y)
		self.carried=false
		self.carriermob=nil
		self.position.x=x
		self.position.y=y
		self.position.z=0
		self.orientation.yaw=self.orientation_displayed.yaw
		self.orientation_displayed.yaw=self.orientation_displayed.yaw
		self.orientation_displayed.pitch=0
	end
end

do
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_DropBloodLantern = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_DropBloodLantern
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Drop Blood Lantern"
		self.icon="interface/icons/inv_misc_trinket6oih_lanterna1.blp"

		self.requiresfacing=false		
		self.projectileclass=nil		
		self.basecastduration=0
		self.basechannelduration=nil		
		self.basechannelticks=nil
		self.tickonchannelstart=false
		self.usablewhilemoving=true
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)				
		local auras=spellinstancepointer.castercombat.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern)
		if(#auras>0)then
			local aura=auras[1]
			aura:Die()
		else
			local aura=spellinstancepointer.castercombat:ApplyAuraByClass(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern,spellinstancepointer.castercombat,castendtime)
			aura.scenario=spellinstancepointer.castercombat.mob.scenario
			spellinstancepointer.castercombat.mob.scenario.statuslabel:SetText("Click on a flashing lantern to drop the Blood Lantern in that location.",3.0)
		end
	end
	

	
end


do
	local super=XPRACTICE.Aura
	XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.baseduration=nil
	end
	
	function class:OnApply(localtime)		
		super.OnApply(self,localtime)
		--self.castercombat.mob
		local mob=self.castercombat.mob
		for i=1,8 do
			local angle=math.pi*2*(i/8)
			local RADIUS=5
			local lanterngtl=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternGroundTargetLocation.new()
			local x=RADIUS*math.cos(angle+mob.orientation.yaw)+mob.position.x
			local y=RADIUS*math.sin(angle+mob.orientation.yaw)+mob.position.y
			lanterngtl:Setup(mob.environment,x,y,0)
			lanterngtl.angle=angle
			lanterngtl.orientation_displayed.yaw=angle+mob.orientation.yaw
			lanterngtl.orientation.yaw=lanterngtl.orientation_displayed.yaw
			lanterngtl.radius=RADIUS
			lanterngtl.mob=mob
			lanterngtl.scenario=mob.scenario
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(mob.environment,lanterngtl)	
		end
	end	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
	end
	

end


do
	local FLASHRATE=0.25
	local FLASHALPHA1=0.5
	local FLASHALPHA2=0.1
	
	local super=XPRACTICE.Mob
	XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternGroundTargetLocation = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternGroundTargetLocation

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.flashstate=false
		self.flashtimer=FLASHRATE
		self.scale=2
		self.alpha=FLASHALPHA1
		self.startingphasealpha=1
	end
	
	function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
		local radius=0.5
		local base=0
		local height=1.25
		displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
	end	
	
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3241180)	-- 9vm_vampire_lantern01
	end
	
	function class:OnClick(player,environment,button)
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern)		
		if(#auras>0)then									
			local cancel=false
			for i=1,#self.scenario.lines do
				local line=self.scenario.lines[i]				
				if(XPRACTICE.LineLineIntersection(self.position.x,self.position.y,self.mob.position.x,self.mob.position.y,
													line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2))then
					cancel=true
					break
				end
			end
			if(not cancel)then
				auras[1]:Die()
				local lantern=self.scenario.lantern
				lantern:DropMe(self.position.x,self.position.y)
			end
		end
	end	
	

	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		self.flashtimer=self.flashtimer-elapsed
		if(self.flashtimer<0)then
			self.flashtimer=self.flashtimer+FLASHRATE
			self.flashstate=not self.flashstate
			if(self.flashstate)then
				self.alpha=FLASHALPHA2
			else
				self.alpha=FLASHALPHA1
			end
		end
		
		local x=self.radius*math.cos(self.angle+self.mob.orientation.yaw)+self.mob.position.x
		local y=self.radius*math.sin(self.angle+self.mob.orientation.yaw)+self.mob.position.y
		self.position.x=x;self.position.y=y
		self.orientation_displayed.yaw=self.angle+self.mob.orientation.yaw

		if(self.scenario.lantern)then
			if(self.scenario.lantern.carried==false)then
				self:Die()
			else
				if(self.scenario.lantern.carriermob:IsIncapacitated())then
					self:Die()
					local auras=self.scenario.lantern.carriermob.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern)
					if(#auras>0)then
						auras[1]:Die()
					end
				end
				local auras=self.scenario.lantern.carriermob.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern)
				if(#auras==0)then
					self:Die()
				end
			end
		else
			self:Die()
		end
	end
end



do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternTelegraph=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternTelegraph
	
	--"within 14 yards"
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=14.0*(3/12.0)
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.25
	end	

	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3642468)	-- target_anima_revendreth_state_rimonly.m2		
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.lantern)then
			if(not self.lantern.dead)then
				if(self.lantern.carried)then
					self.scale=14.0*(3/12.0)
					self.position={x=self.lantern.carriermob.position.x,y=self.lantern.carriermob.position.y,z=0}
				else
					self.scale=4.0*(3/12.0)
					self.position={x=self.lantern.position.x,y=self.lantern.position.y,z=0}
					--self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
				end
			else
				self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
		end
	end
end


do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternTelegraph2=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternTelegraph2
	
	--"within 14 yards"
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=2
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.25
	end	

	function class:SetActorAppearanceViaOwner(actor)
		----TODO LATER: these are not the right models
		actor:SetModelByFileID(3234482)	-- 9fx_generic_anima_revendreth_pickup		
		--actor:SetModelByFileID(1733378)	--creature_goo_orb_bloodtroll_nodrippile
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.lantern)then
			if(self.lantern.carried)then
				self.position={x=self.lantern.carriermob.position.x,y=self.lantern.carriermob.position.y,z=TELEGRAPH2HEIGHT}
			else
				self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
		end
	end
end


do
	local super=XPRACTICE.Aura
	XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.baseduration=nil
	end
	
	function class:OnApply(localtime)		
		super.OnApply(self,localtime)
		--self.castercombat.mob
		local mob=self.castercombat.mob
		for i=1,8 do
			local angle=math.pi*2*(i/8)
			local RADIUS=5
			local lanterngtl=XPRACTICE.TERROROFCASTLENATHRIA.BloodLanternGroundTargetLocation.new()
			local x=RADIUS*math.cos(angle+mob.orientation.yaw)+mob.position.x
			local y=RADIUS*math.sin(angle+mob.orientation.yaw)+mob.position.y
			lanterngtl:Setup(mob.environment,x,y,0)
			lanterngtl.angle=angle
			lanterngtl.orientation_displayed.yaw=angle+mob.orientation.yaw
			lanterngtl.orientation.yaw=lanterngtl.orientation_displayed.yaw
			lanterngtl.radius=RADIUS
			lanterngtl.mob=mob
			lanterngtl.scenario=mob.scenario
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(mob.environment,lanterngtl)	
		end
	end	
	

end

do
	local super=XPRACTICE.Aura
	XPRACTICE.TERROROFCASTLENATHRIA.Aura_Bloodlight=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Aura_Bloodlight
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.baseduration=XPRACTICE.Config.Shriekwing.BloodlightDuration
		self.removeondeadingame=false --this wouldn't happen in the real game, but it makes the action easier to follow
		self.maximumdisplayedtimeremaining=XPRACTICE.Config.Shriekwing.BloodlightDuration-XPRACTICE.Config.Shriekwing.BloodlightApplicationRate
		self.minimumflashstacks=XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks
		self.icon="interface/icons/spell_animarevendreth_orb.blp"
	end
	
	function class:AddAuraToCombatModule(targetcombat)
		local auras=targetcombat.auras:GetAurasByClassIfExist(class)
		if(#auras==0)then
			local aura=targetcombat:AddNewAura(self)
			self:OnApply(localtime)
		else
			local aura=auras[1]
			aura.expirytime=targetcombat.localtime+aura.baseduration
			aura.stacks=aura.stacks+1
			if(aura.stacks>=99)then aura.stacks=99 end
			--TODO: maybe pulse stack display
			if(aura.stacks>=XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks)then
				local scenario=targetcombat.mob.scenario
				if(scenario.phaseinprogress)then
					local aura=targetcombat:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,targetcombat,scenario.localtime)
					targetcombat.mob.scenario.statuslabel:SetText("You died from Bloodlight stacks.",3.0)
				end
			end
		end
	
	end
	
	function class:OnApply(localtime)		
		super.OnApply(self,localtime)
		local mob=self.castercombat.mob
		local trail=XPRACTICE.TERROROFCASTLENATHRIA.BloodlightTrail.new()		
		trail:Setup(mob.environment,mob.position.x,mob.position.y,mob.position.z)
		trail.mob=mob
		trail.scenario=mob.scenario
		mob.bloodlighttrail=trail
		mob.scenario.sonarvisible=true
	end
	
	function class:OnRemove()		
		super.OnRemove(self)
		local mob=self.castercombat.mob
		--mob.bloodlighttrail:Die()
		mob.bloodlighttrail.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		mob.bloodlighttrail=nil		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty==2)then
			mob.scenario.sonarvisible=false
		end
	end
end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.BloodlightTrail=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodlightTrail
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=1.5
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=3.0
	end	

	function class:SetActorAppearanceViaOwner(actor)
		----TODO LATER: not the right models
		actor:SetModelByFileID(1249924)
		--actor:SetModelByFileID(1249120)
		--actor:SetModelByFileID(166693)
		--actor:SetModelByFileID(166012)
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		self.position.x=self.mob.position.x
		self.position.y=self.mob.position.y
		self.position.z=self.mob.position.z+0
	end
end
