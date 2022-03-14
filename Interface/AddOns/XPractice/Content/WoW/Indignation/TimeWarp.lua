do

	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.TimeWarpEffect=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.TimeWarpEffect

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=1
		end
		
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileLoopCustomDuration)
			self.projectileloopcustomduration=1.625
			self.projectiledespawncustomduration=0.0
		end	

		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(430845)	-- mage_timewarp_impact_01
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(self.player)then
				self.position.x=self.player.position.x
				self.position.y=self.player.position.y
				self.position.z=self.player.position.z+2.5
			end
		end
	end
end