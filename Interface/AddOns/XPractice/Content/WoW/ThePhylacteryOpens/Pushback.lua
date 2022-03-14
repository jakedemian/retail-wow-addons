do
	local PRECASTVISUALDISTANCE=6.0
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_PushbackMulti=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_PushbackMulti
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Foul Winds"			
			self.icon="interface/icons/ability_druid_astralstorm.blp"
			self.queuespellname="Pushback"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer:FormatAndSendCustom("QUEUE_PUSH")
		end
	end		
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Pushback = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Pushback
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Foul Winds"
			self.icon="interface/icons/ability_druid_astralstorm.blp"

			self.requiresfacing=false		
			self.projectileclass=nil		
			self.basecastduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackCastTime
			self.basechannelduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackDuration		
			self.basechannelticks=1
			self.tickonchannelstart=false
			self.usablewhilemoving=true
		end
		
		function class:Broadcast(scenario)
			local boss=scenario.boss
			scenario.multiplayer:FormatAndSendCustom("CAST_PUSH",angle)	
		end		
		
		function class:StartCastingEffect(spellinstancepointer)
			local boss=spellinstancepointer.castercombat.mob
			local scenario=boss.scenario
			
			-- --animation doesn't loop into itself, so we can't use CastingAnimationFunction
			-- if(scenario.currentphase==3)then
				-- boss.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth_Phase3)
			-- else
				-- boss.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth)
			-- end			
		end
		
		function class:CastingAnimationFunction(spellinstancepointer)	
			spellinstancepointer.castercombat.mob.animationmodule:TryOmniSpellcast()
			--spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth)
		end
		function class:ChannelingAnimationFunction(spellinstancepointer)		
			spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
		end
		function class:CompleteCastingAnimationFunction(spellinstancepointer)				
			spellinstancepointer.castercombat.mob.animationmodule:TryCompleteOmniSpellcast()
			-- local scenario=spellinstancepointer.castercombat.mob.scenario
			-- --if(scenario.currentphase==3)then
			-- if(false)then
				-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.SpellCastDirected_Phase3)
			-- else
				-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.SpellCastDirected)
			-- end
		end

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)							
			local visual=XPRACTICE.KELTHUZADMULTIPLAYER.PushbackVisual.new()
			visual:Setup(spellinstancepointer.castercombat.mob.environment)
			visual.scenario=spellinstancepointer.scenario
		end
	end
	
	
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PushbackVisual = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PushbackVisual
		
		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByFileID(2564475)	--8fx_jaina_frostzone_low	-- no
			--self.scale=5
			actor:SetModelByFileID(2399696)	--8fx_loacouncil_windradial_state	-- maybe
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackVisualScale
			self.alpha=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackVisualAlpha
			self.displayedpositionoffset={x=0,y=0,z=0}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.5
			self.projectileloopcustomduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackDuration-1.0
			self.projectiledespawncustomduration=0.5		
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)			
			self.alivetime=self.alivetime or 0
			self.alivetime=self.alivetime+elapsed
			--TODO: pushback here			
			for k,v in pairs(self.scenario.multiplayer.allplayers) do
				local player=v
				--local player=self.scenario.player
				--
				if(player.inphase and not player:IsDeadInGame())then
					local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
					if(not(#auras>0 and not auras[1].dying))then
						local auras2=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
						if(not(#auras2>0 and not auras2[1].dying))then
							local angle=math.atan2(player.position.y,player.position.x)
							--print(k,"angle:",angle)
							local startpbs=XPRACTICE.KELTHUZADMULTIPLAYER.Config.StartPushbackStrength
							local endpbs=XPRACTICE.KELTHUZADMULTIPLAYER.Config.EndPushbackStrength
							local multiplier=(endpbs-startpbs)*(self.alivetime/XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackDuration)+startpbs
							--print(multiplier)
							local force=7.0*multiplier
							player.position.x=player.position.x+math.cos(angle)*force*elapsed
							player.position.y=player.position.y+math.sin(angle)*force*elapsed						
						end
					end
				end
			end
			
		end
		function class:OnProjectileDespawned()
			super.OnProjectileDespawned(self)
			-- TODO: modify air speed
			--for k,v in pairs(scenario.multiplayer.allplayers) do
				--local player=v
				local player=self.scenario.player
				if(not player:IsDeadInGame())then
					local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
					if(not(#auras>0 and not auras[1].dying))then
						local auras2=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
						if(not(#auras2>0 and not auras2[1].dying))then
							if(player:IsInMidair())then
								local angle=math.atan2(player.position.y,player.position.x)
								local force=7.0*XPRACTICE.KELTHUZADMULTIPLAYER.Config.EndPushbackStrength
								player.velocity.x=player.velocity.x+math.cos(angle)*force
								player.velocity.y=player.velocity.y+math.sin(angle)*force
							end
						end
					end
				end
			--end
		end
	end
end