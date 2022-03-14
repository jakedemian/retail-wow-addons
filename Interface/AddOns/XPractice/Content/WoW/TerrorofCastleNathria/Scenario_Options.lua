do
	local super=XPRACTICE.Scenario
	XPRACTICE.TERROROFCASTLENATHRIA.Scenario_Options=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Scenario_Options
	
	local savedataname="TERROROFCASTLENATHRIA"
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.parentscenario=XPRACTICE.TERROROFCASTLENATHRIA.Scenario
	end

	
	XPRACTICE.GetSaveDataDefaults[savedataname]=function()
		local defaults={}
		
		-- 1: heroic
		-- 2: mythic
		defaults.Difficulty=1
		
		defaults.SkipBloodShroudIntro=false
		
		--1-4 NW, NE, SE, SW
		defaults.HomePillar=2
		
		-- 2 north, 4 east, 6 south, 8 west, 0 random.
		defaults.ShriekwingFirstMovementLocation=0
		-- -1 counterclockwise, 1 clockwise, 0 random.
		defaults.ShriekwingMovementDirection=0			
		
		-- 100 to disable (stacks stop at 99)
		defaults.BloodlightWarningStacks=8
		defaults.BloodlightDeathStacks=11		
		
		defaults.LanternActiveOnFloor=true			
		
		defaults.LanternGhost=true
		defaults.LanternGhostBehavior=1			

		-- Intermission length as measured in Sonar Shrieks.  Value of -1 indicates endless intermission.
		defaults.IntermissionLength=3	
		defaults.ShriekwingMovementSpeed=0
		
		defaults.ShriekLOSEdges=false
		defaults.EchoingSonarForgiving=true			
		
		defaults.ExtraSonarWaves=0	
		defaults.EchoingSonarProjectileSpeed=0
		defaults.EchoingSonarProjectileSize=0

		-- 1: simple
		-- 2: random
		-- 3: cruel
		defaults.PillarCollisionStyle=1

		-- WARNING: these player ghosts are not your friends!
		defaults.EnemyGhosts=0
		
		-- 1: "simplified"
		-- 2: "complex" (NYI)
		defaults.RoomShapeStyle=1		

		defaults.ExtraLanternHazards=false		
		
		return defaults
	end
	
	
	

	function class:Populate()
		super.Populate(self)
		
		
		self.buttongroups={}

		
		local scenario=self
		

		self.menubuttons={}
		local environment=self.game.environment_gameplay
		local scrollbox=XPRACTICE.ScrollBox.new()
		scrollbox:Setup(environment,25,self.game.SCREEN_HEIGHT-25)
		self.scrollbox=scrollbox
		
		local scrollbar=XPRACTICE.ScrollBarVertical.new()
		scrollbar:Setup(environment,self.game.SCREEN_WIDTH-52,2)
		scrollbar:SetSize(50,self.game.SCREEN_HEIGHT-4)
		scrollbar.scrollbox=scrollbox
		scrollbar:SetMaxScrollHeight(850)
		self.scrollbar=scrollbar
		
		
		
		

		XPRACTICE.OptionsMenuButton.ResetPosition()

	
		local label=XPRACTICE.LeftAlignedLabel.new()
		label:Setup(environment)		
		label.position.x=25--self.game.SCREEN_WIDTH/2
		label.position.y=-25
		--label:SetSize(self.game.SCREEN_WIDTH-label.position.x*2,25)
		label:SetSize(self.game.SCREEN_WIDTH/2,25)
		label.displayobject.drawable.fontstring:SetFont("Fonts\\FRIZQT__.TTF",20,"OUTLINE")
		label:SetText("Options -- Terror of Castle Nathria")
		
		
		label.displayobject.parentframe=scrollbox.displayobject.drawable
		label.displayobject.drawable:SetParent(label.displayobject.parentframe)
		XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-5

		self.desclabel={}

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Raid difficulty:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,60,"TERROROFCASTLENATHRIA","Difficulty",
												{{"Heroic",1},{"Mythic",2}})	
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["Difficulty"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")							
												
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Skip intro?")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","SkipBloodShroudIntro",
												{{"No",false},{"Yes",true}})		
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["SkipBloodShroudIntro"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Home pillar:")
		local group=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","HomePillar",
												{{"NW",1},{"NE",2},{"SE",3},{"SW",4}})		
		tinsert(self.buttongroups,group)
		self.desclabel["HomePillar"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")							
		group[3].position.y=group[3].position.y-40;	group[3].position.x=group[3].position.x-80
		group[4].position.y=group[4].position.y-40;	group[4].position.x=group[4].position.x-240
		XPRACTICE.OptionsMenuButton.descriptionx=XPRACTICE.OptionsMenuButton.descriptionx-160
		XPRACTICE.OptionsMenuButton.descriptiony=XPRACTICE.OptionsMenuButton.descriptiony-15
		XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-30
		self.desclabel["HomePillar"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		
		local tempy=XPRACTICE.OptionsMenuButton.debugbuttony
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Shriekwing will start off moving...")
		local group=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","ShriekwingFirstMovementLocation",
												{{"North",2},{"East",4},{"South",6},{"West",8},{"Random",0}})	
		tinsert(self.buttongroups,group)
		group[1].position.x=group[1].position.x+80
		group[2].position.x=group[2].position.x+80;group[2].position.y=group[2].position.y-40
		group[3].position.x=group[3].position.x-80;group[3].position.y=group[3].position.y-80
		group[4].position.x=group[4].position.x-240;group[4].position.y=group[4].position.y-40
		group[5].position.x=group[5].position.x-240;group[5].position.y=group[5].position.y-40
		
		XPRACTICE.OptionsMenuButton.debugbuttony=tempy-40*4
		--XPRACTICE.OptionsMenuButton.debugbuttony=tempy-40
		--XPRACTICE.OptionsMenuButton.debugbuttonx=350
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"...and then continue moving...")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,30,"TERROROFCASTLENATHRIA","ShriekwingMovementDirection",
												{{"Counterclockwise",-1},{"Random",0},{"Clockwise",1}})
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["ShriekwingMovementDirection"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")

		--XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-40*1

		self.lanternlabels={}
		self.lanterngroups={}
		self.lanternlabels[1]={XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Maximum tolerable Bloodlight stacks:")}
		self.lanterngroups[1]=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","BloodlightDeathStacks",
												{{"-",1000},{"10",11},{"9",10},{"8",9},{"7",8},{"6",7},{"5",6}})		
		tinsert(self.buttongroups,self.lanterngroups[1])
		self.desclabel["BloodlightDeathStacks"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		self.lanternlabels[1][2]=self.desclabel["BloodlightDeathStacks"]
		
		-- self.lanternlabels[4]={XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Blood Lantern active on floor?")}
		-- self.lanterngroups[4]=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","LanternActiveOnFloor",
												-- {{"No",false},{"Yes",true}})
		-- tinsert(self.buttongroups,self.lanterngroups[4])
		-- self.desclabel["LanternActiveOnFloor"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")				
		-- self.lanternlabels[4][2]=self.desclabel["LanternActiveOnFloor"]		
		
		self.lanternlabels[2]={XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Who will carry the Blood Lantern?")}
		self.lanterngroups[2]=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","LanternGhost",
												{{"CPU",true},{"You",false}})
		tinsert(self.buttongroups,self.lanterngroups[2])
		self.desclabel["LanternGhost"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")				
		self.lanternlabels[2][2]=self.desclabel["LanternGhost"]

		self.lanternlabels[3]={XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"CPU behavior:")}
		self.lanterngroups[3]=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,30,"TERROROFCASTLENATHRIA","LanternGhostBehavior",
												{{"Helpful",1},{"Distant",2},{"Obstinate",3}})
		tinsert(self.buttongroups,self.lanterngroups[3])
		self.desclabel["LanternGhostBehavior"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")				
		self.lanternlabels[3][2]=self.desclabel["LanternGhostBehavior"]
		
		self.lanternlabels[4]={XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Lantern fragility:")}
		self.lanterngroups[4]=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,30,"TERROROFCASTLENATHRIA","ExtraLanternHazards",
												{{"Descent Only",false},{"Descent + Sonar",true}})
		tinsert(self.buttongroups,self.lanterngroups[4])
		self.desclabel["ExtraLanternHazards"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")				
		self.lanternlabels[4][2]=self.desclabel["ExtraLanternHazards"]


		local tempy=XPRACTICE.OptionsMenuButton.debugbuttony
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Intermission length (measured in Sonar Shrieks):")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","IntermissionLength",
												{{"3",3},{"5",5},{"7",7},{"9",9},{"11",11},{"Endless",-1}})
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["IntermissionLength"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")																
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Shriekwing walk speed:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","ShriekwingMovementSpeed",
												{{"1 (Slow)",0},{"2",1},{"3",2},{"4",3},{"5 (Fast)",4}})
		tinsert(self.buttongroups,buttongroup)

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Earsplitting Shriek hit detection:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,30,"TERROROFCASTLENATHRIA","ShriekLOSEdges",
												{{"Standard",false},{"Difficult",true}})		
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["ShriekLOSEdges"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")	

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Echoing Sonar hit detection:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,30,"TERROROFCASTLENATHRIA","EchoingSonarForgiving",
												{{"Standard",true},{"Difficult",false}})		
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["EchoingSonarForgiving"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")																
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Echoing Sonar projectile count:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","ExtraSonarWaves",
												{{"1 (Less)",0},{"2",1},{"3",2},{"4",3},{"5",4},{"6 (More)",5}})														
		tinsert(self.buttongroups,buttongroup)
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Echoing Sonar projectile speed:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","EchoingSonarProjectileSpeed",
												{{"1 (Slow)",0},{"2",1},{"3",2},{"4",3},{"5 (Fast)",4}})											
		tinsert(self.buttongroups,buttongroup)

		-- --TODO LATER: hit detection gets kinda sketchy at sizes greater than 1.25x
		-- -- also it's too easy to hug the pillars to avoid everything
		-- XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Echoing Sonar projectile size:")
		-- local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","EchoingSonarProjectileSize",
												-- {{"1 (Small)",0},{"2",1},{"3",2},{"4",3},{"5 (Large)",4}})
		-- tinsert(self.buttongroups,buttongroup)
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Echoing Sonar projectile bounce style:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","PillarCollisionStyle",
												{{"Simple",1},{"Random",2},{"Cruel",3}})
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["PillarCollisionStyle"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")


		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Hazard ghosts:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"TERROROFCASTLENATHRIA","EnemyGhosts",
												{{"None",0},{"Few",1},{"Many",2}})		
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["EnemyGhosts"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")

		local scenario=self
		local button
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.displayobject.parentframe=self.scrollbox.displayobject.drawable
		button.displayobject.drawable:SetParent(button.displayobject.parentframe)
		button.position={x=XPRACTICE.OptionsMenuButton.debugbuttonx,y=-1500,z=0}
		button:SetSize(250,30)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Reset all settings to default")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 
					XPRACTICE.ResetSaveData(savedataname)
					scenario:Recalculate()
				end
			end)
	
		
		local button
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH-52-200-25,y=25,z=0}
		button.displayobject.drawable.texture:SetColorTexture(0,0,0,1)
		button.displayobject.drawable:SetFrameLevel(210)
		button:SetSize(200,120)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Save and return")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					scenario.game:LoadScenarioByClass(scenario.parentscenario)
				end
			end)
			
		self:Recalculate()

	end
	
	

	
		
	function class:Recalculate()
	
		for i=1,#self.buttongroups do
			local buttongroup=self.buttongroups[i]
			for j=1,#buttongroup do
				local button=buttongroup[j]
				if(XPRACTICE_SAVEDATA[button.savearray][button.savevariable]==button.value)then
					button:Select(true)
				else
					button:Select(false)
				end
			end
		end
	
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==1000)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=1000
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==11)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=8
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==10)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=7
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==9)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=6
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==8)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=5		
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==7)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=5
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks==6)then
			XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks=4	
		end
		
		local alpha
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty==1)then
			alpha=0.333
			--self.desclabel["Difficulty"]:SetText("20% less projectiles, and no lantern to worry about.")			
		else
			alpha=1.0
			--self.desclabel["Difficulty"]:SetText("You can add even more projectiles by adjusting the \"Echoing Sonar projectile count\" setting below.")
		end
		self.desclabel["Difficulty"]:AutoSize()
		for i=1,#self.lanternlabels do
			local group=self.lanternlabels[i]
			for j=1,#group do
				self.lanternlabels[i][j].alpha=alpha
			end
		end
		for i=1,#self.lanterngroups do
			local group=self.lanterngroups[i]
			for j=1,#group do
				local button=group[j]
				button:SetLockedStartingAlpha(alpha)
			end
		end
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhost==false)then
			for j=1,#self.lanternlabels[3] do
				self.lanternlabels[3][j].alpha=0.333
			end
			for j=1,#self.lanterngroups[3] do
				local button=self.lanterngroups[3][j]
				button:SetLockedStartingAlpha(0.333)
			end
		end
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.SkipBloodShroudIntro==false)then
			self.desclabel["SkipBloodShroudIntro"]:SetText("")			
		else
			self.desclabel["SkipBloodShroudIntro"]:SetText("Save a few seconds each time you practice.")
		end	
		self.desclabel["SkipBloodShroudIntro"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==1)then
			self.desclabel["HomePillar"]:SetText("...the \"far left\" pillar.")			
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==2)then
			self.desclabel["HomePillar"]:SetText("...the \"near left\" pillar.")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==3)then
			self.desclabel["HomePillar"]:SetText("...the \"near right\" pillar.")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.HomePillar==4)then
			self.desclabel["HomePillar"]:SetText("...the \"far right\" pillar.")
		end	
		self.desclabel["HomePillar"]:AutoSize()
		
		-- if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekwingMovementDirection==0)then
			-- self.desclabel["ShriekwingMovementDirection"]:SetText("If the intermission length is set to Endless,\nShriekwing will occasionally reverse direction.")
		-- else
			-- self.desclabel["ShriekwingMovementDirection"]:SetText("")
		-- end
		-- self.desclabel["ShriekwingMovementDirection"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.IntermissionLength<0)then
			self.desclabel["IntermissionLength"]:SetText("If \"continue moving\" is set to Random,\nShriekwing will occasionally reverse direction.")
		else
			self.desclabel["IntermissionLength"]:SetText("")
		end
		self.desclabel["IntermissionLength"]:AutoSize()		
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightDeathStacks<99)then
			self.desclabel["BloodlightDeathStacks"]:SetText("More than this number, and you die.")
		else
			self.desclabel["BloodlightDeathStacks"]:SetText("Bloodlight can't kill you.")
		end
		self.desclabel["BloodlightDeathStacks"]:AutoSize()
		
		-- if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternActiveOnFloor)then
			-- self.desclabel["LanternActiveOnFloor"]:SetText("Standing near the lantern will give you Bloodlight stacks, even if it's on the floor.")
		-- else
			-- self.desclabel["LanternActiveOnFloor"]:SetText("You'll only get Bloodlight stacks if someone is carrying the lantern.")
		-- end
		-- self.desclabel["LanternActiveOnFloor"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhost)then
			self.desclabel["LanternGhost"]:SetText("The CPU is immune to Shriekwing's attacks, \nand the lantern will not break if the CPU has touched it recently.")
		else
			self.desclabel["LanternGhost"]:SetText("Use the extra action button to drop the lantern.")
		end
		self.desclabel["LanternGhost"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior==1)then
			self.desclabel["LanternGhostBehavior"]:SetText("The CPU will try to keep your Bloodlight stacks under control.")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior==2)then
			self.desclabel["LanternGhostBehavior"]:SetText("The CPU will hold the lantern at a distance and never drop it.\nWalk towards them to refresh your stacks.\n(Also, they might walk through pillars, but that's a feature, not a bug.)")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior==3)then
			self.desclabel["LanternGhostBehavior"]:SetText("The CPU will hold the lantern over the hiding spot at all times.\nDropping your stacks might be very difficult!")
		end
		self.desclabel["LanternGhostBehavior"]:AutoSize()		
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ExtraLanternHazards==false)then
			self.desclabel["ExtraLanternHazards"]:SetText("Lantern will break only if Shriekwing hits it with Deadly Descent.")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ExtraLanternHazards==true)then
			self.desclabel["ExtraLanternHazards"]:SetText("Lantern will also break if it gets hit by an Echoing Sonar wave.")
		end
		self.desclabel["ExtraLanternHazards"]:AutoSize()		
				
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekLOSEdges==false)then
			self.desclabel["ShriekLOSEdges"]:SetText("LOS is measured from the center of Shriekwing's body.  Standard behavior.")
		else
			self.desclabel["ShriekLOSEdges"]:SetText("LOS is also measured from Shriekwing's head and tail.")
		end
		self.desclabel["ShriekLOSEdges"]:AutoSize()				
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarForgiving)then
			self.desclabel["EchoingSonarForgiving"]:SetText("That outer ring is a harmless bug we couldn't fix.")
		else
			self.desclabel["EchoingSonarForgiving"]:SetText("Maybe not so harmless after all.  (WARNING: might not be visible on certain graphics settings!)")
		end
		self.desclabel["EchoingSonarForgiving"]:AutoSize()				
	
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.PillarCollisionStyle==1)then
			self.desclabel["PillarCollisionStyle"]:SetText("If Simple is too predictable, try Random.")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.PillarCollisionStyle==2)then
			self.desclabel["PillarCollisionStyle"]:SetText("")
		elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.PillarCollisionStyle==3)then
			self.desclabel["PillarCollisionStyle"]:SetText("They're aiming at you.")
		end
		self.desclabel["PillarCollisionStyle"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EnemyGhosts==0)then
			self.desclabel["EnemyGhosts"]:SetText("")
		else
			self.desclabel["EnemyGhosts"]:SetText("These ghosts are not your friends.")
		end
		self.desclabel["EnemyGhosts"]:AutoSize()
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
	
	function class:OnEscapeKey()
		self.game:LoadScenarioByClass(self.parentscenario)
	end	
end

-- do not register scenario to main menu
