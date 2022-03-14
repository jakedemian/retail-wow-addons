do

	XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList={}
	----XPRACTICE.AnimationTemplate.QuickSetup(animationlist,			name,		index,	subindex,	priority,	duration,	nextanimation)
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"-",5,	0,			"Active",	0.25,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"KelthIdle",51,		0,			"Idle",	1.0,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"SpellCastDirected",53,		0,			"Active",	1.0,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"SpellCastDirected_Phase3",124,		0,		"Active",	1.0,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"MagSpellPrecastBothChannel",900,		0,		"Active", nil,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"MagSpellPrecastBoth",898,		0,		"Active", 1.75,		XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBothChannel)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"MagSpellPrecastBoth_Phase3",898,		0,		"Active", .75,		XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBothChannel)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"KneelLoop",115,	0,							"Priority",	nil,nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList,"BattleRoar",55,	0,				"Active",	1.0,nil)

	do		
		local super=XPRACTICE.Mob
		XPRACTICE.KELTHUZADMULTIPLAYER.RemnantOfKELTHUZADMULTIPLAYER=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.RemnantOfKELTHUZADMULTIPLAYER
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.basemovespeed=14
			self.defaultspeechbubbleduration=4.0
		end
		
		function class:CreateCombatModule()
			super.CreateCombatModule(self)
			local spell=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_IceBeam.new()
			spell:Setup(self.combatmodule)
			self.combatmodule.spellbook.beam=spell
			local spell=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Pushback.new()
			spell:Setup(self.combatmodule)
			self.combatmodule.spellbook.push=spell
			local spell=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Tornadoes.new()
			spell:Setup(self.combatmodule)
			self.combatmodule.spellbook.cyclo=spell
			local spell=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_UndyingWrath.new()
			spell:Setup(self.combatmodule)
			self.combatmodule.spellbook.final=spell			
		end			

		function class:SetActorAppearanceViaOwner(actor)
			--if(self.scenario.currentphase<3)then
			if(XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.mobappearance<3)then
				actor:SetModelByCreatureDisplayID(101350) --Remnant of Kel'Thuzad (humanmale_hd.m2)
				self.scale=2
				self.alpha=1.0
			else
				actor:SetModelByCreatureDisplayID(15945) --Remnant of Kel'Thuzad (3rd intermission) (KELTHUZADMULTIPLAYER.m2) 
												-- this model has dry ice effects, which somehow don't show up in the real game
				self.scale=2
				self.alpha=0.5			-- decreasing alpha makes the dry ice effects less prominent			
			end
			
			actor:SetSpellVisualKit(100976) -- close-ish			

		end
		
		function class:PlayIdleAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.KelthIdle)
			--self.animationmodule:TryDirectedSpellcast()
		end
	end

	
end