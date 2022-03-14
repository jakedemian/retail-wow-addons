local _, ns = ...
local L = ns.L

local localeMap = {
	enUS = "English",
	deDE = "Deutsch",
	esES = "Español",
	esMX = "Español",
	frFR = "Français",
	itIT = "Italiano",
	koKR = "한국어",
	ptBR = "Português",
	ruRU = "Русский",
	zhCN = "简体中文",
	zhTW = "繁體中文",
}

local heroes = {
	Announcer = "Athena",
	Ana = "Ana",
	Ashe = "Ashe",
	Baptiste = "Baptiste",
	Bastion = "Bastion",
	Brigitte = "Brigitte",
	DVa = "D.Va",
	Doomfist = "Doomfist",
	Genji = "Genji",
	Hanzo = "Hanzo",
	Junkrat = "Junkrat",
	Lucio = "Lúcio",
	McCree = "McCree",
	Mei = "Mei",
	Mercy = "Mercy",
	Moira = "Moira",
	Orisa = "Orisa",
	Pharah = "Pharah" ,
	Reaper = "Reaper",
	Reinhardt = "Reinhardt",
	Roadhog = "Roadhog",
	Sigma = "Sigma",
	Soldier76 = "Soldier: 76",
	Sombra = "Sombra",
	Symmetra = "Symmetra",
	Torbjorn = "Torbjörn",
	Tracer = "Tracer",
	Widowmaker = "Widowmaker",
	Winston = "Winston",
	WreckingBall = "Wrecking Ball",
	Zarya = "Zarya",
	Zenyatta = "Zenyatta",
}

local function register(locale)
	local lang = localeMap[locale]
	local path = "Interface\\AddOns\\BigWigs_Countdown_Overwatch\\"..locale.."\\%s_%d.ogg"
	local key = locale ~= "enUS" and L.key or "%s: Overwatch: %s"

	for k, v in next, heroes do
		local id = ("%s: Overwatch: %s"):format(lang, k)
		local name = key:format(lang, locale ~= "enUS" and L[k] or v)
		if k == "Bastion" then
			-- Bastion beeps and boops are the same for all locales
			BigWigsAPI:RegisterCountdown(id, name, {
				"Interface\\AddOns\\BigWigs_Countdown_Overwatch\\enUS\\Bastion_1.ogg",
				"Interface\\AddOns\\BigWigs_Countdown_Overwatch\\enUS\\Bastion_2.ogg",
				"Interface\\AddOns\\BigWigs_Countdown_Overwatch\\enUS\\Bastion_3.ogg",
				"Interface\\AddOns\\BigWigs_Countdown_Overwatch\\enUS\\Bastion_4.ogg",
				"Interface\\AddOns\\BigWigs_Countdown_Overwatch\\enUS\\Bastion_5.ogg",
			})
		else
			BigWigsAPI:RegisterCountdown(id, name, {
				path:format(k, 1),
				path:format(k, 2),
				path:format(k, 3),
				path:format(k, 4),
				path:format(k, 5),
			})
		end
	end
end

local locale = GetLocale()
if not localeMap[locale] then
	locale = "enUS"
end
register(locale)
if locale ~= "enUS" then
	register("enUS")
end
