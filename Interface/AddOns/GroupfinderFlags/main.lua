-- Addon:	     GroupfinderFlags
-- Author:	     Spielstein@Curse
-- Contributor:  Turtle919@Curse (Data and flag pictures of the american/oceanic region)


----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------  Variables, databases and constants  ------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------

-- Creating MainFrame
GroupfinderFlags = {}
GroupfinderFlags.mainFrame = CreateFrame("Frame", "GroupfinderFlagsFrame", UIParent)
GroupfinderFlags.FIRST_SLASH_START = 0

-- own realm
GroupfinderFlags.OWN_REALM = GetRealmName()

-- locale code
GroupfinderFlags.LOCALE_CODE = "enUS"
local locale = GetLocale()

-- german localization
if locale == "deDE" then
	GroupfinderFlags.LOCALE_CODE = "deDE"
-- french localization
elseif locale == "frFR" then
	GroupfinderFlags.LOCALE_CODE = "frFR"
-- italian localization
elseif locale == "itIT" then
	GroupfinderFlags.LOCALE_CODE = "itIT"
-- russian localization
elseif locale == "ruRU" then
	GroupfinderFlags.LOCALE_CODE = "ruRU"
-- spanish localization
elseif locale == "esES" then
	GroupfinderFlags.LOCALE_CODE = "esES"
-- (mexican) spanish localization
elseif locale == "esMX" then
	GroupfinderFlags.LOCALE_CODE = "esMX"
-- portuguese localization
elseif locale == "ptBR" then
	GroupfinderFlags.LOCALE_CODE = "ptBR"
end


-- flage files
GroupfinderFlags.PATH = "|TInterface\\AddOns\\GroupfinderFlags\\images\\"
GroupfinderFlags.SIZE = ":9:15|t"
GroupfinderFlags.FLAGS = {
	-- europe
	["german"] = "german"..GroupfinderFlags.SIZE,
	["british"] = "british"..GroupfinderFlags.SIZE,
	["portuguese"] = "portuguese"..GroupfinderFlags.SIZE,
	["russian"] = "russian"..GroupfinderFlags.SIZE,
	["french"] = "french"..GroupfinderFlags.SIZE,
	["spanish"] = "spanish"..GroupfinderFlags.SIZE,
	["italian"] = "italian"..GroupfinderFlags.SIZE,
	-- american/oceanic
	["american"] = "american"..GroupfinderFlags.SIZE,
	["brazilian"] = "brazilian"..GroupfinderFlags.SIZE,
	["oceanic"] = "oceanic"..GroupfinderFlags.SIZE,
	["mexican"] = "mexican"..GroupfinderFlags.SIZE,
}

-- continent maps
GroupfinderFlags.MAPS = {
	["america"] = "Interface\\Addons\\GroupfinderFlags\\images\\map_america_oceania.tga",
	["europe"] = "Interface\\Addons\\GroupfinderFlags\\images\\map_europe.tga",
	["america_sw"] = "Interface\\Addons\\GroupfinderFlags\\images\\map_america_oceania_sw.tga",
	["europe_sw"] = "Interface\\Addons\\GroupfinderFlags\\images\\map_europe_sw.tga",
}
GroupfinderFlags.BUTTON_OVERLAY = "Interface\\Addons\\GroupfinderFlags\\images\\button_overlay.tga"

local function GFF_ManipulateTextureColors(btn)
	if btn.Top         then btn.Top:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.TopLeft     then btn.TopLeft:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.TopRight    then btn.TopRight:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.Bottom      then btn.Bottom:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.BottomLeft  then btn.BottomLeft:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.BottomRight then btn.BottomRight:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.Left        then btn.Left:SetVertexColor(0.6157, 0.4627, 0.0902) end
	if btn.Right       then btn.Right:SetVertexColor(0.6157, 0.4627, 0.0902) end
end


----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------  Options panel  ---------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------

-- option panel

local opanel = CreateFrame("Frame", "GroupfinderFlagsOptionsPanel", UIParent)

