--TODO: volatile code reuse -- only use function in multiplayer/messagehandler.lua
local function IsRealOfficer(unit)
	unit=strsplit("-",unit)
	return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
end


do
	local super=XPRACTICE.Scenario
	XPRACTICE.FATESCRIBEMULTIPLAYER.Scenario=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Scenario
	
	XPRACTICE.FATESCRIBEMULTIPLAYER.NPCID=175730
	
	local FLOORZ=-0.425*(1.8/3)
	
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		
		self.savedataname="FATESCRIBEMULTIPLAYER"
		self.npcid=XPRACTICE.FATESCRIBEMULTIPLAYER.NPCID

		self.phaseinprogress=false
		self.phasecomplete=false

		self.player=nil
		self.startbutton=nil
		self.lastmovetime=0
		
		self.events={}
		self.stopallevents=false
		
		self.rings={}
		self.orbs={}		
		
		self.orbhits=0
		self.TEMP_PLAYERCOUNT=1
		self.playercurrentring=nil
	end
	


	function class:Populate()
		super.Populate(self)
		
		self.ringlasers=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.ringlasers
		
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

		self.collision=XPRACTICE.FATESCRIBEMULTIPLAYER.Collision.new()
		self.collision.scenario=self
		
		local button

		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=200,z=0}
		label:SetSize(600,300)
		label:SetText("")
		self.packetlosslabel=label
		
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
		--player.orientation.yaw=math.pi*1.5;player.orientation_displayed.yaw=math.pi*1.5
		--player.position={x=0,y=-18,z=0}
		player.position={x=-25,y=0,z=0}


		--facing EAST
		player.orientation.yaw=0;player.orientation_displayed.yaw=player.orientation.yaw
		player.scenario=self
		self.player=player
	
	
		self.multiplayer=XPRACTICE.FATESCRIBEMULTIPLAYER.Multiplayer.new()
		self.multiplayer:Setup(self.npcid,self,self.game.environment_gameplay)	
		self.multiplayer:SendHello()


		self.game.environment_gameplay.cameramanager.camera.focus=player
		self.game.environment_gameplay.cameramanager.camera.orientation.yaw=player.orientation.yaw
		self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05
		--self.game.environment_gameplay.cameramanager.camera.cdist=30
		self.game.environment_gameplay.cameramanager.camera.cdist=60
		
		
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
		
		
		
		self.boss=XPRACTICE.FATESCRIBEMULTIPLAYER.FatescribeRohKalo.new()
		self.boss:Setup(self.game.environment_gameplay)
		self.boss.position={x=20,y=0,z=0}		
		self.boss.scenario=self
		self.boss:FreezeOrientation(math.pi*1.75)
		--!!!
		self.boss.targetheight=self.boss.maxheight
		self.boss.position={x=0,y=0,z=self.boss.maxheight}
		
		local nameplate=XPRACTICE.Nameplate.new()
		nameplate.hp_TEMP=0.70
		nameplate:Setup(self.game.environment_gameplay,self.boss)
		nameplate:SetText("Fatescribe Roh-Kalo")
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
		
		
		self.orbspawnercontroller=XPRACTICE.FATESCRIBEMULTIPLAYER.OrbSpawnerController.new()
		self.orbspawnercontroller:Setup(self.game.environment_gameplay)
		self.orbspawnercontroller.scenario=self
		

		local floorobj
		floorobj=XPRACTICE.FATESCRIBEMULTIPLAYER.Floor.new()
		floorobj:Setup(self.game.environment_gameplay)
		self.floorobj=floorobj	
		local ringcenter
		ringcenter=XPRACTICE.FATESCRIBEMULTIPLAYER.RingCenter.new()
		ringcenter:Setup(self.game.environment_gameplay)
		self.ringcenter=ringcenter

		local ring
		for i=1,6 do
			local classname="Ring"..tostring(i)
			ring=XPRACTICE.FATESCRIBEMULTIPLAYER[classname].new()
			ring:Setup(self.game.environment_gameplay)
			ring.scenario=self
			tinsert(self.rings,ring)
		end


		local debufficon=XPRACTICE.FATESCRIBEMULTIPLAYER.LaserDebuffIcon.new()
		debufficon:Setup(self.game.environment_gameplay)
		debufficon.position.x=self.game.SCREEN_WIDTH-125
		debufficon.position.y=self.game.SCREEN_HEIGHT-125
		debufficon.scenario=self
		debufficon.focus=self.player
		self.debufficon=debufficon
		

		
		self.worldmarkercontroller=XPRACTICE.FATESCRIBEMULTIPLAYER.WorldMarkerController.new()
		self.worldmarkercontroller:Setup(self.game.environment_gameplay)
		
		XPRACTICE.BossDebugButton.ResetPosition()
		self.bossdebugbuttons={}
		local button
				
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		XPRACTICE.BossDebugButton.debugbuttony=XPRACTICE.BossDebugButton.debugbuttony+52
		--self.getplayerpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_GetPlayerPosition,self.spellbunny)
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		--self.realignfatefixedbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateFixed,self.boss,"START\nFIXED")		
		--self.skipintrorealignfatefixedbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SkipIntroRealignFateFixed,self.boss,"QUICK\nFIXED")
		self.realignfatebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateTrigger,self.boss,"START")
		self.skipintrorealignfatebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SkipIntroRealignFate,self.boss,"QUICK\nSTART")
		self.addbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_AddImaginaryPlayer,self.spellbunny,"ADD\nGHOST")
		self.subtractbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SubtractImaginaryPlayer,self.spellbunny,"REMOVE\nGHOST",9)
		self.pallybubblebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_PallyBubble,self.spellbunny,"INVUL\n5 SEC")
		self.brezbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_Brez,self.spellbunny,"ANKH")
		
		XPRACTICE.BossDebugButton.debugbuttonx=XPRACTICE.BossDebugButton.debugbuttonx+52
		self.stopbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_StopEncounter,self.spellbunny,"STOP")
		
	
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		
		-- self.movebosstocenterbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossToCenter,self.spellbunny)
		-- self.movebossupbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossUp,self.spellbunny)
		-- self.movebossdownbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossDown,self.spellbunny)
		--self.setruneresetbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingReset,self.spellbunny,"RNG\nRUNE")
		--self.setruneinitialpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRuneInitialPosition,self.spellbunny,"MOVE\nRUNE")
		--self.setringscrambledirectionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingScrambleDirection,self.spellbunny,"DIR")
		--self.setringwhichrunebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingWhichRune,self.spellbunny,"RUNE")
		
		
		self.rngrunemodebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RNGRuneMode,self.spellbunny,"RNG\nRUNES")
		self.fixedrunemodebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_FixedRuneMode,self.spellbunny,"CUSTOM\nRUNES",9)		
		self.setruneinitialpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRuneInitialPosition,self.spellbunny,"MOVE\nRUNE")
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		--self.randomizeallindicatorsbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RandomizeAllIndicators,self.spellbunny,"RNG\nALL\nGOALS")
		--self.randomizeallindicatorsbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RandomizeAllIndicators,self.spellbunny,"CUSTOM\nGOALS",9)
		self.fixedgoalsbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_FixedGoalMode,self.spellbunny,"FIXED\nGOALS")
		self.customgoalsbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_CustomGoalMode,self.spellbunny,"CUSTOM\nGOALS",9)
		self.setindicatorbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetIndicator,self.spellbunny,"MOVE\nGOAL")
		XPRACTICE.BossDebugButton.debugbuttonx=XPRACTICE.BossDebugButton.debugbuttonx+52
		self.lasersonbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LasersOn,self.spellbunny,"LASER\nON")
		self.lasersoffbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LasersOff,self.spellbunny,"LASER\nOFF")

		
		--self.saveindicatorbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SaveIndicator,self.spellbunny,"SAVE\nGOALS")
		--self.loadindicatorbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LoadIndicator,self.spellbunny,"LOAD\nGOALS")
		
		--								

		
		
		for i=1,#self.bossdebugbuttons do
			self.bossdebugbuttons[i]:SetLockedStartingAlpha(1);self.bossdebugbuttons[i]:EnableMouse(true) --TODO NEXT: --!!!
		end
		

		----self.suppressloadmessage=true 	-- this doesn't work -- buttonclick gets queued for later
		--self.loadindicatorbutton:BossButtonClick()
		if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customgoals)then
			XPRACTICE.FATESCRIBEMULTIPLAYER.LoadCustomGoals(self)
		else
			XPRACTICE.FATESCRIBEMULTIPLAYER.LoadStandardGoals(self)
		end
		
		self.worldmarkercontroller:LoadAll(self,true)
		----self.suppressloadmessage=false
		
		-- local markers={{"REDX",456041},{"PURPLEDIAMOND",456039},{"GREENTRIANGLE",456037},{"YELLOWSTAR",456043},{"SILVERMOON",1014628},{"BLUESQUARE",456035},{"ORANGECIRCLE",1014619},{"WHITESKULL",1014641}}
		-- for i=1,#markers do
			-- local varname="WorldMarker"..markers[i][1].."Position"
			-- if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname])then
				-- obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
				-- obj.displayobject.drawable:SetModelByFileID(markers[i][2])	-- raid_ui_fx_
				-- obj.position=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]
				-- obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
				-- obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0
			-- end
		-- end
		
		
		
		if(self.multiplayer.joinedsolo)then
			self.statuslabel:SetText("You are not in a group!\nJoin a group to enable multiplayer features.",nil)
		end
		
		if(IsRealOfficer("player"))then
			local rings=self.rings
			self.multiplayer:FormatAndSendCustom("PLACEGOALSWITHOUTSAVING",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)			
		end
		
		
	end
	
	
	function class:OnReceiveHello()
		if(IsRealOfficer("player"))then
			local rings=self.rings
			self.multiplayer:FormatAndSendCustom("PLACEGOALSWITHOUTSAVING",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)			
		end
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)


		
		---------------------------------------------------------------
		-- HIT DETECTION
		---------------------------------------------------------------
		
		if(self.player)then
			self.collision:OutOfBoundsCheck()
			self.collision:RingRuneCheck()
			self.collision:SpawnerCollisionCheck()
			self.collision:OrbCollisionCheck()
			self.collision:LineOfDeathCheck()
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
		

		
		for i=#self.orbs,1,-1 do
			if(self.orbs[i].dead)then
				tremove(self.orbs,i)
			end
		end
		
	end
	


	function class:Brez()
		local auras=self.player.combatmodule.auras.deadingame
		if(#auras==0)then 
			self.statuslabel:SetText("You're not dead yet.",3.0)
			return 
		end		
		for i=1,#auras do
			auras[i]:Die()
		end
		self.orbhits=0
		self.playercurrentring=nil
		self.statuslabel:SetText("Rezzed.",3.0)
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
	end
	
	function class:OnRoomUnlock(hostname,noofficers,acknowledge)
		--if(not self.multiplayer.roomlocked)then return end   --this doesn't work: room is ALREADY unlocked
		
		self.orbspawnercontroller:Deactivate()
		
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
		for i=1,#self.rings do
			local ring=self.rings[i]
			ring.active=false
			if(ring.ringindicator)then
				ring.ringindicator:Die()  --REMINDER: always Die instead of Cleanup.  otherwise cleanedup object will still be in environment object list and crash on shutdown.
				ring.ringindicatorvisible=false
			end	
			ring.ringvelocity=0
			ring.scramblerunetimer=0
			ring.realplayercount=0
			ring.ghostplayercount=0
			ring.scrambling=false			
			
			ring.displayobject.drawable:SetAnimation(0)
		end
	end

	function class:OnRoomAlreadyInProgress(sender)
		--TODO NEXT:		
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
	
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.FATESCRIBEMULTIPLAYER.Scenario,"Realign Fate","(Fatescribe Roh-Kalo)")	
end

