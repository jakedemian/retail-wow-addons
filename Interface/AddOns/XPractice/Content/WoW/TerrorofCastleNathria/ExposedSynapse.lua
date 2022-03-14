do
	local super=XPRACTICE.Mob
	XPRACTICE.TERROROFCASTLENATHRIA.ExposedSynapse=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.ExposedSynapse
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.phase=2
	end
	function class:SetActorAppearanceViaOwner(actor)
		--actor:SetModelByFileID(159578)	-- client crash!
		--actor:SetModelByFileID(531316)	--corruptedtentacle (Deathwing)
		--actor:SetModelByFileID(1366039)	--nightmaretentacle
		--actor:SetModelByFileID(3071318)	--nzothwormtentacle
		--actor:SetModelByFileID(3155386)	--voidetherealbosstentacle02
		actor:SetModelByFileID(1601821)	--voidetherealbosstentacle		
	end
	function class:SetFacepullRadiusViaOwner(ai)
		ai.facepullradius=30
	end
	
	----Voidetherealbosstentacle doesn't cooperate with telegraph circles, so we'll leave them out for now.  :(
	-- function class:CreateAssociatedObjects()
		-- local telegraph=XPRACTICE.TERROROFCASTLENATHRIA.ExposedSynapseTelegraph.new()
		-- telegraph:Setup(self.environment)
		-- telegraph.tentacle=self
	-- end
	
	
end

-- do
	-- local super=XPRACTICE.WoWObject
	-- XPRACTICE.TERROROFCASTLENATHRIA.ExposedSynapseTelegraph=XPRACTICE.inheritsFrom(super)
	-- local class=XPRACTICE.TERROROFCASTLENATHRIA.ExposedSynapseTelegraph
	-- function class:SetCustomInfo()
		-- super.SetCustomInfo(self)		
		-- self.phase=2
		-- self.scale=2
	-- end
	-- function class:SetActorAppearanceViaOwner(actor)
		-- actor:SetModelByFileID(2125936)	--cfx_warlock_genericportalvoid_notbillboarded_world 		
	
	-- end
	-- function class:Step(elapsed)
		-- super.Step(self,elapsed)
		-- self.position={x=self.tentacle.position.x,y=self.tentacle.position.y,z=self.tentacle.position.z}
	-- end	
-- end