-- main titles
opanel.title = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
opanel.title:SetPoint("TOPLEFT", 16, -16)
opanel.title:SetText("GroupfinderFlags")
opanel.title:SetJustifyH("LEFT")

opanel.title2 = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.title2:SetPoint("TOPLEFT", 16, -35)
opanel.title2:SetText("Author: Spielstein@Curse\nVersion: " .. GetAddOnMetadata("GroupfinderFlags", "Version"))
opanel.title2:SetJustifyH("LEFT")


-- region selection title
opanel.regionTitle = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
opanel.regionTitle:SetPoint("TOPLEFT",  opanel.title2, "BOTTOMLEFT", 0, -20)
opanel.regionTitle:SetText("Region selection")
opanel.regionTitle:SetJustifyH("LEFT")

-- region selection
opanel.us_button = CreateFrame("Button", "GFF_US_Button", opanel, "ThinBorderTemplate")
opanel.us_button:SetPoint("TOPLEFT", opanel.regionTitle, "BOTTOMLEFT", 16, -5)
opanel.us_button:SetSize(64, 64)
opanel.us_button:SetNormalTexture(GroupfinderFlags.MAPS.america_sw)
opanel.us_button:SetPushedTexture(GroupfinderFlags.MAPS.america)
opanel.us_button:SetDisabledTexture(GroupfinderFlags.MAPS.america)
opanel.us_button:SetHighlightTexture(GroupfinderFlags.BUTTON_OVERLAY, 0.5)
opanel.us_button:SetScript("OnClick", function (self)
	GroupfinderFlagsDB.region = "america"
	self:Disable()
	self:GetParent().eu_button:Enable()
end)
GFF_ManipulateTextureColors(opanel.us_button)
opanel.us_button:Disable()

opanel.us_text = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.us_text:SetText("America\nOceania")
opanel.us_text:SetPoint("TOP", opanel.us_button, "BOTTOM", 0, 0)

opanel.eu_button = CreateFrame("Button", "GFF_EU_Button", opanel, "ThinBorderTemplate")
opanel.eu_button:SetPoint("LEFT", opanel.us_button, "RIGHT", 32, 0)
opanel.eu_button:SetSize(64, 64)
opanel.eu_button:SetNormalTexture(GroupfinderFlags.MAPS.europe_sw)
opanel.eu_button:SetPushedTexture(GroupfinderFlags.MAPS.europe)
opanel.eu_button:SetDisabledTexture(GroupfinderFlags.MAPS.europe)
opanel.eu_button:SetHighlightTexture(GroupfinderFlags.BUTTON_OVERLAY, 0.5)
opanel.eu_button:SetScript("OnClick", function (self)
	GroupfinderFlagsDB.region = "europe"
	self:Disable()
	self:GetParent().us_button:Enable()
end)
GFF_ManipulateTextureColors(opanel.eu_button)
opanel.eu_button:Disable()

opanel.eu_text = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.eu_text:SetText("Europe")
opanel.eu_text:SetPoint("TOP", opanel.eu_button, "BOTTOM", 0, -(opanel.eu_text:GetStringHeight()/2))


-- option title
opanel.optionTitle = opanel:CreateFontString(nil, "ARTWORK", "GameFontNormalMed3")
opanel.optionTitle:SetPoint("TOPLEFT",  opanel.regionTitle, "BOTTOMLEFT", 0, -110)
opanel.optionTitle:SetText("Options")
opanel.optionTitle:SetJustifyH("LEFT")

-- option for disabling flags in the groupfinder
opanel.boxForGrpFinder = CreateFrame("CheckButton", "GFF_ShowGrpFinderFlagCheckbox", opanel, "OptionsBaseCheckButtonTemplate")
opanel.boxForGrpFinder:SetPoint("TOPLEFT", opanel.optionTitle, "BOTTOMLEFT", 0, -5)
opanel.boxForGrpFinder:SetScript("OnClick", function()
	GroupfinderFlagsDB.showFlagInGrpFinder = not GroupfinderFlagsDB.showFlagInGrpFinder
	opanel.boxForGrpFinder:SetChecked(GroupfinderFlagsDB.showFlagInGrpFinder)
end)
opanel.boxtextForGrpFinder = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.boxtextForGrpFinder:SetPoint("LEFT", opanel.boxForGrpFinder, "RIGHT", 10, 1)
opanel.boxtextForGrpFinder:SetJustifyH("LEFT")
opanel.boxtextForGrpFinder:SetText("Show the country's flag in the Groupfinder UI")

