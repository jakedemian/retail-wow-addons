do
	local super=XPRACTICE.Scenario
	XPRACTICE.FATESCRIBEMULTIPLAYER.Scenario_Options=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Scenario_Options
	
	local savedataname="FATESCRIBEMULTIPLAYER"
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.parentscenario=XPRACTICE.FATESCRIBEMULTIPLAYER.Scenario
	end

	
	XPRACTICE.GetSaveDataDefaults[savedataname]=function()
		local defaults={}
		
		defaults.ringangle1=math.pi*1
		defaults.ringangle2=math.pi*1
		defaults.ringangle3=math.pi*1
		defaults.ringangle4=math.pi*1
		defaults.ringangle5=math.pi*1
		defaults.ringangle6=math.pi*1
		defaults.ringdir1=3
		defaults.ringdir2=3
		defaults.ringdir3=3
		defaults.ringdir4=3
		defaults.ringdir5=3
		defaults.ringdir6=3
		defaults.ringrune1=7
		defaults.ringrune2=7
		defaults.ringrune3=7
		defaults.ringrune4=7
		defaults.ringrune5=7
		defaults.ringrune6=7
		local angleoffset=math.pi*0
		defaults.goalangle1=0
		defaults.goalangle2=0
		defaults.goalangle3=0
		defaults.goalangle4=0
		defaults.goalangle5=0
		defaults.goalangle6=0
		-- local angleoffset=math.pi*0
		-- defaults.goalangle1=-1*-0.981031+angleoffset
		-- defaults.goalangle2=-1*2.569171+angleoffset
		-- defaults.goalangle3=-1*-1.548367+angleoffset
		-- defaults.goalangle4=-1*1.059856+angleoffset
		-- defaults.goalangle5=-1*-2.090060+angleoffset
		-- defaults.goalangle6=-1*0.027821+angleoffset
		
		defaults.customrunes=false
		defaults.customgoals=false
		
		XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.ringlasers=true
		
		defaults.WorldMarkerREDXposx = nil
		defaults.WorldMarkerREDXposy = nil
		defaults.WorldMarkerPURPLEDIAMONDposx = nil
		defaults.WorldMarkerPURPLEDIAMONDposy = nil
		defaults.WorldMarkerGREENTRIANGLEposx = nil
		defaults.WorldMarkerGREENTRIANGLEposy = nil
		defaults.WorldMarkerYELLOWSTARposx = 	nil
		defaults.WorldMarkerYELLOWSTARposy = 	nil
		defaults.WorldMarkerSILVERMOONposx =	nil
		defaults.WorldMarkerSILVERMOONposy =	nil
		defaults.WorldMarkerBLUESQUAREposx =	nil
		defaults.WorldMarkerBLUESQUAREposy =	nil
		defaults.WorldMarkerORANGECIRCLEposx =	nil
		defaults.WorldMarkerORANGECIRCLEposy =	nil
		defaults.WorldMarkerWHITESKULLposx =	nil
		defaults.WorldMarkerWHITESKULLposy =	nil
		
		
		return defaults
	end
	
	
	

	function class:Populate()
		super.Populate(self)
		
		
		self.buttongroups={}

		
		local scenario=self
		

		-- self.menubuttons={}
		-- local environment=self.game.environment_gameplay
		-- local scrollbox=XPRACTICE.ScrollBox.new()
		-- scrollbox:Setup(environment,25,self.game.SCREEN_HEIGHT-25)
		-- self.scrollbox=scrollbox
		
		-- local scrollbar=XPRACTICE.ScrollBarVertical.new()
		-- scrollbar:Setup(environment,self.game.SCREEN_WIDTH-52,2)
		-- scrollbar:SetSize(50,self.game.SCREEN_HEIGHT-4)
		-- scrollbar.scrollbox=scrollbox
		-- scrollbar:SetMaxScrollHeight(850)
		-- self.scrollbar=scrollbar
		
		
		-- XPRACTICE.OptionsMenuButton.ResetPosition()
		
		-- local scenario=self
		-- local button
		-- button=XPRACTICE.Button.new()		
		-- button:Setup(self.game.environment_gameplay)
		-- button.displayobject.parentframe=self.scrollbox.displayobject.drawable
		-- button.displayobject.drawable:SetParent(button.displayobject.parentframe)
		-- button.position={x=XPRACTICE.OptionsMenuButton.debugbuttonx,y=-1500,z=0}
		-- button:SetSize(250,30)
		-- button:SetLockedStartingAlpha(1.0)
		-- button:SetText("Reset all settings to default")
		-- button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				-- if(button=="LeftButton" and down)then 
					-- XPRACTICE.ResetSaveData(savedataname)
					-- scenario:Recalculate()
				-- end
			-- end)
	
		
		-- local button
		-- button=XPRACTICE.Button.new()		
		-- button:Setup(self.game.environment_gameplay)
		-- button.position={x=self.game.SCREEN_WIDTH-52-200-25,y=25,z=0}
		-- button.displayobject.drawable.texture:SetColorTexture(0,0,0,1)
		-- button.displayobject.drawable:SetFrameLevel(210)
		-- button:SetSize(200,120)
		-- button:SetLockedStartingAlpha(1.0)
		-- button:SetText("Save and return")
		-- button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				-- if(button=="LeftButton" and down)then 					
					-- scenario.game:LoadScenarioByClass(scenario.parentscenario)
				-- end
			-- end)
		
		--self:Recalculate()

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
