do


	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_Brez=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_Brez
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Brez)"
			self.icon="interface/icons/inv_jewelry_talisman_06.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario:Brez()
			--scenario.multiplayer:FormatAndSendCustom("BREZ") -- brez message moved to scenario so we can check if player is actually dead first
		end
	end	

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_AddImaginaryPlayer=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_AddImaginaryPlayer
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Add imaginary player)"
			self.icon="interface/icons/spell_chargepositive.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local bounds=XPRACTICE.FATESCRIBEMULTIPLAYER.BOUNDS
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				if(ring.active and ring.rune)then
					local distx=scenario.player.position.x
					local disty=scenario.player.position.y
					local distsqr=distx*distx+disty*disty
					local dist=math.sqrt(distsqr)		
					local mindist=bounds[ring.ringindex][1]
					local maxdist=bounds[ring.ringindex][2]
					
					if(mindist<=dist and dist<=maxdist)then
						success=true
						successindex=ring.ringindex
						scenario.multiplayer:FormatAndSendCustom("ADDGHOST",ring.ringindex)
						-- if(ring.ghostplayercount<9)then
							-- ring.ghostplayercount=ring.ghostplayercount+1
							-- scenario.statuslabel:SetText(sender.." added an imaginary player to ring #"..tostring(ring.ringindex).." ("..tostring(ring.ghostplayercount).." total).",3.0)							
						-- else
							-- --scenario.statuslabel:SetText("That's more than enough imaginary players.",3.0)
						-- end
					end
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("Stand on an active ring first.")
			end
		end
	end	
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SubtractImaginaryPlayer=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SubtractImaginaryPlayer
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Subtract imaginary player)"
			self.icon="interface/icons/spell_chargenegative.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local bounds=XPRACTICE.FATESCRIBEMULTIPLAYER.BOUNDS
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				if(ring.active and ring.rune)then
					local distx=scenario.player.position.x
					local disty=scenario.player.position.y
					local distsqr=distx*distx+disty*disty
					local dist=math.sqrt(distsqr)		
					local mindist=bounds[ring.ringindex][1]
					local maxdist=bounds[ring.ringindex][2]
					
					if(mindist<=dist and dist<=maxdist)then
						success=true
						successindex=ring.ringindex
						scenario.multiplayer:FormatAndSendCustom("REMOVEGHOST",ring.ringindex)
						-- if(ring.ghostplayercount>0)then
							-- ring.ghostplayercount=ring.ghostplayercount-1
							-- scenario.statuslabel:SetText(sender.." removed an imaginary player from ring #"..tostring(ring.ringindex).." ("..tostring(ring.ghostplayercount).." remaining).",3.0)							
						-- else
							-- scenario.statuslabel:SetText("No imaginary players to remove.",3.0)
						-- end
					end
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("Stand on an active ring first.")
			end
		end
	end	
	
	

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_StopEncounter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_StopEncounter
		
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
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_GetPlayerPosition=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_GetPlayerPosition
		
			
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="(Get Player Position)"
			self.icon="interface/icons/icon_treasuremap.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local player=self.scenario.player
			local camera=self.scenario.game.environment_gameplay.cameramanager.camera
			print("Coordinates:  x="..tostring(player.position.x)..", y="..tostring(player.position.y)..", z="..player.position.z)			
			--print("Camera:",camera.cdist)
			print("Orientation:",player.orientation_displayed.yaw)			
			local playerangle=math.atan2(player.position.y,player.position.x)
			print("Distance from center:",math.sqrt(player.position.x*player.position.x+player.position.y*player.position.y))			
			print("Angle from center:",playerangle)
			
			local safeangle=-math.pi/6
			local playerangle=math.atan2(player.position.y,player.position.x)
		end
	end
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_PallyBubble=XPRACTICE.inheritsFrom(super)
		
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_PallyBubble
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
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff)
			for i=1,#auras do
				auras[i]:Die()
			end
			self.scenario.multiplayer:FormatAndSendCustom("PALLYBUBBLE")
		end
		
	--ghost.animationmodule:TryCompleteOmniSpellcast()	
	end	
	
	do
		local super=XPRACTICE.Aura
		XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble

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
			player:CreateSpeechBubble("IMMUNE")
			local visual=XPRACTICE.FATESCRIBEMULTIPLAYER.PallyBubbleVisual.new()
			visual:Setup(player.environment,player.position.x,player.position.y,player.position.z)
			visual.player=player
			
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff)
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
				self.targetcombat.mob:CreateSpeechBubble(tostring(timer))
			end
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.PallyBubbleVisual=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.PallyBubbleVisual
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
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_FixedRuneMode=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_FixedRuneMode			
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Fixed Runes)"
			self.icon="interface/icons/inv_misc_celestial map.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customrunes=true
			self.scenario.statuslabel:SetText("Runes will start in your preset positions.",3.0)
		end
	end	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RNGRuneMode=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RNGRuneMode			
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(RNG Runes)"
			self.icon="interface/icons/ability_iyyokuk_drum_red.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customrunes=false
			self.scenario.statuslabel:SetText("Runes will start in random positions.",3.0)
		end
	end		
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_CustomGoalMode=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_CustomGoalMode			
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Custom goals)"
			self.icon="interface/icons/ability_druid_typhoon.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customgoals=true
			if(self.scenario.multiplayer.roomlocked)then
				self.scenario.statuslabel:SetText("Can't adjust goals while encounter is in progress.")
				return
			end			
			self.scenario.statuslabel:SetText("Goals will start in your preset positions.",3.0)
			XPRACTICE.FATESCRIBEMULTIPLAYER.LoadCustomGoals(self.scenario)
			local rings=self.scenario.rings
			self.scenario.multiplayer:FormatAndSendCustom("PLACEGOALSWITHOUTSAVING",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)		
		end
	end	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_FixedGoalMode=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_FixedGoalMode
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Fixed goals)"
			self.icon="interface/icons/inv_misc_book_16.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customgoals=false
			if(self.scenario.multiplayer.roomlocked)then
				self.scenario.statuslabel:SetText("Can't adjust goals while encounter is in progress.")
				return
			end
			self.scenario.statuslabel:SetText("Goals will start in their standard positions.",3.0)
			XPRACTICE.FATESCRIBEMULTIPLAYER.LoadStandardGoals(self.scenario)
			local rings=self.scenario.rings
			self.scenario.multiplayer:FormatAndSendCustom("PLACEGOALSWITHOUTSAVING",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)
		end
	end			
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LasersOn=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LasersOn
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Lasers on)"
			self.icon="interface/icons/spell_animaardenweald_beam.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.ringlasers=true			
			scenario.multiplayer:FormatAndSendCustom("LINES",true)
		end
	end		
		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LasersOff=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LasersOff
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Lasers off)"
			self.icon="interface/icons/spell_animamaw_beam.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario	
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.ringlasers=false
			scenario.multiplayer:FormatAndSendCustom("LINES",false)
		end
	end		
end