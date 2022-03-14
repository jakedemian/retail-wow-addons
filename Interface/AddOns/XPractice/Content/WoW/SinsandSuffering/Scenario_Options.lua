do
	local super=XPRACTICE.Scenario
	XPRACTICE.SINSANDSUFFERING.Scenario_Options=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Scenario_Options
	
	local savedataname="SINSANDSUFFERING"

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.parentscenario=XPRACTICE.SINSANDSUFFERING.Scenario
	end
	

	--static!
	XPRACTICE.GetSaveDataDefaults[savedataname]=function()
		local defaults={}

		defaults.CPUGhostCount=2

		defaults.TimeLimit=20.0

		defaults.ContainerLevel=1
		
		--defaults.RecognitionDelay=0.25
		defaults.RecognitionDelay=-1
		
		defaults.HitDetectOrbDistance=1.0
		defaults.OrbTargetCircles=false
		
		defaults.HitDetectWebDistance=0.75
		
		defaults.AnimaWebGrowthRate=7
		defaults.AnimaWebSpinRate=3.5
		
		defaults.AnimaWebLineType=1
				
		-- (announce role only applies to 2-ghost)
		defaults.AnnounceRole=false			
		
		defaults.EnableHints=false
		
		defaults.ShapesType1=true
		defaults.ShapesType2=false
		defaults.ShapesType3=false

		defaults.AnnounceShapeType=false			
		
		--1: pointman
		--2: opposite anchor
		--3: random
		defaults.CPUAnchorAlignment=1
		
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
		scrollbar:SetMaxScrollHeight(700)
		self.scrollbar=scrollbar
		
		

		

		XPRACTICE.OptionsMenuButton.ResetPosition()

	
		local label=XPRACTICE.LeftAlignedLabel.new()
		label:Setup(environment)		
		label.position.x=25--self.game.SCREEN_WIDTH/2
		label.position.y=-25
		--label:SetSize(self.game.SCREEN_WIDTH-label.position.x*2,25)
		label:SetSize(self.game.SCREEN_WIDTH/2,25)
		label.displayobject.drawable.fontstring:SetFont("Fonts\\FRIZQT__.TTF",20,"OUTLINE")
		label:SetText("Options -- Sins and Suffering")
		label.displayobject.parentframe=scrollbox.displayobject.drawable
		label.displayobject.drawable:SetParent(label.displayobject.parentframe)
		
		XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-5

		self.desclabel={}

		--XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"CPU-controlled ghosts:                              (When you adjust the ghost count, remember to change the time limit too!)")
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"CPU-controlled ghosts:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,45,30,"SINSANDSUFFERING","CPUGhostCount",
												{{"2",2},{"1",1},{"0",0}})	
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["CPUGhostCount"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")							
		--self.desclabel["CPUGhostCount"].displayobject.drawable.texture:Show()
												
		local adjustwarning=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"(When you change the ghost count, remember to adjust the time limit too!)")
		adjustwarning.position.y=adjustwarning.position.y+20

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Time limit:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,45,30,"SINSANDSUFFERING","TimeLimit",
												{{"10",10.0},{"15",15.0},{"20",20.0},{"25",25.0},{"30",30.0},{"35",35.0},{"40",40.0},{"45",45.0},{"50",50.0},{"55",55.0},{"60",60.0}})
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["TimeLimit"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")								
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Container level:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","ContainerLevel",
												{{"1",1},{"2",2},{"3",3}})	
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["ContainerLevel"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")							
		
		self.cpuanchoralignmentbuttons={}
		self.cpuanchoralignmentlabels={}
		local label=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Ghost anchor alignment:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,140,30,"SINSANDSUFFERING","CPUAnchorAlignment",
												{{"Anchor-Pointman",1},{"Anchor-Anchor",2},{"Random",3}})	
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["CPUAnchorAlignment"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")							
		tinsert(self.cpuanchoralignmentlabels,label)
		tinsert(self.cpuanchoralignmentlabels,self.desclabel["CPUAnchorAlignment"])
		tinsert(self.cpuanchoralignmentbuttons,buttongroup)		
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Recognition delay:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","RecognitionDelay",
												{{"None",-1},{"Short",0.25},{"Long",1}})	
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["RecognitionDelay"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")							
				
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Orb hit detection distance:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","HitDetectOrbDistance",
												{{"1 (Hard)",0.5},{"2",0.75},{"3",1.0},{"4",1.25},{"5 (Easy)",1.5}})	
												--{{"5 (Easy)",1.5},{"4",1.25},{"3",1.0},{"2",0.75},{"1 (Hard)",0.5}})	
		tinsert(self.buttongroups,buttongroup)
		--self.desclabel["HitDetectOrbDistance"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")		
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Draw circles under orbs?")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","OrbTargetCircles",
												{{"No",false},{"Yes",true}})	
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["OrbTargetCircles"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")		

		self.animawebbuttons={}
		self.animaweblabels={}
		local label=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Anima Web hit detection distance:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","HitDetectWebDistance",
												{{"1 (Easy)",0.25},{"2",0.5},{"3",0.75},{"4",1.0},{"5 (Hard)",1.25}})
		tinsert(self.buttongroups,buttongroup)
		tinsert(self.animaweblabels,label)
		tinsert(self.animawebbuttons,buttongroup)
		
		local label=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Anima Web growth rate:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","AnimaWebGrowthRate",
												{{"1 (Slow)",3.5},{"2",4.375},{"3",5.25},{"4",6.125},{"5 (Fast)",7.0}})												
		tinsert(self.buttongroups,buttongroup)
		tinsert(self.animaweblabels,label)
		tinsert(self.animawebbuttons,buttongroup)
		
		self.webrotationlabel=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Anima Web rotation speed:")
		self.webrotationbuttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","AnimaWebSpinRate",
												{{"1 (Slow)",1.75},{"2",2.625},{"3",3.5},{"4",4.375},{"5 (Fast)",5.25}})
		tinsert(self.buttongroups,self.webrotationbuttongroup)		
		
		local label=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Anima Web line appearance:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","AnimaWebLineType",
												{{"Orange",1},{"Red",2}})
		tinsert(self.buttongroups,buttongroup)
		tinsert(self.animaweblabels,label)
		tinsert(self.animawebbuttons,buttongroup)		
		self.desclabel["AnimaWebLineType"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")		
		tinsert(self.animaweblabels,self.desclabel["AnimaWebLineType"])
		
		self.rolelabel=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Announce player role?")
		self.rolebuttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","AnnounceRole",
												{{"No",false},{"Yes",true}})	
		tinsert(self.buttongroups,self.rolebuttongroup)
		self.desclabel["AnnounceRole"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		
		local label=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Hint button?")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","EnableHints",
												{{"No",false},{"Yes",true}})	
		tinsert(self.buttongroups,buttongroup)
		
		
		self.prevshapestype1=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1
		self.prevshapestype2=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2
		self.prevshapestype3=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3
	
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"")
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Do not change the following options unless instructed to by your raid leader.")
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"")
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Shape types:")

		self.prevshapestype1=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1
		self.prevshapestype2=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2
		self.prevshapestype3=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3
		
		local icon=XPRACTICE.Label.new()
		icon:Setup(self.game.environment_gameplay,25,XPRACTICE.OptionsMenuButton.debugbuttony-32,0)
		icon:SetSize(32,32)
		icon.displayobject.drawable.texture:SetTexture("interface\\addons\\xpractice\\content\\sinsandsuffering\\assets\\shape1.tga")
		icon.displayobject.drawable.texture:Show()
		icon.displayobject.parentframe=self.scrollbox.displayobject.drawable;icon.displayobject.drawable:SetParent(icon.displayobject.parentframe)	

		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup   (environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","ShapesType1",
												{{"On",true},{"Off",false}})	
		tinsert(self.buttongroups,buttongroup)
		
		local buttongroupoffset=170
		local desclabeloffset=-150
		
		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=350,y=XPRACTICE.OptionsMenuButton.debugbuttony-13,z=0}
		label:SetSize(600,100)
		label:SetText("")
		self.statuslabel=label
		label.displayobject.parentframe=self.scrollbox.displayobject.drawable
		label.displayobject.drawable:SetParent(label.displayobject.parentframe)	
		
		self.desclabel["ShapesType1"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"\"Two anchors\"")				
		for i=1,#buttongroup do	buttongroup[i].position.x=buttongroup[i].position.x+buttongroupoffset end; self.desclabel["ShapesType1"].position.x=self.desclabel["ShapesType1"].position.x+desclabeloffset
		
		local icon=XPRACTICE.Label.new()
		icon:Setup(self.game.environment_gameplay,25,XPRACTICE.OptionsMenuButton.debugbuttony-32,0)
		icon:SetSize(32,32)
		icon.displayobject.drawable.texture:SetTexture("interface\\addons\\xpractice\\content\\sinsandsuffering\\assets\\shape2.tga")
		icon.displayobject.drawable.texture:Show()
		icon.displayobject.parentframe=self.scrollbox.displayobject.drawable;icon.displayobject.drawable:SetParent(icon.displayobject.parentframe)	
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","ShapesType2",
												{{"On",true},{"Off",false}})	
		tinsert(self.buttongroups,buttongroup)		
		self.desclabel["ShapesType2"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"\"One anchor\"")
		for i=1,#buttongroup do	buttongroup[i].position.x=buttongroup[i].position.x+buttongroupoffset end; self.desclabel["ShapesType2"].position.x=self.desclabel["ShapesType2"].position.x+desclabeloffset

		local icon=XPRACTICE.Label.new()
		icon:Setup(self.game.environment_gameplay,25,XPRACTICE.OptionsMenuButton.debugbuttony-32,0)
		icon:SetSize(32,32)
		icon.displayobject.drawable.texture:SetTexture("interface\\addons\\xpractice\\content\\sinsandsuffering\\assets\\shape3.tga")
		icon.displayobject.drawable.texture:Show()
		icon.displayobject.parentframe=self.scrollbox.displayobject.drawable;icon.displayobject.drawable:SetParent(icon.displayobject.parentframe)	

		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","ShapesType3",
												{{"On",true},{"Off",false}})	
		tinsert(self.buttongroups,buttongroup)		
		self.desclabel["ShapesType3"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"\"No anchors\"")							
		for i=1,#buttongroup do	buttongroup[i].position.x=buttongroup[i].position.x+buttongroupoffset end; self.desclabel["ShapesType3"].position.x=self.desclabel["ShapesType3"].position.x+desclabeloffset
		
		
		self.shapetypelabel=XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Announce shape type?")
		self.shapetypebuttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,70,30,"SINSANDSUFFERING","AnnounceShapeType",
												{{"No",false},{"Yes",true}})
		tinsert(self.buttongroups,self.shapetypebuttongroup)
		self.desclabel["AnnounceShapeType"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
				
				
				
		
		local scenario=self
		local button
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.displayobject.parentframe=self.scrollbox.displayobject.drawable
		button.displayobject.drawable:SetParent(button.displayobject.parentframe)
		button.position={x=XPRACTICE.OptionsMenuButton.debugbuttonx,y=-1350,z=0}
		button:SetSize(250,30)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Reset all settings to default")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					XPRACTICE.ResetSaveData(savedataname)
					scenario:Recalculate()
				end
			end)

		local scenario=self
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
				if(down)then 					
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
				--print("Button:",button.savearray,button.savevariable,button.value)
				if(XPRACTICE_SAVEDATA[button.savearray][button.savevariable]==button.value)then
					button:Select(true)
				else
					button:Select(false)
				end
			end
		end
		
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount==2)then
			self.desclabel["CPUGhostCount"]:SetText("")			
		else
			self.desclabel["CPUGhostCount"]:SetText("Use the extra action button to summon and dismiss additional ghosts.")
		end
		self.desclabel["CPUGhostCount"]:AutoSize()		
		
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel==2)then
			self.desclabel["ContainerLevel"]:SetText("Anima webs.")			
		elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel==3)then
			self.desclabel["ContainerLevel"]:SetText("Spinning anima webs.")
		else			
			self.desclabel["ContainerLevel"]:SetText("")
		end
		self.desclabel["ContainerLevel"]:AutoSize()
		
		

		local alpha
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel<2)then
			alpha=0.333
		else
			alpha=1
		end
		for i=1,#self.animaweblabels do
			self.animaweblabels[i].alpha=alpha
		end
		for i=1,#self.animawebbuttons do
			local group=self.animawebbuttons[i]
			for j=1,#group do
				local button=group[j]
				button:SetLockedStartingAlpha(alpha)
			end
		end
		
		local alpha
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel<3)then
			alpha=0.333
		else
			alpha=1
		end
		self.webrotationlabel.alpha=alpha
		local group=self.webrotationbuttongroup
		for j=1,#group do
			local button=group[j]
			button:SetLockedStartingAlpha(alpha)
		end




		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount>=1)then
			alpha=1
		else
			alpha=0.333
		end
		for i=1,#self.cpuanchoralignmentlabels do
			self.cpuanchoralignmentlabels[i].alpha=alpha
		end
		for i=1, #self.cpuanchoralignmentbuttons do
			local group=self.cpuanchoralignmentbuttons[i]
			for j=1,#group do
				local button=group[j]
				button:SetLockedStartingAlpha(alpha)
			end
		end
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUAnchorAlignment==1)then
			self.desclabel["CPUAnchorAlignment"]:SetText("The pointman's lines will connect exactly two orbs each.")
		elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUAnchorAlignment==2)then
			self.desclabel["CPUAnchorAlignment"]:SetText("The pointman's lines will connect exactly one orb each.")
		else			
			self.desclabel["CPUAnchorAlignment"]:SetText("")
		end
		self.desclabel["CPUAnchorAlignment"]:AutoSize()

		
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.RecognitionDelay==-1)then
			self.desclabel["RecognitionDelay"]:SetText("You can connect orbs even if you are moving.")			
		elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.RecognitionDelay==0.25)then
			self.desclabel["RecognitionDelay"]:SetText("You must stop moving for a split second before the orbs will connect.")
		elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.RecognitionDelay==1)then
			self.desclabel["RecognitionDelay"]:SetText("The orbs will not connect unless you are standing still.")
		end
		self.desclabel["RecognitionDelay"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.OrbTargetCircles)then
			self.desclabel["OrbTargetCircles"]:SetText("Makes it easier to connect orbs.")
		else
			self.desclabel["OrbTargetCircles"]:SetText("")
		end
		self.desclabel["OrbTargetCircles"]:AutoSize()		
		
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnimaWebLineType==1)then
			self.desclabel["AnimaWebLineType"]:SetText("Easy to distinguish from Shared Suffering.")			
		elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnimaWebLineType==2)then
			self.desclabel["AnimaWebLineType"]:SetText("More faithful to the original... but identical to Shared Suffering.")
		end
		self.desclabel["AnimaWebLineType"]:AutoSize()
		
		
		local alpha
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount~=2)then
			alpha=0.333
			self.desclabel["AnnounceRole"]:SetText("Not applicable unless CPU ghost count is set to 2.")
		else
			alpha=1
			self.desclabel["AnnounceRole"]:SetText("")
		end
		self.desclabel["AnnounceRole"]:AutoSize()
		self.rolelabel.alpha=alpha
		local group=self.rolebuttongroup
		for j=1,#group do
			local button=group[j]
			button:SetLockedStartingAlpha(alpha)
		end
		self.desclabel["AnnounceRole"].alpha=alpha
		
		
		local shapecount=0
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1)then shapecount=shapecount+1 end
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2)then shapecount=shapecount+1 end
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3)then shapecount=shapecount+1 end
		if(shapecount==1)then
			alpha=0.333
		else
			alpha=1
		end
		
		self.shapetypelabel.alpha=alpha
		local group=self.shapetypebuttongroup
		for j=1,#group do
			local button=group[j]
			button:SetLockedStartingAlpha(alpha)
		end
		self.desclabel["AnnounceShapeType"].alpha=alpha
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount==0)then
			self.desclabel["AnnounceShapeType"]:SetText("(When there are no CPU ghosts, you may be able to find your own solution.)")
		else
			self.desclabel["AnnounceShapeType"]:SetText("")
		end
		self.desclabel["AnnounceShapeType"]:AutoSize()
		

		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1==false and XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2==false and XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3==false)then
			XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1=self.prevshapestype1
			XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2=self.prevshapestype2
			XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3=self.prevshapestype3
			self.statuslabel:SetText("You can't disable every shape type at the same time!",3)
			-- before recalculating, check that the savedata actually changed so we don't get infinite looped
			if(not (XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1==false and XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2==false and XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3==false))then
				self:Recalculate()
			end
		end
		
		self.prevshapestype1=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1
		self.prevshapestype2=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2
		self.prevshapestype3=XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3
		
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
