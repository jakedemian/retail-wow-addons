--Файл локализации для ruRU
local L = ElvUI[1].Libs.ACL:NewLocale("ElvUI", "ruRU")
if not L then return; end

L['Combat State Options'] = "Опции состояния боя"
L["OOC_DESC"] = [[Эти опции позволят вам утановить разные условия отображения и показа при наведении при вступлении или выходе из боя.
Замечание: если вы активируете автоматическую смену для какой-либо панели, то указанные опции пропадут из обычных настроек для данной панели.]]
L["In Combat"] = "В бою"
L["Conditions below will take effet when entering combat."] = "Эти условия будут применяться при вступлении в бой."
L["Out of Combat"] = "Вне боя"
L["Conditions below will take effet when leaving combat."] = "Эти условия будут применяться при выходе из боя."
L["Full Alpha On Mouse Over"] = "Отклюить прозрачность при наведении"
L["Forces the bar to set alpha to 100% when under the cursor. Does not affect bars with mouseover on."] = "Принудительно делает панель полностью непрозрачной при наведении мыши. Не работает на панели с активной опцией \"при наведении\"."
L["Full Alpha On Mouse Over (Global)"] = "Отклюить прозрачность при наведении (глобально)"
L["Forces all bars to set alpha to 100% when mouse over any bar. Does not affect bars with mouseover on."] = "Принудительно делает все панели полностью непрозрачными при наведении мыши на любую из них. Не работает на панели с активной опцией \"при наведении\"."
