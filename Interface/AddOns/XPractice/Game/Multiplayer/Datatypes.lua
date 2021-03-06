local PH=1
do
	
	XPRACTICE.MULTIPLAYER.Datatype = {}
	local class=XPRACTICE.MULTIPLAYER.Datatype
	class.__index = class
	
	function class.new()
		local self=setmetatable({}, class)	
		return self
	end
	
	function class.Name()
		return "?"
	end
	
	function class.Size()
		return -1
	end
	
	function class.Decode()
		return -1
	end
end

XPRACTICE.MULTIPLAYER.Datatypes={}

do
	local super=XPRACTICE.MULTIPLAYER.Datatype
	XPRACTICE.MULTIPLAYER.Datatypes.BCD=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.MULTIPLAYER.Datatypes.BCD
	
	function class.Name()
		return "BCD-4"
	end
	
	function class.Size()
		return 4
	end
	
	--TODO NEXT: decimals=6 gives us X.XXXXX, not XX.XXXXXX
	function class.ToString(number,decimals)		
		decimals=decimals or 0
		--print("Encode:",number,"Decimals:",decimals)
		local sign
		local debugsign
		if(number<0)then 
			sign=13
			debugsign="-" 
		else 
			sign=12
			debugsign="+" 
		end
		
		local result={}	
		---- floating point error makes the standard "%10 method" unworkable
		local str=tostring(math.abs(number))
		
		local oops=string.find(str,"e")
		if(oops)then
			-- number is either absurdly small or absurdly large
			if(string.sub(str,oops+1,oops+1)=="-")then
				str="00000000.00000000"
			else
				str="99999999.99999999"	--TODO: not formally tested yet
			end
		end
		
		--print("str",str)
		local decindex=string.find(str,"%.")
		if(decindex)then
			--print("dec",decindex)
			str=string.sub(str,1,decindex-1)..string.sub(str,decindex+1)
		else
			decindex=string.len(str)+1
			--print("Decindex:",decindex)
		end	
		local r=1
		for i=decindex+decimals-7,decindex+decimals-1 do
			local chr
			if(i>=1 and i<=string.len(str))then
				chr=string.sub(str,i,i)
			else
				chr="0"
			end	
			result[r]=tonumber(chr)
			if(result[r]==0)then
				result[r]=10		-- NUL not allowed in messages.  convert 0000 to 1010
			end	
			r=r+1
			--print("strindex",i,"chr",chr)
			
		end
		result[8]=sign
		
		
		-- local debugstr=""
		-- for i=1,8 do
			-- debugstr=debugstr..result[i]
		-- end
		-- print(debugstr)
		
		local text=""
		for i=1,7,2 do
			local high=result[i]
			local low=result[i+1]
			local total=high*16+low
			--print("SEND byte:",total,string.char(total))
			text=text..string.char(total)
		end
		
		return text
	end

	
	function class.Decode(str,decimals)
		local result=0
		local sign=1
		for i=1,4 do
			local chr=string.sub(str,i,i)
			local byt=string.byte(chr)
			local high=math.floor(byt/16)
			local low=math.floor(byt%16)			
			if(high==10)then high=0 end
			if(low==10)then low=0 end			
			if(high<0 or high>9)then return 0 end
			--print("GET byte:",byt,high,low)
			result=result*10			
			result=result+high
			if(i~=4)then
				if(low<0 or low>9)then return 0 end
				result=result*10
				result=result+low
			else				
				if(low==13)then sign=-1 end
				--print("Sign:",sign)
			end
		end
		result=result*math.pow(10,-decimals)
		result=result*sign
		return result
	end
end

do
	local super=XPRACTICE.MULTIPLAYER.Datatype
	XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.MULTIPLAYER.Datatypes.ShortBCD
	
	function class.Size()
		return 2
	end
	
	function class.ToString(number,decimals)			
		decimals=decimals or 0
		local sign
		local debugsign
		if(number<0)then 
			sign=13
			debugsign="-" 
		else 
			sign=12
			debugsign="+" 
		end
		
		local result={}	
		---- floating point error makes the standard "%10 method" unworkable
		local str=tostring(math.abs(number))
		--print("str",str)
		local decindex=string.find(str,"%.")
		if(decindex)then
			--print("dec",decindex)
			str=string.sub(str,1,decindex-1)..string.sub(str,decindex+1)
		else
			decindex=string.len(str)+1
		end	
		local r=1
		for i=decindex+decimals-3,decindex+decimals-1 do
			local chr
			if(i>=1 and i<=string.len(str))then
				chr=string.sub(str,i,i)
			else
				chr="0"
			end	
			result[r]=tonumber(chr)
			if(result[r]==0)then
				result[r]=10		-- NUL not allowed in messages.  convert 0000 to 1010
			end
			r=r+1
			--print("chr",chr)
		end
		result[4]=sign
		
		
		-- local debugstr=""
		-- for i=1,8 do
			-- debugstr=debugstr..result[i]
		-- end
		-- print(debugstr)
		
		local text=""
		for i=1,3,2 do
			local high=result[i]
			local low=result[i+1]
			local total=high*16+low
			text=text..string.char(total)
		end		
		return text
	end
	

	
	function class.Decode(str,decimals)
		--TODO NEXT:
		return -1
	end
end



do
	local super=XPRACTICE.MULTIPLAYER.Datatype
	XPRACTICE.MULTIPLAYER.Datatypes.BOOLEAN=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.MULTIPLAYER.Datatypes.BOOLEAN
	
	function class.Size()
		return 1
	end
	
	function class.ToString(bool)
		if(bool)then return "1" else return "0" end
	end
	
	function class.Decode(str)
		if(str=="0")then return false else return true end
	end
end

do
	local super=XPRACTICE.MULTIPLAYER.Datatype
	XPRACTICE.MULTIPLAYER.Datatypes.CHAR=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.MULTIPLAYER.Datatypes.CHAR
	
	function class.Name()
		return "CHAR"
	end
	
	function class.Size()
		return 1
	end
	
	--TODO: assertion failed if chr size > 1 (means we forgot to convert number to char first)
	function class.ToString(chr)
		return chr
	end
	
	function class.Decode(str)
		return str
	end
end