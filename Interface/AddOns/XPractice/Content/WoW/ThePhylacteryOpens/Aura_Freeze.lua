do
	local super=XPRACTICE.Aura
	XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.animation=XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.KneelLoop
		self.baseduration=4.0
		self.locaicon="interface/icons/ability_mage_waterjet.blp"
	end
	
	function class:SetupNewauraLists(auramodule)
		super.SetupNewauraLists(self,auramodule)
		tinsert(self.auramodulelists,auramodule.animation)
		tinsert(self.auramodulelists,auramodule.incapacitated)
		tinsert(self.auramodulelists,auramodule.lossofcontrolalert)
	end	
	
	function class:GetAnimation()
		return self.animation
	end
	function class:GetLOCAIcon()
		return self.locaicon
	end
	function class:GetLOCAText()
		return "Rooted"
	end	
end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.KELTHUZADMULTIPLAYER.FreezeVisualEffect=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.FreezeVisualEffect
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2497792) -- 8fx_jaina_rootedstate (0,158,159)
		self.scale=1.0
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.25		
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		if(self.state==nil)then
			self.aliveframes=self.aliveframes or 0
			self.aliveframes=self.aliveframes+1
			if(self.aliveframes>2)then
				local auras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
				if(#auras==0)then
					self.state=1
					self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
					--print("DESPAWN VISUAL")
				else
					self.position.x=self.player.position.x
					self.position.y=self.player.position.y
					self.position.z=0
					self.orientation_displayed.yaw=self.player.orientation.yaw
				end
			end
		end
	end
end