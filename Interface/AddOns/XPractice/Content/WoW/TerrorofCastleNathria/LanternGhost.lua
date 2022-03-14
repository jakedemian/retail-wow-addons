do
	local super=XPRACTICE.Mob
	XPRACTICE.TERROROFCASTLENATHRIA.LanternGhost=XPRACTICE.inheritsFrom(XPRACTICE.Mob)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.LanternGhost
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.targetghostalpha=1
		self.ghostalpha=0
		self.ghostalphamultiplier=0.25		
		self.thinkingtime=0	--TODO LATER: "thinking reaction time", "thinking cooldown time"
		self.hidingcooldowntime=0	
		self.knockbackcooldowntime=0
		self.lanternholdtime=0
		self.lanternfloortime=0
	end	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)
		self.displayobject.drawable:SetModelByUnit("player")
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		self:ProcessThinking(elapsed)
		if(self.hidingcooldowntime>0)then
			self.hidingcooldowntime=self.hidingcooldowntime-elapsed
			if(self.hidingcooldowntime<=0)then
				self.hidingcooldowntime=0
			end
		end
		-- don't drop lantern for 2 seconds after knockback (unless stacks get too high)
		if(self.position.z>0)then self.knockbackcooldowntime=2.0 end
		if(self.knockbackcooldowntime>0)then
			self.knockbackcooldowntime=self.knockbackcooldowntime-elapsed
			if(self.knockbackcooldowntime<=0)then
				self.knockbackcooldowntime=0
			end
		end

		self.ai.changeorientationtomovementdirection=true		
		
		if(self.ghostalpha>self.targetghostalpha)then
			self.ghostalpha=self.ghostalpha-elapsed*0.5
			if(self.ghostalpha<self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
		end
		if(self.ghostalpha<self.targetghostalpha)then			
			self.ghostalpha=self.ghostalpha+elapsed*0.5
			if(self.ghostalpha>self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
		end	
		self.alpha=self.ghostalpha*self.ghostalphamultiplier		
		
		
		if(self.scenario and self.scenario.player)then
			local player=self.scenario.player
			local lantern=self.scenario.lantern
			if(lantern)then
				local getlantern=false
				if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior>=2)then 
					getlantern=true
				elseif(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior==1)then
					local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_Bloodlight)		
					if(#auras==0)then
						getlantern=true
					else
						local aura=auras[1]
						getlantern=(lantern.carriermob==self)
						if(self.lanternholdtime>=XPRACTICE.Config.Shriekwing.LanternGhostMaxHoldTime and self.hidingcooldowntime<=0 and self.knockbackcooldowntime<=0)then
							getlantern=false
						end
						if(aura.expirytime<player.localtime+(aura.baseduration-XPRACTICE.Config.Shriekwing.LanternGhostMaxFloorTime))then
--						if(self.lanternfloortime>=XPRACTICE.Config.Shriekwing.LanternGhostMaxFloorTime)then
							getlantern=true
						end						
						if(aura.stacks>=XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.BloodlightWarningStacks)then
							getlantern=false
						end						
					end
				end
				if(lantern.carriermob~=self)then	
					self.lanternholdtime=0
				else
					self.lanternholdtime=self.lanternholdtime+elapsed
				end
				if(lantern.carriermob==nil)then	
					self.lanternfloortime=self.lanternfloortime+elapsed					
				else
					self.lanternfloortime=0
				end				
				if(getlantern)then				
					if(lantern.carriermob==nil)then							
						-- move and pick up									
						local distsqr=XPRACTICE.distsqr(lantern.position.x,lantern.position.y,self.position.x,self.position.y)
						if(distsqr>2*2)then
							if(self:Think(XPRACTICE.Config.Shriekwing.LanternGhostReactionTime))then
								self.ai.targetposition={x=lantern.position.x,y=lantern.position.y,z=0}							
							end
						else
							lantern:OnClick(self,self.environment,nil)
							--self.thinkingtime=1.0
						end						
					end
				else
					if(lantern.carriermob==self)then
						self.lanternfloortime=0
						-- drop
						if(self:Think(XPRACTICE.Config.Shriekwing.LanternGhostReactionTime))then
							local x,y
							local pillarpos=XPRACTICE.TERROROFCASTLENATHRIA.Pillar.GetHomePillarPosition()
							local pillarangle=math.atan2(pillarpos.y-self.position.y,pillarpos.x-self.position.x)
							local playerangle=math.atan2(player.position.y-self.position.y,player.position.x-self.position.x)
							local pillarplayerdiff=XPRACTICE.AngleDifference(playerangle,pillarangle)
							local signum=XPRACTICE.signum(pillarplayerdiff)
							local lanternangle=pillarangle+math.pi*0.5*(-signum)
							--local lanternangle=pillarangle+math.pi
							x=self.position.x+5*math.cos(lanternangle)
							y=self.position.y+5*math.sin(lanternangle)
							lantern:DropMe(x,y)
						end
					else
						self.lanternfloortime=self.lanternfloortime+elapsed
					end
				end
				
				local busy=((getlantern and lantern.carriermob==nil) or (getlantern==false and lantern.carriermob==self))
				if(not busy)then
					local pillarpos=XPRACTICE.TERROROFCASTLENATHRIA.Pillar.GetHomePillarPosition()
					local shriekwing=self.scenario.shriekwing
					--local shriekwing=player	--for debug purposes only\

					local angle=math.atan2(pillarpos.y-shriekwing.position.y,pillarpos.x-shriekwing.position.x)
					local mindistance,maxdistance
					if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior==1 or XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.LanternGhostBehavior==3)then
						maxdistance=11
						mindistance=10 
					else
						maxdistance=22
						mindistance=21 
					end
					
					
					--the intended effect is to set cooldown timer whenever we're moving,
					-- but then ignore it until we're standing still again.
					if(self.ai.targetradial~=nil)then
						self.hidingcooldowntime=2.0
					end
					if(self.ai.targetradial or self.hidingcooldowntime<=0)then						
						self.ai.targetradial={x=pillarpos.x,y=pillarpos.y,angle=angle,mindistance=mindistance,maxdistance=maxdistance}
						--self.ai:SetTargetRadial(pillarpos.x,pillarpos.y,angle,mindistance,maxdistance)
					end
					--print(self.hidingcooldowntime)
				end
			end
		end
	end
	
	--TODO: move to mob or ai?	
	function class:ProcessThinking(elapsed)				
		if(self.thinkingtime>0)then
			self.thinkingtime=self.thinkingtime-elapsed
			if(self.thinkingtime<0)then 
				self.thinkingtime=0
				self.donethinkingthisframe=true
			else
				self.donethinkingthisframe=false
			end
		else
			self.donethinkingthisframe=false
		end

		--print(self.thinkingtime,self.donethinkingthisframe,self.cooldowntime)
		--print(self.ai.targetradial)
	end
	--TODO: unintended effects if we call Think(small number) followed by Think(large number)
	function class:Think(reactiontime)
		if(self.donethinkingthisframe)then
			self.donethinkingthisframe=false
			return true
		else
			if(reactiontime)then
				if(self.thinkingtime==0)then
					self.thinkingtime=reactiontime
				end
			end
		end
		return false
	end	


end