-- option for disabling flags in tooltip
opanel.boxForTooltipFlag = CreateFrame("CheckButton", "GFF_ShowTooltipFlagCheckbox", opanel, "OptionsBaseCheckButtonTemplate")
opanel.boxForTooltipFlag:SetPoint("TOPLEFT", opanel.boxForGrpFinder, "BOTTOMLEFT", 0, -1)
opanel.boxForTooltipFlag:SetScript("OnClick", function()
	GroupfinderFlagsDB.showFlagInTooltip = not GroupfinderFlagsDB.showFlagInTooltip
	opanel.boxForTooltipFlag:SetChecked(GroupfinderFlagsDB.showFlagInTooltip)
end)
opanel.boxtextForTooltipFlag = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.boxtextForTooltipFlag:SetPoint("LEFT", opanel.boxForTooltipFlag, "RIGHT", 10, 1)
opanel.boxtextForTooltipFlag:SetJustifyH("LEFT")
opanel.boxtextForTooltipFlag:SetText("Show the country's flag in the tooltips")

-- option for disabling country name next to flag
opanel.boxForTooltipCountryNames = CreateFrame("CheckButton", "GFF_ShowTooltipCountryNameCheckbox", opanel, "OptionsBaseCheckButtonTemplate")
opanel.boxForTooltipCountryNames:SetPoint("TOPLEFT", opanel.boxForTooltipFlag, "BOTTOMLEFT", 0, -1)
opanel.boxForTooltipCountryNames:SetScript("OnClick", function()
	GroupfinderFlagsDB.showCountrynameInTooltip = not GroupfinderFlagsDB.showCountrynameInTooltip
	opanel.boxForTooltipCountryNames:SetChecked(GroupfinderFlagsDB.showCountrynameInTooltip)
end)
opanel.boxtextForTooltipCountryNames = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.boxtextForTooltipCountryNames:SetPoint("LEFT", opanel.boxForTooltipCountryNames, "RIGHT", 10, 1)
opanel.boxtextForTooltipCountryNames:SetJustifyH("LEFT")
opanel.boxtextForTooltipCountryNames:SetText("Show the country's name next to the flag in tooltips")

-- option for showing the informatio only if realm languages are different
opanel.boxForOnlyShowingIfLanguagesDiff = CreateFrame("CheckButton", "GFF_ShowFlagOnlyIfLangDiffCheckbox", opanel, "OptionsBaseCheckButtonTemplate")
opanel.boxForOnlyShowingIfLanguagesDiff:SetPoint("TOPLEFT", opanel.boxForTooltipCountryNames, "BOTTOMLEFT", 0, -1)
opanel.boxForOnlyShowingIfLanguagesDiff:SetScript("OnClick", function()
	GroupfinderFlagsDB.showFlagOnlyIfOtherCountry = not GroupfinderFlagsDB.showFlagOnlyIfOtherCountry
	opanel.boxForOnlyShowingIfLanguagesDiff:SetChecked(GroupfinderFlagsDB.showFlagOnlyIfOtherCountry)
end)
opanel.boxtextForOnlyShowingIfLanguagesDiff = opanel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
opanel.boxtextForOnlyShowingIfLanguagesDiff:SetPoint("LEFT", opanel.boxForOnlyShowingIfLanguagesDiff, "RIGHT", 10, 1)
opanel.boxtextForOnlyShowingIfLanguagesDiff:SetJustifyH("LEFT")
opanel.boxtextForOnlyShowingIfLanguagesDiff:SetText("Only show the flag/county name if my and their language is different.")


GroupfinderFlags.opanel = opanel
GroupfinderFlags.opanel.name = "GroupfinderFlags";
InterfaceOptions_AddCategory(GroupfinderFlags.opanel);


----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------  Hooking functions  -----------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------

