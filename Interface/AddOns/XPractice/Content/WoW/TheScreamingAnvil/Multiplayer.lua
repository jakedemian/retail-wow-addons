do	

	--TODO: volatile code reuse -- only use function in multiplayer/messagehandler.lua
	local function IsRealOfficer(unit)
		unit=strsplit("-",unit)
		return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
	end
	
	local function IsFlaggedAsOfficer(multiplayermodule,sender)
		if(not IsInGroup("player"))then return true end
		local name1,name2=UnitFullName("player")
		local myfullname=name1.."-"..name2		
		if(myfullname==sender)then return multiplayermodule.officer end
		if(multiplayermodule.allplayers[sender])then return multiplayermodule.allplayers[sender].officer end
		return false
	end

	local roomnumber=XPRACTICE.PAINSMITH.NPCID
	local roomBCD=XPRACTICE.MULTIPLAYER.Datatypes.BCD.ToString(XPRACTICE.PAINSMITH.NPCID)	
	XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD]={}
	do
		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes={}
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer={}
		local messagecode=0
		

		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="SAFESPOTS"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}
							}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="SWIRLSYNC_STOP"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="RESETSTACKS"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="BREZ"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="SPRINT"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="ROAR"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
				
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="GOT_ROAR"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
						
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="PALLYBUBBLE"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]						
		
		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="MYSWIRL"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}, -- previous swirl tag
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}, -- previous swirl real position
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}, 
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}, -- next swirl tag
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}, -- next swirl offset
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}, 
							}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="QUEUE_BEAM"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="QUEUE_PUSH"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="QUEUE_CYCLO"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="QUEUE_FINAL"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]


		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="QUEUE_CLEAR"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="CAST_BEAM"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="CAST_PUSH"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="CAST_CYCLO"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="CAST_FINAL"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
	


		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="DEAD_EMBERS"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="DEAD_FLOORSPIKES"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="DEAD_RINGOUT"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="DEAD_SPIKEDBALL"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
			
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="CHANGE_PHASE"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BOOLEAN}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
				
			
	end
	
	local super=XPRACTICE.MULTIPLAYER.Multiplayer
	XPRACTICE.PAINSMITH.Multiplayer=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PAINSMITH.Multiplayer		
	
	--local prev=class.Handle_HELLO -- this doesn't work anymore!  prev now refers to FATESCRIBE for some reason --TODO: why?
	local prev=XPRACTICE.MULTIPLAYER.Multiplayer.Handle_HELLO 
	function class.Handle_HELLO(self,sender,args)
		--print(XPRACTICE.MULTIPLAYER.Multiplayer.Handle, XPRACTICE.FATESCRIBEMULTIPLAYER.Handle, XPRACTICE.PAINSMITH.Handle)
		--print(XPRACTICE.MULTIPLAYER.Multiplayer.Handle, XPRACTICE.PAINSMITH.Handle)
		prev(self,sender,args)	
		--XPRACTICE.MULTIPLAYER.Multiplayer.Handle_HELLO(self,sender,args)	-- but we can do this instead
		--TODO NEXT: this is scenario-specific!
		if(IsRealOfficer("player"))then
			--TODO NEXT: move worldmarker send to baseline
			if(self.scenario.worldmarkercontroller)then
				self.scenario.worldmarkercontroller:SendAll(self)
			end
		end		
	end
	
	function class.HandleCustom_SAFESPOTS(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		
		if(not player.swirlpositions)then player.swirlpositions={} end
		if(not player.swirloffsets)then player.swirloffsets={} end
		player.swirlpositions[string.byte(args[1])]={x=args[2],y=args[3]}
		player.swirloffsets[string.byte(args[4])]={x=args[5],y=args[6]}
		
		--print("Got swirlposition",sender,"tag",args[1],string.byte(args[1]))
		-- print("Set swirloffset",sender,"tag",args[4],string.byte(args[4]))
		for i=1,9 do
			scenario.scheduler.spikepattern[i]=string.byte(args[i])
		end
		scenario.scheduler:Activate()
	end
	
	function class.HandleCustom_SWIRLSYNC_FAST(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		--TODO: actually sync
		XPRACTICE_SAVEDATA.PAINSMITH.swirltype=3
		scenario.swirlcontroller.swirlfrequency=XPRACTICE_SAVEDATA.PAINSMITH.swirltype
--TODO: once we've implemented outofphase, don't sync swirltimer until 1st player enters phase
		--scenario.swirlcontroller.swirltimer=XPRACTICE.PAINSMITH.Config.MinimumPhaseSwirlTime+1.0
		scenario.swirlcontroller.swirltimer=1.0
		scenario.swirlcontroller.swirltag=1		
		--scenario.statuslabel:SetText(sender.." set Shadow Fissure to 2 seconds.",3.0)
		--scenario.statuslabel:SetText(sender.." set Shadow Fissure to 3 seconds.",3.0)
	end
	
	function class.HandleCustom_SWIRLSYNC_STOP(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		--TODO: actually sync
		XPRACTICE_SAVEDATA.PAINSMITH.swirltype=0
		scenario.swirlcontroller.swirlfrequency=XPRACTICE_SAVEDATA.PAINSMITH.swirltype
--TODO: once we've implemented outofphase, don't sync swirltimer until 1st player enters phase
		scenario.swirlcontroller.swirltimer=XPRACTICE.PAINSMITH.Config.MinimumPhaseSwirlTime+1.0
		scenario.swirlcontroller.swirltag=1		
		--scenario.statuslabel:SetText(sender.." paused Shadow Fissure.",3.0)
	end
	
	function class.HandleCustom_RESETSTACKS(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		for k,v in pairs(scenario.multiplayer.allplayers)do
			local player=v
			player.timeinphase=0
		end
	end
	
	
	function class.HandleCustom_BREZ(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		local auras=player.combatmodule.auras.deadingame
		if(#auras==0)then return end
		for i=1,#auras do
			auras[i]:Die()
		end
		player.ai.targetposition=nil
		scenario.statuslabel:SetText(sender.." was rezzed.",3.0)
	end			
	
	function class.HandleCustom_SPRINT(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		local auras=player.combatmodule.auras.speedboost
		if(#auras>0 and not auras[1].dying)then
			local newexpiry=player.environment.localtime+8.000
			if(newexpiry>auras[1].expirytime)then auras[1].expirytime=newexpiry end
			auras[1].multiplier=1.7
		else
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_StampedingRoar,player.combatmodule,player.environment.localtime)
			aura.expirytime=player.environment.localtime+8.000
			aura.multiplier=1.7
		end
		local visual=XPRACTICE.PAINSMITH.SprintVisualEffect.new()
		visual:Setup(player.environment,player.position.x,player.position.y,player.position.z+2)
		visual.player=player		

	end			
	
	function class.HandleCustom_ROAR(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		scenario.statuslabel:SetText(sender.." casts Stampeding Roar.",3.0)
		player.animationmodule:PlayAnimation(XPRACTICE.PAINSMITH.AnimationList.BattleRoar)
		local me=self.scenario.player
		if(me:IsDeadInGame())then return end
		local xdist=me.position.x-args[1]
		local ydist=me.position.y-args[2]
		local distsqr=xdist*xdist+ydist*ydist
		local radius=15.0*1.24+5.0	-- not sure how Front of the Pack interacts with Balance Affinity		
		if(distsqr<=radius*radius)then
			if(me~=player)then	-- sender already sent GOT_ROAR in the same function that sent ROAR
				scenario.multiplayer:FormatAndSendCustom("GOT_ROAR")
			end
			local auras=player.combatmodule.auras.speedboost
			if(#auras>0 and not auras[1].dying)then
				local newexpiry=me.environment.localtime+8.000 * 1.24 -- Front of the Pack ilvl 226
				if(newexpiry>auras[1].expirytime)then auras[1].expirytime=newexpiry end
				auras[1].multiplier=1.6
			else
				local aura=me.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_StampedingRoar,me.combatmodule,me.environment.localtime)
				aura.expirytime=me.environment.localtime+8.000 * 1.24
				aura.multiplier=1.6
			end	
			local visual=XPRACTICE.PAINSMITH.RoarVisualEffect.new()
			visual:Setup(me.environment,me.position.x,me.position.y,me.position.z+2)
			visual.player=me		

		end
	end	
	
	function class.HandleCustom_GOT_ROAR(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		local auras=player.combatmodule.auras.speedboost
		if(#auras>0 and not auras[1].dying)then
			local newexpiry=player.environment.localtime+8.000 * 1.24 -- Front of the Pack ilvl 226
			if(newexpiry>auras[1].expirytime)then auras[1].expirytime=newexpiry end
			auras[1].multiplier=1.6
		else
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_StampedingRoar,player.combatmodule,player.environment.localtime)
			aura.expirytime=player.environment.localtime+8.000 * 1.24
			aura.multiplier=1.6
		end
		local visual=XPRACTICE.PAINSMITH.RoarVisualEffect.new()
		visual:Setup(player.environment,player.position.x,player.position.y,player.position.z+2)
		visual.player=player		
	end	
	
	
	function class.HandleCustom_PALLYBUBBLE(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
		if(#auras==0)then
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.PAINSMITH.Aura_PallyBubble)
		end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_Freeze)
		for i=1,#auras do
			auras[i]:Die()
		end
	end	
	

	

	
	local function QuickCast(spell,scenario,boss,savedangle)
		local queuepointer=spell:NewQueue()
		queuepointer.castercombat=boss.combatmodule
		local spellinstance=spell:NewCast(queuepointer)
		spellinstance.targetcombat=boss.combatmodule
		spellinstance.savedangle=savedangle
		spellinstance.scenario=scenario
		spellinstance.spellbookspell:StartCasting(boss.environment.localtime,spellinstance)
		boss.combatmodule.castedspell=spellinstance					
	end
	


	
	function class.HandleCustom_DEAD_EMBERS(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from Shadowsteel Embers.",3.0)
	end	
	
	function class.HandleCustom_DEAD_FLOORSPIKES(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from floor spikes.",3.0)
	end		
	
	function class.HandleCustom_DEAD_RINGOUT(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." fell off the arena.",3.0)
		--player.position.x=-XPRACTICE.PAINSMITH.Config.ArenaRadius+3;player.position.y=0;player.position.z=2
	end		
	
	function class.HandleCustom_DEAD_SPIKEDBALL(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from a Spiked Ball.",3.0)
	end			
	

	
end		
		
	
	
	
	