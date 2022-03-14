do
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_SinisterReflection=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_SinisterReflection
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Sinister Reflection"
			self.icon="interface/icons/spell_shadow_charm.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=3.0
			self.basechannelticks=3
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			--print("castendtime",castendtime)
			local mob=spellinstancepointer.castercombat.mob
			local message=""
			local i=math.floor(math.random()*2)+1
			if(i==1)then
				message="My reign is everlasting!"
			elseif(i==2)then
				message="Fools! I am Revendreth!"
			end
			mob:CreateSpeechBubble("\124cffff3f40"..message.."\124r")
		end
		function class:ChannelingAnimationFunction(spellinstancepointer)	
			-- can't find this animation... channelcastdirected is close enough
			spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ChannelCastDirected)
		end
		function class:OnChannelTick(spellinstancepointer,tickcount)
			if(tickcount==1)then
				local reflection=XPRACTICE.INDIGNATION.DenathriusReflection.new()
				reflection:Setup(self.scenario.game.environment_gameplay,0,0,0)
				reflection.scenario=self.scenario
				self.scenario.ravagecontroller.reflection=reflection
				local angle=-math.pi/6+(math.pi*2/3)*self.scenario.ravagecount
				reflection:FreezeOrientation(angle)
			end
		end
		function class:CompleteChannelingEffect(castendtime,spellinstancepointer)	
			--self.scenario.ravagecontroller:Precast()	-- moved to Reflection mob
			--self.scenario.massacrecontroller:Activate()
		end
	end
	
	do
		local super=XPRACTICE.Mob
		XPRACTICE.INDIGNATION.DenathriusReflection=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.DenathriusReflection

		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)
			self.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.ShaSpellPrecastBoth)			
		end
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=3			
					--2.0 from spawn until channel ends
					--[config.RRD] from channel end until ravager cast
					--5.75 after ravager cast
			self.fadestarttime=self.environment.localtime+5.75+2.0+XPRACTICE.Config.Indignation.RavageReflectionDelay
			self.expirytime=self.fadestarttime+0.9
			self.state=0
			self.alivetime=0
		end
		function class:SetActorAppearanceViaOwner(actor)			
			actor:SetModelByCreatureDisplayID(96951)
			actor:SetSpellVisualKit(131725)			
		end
		function class:PlayIdleAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ChannelCastDirected)
		end
		function class:Step(elapsed)		
			super.Step(self,elapsed)
			self.alivetime=self.alivetime+elapsed
			if(self.state==0)then
				if(self.alivetime>=2.0+XPRACTICE.Config.Indignation.MassacreReflectionDelay)then
					self.scenario.massacrecontroller:Activate()
					self.state=self.state+1
				end
			elseif(self.state==1)then
				if(self.alivetime>=2.0+XPRACTICE.Config.Indignation.RavageReflectionDelay)then
					self.scenario.ravagecontroller:Precast()
					self.state=self.state+1
				end
			end
			if(self.scenario.bossdead)then
				if(self.fadestarttime>self.environment.localtime)then
					self.fadestarttime=self.environment.localtime+0
					self.expirytime=self.fadestarttime+0.9
				end
			end
		end
		
		function class:OnFadeStart()
			--print("fadestart",self.environment.localtime)
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.CombatAbility2H02)
			local event={}
			event.time=self.scenario.game.environment_gameplay.localtime+.25
			event.func=function(scenario)
					if(not self.scenario.bossdead and self.scenario.ravagecount<2)then
						scenario.ravagecontroller:Activate()
					end
				end
			event.alwayshappens=true
			tinsert(self.scenario.events,event)
		end
	end
	
end