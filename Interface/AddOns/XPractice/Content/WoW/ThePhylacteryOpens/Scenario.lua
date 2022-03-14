--TODO NEXT:

-- HP bar shouldn't be full in phases 2-3
-- 9du_torghastraid_phylactery01    -- 0,146,147,148,149,213 (inert, closing, closed, opening, opened, shattered)

do
	local super=XPRACTICE.Scenario
	XPRACTICE.KELTHUZADMULTIPLAYER.Scenario=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.Scenario
	
	XPRACTICE.KELTHUZADMULTIPLAYER.NPCID=176929
	
	local FLOORZ=-0.425*(1.8/3)
	
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		
		self.savedataname="KELTHUZADMULTIPLAYER"
		self.npcid=XPRACTICE.KELTHUZADMULTIPLAYER.NPCID

		self.phaseinprogress=false
		self.currentphase=1
		self.phasecomplete=false

		self.player=nil
		self.startbutton=nil
		self.lastmovetime=0
		
		self.events={}
		self.stopallevents=false
		
		self.allplayers={}
		self.swirls={}
		self.pools={}
		self.tornadoes={}
		
		self.tornadograceperiod=nil
		
		self.pooltime=0
		self.inpool=false
		self.exitportallocked=true
		
		self.bossqueue={}
		self.bossgcd=0
		self.inphasecount=0
		
		self.queueloader=nil
	end
	


	function class:Populate()
		super.Populate(self)
		
		local scenario=self

		self.phaseinprogress=false
		self.phasetime=0
		
		self.buttongroup={}
		self.buttongroup[1]={}		-- Options/Go

		
		self.markers={}
		
	
		local scenario=self
		local gamemenu=XPRACTICE.GameMenu.new()
		gamemenu:Setup(self.game.environment_gameplay,self.game.SCREEN_WIDTH/2-180/2,self.game.SCREEN_HEIGHT/2-270/2)
		self.gamemenu=gamemenu
		

		self.game.environment_gameplay.modelsceneframe:SetLightDirection(.2,0,-1)

		self.collision=XPRACTICE.KELTHUZADMULTIPLAYER.Collision.new()
		self.collision.scenario=self
		
		local button

		
		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=150,z=0}
		label:SetSize(600,300)
		label:SetText("")
		self.statuslabel=label

		self.debugbuttonx=self.game.SCREEN_WIDTH/2-25
		self.debugbuttony=104
				
	

		local mob,obj
		local player


		
		--mob=XPRACTICE.Mob.new()
		player=XPRACTICE.PlayerCharacter.new()		
		player:Setup(self.game.environment_gameplay)
		player.displayobject.drawable:SetSheathed(false) 
		
		if(XPRACTICE.KELTHUZADMULTIPLAYER.Config.QuickStart)then
			player.position={x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3,y=0,z=0}	
			player.orientation.yaw=0;player.orientation_displayed.yaw=player.orientation.yaw	--facing EAST			
			player.inphase=true
		else
			player.position={x=0,y=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-10,z=0}	
			player.orientation.yaw=-math.pi/2;player.orientation_displayed.yaw=player.orientation.yaw			
			player.inphase=false
		end
		player.scenario=self
		self.player=player		
		tinsert(self.allplayers,player)
		player.timeinphase=0
		

		self.game.environment_gameplay.cameramanager.camera.focus=player
		self.game.environment_gameplay.cameramanager.camera.orientation.yaw=player.orientation.yaw
		self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05
		--self.game.environment_gameplay.cameramanager.camera.cdist=30
		self.game.environment_gameplay.cameramanager.camera.cdist=45
		
		
		local lossofcontrolalert=XPRACTICE.LossOfControlAlert.new()
		self.lossofcontrolalert=lossofcontrolalert
		lossofcontrolalert:Setup(self.game.environment_gameplay)
		lossofcontrolalert.position={x=self.game.SCREEN_WIDTH/2-180/2,y=self.game.SCREEN_HEIGHT/2,z=0}
		lossofcontrolalert.focus=player

		
		--TODO: move elsewhere
		local maincastingbar=XPRACTICE.CastingBar.new()
		self.maincastingbar=maincastingbar
		maincastingbar:Setup(self.game.environment_gameplay)
		maincastingbar.position={x=self.game.SCREEN_WIDTH/2-196/2,y=150,z=0}
		maincastingbar.focus=player
		
		local controller=XPRACTICE.PlayerController.new()
		controller:Setup(self.game.environment_gameplay,player,self.game.environment_gameplay.cameramanager.camera)
		
		
		self.multiplayer=XPRACTICE.KELTHUZADMULTIPLAYER.Multiplayer.new()
		self.multiplayer:Setup(self.npcid,self,self.game.environment_gameplay)	
		self.multiplayer:SendHello()
		
		
		self.boss=XPRACTICE.KELTHUZADMULTIPLAYER.RemnantOfKELTHUZADMULTIPLAYER.new()
		self.boss.scenario=self
		self.boss:Setup(self.game.environment_gameplay)
		self.boss.position={x=0,y=0,z=0}				
		self.boss:FreezeOrientation(math.pi)
		
		
		local nameplate=XPRACTICE.Nameplate.new()
		nameplate.hp_TEMP=1.0
		nameplate:Setup(self.game.environment_gameplay,self.boss)
		nameplate:SetText("Remnant of Kel'Thuzad")
		local castingbar=XPRACTICE.CastingBarTiny.new()
		castingbar:Setup(self.game.environment_gameplay,0,0,0)
		castingbar.focus=self.boss
		castingbar:AnchorToNameplate(nameplate)
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(self.game.environment_gameplay,self.boss)
		


		-- we use a separate mob for hidden spells so we can cast while boss is already casting
			-- pick a mob class at random.  we can't use Mob because the game doesn't know how to handle FileID(1) after rebooting
				-- (function crashes silently, no lua error!)
		local obj=XPRACTICE.INDIGNATION.CrimsonCabalist.new()
		obj:Setup(self.game.environment_gameplay)
		obj.alpha=0		-- invisible bunny
		obj.scenario=self
		self.spellbunny=obj
		



		self.swirlcontroller=XPRACTICE.KELTHUZADMULTIPLAYER.SwirlController.new()
		self.swirlcontroller:Setup(self.game.environment_gameplay)
		self.swirlcontroller.scenario=self
		

		local floorobj
		floorobj=XPRACTICE.KELTHUZADMULTIPLAYER.Floor.new()
		floorobj:Setup(self.game.environment_gameplay)
	
		local floorobj2
		floorobj2=XPRACTICE.KELTHUZADMULTIPLAYER.MainPhaseFloor.new()
		floorobj2:Setup(self.game.environment_gameplay,0,XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset,0)


		
		local exitportal
		exitportal=XPRACTICE.KELTHUZADMULTIPLAYER.ExitPortal.new()
		exitportal:Setup(self.game.environment_gameplay)
		exitportal.orientation_displayed.yaw=math.pi
		--exitportal.position={x=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius-3,y=0,z=3}
		exitportal.position={x=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius-5,y=0,z=0}
		self.exitportal=exitportal

		local entranceportal
		entranceportal=XPRACTICE.KELTHUZADMULTIPLAYER.EntrancePortal.new()
		entranceportal:Setup(self.game.environment_gameplay)
		--entranceportal.orientation_displayed.yaw=math.pi
		--exitportal.position={x=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius-3,y=0,z=3}
		entranceportal.position={x=0,y=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset+XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerYOffset,z=0}
		self.entranceportal=entranceportal
		
		local entrancektvisual
		entrancektvisual=XPRACTICE.KELTHUZADMULTIPLAYER.KTEntranceVisual.new()
		entrancektvisual:Setup(self.game.environment_gameplay)
		entrancektvisual.position={x=0,y=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset+XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerYOffset,z=5}
		entrancektvisual.orientation_displayed.yaw=math.pi/2
		self.entrancektvisual=entrancektvisual		
		
		local scryingorb
		scryingorb=XPRACTICE.KELTHUZADMULTIPLAYER.ScryingOrb.new()
		scryingorb:Setup(self.game.environment_gameplay)
		scryingorb.position={x=-13,y=13+XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset+XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerYOffset,z=0}
		scryingorb.orientation_displayed.yaw=math.pi/2
		scryingorb.scenario=self
		self.scryingorb=scryingorb	
		local nameplate=XPRACTICE.KELTHUZADMULTIPLAYER.OrbNameplate.new()
		nameplate:Setup(scryingorb.environment,scryingorb)
		nameplate:SetText("Scrying Orb")
		nameplate:SetSelected(true)
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(scryingorb.environment,scryingorb)		

	
		local doticon=XPRACTICE.KELTHUZADMULTIPLAYER.DoTDebuffIcon.new()
		doticon:Setup(self.game.environment_gameplay)
		doticon.position.x=self.game.SCREEN_WIDTH-125
		doticon.position.y=self.game.SCREEN_HEIGHT-125
		doticon.scenario=self
		doticon.focus=self.player
		self.doticon=doticon

		local poolicon=XPRACTICE.KELTHUZADMULTIPLAYER.PoolDebuffIcon.new()
		poolicon:Setup(self.game.environment_gameplay)
		poolicon.position.x=self.game.SCREEN_WIDTH-125-125
		poolicon.position.y=self.game.SCREEN_HEIGHT-125
		poolicon.scenario=self
		poolicon.focus=self.player
		self.poolicon=poolicon


		local scenario=self
		
		----extra action button...
		local spell_changephase=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ChangePhase.new()		
		spell_changephase:Setup(self.player.combatmodule)
		self.spell_changephase=spell_changephase
		local changephasebutton
		changephasebutton=XPRACTICE.ExtraActionButton.new()						
		changephasebutton:Setup(self.game.environment_gameplay)
		changephasebutton:SetIcon(spell_changephase:GetIcon())
		changephasebutton:SetExtraBorderSize(256,128)
		changephasebutton:SetLockedStartingAlpha(0)
		self.changephasebutton=changephasebutton
		changephasebutton:SetExtraBorderIcon("interface/extrabutton/default.blp")
		changephasebutton.position={x=self.game.SCREEN_WIDTH/2-25,y=75,z=0}
		changephasebutton.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 		
					local queuepointer=scenario.spell_changephase:NewQueue()
					queuepointer.castercombat=scenario.player.combatmodule
					local errorcode=scenario.player.combatmodule:TryQueue(queuepointer)
				end
			end)
		
		
		self.worldmarkercontroller=XPRACTICE.FATESCRIBEMULTIPLAYER.WorldMarkerController.new()
		self.worldmarkercontroller:Setup(self.game.environment_gameplay)
		
		XPRACTICE.BossDebugButton.ResetPosition()
		self.bossdebugbuttons={}
		local button
		
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		--self.getplayerpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_GetPlayerPosition,self.spellbunny)
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		self.loadbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_LoadQueue,self.spellbunny,"LOAD\nQUEUE")
		self.loadbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SaveQueue,self.spellbunny,"SAVE\nQUEUE")
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		self.startbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_StartEncounter,self.spellbunny,"START")
		self.icebeambutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_IceBeamMulti,self.spellbunny,"BEAM")
		self.pushbackbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_PushbackMulti,self.spellbunny,"PUSH")
		self.tornadoesbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_TornadoesMulti,self.spellbunny,"CYCLO")
		--self.tornadoesdebugbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Tornadoes_Debug,self.spellbunny)		
		self.wrathbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_UndyingWrathMulti,self.spellbunny,"FINAL")
		self.clearbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ClearQueue,self.spellbunny,"CLEAR\nQUEUE")
		self.stopbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_StopEncounter,self.spellbunny,"STOP")
		XPRACTICE.BossDebugButton.debugbuttonx=XPRACTICE.BossDebugButton.debugbuttonx+52
		self.dashbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Sprint,self.spellbunny,"DASH")
		self.roarbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Roar,self.spellbunny,"ROAR")
		self.pallybubblebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_PallyBubble,self.spellbunny,"INVUL\n5 SEC")
		self.brezbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Brez,self.spellbunny,"ANKH")
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		self.swirlsync5button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_5,self.spellbunny,"SWIRL\n5 SEC")
		self.swirlsync2button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_2,self.spellbunny,"SWIRL\n3 SEC")
		self.swirlsyncstopbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_Stop,self.spellbunny,"SWIRL\nSTOP")
		self.resetstacksbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ResetStacks,self.spellbunny,"RESET\nSTACK")
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		self.humanappearancebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_HumanAppearance,self.spellbunny,"HMN")
		self.lichappearancebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.KELTHUZADMULTIPLAYER.Spell_LichAppearance,self.spellbunny,"LICH")		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		for i=1,#self.bossdebugbuttons do
			self.bossdebugbuttons[i]:SetLockedStartingAlpha(1);self.bossdebugbuttons[i]:EnableMouse(true) --TODO NEXT: --!!!
		end
		

		self.worldmarkercontroller:LoadAll(self,true)

		
		

		
		if(self.multiplayer.joinedsolo)then
			self.statuslabel:SetText("You are not in a group!\nJoin a group to enable multiplayer features.",nil)
		end
		
		
	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		if(self.player and self.spectating)then
			if(self.player.velocity.x~=0 or self.player.velocity.y~=0 or self.player.velocity.z~=0)then
				self.spectating=false
				self.game.environment_gameplay.cameramanager.camera.focus=self.player
			end
		end
		
		if(self.inphasecount>0)then
			if(self.bossgcd>0)then
				self.bossgcd=self.bossgcd-elapsed
				if(self.bossgcd<-1.0)then self.bossgcd=-1.0 end
			end
		else
			self.bossgcd=self.bossgcd-elapsed
			if(self.bossgcd<XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSpellcastTime)then self.bossgcd=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSpellcastTime end
		end
		if(self.multiplayer.roomlocked)then
			if(self.multiplayer.host)then
				if(self.bossgcd<=0)then
					if(self.inphasecount>0)then
						if(#self.bossqueue>0)then
							self.bossgcd=self.bossgcd+XPRACTICE.KELTHUZADMULTIPLAYER.Config.BossGCDSafetyBuffer
							local spell=self.bossqueue[1]						
							local spellname="Spell_"..spell
							XPRACTICE.KELTHUZADMULTIPLAYER[spellname]:Broadcast(self)
						end
					end
				end
			end
		end

		--if(self.phaseinprogress)then
		for k,v in pairs(self.multiplayer.allplayers)do
			local player=v
			player.inphase=player.inphase or false 	--TODO: should be true only if quickstart is on
			if(player.inphase)then
				if(player:IsDeadInGame() or not self.multiplayer.roomlocked)then
					player.timeinphase=0
				else
					player.timeinphase=player.timeinphase or 0
					player.timeinphase=player.timeinphase+elapsed
				end
			else			
				player.timeinphase=0
			end
		end
		--end


		------------------------------------------------------------------------------
		-- EXTRA ACTION BUTTON
		------------------------------------------------------------------------------
		if(self.player)then
			self.collision:ChangePhaseButtonCheck()
		end

		
		---------------------------------------------------------------
		-- HIT DETECTION
		---------------------------------------------------------------
		
		if(self.player)then
			self.collision:OutOfBoundsCheck()
			
			self.collision:TornadoCheck()
			self.collision:PoolCheck(elapsed)
		end
		
		
		
		------------------------------------------------------------------------------
		-- MENU BUTTONS
		------------------------------------------------------------------------------	
	
		

		
		
		------------------------------------------------------------------------------
		-- TIMED EVENTS
		------------------------------------------------------------------------------	
		-- process this loop forward so events are executed usually in the order they are queued
		
		for i=1,#self.events do
			local event=self.events[i]
			if(self.stopallevents==false or event.alwayshappens)then
				if(self.game.environment_gameplay.localtime>=event.time)then
					--print("event",event,event.time)
					if(event.button)then
						event.button:BossButtonClick()				
					end
					if(event.func)then
						event.func(self)
					end
					event.dead=true
					--TODO LATER: due to the way spell queues are currently set up, queueing up two buttons on the same frame will overwrite the former spell with the latter
					-- so for now, we break to limit one event per frame
					break
				end
			end
		end

		-- removal loop goes backward as usual
		for i=#self.events,1,-1 do
			if(self.events[i].dead)then
				tremove(self.events,i)
			end
		end
		
		
		for i=#self.pools,1,-1 do
			if(self.pools[i].dead)then
				tremove(self.pools,i)
			end
		end
		
		for i=#self.tornadoes,1,-1 do
			if(self.tornadoes[i].dead)then
				tremove(self.tornadoes,i)
			end
		end		

		
	end
	
	
	function class:UpdatePlayerFloorbelowStatus()
	
		for k,v in pairs(self.multiplayer.allplayers)do
			local player=v
			if(not player.inphase)then
				player.floorbelow=true
				return
			end
			if(self.player.floorbelow==false and self.player.position.z<0)then 
				return 
			end
			local ok=self.collision:EdgeCheck(player)
			player.floorbelow=ok
			
		end
	
		-- --overridden function is base scenario class, so we can't move the entire thing to collision
		-- if(not self.player)then return end
		-- if(not self.player.inphase)then
			-- self.player.floorbelow=true
			-- return
		-- end
		
		-- if(self.player.floorbelow==false and self.player.position.z<0)then 
			-- return 
		-- end
		
		-- local ok=self.collision:EdgeCheck(0)
		-- -- if(ok==false)then	-- this secondary check is only needed for line-based boundary check
			-- -- ok=self.collision:OutOfBoundsCheck(-0.01) or self.collision:OutOfBoundsCheck(-0.01)
		-- -- end
		-- self.player.floorbelow=ok
	end
	


	function class:Brez()
		local auras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced)
		if(#auras>0)then 			
			return 
		end				
		if(self.player.position.z<0)then
			return
		end
	
		local auras=self.player.combatmodule.auras.deadingame
		if(#auras==0)then 
			self.statuslabel:SetText("You're not dead yet.",3.0)
			return 
		end
		local auras=self.player.combatmodule.auras.deadingame
		for i=1,#auras do
			auras[i]:Die()
		end
		
	
		
		self.pooltime=0
		self.inpool=false
		self.player.timeinphase=0
		self.player.velocity.x=0
		self.player.velocity.y=0
		self.player.velocity.z=0				

		self.statuslabel:SetText("Brezzed.",3.0)
		self.multiplayer:FormatAndSendCustom("BREZ")
	end



	-- function class:EnableButtons(buttongroup,toggle)
		-- for i=1,#buttongroup do
			-- local button=buttongroup[i]
			-- if(toggle)then
				-- button.displayobject.drawable:SetAlpha(1)
			-- else
				-- button.displayobject.drawable:SetAlpha(0)
			-- end
			-- button:EnableMouse(toggle)
		-- end
	-- end
	function class:EnableButtons(buttongroup,toggle)
		for i=1,#buttongroup do
			local button=buttongroup[i]
			if(toggle)then
				button.displayobject.drawable:SetAlpha(1) -- for labels
				button.alpha=1
				button:SetLockedStartingAlpha(1.0)	-- for buttons
			else
				button.displayobject.drawable:SetAlpha(0)
				button.alpha=0
				button:SetLockedStartingAlpha(0.0)
			end
			button:EnableMouse(toggle)
		end
	end	
	
	
	function class:DeselectButtons(buttongroup)
		for i=1,#buttongroup do
			local button=buttongroup[i]
			button:Select(false)
		end
	end
	


	function class:ClickButtonAfterDelay(button,delay)		
		if(delay<0)then return end --cheap way to skip events when we fastforward
		local event={}
		event.button=button
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end
	
	function class:FunctionAfterDelay(func,delay)		
		if(delay<0)then return end --cheap way to skip events when we fastforward
		local event={}
		event.func=func
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end
	

	
	function class:OnRoomLock(hostname)
		self.statuslabel:SetText(hostname.." started the encounter!",3.0)
		self.phaseinprogress=true
		self.swirlcontroller.active=true
		--TODO: once we've implemented outofphase, don't sync swirltimer until 1st player enters phase
		self.swirlcontroller.swirltimer=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSwirlTime+1.0
		self.swirlcontroller.swirltag=1
		
		local offsetx,offsety=XPRACTICE.RandomPointInCircle(0,0,XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimMaxOffset)
		--self.multiplayer:FormatAndSendCustom("MYSWIRL",string.char(254),0,0,string.char(self.swirlcontroller.swirltag),offsetx,offsety)
		self.multiplayer:FormatAndSendCustom("MYSWIRL",string.char(254),0,0,string.char(self.swirlcontroller.swirltag),offsetx,offsety)
		if(not self.player.swirloffsets)then self.player.swirloffsets={} end
		self.player.swirloffsets[self.swirlcontroller.swirltag]={x=offsetx,y=offsety}      

		self.inphasecount=0		
		for k,v in pairs(self.multiplayer.allplayers) do
			local player=v
			if(player.position.y>-1*(XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+10))then
				player.inphase=true
				self.inphasecount=self.inphasecount+1
			else
				player.inphase=false
			end
		end
		
		--local newgcd=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSpellcastTime
		--if(self.bossgcd<newgcd)then self.bossgcd=newgcd end
		
		--print("inphasecount",self.inphasecount)
	end
	
	function class:OnRoomUnlock(hostname,noofficers,acknowledge)
		--if(not self.multiplayer.roomlocked)then return end   --this doesn't work: room is ALREADY unlocked
		
		self.swirlcontroller.active=false
		
		if(not self.multiplayer.joinedgameinprogress)then
			if(not noofficers)then
				if(self.phaseinprogress)then
					self.statuslabel:SetText(hostname.." ended the encounter.",3.0)
				end
			else
				if(self.phaseinprogress)then      
					self.statuslabel:SetText("There are no officers left in the room.  The encounter ends.",3.0)
				end
			end		
			self.multiplayer:SendIExist()
		else
			self.multiplayer.joinedgameinprogress=false
			self.statuslabel:SetText("The encounter in progress has ended.  You will now join the room.",3.0)
			self.multiplayer:SendHello()
		end		
		for i=1,#self.swirls do
			local swirl=self.swirls[i]
			swirl.disarmed=true
			if(swirl.expirytime==nil)then				
				swirl.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
		end		
		for i=1,#self.pools do
			local pool=self.pools[i]
			if(pool.expirytime>pool.environment.localtime+1.0)then
				pool.fadestarttime=pool.environment.localtime+0.0
				pool.expirytime=pool.environment.localtime+1.0
			end
		end
	end

	function class:OnRoomAlreadyInProgress(sender)
		self.statuslabel:SetText("An encounter is already in progress!\nYou will automatically join the room when the encounter ends.",nil)
	end
	
	function class:OnCustomMessage(msgcode,sender,args)
		
	end
	
	function class:OnEscapeKey()
		if(self.gamemenu)then
			if(self.gamemenu.shown)then
				self.gamemenu:Hide()
			else
				local ok=true
				if(self.player)then					
					if(self.player.combatmodule.targetmob)then
						ok=false
					end
				end
				if(ok)then
					self.gamemenu:Show()
				end
			end
		end
	end	
	
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.KELTHUZADMULTIPLAYER.Scenario,"The Phylactery Opens","(Kel'Thuzad)")	
end

