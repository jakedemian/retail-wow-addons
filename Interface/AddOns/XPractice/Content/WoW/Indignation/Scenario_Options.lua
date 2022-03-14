do
	local super=XPRACTICE.Scenario
	XPRACTICE.INDIGNATION.Scenario_Options=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.Scenario_Options
	
	local savedataname="INDIGNATION"
	
	--static!
	XPRACTICE.GetSaveDataDefaults[savedataname]=function()
		local defaults={}

		
		-- 1. ravage directly east
		-- 2. ravage east-southeast		
			-- (second ravage is always counter-clockwise from first)
		defaults.dancetype=1
				
		
		-- 1. blue and gray
		-- 2. blue only
		-- 3. gray only
		defaults.floorcolor=1
		
		
		--1 detailed, 2 simple, 3 off
		--(1: "Move right and drop seed near the edge." or "Wait... Wait... CLICK GATEWAY NOW")
		--(2: "Next: Ravage+Seed Combo")
		--(3: "FATAL FINESSE ON YOU")
		defaults.forecast=true
		
		defaults.hintarrow=true
		

		--1 time since P3 start, 2 time since encounter start, 3 time remaining, 4 off
		defaults.clock=1
		
		--1 always, 2 never, 3 random
		defaults.target_ff_1=3
		defaults.target_ff_2=3
		defaults.target_ff_3=3
		defaults.target_ff_4=3
		defaults.target_ff_5=3
		defaults.target_ff_6=3
		defaults.target_ff_7=3
		
		--
		defaults.startfrommidway=0
		defaults.mirrorgroup=false
		--
		defaults.killplayerforunnecessarysoak=false
		defaults.mirrorknockbackresist=true
		
		
		return defaults
	end
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
	end
	

	--TODO: call CheckSaveData before trying to populate

	function class:Populate()
		super.Populate(self)
		
		
		self.buttongroups={}
		self.desclabel={}

		
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
		scrollbar:SetMaxScrollHeight(400)
		--scrollbar:SetMaxScrollHeight(1)
		self.scrollbar=scrollbar
		
		local scenario=self
		local button
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.displayobject.parentframe=self.scrollbox.displayobject.drawable
		button.displayobject.drawable:SetParent(button.displayobject.parentframe)
		button.position={x=XPRACTICE.OptionsMenuButton.debugbuttonx,y=-1050,z=0}
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
					scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
				end
			end)		
		
		

		

		XPRACTICE.OptionsMenuButton.ResetPosition()

	
		local label=XPRACTICE.LeftAlignedLabel.new()
		label:Setup(environment)		
		label.position.x=25--self.game.SCREEN_WIDTH/2
		label.position.y=-25
		--label:SetSize(self.game.SCREEN_WIDTH-label.position.x*2,25)
		label:SetSize(self.game.SCREEN_WIDTH/2,25)
		label.displayobject.drawable.fontstring:SetFont("Fonts\\FRIZQT__.TTF",20,"OUTLINE")
		label:SetText("Options -- Indignation")
		label.displayobject.parentframe=scrollbox.displayobject.drawable
		label.displayobject.drawable:SetParent(label.displayobject.parentframe)
		
		XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-5


		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"First Ravage attack:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,150,30,"INDIGNATION","dancetype",
												{{"Directly east",1},{"30 degrees east-southeast",2}})
		tinsert(self.buttongroups,buttongroup)
		self.desclabel["dancetype"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Start time:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,90,30,"INDIGNATION","startfrommidway",
												{{"Phase start",0},{"FF 1",1},{"FF 2",2},{"FF 3",3},{"FF 4",4},{"FF 5",5},{"FF 6",6}})
		tinsert(self.buttongroups,buttongroup)
		
		self.mirrorrealmlabels={}
		tinsert(self.mirrorrealmlabels,XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Player group:"))
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,120,30,"INDIGNATION","mirrorgroup",
												{{"Standard realm",false},{"Mirror realm",true}})
		tinsert(self.buttongroups,buttongroup)		
		self.mirrorrealmgroup=buttongroup
		self.desclabel["mirrorgroup"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		tinsert(self.mirrorrealmlabels,self.desclabel["mirrorgroup"])

		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"You can choose whether specific Fatal Finesse attacks will target you.")
		--XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-10
		
		for i=1,7 do
			local var="target_ff_"..tostring(i)
			local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,90,30,"INDIGNATION",var,
													{{"Always",1},{"Never",2},{"Random",3}})	
			tinsert(self.buttongroups,buttongroup)
			self.desclabel["target_ff_"..tostring(i)]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"Fatal Finesse "..tostring(i))							
			--XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony+15
			XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony+30
		end
		XPRACTICE.OptionsMenuButton.debugbuttony=XPRACTICE.OptionsMenuButton.debugbuttony-15
		
		--self.desclabel["CPUGhostCount"].displayobject.drawable.texture:Show()

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Hint arrow:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,60,30,"INDIGNATION","hintarrow",
													{{"On",true},{"Off",false}})
			tinsert(self.buttongroups,buttongroup)
		self.desclabel["hintarrow"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Forecast:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,60,30,"INDIGNATION","forecast",
													{{"On",true},{"Off",false}})
			tinsert(self.buttongroups,buttongroup)		
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Clock display:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,180,30,"INDIGNATION","clock",
													{{"Phase 3 time",1},{"Total encounter time",2},{"Time remaining",3},{"Off",4}})
			tinsert(self.buttongroups,buttongroup)		

		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Floor color:")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,120,30,"INDIGNATION","floorcolor",
													{{"Blue and gray",1},{"All blue",2},{"All gray",3}})	
			tinsert(self.buttongroups,buttongroup)
	
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Kill player for soaking Smoldering Ire after dropping Fatal Finesse?")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,120,30,"INDIGNATION","killplayerforunnecessarysoak",
													{{"Yes",true},{"No",false}})	
			tinsert(self.buttongroups,buttongroup)
		self.desclabel["killplayerforunnecessarysoak"]=XPRACTICE.OptionsMenuButton.QuickDescriptionLabel(environment,scenario,scrollbox,"")
		
		XPRACTICE.OptionsMenuButton.QuickLabel(environment,scenario,scrollbox,"Apply knockback resist for Fatal Finesse 5 mirror realm?")
		local buttongroup=XPRACTICE.OptionsMenuButton.QuickButtonGroup(environment,scenario,scrollbox,120,30,"INDIGNATION","mirrorknockbackresist",
													{{"Yes",true},{"No",false}})	
			tinsert(self.buttongroups,buttongroup)
		

			
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
		
		local alpha
		
		if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==1)then
			self.desclabel["dancetype"]:SetText("As seen in most strategy guides.")		
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
			self.desclabel["dancetype"]:SetText("A slightly different dance used by some guilds.")
		end
		self.desclabel["dancetype"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.INDIGNATION.hintarrow==true)then
			self.desclabel["hintarrow"]:SetText("")		
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.hintarrow==false)then
			self.desclabel["hintarrow"]:SetText("You will still be penalized if you drop Fatal Finesse too far from where the arrow would have been.  Be careful.")
		end
		self.desclabel["hintarrow"]:AutoSize()		
		
		if(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway~=0)then
			self.desclabel["mirrorgroup"]:SetText("")			
			alpha=1.0
		else
			self.desclabel["mirrorgroup"]:SetText("(Not used when starting from phase start.)")
			alpha=0.333
		end
		self.desclabel["mirrorgroup"]:AutoSize()
		
		if(XPRACTICE_SAVEDATA.INDIGNATION.killplayerforunnecessarysoak==false)then
			self.desclabel["killplayerforunnecessarysoak"]:SetText("")		
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.killplayerforunnecessarysoak==true)then
			self.desclabel["killplayerforunnecessarysoak"]:SetText("The hint arrow ignores this setting.  Do not believe its lies.")
		end
		self.desclabel["killplayerforunnecessarysoak"]:AutoSize()		
		
		local group=self.mirrorrealmgroup
		for j=1,#group do
			local button=group[j]
			button:SetLockedStartingAlpha(alpha)
		end
		for i=1,#self.mirrorrealmlabels do
			self.mirrorrealmlabels[i].alpha=alpha
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
	
	function class:OnEscapeKey()
		self.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
	end	
end

-- do not register scenario to main menu