-- hooking the gametooltip
local function HookfunctionForGametooltip(...)

	if not (GroupfinderFlagsDB.showFlagInTooltip or GroupfinderFlagsDB.showCountrynameInTooltip) then
		return
	end

	-- variables
	local _
	local name, unit, GUID, realm, languageList

	-- get unit infos from the game tooltip
	_, unit = GameTooltip:GetUnit()

	if unit ~= nil then

		-- get GUID infos from the game tooltip
		GUID = UnitGUID(unit)

		if GUID ~= nil then
			-- checking whether the unit is a player
			if string.match(UnitGUID(unit), "^Player-") then

				-- gets name and realm of the player
				name, realm = UnitName(unit)

				-- if realm is nil then player is from user's own realm
				if realm == nil or realm == "" then
					realm = GroupfinderFlags.OWN_REALM
				end

				-- check whether region is selected
				if GroupfinderFlagsDB.region ~= nil and (GroupfinderFlagsDB.region == "europe" or GroupfinderFlagsDB.region == "america") then

					-- get region specific realm language list
					if GroupfinderFlagsDB.region == "europe" then
						languageList = GroupfinderFlags.EU_REALM_LANGUAGES
					elseif GroupfinderFlagsDB.region == "america" then
						languageList = GroupfinderFlags.US_REALM_LANGUAGES
					end


					-- only proceed if player's realm is in database
					if languageList[realm] ~= nil then

						-- if option "showFlagOnlyIfOtherCountry" is active, only proceed with different languages
						if not GroupfinderFlagsDB.showFlagOnlyIfOtherCountry or languageList[realm] ~= languageList[GroupfinderFlags.OWN_REALM] then

							-- adding the flag by :AddLine()
							local flag = GroupfinderFlags.PATH..GroupfinderFlags.FLAGS[languageList[realm]]
							local country_name = "|cFFFFFFFF" .. GroupfinderFlags.COUNTRYNAMES[GroupfinderFlags.LOCALE_CODE][languageList[realm]] .. "|r"
							local both_activated = GroupfinderFlagsDB.showFlagInTooltip and GroupfinderFlagsDB.showCountrynameInTooltip
							GameTooltip:AddLine((GroupfinderFlagsDB.showFlagInTooltip and flag or "") .. (both_activated and "|cFFFFFFFF - |r" or "") .. (GroupfinderFlagsDB.showCountrynameInTooltip and country_name or ""))
							--  and readjusting the height and the width of the tooltip by :Show()
							GameTooltip:Show()
						end
					end
				end
			end
		end
	end
end


--
local function HookfunctionForGroupFinderSearchTooltip(tooltip, resultID)

	if not (GroupfinderFlagsDB.showFlagInTooltip or GroupfinderFlagsDB.showCountrynameInTooltip) then
		return
	end

	-- check whether region is selected
	if GroupfinderFlagsDB.region == nil or (GroupfinderFlagsDB.region ~= "europe" and GroupfinderFlagsDB.region ~= "america") then
		return
	end

	local _
	local leaderName, shortname, fullname, realm, languageList

	leaderName = C_LFGList.GetSearchResultInfo(resultID)["leaderName"];

	if leaderName == nil then
		return
	end

	-- extract name+realm and (only) name
	shortname = Ambiguate(leaderName, "short")
	fullname = Ambiguate(leaderName, "mail")

	-- if:     shortname and fullname are equal -> applicant is from user's own realm
	-- else:   extract realm from fullname
	if shortname == fullname then
		realm = GroupfinderFlags.OWN_REALM
	else
		realm = string.sub(fullname, string.len(shortname)+2)
	end

	-- get region specific realm language list
	if GroupfinderFlagsDB.region == "europe" then
		languageList = GroupfinderFlags.EU_REALM_LANGUAGES
	elseif GroupfinderFlagsDB.region == "america" then
		languageList = GroupfinderFlags.US_REALM_LANGUAGES
	end

	-- only proceed if player's realm is in database
	if languageList[realm] ~= nil then

		-- if option "showFlagOnlyIfOtherCountry" is active, only proceed with different languages
		if not GroupfinderFlagsDB.showFlagOnlyIfOtherCountry or languageList[realm] ~= languageList[GroupfinderFlags.OWN_REALM] then

			-- adding the flag by :AddLine()
			local flag = GroupfinderFlags.PATH..GroupfinderFlags.FLAGS[languageList[realm]]
			local country_name = "|cFFFFFFFF" .. GroupfinderFlags.COUNTRYNAMES[GroupfinderFlags.LOCALE_CODE][languageList[realm]] .. "|r"
			local both_activated = GroupfinderFlagsDB.showFlagInTooltip and GroupfinderFlagsDB.showCountrynameInTooltip
			tooltip:AddLine(" ")
			tooltip:AddLine((GroupfinderFlagsDB.showFlagInTooltip and flag or "") .. (both_activated and "|cFFFFFFFF - |r" or "") .. (GroupfinderFlagsDB.showCountrynameInTooltip and country_name or ""))
			--  and readjusting the height and the width of the tooltip by :Show()
			tooltip:Show()
		end
	end

