---------------------------------------------------------------
-- Tukui RoleIcons - Battle for Azeroth - 02-01-2019
---------------------------------------------------------------

-- setting up role icons for raidframes instead of using the colored name tags.

---------------------------------------------------------------
-- Locals
---------------------------------------------------------------
local T, C, L = Tukui:unpack()
local UnitFrames = T["UnitFrames"]

---------------------------------------------------------------
-- Tukui RoleIcons OPTIONS
---------------------------------------------------------------
C["Raid"]["CustomIcons"] = true
C["Raid"]["ElvUIIcons"] = false
C["Raid"]["BlizzIcons"] = false

local CustomIcons = {
			["Name"] = "|cffFFFF99Custom Roll Icons|r",
			["Desc"] = "Enable/Disable the custom Roll Icons for Tukui, it will remove the colored names for the raidframes.",
}
TukuiConfig.enUS["Raid"]["CustomIcons"] = CustomIcons

local ElvUIIcons = {
			["Name"] = "|cffFFFF99ElvUI Roll Icons|r",
			["Desc"] = "Enable/Disable the custom Roll Icons for Tukui, it will remove the colored names for the raidframes.",
}
TukuiConfig.enUS["Raid"]["ElvUIIcons"] = ElvUIIcons

local BlizzIcons = {
			["Name"] = "|cffFFFF99Blizzard Roll Icons|r",
			["Desc"] = "Enable/Disable the custom Roll Icons for Tukui, it will remove the colored names for the raidframes.",
}
TukuiConfig.enUS["Raid"]["BlizzIcons"] = BlizzIcons

---------------------------------------------------------------
-- Set Grid Group Role Function
---------------------------------------------------------------
function UnitFrames:SetGridGroupRole()
	local GroupRoleIndicator = self.GroupRoleIndicator
	local Role = UnitGroupRolesAssigned(self.unit)

		if Role == "TANK" then
			if C["Raid"]["CustomIcons"] == true then
				GroupRoleIndicator:SetTexture("Interface\\AddOns\\Tukui_RoleIcons\\Textures\\tank2.tga")
			else 
				GroupRoleIndicator:SetTexture("Interface\\AddOns\\Tukui_RoleIcons\\Textures\\tank.tga")
			end
			GroupRoleIndicator:Show()
				
		elseif Role == "HEALER" then
			if C["Raid"]["CustomIcons"] == true then
				GroupRoleIndicator:SetTexture("Interface\\AddOns\\Tukui_RoleIcons\\Textures\\healer3.tga")
			else
				GroupRoleIndicator:SetTexture("Interface\\AddOns\\Tukui_RoleIcons\\Textures\\healer.tga")
			end
			GroupRoleIndicator:Show()

		elseif Role == "DAMAGER" then
			if C["Raid"]["CustomIcons"] == true then
				GroupRoleIndicator:SetTexture("Interface\\AddOns\\Tukui_RoleIcons\\Textures\\dps2.tga")
			else
				GroupRoleIndicator:SetTexture("Interface\\AddOns\\Tukui_RoleIcons\\Textures\\dps.tga")
			end
			GroupRoleIndicator:Show()
		else
			GroupRoleIndicator:Hide()
		end
	end	
T["UnitFrames"] = UnitFrames

---------------------------------------------------------------
-- Tukui RoleIcons Code
---------------------------------------------------------------
local function Raid(self)
	local Health = self.Health
	local Name = self.Name
	local RaidIcon = self.RaidTargetIndicator
	
	if C["Raid"]["CustomIcons"] == true or C["Raid"]["ElvUIIcons"] == true or C["Raid"]["BlizzIcons"] == true then

		-- name, remove the coloring by role
		self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameShort]")
		
		-- raidicon
		RaidIcon:ClearAllPoints()
		RaidIcon:Point("TOP", Health, 10, 8)

		local GroupRoleIndicator = Health:CreateTexture(nil, "OVERLAY")
		GroupRoleIndicator:Size(18)
		GroupRoleIndicator:SetPoint("TOP", Health, -10, 8) -- adjust the position: TOP 
		--GroupRoleIndicator:SetPoint("LEFT", Health, 2, 0) -- adjust the position: LEFT
		--GroupRoleIndicator:SetPoint("CENTER", Health, 0, 0) -- adjust the position: CEMTER 
		--GroupRoleIndicator:SetPoint("RIGHT", Health, -2, 0) -- adjust the position: RIGHT
			self.GroupRoleIndicator = GroupRoleIndicator
		
		if C["Raid"]["CustomIcons"] == true or C["Raid"]["ElvUIIcons"] == true then
			GroupRoleIndicator.Override = UnitFrames.SetGridGroupRole
		end
	end	
end
hooksecurefunc(UnitFrames, "Raid", Raid)