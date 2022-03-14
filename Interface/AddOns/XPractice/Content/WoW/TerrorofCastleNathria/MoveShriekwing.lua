do
	MoveShriekwing={}
	ShriekwingTargetLocations={}
	ShriekwingTargetLocations[1]={x=-XPRACTICE.Config.Shriekwing.DiagonalXCoordinate,y=XPRACTICE.Config.Shriekwing.DiagonalYCoordinate}
	ShriekwingTargetLocations[2]={x=0,y=XPRACTICE.Config.Shriekwing.NorthsouthYCoordinate}
	ShriekwingTargetLocations[3]={x=XPRACTICE.Config.Shriekwing.DiagonalXCoordinate,y=XPRACTICE.Config.Shriekwing.DiagonalYCoordinate}
	ShriekwingTargetLocations[4]={x=XPRACTICE.Config.Shriekwing.EastwestXCoordinate,y=0}
	ShriekwingTargetLocations[5]={x=XPRACTICE.Config.Shriekwing.DiagonalXCoordinate,y=-XPRACTICE.Config.Shriekwing.DiagonalYCoordinate}
	ShriekwingTargetLocations[6]={x=0,y=-XPRACTICE.Config.Shriekwing.NorthsouthYCoordinate}
	ShriekwingTargetLocations[7]={x=-XPRACTICE.Config.Shriekwing.DiagonalXCoordinate,y=-XPRACTICE.Config.Shriekwing.DiagonalYCoordinate}
	ShriekwingTargetLocations[8]={x=-XPRACTICE.Config.Shriekwing.EastwestXCoordinate,y=0}
	
	function MoveShriekwing.CustomInfoSupplement(self)
		self.requiresfacing=false		
		self.projectileclass=nil		
		self.basecastduration=0.000
		self.basechannelduration=nil
		self.basechannelticks=nil
		self.tickonchannelstart=false
		--self.usablewhilemoving=true
		self.usablewhilemoving=false
	end
	function MoveShriekwing.AbsoluteMovement(self,spellinstancepointer,index)
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.targetlocationindex=index
		MoveShriekwing.ToTargetLocationIndex(shriekwing)
	end
	function MoveShriekwing.RelativeMovement(self,spellinstancepointer,direction)
		local shriekwing=spellinstancepointer.castercombat.mob
		if(shriekwing.targetlocationindex<=0)then
			shriekwing.targetlocationindex=4
		end
		shriekwing.targetlocationindex=shriekwing.targetlocationindex+direction
		if(shriekwing.targetlocationindex<1)then shriekwing.targetlocationindex=8 end
		if(shriekwing.targetlocationindex>8)then shriekwing.targetlocationindex=1 end
		MoveShriekwing.ToTargetLocationIndex(shriekwing)		
	end	
	function MoveShriekwing.ToTargetLocationIndex(shriekwing)
		shriekwing.ai.targetposition={x=ShriekwingTargetLocations[shriekwing.targetlocationindex].x,y=ShriekwingTargetLocations[shriekwing.targetlocationindex].y,z=0}
		
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingNorth=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingNorth
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing North"
		self.icon="interface/icons/misc_arrowlup.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		MoveShriekwing.AbsoluteMovement(self,spellinstancepointer,2)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingEast=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingEast
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing East"
		self.icon="interface/icons/misc_arrowright.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		MoveShriekwing.AbsoluteMovement(self,spellinstancepointer,4)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingSouth=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingSouth
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing South"
		self.icon="interface/icons/misc_arrowdown.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		MoveShriekwing.AbsoluteMovement(self,spellinstancepointer,6)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingWest=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingWest
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing West"
		self.icon="interface/icons/misc_arrowleft.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		MoveShriekwing.AbsoluteMovement(self,spellinstancepointer,8)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingCounterclockwise=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingCounterclockwise
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing Counterclockwise"
		self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.movementdirection=-1	
		MoveShriekwing.RelativeMovement(self,spellinstancepointer,shriekwing.movementdirection)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingClockwise=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingClockwise
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing Clockwise"
		self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.movementdirection=1
		MoveShriekwing.RelativeMovement(self,spellinstancepointer,shriekwing.movementdirection)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingAuto=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_MoveShriekwingAuto
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="Move Shriekwing Auto"
		self.icon="interface/icons/inv_misc_questionmark.blp"
		MoveShriekwing.CustomInfoSupplement(self)
	end	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		local shriekwing=spellinstancepointer.castercombat.mob
		
		if(shriekwing.targetlocationindex<=0)then
			local target=XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekwingFirstMovementLocation
			if(target==0)then
				target=math.floor(math.random()*4+1)*2
			end
			MoveShriekwing.AbsoluteMovement(self,spellinstancepointer,target)
			shriekwing.automovessincereversedirection=0
		else
			if(shriekwing.movementdirection==0)then
				shriekwing.movementdirection=XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekwingMovementDirection
				if(shriekwing.movementdirection==0)then
					if(math.random()>.5)then shriekwing.movementdirection=-1 else shriekwing.movementdirection=1 end
				end
			end
			shriekwing.automovessincereversedirection=shriekwing.automovessincereversedirection+1
			if(shriekwing.automovessincereversedirection>3)then
				if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekwingMovementDirection==0 and XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.IntermissionLength==-1 and math.random()<1/8.0)then
					shriekwing.movementdirection=-shriekwing.movementdirection
					shriekwing.automovessincereversedirection=1
				end
			end
			
			MoveShriekwing.RelativeMovement(self,spellinstancepointer,shriekwing.movementdirection)
		end
		
	end
end