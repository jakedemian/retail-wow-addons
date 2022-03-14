local E, L, V, P, G, _ =  unpack(ElvUI);
local ABCS = E:NewModule('ActionBarCS', 'AceHook-3.0', 'AceEvent-3.0');
local AB = E:GetModule('ActionBars');
local EP = LibStub("LibElvUIPlugin-1.0")
local addon = ...
local bars
local IsAddOnLoaded = IsAddOnLoaded
local _G = _G
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS
local NUM_STANCE_SLOTS = NUM_STANCE_SLOTS

function ABCS:UpdateBarSettings(barName)
	local bar
	if barName == "barPet" then
		bar = _G["ElvUI_BarPet"]
	elseif barName == "stanceBar" then
		bar = _G["ElvUI_StanceBar"]
	else
		bar = AB["handledBars"][barName]
	end
	if not bar then return; end

	local db = E.db.actionbar[barName];

	if not db then return end

	if (db.visibility) then
		RegisterStateDriver(bar, 'visibility', db.visibility);
	end

	bar.mouseover = db.mouseover;
	if bar.mouseover then
		bar:SetAlpha(0);
	else
		bar:SetAlpha(db.alpha);
	end
end

function ABCS:EnteringCombat()
	for i = 1, bars do
		if E.db.actionbar.combatstate['bar'..i]['enable'] then
			E.db.actionbar['bar'..i]['visibility'] = E.db.actionbar.combatstate['bar'..i]['ic']['visibility']
			E.db.actionbar['bar'..i]['mouseover'] = E.db.actionbar.combatstate['bar'..i]['ic']['mouseover']
			E.db.actionbar['bar'..i]['alpha'] = E.db.actionbar.combatstate['bar'..i]['ic']['alpha']
			self:UpdateBarSettings('bar'..i);
		end
	end
	if E.db.actionbar.combatstate.barPet.enable then
		E.db.actionbar.barPet['visibility'] = E.db.actionbar.combatstate.barPet['ic']['visibility']
		E.db.actionbar.barPet['mouseover'] = E.db.actionbar.combatstate.barPet['ic']['mouseover']
		E.db.actionbar.barPet['alpha'] = E.db.actionbar.combatstate.barPet['ic']['alpha']
		self:UpdateBarSettings('barPet')
	end
	if E.db.actionbar.combatstate.stanceBar['enable'] then
		E.db.actionbar.stanceBar['mouseover'] = E.db.actionbar.combatstate.stanceBar['ic']['mouseover']
		E.db.actionbar.stanceBar['alpha'] = E.db.actionbar.combatstate.stanceBar['ic']['alpha']
		self:UpdateBarSettings('stanceBar');
	end
end

