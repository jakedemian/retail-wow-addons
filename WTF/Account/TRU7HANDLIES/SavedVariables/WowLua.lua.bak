
WowLua_DB = {
	["currentPage"] = 2,
	["fontSize"] = 14,
	["pages"] = {
		{
			["untitled"] = true,
			["name"] = "Untitled 13",
			["content"] = "local f  = QuickVolume or CreateFrame(\"Frame\", \"QuickVolume\", UIParent)\n\nlocal function DoQuickVolume(self, key)\n   local vol = tonumber(GetCVar(\"Sound_MasterVolume\"))\n   \n   vol = floor(100*vol)/100 --getting rid of annoying decimal\n   \n   if key == \"=\" then\n      vol = floor((100*vol)+2)/100\n   elseif key == \"-\" then\n      vol = floor((100*vol)-2)/100\n   end\n   \n   if vol < 0 then vol = 0\n   elseif vol > 1 then vol = 1\n   end\n   \n   \n   SetCVar(\"Sound_MasterVolume\",vol)\n   WeakAuras.ScanEvents(\"VOLUME_CHANGED\") --used to update display\nend\n\nf:SetScript(\"OnKeyDown\", DoQuickVolume)\nf:SetPropagateKeyboardInput(true)",
		}, -- [1]
		{
			["untitled"] = true,
			["name"] = "Untitled 14",
			["content"] = "SOUND_MASTERVOLUME_STEP = 0.02",
		}, -- [2]
	},
	["untitled"] = 15,
}
