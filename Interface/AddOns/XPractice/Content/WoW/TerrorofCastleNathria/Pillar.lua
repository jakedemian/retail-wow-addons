do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.Pillar=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Pillar

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		local scalemodifier=1
		self.scale=XPRACTICE.Config.Shriekwing.PillarScale
		--self.scale=0.5
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3670323) --9fx_raid1_dredgerbrute_pillarexplosion_explosion		
	end
	function class:Step(elapsed)
		super.Step(self,elapsed)
	end
	
	--static!
	function class.GetHomePillarPosition()
		local xmod,ymod
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==2)then ymod=1 else ymod=-1 end
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==4)then xmod=-1 else xmod=1 end			
		local HZRADIUS=XPRACTICE.Config.Shriekwing.PillarEWDistance
		local VTRADIUS=XPRACTICE.Config.Shriekwing.PillarNSDistance
		return {x=HZRADIUS*xmod,y=VTRADIUS*ymod,z=0}
	end
end