-- pure virtual
do
	local super=XPRACTICE.WoWObject
	XPRACTICE.INDIGNATION.MassacreTelegraph=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.MassacreTelegraph

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.oob=false	--might be true by the end of this function
		self.alpha=0
		--self.MAX_LENGTH=300
		self.MAX_LENGTH=1000	-- will be cropped later
		self.origin={}
		--self.angle=0
		--self.angle=math.random()*math.pi*2 --TODO:

		local playerx	--TODO:
		local playery
		--playerx,playery=XPRACTICE.RandomPointInCircle(0,0,48)
		playerx,playery=self.targetplayer.position.x,self.targetplayer.position.y
		--self.angle=math.atan2(playery,playerx)+(math.pi/2)*(math.random()*2-1)

		--origin point is always one of the bottomless pit sections in the corner
			-- always 3 swords per corner, starting from northeast, clockwise?
			-- in order: 123 465 879 CBA
			-- cd7Gw1aPg5A  6:08
		--TODO: global static vars and/or functions
		local originx,originy
		local NEAR=30
		local FAR=60
		local CORNER=35
		--local CORNER=60-30*math.cos(math.pi/4)
		local originquad=math.floor((self.originindex-1)/3)	-- which corner of the room?
		local origintripoint=(self.originindex%3)		-- which corner of the triangle?
		--print("Quad:",originquad)
		--print("Tripoint:",origintripoint)
		if(origintripoint==1)then
			originx=-FAR
			originy=NEAR
		elseif(origintripoint==2)then
			originx=-CORNER
			originy=CORNER
		elseif(origintripoint==0)then
			originx=-NEAR
			originy=FAR
		end
		originx,originy=XPRACTICE.Transform_Rotate2D(originx,originy,originquad*-math.pi/2,0,0)
		self.origin.x=originx
		self.origin.y=originy
		
		self.angle=math.atan2(playery-originy,playerx-originx)
		


		-- --TODO: calculate origin and maxlength from player position and room size
		-- --TODO: if origin is closer to player than endpoint, swap them and reverse angle
		-- self.origin.x=math.cos(self.angle)*-self.MAX_LENGTH/2+playerx
		-- self.origin.y=math.sin(self.angle)*-self.MAX_LENGTH/2+playery
		
		self:CropSquare()
		
		self.origin.z=0
		--self.linewidth=3	--TODO: options menu
		self.linewidth=XPRACTICE.Config.Indignation.MassacreLineWidth	--TODO: options menu
		--self.linelength=15	--TODO: minimum linewidth*4.3
		self.linestart=0
		self.lineend=15			--TODO: minimum linewidth*4.3				
		self.expandspeed=800
		self.retractspeed=200
		self.alivetime=0
		--self.telegraphtime=XPRACTICE.Config.Indignation.MassacreTelegraphTimeMinimum
		self.telegraphtime=XPRACTICE.RandomNumberInBetween(XPRACTICE.Config.Indignation.MassacreTelegraphTimeMinimum,XPRACTICE.Config.Indignation.MassacreTelegraphTimeMaximum)
		--self.telegraphtime=2.5
		--self.telegraphtime=2.75
		--self.telegraphtime=3
	end
	
	function class:CreateAssociatedObjects()	
		local SWORDZ=-3.125
		local sword=XPRACTICE.INDIGNATION.MassacreSwordVisual.new()
		sword:Setup(self.environment,self.origin.x,self.origin.y,SWORDZ)
		sword.orientation_displayed.yaw=self.angle
		self.sword=sword
	end
	
	function class:CropSquare()
		local RADIUS=160 
		local x1=self.origin.x
		local y1=self.origin.y
		local x2=self.origin.x+self.MAX_LENGTH*math.cos(self.angle)
		local y2=self.origin.y+self.MAX_LENGTH*math.sin(self.angle)
		local result={}
		local x,y
		x,y=XPRACTICE.LineLineIntersectionPosition(x1,y1,x2,y2,-RADIUS,-RADIUS,RADIUS,-RADIUS)
		if(x)then tinsert(result,{x=x,y=y})end
		x,y=XPRACTICE.LineLineIntersectionPosition(x1,y1,x2,y2,-RADIUS,RADIUS,RADIUS,RADIUS)
		if(x)then tinsert(result,{x=x,y=y})end
		x,y=XPRACTICE.LineLineIntersectionPosition(x1,y1,x2,y2,-RADIUS,-RADIUS,-RADIUS,RADIUS)
		if(x)then tinsert(result,{x=x,y=y})end
		x,y=XPRACTICE.LineLineIntersectionPosition(x1,y1,x2,y2,RADIUS,-RADIUS,RADIUS,RADIUS)
		if(x)then tinsert(result,{x=x,y=y})end
		
		if(#result==1)then
			self.MAX_LENGTH=math.sqrt((result[1].x-self.origin.x)*(result[1].x-self.origin.x)+(result[1].y-self.origin.y)*(result[1].y-self.origin.y))
			
		-- else
			-- -- line is out of bounds
			-- self.oob=true
			-- self:Die()
		end
	end

	function class:Start()
		--override, call super
		self.state=1
	end
	function class:Step(elapsed)
		self.alivetime=self.alivetime+elapsed
		if(self.scenario.bossdead)then self:Die() end
		
		--override, call super
		if(self.state==1)then
			self.lineend=self.lineend+self.expandspeed*elapsed
			if(self.lineend>self.MAX_LENGTH)then 
				self.lineend=self.MAX_LENGTH 
				self.state=2				
			end
		elseif(self.state==2)then
			if(self.alivetime>self.telegraphtime-0.5)then
				self.sword.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.RemorniaMassacreAttackStart)
			end
			if(self.alivetime>self.telegraphtime)then 
				self.state=3
			end
		elseif(self.state==3)then
			local prevlinestart=self.linestart
			local player=self.scenario.player
			self.linestart=self.linestart+self.retractspeed*elapsed
			local x1=self.origin.x+prevlinestart*math.cos(self.angle)
			local y1=self.origin.y+prevlinestart*math.sin(self.angle)
			local x2=self.origin.x+self.linestart*math.cos(self.angle)
			local y2=self.origin.y+self.linestart*math.sin(self.angle)
			local TOLERANCE=self.linewidth/2
			if(XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,TOLERANCE))then
				self.scenario:AttemptKillPlayer(1,"You died from Massacre.",false)
			end

			self.sword.position.x=x2
			self.sword.position.y=y2
			self.sword.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.RemorniaMassacreAttack)


			if(self.linestart>=self.lineend)then
				self.state=4
			end
		elseif(self.state==4)then
			--self.sword.fadestarttime=self.environment.localtime	--moved to Cleanup
			--self.sword.expirytime=self.environment.localtime+0.25
			self:Die()
		end
	end

	function class:Cleanup()
		--override, call super
		super.Cleanup(self)
			self.sword.fadestarttime=self.environment.localtime
			self.sword.expirytime=self.environment.localtime+0.25
			self:Die()		
	end

end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.INDIGNATION.MassacreSwordVisual=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.MassacreSwordVisual
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=10
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByCreatureDisplayID(96665)
	end	
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.RemorniaEmerge)
	end
	function class:PlayIdleAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.RemorniaEmerge)
	end
end