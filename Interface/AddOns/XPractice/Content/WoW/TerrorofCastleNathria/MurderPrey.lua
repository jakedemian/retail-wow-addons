
do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.MurderPreyTelegraph=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.MurderPreyTelegraph
	
	--"within 12 yards"

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		--TODO: fine-tune scale?  at the moment, the very innermost edge of the circle is at 12 yards.
		self.scale=3*(XPRACTICE.Config.Shriekwing.MurderPreyRadius/12.0)+XPRACTICE.Config.Shriekwing.MurderPreyTelegraphAdjustment
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
		if(self.shriekwing)then
			self.position={x=self.shriekwing.position.x,y=self.shriekwing.position.y,z=self.shriekwing.position.z}
			local scenario=self.shriekwing.scenario
			local RADIUS=XPRACTICE.Config.Shriekwing.MurderPreyRadius
			local player=scenario.player
			if(player and not player:IsDeadInGame())then
				local distsqr=XPRACTICE.distsqr(self.position.x,self.position.y,player.position.x,player.position.y)
				if(distsqr<=RADIUS*RADIUS)then
					local blood=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentBloodEffect.new()
					blood:Setup(self.environment,player.position.x,player.position.y,2)	
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,scenario.localtime)
					local shriekwing=self.shriekwing
					local angle=math.atan2(player.position.y-shriekwing.position.y,player.position.x-shriekwing.position.x)
					player.velocity.x=math.cos(angle)*28
					player.velocity.y=math.sin(angle)*28
					player.velocity.z=8		
				end
			end
		end
	end
end

