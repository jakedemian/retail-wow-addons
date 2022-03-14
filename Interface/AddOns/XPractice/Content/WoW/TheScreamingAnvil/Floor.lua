do

	
	do	
		local super=XPRACTICE.MultiSolid
		XPRACTICE.PAINSMITH.Floor=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Floor
		
		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)
			for xx=1,13 do
				for yy=1,13 do
					local x=XPRACTICE.PAINSMITH.Config.ArenaTileSize*(xx+0.5)
					local y=XPRACTICE.PAINSMITH.Config.ArenaTileSize*(yy+0.5)
					--local a=self:AddActorByClass(XPRACTICE.SOLIDS.Box001Gray,x,y,XPRACTICE.PAINSMITH.Config.ArenaCubeZOffset,XPRACTICE.PAINSMITH.Config.ArenaCubeScale,0)
					local a=self:AddActorByClass(XPRACTICE.SOLIDS.Box001Red,x,y,XPRACTICE.PAINSMITH.Config.ArenaCubeZOffset,XPRACTICE.PAINSMITH.Config.ArenaCubeScale,0)
					
					--a:SetSpellVisualKit(8473)
					a:SetSpellVisualKit(6526)
				end
			end
		end
		

	end
	
	
	

end