function ABCS:LeavingCombat(force, x)
	for i = 1, bars do
		if E.db.actionbar.combatstate['bar'..i]['enable'] then
			E.db.actionbar['bar'..i]['visibility'] = E.db.actionbar.combatstate['bar'..i]['ooc']['visibility']
			E.db.actionbar['bar'..i]['mouseover'] = E.db.actionbar.combatstate['bar'..i]['ooc']['mouseover']
			E.db.actionbar['bar'..i]['alpha'] = E.db.actionbar.combatstate['bar'..i]['ooc']['alpha']
			self:UpdateBarSettings('bar'..i);
		end
	end
	if E.db.actionbar.combatstate.barPet.enable then
		E.db.actionbar.barPet['visibility'] = E.db.actionbar.combatstate.barPet['ooc']['visibility']
		E.db.actionbar.barPet['mouseover'] = E.db.actionbar.combatstate.barPet['ooc']['mouseover']
		E.db.actionbar.barPet['alpha'] = E.db.actionbar.combatstate.barPet['ooc']['alpha']
		self:UpdateBarSettings('barPet');
	end
	if E.db.actionbar.combatstate.stanceBar['enable'] then
		E.db.actionbar.stanceBar['mouseover'] = E.db.actionbar.combatstate.stanceBar['ooc']['mouseover']
		E.db.actionbar.stanceBar['alpha'] = E.db.actionbar.combatstate.stanceBar['ooc']['alpha']
		self:UpdateBarSettings('stanceBar');
	end
	if force and x then
		if x == "pet" then
			if E.db.actionbar.combatstate.barPet['enable'] then
				E.db.actionbar.barPet['visibility'] = E.db.actionbar.combatstate.barPet['ooc']['visibility']
				E.db.actionbar.barPet['mouseover'] = E.db.actionbar.combatstate.barPet['ooc']['mouseover']
				E.db.actionbar.barPet['alpha'] = E.db.actionbar.combatstate.barPet['ooc']['alpha']
				self:UpdateBarSettings('barPet');
			else
				E.db.actionbar.barPet['visibility'] = E.db.actionbar.combatstate.barPet.lastSaved.visibility
				E.db.actionbar.barPet['mouseover'] = E.db.actionbar.combatstate.barPet.lastSaved.mouseover
				E.db.actionbar.barPet['alpha'] = E.db.actionbar.combatstate.barPet.lastSaved.alpha
				self:UpdateBarSettings('barPet');
			end
		elseif x == "stance" then
			if E.db.actionbar.combatstate.stanceBar['enable'] then
				E.db.actionbar.stanceBar['mouseover'] = E.db.actionbar.combatstate.stanceBar['ooc']['mouseover']
				E.db.actionbar.stanceBar['alpha'] = E.db.actionbar.combatstate.stanceBar['ooc']['alpha']
				self:UpdateBarSettings('stanceBar');
			else
				E.db.actionbar.stanceBar['mouseover'] = E.db.actionbar.combatstate.stanceBar.lastSaved.mouseover
				E.db.actionbar.stanceBar['alpha'] = E.db.actionbar.combatstate.stanceBar.lastSaved.alpha
				self:UpdateBarSettings('stanceBar');
			end
		else
			if E.db.actionbar.combatstate['bar'..x]['enable'] then
				E.db.actionbar['bar'..x]['visibility'] = E.db.actionbar.combatstate['bar'..x]['ooc']['visibility']
				E.db.actionbar['bar'..x]['mouseover'] = E.db.actionbar.combatstate['bar'..x]['ooc']['mouseover']
				E.db.actionbar['bar'..x]['alpha'] = E.db.actionbar.combatstate['bar'..x]['ooc']['alpha']
				self:UpdateBarSettings('bar'..x);
			else
				E.db.actionbar['bar'..x]['visibility'] = E.db.actionbar.combatstate['bar'..x]['lastSaved']['visibility']
				E.db.actionbar['bar'..x]['mouseover'] = E.db.actionbar.combatstate['bar'..x]['lastSaved']['mouseover']
				E.db.actionbar['bar'..x]['alpha'] = E.db.actionbar.combatstate['bar'..x]['lastSaved']['alpha']
				self:UpdateBarSettings('bar'..x);
			end
		end
	end
end

