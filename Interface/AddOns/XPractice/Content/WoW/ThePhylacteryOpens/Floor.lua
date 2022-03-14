do

	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.Floor=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Floor
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(996287)	--scale_obj_cylinder_004
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaCylinderScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaCylinderZOffset}
		end		
	end
	
	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.ExitPortal=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.ExitPortal
		
		function class:SetActorAppearanceViaOwner(actor)
			----actor:SetModelByFileID(234780)	--portalbluearcane
			--actor:SetModelByFileID(1002630)	--portalblueshadow
			--self.scale=1			
			actor:SetModelByFileID(3447640)	--8fx_generic_necromancy_marker
			--self.scale=0.5
			self.scale=0.3
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=1.0
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=1.0
		end			
	end


	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.EntrancePortal=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.EntrancePortal
		
		function class:SetActorAppearanceViaOwner(actor)	
			actor:SetModelByFileID(3447640)	--8fx_generic_necromancy_marker
			self.scale=1.0
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=1.0
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=1.0
		end			
	end
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.KTEntranceVisual=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.KTEntranceVisual
		
		function class:SetActorAppearanceViaOwner(actor)	
			actor:SetModelByCreatureDisplayID(96238)	--KT
			actor:SetSpellVisualKit(100976)
			self.scale=3.0
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=1.0
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=1.0
		end			
	end	
	

end