end


-- hooking function for the applicantviewer
local function HookfunctionForGroupFinderApplicants(member, appID, memberIdx)

	if not GroupfinderFlagsDB.showFlagInGrpFinder then
		return
	end

	-- check whether region is selected
	if GroupfinderFlagsDB.region == nil or (GroupfinderFlagsDB.region ~= "europe" and GroupfinderFlagsDB.region ~= "america") then
		return
	end

	-- variables
	local realm, shortname, fullname, languageList

	-- getting applicant's name
	local name, _, _, _, _, _, _, _, _, _, relationship = C_LFGList.GetApplicantMemberInfo(appID, memberIdx);

	if GroupfinderFlagsDB.region == nil or (GroupfinderFlagsDB.region ~= "europe" and GroupfinderFlagsDB.region ~= "america") then
		return
	end

	-- extract name+realm and (only) name
	shortname = Ambiguate(name, "short")
	fullname = Ambiguate(name, "mail")

	-- if:     shortname and fullname are equal -> applicant is from user's own realm
	-- else:   extract realm from fullname
	if shortname == fullname then
		realm = GroupfinderFlags.OWN_REALM
	else
		realm = string.sub(fullname, string.len(shortname)+2)
	end

	-- get region specific realm language list
	if GroupfinderFlagsDB.region == "europe" then
		languageList = GroupfinderFlags.EU_REALM_LANGUAGES
	elseif GroupfinderFlagsDB.region == "america" then
		languageList = GroupfinderFlags.US_REALM_LANGUAGES
	end

	-- if option "showFlagOnlyIfOtherCountry" is active, only proceed with different languages
	if GroupfinderFlagsDB.showFlagOnlyIfOtherCountry and languageList[realm] == languageList[GroupfinderFlags.OWN_REALM] then
		return
	end

	-- add a font string for displaying the flag if needed
	if not member.flag then
		member.flag = member:CreateFontString("$parentFlag", "ARTWORK", "GameFontNormalSmall")
		member.flag:SetPoint("LEFT", member.Name, "RIGHT", 3, 0)
	end
	-- set the appropiate flag
	member.flag:SetText(languageList[realm] ~= nil and GroupfinderFlags.PATH..GroupfinderFlags.FLAGS[languageList[realm]] or "")

	-- recalculate the name column's width (taken from blizz code and modified)
	local nameLength = 100 - 15
	if relationship then
		member.FriendIcon:SetPoint("LEFT", member.flag, "RIGHT", 0, 0)
		nameLength = nameLength - 22
	end
  	if ( member.Name:GetWidth() > nameLength ) then
    	member.Name:SetWidth(nameLength)
  	end

end

