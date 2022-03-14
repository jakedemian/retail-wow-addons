do
	--TODO: volatile code reuse -- only use function in multiplayer/messagehandler.lua
	local function IsRealOfficer(unit)
		unit=strsplit("-",unit)
		return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
	end

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.PAINSMITH.Spell_Brez=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Spell_Brez
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Brez)"
			self.icon="interface/icons/inv_jewelry_talisman_06.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario	
			scenario:Brez()
		end
	end	
	

		
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.PAINSMITH.Spell_StopEncounter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Spell_StopEncounter 
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Stop encounter)"
			self.icon="interface/icons/spell_mage_altertime_active.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer.Send.UNLOCK(scenario.multiplayer)
		end
	end	
	
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.PAINSMITH.Spell_PallyBubble=XPRACTICE.inheritsFrom(super)
		
		local class=XPRACTICE.PAINSMITH.Spell_PallyBubble
			function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Bubble)"
			self.icon="interface/icons/spell_holy_divineshield.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)		
			-- targetcombat doesn't exist because this is a boss debug button.  use castercombat instead
				-- wait nvm we can't use castercombat because castercombat is spellbunny!
			local player=spellinstancepointer.castercombat.mob.scenario.player
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_LaserDebuff)
			for i=1,#auras do
				auras[i]:Die()
			end
			self.scenario.multiplayer:FormatAndSendCustom("PALLYBUBBLE")
		end
		
	--ghost.animationmodule:TryCompleteOmniSpellcast()	
	end	
	
	do
		local super=XPRACTICE.Aura
		XPRACTICE.PAINSMITH.Aura_PallyBubble = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Aura_PallyBubble

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.baseduration=5.0
			self.removeondeadingame=true			
			self.tickdelay=1.0
			self.basetickrate=1.0			
			self.tickcount=0
		end			
		function class:OnApply(localtime)
			super.OnApply(self,localtime)
			local player=self.targetcombat.mob
			player.animationmodule:TryCompleteOmniSpellcast()
			--player:CreateSpeechBubble("IMMUNE")	-- don't need to announce to other players here.  fatescribe was an exception.
			local visual=XPRACTICE.PAINSMITH.PallyBubbleVisual.new()
			visual:Setup(player.environment,player.position.x,player.position.y,player.position.z)
			visual.player=player
			self.visual=visual
			
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_LaserDebuff)
			for i=1,#auras do
				auras[i]:Die()
			end			
		end

		function class:Tick(ticktime)
			self:OnTick(ticktime,1.0)
			--!!!
			--TODO: move to base aura class
			self.previousticktime=ticktime
		end		
		function class:OnTick(ticktime,percentage)
			self.tickcount=self.tickcount+1
			if(self.tickcount>=2 and self.tickcount<=4)then
				local timer=5-self.tickcount
				if(self.targetcombat.mob.scenario)then
					if(self.targetcombat.mob==self.targetcombat.mob.scenario.player)then
						-- but it would still be useful to have a visible countdown for the player who bubbled
						self.targetcombat.mob:CreateSpeechBubble(tostring(timer)) 
					end
				end
			end
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.PallyBubbleVisual=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.PallyBubbleVisual
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1127086)	--cfx_paladin_divineshield_statebase
			self.scale=1.5
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.5
			self.projectileloopcustomduration=4.0
			self.projectiledespawncustomduration=2.0
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.position.x=self.player.position.x
			self.position.y=self.player.position.y
			self.position.z=self.player.position.z
			if(self.player:IsDeadInGame())then
				if(not self.toolate)then
					self.toolate=true
					self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
				end
			end
		end
	end	
	
	
	

end