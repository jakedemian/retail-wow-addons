XPRACTICE.INDIGNATION.AnimationList={}
----XPRACTICE.AnimationTemplate.QuickSetup(animationlist,					name,		index,	subindex,	priority,	duration,	nextanimation)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"CustomSpell01",213,	0,			"Active",	0.75,		nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"IdleAttack2H",		18,		0,		"Shuffle",	1.0,		nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"MirrorStand",0,	0,"Active",nil,nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"MirrorBroken",216,	0,"Active",nil,nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"MirrorBreak",213,	0,"Active",3.0,XPRACTICE.INDIGNATION.AnimationList.MirrorBroken)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"MirrorRepair",214,	0,"Active",2.0,XPRACTICE.INDIGNATION.AnimationList.MirrorStand)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"CombatWhirlwind",814,	0,"Active",2.0,nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"ShaSpellPrecastBoth",828,	0,"Active",2.0,nil)

--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"RemorniaEmerge",224,	0,"Active",2.0,nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"RemorniaEmerge",224,	0,"Active",3.0,nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"RemorniaMassacreAttack",219,0,"Active",nil,nil)
XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.INDIGNATION.AnimationList,"RemorniaMassacreAttackStart",154,	0,"Active",0.5,XPRACTICE.INDIGNATION.AnimationList.RemorniaMassacreAttack)





do
	local super=XPRACTICE.Mob
	XPRACTICE.INDIGNATION.SireDenathrius=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.SireDenathrius

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=3
		self.basemovespeed=14.0
		self.walkspeed=7.0
		self.defaultspeechbubbleduration=4.0
		
		self.autoattacktimer=nil
		self.autoattackspeed=3.125 -- without Weakness
		----self.autoattackspeed=2.5*(1+.25+.2)	--guessing Remornia and Weakness stack additively = 3.625
		--self.autoattackspeed=3.8 -- even if they stack multiplicatively it shouldn't be as high as 3.8, but that's what the logs say		
								-- 2.5*1.25*1.2 = 3.75
		
		self.destx=nil
		self.desty=nil
		self.multidestx=nil
		self.multidesty=nil
		
		self.phase3time=0
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByCreatureDisplayID(92797)	
	end
	function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
		local radius=0.625
		local base=0
		local height=2.7
		displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
	end
	function class:PlayIdleAnimation()
		if(self.scenario.currentphase<=2)then
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ReadyUnarmed)
		else
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Ready2H)
		end
	end
	function class:PlayShuffleLeftAnimation()
		-- do nothing
	end
	function class:PlayShuffleRightAnimation()
		-- do nothing
	end		
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		if(self.scenario.phase==3)then
			self.phase3time=self.phase3time+1
			
		end

		if(self.autoattacktimer)then
			if(self.combatmodule.castedspell==nil and self.combatmodule.channeledspell==nil and self.scenario.stopallevents==false)then
				self.autoattacktimer=self.autoattacktimer-elapsed
				if(self.autoattacktimer<=0)then
					self.autoattacktimer=self.autoattacktimer+self.autoattackspeed
					self.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.IdleAttack2H)
				end
			end
		end
	
		--ghost movement--------------------------------------------		
		if(self.remainingreactiontime~=nil and self.destx and self.desty)then			
			self.remainingreactiontime=self.remainingreactiontime-elapsed
			if(self.remainingreactiontime<=0)then
				if(not self:IsInMidair())then
					self.remainingreactiontime=nil
					self.ai:SetTargetPosition(self.destx,self.desty)
					if(self.destyaw)then 
						--print("set yaw to destyaw",self.destyaw)
						self.orientation.yaw=self.destyaw 					
						self.destyaw=nil
					else
						if(self.desty and self.destx)then
							local angle=math.atan2(self.desty-self.position.y,self.destx-self.position.x)
							if(self.desty~=self.position.y or self.destx~=self.position.x)then
								self.orientation.yaw=angle
							end
						else
							self.orientation.yaw=self.orientation_displayed.yaw
						end
					end
				end
			end
		end		
		
	end
	function class:FaceTowardsTank1()
		local tank=self.scenario.tanks[1]
		--if(self.velocity.x==0 and self.velocity.y==0)then
			local tank=self.scenario.tanks[1]		
			local targetangle=math.atan2(tank.position.y-self.position.y,tank.position.x-self.position.x)
			if(math.abs(XPRACTICE.AngleDifference(targetangle,denathrius.orientation.yaw))>0.01)then
				denathrius.orientation.yaw=targetangle
			end
		--end			
	end
	function class:FaceTowardsTank1Destination()
		local tank=self.scenario.tanks[1]
		local bosscamp=self.scenario.bosscamp
		if(not tank.destx)then self:FaceTowardsTank1() return end
		local targetangle=math.atan2(tank.desty-bosscamp.y,tank.destx-bosscamp.x)
		--print("targetangle:",targetangle)
		if(math.abs(XPRACTICE.AngleDifference(targetangle,denathrius.orientation.yaw))>0.01)then
			--denathrius.orientation.yaw=targetangle
			denathrius.destyaw=targetangle
		end

	end
	
	function class:FaceTowardsSafeAngle(targetangle)
		if(math.abs(XPRACTICE.AngleDifference(targetangle,denathrius.orientation.yaw))>0.01)then
			denathrius.orientation.yaw=targetangle
		end
	end	
end



do
	local super=XPRACTICE.Mob
	XPRACTICE.INDIGNATION.Remornia=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.Remornia

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=2.5
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByCreatureDisplayID(96665)
	end
	function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
		local radius=0.625
		local base=0
		local height=2.7
		displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
	end
	function class:PlayIdleAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.FlyStand)
	end
end
