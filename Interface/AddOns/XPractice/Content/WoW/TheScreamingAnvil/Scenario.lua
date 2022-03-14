
do
	local super=XPRACTICE.Scenario
	XPRACTICE.PAINSMITH.Scenario=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PAINSMITH.Scenario
	
	XPRACTICE.PAINSMITH.NPCID=176523
	
	local FLOORZ=-0.425*(1.8/3)
	
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		
		self.savedataname="PAINSMITH"
		self.npcid=XPRACTICE.PAINSMITH.NPCID

		self.phaseinprogress=false
		self.currentphase=1
		self.phasecomplete=false

		self.player=nil
		self.startbutton=nil
		self.lastmovetime=0
		
		self.events={}
		self.stopallevents=false
		
		self.allplayers={}
		self.spikes={}
		self.spikedballs={}
		self.spikesrows={}
		
		
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

		self.collision=XPRACTICE.PAINSMITH.Collision.new()
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
		
		player.position={x=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5,y=XPRACTICE.PAINSMITH.Config.ArenaTileSize*(7.5-2),z=0}
		player.orientation.yaw=math.pi/2;player.orientation_displayed.yaw=player.orientation.yaw	--facing NORTH

		player.scenario=self
		self.player=player		
		tinsert(self.allplayers,player)

		

		self.game.environment_gameplay.cameramanager.camera.focus=player
		self.game.environment_gameplay.cameramanager.camera.orientation.yaw=player.orientation.yaw
		--self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05
		self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.15
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
		
		
		self.multiplayer=XPRACTICE.PAINSMITH.Multiplayer.new()
		self.multiplayer:Setup(self.npcid,self,self.game.environment_gameplay)	
		self.multiplayer:SendHello()
		
		
		
		
		-- self.boss=XPRACTICE.PAINSMITH.Painsmith.new()
		-- self.boss.scenario=self
		-- self.boss:Setup(self.game.environment_gameplay)
		-- self.boss.position={x=0,y=0,z=0}				
		-- self.boss:FreezeOrientation(math.pi)
		-- local nameplate=XPRACTICE.Nameplate.new()
		-- nameplate.hp_TEMP=1.0
		-- nameplate:Setup(self.game.environment_gameplay,self.boss)
		-- nameplate:SetText("Remnant of Kel'Thuzad")
		-- local castingbar=XPRACTICE.CastingBarTiny.new()
		-- castingbar:Setup(self.game.environment_gameplay,0,0,0)
		-- castingbar.focus=self.boss
		-- castingbar:AnchorToNameplate(nameplate)
		-- local mobclickzone=XPRACTICE.MobClickZone.new()
		-- mobclickzone:Setup(self.game.environment_gameplay,self.boss)
		


		-- we use a separate mob for hidden spells so we can cast while boss is already casting
			-- pick a mob class at random.  we can't use Mob because the game doesn't know how to handle FileID(1) after rebooting
				-- (function crashes silently, no lua error!)
		local obj=XPRACTICE.INDIGNATION.CrimsonCabalist.new()
		obj:Setup(self.game.environment_gameplay)
		obj.alpha=0		-- invisible bunny
		obj.scenario=self
		self.spellbunny=obj
		



		local floorobj
		floorobj=XPRACTICE.PAINSMITH.Floor.new()
		floorobj:Setup(self.game.environment_gameplay)


		local scenario=self

			
		self.worldmarkercontroller=XPRACTICE.PAINSMITH.WorldMarkerController.new()
		self.worldmarkercontroller:Setup(self.game.environment_gameplay)
		
		
		self.scheduler=XPRACTICE.PAINSMITH.Scheduler.new()
		self.scheduler:Setup(self.game.environment_gameplay)
		self.scheduler.scenario=self
		
		
		XPRACTICE.PAINSMITH.QuickDemonicGateway(self)
		
		XPRACTICE.BossDebugButton.ResetPosition()
		self.bossdebugbuttons={}
		local button
		
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		self.getplayerpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_GetPlayerPosition,self.spellbunny)
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		-- self.loadbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_LoadQueue,self.spellbunny,"LOAD\nQUEUE")
		-- self.loadbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_SaveQueue,self.spellbunny,"SAVE\nQUEUE")
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		self.startbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_StartEncounter,self.spellbunny,"START")
		-- self.icebeambutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_IceBeamMulti,self.spellbunny,"BEAM")
		-- self.pushbackbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_PushbackMulti,self.spellbunny,"PUSH")
		-- self.tornadoesbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_TornadoesMulti,self.spellbunny,"CYCLO")
		-- --self.tornadoesdebugbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_Tornadoes_Debug,self.spellbunny)		
		-- self.wrathbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_UndyingWrathMulti,self.spellbunny,"FINAL")
		-- self.clearbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_ClearQueue,self.spellbunny,"CLEAR\nQUEUE")
		self.stopbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_StopEncounter,self.spellbunny,"STOP")
		XPRACTICE.BossDebugButton.debugbuttonx=XPRACTICE.BossDebugButton.debugbuttonx+52
		self.dashbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_Sprint,self.spellbunny,"DASH")
		self.roarbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_Roar,self.spellbunny,"ROAR")
		self.pallybubblebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_PallyBubble,self.spellbunny,"INVUL\n5 SEC")
		self.brezbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_Brez,self.spellbunny,"ANKH")
		
		-- XPRACTICE.BossDebugButton.CarriageReturn()
		
		-- self.swirlsync5button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_SwirlSync_5,self.spellbunny,"SWIRL\n5 SEC")
		-- self.swirlsync2button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_SwirlSync_2,self.spellbunny,"SWIRL\n3 SEC")
		-- self.swirlsyncstopbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_SwirlSync_Stop,self.spellbunny,"SWIRL\nSTOP")
		-- self.resetstacksbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_ResetStacks,self.spellbunny,"RESET\nSTACK")
		
		-- XPRACTICE.BossDebugButton.CarriageReturn()
		-- self.humanappearancebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_HumanAppearance,self.spellbunny,"HMN")
		-- self.lichappearancebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.PAINSMITH.Spell_LichAppearance,self.spellbunny,"LICH")		
		-- XPRACTICE.BossDebugButton.CarriageReturn()
		
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


		
		---------------------------------------------------------------
		-- HIT DETECTION
		---------------------------------------------------------------
		
		if(self.player)then
			self.collision:OutOfBoundsCheck()
			
			self.collision:SpikedBallsCheck()
			self.collision:SpikesCheck()
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
		
		
		for i=#self.spikes,1,-1 do
			if(self.spikes[i].dead)then
				tremove(self.spikes,i)
			end
		end
		
		for i=#self.spikedballs,1,-1 do
			if(self.spikedballs[i].dead)then
				tremove(self.spikedballs,i)
			end
		end		

		for i=#self.spikesrows,1,-1 do
			if(self.spikesrows[i].dead)then
				tremove(self.spikesrows,i)
			end
		end		
	end
	
	
	function class:UpdatePlayerFloorbelowStatus()
	
		for k,v in pairs(self.multiplayer.allplayers)do
			local player=v
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
		local auras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_ChangePhaseForced)
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
		
	
		
		self.player.portaldebuff=false
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
		self.scheduler:Activate()
		self.player.portaldebuff=false
		

	end
	
	function class:OnRoomUnlock(hostname,noofficers,acknowledge)
		--if(not self.multiplayer.roomlocked)then return end   --this doesn't work: room is ALREADY unlocked
		
		self.scheduler:Deactivate()
		
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
	
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.PAINSMITH.Scenario,"The Screaming Anvil","(WORK IN PROGRESS)","SCENARIO_TEST")
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.PAINSMITH.Scenario,"9.1","Sanctum of Domination","SEPARATOR")
end

