

-- TODO NEXT:
-- change key state during KeyDown/KeyUp events only
-- for one frame following a KeyDown event, current=true even if a KeyUp occurred afterwards
		-- (probably requires a logic rewrite)


-- new plan:
-- game keeps list of RawInput (keycode index)
-- 

XPRACTICE.RawInput = {}
XPRACTICE.RawInput.__index = XPRACTICE.RawInput

function XPRACTICE.RawInput:new()
	local self={}
	setmetatable(self, XPRACTICE.RawInput)	
	
	self.keys={}
	
	--mousewheel uses SetMouseWheel instead and the system expects it to exist already
	self.keys["WMOUSE"]=XPRACTICE.Key:new()
	
	return self
end

function XPRACTICE.RawInput:CreateKeycodeIfNotExists(keycode)
	if(not self.keys[keycode])then		
		self.keys[keycode]=XPRACTICE.Key.new()
	end
end

function XPRACTICE.RawInput:EndStep()
	--call at very end of frame to turn off pressed/released status.
	for k,v in pairs(self.keys) do
		v.pressed=false
		v.released=false
	end	
end

function XPRACTICE.RawInput:SetKey(keycode,state)
	--self:CreateKeycodeIfNotExists(keycode)
	--self.keys[keycode]:SetKey(state)
	if(self.keys[keycode])then self.keys[keycode]:SetKey(state) end
end

function XPRACTICE.RawInput:Cleanup()
	--
end

----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------


----------------------------------------------------------

-- WC3 controls: 
-- F1-F3 to select Heroes (change to boss units instead?)
-- number row: quick select keys
-- ctrl+number row: save currently selected units to quick select
-- RMB to attack or move
-- mousewheel or pgup/pgdn to zoom
-- insert/delete to rotate camera left/right (TODO LATER, maybe)
-- Alt+RMB to move as fast as possible (breaking formation) (does alt even work in WoW?)
										-- alt works in WoW but alt+F4 still force closes
-- Tab to switch between subgroups (mDPS/rDPS/heal/tank/boss?)
-- ULDR to scroll camera (not WASD)
-- (use A+LMB as alternative to RMB?)
-- (use QWER for boss abilities?)

----------------------------------------------------------

-- A collection of "gamepad" keys intended for arcade gameplay.
-- For spells, use Game>Spells>SpellButton instead.

-- (also stores mouse info)

XPRACTICE.Keys = {}
XPRACTICE.Keys.__index = XPRACTICE.Keys

function XPRACTICE.Keys:new()
	local self={}
	setmetatable(self, XPRACTICE.Keys)	
	
	-- most access to keys is done via rawinput.map,
	-- but we still need to keep a list of keys to reset pressed status at the end of frame
	self.keys={}
	
	return self
end

function XPRACTICE.Keys:Setup(rawinput)
	--TODO: do keycodes still work in other languages?

	self.rawinput=rawinput
	--TODO: rename directional keys, maybe WASDup etc?
	self.upW=self:NewKey(XPRACTICE.Config.Keybinds.MoveForward)
	self.leftA=self:NewKey(XPRACTICE.Config.Keybinds.StrafeLeft)
	self.downS=self:NewKey(XPRACTICE.Config.Keybinds.MoveBackward)
	self.rightD=self:NewKey(XPRACTICE.Config.Keybinds.StrafeRight)
	self.turnQ=self:NewKey(XPRACTICE.Config.Keybinds.TurnLeft)
	self.turnE=self:NewKey(XPRACTICE.Config.Keybinds.TurnRight)
	
	self.up=self:NewKey("UP")
	self.left=self:NewKey("LEFT")
	self.down=self:NewKey("DOWN")
	self.right=self:NewKey("RIGHT")
	
	self.esc=self:NewKey("ESCAPE")
	
	self.jump=self:NewKey(XPRACTICE.Config.Keybinds.Jump)
	
	self.togglerunwalk=self:NewKey(XPRACTICE.Config.Keybinds.ToggleRunWalk)
	
	--mouse buttons work the same as other keys,
	--but they're set in OnMouseChange
	self.lmouse=self:NewKey("LMOUSE")
	self.rmouse=self:NewKey("RMOUSE")
	self.mmouse=self:NewKey("MMOUSE")--mousewheel click
	--special case for mousewheel scroll, handled separately-ish.
	--"pressed" value contains delta for wheel scroll
	self.wmouse=self:NewKey("WMOUSE")
	
end

function XPRACTICE.Keys:EndStep()
	--call at very end of frame to turn off pressed/released status.
	for k,v in ipairs(self.keys) do
		v.pressed=false
		v.released=false
	end	
end

function XPRACTICE.Keys:Cleanup()
	--
end



-- currently support to assign many functions to one key, but only one key.
-- before calling AssignKey, make sure self.rawinput points to something
function XPRACTICE.Keys:NewKey(keycode)	
	local key=XPRACTICE.Key.new()
	
	self.rawinput:CreateKeycodeIfNotExists(keycode)
	self.rawinput.keys[keycode].map=key
	tinsert(self.keys,key)
	
	return key
end
