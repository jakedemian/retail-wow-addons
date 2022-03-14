do
	--there's some trickery going on where the effects are visibly 3 seconds but they really last 3.5
	-- 	and the animation doesn't really line up either.  this was an acceptable compromise
	local BLOODPRICE_KNOCKBACK_DELAY=0.25
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_BloodPrice=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_BloodPrice
		

		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Blood Price"
			self.icon="interface/icons/ability_ironmaidens_whirlofblood.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=1.5
			self.basechannelduration=3.25
			self.basechannelticks=1
			--self.tickonchannelstart=true
		end

		function class:CastingAnimationFunction(spellinstancepointer)	
			spellinstancepointer.castercombat.mob.animationmodule:TryOmniSpellcast()
		end
		function class:ChannelingAnimationFunction(spellinstancepointer)				
			spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
		end
		function class:CompleteChannelingAnimationFunction(spellinstancepointer)				
			spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.AnimationList.CastOutStrong)
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=self.scenario
			--scenario.denathrius:FaceTowardsTank1()
			local message=""
			local i=math.floor(math.random()*4)+1
			if(i==1)then
				message="Shadows consume you!"
			elseif(i==2)then
				message="You will all die at my feet!"
			elseif(i==3)then
				message="None will survive!"
			elseif(i==4)then
				message="You will perish together!"
			end
			scenario.denathrius:CreateSpeechBubble("\124cffff3f40"..message.."\124r")
			for i=1,#scenario.allplayers do
				local ghost=scenario.allplayers[i]
				if(not ghost:IsDeadInGame())then
					ghost.combatmodule:ApplyAuraByClass(XPRACTICE.INDIGNATION.Aura_BloodPrice,self.castercombat,ghost.scenario.localtime)
				end
			end
		end
		
		
		function class:CompleteChannelingEffect(channelendtime,spellinstancepointer)
			local event={}
			event.time=self.scenario.game.environment_gameplay.localtime+BLOODPRICE_KNOCKBACK_DELAY
			event.func=function(scenario)
					self:BloodPriceKnockback(spellinstancepointer,scenario)
				end
			event.alwayshappens=true
			tinsert(self.scenario.events,event)				


			if(self.scenario.bloodpricecallback)then
				local event={}
				event.time=self.scenario.game.environment_gameplay.localtime+BLOODPRICE_KNOCKBACK_DELAY+0.1
				event.func=function(scenario)					
						scenario:bloodpricecallback()
						scenario.bloodpricecallback=nil
					
				end
				--event.alwayshappens=true				
				tinsert(self.scenario.events,event)				
			end				
						
		end
		
		function class:BloodPriceKnockback(spellinstancepointer,scenario)
			local denathrius=spellinstancepointer.castercombat.mob
			for i=1,#scenario.allplayers do
				local ghost=scenario.allplayers[i]
				if(not ghost:IsDeadInGame())then
					local angle=math.atan2(ghost.position.y-denathrius.position.y,ghost.position.x-denathrius.position.x)
					if(ghost.mirrorrealm)then 
						angle=angle+math.pi
					end				
					ghost.velocity.z=60*(1/10)
					local xyvelocity=100*(1/10)
					ghost.velocity.x=math.cos(angle)*xyvelocity
					ghost.velocity.y=math.sin(angle)*xyvelocity
				end				
			end
		end
	end
	
	do
		local super=XPRACTICE.Aura_UnskippableCutscene
		XPRACTICE.INDIGNATION.Aura_BloodPrice=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Aura_BloodPrice
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.state=1
			self.baseduration=3.5+BLOODPRICE_KNOCKBACK_DELAY
		end
		

		
		function class:SetupNewauraLists(auramodule)
			super.SetupNewauraLists(self,auramodule)	-- unskippablecutscene
			tinsert(self.auramodulelists,auramodule.animation)
			tinsert(self.auramodulelists,auramodule.lossofcontrolalert)
		end
				
			function class:GetAnimation()
			return XPRACTICE.AnimationList.Strangulate
		end
	
		function class:GetLOCAIcon()
			return "interface/icons/ability_ironmaidens_whirlofblood.blp"
		end
		function class:GetLOCAText()
			return "Silenced"
		end	

		
		function class:Step(elapsed)		
			super.Step(self,elapsed)
			
			--local TOP_POSITION=15
			local TOP_POSITION=12.5
			if(self.state==1)then
				self.targetcombat.mob.velocity.x=0
				self.targetcombat.mob.velocity.y=0
				--self.targetcombat.mob.velocity.z=5
				self.targetcombat.mob.velocity.z=15
				if(self.targetcombat.mob.position.z>=TOP_POSITION)then 
					self.state=2
				end
			end
			if(self.state==2)then
				self.targetcombat.mob.velocity.z=0
				self.targetcombat.mob.position.z=TOP_POSITION
			end
		end
		
		-- function class:OnExpiry()
			-- super.OnExpiry(self)
			-- --self.targetcombat:ApplyAuraByClass(NZOTHPRACTICE.DEFAULTSCENARIO.Aura_GlimpseOfInfinity_Knockdown,self.castercombat,self.targetcombat.mob.scenario.localtime)
			
		-- end
	end	

end