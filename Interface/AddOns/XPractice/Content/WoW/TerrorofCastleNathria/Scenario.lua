do
	local super=XPRACTICE.Scenario
	XPRACTICE.TERROROFCASTLENATHRIA.Scenario=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Scenario
	
	
	XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE={}
	XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR=1
	XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL=2
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		
		self.savedataname="TERROROFCASTLENATHRIA"
		self.phaseinprogress=false
		
		-- self.buttonphase=1	--1: group/direction buttons
							-- --2: go button
							-- --3: no buttons
							-- --4: pause button
		-- self.playergroup=0
		-- self.orbmovement=0
		-- self.useguidelines=0
		-- self.useghosts=false 
		-- self.xaneshstandstilltimer=0
		-- self.soakstatus=0	--0: nothing to soak yet
							-- --1: unsuccessful soak
							-- --2: successful soak
		
		self.player=nil
		self.lantern=nil
		self.lanternghost=nil
		self.redx=nil
		self.startbutton=nil
		
		self.adjustdifficultysuggestion=true
		
		self.nexteventtime=nil
		self.nexteventbutton=nil
	end
	
	

	function class:Populate()
		super.Populate(self)
		
	
		self.phaseinprogress=false
		
		self.buttongroup={}
		self.buttongroup[1]={}		-- Heroic/Mythic/Advanced options/Go
		self.buttongroup[2]={}		-- Restart
		
		local scenario=self
		local gamemenu=XPRACTICE.GameMenu.new()
		gamemenu:Setup(self.game.environment_gameplay,self.game.SCREEN_WIDTH/2-180/2,self.game.SCREEN_HEIGHT/2-270/2)
		self.gamemenu=gamemenu
		
		----------------------------------------------------------
		---- BUTTON GROUP 1
		----------------------------------------------------------
		local button
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=475,y=500,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Heroic")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					scenario:SetHeroic()
				end
			end)
		tinsert(self.buttongroup[1],button)
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=475+180,y=500,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Mythic")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					scenario:SetMythic()
				end
			end)
		tinsert(self.buttongroup[1],button)		
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-300/2,y=420,z=0}
		button:SetSize(300,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Advanced Options")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					self:EnableMouse(false)
					scenario.game:LoadScenarioByClass(XPRACTICE.TERROROFCASTLENATHRIA.Scenario_Options)
				end
			end)
		tinsert(self.buttongroup[1],button)			
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Go!")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					scenario.startbutton:BossButtonClick()
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
				if(button=="LeftButton" and down)then 					
					self:EnableMouse(false)
					scenario.game:LoadScenarioByClass(XPRACTICE.TERROROFCASTLENATHRIA.Scenario)
				end
			end)
		tinsert(self.buttongroup[2],button)				
		
		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=150,z=0}
		label:SetSize(600,300)
		label:SetText("")
		self.statuslabel=label


		self.debugbuttonx=self.game.SCREEN_WIDTH/2-25
		self.debugbuttony=104
				
		self.sonars={}
		
		--self:QuickSonar(0,0,0,math.pi)
		
		self.descenttelegraphs={}

		local mob,obj
		local player
		
		local xmod,ymod
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==2)then ymod=1 else ymod=-1 end
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==4)then xmod=-1 else xmod=1 end	
		
		
		--mob=XPRACTICE.Mob.new()
		player=XPRACTICE.PlayerCharacter.new()
		player:Setup(self.game.environment_gameplay)
		player.displayobject.drawable:SetSheathed(false)
		-- player.orientation.yaw=math.pi*1.5;player.orientation_displayed.yaw=math.pi*1.5
		--player.position={x=0,y=-18,z=0}
		--player.position={x=-20,y=0,z=0}		
		player.position.x=xmod*(7+XPRACTICE.Config.Shriekwing.PillarEWDistance)
		player.position.y=ymod*(7+XPRACTICE.Config.Shriekwing.PillarNSDistance)
		----facing EAST
		--player.orientation.yaw=math.pi*0;player.orientation_displayed.yaw=math.pi*0
		player.orientation.yaw=math.atan2(-player.position.y,-player.position.x)
		player.scenario=self
		self.player=player
		
		local auratracker=XPRACTICE.AuraTracker.new()
		auratracker:Setup(self.game.environment_gameplay)
		auratracker.focus=player
		auratracker.position.x=self.game.SCREEN_WIDTH/2-85
		auratracker.position.y=150
		auratracker.trackedauraclass=XPRACTICE.TERROROFCASTLENATHRIA.Aura_Bloodlight
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty==1)then
			self:SetHeroic()
		else
			self:SetMythic()
		end
		


		local lossofcontrolalert=XPRACTICE.LossOfControlAlert.new()
		self.lossofcontrolalert=lossofcontrolalert
		lossofcontrolalert:Setup(self.game.environment_gameplay)
		lossofcontrolalert.position={x=self.game.SCREEN_WIDTH/2-180/2,y=self.game.SCREEN_HEIGHT/2,z=0}
		lossofcontrolalert.focus=player
		
		

		self.game.environment_gameplay.cameramanager.camera.focus=player
		self.game.environment_gameplay.cameramanager.camera.orientation.yaw=player.orientation.yaw
		self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05
		self.game.environment_gameplay.cameramanager.camera.cdist=30
		
		----TODO: adjust lighting
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




		local shriekwing
		shriekwing=XPRACTICE.TERROROFCASTLENATHRIA.Shriekwing.new()		
		shriekwing:Setup(self.game.environment_gameplay)		
		shriekwing.position={x=20,y=0,z=0}
		--facing WEST
		shriekwing.orientation.yaw=math.pi;shriekwing.orientation_displayed.yaw=math.pi
		shriekwing.scenario=self
		self.shriekwing=shriekwing
		---- Shriekwing can't be targeted in phase 2!		
		local nameplate=XPRACTICE.Nameplate.new()
		nameplate:Setup(self.game.environment_gameplay,shriekwing)
		nameplate:SetText("Shriekwing")
		local castingbar=XPRACTICE.CastingBarTiny.new()
		castingbar:Setup(self.game.environment_gameplay,0,0,0)
		castingbar.focus=shriekwing
		castingbar:AnchorToNameplate(nameplate)
		
		
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(self.game.environment_gameplay,shriekwing)		
		shriekwing.walking=true
		--shriekwing.ai.targetposition={x=-15,y=0,z=0}
		shriekwing.ai.changeorientationtomovementdirection=true
		--shriekwing.ai.targetposition={x=0,y=30,z=0}
		--shriekwing.ai.targetposition={x=30,y=30,z=0}
				


		local floorobj
		floorobj=XPRACTICE.WoWObject.new()
		floorobj:Setup(self.game.environment_gameplay)		
		--floorobj.displayobject.drawable:SetModelByFileID(1829551)	--8du_nazmirraid_elevator01
		--floorobj.position={x=0,y=0,z=0}
		floorobj.displayobject.drawable:SetModelByFileID(1591934)	--7du_tombofsargeras_councilfloor01
		floorobj.position={x=0,y=0,z=-0.425}
		floorobj.scale=3		
		floorobj.visiblefromallphases=true		
				
	
		
		self.lines={}
		self.outsidecorners={}
		self.pillars={}
		--counterclockwise so normals face inward!
		---- at HZRADIUS>60, particle trail breaks down.  need 2 lines.
		--TODO: don't need 2 separate collision detection lines.  separate collision detection lines from drawn lines.
		local HZRADIUS=XPRACTICE.Config.Shriekwing.RoomEWRadius
		local VTRADIUS=XPRACTICE.Config.Shriekwing.RoomNSRadius
		--bottom
		self:QuickCollisionLine(-HZRADIUS,-VTRADIUS,0,HZRADIUS,-VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)	
		self:QuickVisibleLine(-HZRADIUS,-VTRADIUS,0,0,-VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)
		self:QuickVisibleLine(0,-VTRADIUS,0,HZRADIUS,-VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)		
		--right
		self:QuickLine(HZRADIUS,-VTRADIUS,0,HZRADIUS,VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)
		--top
		self:QuickCollisionLine(HZRADIUS,VTRADIUS,0,-HZRADIUS,VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)		
		self:QuickVisibleLine(HZRADIUS,VTRADIUS,0,0,VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)
		self:QuickVisibleLine(0,VTRADIUS,0,-HZRADIUS,VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)		
		--left
		self:QuickLine(-HZRADIUS,VTRADIUS,0,-HZRADIUS,-VTRADIUS,0,true,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)
		
		
		
		local HZRADIUS=XPRACTICE.Config.Shriekwing.PillarEWDistance
		local VTRADIUS=XPRACTICE.Config.Shriekwing.PillarNSDistance
		self:QuickPillar(-HZRADIUS,-VTRADIUS,0)
		self:QuickPillar(-HZRADIUS,VTRADIUS,0)
		self:QuickPillar(HZRADIUS,-VTRADIUS,0)
		self:QuickPillar(HZRADIUS,VTRADIUS,0)




		
		local scenario=self
		
		
		----extra action button...
		local spell_dropbloodlantern=XPRACTICE.TERROROFCASTLENATHRIA.Spell_DropBloodLantern.new()		
		spell_dropbloodlantern:Setup(self.player.combatmodule)
		self.spell_dropbloodlantern=spell_dropbloodlantern
		local bloodlanternbutton
		bloodlanternbutton=XPRACTICE.ExtraActionButton.new()						
		bloodlanternbutton:Setup(self.game.environment_gameplay)
		bloodlanternbutton:SetIcon(spell_dropbloodlantern:GetIcon())
		bloodlanternbutton:SetExtraBorderSize(256,128)
		bloodlanternbutton:SetLockedStartingAlpha(0)
		self.bloodlanternbutton=bloodlanternbutton
		if(XPRACTICE.TOCVersion>=90002)then			
			bloodlanternbutton:SetExtraBorderIcon("interface/extrabutton/venthyr-extrabutton.blp")			 -- curiously, this file is missing from PTR builds
		else
			bloodlanternbutton:SetExtraBorderIcon("interface/extrabutton/default.blp")
		end
		bloodlanternbutton.position={x=self.game.SCREEN_WIDTH/2-25,y=75,z=0}
		bloodlanternbutton.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 		
					--if(scenario.azerothsradianceavailable)then
						--scenario.azerothsradianceavailable=false
						local queuepointer=scenario.spell_dropbloodlantern:NewQueue()
						queuepointer.castercombat=scenario.player.combatmodule
						local errorcode=scenario.player.combatmodule:TryQueue(queuepointer)
					--end
				end
			end)
		
		-- local debugsonar=XPRACTICE.TERROROFCASTLENATHRIA.EchoingSonarProjectile.new()
		-- debugsonar.scenario=self
		-- XPRACTICE.Config.Shriekwing.SonarSpeed=0	-- for debug only
		-- debugsonar:Setup(self.game.environment_gameplay)	
		-- tinsert(self.sonars,debugsonar)
		
		


		XPRACTICE.BossDebugButton.ResetPosition()
		self.bossdebugbuttons={}
		
		local button
		
		self.startbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_BloodShroudTeleport,self.shriekwing)
		self.bloodshroudbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_BloodShroud,self.shriekwing)
		self.echoingsonarbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_EchoingSonar,self.shriekwing)
		self.sonarshriekbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_SonarShriek,self.shriekwing)
		XPRACTICE.BossDebugButton.CarriageReturn()
		button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingCounterclockwise,self.shriekwing)
		button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingWest,self.shriekwing)
		button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingSouth,self.shriekwing)
		button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingNorth,self.shriekwing)
		button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingEast,self.shriekwing)
		button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingClockwise,self.shriekwing)
		self.moveshriekwingbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingAuto,self.shriekwing)
		XPRACTICE.BossDebugButton.CarriageReturn()
		self.endphasebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.TERROROFCASTLENATHRIA.Spell_EndPhase,self.shriekwing)		

		-- Debug LOS indicators
		self.loslines={}
		if(XPRACTICE.Config.Shriekwing.ShriekLOSVisibility)then
			local line=XPRACTICE.VisibleLine.new()
			line:Setup(self.game.environment_gameplay,0,0,0,0,0,0)
			line.visible=true
			self.loslines[1]=line
			if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekLOSEdges)then
				local line=XPRACTICE.VisibleLine.new()
				line:Setup(self.game.environment_gameplay,0,0,0,0,0,0)
				line.visible=true
				self.loslines[2]=line
				local line=XPRACTICE.VisibleLine.new()
				line:Setup(self.game.environment_gameplay,0,0,0,0,0,0)
				line.visible=true
				self.loslines[3]=line
			end
		end
		

		

	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)

		------------------------------------------------------------------------------
		-- EXTRA ACTION BUTTON
		------------------------------------------------------------------------------
		if(self.lantern and self.bloodlanternbutton)then
			if(self.lantern.carriermob==self.player and not self.player:IsIncapacitated())then
				self.bloodlanternbutton.targetalpha=1
				self.bloodlanternbutton.displayobject.drawable:EnableMouse(true)
			else
				self.bloodlanternbutton.targetalpha=0
				self.bloodlanternbutton.displayobject.drawable:EnableMouse(false)
			end
		else
			self.bloodlanternbutton.targetalpha=0
			self.bloodlanternbutton.displayobject.drawable:EnableMouse(false)
		end
		
		------------------------------------------------------------------------------
		-- SONAR VISIBILITY
		------------------------------------------------------------------------------
		local SONARALPHARATE=2
		if(self.sonarvisible)then
			if(self.sonaralpha<1)then
				self.sonaralpha=self.sonaralpha+elapsed*SONARALPHARATE
				if(self.sonaralpha>=1)then self.sonaralpha=1 end
				for i=1,#self.sonars do
					self.sonars[i].alpha=self.sonaralpha
				end
			end			
		else
			if(self.sonaralpha>0)then
				self.sonaralpha=self.sonaralpha-elapsed*SONARALPHARATE
				if(self.sonaralpha<=0)then self.sonaralpha=0 end
				for i=1,#self.sonars do
					self.sonars[i].alpha=self.sonaralpha
				end
			end
		end
		
		
		-- if(self.player)then
			-- local distsqr=self.player.position.x*self.player.position.x+self.player.position.y*self.player.position.y
			-- local dist=math.sqrt(distsqr)
			-- local maxradius=24
			-- if(dist>maxradius)then
				-- local unitvectorx=self.player.position.x/dist
				-- local unitvectory=self.player.position.y/dist
				
				-- self.player.position.x=unitvectorx*maxradius
				-- self.player.position.y=unitvectory*maxradius
			-- end
		-- end
		
		------------------------------------------------------------------------------
		-- SONAR/PLAYER HIT DETECTION and GHOST GENERATION
		------------------------------------------------------------------------------
		if(self.player)then
			if(not self.player:IsDeadInGame())then
				local descentauras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_GracePeriod)
				if(#descentauras==0)then
					local scalemodifier=1+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarProjectileSize*XPRACTICE.Config.Shriekwing.SonarSavedataSizeMultiplier
					local RADIUS
					RADIUS=XPRACTICE.Config.Shriekwing.SonarPlayerCollisionRadiusStandard
					if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarForgiving==false)then
						RADIUS=XPRACTICE.Config.Shriekwing.SonarPlayerCollisionRadiusDifficult
					end
					local GHOSTRADIUS=XPRACTICE.Config.Shriekwing.EnemyGhostRadius				
							
					for i=1,#self.sonars do
						local sonar=self.sonars[i]
						local distsqr=XPRACTICE.distsqr(self.player.position.x,self.player.position.y,sonar.position.x,sonar.position.y)
						if(distsqr<RADIUS*RADIUS)then						
							self:QuickDeadlyDescent(self.player)
						end
						if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EnemyGhosts>0)then
							if(sonar.localtime>=sonar.nextghosttime)then
								local rate=XPRACTICE.Config.Shriekwing.EnemyGhostSonarRate
								if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EnemyGhosts==1)then
									rate=rate/3.0
								end							
								if(math.random()<rate)then
									if(distsqr<GHOSTRADIUS*GHOSTRADIUS)then	
										sonar.nextghosttime=sonar.localtime+XPRACTICE.Config.Shriekwing.EnemyGhostSonarCooldown
										self:QuickEnemyGhost(sonar.position.x,sonar.position.y,0)
									end
								end
							end
						end
					end
				end
			end
		end
		------------------------------------------------------------------------------
		-- SONAR/LANTERN HIT DETECTION
		------------------------------------------------------------------------------		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ExtraLanternHazards==true)then
			local lantern=self.lantern
			if(lantern and (lantern.previouscarriermob==nil or lantern.previouscarriermob==self.player))then
				if(not lantern.carried)then			
					local scalemodifier=1+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarProjectileSize*0.25
					local RADIUS
					RADIUS=XPRACTICE.Config.Shriekwing.SonarPlayerCollisionRadiusStandard
					if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarForgiving==false)then
						RADIUS=XPRACTICE.Config.Shriekwing.SonarPlayerCollisionRadiusDifficult
					end
					for i=1,#self.sonars do
						local sonar=self.sonars[i]
						local distsqr=XPRACTICE.distsqr(lantern.position.x,lantern.position.y,sonar.position.x,sonar.position.y)
						if(distsqr<=RADIUS*RADIUS)then
							self.lantern.carried=false
							self.lantern:Die()
							self.lantern=nil
							local player=self.player
							if(player and not self.player:IsDeadInGame())then
								local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.TERROROFCASTLENATHRIA.Aura_LanternBroken_Horrified,player.combatmodule,self.localtime)
								local feareffect=XPRACTICE.TERROROFCASTLENATHRIA.OverheadFearEffect.new()
								feareffect:Setup(player.environment,player.position.x,player.position.y,1)
								feareffect.projectileloopcustomduration=5.0-0.25
								feareffect.player=player
								self.statuslabel:SetText("The Blood Lantern shattered!",4.0)
							end
						end
					end
				end
			end
		end
	
		

		
		if(self.player)then
			------------------------------------------------------------------------------
			-- WALL/PILLAR HIT DETECTION
			------------------------------------------------------------------------------
			local RADIUS=XPRACTICE.Config.Shriekwing.PlayerObjectCollisionRadius
			--TODO: maybe check outsidecorner collisions too?
			for i=1,#self.lines do
				local line=self.lines[i]
				local distsqr=XPRACTICE.PointLineDistSqr(self.player.position.x,self.player.position.y,line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2)
				if(distsqr<RADIUS*RADIUS) then					
					local yaw=math.atan2(self.player.velocity.y,self.player.velocity.x)
					local difference=XPRACTICE.AngleDifference(yaw,line.normal2d)
					--print("Collision yaw",yaw,"normal",line.normal2d,"difference",difference)
					if(math.abs(difference)>math.pi/2)then
						local dist=math.sqrt(distsqr)
						local adjustment=RADIUS-dist
						self.player.position.x=self.player.position.x+math.cos(line.normal2d)*adjustment
						self.player.position.y=self.player.position.y+math.sin(line.normal2d)*adjustment
					end
				end
			end
			
			------------------------------------------------------------------------------
			-- PLAYER DIST FROM CENTER
			------------------------------------------------------------------------------
			local distsqr=self.player.position.x*self.player.position.x+self.player.position.y*self.player.position.y
			local dist=math.sqrt(distsqr)
			--print("Player dist from center:",dist)
			
			------------------------------------------------------------------------------
			-- SHRIEK LOS VISIBILITY
			------------------------------------------------------------------------------
			if(XPRACTICE.Config.Shriekwing.ShriekLOSVisibility==true and self.player and self.shriekwing)then
				local loslines=self:GetShriekLOSLines(self.player)
				for i=1,#loslines do
					self.loslines[i].linesegment={x1=loslines[i].x1,y1=loslines[i].y1,z1=loslines[i].z1,x2=loslines[i].x2,y2=loslines[i].y2,z2=loslines[i].z2}
					local collision=self:LOSLineCollisionTest(self.loslines[i].linesegment)
					if(collision)then
						--self.loslines[i]:ChangeLineActorID(166497,0,0)
						self.loslines[i]:ChangeLineActorID(166254,0,0)						
						--self.loslines[i]:ChangeLineActorID(604738,0,0)
					else
						--self.loslines[i]:ChangeLineActorID(530068,0.35,0)
						self.loslines[i]:ChangeLineActorID(166497,0,0)
						--self.loslines[i]:ChangeLineActorID(604834,0,0)
					end	
				end
			end
		end		
		
		------------------------------------------------------------------------------
		-- MENU BUTTONS
		------------------------------------------------------------------------------	
		local visiblegroup=1
		if(self.phaseinprogress)then
			visiblegroup=0
		end
		if(self.player and (self.player:IsDeadInGame()))then
			visiblegroup=2
		end
		for i=1,2 do
			if(i==visiblegroup)then
				self:EnableButtons(self.buttongroup[i],true)
			else
				self:EnableButtons(self.buttongroup[i],false)
			end
		end
		
		
		------------------------------------------------------------------------------
		-- TIMED EVENTS
		------------------------------------------------------------------------------	
		if(self.nexteventtime and self.nexteventbutton)then
			if(self.game.environment_gameplay.localtime>=self.nexteventtime)then
				self.nexteventbutton:BossButtonClick()
				self.nexteventtime=nil
				self.nexteventbutton=nil
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
	

	function class:SpawnVoidRitualSoaks()
		self.paused=false
		self.pausebutton:Select(false)
		self.pausebutton:SetText("Pause")
		local obj
		for i=1,3 do
			obj=XPRACTICE.TERROROFCASTLENATHRIA.VoidRitualSoak.new()
			obj:Setup(self.game.environment_gameplay)		
			local angle=self.xanesh.orientation_displayed.yaw
			local x=self.xanesh.position.x+6*math.cos(math.pi/2*i+angle)
			local y=self.xanesh.position.y+6*math.sin(math.pi/2*i+angle)
			obj.position={x=x,y=y,z=0}	
			obj.scenario=self
			if(self.useghosts)then
				local ghost=XPRACTICE.TERROROFCASTLENATHRIA.PlayerGhost.new()
				ghost:Setup(self.game.environment_gameplay)
				ghost.position={x=x,y=y,z=0}
				ghost.orientation.yaw=math.pi/2*i+angle+math.pi
				ghost.orientation_displayed.yaw=ghost.orientation.yaw
				ghost.target_orientation_displayed.yaw=ghost.orientation.yaw				
				ghost.scenario=self
				tinsert(self.ghosts,ghost)
			end			
		end
	end
	
	
	function class:GetShriekLOSLines(target)
		local loslines={}
		if(self.shriekwing and target)then
			--local HEIGHT=0
			local HEIGHT=1		
			local Ax1=self.shriekwing.position.x
			local Ay1=self.shriekwing.position.y
			local Ax2=target.position.x
			local Ay2=target.position.y
			local Az1=HEIGHT
			local Az2=HEIGHT
		
			
			local losline={x1=Ax1,y1=Ay1,z1=Az1,x2=Ax2,y2=Ay2,z2=Az2}
			tinsert(loslines,losline)
		
			-- loslines[1].x1=Ax1
			-- loslines[1].y1=Ay1
			-- loslines[1].z1=Az1
			-- loslines[1].x1=Ax1
			-- loslines[1].y1=Ay1
			-- loslines[1].z1=Az1
			
			if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekLOSEdges)then
				local Bx1,By1,Bz1,Bx2,By2,Bz2
				local Cx1,Cy1,Cz1,Cx2,Cy2,Cz2
				local angle=math.atan2(Ay2-Ay1,Ax2-Ax1)
				local orthogonal=angle+math.pi*0.5
				Bx1=Ax1+math.cos(orthogonal)*XPRACTICE.Config.Shriekwing.ShriekwingShriekRadius
				By1=Ay1+math.sin(orthogonal)*XPRACTICE.Config.Shriekwing.ShriekwingShriekRadius
				Bx2=Ax2+math.cos(orthogonal)*XPRACTICE.Config.Shriekwing.PlayerShriekRadius
				By2=Ay2+math.sin(orthogonal)*XPRACTICE.Config.Shriekwing.PlayerShriekRadius				
				Bz1=HEIGHT
				Bz2=HEIGHT
				local losline={x1=Bx1,y1=By1,z1=Bz1,x2=Bx2,y2=By2,z2=Bz2}
				tinsert(loslines,losline)
				--self.loslines[2]:SetMissileOrientationAlongLine()
				Cx1=Ax1-math.cos(orthogonal)*XPRACTICE.Config.Shriekwing.ShriekwingShriekRadius
				Cy1=Ay1-math.sin(orthogonal)*XPRACTICE.Config.Shriekwing.ShriekwingShriekRadius
				Cx2=Ax2-math.cos(orthogonal)*XPRACTICE.Config.Shriekwing.PlayerShriekRadius
				Cy2=Ay2-math.sin(orthogonal)*XPRACTICE.Config.Shriekwing.PlayerShriekRadius
				Cz1=HEIGHT
				Cz2=HEIGHT
				local losline={x1=Cx1,y1=Cy1,z1=Cz1,x2=Cx2,y2=Cy2,z2=Cz2}
				tinsert(loslines,losline)

				--self.loslines[3]:SetMissileOrientationAlongLine()
			end
			
			-- for j=1,#self.loslines do
				-- local losline=self.loslines[j]
				-- local collision=false
				-- for i=1,#self.lines do					
					-- local line=self.lines[i]
					-- --print(losline.linesegment.x1,losline.linesegment.y1,losline.linesegment.x2,losline.linesegment.y2)
					-- if(XPRACTICE.LineLineIntersection(losline.linesegment.x1,losline.linesegment.y1,losline.linesegment.x2,losline.linesegment.y2,
															-- line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2))then
						-- collision=true
						-- break
					-- end					
				-- end
				-- if(collision)then
					-- --losline:ChangeLineActorID(166497,0,0)
					-- losline:ChangeLineActorID(166254,0,0)						
					-- --losline:ChangeLineActorID(604738,0,0)
				-- else
					-- --losline:ChangeLineActorID(530068,0.35,0)
					-- losline:ChangeLineActorID(166497,0,0)
					-- --losline:ChangeLineActorID(604834,0,0)
				-- end
			-- end	
		end
		return loslines
	end
	
	-- function class:ResetScenario()
		-- self.paused=false
		-- self.phaseinprogress=false
		-- if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty==1)then
			-- --heroic
			-- self.sonarvisible=true	
			-- self.sonaralpha=1		
		-- else
			-- --mythic
			-- self.sonarvisible=false	
			-- self.sonaralpha=0		
		-- end	
	-- end
	
	function class:LOSLineCollisionTest(loslinesegment)
		local losline=self.loslines[j]
		local collision=false
		for i=1,#self.lines do					
			local line=self.lines[i]
			--print(loslinesegment.x1,loslinesegment.y1,loslinesegment.x2,loslinesegment.y2)
			if(XPRACTICE.LineLineIntersection(loslinesegment.x1,loslinesegment.y1,loslinesegment.x2,loslinesegment.y2,
													line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2))then
				return true
				--break
			end					
		end
		return false
	end

	
	function class:QuickBomb(x,y,fuse,forgiving)		
		local obj
		obj=XPRACTICE.TERROROFCASTLENATHRIA.CleansingProtocolTelegraph.new()
		obj:Setup(self.game.environment_gameplay)		
		obj.scenario=self
		obj.position={x=x,y=y,z=0}	
		obj.fuse=fuse
		obj.forgiving=forgiving
		return obj
	end

	function class:QuickPillar(x,y,z)
		local pillar
		pillar=XPRACTICE.TERROROFCASTLENATHRIA.Pillar.new()
		pillar:Setup(self.game.environment_gameplay)
		pillar.position={x=x,y=y,z=z}
		--pillar.orientation.yaw=math.pi*0.5;pillar.orientation_displayed.yaw=math.pi*0.5
		pillar.scenario=self
		tinsert(self.pillars,pillar)	
		local RADIUS=XPRACTICE.Config.Shriekwing.PillarPreciseCollisionSize
		--<s>pillars are slightly to the right of where they appear</s>
		--<s>do not multiply offset by pillarscale</s>
		--...or wait, is solarwrath slightly to the left?
		-- it's solarwrath.
		--local xoffset=0.35
		local xoffset=0
		local yoffset=0
		x=x+xoffset
		y=y+yoffset
		local DEBUGVISIBILITY=XPRACTICE.Config.Shriekwing.PillarCollisionVisibility
		
		-- --clockwise -- normals face out
		self:QuickLine(x-RADIUS,y,z,x,y+RADIUS,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickLine(x,y+RADIUS,z,x+RADIUS,y,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickLine(x+RADIUS,y,z,x,y-RADIUS,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickLine(x,y-RADIUS,z,x-RADIUS,y,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickOutsideCorner(x-RADIUS,y,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickOutsideCorner(x,y+RADIUS,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickOutsideCorner(x+RADIUS,y,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)
		self:QuickOutsideCorner(x,y-RADIUS,z,DEBUGVISIBILITY,XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.PILLAR)

		
	end
	
	function class:QuickLine(x1,y1,z1,x2,y2,z2,visible,linetype)
		self:QuickCollisionLine(x1,y1,z1,x2,y2,z2,visible,linetype)
		if(visible)then self:QuickVisibleLine(x1,y1,z1,x2,y2,z2,visible,linetype) end
	end
	function class:QuickCollisionLine(x1,y1,z1,x2,y2,z2,visible,linetype)
		local line
		line=XPRACTICE.CollisionLine.new()
		line:Setup(self.game.environment_gameplay,x1,y1,z1,x2,y2,z2)
		line.linetype=linetype
		tinsert(self.lines,line)
	end
	function class:QuickVisibleLine(x1,y1,z1,x2,y2,z2,visible,linetype)
		local line
		line=XPRACTICE.VisibleLine.new()
		line:Setup(self.game.environment_gameplay,x1,y1,z1,x2,y2,z2)
		line.visible=visible
		line.linetype=linetype		
		line:ChangeLineActorID(166331,0,0)
	end
	
	
	function class:QuickOutsideCorner(x1,y1,z1,visible,linetype)
		local outsidecorner
		outsidecorner=XPRACTICE.OutsideCorner.new()
		outsidecorner:Setup(self.game.environment_gameplay,x1,y1,z1)
		outsidecorner.visible=visible
		outsidecorner.linetype=linetype
		tinsert(self.outsidecorners,outsidecorner)
	end	
	
	function class:Quick4Sonar(x,y,z,yaw)		
		self:QuickSonar(x,y,z,yaw)
		self:QuickSonar(x,y,z,yaw+math.pi*.5)
		self:QuickSonar(x,y,z,yaw+math.pi)
		self:QuickSonar(x,y,z,yaw+math.pi*1.5)	
	end
	function class:Quick5Sonar(x,y,z,yaw)		
		self:QuickSonar(x,y,z,yaw)
		self:QuickSonar(x,y,z,yaw+math.pi*.4)
		self:QuickSonar(x,y,z,yaw+math.pi*.8)
		self:QuickSonar(x,y,z,yaw+math.pi*1.2)
		self:QuickSonar(x,y,z,yaw+math.pi*1.6)	
	end	
	function class:QuickRandom4Sonar(x,y,z,yaw)		
		for i=1,4 do
			local a=math.pi*.4*(i-1)
			--local variance=math.pi*0.25
			local variance=math.pi*0.125
			a=a+(math.random()*1-.5)*variance
			self:QuickSonar(x,y,z,yaw+a)
		end
	end			
	function class:QuickRandom5Sonar(x,y,z,yaw)		
		for i=1,5 do
			local a=math.pi*.4*(i-1)
			--local variance=math.pi*0.25
			local variance=math.pi*0.125
			a=a+(math.random()*1-.5)*variance
			self:QuickSonar(x,y,z,yaw+a)
		end
	end		
	
	function class:QuickSonar(x,y,z,yaw)
		local sonar
		sonar=XPRACTICE.TERROROFCASTLENATHRIA.EchoingSonarProjectile.new()
		local DIST=3.5
		sonar:Setup(self.game.environment_gameplay,x+DIST*math.cos(yaw),y+DIST*math.sin(yaw),z)
		sonar.orientation.yaw=yaw
		sonar.scenario=self
		sonar.alpha=self.sonaralpha
		tinsert(self.sonars,sonar)
	end
	
	function class:QuickDeadlyDescent(targetobj)		
		local castercombat
		if(self.shriekwing)then
			castercombat=self.shriekwing.combatmodule
		else
			castercombat=nil
		end
		if(targetobj.combatmodule)then
			local aura=targetobj.combatmodule:ApplyAuraByClass(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_GracePeriod,castercombat,self.localtime)	
			local aura=targetobj.combatmodule:ApplyAuraByClass(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DeadlyDescent_Horrified,castercombat,self.localtime)	
		end
		local telegraph=XPRACTICE.TERROROFCASTLENATHRIA.DeadlyDescentTelegraph.new()
		telegraph:Setup(self.game.environment_gameplay,targetobj.position.x,targetobj.position.y,0)
		telegraph.scenario=self
		telegraph.targetobj=targetobj
		local feareffect=XPRACTICE.TERROROFCASTLENATHRIA.OverheadFearEffect.new()
		feareffect:Setup(self.game.environment_gameplay,targetobj.position.x,targetobj.position.y,1)
		feareffect.player=targetobj
		local impact=XPRACTICE.TERROROFCASTLENATHRIA.SonarImpact.new()
		impact:Setup(self.game.environment_gameplay,targetobj.position.x,targetobj.position.y,1)		
	end
	
	function class:QuickEnemyGhost(x,y,z)
		local ghost=XPRACTICE.TERROROFCASTLENATHRIA.EnemyGhost.new()
		ghost:Setup(self.game.environment_gameplay)
		ghost.position={x=x,y=y,z=z}
		ghost.orientation_displayed.yaw=math.random()*math.pi*2;ghost.orientation.yaw=ghost.orientation_displayed.yaw
		ghost.scenario=self		

		self:QuickDeadlyDescent(ghost)
	end

	function class:SetHeroic()
		XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty=1
		self.sonarvisible=true	
		self.sonaralpha=1	
		self:DeselectButtons(self.buttongroup[1])
		self.buttongroup[1][1]:Select(true)
		if(self.lantern)then
			self.lantern:Die()
			self.lantern.carried=false
			self.lantern=nil			
		end
		if(self.redx)then
			self.redx.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			self.redx=nil
		end
		if(self.lanternghost)then
			self.lanternghost.expirytime=self.lanternghost.localtime+1.0
			self.lanternghost.fadestarttime=self.lanternghost.localtime
			self.lanternghost=nil
		end
	end
	function class:SetMythic()
		--TODO LATER: why does this cause a framerate lag spike?
		XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty=2
		self.sonarvisible=false
		self.sonaralpha=0			
		self:DeselectButtons(self.buttongroup[1])
		self.buttongroup[1][2]:Select(true)
		local obj
		local xmod,ymod
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==2)then ymod=1 else ymod=-1 end
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==4)then xmod=-1 else xmod=1 end	
		if(not self.lantern)then
			lantern=XPRACTICE.TERROROFCASTLENATHRIA.BloodLantern.new()
			lantern:Setup(self.game.environment_gameplay)			
			lantern.position.x=xmod*(XPRACTICE.Config.Shriekwing.PillarEWDistance)
			lantern.position.y=ymod*(7+XPRACTICE.Config.Shriekwing.PillarNSDistance)						
			lantern.scenario=self
			self.lantern=lantern
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(self.game.environment_gameplay,lantern)
		end		
		if(not self.redx)then		
			obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(456041)	-- raid_ui_fx_red
			obj.position.x=lantern.position.x
			obj.position.y=lantern.position.y
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0		
			self.redx=obj
		end
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhost)then
			if(not self.lanternghost)then
				lanternghost=XPRACTICE.TERROROFCASTLENATHRIA.LanternGhost.new()
				lanternghost:Setup(self.game.environment_gameplay)			
				lanternghost.position.x=xmod*(XPRACTICE.Config.Shriekwing.PillarEWDistance)
				lanternghost.position.y=ymod*(15+XPRACTICE.Config.Shriekwing.PillarNSDistance)
				lanternghost.orientation.yaw=math.atan2(lantern.position.y-lanternghost.position.y,lantern.position.x-lanternghost.position.x)
				lanternghost.orientation_displayed.yaw=lanternghost.orientation.yaw
				lanternghost.scenario=self
				self.lanternghost=lanternghost	
			end
		end					
	end

	function class:ClickButtonAfterDelay(button,delay)
		self.nexteventtime=self.game.environment_gameplay.localtime+delay
		self.nexteventbutton=button
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
					local auras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_DropBloodLantern)
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
	
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.TERROROFCASTLENATHRIA.Scenario,"Terror of Castle Nathria","(Shriekwing intermission)")
end

