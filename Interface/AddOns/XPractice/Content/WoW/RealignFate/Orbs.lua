local PH=1

do
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.Orb=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Orb
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.alivetime=0
			self.state=0
			self.active=false
			self.despawning=false
			self.graceperiodendtime=0			
		end
	
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4058682) --9fx_generic_anima_maw_orb (127,158,159)
			self.scale=1.75
			self.displayedpositionoffset={x=0,y=0,z=1.5}
		end
	
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2SpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end	
		
		function class:OnProjectileDespawning()
			self.despawning=true
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(self.state==0)then
				self.alivetime=self.alivetime+elapsed
				if(self.alivetime>=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbMovementDelay)then
					self.velocity.x=math.cos(self.angle)*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpeed
					self.velocity.y=math.sin(self.angle)*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpeed
					self.state=self.state+1
				end
			end
		end
	
	end

	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawnerController=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawnerController
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.angle=0
			self.spawners={}
			self.active=false
			self.spawntimer=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnRate
			self.graceperiodendtime=0
			self.nextid=2
		end
		
		function class:Activate()
			self.nextid=2 --!!!
			if(self.active)then return end
			self.active=true
			for i=1,XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerCount do
				local spawner=XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawner.new()
				local angle=self.angle+(math.pi*2)*(i/XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerCount)
				spawner:Setup(self.environment)				
				spawner.position.x=math.cos(angle)*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerDistance
				spawner.position.y=math.sin(angle)*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerDistance
				spawner.shadow.position.x=spawner.position.x
				spawner.shadow.position.y=spawner.position.y
				spawner.scenario=self.scenario
				tinsert(self.spawners,spawner)
				self.spawntimer=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnRate
			end
			self.graceperiodendtime=self.environment.localtime+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerGracePeriod
		end
		
		function class:SetAngle(angle)
			self.angle=angle
		end

		function class:Deactivate()
			if(not self.active)then return end
			self.active=false
			for i=1,#self.spawners do
				local spawner=self.spawners[i]
				spawner.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
				spawner.shadow.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
			self.spawners={}
		end

		function class:Step(elapsed)			
			super.Step(self,elapsed)
			self.angle=self.angle+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerSpeed*elapsed
			if(#self.spawners>0)then
				for i=1,#self.spawners do
					local spawner=self.spawners[i]
					local angle=self.angle+(math.pi*2)*(i/#self.spawners)
					spawner.position.x=math.cos(angle)*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerDistance
					spawner.position.y=math.sin(angle)*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerDistance
					spawner.shadow.position.x=spawner.position.x
					spawner.shadow.position.y=spawner.position.y
				end
				self.spawntimer=self.spawntimer-elapsed
				if(self.spawntimer<=0)then
					self.spawntimer=self.spawntimer+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnRate
					for i=1,#self.spawners do
						local spawner=self.spawners[i]
						local angle=self.angle+(math.pi*2)*(i/#self.spawners)
						local orb=XPRACTICE.FATESCRIBEMULTIPLAYER.Orb.new()
						orb:Setup(self.environment)
						orb.position.x=spawner.position.x
						orb.position.y=spawner.position.y
						orb.angle=angle+math.pi
						local totaltime=(XPRACTICE.FATESCRIBEMULTIPLAYER.Config.ArenaRadius+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerDistance)/XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpeed
						totaltime=totaltime+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbMovementDelay
						orb.projectileloopcustomduration=totaltime
						orb.scenario=self.scenario
						tinsert(self.scenario.orbs,orb)
						orb.id=self.nextid
						self.nextid=self.nextid+1
						if(self.nextid>9999)then self.nextid=2 end
						
					end
				end
			end
		end
	end


	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawner=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawner
	
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3815672) --9fx_generic_soul_channelhand	-- not exact, but pretty close  
														-- (0,158,159)	
														-- animations don't appear to work; use alpha instead?
			self.scale=2.5
			self.alpha=0.25
			self.displayedpositionoffset={x=0,y=0,z=1.5}
		end

		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end	
		
		function class:CreateAssociatedObjects()
			self.shadow=XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawnerShadow.new()
			self.shadow:Setup(self.environment)
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.shadow.position={x=self.position.x,y=self.position.y,z=0}
		end
	end

	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawnerShadow=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawnerShadow
	
		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByFileID(3621952) --target_anima_maw_state_centeronly
			actor:SetModelByFileID(3622767) --target_anima_maw_state	-- best we could find on short notice							
														-- (0,158,159)	
													--maybe use 9fx_generic_spotlight_base01 ?
			--self.scale=0.5
			self.scale=1.0
			self.alpha=1
			self.displayedpositionoffset={x=0,y=0,z=0}
		end

		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end	
		

	end


	do
		--TODO: add aura snare category in core folder
		local super=XPRACTICE.Aura_SpeedBoost
		XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.baseduration=7.000	
			--TODO: force walking animation below a certain speed
			self.multiplier=1-.33
		end		
		--TODO: oops this should be baseline in SpeedBoost
		function class:SetupNewauraLists(auramodule)
			super.SetupNewauraLists(self,auramodule)
			tinsert(self.auramodulelists,auramodule.speedboost)
		end	
	end

end