function ABCS:MouseOverOption(i)
	if not IsAddOnLoaded("ElvUI_Config") then return end
	if i == "pet" then
		if E.db.actionbar.combatstate.barPet['enable'] then
			E.Options.args.actionbar.args.barPet['args']['mouseover'] = nil
			E.Options.args.actionbar.args.barPet['args']['visibility'] = nil
			E.Options.args.actionbar.args.barPet['args']['alpha'] = nil
		else
			E.Options.args.actionbar.args.barPet['args']['mouseover'] = {
				order = 5,
				name = L['Mouse Over'],
				desc = L['The frame is not shown unless you mouse over the frame.'],
				type = "toggle",
				get = function(info) return E.db.actionbar.barPet['mouseover'] end,
				set = function(info, value) E.db.actionbar.barPet['mouseover'] = value; self:UpdateBarSettings('barPet'); end,
			}
			E.Options.args.actionbar.args.barPet['args']['alpha'] = {
				order = 12,
				type = 'range',
				name = L['Alpha'],
				isPercent = true,
				min = 0, max = 1, step = 0.01,
				get = function(info) return E.db.actionbar.barPet['alpha'] end,
				set = function(info, value) E.db.actionbar.barPet['alpha'] = value; self:UpdateBarSettings('barPet') end,
			}
			E.Options.args.actionbar.args.barPet['args']['visibility'] = {
				type = 'input',
				order = 13,
				name = L['Visibility State'],
				desc = L["This works like a macro, you can run different situations to get the actionbar to show/hide differently.\n Example: '[combat] show;hide'"],
				width = 'full',
				multiline = true,
				get = function(info) return E.db.actionbar.barPet['visibility'] end,
				set = function(info, value)
					E.db.actionbar['barPet']['visibility'] = value;
					self:UpdateBarSettings('barPet');
				end,
			}
		end
	elseif i == "stance" then
		if E.db.actionbar.combatstate.stanceBar['enable'] then
			E.Options.args.actionbar.args.stanceBar['args']['mouseover'] = nil
			E.Options.args.actionbar.args.stanceBar['args']['alpha'] = nil
		else
			E.Options.args.actionbar.args.stanceBar['args']['mouseover'] = {
				order = 5,
				name = L['Mouse Over'],
				desc = L['The frame is not shown unless you mouse over the frame.'],
				type = "toggle",
				get = function(info) return E.db.actionbar.stanceBar['mouseover'] end,
				set = function(info, value) E.db.actionbar.stanceBar['mouseover'] = value; self:UpdateBarSettings('stanceBar'); end,
			}
			E.Options.args.actionbar.args.stanceBar['args']['alpha'] = {
				order = 12,
				type = 'range',
				name = L['Alpha'],
				isPercent = true,
				min = 0, max = 1, step = 0.01,
				get = function(info) return E.db.actionbar.stanceBar['alpha'] end,
				set = function(info, value) E.db.actionbar.stanceBar['alpha'] = value; self:UpdateBarSettings('stanceBar') end,
			}
		end
	else
		if IsAddOnLoaded('ElvUI_ExtraActionBars') and i > 6 then
			if E.db.actionbar.combatstate['bar'..i]['enable'] then
				E.Options.args.blazeplugins.args.EAB.args['bar'..i]['args']['mouseover'] = nil
				E.Options.args.blazeplugins.args.EAB.args['bar'..i]['args']['visibility'] = nil
				E.Options.args.blazeplugins.args.EAB.args['bar'..i]['args']['alpha'] = nil
			else
				E.Options.args.blazeplugins.args.EAB.args['bar'..i]['args']['mouseover'] = {
					order = 5,
					name = L['Mouse Over'],
					desc = L['The frame is not shown unless you mouse over the frame.'],
					type = "toggle",
					get = function(info) return E.db.actionbar['bar'..i]['mouseover'] end,
					set = function(info, value) E.db.actionbar['bar'..i]['mouseover'] = value; self:UpdateBarSettings('bar'..i) end,
				}
				E.Options.args.blazeplugins.args.EAB.args['bar'..i]['args']['alpha'] = {
					order = 12,
					type = 'range',
					name = L['Alpha'],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.db.actionbar['bar'..i]['alpha'] end,
					set = function(info, value) E.db.actionbar['bar'..i]['alpha'] = value; self:UpdateBarSettings('bar'..i) end,
				}
				E.Options.args.blazeplugins.args.EAB.args['bar'..i]['args']['visibility'] = {
					type = 'input',
					order = 14,
					name = L['Visibility State'],
					desc = L["This works like a macro, you can run different situations to get the actionbar to show/hide differently.\n Example: '[combat] show;hide'"],
					width = 'full',
					multiline = true,
					get = function(info) return E.db.actionbar['bar'..i]['visibility'] end,
					set = function(info, value)
						E.db.actionbar['bar'..i]['visibility'] = value;
						self:UpdateBarSettings('bar'..i);
					end,
				}
			end
		else
			if E.db.actionbar.combatstate['bar'..i]['enable'] then
				E.Options.args.actionbar.args['bar'..i]['args']['mouseover'] = nil
				E.Options.args.actionbar.args['bar'..i]['args']['visibility'] = nil
				E.Options.args.actionbar.args['bar'..i]['args']['alpha'] = nil
			else
				E.Options.args.actionbar.args['bar'..i]['args']['mouseover'] = {
					order = 5,
					name = L['Mouse Over'],
					desc = L['The frame is not shown unless you mouse over the frame.'],
					type = "toggle",
					get = function(info) return E.db.actionbar['bar'..i]['mouseover'] end,
					set = function(info, value) E.db.actionbar['bar'..i]['mouseover'] = value; self:UpdateBarSettings('bar'..i) end,
				}
				E.Options.args.actionbar.args['bar'..i]['args']['alpha'] = {
					order = 12,
					type = 'range',
					name = L['Alpha'],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
					get = function(info) return E.db.actionbar['bar'..i]['alpha'] end,
					set = function(info, value) E.db.actionbar['bar'..i]['alpha'] = value; self:UpdateBarSettings('bar'..i) end,
				}
				E.Options.args.actionbar.args['bar'..i]['args']['visibility'] = {
					type = 'input',
					order = 14,
					name = L['Visibility State'],
					desc = L["This works like a macro, you can run different situations to get the actionbar to show/hide differently.\n Example: '[combat] show;hide'"],
					width = 'full',
					multiline = true,
					get = function(info) return E.db.actionbar['bar'..i]['visibility'] end,
					set = function(info, value)
						E.db.actionbar['bar'..i]['visibility'] = value;
						self:UpdateBarSettings('bar'..i);
					end,
				}
			end
		end
	end