local function OnLFGListSearchEntryUpdate(self)
	local searchResultInfo = C_LFGList.GetSearchResultInfo(self.resultID)
	local leaderName = searchResultInfo.leaderName;

	if leaderName == nil then
		return
	end

	-- extract name+realm and (only) name
	shortname = Ambiguate(leaderName, "short")
	fullname = Ambiguate(leaderName, "mail")

	-- if:     shortname and fullname are equal -> applicant is from user's own realm
	-- else:   extract realm from fullname
	if shortname == fullname then
		realm = GroupfinderFlags.OWN_REALM
	else
		realm = string.sub(fullname, string.len(shortname)+2)
	end

	-- get region specific realm language list
	if GroupfinderFlagsDB.region == "europe" then
		languageList = GroupfinderFlags.EU_REALM_LANGUAGES
	elseif GroupfinderFlagsDB.region == "america" then
		languageList = GroupfinderFlags.US_REALM_LANGUAGES
	end

	-- if option "showFlagOnlyIfOtherCountry" is active, only proceed with different languages
	if GroupfinderFlagsDB.showFlagOnlyIfOtherCountry and languageList[realm] == languageList[GroupfinderFlags.OWN_REALM] then
		return
	end

	-- add a font string for displaying the flag if needed
	if not self.flag then
		self.flag = self:CreateFontString("$parentFlag", "ARTWORK", "GameFontNormalSmall")
		self.flag:SetPoint("RIGHT", self.ActivityName, "LEFT", 3, 0)
	end
	-- set the appropiate flag
	self.flag:SetText(languageList[realm] ~= nil and GroupfinderFlags.PATH..GroupfinderFlags.FLAGS[languageList[realm]] or "")

	self.ActivityName:SetText(self.ActivityName:GetText())
end


----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------  OnEvent Handler  -------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------

