do
	local CRESCENDO_WARNINGDELAY=0.0
	local CRESCENDO_SWIRLDELAY=2.0
	local CRESCENDO_IMPACTDELAY=2.0 --added to swirldelay
	local CRESCENDO_RADIUS=3.0	--supposed to be 2.5
	local CRESCENDO_SECONDTELEGRAPHDELAY=0.0
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Crescendo=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Crescendo
		
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Crescendo"
			self.icon="interface/icons/spell_animarevendreth_missile.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local manager=XPRACTICE.INDIGNATION.CrescendoManager.new()
			manager:Setup(self.scenario.game.environment_gameplay)
			manager.scenario=self.scenario
			manager.sourcemob=spellinstancepointer.castercombat.mob
		end
		function class:OnChannelTick(spellinstancepointer,tickcount)
		end
	end


	do
		local super=XPRACTICE.GameObject
		XPRACTICE.INDIGNATION.CrescendoManager=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.CrescendoManager
		
		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)
			self.alivetime=0
			self.state=1
		end
		
		function class:Step(elapsed)			
			super.Step(self,elapsed)			
			self.alivetime=self.alivetime+elapsed
			
			local scenario=self.scenario
			if(self.state==1)then
				--maybe raidwarning goes here
				self.state=self.state+1				
			elseif(self.state==2)then
				if(self.alivetime>=CRESCENDO_SWIRLDELAY)then
					--XPRACTICE_RaidBossEmote("DODGE CRESCENDO",2.0,true)
					--XPRACTICE_RaidBossEmote("FEET",2.0,true)
					for i=1,#scenario.allplayers do
					local ghost=scenario.allplayers[i]
						if(not ghost:IsDeadInGame())then
							local telegraph
							if(self.sourcemob~=scenario.denathrius)then
								telegraph=XPRACTICE.INDIGNATION.CrescendoTelegraph.new()
							else
								telegraph=XPRACTICE.INDIGNATION.CrescendoTelegraphGuaranteedDoom.new()
							end
							telegraph:Setup(scenario.game.environment_gameplay,ghost.position.x,ghost.position.y,0)
							telegraph.scenario=scenario
							if(self.sourcemob~=scenario.denathrius)then
								telegraph.sourcex=self.sourcemob.position.x
								telegraph.sourcey=self.sourcemob.position.y
							else
								telegraph.sourcex=0
								telegraph.sourcey=0
							end
							
							local projectile=XPRACTICE.INDIGNATION.CrescendoProjectile.new()
							projectile:Setup(scenario.game.environment_gameplay,self.sourcemob.position.x,self.sourcemob.position.y,0)
							projectile.startposition={x=self.sourcemob.position.x,y=self.sourcemob.position.y}
							projectile.destination={x=ghost.position.x,y=ghost.position.y}
							
						end
					end
					self.state=self.state+1					
				end
			elseif(self.state==3)then
				if(self.alivetime>=CRESCENDO_SWIRLDELAY+CRESCENDO_IMPACTDELAY)then
					self.state=self.state+1
					
				end
			elseif(self.state==4)then
				self:Die()
			end			
		end		
	end

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.CrescendoTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.CrescendoTelegraph

		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			--self.scale=CRESCENDO_RADIUS*(3/12.0)
			self.scale=CRESCENDO_RADIUS*(4/12.0)
			--self.expirytime=self.environment.localtime+CRESCENDO_IMPACTDELAY		-- is this causing ProjectileDespawning to fail?
			self.alivetime=0	
			self.state=1			
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3642466)	--spells/target_anima_revendreth_state_centeronly
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=CRESCENDO_IMPACTDELAY-0.25
			self.projectiledespawncustomduration=0.25		
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.alivetime=self.alivetime+elapsed			
			if(self.state==1 and self.alivetime>=CRESCENDO_SECONDTELEGRAPHDELAY)then
				if(self.scenario.player.mirrorrealm)then
					local telegraph=XPRACTICE.INDIGNATION.CrescendoExtraTelegraph.new()
					telegraph:Setup(self.environment,self.position.x,self.position.y,0.1)
				end
				self.state=self.state+1
			end
		end
		

		
		function class:OnProjectileDespawning()
			super.OnProjectileDespawning(self)
			local scenario=self.scenario
			local player=scenario.player
			--TODO: seems to miss sometimes.			
			if(player)then				
				if(not player:IsDeadInGame())then
					local distsqr=XPRACTICE.distsqr(player.position.x,player.position.y,self.position.x,self.position.y)
					if(distsqr<=CRESCENDO_RADIUS*CRESCENDO_RADIUS)then
						local angle=math.atan2(player.position.y-self.sourcey,player.position.x-self.sourcex)
						player.velocity.z=80*(1/10)
						local xyvelocity=200*(1/10)
						player.velocity.x=math.cos(angle)*xyvelocity
						player.velocity.y=math.sin(angle)*xyvelocity						
						if(player.position.z<=1)then player.position.z=1 end
					end
				end
			end
		end
	end

	do
		local super=XPRACTICE.INDIGNATION.CrescendoTelegraph
		XPRACTICE.INDIGNATION.CrescendoTelegraphGuaranteedDoom=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.CrescendoTelegraphGuaranteedDoom

		function class:OnProjectileDespawning()
			XPRACTICE.WoWObject.OnProjectileDespawning(self)	-- skip the non-guaranteed doom function and jump straight to WoWObject!
			local scenario=self.scenario
			local player=scenario.player
			--print("player:",player)
			if(player)then
				--print("dead:",player:IsDeadInGame())
				if(not player:IsDeadInGame())then
					local distsqr=XPRACTICE.distsqr(player.position.x,player.position.y,self.position.x,self.position.y)
					--print("Crescendo check:",distsqr)
					if(distsqr<=CRESCENDO_RADIUS*CRESCENDO_RADIUS)then
						--southwest corner
						
						local xdist=-33-player.position.x
						local ydist=-33-player.position.y
						local angle=math.atan2(ydist,xdist)
						local dist=math.sqrt(xdist*xdist+ydist*ydist)
						local xyvelocity=dist/2.0
						if(player.position.z<=1)then player.position.z=1 end
						player.velocity.z=25
						player.velocity.x=math.cos(angle)*xyvelocity
						player.velocity.y=math.sin(angle)*xyvelocity		
						self.scenario.hitbysurprisefinalattack=true
						self.scenario.player.portaldebuff=true
						
						--if(not self.scenario.wipereason)then self.scenario.wipereason="Celebrated too soon." end
						self.scenario.wipereason="Celebrated too soon."
					end
				end
			end
		end
	end

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.CrescendoExtraTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.CrescendoExtraTelegraph

		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.scale=CRESCENDO_RADIUS*1.1*(3/12.0)			
			--self.expirytime=self.environment.localtime+CRESCENDO_IMPACTDELAY			
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1034184)	--spells/target_fire_state_centeronly
			--actor:SetModelByFileID(2958722)	--spells/target_spark_state_centeronly
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=CRESCENDO_IMPACTDELAY-0.25-CRESCENDO_SECONDTELEGRAPHDELAY
			self.projectiledespawncustomduration=0.25		
		end	
	end

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.CrescendoProjectile=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.CrescendoProjectile

		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(604834) -- chiwave_missile_hostile isn't the right model, but it's pretty close
			self.scale=1
			self.alivetime=0
			self.velocity.z=15
		end
		function class:Step(elapsed)
			super.Step(self,elapsed)
			

			local MAXTIME=2
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
		local super=XPRACTICE.Mob
		XPRACTICE.INDIGNATION.CrimsonCabalist=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.CrimsonCabalist

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=1.5

			--self.alpha=0  -- if invisible bunny
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByCreatureDisplayID(93611)	
		end
		function class:PlayIdleAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ChannelCastOmni)
		end
	end


end