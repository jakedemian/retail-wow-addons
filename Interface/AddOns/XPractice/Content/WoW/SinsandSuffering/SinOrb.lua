do
	local super=XPRACTICE.WoWObject
	XPRACTICE.SINSANDSUFFERING.SinOrb=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.SinOrb

	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3581780)	--9fx_raid1_sommelier_sharedsuffering_orb
		self.scale=2
		self.displayedpositionoffset={x=0.6,y=0,z=0}
	end
	
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=1.0
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=1.0
	end	
	
	function class:CreateAssociatedObjects()
		self.shadow=XPRACTICE.SINSANDSUFFERING.SinOrb_CosmeticShadow.new()
		self.shadow:Setup(self.environment,self.position.x,self.position.y,0.5)
		self.shadow.orb=self		
		tinsert(self.scenario.sinorb_cosmetics,self.shadow)
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.OrbTargetCircles)then
			self.circle=XPRACTICE.SINSANDSUFFERING.SinOrb_CosmeticCircle.new()
			self.circle:Setup(self.environment,self.position.x,self.position.y,1.0)
			self.circle.orb=self		
			tinsert(self.scenario.sinorb_cosmetics,self.circle)
		end
		
	end

end




do
	local super=XPRACTICE.WoWObject
	XPRACTICE.SINSANDSUFFERING.SinOrb_CosmeticShadow=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.SinOrb_CosmeticShadow
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=1
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=3.0
	end	

	function class:SetActorAppearanceViaOwner(actor)
		-- this is not the right model either
		actor:SetModelByFileID(1249924)	--7fx_ghost_red_state
		--actor:SetModelByFileID(1)
	end

end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.SINSANDSUFFERING.SinOrb_CosmeticCircle=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.SinOrb_CosmeticCircle
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=XPRACTICE_SAVEDATA.SINSANDSUFFERING.HitDetectOrbDistance*(3/12.0)		
		--print("Scale:",self.scale)
	end

	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.25
	end	

	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3642468)	-- target_anima_revendreth_state_rimonly				
	end

end