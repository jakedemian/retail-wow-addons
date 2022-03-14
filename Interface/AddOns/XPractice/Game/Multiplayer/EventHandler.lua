do
	XPRACTICE.MULTIPLAYER.EventHandler=function(self,event,...)	
		local prefix,text,channel,sender=...
		
		if(event=="CHAT_MSG_ADDON")then
			if(prefix==XPRACTICE.MULTIPLAYER.PREFIX)then
				if(channel=="PARTY" or channel=="RAID")then
					XPRACTICE.MULTIPLAYER.ProcessInput(text,sender)
				end
			end
		elseif(event=="GROUP_ROSTER_UPDATE")then
			for k,v in pairs(XPRACTICE.MULTIPLAYER.modulelist) do					
				for i=1,#v do
					local multi=v[i]
					multi.receivedpackettracker={}
					multi.sentpackettracker={}
				end
			end
		
			--print("group roster update!")
			if(IsInGroup())then
				for k,v in pairs(XPRACTICE.MULTIPLAYER.modulelist) do					
					for i=1,#v do
						local multi=v[i]
						if(multi.joinedsolo and GetNumGroupMembers()>1)then
							multi.scenario.statuslabel:SetText("Multiplayer features are now enabled!",3.0)							
							multi:SendHello() -- reminder: if a solo player joins a solo player, the player that invited will already be part of a (solo) group when player 2 accepts the group invite
						end
						if(multi.roomlocked)then											
							if(multi.host)then		
								multi:FormatAndSend("ALREADYINPROGRESS")
							end
						else
							multi:SendIExist()
						end
						if(GetNumGroupMembers()>1)then
							multi.joinedsolo=false
						else
							multi.joinedsolo=true
							multi.scenario.statuslabel:SetText("You are not in a group!\nJoin a group to enable multiplayer features.",nil)
						end
					end	
				end
			else
				for k,v in pairs(XPRACTICE.MULTIPLAYER.modulelist) do					
					for i=1,#v do
						local multi=v[i]
						multi.joinedsolo=true
						multi.scenario.statuslabel:SetText("You are not in a group!\nJoin a group to enable multiplayer features.",nil)
					end
				end
			end


		end
	end
	
	XPRACTICE.MULTIPLAYER.ProcessInput=function(text,sender)	
		--TODO: if sender doesn't have a last name, maybe panic
		--print("Process (raw):",sender,text)		
		if(string.len(text)<7)then return end
		local trackingcode=string.sub(text,1,1)
		local roomcode=string.sub(text,2,5)
		if(not XPRACTICE.MULTIPLAYER.modulelist[roomcode])then return end
		local msgcode=string.sub(text,6,7)		
		local argstr=string.sub(text,8)
		
		if(XPRACTICE.Config.TrackCommunicationErrors)then
			for i=1,#XPRACTICE.MULTIPLAYER.modulelist[roomcode] do
				local multiplayermodule=XPRACTICE.MULTIPLAYER.modulelist[roomcode][i]
				if(multiplayermodule)then
					if(multiplayermodule.receivedpackettracker[sender])then
						--print("Received",string.byte(trackingcode))
						--"1" code is a reset signal
						if(string.byte(trackingcode)==1) then multiplayermodule.receivedpackettracker[sender]=1 end
						
						if(multiplayermodule.receivedpackettracker[sender]==string.byte(trackingcode))then
							--do nothing
							--print("(Expected #"..multiplayermodule.receivedpackettracker[sender]..", got #"..string.byte(trackingcode)..")")
						else							
							multiplayermodule.scenario.packetlosslabel:SetText("COMMUNICATION ERROR DETECTED.  Check your chat window.",1.0)
							local diff=string.byte(trackingcode)-multiplayermodule.receivedpackettracker[sender]
							if(diff<0)then diff=diff+254 end
							if(not multiplayermodule.packeterrors[sender])then
								multiplayermodule.packeterrors[sender]=0
							end
							multiplayermodule.packeterrors[sender]=multiplayermodule.packeterrors[sender]+diff
							print("Lost something from "..sender..".  "..tostring(multiplayermodule.packeterrors[sender]).." errors so far.")
							print("(Expected #"..multiplayermodule.receivedpackettracker[sender]..", got #"..string.byte(trackingcode)..")")					
						end						
					else
						multiplayermodule.receivedpackettracker[sender]=string.byte(trackingcode)
					end
					multiplayermodule.receivedpackettracker[sender]=string.byte(trackingcode)+1
					
					if(multiplayermodule.receivedpackettracker[sender]>255)then multiplayermodule.receivedpackettracker[sender]=2 end
					--print("Next:",multiplayermodule.receivedpackettracker[sender])
				end
			end
		end		
		
		
		if(msgcode==XPRACTICE.MULTIPLAYER.Messagetypes.CUSTOM.BCDmessagecode)then		
			--scenario custom command!
			if(string.len(text)<9)then return end
			custommsgcode=string.sub(text,8,9)
			argstr=string.sub(text,10)
			for i=1,#XPRACTICE.MULTIPLAYER.modulelist[roomcode] do
				--print("Got custom",roomcode,msgcode..custommsgcode)
				local messagetype=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomcode].MessagetypesBCDPointer[custommsgcode]
				if(not messagetype)then return end
				if(messagetype:MessageIsValid(sender))then
					for i=1,#XPRACTICE.MULTIPLAYER.modulelist[roomcode] do
						local multiplayermodule=XPRACTICE.MULTIPLAYER.modulelist[roomcode][i]
						if(multiplayermodule)then	
							tinsert(multiplayermodule.newmessages,{messagetype,sender,argstr,true,roomcode})
						end
					end
				end
			end
		else
			-- generic command
			local messagetype=XPRACTICE.MULTIPLAYER.MessagetypesBCDPointer[msgcode]
			if(not messagetype)then return end
			--print("Validate:",GetTime(),sender,messagetype.messagename,argstr,"(length",tostring(6+string.len(argstr))..")")
			if(messagetype:MessageIsValid(sender))then	
				--print("Process:",GetTime(),sender,messagetype.messagename,argstr,"(length",tostring(6+string.len(argstr))..")")
				for i=1,#XPRACTICE.MULTIPLAYER.modulelist[roomcode] do
					local multiplayermodule=XPRACTICE.MULTIPLAYER.modulelist[roomcode][i]
					if(multiplayermodule)then	
						--print("queue up",messagetype,sender,"-"..argstr.."-")
						tinsert(multiplayermodule.newmessages,{messagetype,sender,argstr,false,roomcode})
					end
				end
			end
		end
	end
end