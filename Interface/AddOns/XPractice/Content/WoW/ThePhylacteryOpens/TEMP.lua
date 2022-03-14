do
	--TODO: volatile code reuse -- only use function in multiplayer/messagehandler.lua
	local function IsRealOfficer(unit)
		unit=strsplit("-",unit)
		return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
	end

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Brez=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Brez
		
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
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_StartEncounter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_StartEncounter
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Start)"
			self.icon="interface/icons/spell_warlock_darkregeneration.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			
			if(not IsRealOfficer("player"))then
				scenario.statuslabel:SetText("When you are in a group, you must be lead/assist to start the game.",3.0)
				return 
			end
			
			if(scenario.multiplayer.roomlocked)then 
				scenario.statuslabel:SetText("Seems to be a game in progress already.",3.0)
				return 
			end
			
			local swirltype=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype
			if(swirltype==0)then
				scenario.multiplayer:FormatAndSendCustom("SWIRLSYNC_STOP")
			elseif(swirltype==3)then
				scenario.multiplayer:FormatAndSendCustom("SWIRLSYNC_FAST")
			else
				scenario.multiplayer:FormatAndSendCustom("SWIRLSYNC_SLOW")
			end
			local mobappearance=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.mobappearance
			if(mobappearance==3)then
				scenario.multiplayer:FormatAndSendCustom("APPEAR_LICH")
			else
				scenario.multiplayer:FormatAndSendCustom("APPEAR_HUMAN")
			end
			
			scenario.multiplayer.Send.LOCK(scenario.multiplayer)
		end
	end	
		
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_StopEncounter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_StopEncounter 
		
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
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_HumanAppearance=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_HumanAppearance
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Human appearance)"
			self.icon="interface/icons/spell_nature_invisibilty.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer:FormatAndSendCustom("APPEAR_HUMAN")
		end
	end	
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_LichAppearance=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_LichAppearance
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Lich appearance)"
			self.icon="interface/icons/spell_magic_lesserinvisibilty.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer:FormatAndSendCustom("APPEAR_LICH")			
		end
	end		


	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ClearQueue=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ClearQueue
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Clear spell queue)"
			self.icon="interface/icons/spell_holy_dispelmagic.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer:FormatAndSendCustom("QUEUE_CLEAR")
		end
	end	
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SaveQueue=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SaveQueue
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Clear spell queue)"
			self.icon="interface/icons/spell_holy_dispelmagic.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario	
			scenario.multiplayer:FormatAndSendCustom("QUEUE_CLEAR")
		end
	end
	
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SaveQueue=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SaveQueue
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Save boss queue)"
			self.icon="interface/icons/inv_misc_book_16.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.savedbossqueue={}
			for i=1,#scenario.bossqueue do
				tinsert(XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.savedbossqueue,scenario.bossqueue[i])
			end
			scenario.statuslabel:SetText("Recorded current boss queue (length "..#scenario.bossqueue..") to addon savedata.",3.0)
		end
	end		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_LoadQueue=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_LoadQueue
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Load boss queue)"
			self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			if(not IsRealOfficer("player"))then
				scenario.statuslabel:SetText("Can't load queue because you are not lead/assist.",3.0)
				return
			end			
			if(scenario.queueloader)then
				scenario.statuslabel:SetText("You're already busy sending your saved queue to other players.",3.0)
				return
			else
				scenario.queueloader=XPRACTICE.KELTHUZADMULTIPLAYER.QueueLoader.new()
				scenario.queueloader:Setup(spellinstancepointer.castercombat.mob.environment)
				scenario.queueloader.scenario=scenario
			end	
		end
	end		
	do
		local super=XPRACTICE.GameObject
		XPRACTICE.KELTHUZADMULTIPLAYER.QueueLoader=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.QueueLoader
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.queueindex=self.queueindex or 1.0
			self.throttletimer=self.throttletimer or 0.0
			self.throttletimer=self.throttletimer-elapsed
			if(self.throttletimer<0)then
				self.throttletimer=0.25
				if(self.queueindex>#XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.savedbossqueue)then
					if(#XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.savedbossqueue==0)then
						self.scenario.statuslabel:SetText("Your saved queue appears to be empty.",3.0)
					end
					self.scenario.queueloader=nil
					self:Die()
				else
					local spellname=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.savedbossqueue[self.queueindex]
					if(spellname=="IceBeam")then
						self.scenario.multiplayer:FormatAndSendCustom("QUEUE_BEAM")
					elseif(spellname=="Pushback")then
						self.scenario.multiplayer:FormatAndSendCustom("QUEUE_PUSH")
					elseif(spellname=="Tornadoes")then
						self.scenario.multiplayer:FormatAndSendCustom("QUEUE_CYCLO")
					elseif(spellname=="UndyingWrath")then
						self.scenario.multiplayer:FormatAndSendCustom("QUEUE_FINAL")
					end
				end
				self.queueindex=self.queueindex+1
			end
		end
		
	end
	
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_PallyBubble=XPRACTICE.inheritsFrom(super)
		
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_PallyBubble
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
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_LaserDebuff)
			for i=1,#auras do
				auras[i]:Die()
			end
			self.scenario.multiplayer:FormatAndSendCustom("PALLYBUBBLE")
		end
		
	--ghost.animationmodule:TryCompleteOmniSpellcast()	
	end	
	
	do
		local super=XPRACTICE.Aura
		XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble

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
			local visual=XPRACTICE.KELTHUZADMULTIPLAYER.PallyBubbleVisual.new()
			visual:Setup(player.environment,player.position.x,player.position.y,player.position.z)
			visual.player=player
			
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_LaserDebuff)
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
		XPRACTICE.KELTHUZADMULTIPLAYER.PallyBubbleVisual=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PallyBubbleVisual
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
		local super=XPRACTICE.Nameplate
		XPRACTICE.KELTHUZADMULTIPLAYER.OrbNameplate=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.OrbNameplate
		function class:CreateDisplayObject()
			self.displayobject=XPRACTICE.KELTHUZADMULTIPLAYER.OrbNameplateDisplayObject.new()
			self.displayobject:Setup(self)
		end		
		function class:SetNearby()
			self:SetLongrange()
		end	
		function class:Step(elapsed)
			if(self.mob.alreadyfadestarted or self.mob.dead)then
				self:Die()
			end
			if(self.selected)then
				self.selectsize=self.selectsize+elapsed*(10)
				if(self.selectsize>1)then self.selectsize=1 end
			else
				self.selectsize=self.selectsize-elapsed*(10)
				if(self.selectsize<0)then self.selectsize=0 end	
			end
			self.displayobject.background:SetSize(145+65*self.selectsize,15+5*self.selectsize)
			self.displayobject:SetFillPoints()
			--self.displayobject.drawable:SetSize(145+65*self.selectsize,55+5*self.selectsize)
		end		
		
		function class:SetTextonlySize(size)
			--print("!!!")
			local scale=size/100 --tentative
			--print("Textonly scale",scale)
			self.displayobject.textonly.fontstring:SetScale(scale)	--!!!
			self.displayobject.textonly:SetWidth(size*4)				--!!!
			self.displayobject.textonly:SetHeight(53) --!!!  --TODO: why does height change after closing+reopening xpractice?
		end		
	end
	do
		local super=XPRACTICE.NameplateDisplayObject
		XPRACTICE.KELTHUZADMULTIPLAYER.OrbNameplateDisplayObject=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.OrbNameplateDisplayObject
		
		function class:SetSelected(selected)
			local texture,gradient1,gradient2,textcolor
			if(not selected)then
				--texture={0,0,0,0.75}
				texture={0,0,0,1}
				gradient1={"VERTICAL",0,0.4375,0.8633,0.75,0,0,0,0.75}
				gradient2={"VERTICAL",0,0.4375,0.8633,0.75,1,0,0,0.75}
				textcolor={0,1,0,0.75}
			else
				texture={1,1,1,1}
				gradient1={"VERTICAL",0,0.4375,0.8633,1,0,0,0,1}
				gradient2={"VERTICAL",0,0.4375,0.86331,1,0,0,1}
				textcolor={0,1,0,1}
			end
			--self.background.texture:SetColorTexture(unpack(texture))
			self.bordertop.texture:SetColorTexture(unpack(texture))
			self.borderbottom.texture:SetColorTexture(unpack(texture))
			self.borderleft.texture:SetColorTexture(unpack(texture))
			self.borderright.texture:SetColorTexture(unpack(texture))
			self.topfill.texture:SetGradientAlpha(unpack(gradient1))		
			self.bottomfill.texture:SetGradientAlpha(unpack(gradient2))
			self.name.fontstring:SetTextColor(unpack(textcolor))
			self.textonly.fontstring:SetTextColor(unpack(textcolor))
		end
	
	function class:SetText(text)
		self.name.fontstring:SetText(text)
		self.name:SetSize(self.name.fontstring:GetStringWidth(),self.name.fontstring:GetStringHeight()+5)	
		self.name.fontstring:SetScale(1)	--TODO: this shouldn't be necessary, but it isn't being applied in ResetProperties
		
		self.textonly.fontstring:SetText(text)
		--self.textonly:SetSize(self.textonly.fontstring:GetStringWidth(),self.textonly.fontstring:GetStringHeight()+5)	
		self.textonly:SetSize(self.textonly.fontstring:GetStringWidth(),self.textonly.fontstring:GetStringHeight()+5)	
	end	

end

	
end