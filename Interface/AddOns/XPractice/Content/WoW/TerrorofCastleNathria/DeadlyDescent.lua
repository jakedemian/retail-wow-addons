
--TODO: countdown chat bubble?


do
	local super=XPRACTICE.Aura
	XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_GracePeriod=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_GracePeriod
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.alivetime=0
	end

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		
		self.baseduration=XPRACTICE.Config.Shriekwing.DeadlyDescentGracePeriod
	end
end

do
	local super=XPRACTICE.Aura_Incapacitated
	XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_Horrified=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_Horrified
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
	end

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.animation=XPRACTICE.AnimationList.Cower
		
		self.baseduration=XPRACTICE.Config.Shriekwing.DeadlyDescentHorrifyTime
	end
	
	function class:SetupNewauraLists(auramodule)
		super.SetupNewauraLists(self,auramodule)
		tinsert(self.auramodulelists,auramodule.animation)
		tinsert(self.auramodulelists,auramodule.lossofcontrolalert)
	end	
	
	function class:GetAnimation()
		return self.animation
	end
	function class:GetLOCAIcon()
		return "interface/icons/spell_shadow_ragingscream.blp"
	end
	function class:GetLOCAText()
		return "Horrified"
	end	
end




do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.SonarImpact=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.SonarImpact

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=1.0
		self.expirytime=self.environment.localtime+0.5
	end
	function class:SetActorAppearanceViaOwner(actor)		
		actor:SetModelByFileID(3621932) --9fx_raid1_gargoylebat_sonicwave_impact
	end
end



do	
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.OverheadFearEffect=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.OverheadFearEffect

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=1.0
		--self.fadestarttime=self.environment.localtime+XPRACTICE.Config.Shriekwing.DeadlyDescentHorrifyTime
		--self.expirytime=self.environment.localtime+XPRACTICE.Config.Shriekwing.DeadlyDescentHorrifyTime+1.0
	end
	function class:SetActorAppearanceViaOwner(actor)				
		actor:SetModelByFileID(876375) --fear_state_base_v2
		--actor:SetModelByFileID(1467538) --fear_state_playername_v2
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile4SpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=XPRACTICE.Config.Shriekwing.DeadlyDescentHorrifyTime-0.25		
		self.projectiledespawncustomduration=0.25
	end
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.player)then
			if(self.player.IsDeadInGame)then
				if(self.player:IsDeadInGame())then
					self.animationmodule:PlayOrContinueAnimation(XPRACTICE.AnimationList.Projectile4DespawnCustomDuration)
				end
			end
		end
	end