end

function ABCS:SettingsUpdate(i)
	if i == "pet" then
		if E.db.actionbar.combatstate.barPet['enable'] then
			E.db.actionbar.combatstate.barPet.lastSaved.mouseover = E.db.actionbar.barPet.mouseover
			E.db.actionbar.combatstate.barPet.lastSaved.visibility = E.db.actionbar.barPet.visibility
			E.db.actionbar.combatstate.barPet.lastSaved.alpha = E.db.actionbar.barPet.alpha
		end
	elseif i == "stance" then
		if E.db.actionbar.combatstate.stanceBar['enable'] then
			E.db.actionbar.combatstate.stanceBar.lastSaved.mouseover = E.db.actionbar.stanceBar.mouseover
			E.db.actionbar.combatstate.stanceBar.lastSaved.alpha = E.db.actionbar.stanceBar.alpha
		end
	else
		if E.db.actionbar.combatstate['bar'..i]['enable'] then
			E.db.actionbar.combatstate['bar'..i]['lastSaved']['visibility'] = E.db.actionbar['bar'..i]['visibility']
			E.db.actionbar.combatstate['bar'..i]['lastSaved']['mouseover'] = E.db.actionbar['bar'..i]['mouseover']
			E.db.actionbar.combatstate['bar'..i]['lastSaved']['alpha'] = E.db.actionbar['bar'..i]['alpha']
		end
	end
end

function ABCS:Bar_OnEnter(bar)
	if E.private.combatstate.GlobalFullAlpha then
		for i = 1, bars do
			if not AB["handledBars"]["bar"..i].db.mouseover then
				E:UIFrameFadeIn(AB["handledBars"]["bar"..i], 0.2, AB["handledBars"]["bar"..i]:GetAlpha(), 1)
			end
		end
		if not _G["ElvUI_BarPet"].db.mouseover then E:UIFrameFadeIn(_G["ElvUI_BarPet"], 0.2, _G["ElvUI_BarPet"]:GetAlpha(), 1) end
		if not _G["ElvUI_StanceBar"].db.mouseover then
			E:UIFrameFadeIn(_G["ElvUI_StanceBar"], 0.2, _G["ElvUI_StanceBar"]:GetAlpha(), 1)
			for j=1, NUM_STANCE_SLOTS do
				buttonS = _G["ElvUI_StanceBar"].buttons[j]
				E:UIFrameFadeIn(buttonS, 0.2, buttonS:GetAlpha(), 1)
			end
		end
	else
		if bar.db.mouseover then return end
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
		if bar == _G["ElvUI_StanceBar"] then
			local button
			for i=1, NUM_STANCE_SLOTS do
				button = bar.buttons[i]
				E:UIFrameFadeIn(button, 0.2, button:GetAlpha(), 1)
			end
		end
	end
end

