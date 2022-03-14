do
	local super=XPRACTICE.WoWObject
	XPRACTICE.SINSANDSUFFERING.SinProjectile=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.SinProjectile

	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(604834) -- chiwave_missile_hostile isn't the right model, but it's pretty close
		--actor:SetModelByFileID(2066489)
		--actor:SetModelByFileID(165724)
		self.scale=1
		self.alivetime=0
	end
	function class:Step(elapsed)
		super.Step(self,elapsed)
		

		local MAXTIME=0.75
		self.alivetime=self.alivetime+elapsed
		--TODO LATER: clean up logic
		if(self.alivetime>=MAXTIME)then
			self.velocity.z=0
			self.alivetime=MAXTIME
			if(not self.alreadyfadestarted)then
				self.fadestarttime=self.environment.localtime
				self.expirytime=self.environment.localtime+0.5
			end
		else
			--local GRAVITY=-25
			local GRAVITY=-15
			self.velocity.z=self.velocity.z+GRAVITY*elapsed			
		end

		local ratio=self.alivetime/MAXTIME
		self.position.x=self.startposition.x+(self.destination.x-self.startposition.x)*ratio
		self.position.y=self.startposition.y+(self.destination.y-self.startposition.y)*ratio
		--self.position.z=10*math.sin(ratio*math.pi)

	end

end



do
	local super=XPRACTICE.WoWObject
	XPRACTICE.SINSANDSUFFERING.SASTelegraph=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.SASTelegraph
	
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3642464) -- target_anima_revendreth_state
		self.scale=0.5
	end
	
	
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=0.125
		self.projectiledespawncustomduration=0.25
	end	
end