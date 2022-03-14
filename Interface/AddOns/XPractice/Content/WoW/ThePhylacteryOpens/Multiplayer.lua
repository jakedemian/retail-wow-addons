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

	local roomnumber=XPRACTICE.KELTHUZADMULTIPLAYER.NPCID
	local roomBCD=XPRACTICE.MULTIPLAYER.Datatypes.BCD.ToString(XPRACTICE.KELTHUZADMULTIPLAYER.NPCID)	
	XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD]={}
	do
		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes={}
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer={}
		local messagecode=0
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="SWIRLSYNC_SLOW"
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
		local messagename="SWIRLSYNC_FAST"
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
		local messagename="APPEAR_HUMAN"
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
		local messagename="APPEAR_LICH"
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
		local messagename="FREEZE_BEAM"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="FREEZE_CYCLO"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,4}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="DEAD_SWIRL"
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
		local messagename="DEAD_POOL"
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
		local messagename="DEAD_WRATH"
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
	XPRACTICE.KELTHUZADMULTIPLAYER.Multiplayer=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.Multiplayer		
	
	--local prev=class.Handle_HELLO -- this doesn't work anymore!  prev now refers to FATESCRIBE for some reason --TODO: why?
	local prev=XPRACTICE.MULTIPLAYER.Multiplayer.Handle_HELLO 
	function class.Handle_HELLO(self,sender,args)
		--print(XPRACTICE.MULTIPLAYER.Multiplayer.Handle, XPRACTICE.FATESCRIBEMULTIPLAYER.Handle, XPRACTICE.KELTHUZADMULTIPLAYER.Handle)
		--print(XPRACTICE.MULTIPLAYER.Multiplayer.Handle, XPRACTICE.KELTHUZADMULTIPLAYER.Handle)
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
	
	function class.HandleCustom_SWIRLSYNC_SLOW(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		--TODO: actually sync
		XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype=5
		scenario.swirlcontroller.swirlfrequency=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype
--TODO: once we've implemented outofphase, don't sync swirltimer until 1st player enters phase
		--scenario.swirlcontroller.swirltimer=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSwirlTime+1.0
		scenario.swirlcontroller.swirltimer=2.5
		scenario.swirlcontroller.swirltag=1		
		--scenario.statuslabel:SetText(sender.." set Shadow Fissure to 5 seconds.",3.0)
	end
	
	function class.HandleCustom_SWIRLSYNC_FAST(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		--TODO: actually sync
		XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype=3
		scenario.swirlcontroller.swirlfrequency=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype
--TODO: once we've implemented outofphase, don't sync swirltimer until 1st player enters phase
		--scenario.swirlcontroller.swirltimer=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSwirlTime+1.0
		scenario.swirlcontroller.swirltimer=1.0
		scenario.swirlcontroller.swirltag=1		
		--scenario.statuslabel:SetText(sender.." set Shadow Fissure to 2 seconds.",3.0)
		--scenario.statuslabel:SetText(sender.." set Shadow Fissure to 3 seconds.",3.0)
	end
	
	function class.HandleCustom_SWIRLSYNC_STOP(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		--TODO: actually sync
		XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype=0
		scenario.swirlcontroller.swirlfrequency=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype
--TODO: once we've implemented outofphase, don't sync swirltimer until 1st player enters phase
		scenario.swirlcontroller.swirltimer=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSwirlTime+1.0
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
		local visual=XPRACTICE.KELTHUZADMULTIPLAYER.SprintVisualEffect.new()
		visual:Setup(player.environment,player.position.x,player.position.y,player.position.z+2)
		visual.player=player		

	end			
	
	function class.HandleCustom_ROAR(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		scenario.statuslabel:SetText(sender.." casts Stampeding Roar.",3.0)
		player.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.BattleRoar)
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
			local visual=XPRACTICE.KELTHUZADMULTIPLAYER.RoarVisualEffect.new()
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
		local visual=XPRACTICE.KELTHUZADMULTIPLAYER.RoarVisualEffect.new()
		visual:Setup(player.environment,player.position.x,player.position.y,player.position.z+2)
		visual.player=player		
	end	
	
	
	function class.HandleCustom_PALLYBUBBLE(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
		if(#auras==0)then
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
		end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
		for i=1,#auras do
			auras[i]:Die()
		end
	end	
	
	function class.HandleCustom_MYSWIRL(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		
		if(not player.swirlpositions)then player.swirlpositions={} end
		if(not player.swirloffsets)then player.swirloffsets={} end
		player.swirlpositions[string.byte(args[1])]={x=args[2],y=args[3]}
		player.swirloffsets[string.byte(args[4])]={x=args[5],y=args[6]}
		
		--print("Got swirlposition",sender,"tag",args[1],string.byte(args[1]))
		-- print("Set swirloffset",sender,"tag",args[4],string.byte(args[4]))
	end
	
	function class.HandleCustom_QUEUE_BEAM(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end		
		tinsert(scenario.bossqueue,"IceBeam")
		scenario.statuslabel:SetText(sender.." queued up a spell (currently "..tostring(#scenario.bossqueue).." in queue).",3.0)
	end		
	
	function class.HandleCustom_QUEUE_PUSH(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end		
		tinsert(scenario.bossqueue,"Pushback")
		scenario.statuslabel:SetText(sender.." queued up a spell (currently "..tostring(#scenario.bossqueue).." in queue).",3.0)
	end		

	function class.HandleCustom_QUEUE_CYCLO(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end		
		tinsert(scenario.bossqueue,"Tornadoes")
		scenario.statuslabel:SetText(sender.." queued up a spell (currently "..tostring(#scenario.bossqueue).." in queue).",3.0)
	end		
	
	function class.HandleCustom_QUEUE_FINAL(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end		
		tinsert(scenario.bossqueue,"UndyingWrath")
		scenario.statuslabel:SetText(sender.." queued up a spell (currently "..tostring(#scenario.bossqueue).." in queue).",3.0)
	end			
	
	function class.HandleCustom_QUEUE_CLEAR(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		
		scenario.bossqueue={}
		scenario.statuslabel:SetText(sender.." cleared the spell queue.",3.0)
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
	
	function class.HandleCustom_CAST_BEAM(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local boss=scenario.boss
		if(#scenario.bossqueue>0)then tremove(scenario.bossqueue,1) end
		scenario.bossgcd=scenario.bossgcd-XPRACTICE.KELTHUZADMULTIPLAYER.Config.BossGCDSafetyBuffer+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamCastGCD
		QuickCast(boss.combatmodule.spellbook.beam,scenario,boss,args[1])
	end		
	
	function class.HandleCustom_CAST_PUSH(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local boss=scenario.boss
		if(#scenario.bossqueue>0)then tremove(scenario.bossqueue,1) end
		scenario.bossgcd=scenario.bossgcd-XPRACTICE.KELTHUZADMULTIPLAYER.Config.BossGCDSafetyBuffer+XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackCastGCD
		QuickCast(boss.combatmodule.spellbook.push,scenario,boss)
	end			
	
	function class.HandleCustom_CAST_CYCLO(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local boss=scenario.boss
		if(#scenario.bossqueue>0)then tremove(scenario.bossqueue,1) end
		scenario.bossgcd=scenario.bossgcd-XPRACTICE.KELTHUZADMULTIPLAYER.Config.BossGCDSafetyBuffer+XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoCastGCD
		QuickCast(boss.combatmodule.spellbook.cyclo,scenario,boss,args[1])
	end			

	function class.HandleCustom_CAST_FINAL(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local boss=scenario.boss
		if(#scenario.bossqueue>0)then tremove(scenario.bossqueue,1) end
		scenario.bossgcd=scenario.bossgcd-XPRACTICE.KELTHUZADMULTIPLAYER.Config.BossGCDSafetyBuffer+11.0
		QuickCast(boss.combatmodule.spellbook.final,scenario,boss)
	end	
	
	function class.HandleCustom_APPEAR_HUMAN(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local boss=scenario.boss
		boss.displayobject.drawable:SetModelByCreatureDisplayID(101350) --Remnant of Kel'Thuzad (humanmale_hd.m2)
		boss.scale=2
		boss.alpha=1.0
		scenario.currentphase=1
		XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.mobappearance=1
	end		
	function class.HandleCustom_APPEAR_LICH(self,sender,args)
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		local boss=scenario.boss
		boss.displayobject.drawable:SetModelByCreatureDisplayID(15945) --Remnant of Kel'Thuzad (3rd intermission) (KELTHUZADMULTIPLAYER.m2) 
										-- this model has dry ice effects, which somehow don't show up in the real game
		boss.scale=2
		boss.alpha=0.5			-- decreasing alpha makes the dry ice effects less prominent			
		scenario.currentphase=3
		XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.mobappearance=3
	end			
	
	function class.HandleCustom_FREEZE_BEAM(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.position.x=args[1]
		player.position.y=args[2]
		player.velocity.x=0;player.velocity.y=0
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
		if(#auras>0 and not auras[1].dying)then
			local newexpiry=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRootDuration
			if(newexpiry>auras[1].expirytime)then auras[1].expirytime=newexpiry end
		else
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze,player.combatmodule,player.environment.localtime)
			aura.expirytime=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRootDuration
			local visual=XPRACTICE.KELTHUZADMULTIPLAYER.FreezeVisualEffect.new()
			visual:Setup(player.environment,player.position.x,player.position.y,0)
			visual.player=player
			visual.orientation_displayed.yaw=player.orientation.yaw						
			self.scenario.statuslabel:SetText(sender.." was frozen by Freezing Blast.",3.0)			
		end
	end	
	
	function class.HandleCustom_FREEZE_CYCLO(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.position.x=args[1]
		player.position.y=args[2]
		player.velocity.x=0;player.velocity.y=0	
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
		if(#auras>0 and not auras[1].dying)then
			auras[1].expirytime=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoFreezeTime
		else
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze,player.combatmodule,self.localtime)
			aura.expirytime=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoFreezeTime
			aura.locaicon="interface/icons/ability_skyreach_four_wind.blp"
			local visual=XPRACTICE.KELTHUZADMULTIPLAYER.FreezeVisualEffect.new()
			visual:Setup(player.environment,player.position.x,player.position.y,0)
			visual.player=player
			visual.orientation_displayed.yaw=player.orientation.yaw
			scenario.statuslabel:SetText("Frozen by Glacial Winds.",3.0)
			self.scenario.statuslabel:SetText(sender.." was frozen by Glacial Winds.",3.0)	
		end
	end
	
	function class.HandleCustom_DEAD_SWIRL(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from Shadow Fissure.",3.0)
	end	
	
	function class.HandleCustom_DEAD_POOL(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from Shadow Pool.",3.0)
	end		
	
	function class.HandleCustom_DEAD_RINGOUT(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." fell off the arena.",3.0)
		--player.position.x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3;player.position.y=0;player.position.z=2
	end		
	
	function class.HandleCustom_DEAD_WRATH(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from Undying Wrath.",3.0)
	end			
	
	function class.HandleCustom_CHANGE_PHASE(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		
		if(player~=scenario.player)then
			if(args[1]==true)then
				--if(player.inphase~=true)then scenario.inphasecount=scenario.inphasecount+1 end
				--player.inphase=true
				--print("S.IPC",scenario.inphasecount)
				
				player.position.x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3
				player.position.y=0
				player.position.z=0						
				player:FreezeOrientation(0)
			else
				--if(player.inphase~=false)then scenario.inphasecount=scenario.inphasecount-1 end
				--player.inphase=false
				--if(scenario.inphasecount<0)then scenario.inphasecount=0 end
				--print("S.IPC",scenario.inphasecount)
				if(player==scenario.player)then return end			
				player.position={x=0,y=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-10,z=0}	
				player:FreezeOrientation(-math.pi/2)
				--player.orientation.yaw=-math.pi/2;player.orientation_displayed.yaw=player.orientation.yaw
			end		
			player.velocity.x=0
			player.velocity.y=0
			player.velocity.z=0
			player.ai.targetposition=nil
			player.destx=nil;player.desty=nil
			player.floorbelow=true
			-- local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase)
			-- if(#auras==0)then
				-- local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase,player.combatmodule,player.environment.localtime)
				-- aura.scenario=scenario
			-- end		
			-- if(player==self.scenario.player)then
				-- --TODO: camera visual
			-- end
		end
		
		--player.timeinphase=0
		player.timeinphase=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseTimeLagEstimate
		
		scenario.inphasecount=0
		for k,v in pairs(self.allplayers) do
			local player=v
			if(player.position.y>-1*(XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+10))then
				player.inphase=true
				scenario.inphasecount=scenario.inphasecount+1
			else
				player.inphase=false
			end
		end
		--print("S.IPC",scenario.inphasecount)		
		
	end			
		
	
end		
		
	
	
	
	