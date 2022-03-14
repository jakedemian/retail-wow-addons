
do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_EndPhase=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_EndPhase


	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="End Intermission"
		self.icon="interface/buttons/ui-stopbutton.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	

		self.basecastduration=1.5
		self.basechannelduration=nil
	end
	
	function class:StartCastingEffect(spellinstancepointer)	
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.displayobject.customboundingbox=nil
		if(shriekwing.murderpreytelegraph)then
			shriekwing.murderpreytelegraph.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			shriekwing.murderpreytelegraph=nil
		end
		local scenario=shriekwing.scenario
		for i=1,#scenario.sonars do
			local sonar=scenario.sonars[i]
			sonar.fadestarttime=shriekwing.environment.localtime
			sonar.expirytime=shriekwing.environment.localtime+0.5
			--scenario.sonars[i]:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		end
		scenario.sonars={}
	end
	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
		local shriekwing=spellinstancepointer.castercombat.mob
		local scenario=shriekwing.scenario
		scenario.phaseinprogress=false
		if(shriekwing.targetable==false)then
			shriekwing.targetable=true
			local nameplate=XPRACTICE.Nameplate.new()
			nameplate:Setup(shriekwing.environment,shriekwing)
			nameplate:SetText("Shriekwing")
			local castingbar=XPRACTICE.CastingBarTiny.new()
			castingbar:Setup(shriekwing.environment,0,0,0)
			castingbar.focus=shriekwing
			castingbar:AnchorToNameplate(nameplate)		
		end	
		if(scenario.player and (not scenario.player:IsDeadInGame()) and (not scenario.player:IsIncapacitated()))then
			if(scenario.adjustdifficultysuggestion)then
				scenario.adjustdifficultysuggestion=false
				scenario.statuslabel:SetText("If that was too easy, you can make the scenario more difficult in the Advanced Options menu.",5.0)
			end
		end
		
	end



end
