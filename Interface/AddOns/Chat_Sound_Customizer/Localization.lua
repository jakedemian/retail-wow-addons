local _, L = ...

setmetatable(L, {
	__index = function(t, k) return k end,
	__newindex = function(t, k, v) rawset(t, k, v == true and k or v) end,
	__call = function(self, locale, tab)
		return (self[locale]:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
	end
})

L["CHAT_MSG_OFFICER"] = "Guild Officer"
L["CHAT_MSG_GUILD"] = "Guild"
L["CHAT_MSG_WHISPER"] = "Whisper"
L["CHAT_MSG_BN_WHISPER"] = "BN Whisper"
L["CHAT_MSG_PARTY"] = "Party"
L["CHAT_MSG_PARTY_LEADER"] = "Party Leader"
L["CHAT_MSG_COMMUNITIES_CHANNEL"] = "Communities"
L["CHAT_MSG_RAID"] = "Raid"
L["CHAT_MSG_RAID_LEADER"] = "Raid Leader"
L["CHAT_MSG_INSTANCE_CHAT"] = "Instance"
L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "Instance Leader"
L["CHAT_MSG_SAY"] = "Say"
L["CHAT_MSG_YELL"] = "Yell"
L["CHAT_MSG_EMOTE"] = "Emote"

L["Config UI"] = true
L["Open config UI"] = true
L["Chat"] = true
L["Chats"] = true
L["Channel"] = true
L["Multi Selection"] = true
L["Select a sound"] = true
L["Ignore List"] = true
L["Add to ignore list"] = true
L["Remove from ignore list"] = true
L["${button} to show the Config UI"] = true
L["Left-click"] = true
L["${button} to unmute CSC"] = true
L["${button} to temporarily mute CSC"] = true
L["Right-click"] = true
L["Temporarily Mute"] = true
L["Temporarily mute the addon, it will go back to normal after reload"] = true
L["Show minimap button"] = true
L["Newcomer"] = true
L["Guide"] = true
L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = true
L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = true
L["Zone Channels"] = true
L["General"] = true
L["Trade"] = true
L["Local Defense"] = true
L["Sound for receiving messages"] = true
L["Sound for sending messages"] = true
L["Notification interval (ms)"] = true
L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = true

if GetLocale() == "enUS" or GetLocale() == "enGB" then
	return
end

if GetLocale() == "ptBR" then
L["${button} to show the Config UI"] = "${button} para mostrar a interface de configura????o"
L["${button} to temporarily mute CSC"] = "${button} para mutar o CSC temporariamente"
L["${button} to unmute CSC"] = "${button} para desmutar o CSC"
L["Add to ignore list"] = "Adicionar a lista de ignorados"
L["Channel"] = "Canal"
L["Chat"] = "Chat"
L["CHAT_MSG_BN_WHISPER"] = "Sussurro BN"
L["CHAT_MSG_COMMUNITIES_CHANNEL"] = "Comunidades"
L["CHAT_MSG_EMOTE"] = "Express??o"
L["CHAT_MSG_GUILD"] = "Guilda"
L["CHAT_MSG_INSTANCE_CHAT"] = "Inst??ncia"
L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "L??der da Inst??ncia"
L["CHAT_MSG_OFFICER"] = "Oficial da Guilda"
L["CHAT_MSG_PARTY"] = "Grupo"
L["CHAT_MSG_PARTY_LEADER"] = "L??der do Grupo"
L["CHAT_MSG_RAID"] = "Raid"
L["CHAT_MSG_RAID_LEADER"] = "L??der da Raid"
L["CHAT_MSG_SAY"] = "Dizer"
L["CHAT_MSG_WHISPER"] = "Sussurro"
L["CHAT_MSG_YELL"] = "Gritar"
L["Chats"] = "Chats"
L["Config UI"] = "Interface de Configura????o"
L["General"] = "Geral"
L["Guide"] = "Guia"
L["Ignore List"] = "Lista de ignorados"
L["Left-click"] = "Clique-esquerdo"
L["Local Defense"] = "Defesa Local"
L["Multi Selection"] = "Sele????o M??ltipla"
L["Newcomer"] = "Novato"
L["Notification interval (ms)"] = "Intervalo de notifica????o (ms)"
L["Open config UI"] = "Abrir configura????o"
L["Remove from ignore list"] = "Remover da lista de ignorados"
L["Right-click"] = "Clique-direito"
L["Select a sound"] = "Selecione um som"
L["Show minimap button"] = "Exibir bot??o do minimapa"
L["Sound for receiving messages"] = "Som para mensagens recebidas"
L["Sound for sending messages"] = "Som para mensagens enviadas"
L["Temporarily Mute"] = "Mutar temporariamente"
L["Temporarily mute the addon, it will go back to normal after reload"] = "Muta temporariamente o addon, ir?? resetar ao recarregar o jogo"
L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = "O intervalo m??nimo em milissegundos para que um som toque novamente. Cada chat ?? individual."
L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = "Este som ir?? tocar quando voc?? ?? um Guia e um Novato diz algo no chat de novatos"
L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = "Este som ir?? tocar quando voc?? ?? um Novato e um Guia diz algo no chat de novatos"
L["Trade"] = "Com??rcio"
L["Zone Channels"] = "Canais de ??rea"

	--[===[@debug@
	L["CHAT_MSG_OFFICER"] = "Oficial da Guilda"
	L["CHAT_MSG_GUILD"] = "Guilda"
	L["CHAT_MSG_WHISPER"] = "Sussurro"
	L["CHAT_MSG_BN_WHISPER"] = "Sussurro BN"
	L["CHAT_MSG_PARTY"] = "Grupo"
	L["CHAT_MSG_PARTY_LEADER"] = "L??der do Grupo"
	L["CHAT_MSG_COMMUNITIES_CHANNEL"] = "Comunidades"
	L["CHAT_MSG_RAID"] = "Raid"
	L["CHAT_MSG_RAID_LEADER"] = "L??der da Raid"
	L["CHAT_MSG_INSTANCE_CHAT"] = "Inst??ncia"
	L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = "L??der da Inst??ncia"
	L["CHAT_MSG_SAY"] = "Dizer"
	L["CHAT_MSG_YELL"] = "Gritar"
	L["CHAT_MSG_EMOTE"] = "Express??o"

	L["Config UI"] = "Interface de Configura????o"
	L["Open config UI"] = "Abrir configura????o"
	L["Chat"] = "Chat"
	L["Chats"] = "Chats"
	L["Channel"] = "Canal"
	L["Multi Selection"] = "Sele????o M??ltipla"
	L["Select a sound"] = "Selecione um som"
	L["Ignore List"] = "Lista de ignorados"
	L["Add to ignore list"] = "Adicionar a lista de ignorados"
	L["Remove from ignore list"] = "Remover da lista de ignorados"
	L["${button} to show the Config UI"] = "${button} para mostrar a interface de configura????o"
	L["Left-click"] = "Clique-esquerdo"
	L["${button} to unmute CSC"] = "${button} para desmutar o CSC"
	L["${button} to temporarily mute CSC"] = "${button} para mutar o CSC temporariamente"
	L["Right-click"] = "Clique-direito"
	L["Temporarily Mute"] = "Mutar temporariamente"
	L["Temporarily mute the addon, it will go back to normal after reload"] = "Muta temporariamente o addon, ir?? resetar ao recarregar o jogo"
	L["Show minimap button"] = "Exibir bot??o do minimapa"
	L["Newcomer"] = "Novato"
	L["Guide"] = "Guia"
	L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"]
	= "Este som ir?? tocar quando voc?? ?? um Guia e um Novato diz algo no chat de novatos"
	L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"]
	= "Este som ir?? tocar quando voc?? ?? um Novato e um Guia diz algo no chat de novatos"
	L["Zone Channels"] = "Canais de ??rea"
	L["General"] = "Geral"
	L["Trade"] = "Com??rcio"
	L["Local Defense"] = "Defesa Local"
	L["Sound for receiving messages"] = "Som para mensagens recebidas"
	L["Sound for sending messages"] = "Som para mensagens enviadas"
	L["Notification interval (ms)"] = "Intervalo de notifica????o (ms)"
	L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."]
	= "O intervalo m??nimo em milissegundos para que um som toque novamente. Cada chat ?? individual."
	--@end-debug@]===]

	return
end

if GetLocale() == "frFR" then
--[[Translation missing --]]
--[[ L["${button} to show the Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to temporarily mute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to unmute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["Add to ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Channel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_BN_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_COMMUNITIES_CHANNEL"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_EMOTE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_GUILD"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_OFFICER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_SAY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_YELL"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chats"] = ""--]] 
--[[Translation missing --]]
--[[ L["Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["General"] = ""--]] 
--[[Translation missing --]]
--[[ L["Guide"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ignore List"] = ""--]] 
--[[Translation missing --]]
--[[ L["Left-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Local Defense"] = ""--]] 
--[[Translation missing --]]
--[[ L["Multi Selection"] = ""--]] 
--[[Translation missing --]]
--[[ L["Newcomer"] = ""--]] 
--[[Translation missing --]]
--[[ L["Notification interval (ms)"] = ""--]] 
--[[Translation missing --]]
--[[ L["Open config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["Remove from ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Right-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Select a sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Show minimap button"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for receiving messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for sending messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily Mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily mute the addon, it will go back to normal after reload"] = ""--]] 
--[[Translation missing --]]
--[[ L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["Trade"] = ""--]] 
--[[Translation missing --]]
--[[ L["Zone Channels"] = ""--]] 

	return
end

if GetLocale() == "deDE" then
--[[Translation missing --]]
--[[ L["${button} to show the Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to temporarily mute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to unmute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["Add to ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Channel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_BN_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_COMMUNITIES_CHANNEL"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_EMOTE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_GUILD"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_OFFICER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_SAY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_YELL"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chats"] = ""--]] 
--[[Translation missing --]]
--[[ L["Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["General"] = ""--]] 
--[[Translation missing --]]
--[[ L["Guide"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ignore List"] = ""--]] 
--[[Translation missing --]]
--[[ L["Left-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Local Defense"] = ""--]] 
--[[Translation missing --]]
--[[ L["Multi Selection"] = ""--]] 
--[[Translation missing --]]
--[[ L["Newcomer"] = ""--]] 
--[[Translation missing --]]
--[[ L["Notification interval (ms)"] = ""--]] 
--[[Translation missing --]]
--[[ L["Open config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["Remove from ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Right-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Select a sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Show minimap button"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for receiving messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for sending messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily Mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily mute the addon, it will go back to normal after reload"] = ""--]] 
--[[Translation missing --]]
--[[ L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["Trade"] = ""--]] 
--[[Translation missing --]]
--[[ L["Zone Channels"] = ""--]] 

	return
end

if GetLocale() == "itIT" then
--[[Translation missing --]]
--[[ L["${button} to show the Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to temporarily mute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to unmute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["Add to ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Channel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_BN_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_COMMUNITIES_CHANNEL"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_EMOTE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_GUILD"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_OFFICER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_SAY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_YELL"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chats"] = ""--]] 
--[[Translation missing --]]
--[[ L["Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["General"] = ""--]] 
--[[Translation missing --]]
--[[ L["Guide"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ignore List"] = ""--]] 
--[[Translation missing --]]
--[[ L["Left-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Local Defense"] = ""--]] 
--[[Translation missing --]]
--[[ L["Multi Selection"] = ""--]] 
--[[Translation missing --]]
--[[ L["Newcomer"] = ""--]] 
--[[Translation missing --]]
--[[ L["Notification interval (ms)"] = ""--]] 
--[[Translation missing --]]
--[[ L["Open config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["Remove from ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Right-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Select a sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Show minimap button"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for receiving messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for sending messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily Mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily mute the addon, it will go back to normal after reload"] = ""--]] 
--[[Translation missing --]]
--[[ L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["Trade"] = ""--]] 
--[[Translation missing --]]
--[[ L["Zone Channels"] = ""--]] 

	return
end

if GetLocale() == "esES" then
--[[Translation missing --]]
--[[ L["${button} to show the Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to temporarily mute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to unmute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["Add to ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Channel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_BN_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_COMMUNITIES_CHANNEL"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_EMOTE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_GUILD"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_OFFICER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_SAY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_YELL"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chats"] = ""--]] 
--[[Translation missing --]]
--[[ L["Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["General"] = ""--]] 
--[[Translation missing --]]
--[[ L["Guide"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ignore List"] = ""--]] 
--[[Translation missing --]]
--[[ L["Left-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Local Defense"] = ""--]] 
--[[Translation missing --]]
--[[ L["Multi Selection"] = ""--]] 
--[[Translation missing --]]
--[[ L["Newcomer"] = ""--]] 
--[[Translation missing --]]
--[[ L["Notification interval (ms)"] = ""--]] 
--[[Translation missing --]]
--[[ L["Open config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["Remove from ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Right-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Select a sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Show minimap button"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for receiving messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for sending messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily Mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily mute the addon, it will go back to normal after reload"] = ""--]] 
--[[Translation missing --]]
--[[ L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["Trade"] = ""--]] 
--[[Translation missing --]]
--[[ L["Zone Channels"] = ""--]] 

	return
end

if GetLocale() == "esMX" then
--[[Translation missing --]]
--[[ L["${button} to show the Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to temporarily mute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to unmute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["Add to ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Channel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_BN_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_COMMUNITIES_CHANNEL"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_EMOTE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_GUILD"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_OFFICER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_SAY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_YELL"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chats"] = ""--]] 
--[[Translation missing --]]
--[[ L["Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["General"] = ""--]] 
--[[Translation missing --]]
--[[ L["Guide"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ignore List"] = ""--]] 
--[[Translation missing --]]
--[[ L["Left-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Local Defense"] = ""--]] 
--[[Translation missing --]]
--[[ L["Multi Selection"] = ""--]] 
--[[Translation missing --]]
--[[ L["Newcomer"] = ""--]] 
--[[Translation missing --]]
--[[ L["Notification interval (ms)"] = ""--]] 
--[[Translation missing --]]
--[[ L["Open config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["Remove from ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Right-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Select a sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Show minimap button"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for receiving messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for sending messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily Mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily mute the addon, it will go back to normal after reload"] = ""--]] 
--[[Translation missing --]]
--[[ L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["Trade"] = ""--]] 
--[[Translation missing --]]
--[[ L["Zone Channels"] = ""--]] 

	return
end

if GetLocale() == "ruRU" then
--[[Translation missing --]]
--[[ L["${button} to show the Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to temporarily mute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["${button} to unmute CSC"] = ""--]] 
--[[Translation missing --]]
--[[ L["Add to ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Channel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_BN_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_COMMUNITIES_CHANNEL"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_EMOTE"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_GUILD"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_INSTANCE_CHAT_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_OFFICER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_PARTY_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_RAID_LEADER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_SAY"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_WHISPER"] = ""--]] 
--[[Translation missing --]]
--[[ L["CHAT_MSG_YELL"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chats"] = ""--]] 
--[[Translation missing --]]
--[[ L["Config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["General"] = ""--]] 
--[[Translation missing --]]
--[[ L["Guide"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ignore List"] = ""--]] 
--[[Translation missing --]]
--[[ L["Left-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Local Defense"] = ""--]] 
--[[Translation missing --]]
--[[ L["Multi Selection"] = ""--]] 
--[[Translation missing --]]
--[[ L["Newcomer"] = ""--]] 
--[[Translation missing --]]
--[[ L["Notification interval (ms)"] = ""--]] 
--[[Translation missing --]]
--[[ L["Open config UI"] = ""--]] 
--[[Translation missing --]]
--[[ L["Remove from ignore list"] = ""--]] 
--[[Translation missing --]]
--[[ L["Right-click"] = ""--]] 
--[[Translation missing --]]
--[[ L["Select a sound"] = ""--]] 
--[[Translation missing --]]
--[[ L["Show minimap button"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for receiving messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Sound for sending messages"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily Mute"] = ""--]] 
--[[Translation missing --]]
--[[ L["Temporarily mute the addon, it will go back to normal after reload"] = ""--]] 
--[[Translation missing --]]
--[[ L["This is the minimum interval in milliseconds for a sound to be played again. Each chat is individual."] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a GUIDE and a NEWCOMER says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["This sound will play when you are a NEWCOMER and a GUIDE says something in the Newcomer Chat"] = ""--]] 
--[[Translation missing --]]
--[[ L["Trade"] = ""--]] 
--[[Translation missing --]]
--[[ L["Zone Channels"] = ""--]] 

	return
end