function ABCS:Bar_OnLeave(bar)
	if E.private.combatstate.GlobalFullAlpha then
		for i = 1, bars do
			if not AB["handledBars"]["bar"..i].db.mouseover then
				E:UIFrameFadeIn(AB["handledBars"]["bar"..i], 0.2, AB["handledBars"]["bar"..i]:GetAlpha(), AB["handledBars"]["bar"..i].db.alpha)
			end
		end
		if not _G["ElvUI_BarPet"].db.mouseover then E:UIFrameFadeIn(_G["ElvUI_BarPet"], 0.2, _G["ElvUI_BarPet"]:GetAlpha(), _G["ElvUI_BarPet"].db.alpha) end
		if not _G["ElvUI_StanceBar"].db.mouseover then
			E:UIFrameFadeIn(_G["ElvUI_StanceBar"], 0.2, _G["ElvUI_StanceBar"]:GetAlpha(), _G["ElvUI_StanceBar"].db.alpha)
			local buttonS
			for j=1, NUM_STANCE_SLOTS do
				buttonS = _G["ElvUI_StanceBar"].buttons[j]
				E:UIFrameFadeIn(buttonS, 0.2, buttonS:GetAlpha(), bar.db.alpha)
			end
		end
	else
		if bar.db.mouseover then return end
		E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), bar.db.alpha)
		if bar == _G["ElvUI_StanceBar"] then
			local button
			for i=1, NUM_STANCE_SLOTS do
				button = bar.buttons[i]
				E:UIFrameFadeIn(button, 0.2, button:GetAlpha(), bar.db.alpha)
			end
		end
	end
end

function ABCS:Button_OnEnter(button)
	local buttonS
	local bar = button:GetParent()
	if E.private.combatstate.GlobalFullAlpha then
		for i = 1, bars do
			if AB["handledBars"]["bar"..i].db.mouseover then return end
			E:UIFrameFadeIn(AB["handledBars"]["bar"..i], 0.2, AB["handledBars"]["bar"..i]:GetAlpha(), 1)
		end
		if not _G["ElvUI_BarPet"].db.mouseover then E:UIFrameFadeIn(_G["ElvUI_BarPet"], 0.2, _G["ElvUI_BarPet"]:GetAlpha(), 1) end
		if not _G["ElvUI_StanceBar"].db.mouseover then
			E:UIFrameFadeIn(_G["ElvUI_StanceBar"], 0.2, _G["ElvUI_StanceBar"]:GetAlpha(), 1)
			for j=1, NUM_STANCE_SLOTS do
				buttonS = _G["ElvUI_StanceBar"].buttons[j]
				E:UIFrameFadeIn(buttonS, 0.2, buttonS:GetAlpha(), 1)
			end
		end
	else
		-- local bar = button:GetParent()
		if bar.db.mouseover then return end
		E:UIFrameFadeIn(bar, 0.2, bar:GetAlpha(), 1)
		if bar == _G["ElvUI_StanceBar"] then
			for i=1, NUM_STANCE_SLOTS do
				buttonS = bar.buttons[i]
				E:UIFrameFadeIn(buttonS, 0.2, buttonS:GetAlpha(), 1)
			end
		end
	end
end

function ABCS:Button_OnLeave(button)
	local buttonS
	local bar = button:GetParent()
	if E.private.combatstate.GlobalFullAlpha then
		for i = 1, bars do
			if AB["handledBars"]["bar"..i].db.mouseover then return end
			E:UIFrameFadeIn(AB["handledBars"]["bar"..i], 0.2, AB["handledBars"]["bar"..i]:GetAlpha(), AB["handledBars"]["bar"..i].db.alpha)
		end
		E:UIFrameFadeIn(_G["ElvUI_BarPet"], 0.2, _G["ElvUI_BarPet"]:GetAlpha(), _G["ElvUI_BarPet"].db.alpha)
		if not _G["ElvUI_StanceBar"].db.mouseover then
			E:UIFrameFadeIn(_G["ElvUI_StanceBar"], 0.2, _G["ElvUI_StanceBar"]:GetAlpha(), _G["ElvUI_StanceBar"].db.alpha)
			for j=1, NUM_STANCE_SLOTS do
				buttonS = _G["ElvUI_StanceBar"].buttons[j]
				E:UIFrameFadeIn(buttonS, 0.2, buttonS:GetAlpha(), bar.db.alpha)
			end
		end
	else
		if bar.db.mouseover then return end
		E:UIFrameFadeOut(bar, 0.2, bar:GetAlpha(), bar.db.alpha)
		if bar == _G["ElvUI_StanceBar"] then
			for i=1, NUM_STANCE_SLOTS do
				buttonS = bar.buttons[i]
				E:UIFrameFadeIn(buttonS, 0.2, buttonS:GetAlpha(), bar.db.alpha)
			end
		end
	end
