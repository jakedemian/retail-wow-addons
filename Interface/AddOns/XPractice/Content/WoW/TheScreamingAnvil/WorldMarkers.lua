--TODO: volatile code reuse -- only use function in multiplayer/messagehandler.lua
local function IsRealOfficer(unit)
	unit=strsplit("-",unit)
	return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
end
	
do
	XPRACTICE.PAINSMITH.wmnumbers={{1,"BLUESQUARE"},{2,"GREENTRIANGLE"},{3,"PURPLEDIAMOND"},{4,"REDX"},{5,"YELLOWSTAR"},{6,"ORANGECIRCLE"},{7,"SILVERMOON"},{8,"WHITESKULL"}}
	XPRACTICE.PAINSMITH.wmmodels={REDX=456041,PURPLEDIAMOND=456039,GREENTRIANGLE=456037,YELLOWSTAR=456043,SILVERMOON=1014628,BLUESQUARE=456035,ORANGECIRCLE=1014619,WHITESKULL=1014641}
	
	local super=XPRACTICE.GameObject
	XPRACTICE.PAINSMITH.WorldMarkerController=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PAINSMITH.WorldMarkerController
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.wms={}
	end
	
	function class:SetWM(scenario,index,x,y,send)
		if(send)then
			if(scenario.multiplayer)then
				if(IsRealOfficer("player"))then
					scenario.multiplayer:FormatAndSend("WORLDMARKER",tostring(index),x,y)
				end
			end
		end
	end
	
	function class:ClearWM(scenario,index,send)
		if(send)then
			if(scenario.multiplayer)then
				if(IsRealOfficer("player"))then
					scenario.multiplayer:FormatAndSend("CLEARWORLDMARKER",tostring(index))
				end
			end
		end
	end	
	
	function class:ClearWMAll(scenario,send)
		if(send)then
			if(scenario.multiplayer)then
				if(IsRealOfficer("player"))then
					scenario.multiplayer:FormatAndSend("CLEARWORLDMARKER",tostring(9))
				end
			end
		end
	end		
	
	function class:LoadAll(scenario,send)
		if(scenario.multiplayer)then
			for index=1,8 do		--TODO: some code overlap with Handle_WORLDMARKER
				local wmname=XPRACTICE.PAINSMITH.wmnumbers[index][2]
				local varname="WorldMarker"..wmname.."pos"
				local x=XPRACTICE_SAVEDATA[scenario.savedataname][varname.."x"]
				local y=XPRACTICE_SAVEDATA[scenario.savedataname][varname.."y"]
				if(x and y)then
					if(self.wms[index])then
						self.wms[index].animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
					end
					
					local obj=XPRACTICE.WoWObject.new();obj:Setup(scenario.game.environment_gameplay)		
					obj.displayobject.drawable:SetModelByFileID(XPRACTICE.PAINSMITH.wmmodels[wmname])	-- raid_ui_fx_
					--obj.position=XPRACTICE_SAVEDATA.PAINSMITH[varname]
					obj.position={x=x,y=y,z=0}
					obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
					obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0
					self.wms[index]=obj
				end
			end
		end
		if(scenario.multiplayer)then
			if(send)then
				self:SendAll(scenario)
			end
		end
	end	
	
	function class:SendAll(scenario)
		if(scenario.multiplayer)then
			if(IsRealOfficer("player"))then
				local viscount=0
				local args={}
				for i=1,8 do
					if(self.wms[i])then 
						viscount=viscount+1
						tinsert(args,true) 
						tinsert(args,self.wms[i].position.x)
						tinsert(args,self.wms[i].position.y)
					else 
						tinsert(args,false) 
						tinsert(args,0)
						tinsert(args,0)
					end
				end
				-- don't clear everyone's markers if you have zero markers placed
				if(viscount>0)then
					scenario.multiplayer:FormatAndSend("ALLWORLDMARKERS",unpack(args))
				end
			end
		end
	end

	-- TODO NEXT: move WorldMarkers to Multiplayer folder
	-- local prev=SlashCmdList.XPRACTICE
	-- function SlashCmdList.XPRACTICE(msg,editbox)
		-- local args={}
		-- local i=1
		-- for arg in string.gmatch(msg, "%S+") do	
			-- args[i]=arg
			-- i=i+1
			-- --print(arg)
		-- end	
		-- if(#XPRACTICE.games>0)then
			-- local game=XPRACTICE.games[1]
			-- if(game.scenario and game.scenario.worldmarkercontroller and game.scenario.player)then 		
				-- if(#args==2 and args[1]=="wm")then
					-- local number=tonumber(args[2])
					-- if(number)then
						-- if(number>=1 and number<=8)then
							-- local pos=game.scenario.player.position
							-- game.scenario.worldmarkercontroller:SetWM(game.scenario,number,pos.x,pos.y,true)
						-- end
					-- end
				-- elseif(#args==2 and args[1]=="cwm")then
					-- local number=tonumber(args[2])
					-- if(number)then
						-- if(number>=1 and number<=8)then
							-- local pos=game.scenario.player.position
							-- game.scenario.worldmarkercontroller:ClearWM(game.scenario,number,true)
						-- end
					-- elseif(args[2]=="all")then
						-- for i=1,8 do
							-- local pos=game.scenario.player.position
							-- game.scenario.worldmarkercontroller:ClearWMAll(game.scenario,true)
						-- end						
					-- end
				-- end
			-- end
		-- end
		
		-- prev(msg,editbox)		
	-- end
end