-- OnEvent handler
local function OnEvent(self, event, arg1, arg2, ...)
	if event == "ADDON_LOADED" and arg1 == "GroupfinderFlags" then

		-- creating the saved variables' array if needed
		if GroupfinderFlagsDB == nil then
			GroupfinderFlagsDB = {}
    	end

    	-- set the saved variables' default value if needed
    	if GroupfinderFlagsDB.showFlagInGrpFinder == nil then
    		GroupfinderFlagsDB.showFlagInGrpFinder = true
    	end
		if GroupfinderFlagsDB.showFlagInTooltip == nil then
			GroupfinderFlagsDB.showFlagInTooltip = true
		end
		if GroupfinderFlagsDB.showCountrynameInTooltip == nil then
			GroupfinderFlagsDB.showCountrynameInTooltip = true
		end
		if GroupfinderFlagsDB.showFlagOnlyIfOtherCountry == nil then
			GroupfinderFlagsDB.showFlagOnlyIfOtherCountry = false
		end

		-- unregister PLAYER_LOGIN after retrieving saved variables
    	--GroupfinderFlags.mainFrame:UnregisterEvent("PLAYER_LOGIN")
    	GroupfinderFlags.mainFrame:UnregisterEvent("ADDON_LOADED")

    	-- set up the option panel
    	GroupfinderFlags.opanel.boxForGrpFinder:SetChecked(GroupfinderFlagsDB.showFlagInGrpFinder)
    	GroupfinderFlags.opanel.boxForTooltipFlag:SetChecked(GroupfinderFlagsDB.showFlagInTooltip)
    	GroupfinderFlags.opanel.boxForTooltipCountryNames:SetChecked(GroupfinderFlagsDB.showCountrynameInTooltip)
    	GroupfinderFlags.opanel.boxForOnlyShowingIfLanguagesDiff:SetChecked(GroupfinderFlagsDB.showFlagOnlyIfOtherCountry)

    	if GroupfinderFlagsDB.region ~= nil then
    		if GroupfinderFlagsDB.region == "europe" then
    			GroupfinderFlags.opanel.us_button:Enable()
    		elseif GroupfinderFlagsDB.region == "america" then
    			GroupfinderFlags.opanel.eu_button:Enable()
    		end
    	end

    	-- if no region is selected build and show selection dialog
    	if GroupfinderFlagsDB.region == nil then

    		local selectionFrame = CreateFrame("Frame", "GroupfinderFlagsRegionSelection", UIParent, "GlowBoxTemplate")--"ThinBorderTemplate") --GlowBoxTemplate
			selectionFrame:SetSize(300,200)

    		local top_text1 = selectionFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    		top_text1:SetText("GroupfinderFlags")
    		top_text1:SetPoint("TOP", selectionFrame, "TOP", 0, -20)

    		local top_text2 = selectionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    		top_text2:SetText("Choose your Region")
    		top_text2:SetPoint("TOP", top_text1, "BOTTOM", 0, 0)

			local eu_button = CreateFrame("Button", "GFF_EU_RegionButton", selectionFrame, "ThinBorderTemplate")
			eu_button:SetPoint("CENTER", selectionFrame, "CENTER", 48, -10)
			eu_button:SetSize(64, 64)
			eu_button:SetNormalTexture(GroupfinderFlags.MAPS.europe_sw)
			eu_button:SetPushedTexture(GroupfinderFlags.MAPS.europe)
			eu_button:SetHighlightTexture(GroupfinderFlags.BUTTON_OVERLAY)
			eu_button:SetScript("OnClick", function (self)
				GroupfinderFlagsDB.region = "europe"
				GroupfinderFlags.opanel.us_button:Enable()
				self:GetParent():Hide()
			end)
			GFF_ManipulateTextureColors(eu_button)

			local eu_text = selectionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			eu_text:SetText("Europe")
			eu_text:SetPoint("TOP", eu_button, "BOTTOM", 0, -(eu_text:GetStringHeight()/2))

			local us_button = CreateFrame("Button", "GFF_US_RegionButton", selectionFrame, "ThinBorderTemplate")
			us_button:SetPoint("CENTER", selectionFrame, "CENTER", -48, -10)
			us_button:SetSize(64, 64)
			us_button:SetNormalTexture(GroupfinderFlags.MAPS.america_sw)
			us_button:SetPushedTexture(GroupfinderFlags.MAPS.america)
			us_button:SetHighlightTexture(GroupfinderFlags.BUTTON_OVERLAY)
			us_button:SetScript("OnClick", function (self)
				GroupfinderFlagsDB.region = "america"
				GroupfinderFlags.opanel.eu_button:Enable()
				self:GetParent():Hide()
			end)
			GFF_ManipulateTextureColors(us_button)

			local us_text = selectionFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
			us_text:SetText("America\nOceania")
			us_text:SetPoint("TOP", us_button, "BOTTOM", 0, 0)


			selectionFrame:SetPoint("CENTER",0,0)
			selectionFrame:Show()

			selectionFrame.top_text1 = top_text1
			selectionFrame.top_text2 = top_text2

    		selectionFrame.eu_button = eu_button
    		selectionFrame.eu_text = eu_text

    		selectionFrame.us_button = us_button
    		selectionFrame.us_text = us_text

    		GroupfinderFlags.regionSelectionFrame = selectionFrame
    	end
	end
end


----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------  Script startup  --------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------

-- hooking blizz's code: --
-- hook for the applicantviewer
hooksecurefunc("LFGListApplicationViewer_UpdateApplicantMember", HookfunctionForGroupFinderApplicants)
--
hooksecurefunc("LFGListUtil_SetSearchEntryTooltip", HookfunctionForGroupFinderSearchTooltip)


  hooksecurefunc("LFGListSearchEntry_Update", OnLFGListSearchEntryUpdate)
-- hook for the gametooltip
GameTooltip:HookScript("OnTooltipSetUnit", HookfunctionForGametooltip)

-- loading saved settings
GroupfinderFlags.mainFrame:RegisterEvent("ADDON_LOADED")
GroupfinderFlags.mainFrame:SetScript("OnEvent", OnEvent)


-- slash commands
SLASH_GROUPFINDERFLAGS1 = "/gff"
SLASH_GROUPFINDERFLAGS2 = "/groupfinderflags"
SlashCmdList["GROUPFINDERFLAGS"] = function(msg)
    if GroupfinderFlags.FIRST_SLASH_START == 0 then
        GroupfinderFlags.FIRST_SLASH_START = 1
        InterfaceOptionsFrame_OpenToCategory(GroupfinderFlags.opanel)
    end
    InterfaceOptionsFrame_OpenToCategory(GroupfinderFlags.opanel)
end
