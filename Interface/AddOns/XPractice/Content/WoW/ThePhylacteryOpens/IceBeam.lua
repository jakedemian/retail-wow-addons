do
	local PRECASTVISUALDISTANCE=6.0
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_IceBeamMulti=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_IceBeamMulti
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Freezing Blast"			
			self.icon="interface/icons/ability_mage_waterjet.blp"
			self.queuespellname="IceBeam"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer:FormatAndSendCustom("QUEUE_BEAM")
		end
	end	
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_IceBeam = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_IceBeam
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Freezing Blast"
			self.icon="interface/icons/ability_mage_waterjet.blp"

			self.requiresfacing=false		
			self.projectileclass=nil		
			self.basecastduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamCastTime
			self.basechannelduration=nil		
			self.basechannelticks=nil
			self.tickonchannelstart=false
			self.usablewhilemoving=true
		end
		
		function class:Broadcast(scenario)
			local boss=scenario.boss
			local allplayers=scenario.multiplayer.allplayers
			local players={}
			local player=nil
			for k,v in pairs(allplayers) do
				local player=v
				if(player.inphase and not player:IsDeadInGame())then
					tinsert(players,player)
				end				
			end
			if(#players>0)then
				local i=math.floor(math.random()*#players)+1
				player=players[i]
			end
			local angle=boss.orientation.yaw
			if(scenario.currentphase<3)then
				angle=angle-XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamBossAngleOffset
			else
				angle=angle-XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamBossAngleOffsetPhase3
			end
			if(player)then
				if(player~=scenario.player and player.ai.targetposition)then
					angle=math.atan2(player.ai.targetposition.y-boss.position.y,player.ai.targetposition.x-boss.position.x)
				else
					angle=math.atan2(player.position.y-boss.position.y,player.position.x-boss.position.x)
				end				
			end			
			scenario.multiplayer:FormatAndSendCustom("CAST_BEAM",angle)	
		end
		
		function class:StartCastingEffect(spellinstancepointer)
			local boss=spellinstancepointer.castercombat.mob
			local scenario=boss.scenario
			local allplayers=scenario.allplayers
			local players={}
			local player=nil
			local angle=spellinstancepointer.savedangle
			local bossangle
			if(scenario.currentphase<3)then
				bossangle=angle+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamBossAngleOffset
			else
				bossangle=angle+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamBossAngleOffsetPhase3
			end			
			boss.orientation.yaw=bossangle
		
			
			local visual=XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamPrecastVisual.new()
			visual:Setup(boss.environment)
			visual.position={x=PRECASTVISUALDISTANCE,y=0,z=0}
			visual.boss=boss
			visual.angle=angle
			visual.scenario=scenario
			
			--animation doesn't loop into itself, so we can't use CastingAnimationFunction
			if(scenario.currentphase==3)then
				boss.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth_Phase3)
			else
				boss.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth)
			end
			
		end
		
		-- function class:CastingAnimationFunction(spellinstancepointer)	
			-- --spellinstancepointer.castercombat.mob.animationmodule:TryDirectedSpellcast()
			-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth)
		-- end
		-- function class:ChannelingAnimationFunction(spellinstancepointer)				
			-- spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
		-- end
		function class:CompleteCastingAnimationFunction(spellinstancepointer)				
			local scenario=spellinstancepointer.castercombat.mob.scenario
			--if(scenario.currentphase==3)then
			if(false)then
				spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.SpellCastDirected_Phase3)
			else
				spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.SpellCastDirected)
			end
		end

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)							
		
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamPrecastVisual = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamPrecastVisual 
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(2491554)	--8fx_jaina_glacialray_precast (0,158,159)			
			self.scale=1.5
			self.displayedpositionoffset={x=0,y=0,z=3}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=2.0
			self.projectileloopcustomduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamCastTime-2.0
			self.projectiledespawncustomduration=0.5		
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)			
			self.position.x=math.cos(self.angle)*PRECASTVISUALDISTANCE
			self.position.y=math.sin(self.angle)*PRECASTVISUALDISTANCE
			self.orientation_displayed.yaw=self.angle
		end
		function class:OnProjectileDespawning()
			super.OnProjectileDespawning(self)
			--local scenario=spellinstancepointer.castercombat.mob.scenario
			for i=1,3 do
				local dist=4+(i-1)*8
				local angle=self.angle
				local swirl=XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamSwirl.new()
				swirl:Setup(self.environment)
				swirl.position.x=math.cos(angle)*dist
				swirl.position.y=math.sin(angle)*dist
				--swirl.projectileloopcustomduration=0.25*(i-1)
				swirl.projectileloopcustomduration=0.2*(i-1)
				swirl.scenario=self.scenario
			end
			
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamSwirl=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamSwirl
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1034199)	--target_frost_state_centeronly (0,158,159)			
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamSwirlScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZOffset}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.2
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25		
		end	
		function class:OnProjectileDespawning()
			super.OnProjectileDespawning(self)
			local expl=XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamSwirlExplosion.new()
			expl:Setup(self.environment,self.position.x,self.position.y,0)
			
			
			local player=self.scenario.player
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
			if(#auras>0)then return end
			if(not player:IsDeadInGame())then				
				local xdist=player.position.x-self.position.x
				local ydist=player.position.y-self.position.y
				local distsqr=xdist*xdist+ydist*ydist
				if(distsqr<=XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRadius*XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRadius)then
					local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
					if(#auras>0 and not auras[1].dying)then
						local newexpiry=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRootDuration
						if(newexpiry>auras[1].expirytime)then auras[1].expirytime=newexpiry end
					else
						local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze,player.combatmodule,player.environment.localtime)
						aura.expirytime=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRootDuration
						player.velocity.x=0;player.velocity.y=0
						--print(aura.expirytime,player.environment.localtime,aura.dead)	--TODO: why does visual despawn immediately??
						local visual=XPRACTICE.KELTHUZADMULTIPLAYER.FreezeVisualEffect.new()
						visual:Setup(player.environment,player.position.x,player.position.y,0)
						visual.player=player
						visual.orientation_displayed.yaw=player.orientation.yaw						
						self.scenario.statuslabel:SetText("Frozen by Freezing Blast.",3.0)						
					end
					self.scenario.multiplayer:FormatAndSendCustom("FREEZE_BEAM",player.position.x,player.position.y)
				end
			end
		end	
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamSwirlExplosion=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.IceBeamSwirlExplosion
		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByFileID(4025148)	--9fx_raid2_KELTHUZADMULTIPLAYER_frostblast	-- no
			--actor:SetModelByFileID(916376)	--explosion_frost_impact			-- meh
			actor:SetModelByFileID(2497791)	--8fx_jaina_novalow_impactworld		-- close enough for now
			
			self.scale=1.25
		end
		function class:SetDefaultAnimation()
			-- self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			-- self.projectilespawncustomduration=0.25
			-- self.projectileloopcustomduration=nil
			-- self.projectiledespawncustomduration=0.25	
			self.expirytime=self.environment.localtime+1.0
		end	
	end
	
end