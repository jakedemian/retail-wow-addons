
--
-- X Practice is still undergoing construction.
-- Please don't redistribute this addon until official release.
--


--TODO LATER: print debugstack on certain OOP problems such as (but not limited to) inheritance errors
--TODO: mouse sensitivity still not airtight
	-- (maybe because we accidentally hit reload macro while mouse is down?)
	-- (if enableMouseSpeed is false, maybe store that in savedata so we don't forget after an accident)
			-- (but must be very careful not to override out-of-addon changes)

--
-- XPRACTICE "class".  Non-OOP (call methods using . notation instead of : notation)
--

XPRACTICE.LOADED=false
XPRACTICE.TOCVersion=nil
XPRACTICE.games={}

-- event handler frame.  handles ADDON_LOADED and .
-- OnUpdate (step event) has been moved to gamewindow (which also handles input events).
XPRACTICE.EventHandlerFrame = CreateFrame("Frame")

function XPRACTICE.EventHandlerFrame:OnEvent(event, ...)
	if(event=="ADDON_LOADED") then
		XPRACTICE.EventHandlerFrame:OnLoad(...)
	end
end

function XPRACTICE.EventHandlerFrame:OnLoad(AddOn)		
	-- run init code only once
	if(AddOn=="XPractice" and XPRACTICE.LOADED==false) then				
		XPRACTICE.LOADED=true
		self:UnregisterEvent("ADDON_LOADED")		
		-- savedata has been loaded by now, if it exists.
		-- if it's still nil, then there was no data to load.
		if(XPRACTICE_SAVEDATA==nil) then XPRACTICE_SAVEDATA={} end				

		local v,b,d,t=GetBuildInfo()
		XPRACTICE.TOCVersion=t
			
		XPRACTICE.NewsAndUpdates()
		
	end 
end

XPRACTICE.EventHandlerFrame:RegisterEvent("ADDON_LOADED")
XPRACTICE.EventHandlerFrame:SetScript("OnEvent", XPRACTICE.EventHandlerFrame.OnEvent)




SLASH_XPRACTICE1 = "/xp"

function SlashCmdList.XPRACTICE(msg,editbox)
	if(XPRACTICE.LOADED==false)then 
		print("X Practice hasn't loaded yet.  Wait a moment and try again.")
		return 
	end
	
	local args={}
	local i=1
	for arg in string.gmatch(msg, "%S+") do	
		args[i]=arg
		i=i+1
		--print(arg)
	end	
	
	if(#args==0 and args[1]==nil)then
		if(#XPRACTICE.games==0)then
			print("Starting up X Practice...")
			XPRACTICE.alreadyattemptederrorshutdown=false
			XPRACTICE.StartNewGame()
		else
			if(XPRACTICE.DEBUG.allowmultiboxing)then
				print("Starting up X Practice (multiboxing)...")
				XPRACTICE.alreadyattemptederrorshutdown=false
				XPRACTICE.StartNewGame()				
			elseif(XPRACTICE.DEBUG.autoshutdownrestart)then
				print("Restarting X Practice...")
				XPRACTICE.EmergencyShutdown()
				XPRACTICE.alreadyattemptederrorshutdown=false
				XPRACTICE.StartNewGame()				
			else
				print("X Practice appears to be running already.  If something broke, type /xp shutdown.")
			end
		end
	end
	
	if(#args==1 and args[1]=="test")then
		if(#XPRACTICE.games==0)then
			print("Starting up X Practice in test mode...")
			XPRACTICE.alreadyattemptederrorshutdown=false
			XPRACTICE.StartNewGame(true)		
		else
			print("X Practice appears to be running already.  If something broke, type /xp shutdown.")
		end
	end
	
	if(args[1]=="shutdown")then
		XPRACTICE:EmergencyShutdown()
	end
	
	--if(XPRACTICE.DEBUG.extraslashcommands)then
	if(true)then
		if(args[1]=="reset") then		
			if(args[2]~="confirm") then
				print("To delete all X Practice saved data, type /xp reset confirm")
			else			
				XPRACTICE.EmergencyShutdown()			
				XPRACTICE_SAVEDATA={}
				print("X Practice data has been reset.")			
			end
		end 
	end
end

-- XPRACTICE.EventHandlerFrame.OnUpdate=function(self,elapsed)
	-- if(XPRACTICE.games)then
		-- XPRACTICE.xpcall(function()XPRACTICE.games[1].MainGameLoop(XPRACTICE.games[1],elapsed)end)
	-- end
-- end


function XPRACTICE.StartNewGame(testmode)
	if(#XPRACTICE.games==0)then
		XPRACTICE.CVars:SaveAll()
	end
	local game=XPRACTICE.Game.new()	
	if(testmode==true or XPRACTICE.DEBUG.testmode==true)then game.testmode=true end	
	game:Setup(XPRACTICE)	
	tinsert(XPRACTICE.games,game)
	
	
	--XPRACTICE.EventHandlerFrame:SetScript("OnUpdate", XPRACTICE.EventHandlerFrame.OnUpdate)
end

function XPRACTICE:EmergencyShutdown()	
	for i=#XPRACTICE.games,1,-1 do
		XPRACTICE.games[i]:Shutdown()
	end
	XPRACTICE.games={}
end

function XPRACTICE.RemoveDeadGames()
	for i=#XPRACTICE.games,1,-1 do
		if(XPRACTICE.games[i].dead)then
			tremove(XPRACTICE.games,i)
		end
	end
	if(#XPRACTICE.games==0)then
		XPRACTICE.Shutdown()
	end
end

function XPRACTICE.Shutdown()
	XPRACTICE.CVars:RestoreAll()
	--XPRACTICE.EventHandlerFrame:SetScript("OnUpdate", nil)
	XPRACTICE.Cleanup()
end

function XPRACTICE.Cleanup()
	XPRACTICE.ReusableFrames:ResetAndReport()
	print("X Practice was shut down.  Type /xp to restart.")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


function XPRACTICE.NewsAndUpdates()	
	if(XANESHPRACTICE)then
		-- turns out all we had to do was set this to nil
		SLASH_XANESHPRACTICE1=nil
	end
	print("X Practice is enabled.  Type /xp to play.")
	if(XANESHPRACTICE)then
		print("You appear to be running two versions of X Practice at once.  It's safe to disable or delete the older version (\"Xanesh Practice\") from your addons folder.")
	end
end













	