end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentTelegraph=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentTelegraph

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=XPRACTICE.Config.Shriekwing.DeadlyDescentTelegraphScale
		self.expirytime=self.environment.localtime+XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionTime
	end
	function class:SetActorAppearanceViaOwner(actor)		
		actor:SetModelByFileID(3621938) --9fx_raid1_gargoylebat_sonicwave_nova_raidlow
	end

	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(XPRACTICE.Config.Shriekwing.DeadlyDescentTracksPlayer)then
			if(self.targetobj)then			
				self.position={x=self.targetobj.position.x,y=self.targetobj.position.y,z=0}
			end
		end
	end
	
	function class:OnExpiry()
		super.OnExpiry(self)
		if(XPRACTICE.Config.Shriekwing.DeadlyDescentTracksPlayer)then
			if(self.targetobj)then			
				self.position={x=self.targetobj.position.x,y=self.targetobj.position.y,z=0}
			end		
		end

		local pounce=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentShriekwingPounce.new()
		pounce:Setup(self.environment,self.position.x,self.position.y,0)
		local yaw
		if(self.scenario.shriekwing)then
			yaw=math.atan2(self.position.y-self.scenario.shriekwing.position.y,self.position.x-self.scenario.shriekwing.position.x)
		else
			yaw=math.random()*math.pi*2
		end
		pounce.orientation_displayed.yaw=yaw
		local blood=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentBloodEffect.new()
		blood:Setup(self.environment,self.position.x,self.position.y,2)		
		
		--TODO LATER: looks like there should be a dust effect too
		local player=self.scenario.player
		if(player)then
			local distsqr=XPRACTICE.distsqr(self.scenario.player.position.x,self.scenario.player.position.y,self.position.x,self.position.y)
			local RADIUS=XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionRadius
			if(distsqr<=RADIUS*RADIUS)then
				local aura=self.scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,self.scenario.player.combatmodule,self.localtime)	
			end
		end
		local lantern=self.scenario.lantern
		if(lantern and (lantern.previouscarriermob==nil or lantern.previouscarriermob==self.scenario.player))then
			local lightcenterx,lightcentery
			if(lantern.carried)then
				lightcenterx=lantern.carriermob.position.x;lightcentery=lantern.carriermob.position.y
			else
				lightcenterx=lantern.position.x;lightcentery=lantern.position.y
			end
			local distsqr=XPRACTICE.distsqr(lightcenterx,lightcentery,self.position.x,self.position.y)
			local RADIUS=XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionRadius
			if(distsqr<=RADIUS*RADIUS)then
				self.scenario.lantern.carried=false
				self.scenario.lantern:Die()
				self.scenario.lantern=nil
				if(player)then
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.TERROROFCASTLENATHRIA.Aura_LanternBroken_Horrified,player.combatmodule,self.localtime)
					local feareffect=XPRACTICE.TERROROFCASTLENATHRIA.OverheadFearEffect.new()
					feareffect:Setup(self.environment,player.position.x,player.position.y,1)
					feareffect.projectileloopcustomduration=5.0-0.25
					feareffect.player=player
					player.scenario.statuslabel:SetText("The Blood Lantern shattered!",4.0)
				end
			end
		end
	end
end

do	
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentBloodEffect=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentBloodEffect

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=4.0
		self.expirytime=self.environment.localtime+0.5
		if(XPRACTICE.CVars.cvarvalues["violenceLevel"]=="0")then
			self.visiblefromallphases=false
			self.phase=-999	--TODO: more elegant solution
		end
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(165737)	-- bloodyexplosion
		--actor:SetModelByFileID(655752)	-- bloodyexplosion_glyphbloodier
	end
end

do	
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentShriekwingPounce=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentShriekwingPounce

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=2.0
		self.fadestarttime=self.environment.localtime+1.0
		self.expirytime=self.environment.localtime+2.0
	end
	function class:SetActorAppearanceViaOwner(actor)				
		actor:SetModelByCreatureDisplayID(97268)	-- gargoylebruteboss.m2 (Shriekwing)
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.Settle)
	end

end

do	
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.EnemyGhost=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.EnemyGhost

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=1.0
		self.fadestarttime=self.environment.localtime+XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionTime+0.0
		self.expirytime=self.environment.localtime+XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionTime+4.0
	end
	function class:SetActorAppearanceViaOwner(actor)				
		actor:SetModelByUnit("player")
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Cower)
	end
	function class:OnFadeStart()
		super.OnFadeStart(self)
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Death)
	end
end

do
	local super=XPRACTICE.Aura_Incapacitated
	XPRACTICE.TERROROFCASTLENATHRIA.Aura_LanternBroken_Horrified=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Aura_LanternBroken_Horrified
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
	end

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.animation=XPRACTICE.AnimationList.Cower		
		self.baseduration=5.0
	end
	
	function class:SetupNewauraLists(auramodule)
		super.SetupNewauraLists(self,auramodule)
		tinsert(self.auramodulelists,auramodule.animation)
		tinsert(self.auramodulelists,auramodule.lossofcontrolalert)
	end	
	
	function class:GetAnimation()
		return self.animation
	end
	function class:GetLOCAIcon()
		return "interface/icons/achievement_nazmir_boss_bloodofghuun.blp"
	end
	function class:GetLOCAText()
		return "Horrified"
	end	
	
	function class:OnExpiry()
		super.OnExpiry(self)
		local aura=self.targetcombat:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,self.targetcombat,self.targetcombat.mob.scenario.localtime)
	end
end