-- English localization file forenGB.
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "enUS", true, true)
if not L then return; end

L['Combat State Options'] = true
L["OOC_DESC"] = [[This options allow you to set different visibility and mouseover setting when entering or leaving combat.
Please note: if you enable state change for a bar here the presented options will disapper from the regular options for the said bar.]]
L["In Combat"] = true
L["Conditions below will take effet when entering combat."] = true
L["Out of Combat"] = true
L["Conditions below will take effet when leaving combat."] = true
L["Full Alpha On Mouse Over"] = true
L["Forces the bar to set alpha to 100% when under the cursor. Does not affect bars with mouseover on."] = true
L["Full Alpha On Mouse Over (Global)"] = true
L["Forces all bars to set alpha to 100% when mouse over any bar. Does not affect bars with mouseover on."] = true