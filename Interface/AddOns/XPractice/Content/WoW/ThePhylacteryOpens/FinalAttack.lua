do

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_UndyingWrathMulti=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_UndyingWrathMulti
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Undying Wrath"		
			self.icon="interface/icons/spell_shadow_requiem.blp"
			self.queuespellname="UndyingWrath"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario	

			scenario.multiplayer:FormatAndSendCustom("QUEUE_FINAL")
		end
	end		

	local super=XPRACTICE.Spell
	XPRACTICE.KELTHUZADMULTIPLAYER.Spell_UndyingWrath = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_UndyingWrath
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Undying Wrath"
		self.icon="interface/icons/spell_shadow_requiem.blp"
		self.requiresfacing=false;
		self.projectileclass=nil;
		self.basecastduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseEndCastTime
		self.basechannelduration=nil;
		self.basechannelticks=nil;
		self.tickonchannelstart=false;
		self.usablewhilemoving=true
		--self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0;self.basechannelduration=nil;self.basechannelticks=nil;self.tickonchannelstart=false;self.usablewhilemoving=true
	end
	
	function class:Broadcast(scenario)
		scenario.multiplayer:FormatAndSendCustom("CAST_FINAL")
	end		

	function class:StartCastingEffect(spellinstancepointer)
		spellinstancepointer.scenario.exitportallocked=false
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
	end

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)							
		--local visual=XPRACTICE.KELTHUZADMULTIPLAYER.FinalAttackVisual.new()
		--visual:Setup(spellinstancepointer.castercombat.mob.environment)
		--visual.scenario=self.scenario
		
		local player=spellinstancepointer.scenario.player
		if(player.inphase)then
			if(not player:IsDeadInGame())then				
				-- pally bubble can't save you here
				--apply aura BEFORE player velocity; aura is hardcoded to 0 x/y upon application
				local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)
				local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced,player.combatmodule,player.environment.localtime)
				aura.scenario=spellinstancepointer.scenario
				player.velocity.z=15
				local xyvelocity=12
				local angle=math.atan2(player.position.y,player.position.x)
				player.velocity.x=math.cos(angle)*xyvelocity
				player.velocity.y=math.sin(angle)*xyvelocity
				spellinstancepointer.scenario.statuslabel:SetText("Died from Undying Wrath.",3.0)
				spellinstancepointer.scenario.multiplayer:FormatAndSendCustom("DEAD_WRATH")
				
			end
		end
		spellinstancepointer.scenario.exitportallocked=true
	end	
	
	-- maybe use nova_wind_raid_low as a placeholder visual (no animation)
end