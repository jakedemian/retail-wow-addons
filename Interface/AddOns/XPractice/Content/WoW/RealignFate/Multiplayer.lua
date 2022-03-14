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

	local roomnumber=XPRACTICE.FATESCRIBEMULTIPLAYER.NPCID
	local roomBCD=XPRACTICE.MULTIPLAYER.Datatypes.BCD.ToString(XPRACTICE.FATESCRIBEMULTIPLAYER.NPCID)	
	XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD]={}
	do
		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes={}
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer={}
		local messagecode=0
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="CUSTOMGOALS"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={	{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="PLACEGOALSWITHOUTSAVING"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={	{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]
				
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="SCRAMBLE"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=true
			self.argtypes={	{XPRACTICE.MULTIPLAYER.Datatypes.BOOLEAN},	-- skip intro
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},	--goal angle
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},	--ring orientation_displayed prior to scramble
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},	--ring spin direction
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},			
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},	--ring which rune
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},	--rune stop angle
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},							
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},	--orbspawner angle
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,0}}	--orbspawner nextID
			--print("Boolean:",XPRACTICE.MULTIPLAYER.Datatypes.BOOLEAN)

		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="ONRING"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]	
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="OFFRING"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]	

		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="RINGSTOP"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]	
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="RINGMAXSPEED"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.BOOLEAN},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]	

		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="RINGCLEAR"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR},
							{XPRACTICE.MULTIPLAYER.Datatypes.BCD,6}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]	
		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="HIT_ORB"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=true
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.BCD,0},	-- orb ID
							{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}}	-- 1: no reaction (immuned) // 2: debuff // 3: dead
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]		
		
		
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="DEAD_ORBSPAWNER"
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
		local messagename="DEAD_LINE"
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
		local messagename="ADDGHOST"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]				
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="REMOVEGHOST"
		local super=XPRACTICE.MULTIPLAYER.Message
		local lambda=XPRACTICE.inheritsFrom(super)
		local class=lambda	
		function class:SetCustomInfo()
			self.messagename=messagename;self.messagecode=messagecode;self.BCDmessagecode=BCDmessagecode
			self.ignoreself=false
			self.requireofficer=false
			self.argtypes={{XPRACTICE.MULTIPLAYER.Datatypes.CHAR}}
		end		
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]=lambda.new();XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]:Setup()
		XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].MessagetypesBCDPointer[BCDmessagecode]=XPRACTICE.MULTIPLAYER["CUSTOM_"..roomBCD].Messagetypes[messagename]				
		
		messagecode=messagecode+1
		local BCDmessagecode=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD.ToString(messagecode)
		local messagename="LINES"
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
				
	end
	
	local super=XPRACTICE.MULTIPLAYER.Multiplayer
	XPRACTICE.FATESCRIBEMULTIPLAYER.Multiplayer=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Multiplayer		
		
		-- -- not used; overwritten by kelthuzad version
	-- local prev=class.Handle_HELLO
	-- function class.Handle_HELLO(self,sender,args)
		-- prev(self,sender,args)		
		-- --TODO: check first if there's already an officer in the room who sent GOALS earlier
		-- --TODO NEXT: this is scenario-specific!
		-- if(IsRealOfficer("player"))then
			-- if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customgoals)then
				-- local rings=self.scenario.rings
				-- self:FormatAndSendCustom("PLACEGOALSWITHOUTSAVING",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)
			-- end
			-- --TODO NEXT: move worldmarker send to baseline
			-- if(self.scenario.worldmarkercontroller)then
				-- self.scenario.worldmarkercontroller:SendAll(self)
			-- end
		-- end		
	-- end
	
	function class.HandleCustom_CUSTOMGOALS(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		for i=1,#scenario.rings do
			ring=scenario.rings[i]
			ring:SetIndicator(args[i])
			local var="goalangle"..tostring(i)
			XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[var]=args[i]
		end
	end
	
	function class.HandleCustom_PLACEGOALSWITHOUTSAVING(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		for i=1,#scenario.rings do
			ring=scenario.rings[i]
			ring:SetIndicator(args[i])
		end
		
		----TODO: only display message if the goal positions actually changed!
		--self.statuslabel:SetText(sender.." adjusted the goal positions.")
	end	
	
	function class.HandleCustom_LINES(self,sender,args)			
		if(not IsRealOfficer(sender))then return end
		local scenario=self.scenario
		scenario.ringlasers=args[1]
	end	
	
	
	function class.HandleCustom_SCRAMBLE(self,sender,args)
		if(not self.roomlocked)then return end
		--print("SCRAMBLE host:",self.hostname,sender)
		if(not self.hostname==sender)then return end
		local scenario=self.scenario
		local a=1
		local skipintro=args[a];a=a+1
		XPRACTICE.FATESCRIBEMULTIPLAYER.Config.SkipIntro=skipintro
		if(not XPRACTICE.FATESCRIBEMULTIPLAYER.Config.SkipIntro)then
			local decor=XPRACTICE.FATESCRIBEMULTIPLAYER.DecorWindRadial.new()
			decor:Setup(scenario.game.environment_gameplay)
			decor.scenario=scenario
			-- this function also applies stamp roar to the group
			XPRACTICE.FATESCRIBEMULTIPLAYER.DecorWindRadial.ApplyStampedingRoar(scenario)			
		else
			-- final knockback immediately
			XPRACTICE.FATESCRIBEMULTIPLAYER.DecorWindRadial.Knockback(scenario)
		end
		for i=1,#self.scenario.rings do			
			local goalangle=args[a];a=a+1
			self.scenario.rings[i]:SetIndicator(goalangle)				
		end
		for i=1,#self.scenario.rings do			
			local ring=self.scenario.rings[i]
			local ody=args[a];a=a+1
			--print("ODY:",ody)
			ring.orientation_displayed.yaw=XPRACTICE.WrapAngle(ody)
		end
		for i=1,#self.scenario.rings do			
			local ring=self.scenario.rings[i]
			local dir=args[a];a=a+1
			dir=tonumber(dir)
			if(dir==1)then 
				ring.scrambledirection=-1
			else
				ring.scrambledirection=1
			end			
		end		
		for i=1,#self.scenario.rings do			
			local ring=self.scenario.rings[i]
			local rune=args[a];a=a+1
			rune=tonumber(rune)
			if(rune<1 or rune>6)then rune=1 end
			ring.runeindex=rune
		end					
		for i=1,#self.scenario.rings do			
			local ring=self.scenario.rings[i]
			local stopangle=args[a];a=a+1
			ring.stopangle=XPRACTICE.WrapAngle(stopangle)
		end
		local orbs=args[a];a=a+1
		scenario.orbspawnercontroller:Activate()
		scenario.orbspawnercontroller:SetAngle(orbs)
		
		--local runeangles=XPRACTICE.FATESCRIBEMULTIPLAYER.RUNEANGLES
		-- for i=1,#self.scenario.rings do
			-- local ring=self.scenario.rings[i]
			-- --ring.stopangle=ring.stopangle-runeangles[ring.ringindex][ring.runeindex]
			-- ring.runeindex=1--!!!
			-- ring.stopangle=ring.stopangle+runeangles[ring.ringindex][ring.runeindex]
			-- --print("Adding angle",runeangles[ring.ringindex][ring.runeindex])
		-- end

		scenario.boss.targetheight=scenario.boss.maxheight
		scenario.boss.position={x=0,y=0,z=scenario.boss.maxheight}
		scenario.boss:CreateSpeechBubble("\124cffff3f40The loom weaves your destruction!\124r")
		for i=1,#scenario.rings do
			local ring=scenario.rings[i]
			--local offset=1+ring.ringindex
			ring.active=false
			ring.scrambling=true						
			ring.displayobject.drawable:SetAnimation(0)
			-- 2.5 seconds after cast ends, runes light up
			ring.scramblerunetimer=3.0+2.5
			if(XPRACTICE.FATESCRIBEMULTIPLAYER.Config.SkipIntro)then ring.scramblerunetimer=0.5 end --TODO: savedata
			-- indicator lights up when its own ring stops moving

			local remainingangle
			if(ring.scrambledirection==1)then
				remainingangle=XPRACTICE.WrapAngle(ring.stopangle-ring.orientation_displayed.yaw)
			else
				remainingangle=XPRACTICE.WrapAngle(ring.orientation_displayed.yaw-ring.stopangle)
			end
			if(remainingangle<0)then remainingangle=remainingangle+math.pi*2 end
			-- add another 2pi if ring will stop moving before runes light up
			if(remainingangle<math.pi/4)then remainingangle=remainingangle+math.pi*2 end
			ring.scrambleremainingmovement=remainingangle
			if(XPRACTICE.FATESCRIBEMULTIPLAYER.Config.SkipIntro)then ring.scrambleremainingmovement=0;ring.orientation_displayed.yaw=ring.stopangle end --TODO: savedata
			-- if(ring.ringindex==1)then
				-- print("Indicator:",ring.indicator.angle)
				-- print("Rune:",runeangles[ring.ringindex][ring.runeindex])
				-- print("Target:",targetangle)					
				-- print("Stop:",ring.stopangle)
				-- print("Current:",ring.orientation_displayed.yaw)
				-- print("Remaining:",remainingangle)
			-- end			
		end
		
		--scenario.boss
		local boss=scenario.boss
		local bosscombat=boss.combatmodule
		local spellqueue=bosscombat.spellbook.spell_rfcosmetic:NewQueue()
		local spellinstance=bosscombat.spellbook.spell_rfcosmetic:NewCast(spellqueue)
		local localtime=boss.environment.localtime
		spellinstance.targetcombat=nil
		--print("Start casting at time",queuetime)
		spellinstance.spellbookspell:StartCasting(localtime,spellinstance)					
		bosscombat.castedspell=spellinstance					
		--print("Casting spell:",spellinstance,"at time",queuetime,"(local time",self.localtime..")")
		bosscombat.queuedspell=nil	
		
	end	
	
	function class.HandleCustom_ONRING(self,sender,args)
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]
		ring.realplayercount=ring.realplayercount+1
	end
	
	function class.HandleCustom_OFFRING(self,sender,args)
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]		
		ring.realplayercount=ring.realplayercount-1
		if(ring.realplayercount<=0)then ring.realplayercount=0 end

	end

	function class.HandleCustom_RINGSTOP(self,sender,args)		
		local player=self.allplayers[sender]	
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]
		if(ring.ringvelocity==0)then return end
		ring.ringvelocity=0
		ring.orientation_displayed.yaw=XPRACTICE.WrapAngle(args[2])
		ring.goaloffsetyaw=args[3]  -- do not wrap!  expected range between 0 and 2pi        
	end
	
	function class.HandleCustom_RINGMAXSPEED(self,sender,args)
		if(true)then return end	
		-- this one was more useful when we were using the wrong accel formula...
		local player=self.allplayers[sender]	
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]
		if(ring.ringvelocity==0)then return end		
		local signum
		if(args[2]==true)then signum=1 else signum=-1 end
		local maxvelocity=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MaxRingSpeedDeadZone+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MinRingSpeedDeadZone
		ring.ringvelocity=maxvelocity*signum
		ring.orientation_displayed.yaw=XPRACTICE.WrapAngle(args[3])
		ring.goaloffsetyaw=args[4]  -- do not wrap!  expected range between 0 and 2pi        
		
	end	
	
	function class.HandleCustom_RINGCLEAR(self,sender,args)		
		local player=self.allplayers[sender]			
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]
		
		ring.active=false
		ring.ringindicator.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2DespawnCustomDuration)
		ring.ringindicatorvisible=false
		ring.realplayercount=0
		ring.ghostplayercount=0
		if(scenario.playercurrentring==ring.ringindex)then scenario.playercurrentring=nil end
		local animations=XPRACTICE.FATESCRIBEMULTIPLAYER.RINGANIMATIONS
		ring.displayobject.drawable:SetAnimation(animations[ring.runeindex][3])
		ring.ringvelocity=0
		ring.orientation_displayed.yaw=XPRACTICE.WrapAngle(args[2])
		ring.goaloffsetyaw=args[3]  -- do not wrap!  expected range between 0 and 2pi        
		local success=true
		--check if all rings are now inactive
		for j=1,#scenario.rings do
			if(scenario.rings[j].active)then success=false end
		end
		if(success)then
			scenario.orbspawnercontroller:Deactivate()
			local decor=XPRACTICE.FATESCRIBEMULTIPLAYER.DecorRingSuccess.new()
			decor:Setup(ring.environment)
			decor.scenario=scenario						
			scenario.statuslabel:SetText("Phase complete!",3.0)
			if(self.host)then
				scenario.multiplayer.Send.UNLOCK(scenario.multiplayer)
			end
		end
	
	end	
	
	function class.HandleCustom_HIT_ORB(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]
		if(not player)then return end
		for i=1,#scenario.orbs do
			local orb=scenario.orbs[i]
			if(orb.id==args[1])then
				if(not orb.despawning)then
					orb.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2DespawnCustomDuration)
				end
			end
		end
		if(string.byte(args[2])==1)then
			-- do nothing
		elseif(string.byte(args[2])==2)then
			player.combatmodule:ApplyAuraByClass(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate,scenario.boss.combatmodule,player.environment.localtime)
		elseif(string.byte(args[2])==3)then
			player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
			scenario.statuslabel:SetText(sender.." died from Fate Fragments.",3.0)
		end
	
	end
	
	
	-- function class.HandleCustom_ORBDEBUFF(self,sender,args)
		-- local scenario=self.scenario
		-- local player=self.allplayers[sender]
		-- if(not player)then return end
		-- player.combatmodule:ApplyAuraByClass(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate,scenario.boss.combatmodule,player.environment.localtime)
	-- end	
	
	-- function class.HandleCustom_DEAD_ORBS(self,sender,args)
		-- local scenario=self.scenario
		-- local player=self.allplayers[sender]	
		-- if(not player)then return end
		-- player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		-- scenario.statuslabel:SetText(sender.." died from Fate Fragments.",3.0)
	-- end	
	
	function class.HandleCustom_DEAD_ORBSPAWNER(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]	
		if(not player)then return end
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from a Fate Fragment spawner.",3.0)
	end		
	
	function class.HandleCustom_DEAD_LINE(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]
		if(not player)then return end		
		player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
		scenario.statuslabel:SetText(sender.." died from Exposed Threads of Fate.",3.0)
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
	
	function class.HandleCustom_ADDGHOST(self,sender,args)
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]
		if(ring.ghostplayercount<9)then
			ring.ghostplayercount=ring.ghostplayercount+1
			scenario.statuslabel:SetText(sender.." added an imaginary player to ring #"..tostring(ring.ringindex).." ("..tostring(ring.ghostplayercount).." total).",3.0)							
		else
			--scenario.statuslabel:SetText("That's more than enough imaginary players.",3.0)
		end
	end
	
	function class.HandleCustom_REMOVEGHOST(self,sender,args)
		local ringindex=tonumber(args[1])
		if(ringindex<0 or ringindex>6)then return end
		local scenario=self.scenario
		local ring=scenario.rings[ringindex]		
		if(ring.ghostplayercount>0)then
			ring.ghostplayercount=ring.ghostplayercount-1
			scenario.statuslabel:SetText(sender.." removed an imaginary player from ring #"..tostring(ring.ringindex).." ("..tostring(ring.ghostplayercount).." remaining).",3.0)							
		else
			--scenario.statuslabel:SetText("No imaginary players to remove.",3.0)
			ring.ghostplayercount=0
			ring.realplayercount=0
			scenario.statuslabel:SetText(sender.." told ring #"..tostring(ring.ringindex).." to panic and clear ALL players.",3.0)
			--if(scenario.playercurrentring==ring.ringindex)then scenario.playercurrentring=nil end
		end
	end	
	
	function class.HandleCustom_PALLYBUBBLE(self,sender,args)
		local scenario=self.scenario
		local player=self.allplayers[sender]
		if(not player)then return end
		if(player:IsDeadInGame())then return end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
		if(#auras==0)then
			local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
		end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate)
		for i=1,#auras do
			auras[i]:Die()
		end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff)
		for i=1,#auras do
			auras[i]:Die()
		end
	end		
end		
		
	
	
	
	