do
	local super=XPRACTICE.Scenario
	XPRACTICE.SINSANDSUFFERING.Scenario=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Scenario
	
	
	local FLOORZ=-0.425*(2/3)
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.savedataname="SINSANDSUFFERING"

		self.firstround=true
		self.phaseinprogress=false
		self.phasecomplete=false

		
		self.player=nil
		self.lantern=nil
		self.lanternghost=nil
		self.redx=nil
		self.startbutton=nil
		self.lastmovetime=0
		
		self.events={}
		
	end
	


	function class:Populate()
		super.Populate(self)
		
	
		self.phaseinprogress=false
		
		self.buttongroup={}
		self.buttongroup[1]={}		-- Options/Go
		self.buttongroup[2]={}		-- Restart
		self.buttongroup[3]={}		-- Toggle ghosts
		self.buttongroup[4]={}		-- Continue/Stop
		self.buttongroup[5]={}		-- Hint
		
		self.markers={}
		
		self.sinsofthepast={}
		self.sinpoints={}
		self.sinorb_cosmetics={}
		self.solutionpoints={}
		self.weblines={}
		self.webdots={}
		
		local scenario=self
		local gamemenu=XPRACTICE.GameMenu.new()
		gamemenu:Setup(self.game.environment_gameplay,self.game.SCREEN_WIDTH/2-180/2,self.game.SCREEN_HEIGHT/2-270/2)
		self.gamemenu=gamemenu
		
		local button
		-- ----------------------------------------------------------
		-- ---- BUTTON GROUP 1
		-- ----------------------------------------------------------
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=420,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Options")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 
					if(down)then 					
						self:EnableMouse(false)
						scenario.game:LoadScenarioByClass(XPRACTICE.SINSANDSUFFERING.Scenario_Options)
					end
				end
			end)
		tinsert(self.buttongroup[1],button)			
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Go")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 					
					scenario.timelimit.active=false				
					scenario.phaseinprogress=true
					scenario.phasecomplete=false
					-- must use event function instead of calling click directly
					-- otherwise second click queue will override first
					scenario:ClickButtonAfterDelay(scenario.calculatebutton,0.0)
					--scenario.calculatebutton:BossButtonClick()
					if(not scenario.firstround)then						
						--scenario.sharedsufferingtelegraphbutton:BossButtonClick()
						scenario:ClickButtonAfterDelay(scenario.sharedsufferingtelegraphbutton,0.0)
					end
				end
			end)
		tinsert(self.buttongroup[1],button)
		---------------------------------------------------------
		---- BUTTON GROUP 2
		----------------------------------------------------------
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Restart")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 					
					self:EnableMouse(false)
					scenario.game:LoadScenarioByClass(XPRACTICE.SINSANDSUFFERING.Scenario)
				end
			end)
		tinsert(self.buttongroup[2],button)		
		---------------------------------------------------------
		---- BUTTON GROUP 4
		----------------------------------------------------------					
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2-100,y=320,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Continue")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 										
					scenario.phaseinprogress=true
					scenario.phasecomplete=false
					-- must use event function instead of calling click directly
					-- otherwise second click queue will override first
					scenario:ClickButtonAfterDelay(scenario.calculatebutton,0.0)
					scenario.timelimit.active=false
					--scenario.calculatebutton:BossButtonClick()
					if(not scenario.firstround)then						
						--scenario.sharedsufferingtelegraphbutton:BossButtonClick()
						scenario:ClickButtonAfterDelay(scenario.sharedsufferingtelegraphbutton,0.0)
					end
				end
			end)
		tinsert(self.buttongroup[4],button)			
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2+100,y=320,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Stop")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 		
					scenario.timelimit.active=false				
					scenario.phaseinprogress=false
					scenario.phasecomplete=false
				end
			end)
		tinsert(self.buttongroup[4],button)
		-- ----------------------------------------------------------
		-- ---- BUTTON GROUP 5
		-- ----------------------------------------------------------
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH-25-150,y=25,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Hint")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 
					if(down)then 					
						XPRACTICE.SINSANDSUFFERING.SinsandSuffering_Hint(scenario)
					end
				end
			end)
		tinsert(self.buttongroup[5],button)
		
		
		
		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=150,z=0}
		label:SetSize(600,300)
		label:SetText("")
		self.statuslabel=label


		self.debugbuttonx=self.game.SCREEN_WIDTH/2-25
		self.debugbuttony=104
				
	
		--self:QuickSonar(0,0,0,math.pi)
		
		self.descenttelegraphs={}

		local mob,obj
		local player

		
		--mob=XPRACTICE.Mob.new()
		player=XPRACTICE.PlayerCharacter.new()		
		player:Setup(self.game.environment_gameplay)
		player.displayobject.drawable:SetSheathed(false)
		-- player.orientation.yaw=math.pi*1.5;player.orientation_displayed.yaw=math.pi*1.5
		--player.position={x=0,y=-18,z=0}
		--player.position={x=-20,y=0,z=0}		
		player.position.x=-10
		player.position.y=0
		--facing EAST
		player.orientation.yaw=math.pi*0;player.orientation_displayed.yaw=math.pi*0
		player.scenario=self
		player.enabled=true		-- trick the game into thinking this is the same as a ghost object
		self.player=player
		
		self.ghosts={}
		
		for i=1,2 do
			local ghost
			ghost=XPRACTICE.SINSANDSUFFERING.PlayerGhost.new()
			ghost:Setup(self.game.environment_gameplay)
			ghost.enabled=false
			tinsert(self.ghosts,ghost)
			ghost.scenario=self			
		end
		for i=1,XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount do
			local ghost=self.ghosts[i]
			ghost.enabled=true
			ghost.cpu=true
			local angleoffset
			if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount==1)then
				angleoffset=math.pi
			else
				angleoffset=math.pi*2/3
			end
			local angle=math.pi+angleoffset*i
			ghost.position.x=10*math.cos(angle)
			ghost.position.y=10*math.sin(angle)
			ghost.position.z=5
			ghost:FreezeOrientation(angle+math.pi)
		end
		
		self.sharedsufferingarrows={}
		local arrow=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow2.new()
		arrow:Setup(self.game.environment_gameplay)
		arrow.player=self.player
		tinsert(self.sharedsufferingarrows,arrow)
		--arrow:Activate()
		
		for i=1,2 do
			local arrow=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow1.new()
			arrow:Setup(self.game.environment_gameplay)
			arrow.player=self.ghosts[i]
			tinsert(self.sharedsufferingarrows,arrow)			
			--arrow:Activate()			
		end
		
		local sharedsufferinglinecontroller=XPRACTICE.SINSANDSUFFERING.SharedSufferingLineController.new()
		sharedsufferinglinecontroller.scenario=self
		sharedsufferinglinecontroller:Setup(self.game.environment_gameplay)
		self.sharedsufferinglinecontroller=sharedsufferinglinecontroller
		
		local animaweblinecontroller=XPRACTICE.SINSANDSUFFERING.AnimaWebLineController.new()
		animaweblinecontroller.scenario=self
		animaweblinecontroller:Setup(self.game.environment_gameplay)
		self.animaweblinecontroller=animaweblinecontroller
		

		self.game.environment_gameplay.cameramanager.camera.focus=player
		self.game.environment_gameplay.cameramanager.camera.orientation.yaw=player.orientation.yaw
		self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05
		self.game.environment_gameplay.cameramanager.camera.cdist=30
		
		--self.game.environment_gameplay.modelsceneframe:SetLightAmbientColor(0.5,0.5,1,1)			
		--self.game.environment_gameplay.modelsceneframe:SetLightDiffuseColor(0.5,0.5,1,1)
		
		
		--TODO: move elsewhere
		local maincastingbar=XPRACTICE.CastingBar.new()
		self.maincastingbar=maincastingbar
		maincastingbar:Setup(self.game.environment_gameplay)
		maincastingbar.position={x=self.game.SCREEN_WIDTH/2-196/2,y=150,z=0}
		maincastingbar.focus=player
		
		
		
		local controller=XPRACTICE.PlayerController.new()
		controller:Setup(self.game.environment_gameplay,player,self.game.environment_gameplay.cameramanager.camera)



		local floorobj
		floorobj=XPRACTICE.WoWObject.new()
		floorobj:Setup(self.game.environment_gameplay)		
		--floorobj.displayobject.drawable:SetModelByFileID(1829551)	--8du_nazmirraid_elevator01
		--floorobj.position={x=0,y=0,z=0}
		floorobj.displayobject.drawable:SetModelByFileID(1591934)	--7du_tombofsargeras_councilfloor01
		floorobj.position={x=0,y=0,z=FLOORZ}
		floorobj.scale=2
		floorobj.visiblefromallphases=true		
				
	
		-- local testobj
		-- testobj=XPRACTICE.WoWObject.new()
		-- testobj:Setup(self.game.environment_gameplay)		
		-- testobj.displayobject.drawable:SetModelByFileID(3581780)	--9fx_raid1_sommelier_sharedsuffering_orb (0,158,159)
		-- testobj.position={x=0,y=0,z=-0.425*(2/3)}
		
		-- local testobj
		-- testobj=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow2.new()
		-- testobj:Setup(self.game.environment_gameplay)		
		-- testobj.position={x=0,y=0,z=0}



		--mob=XPRACTICE.Mob.new()
		darkvein=XPRACTICE.SINSANDSUFFERING.LadyInervaDarkvein.new()
		darkvein:Setup(self.game.environment_gameplay)
		darkvein.displayobject.drawable:SetSheathed(false)
		-- darkvein.orientation.yaw=math.pi*1.5;darkvein.orientation_displayed.yaw=math.pi*1.5
		--darkvein.position={x=0,y=-18,z=0}
		--darkvein.position={x=-20,y=0,z=0}		
		darkvein.position.x=0
		darkvein.position.y=0
		--facing WEST
		darkvein.orientation.yaw=math.pi*1;darkvein.orientation_displayed.yaw=math.pi*1
		darkvein.scenario=self
		self.darkvein=darkvein
		-- local nameplate=XPRACTICE.Nameplate.new()
		-- nameplate:Setup(self.game.environment_gameplay,darkvein)
		-- nameplate:SetText("Lady Inerva Darkvein")
		-- local castingbar=XPRACTICE.CastingBarTiny.new()
		-- castingbar:Setup(self.game.environment_gameplay,0,0,0)
		-- castingbar.focus=darkvein
		-- castingbar:AnchorToNameplate(nameplate)
		-- local mobclickzone=XPRACTICE.MobClickZone.new()
		-- mobclickzone:Setup(self.game.environment_gameplay,darkvein)	
		

		local timelimit=XPRACTICE.SINSANDSUFFERING.TimeLimit.new()
		timelimit:Setup(self.game.environment_gameplay)
		timelimit.position.x=self.game.SCREEN_WIDTH-125
		timelimit.position.y=self.game.SCREEN_HEIGHT-125
		timelimit.scenario=self
		self.timelimit=timelimit

		
		local scenario=self
		
		



		----extra action button...
		local spell_toggleghost={}		
		local toggleghostbutton={}
		self.spell_toggleghost=spell_toggleghost
		self.toggleghostbutton=toggleghostbutton
		local buttonx		
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount==1)then
			buttonx=self.game.SCREEN_WIDTH/2-25
		else
			-- we want button 2 to appear by itself, or to the LEFT of button 1
			buttonx=self.game.SCREEN_WIDTH/2
		end
		--TODO LATER: this is absolutely not the right way to go about this
		for i=XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount+1,2 do
			spell_toggleghost[i]=XPRACTICE.SINSANDSUFFERING.Spell_ToggleGhost[i].new()		
			spell_toggleghost[i].ghost=self.ghosts[i]			
			spell_toggleghost[i].scenario=self
			spell_toggleghost[i]:Setup(self.player.combatmodule)
			
			self.spell_toggleghost[i]=spell_toggleghost[i]
			
			
			toggleghostbutton[i]=XPRACTICE.ExtraActionButton.new()						
			toggleghostbutton[i]:Setup(self.game.environment_gameplay)
			toggleghostbutton[i]:SetIcon(spell_toggleghost[i]:GetIcon())
			--toggleghostbutton[i]:SetExtraBorderSize(256,128)
			--toggleghostbutton[i]:SetLockedStartingAlpha(0)
			toggleghostbutton[i]:SetLockedStartingAlpha(1) --!!!
			self.toggleghostbutton[i]=toggleghostbutton[i]
			spell_toggleghost[i].button=toggleghostbutton[i]
			-- do not setextrabordericon
			toggleghostbutton[i].position={x=buttonx,y=75,z=0}
			buttonx=buttonx-50
			toggleghostbutton[i].displayobject.drawable:SetScript("OnClick",function(self,button,down)
					if(button=="LeftButton" and down)then 		
						--if(scenario.azerothsradianceavailable)then
							--scenario.azerothsradianceavailable=false
							local queuepointer=scenario.spell_toggleghost[i]:NewQueue()
							queuepointer.castercombat=scenario.player.combatmodule
							local errorcode=scenario.player.combatmodule:TryQueue(queuepointer)
						--end
					end
				end)
			tinsert(self.buttongroup[3],toggleghostbutton[i])
		end


		XPRACTICE.BossDebugButton.ResetPosition()
		self.bossdebugbuttons={}
		
		local button
		
		self.calculatebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Calculate,self.darkvein)
		self.projectilesbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Projectiles,self.darkvein)
		self.spawnbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Spawn,self.darkvein)
		self.sharedsufferingtelegraphbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Telegraph,self.darkvein)
		self.sharedsufferingknockbackbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Knockback,self.darkvein)
		self.sharedsufferinglinkbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Link,self.darkvein)
		self.moveghostsbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_MoveGhosts,self.darkvein)
		self.announcerolebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_AnnounceRole,self.darkvein)
		self.allghostsoffbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_AllPlayerGhostsOff,self.darkvein)
		
		XPRACTICE.BossDebugButton.CarriageReturn()
		self.spawnbutton2=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Spawn,self.darkvein)
		XPRACTICE.BossDebugButton.CarriageReturn()
		self.animawebbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_AnimaWeb,self.darkvein)
		-- XPRACTICE.BossDebugButton.CarriageReturn()
		-- self.endphasebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.SINSANDSUFFERING.Spell_EndPhase,self.darkvein)		

		

		

	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)

		---------------------------------------------------------------
		--ORB HIT DETECTION
		---------------------------------------------------------------
		if(self.sharedsufferinglinecontroller and self.sharedsufferinglinecontroller.enabled)then
			if(self.player)then
				if((not(self.player.velocity.x==0 and self.player.velocity.y==0 and self.player.velocity.z==0))
				or (not(self.ghosts[1].velocity.x==0 and self.ghosts[1].velocity.y==0 and self.ghosts[1].velocity.z==0))
				or (not(self.ghosts[2].velocity.x==0 and self.ghosts[2].velocity.y==0 and self.ghosts[2].velocity.z==0))
				)then
		 			self.lastmovetime=self.game.environment_gameplay.localtime
				end
				if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.RecognitionDelay==-1 or self.game.environment_gameplay.localtime>=self.lastmovetime+XPRACTICE_SAVEDATA.SINSANDSUFFERING.RecognitionDelay)then
					local pointtotal=#self.sinpoints
					if(pointtotal>0)then
						local pointsremaining=pointtotal
						for i=1,pointtotal do
							for j=1,#self.sharedsufferinglinecontroller.lines do
								local line=self.sharedsufferinglinecontroller.lines[j]
								if(line.enabled)then
									local p=self.sinpoints[i]
									local l=line.linesegment
									local distsqr=XPRACTICE.PointLineDistSqr(p.x,p.y,l.x1,l.y1,l.x2,l.y2)
									local ORBRADIUS=XPRACTICE_SAVEDATA.SINSANDSUFFERING.HitDetectOrbDistance
									if(distsqr<=ORBRADIUS*ORBRADIUS)then
										pointsremaining=pointsremaining-1
										break	-- must break, otherwise a point can count twice if two lines overlap
									end
								end
							end
						end
						
						if(pointsremaining==0)then
							self.sharedsufferinglinecontroller:Deactivate()
							self.animaweblinecontroller:Deactivate()
							self:DeleteOrbsAndShadows()
							self.timelimit:StopTimer()
							self:ClickButtonAfterDelay(self.allghostsoffbutton,1.0)
							self.phaseinprogress=false
							self.phasecomplete=true
						end
					end
				end
			end
		end

		---------------------------------------------------------------
		--ANIMA WEB CHECK
		---------------------------------------------------------------
		if(self.animaweblinecontroller and self.player and not self.player:IsDeadInGame())then
			if(self.animaweblinecontroller.enabled)then
				--TODO LATER: it is almost certainly possible to roll through a line unharmed at low framerate
				for i=1,4 do
					local line=self.animaweblinecontroller.weblines[i]
					if(line.length>0)then
						if(XPRACTICE.LineCircleCollision(line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2,
								self.player.position.x,self.player.position.y,XPRACTICE_SAVEDATA.SINSANDSUFFERING.HitDetectWebDistance))then
							self.timelimit:StopTimer()
							local aura=self.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,self.player.combatmodule,self.localtime)
							local link="\124cffff0000\124Hspell:339612\124h[Anima Web]\124h\124r"			
							self.statuslabel:SetText("You died from "..link..".",3.0)
							break
						end
					end
				end
			end
		end

		---------------------------------------------------------------
		--OUT OF BOUNDS CHECK
		---------------------------------------------------------------
		if(self.player)then
			local distsqr=self.player.position.x*self.player.position.x+self.player.position.y*self.player.position.y
			local dist=math.sqrt(distsqr)
			--print("Player dist:",dist)
			local maxradius=53
			if(dist>maxradius)then
				local unitvectorx=self.player.position.x/dist
				local unitvectory=self.player.position.y/dist
				
				self.player.position.x=unitvectorx*maxradius
				self.player.position.y=unitvectory*maxradius
			end
		end
		
		------------------------------------------------------------------------------
		-- MENU BUTTONS
		------------------------------------------------------------------------------	
		--TODO LATER: clean up logic mess
		local visiblegroup=1
		if(self.phaseinprogress)then
			visiblegroup=0
		end
		if(self.phasecomplete)then
			visiblegroup=4
		end
		if(self.player and (self.player:IsDeadInGame()))then
			visiblegroup=2
		end
		for i=1,4 do
			if(i==visiblegroup)then
				self:EnableButtons(self.buttongroup[i],true)
			else
				self:EnableButtons(self.buttongroup[i],false)
			end
		end
		if(self.player and (self.player:IsDeadInGame()))then
			self:EnableButtons(self.buttongroup[3],false)
		else
			self:EnableButtons(self.buttongroup[3],true)
		end		
		--if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.EnableHints and self.phaseinprogress and #self.solutionpoints>0 and not self.phasecomplete)then
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.EnableHints and self.sharedsufferinglinecontroller.enabled)then
			self:EnableButtons(self.buttongroup[5],true)
		else
			self:EnableButtons(self.buttongroup[5],false)
		end			
		
		------------------------------------------------------------------------------
		-- TIMED EVENTS
		------------------------------------------------------------------------------	
		-- process this loop forward so events are executed in the order they are queued
		for i=1,#self.events do
			local event=self.events[i]
			if(self.game.environment_gameplay.localtime>=event.time)then
				--print("event",event)
				event.button:BossButtonClick()				
				event.dead=true
				--TODO LATER: due to the way spell queues are currently set up, queueing up two buttons on the same frame will overwrite the former
				-- so for now, we break to limit one event per frame
				break
			end
		end
		-- removal loop goes backward as usual
		for i=#self.events,1,-1 do
			if(self.events[i].dead)then
				tremove(self.events,i)
			end
		end
	end

	function class:EnableButtons(buttongroup,toggle)
		for i=1,#buttongroup do
			local button=buttongroup[i]
			if(toggle)then
				button.displayobject.drawable:SetAlpha(1)
			else
				button.displayobject.drawable:SetAlpha(0)
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
	
	function class:DeleteGoalPortal()
		if(self.goalportal)then
			self.goalportal:FadeOut()
		end
		self.goalportal=nil
		for i=1,#self.voidwokestates do
			local voidwokestate=self.voidwokestates[i]
			voidwokestate.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		end
		self.voidwokestates={}
	end
	
	function class:ClearGhostPositions()
		self.ghostpositionsCW={}
		self.ghostorientationsCW={}
		self.ghostpositionsCCW={}
		self.ghostorientationsCCW={}
	end
	
	function class:DeleteGhosts()
		for i=1,#self.ghosts do
			local ghost=self.ghosts[i]
			ghost.expirytime=self.game.environment_gameplay.localtime+2.0
			ghost.fadestarttime=self.game.environment_gameplay.localtime
		end
		self.ghosts={}
	end
	
	function class:DeleteOrbsAndShadows()
		for i=1,#self.sinorb_cosmetics do
			local obj=self.sinorb_cosmetics[i]
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		end
		self.sinorb_cosmetics={}
	end
	

	function class:DeleteMarkers()
		for i=1,#self.markers do
			local marker=self.markers[i]
			marker.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		end
		self.markers={}	
	end

	
	function class:QuickMarker1(x,y)
		local obj
		obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay,x,y,FLOORZ)		
		obj.displayobject.drawable:SetModelByFileID(456041)	-- raid_ui_fx_red
		obj.scale=1
		obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)		
		obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0		
		tinsert(self.markers,obj)
	end

	function class:QuickMarker2(x,y)
		local obj
		obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay,x,y,FLOORZ)		
		obj.displayobject.drawable:SetModelByFileID(3581780)	--9fx_raid1_sommelier_sharedsuffering_orb (0,158,159)
		obj.scale=2
		obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)		
		obj.projectilespawncustomduration=1.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=1.0
		tinsert(self.markers,obj)
	end

	
	function class:QuickEnemyGhost(x,y,z)
		local ghost=XPRACTICE.SINSANDSUFFERING.EnemyGhost.new()
		ghost:Setup(self.game.environment_gameplay)
		ghost.position={x=x,y=y,z=z}
		ghost.orientation_displayed.yaw=math.random()*math.pi*2;ghost.orientation.yaw=ghost.orientation_displayed.yaw
		ghost.scenario=self		

		self:QuickDeadlyDescent(ghost)
	end



	function class:ClickButtonAfterDelay(button,delay)
		--self.nexteventtime=self.game.environment_gameplay.localtime+delay
		--self.nexteventbutton=button
		local event={}
		event.button=button
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
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
					--TODO: cancel aura from playercharacter.lua (and not at the same time as deselect target)
					local auras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.SINSANDSUFFERING.Aura_DropBloodLantern)
					if(#auras>0)then
						local aura=auras[1]
						aura:Die()
						ok=false
					end
				end
				if(ok)then
					self.gamemenu:Show()
				end
			end
		end
	end	
	
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.SINSANDSUFFERING.Scenario,"Sins and Suffering","(Lady Inerva Darkvein)")
end