end

local function HookBar(bar)
	ABCS:HookScript(bar, "OnEnter", "Bar_OnEnter")
	ABCS:HookScript(bar, "OnLeave", "Bar_OnLeave")
	for i=1, NUM_ACTIONBAR_BUTTONS do
		local button = bar.buttons[i]
		ABCS:HookScript(button, "OnEnter", "Button_OnEnter")
		ABCS:HookScript(button, "OnLeave", "Button_OnLeave")
	end
end

local function UnhookBar(bar)
	ABCS:Unhook(bar, "OnEnter")
	ABCS:Unhook(bar, "OnLeave")
	for i=1, NUM_ACTIONBAR_BUTTONS do
		local button = bar.buttons[i]
		ABCS:Unhook(button, "OnEnter")
		ABCS:Unhook(button, "OnLeave")
	end
end

local function HookPet(bar)
	ABCS:HookScript(bar, "OnEnter", "Bar_OnEnter")
	ABCS:HookScript(bar, "OnLeave", "Bar_OnLeave")
	for i=1, NUM_PET_ACTION_SLOTS do
		local button = _G["PetActionButton"..i]
		ABCS:HookScript(button, "OnEnter", "Button_OnEnter")
		ABCS:HookScript(button, "OnLeave", "Button_OnLeave")
	end
end

local function UnhookPet(bar)
	ABCS:Unhook(bar, "OnEnter")
	ABCS:Unhook(bar, "OnLeave")
	for i=1, NUM_PET_ACTION_SLOTS do
		local button = _G["PetActionButton"..i]
		ABCS:Unhook(button, "OnEnter")
		ABCS:Unhook(button, "OnLeave")
	end
end

local function HookStance(bar)
	ABCS:HookScript(bar, "OnEnter", "Bar_OnEnter")
	ABCS:HookScript(bar, "OnLeave", "Bar_OnLeave")
	for i=1, NUM_STANCE_SLOTS do
		local button = bar.buttons[i]
		ABCS:HookScript(button, "OnEnter", "Button_OnEnter")
		ABCS:HookScript(button, "OnLeave", "Button_OnLeave")
	end
end

local function UnhookStance(bar)
	ABCS:Unhook(bar, "OnEnter")
	ABCS:Unhook(bar, "OnLeave")
	for i=1, NUM_STANCE_SLOTS do
		local button = bar.buttons[i]
		ABCS:Unhook(button, "OnEnter")
		ABCS:Unhook(button, "OnLeave")
	end
end

function ABCS:UpdateHooks(barName)
	local bar
	if barName == "barPet" then
		bar = _G["ElvUI_BarPet"]
	elseif barName == "stanceBar" then
		bar = _G["ElvUI_StanceBar"]
	else
		bar = AB["handledBars"][barName]
	end
	if not bar then return; end

	if E.db.actionbar.combatstate[barName].fullAlphaOnMouseOver or E.private.combatstate.GlobalFullAlpha then
		if barName == "barPet" then
			HookPet(bar)
		elseif barName == "stanceBar" then
			HookStance(bar)
		else
			HookBar(bar)
		end
	else
		if barName == "barPet" then
			UnhookPet(bar)
		elseif barName == "stanceBar" then
			UnhookStance(bar)
		else
			UnhookBar(bar)
		end
	end
end

function ABCS:GlobalAlpha()
	for i = 1, bars do
		self:UpdateHooks("bar"..i)
	end
	self:UpdateHooks("barPet")
	self:UpdateHooks("stanceBar")
end

function ABCS:Initialize()
	bars = IsAddOnLoaded('ElvUI_ExtraActionBars') and 10 or 6
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "EnteringCombat")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "LeavingCombat")
	EP:RegisterPlugin(addon,ABCS.GetOptions)

	for i = 1, bars do
		ABCS:MouseOverOption(i)
		self:UpdateHooks("bar"..i)
	end
	self:UpdateHooks("barPet")
	self:UpdateHooks("stanceBar")
end

local function InitializeCallback()
	ABCS:Initialize()
end

E:RegisterModule(ABCS:GetName(), InitializeCallback)