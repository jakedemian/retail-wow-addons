do
	--TODO: volatile code reuse -- only use function in multiplayer/messagehandler.lua
	local function IsRealOfficer(unit)
		unit=strsplit("-",unit)
		return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
	end

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.PAINSMITH.Spell_StartEncounter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Spell_StartEncounter
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Start)"
			self.icon="interface/icons/spell_warlock_darkregeneration.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			
			if(not IsRealOfficer("player"))then
				scenario.statuslabel:SetText("When you are in a group, you must be lead/assist to start the game.",3.0)
				return 
			end
			
			if(scenario.multiplayer.roomlocked)then 
				scenario.statuslabel:SetText("Seems to be a game in progress already.",3.0)
				return 
			end
			
			local args={7,7,7,7,7,7,7,7,7}
			local possibleargs={{7,1,10,3,6,7,2,8,2},
								{8,13,3,11,8,7,13,4,12},
								{8,13,3,11,8,7,11,7,1},
								{9,1,11,3,6,7,12,2,13},
								{8,1,11,4,7,7,11,8,2},
								{8,12,2,10,7,7,13,4,13},
								{7,12,2,9,6,7,3,6,12},
								{9,13,4,12,9,7,2,11,1},
								{7,2,12,5,7,7,11,7,2},
								{9,12,3,10,7,7,1,10,2}
								}
			local i=math.floor(math.random()*(#possibleargs))+1
			if(i<1)then i=1 end
			if(i>#possibleargs)then i=#possibleargs end
			
			local argbytes=possibleargs[i]

			for j=1,9 do
				--print("argbytesj:",argbytes[j],i,j)
				args[j]=string.char(argbytes[j])
			end			
			scenario.multiplayer:FormatAndSend("LOCK")
			scenario.multiplayer:FormatAndSendCustom("SAFESPOTS",unpack(args))
		end
	end	

	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.PAINSMITH.Scheduler=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Scheduler
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.spiketimer=0
			self.active=false
			self.spikefrequency=5.0
			self.active=false
			self.spikecount=0
			self.spikepattern={7,7,7,7,7,7,7,7,7}
			--self.spikepattern={1,3,11,5,-1,7,4,13,2}
		end
		
		function class:Activate()
			self.active=true
			self.spiketimer=0
			self.spikecount=0
		end
		
		function class:Deactivate()
			self.active=false
			
		end	
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(self.active)then
				self.spiketimer=self.spiketimer-elapsed
				if(self.spiketimer<=0)then				
					self.spikecount=self.spikecount+1
					self.spiketimer=self.spiketimer+self.spikefrequency

					if(self.spikecount<=9)then
						local spikesrow=XPRACTICE.PAINSMITH.SpikesRow.new()
						spikesrow:Setup(self.environment)
						spikesrow.safespot=self.spikepattern[self.spikecount]
						spikesrow.scenario=self.scenario
						tinsert(self.scenario.spikesrows,spikesrow)
						for i=1,5 do
							local x=math.floor(math.random()*13)+1.5
							local y=math.floor(math.random()*13)+1.5
							local swirl=XPRACTICE.PAINSMITH.Swirl.new()
							swirl.scenario=self.scenario
							swirl:Setup(self.environment,x*XPRACTICE.PAINSMITH.Config.ArenaTileSize,y*XPRACTICE.PAINSMITH.Config.ArenaTileSize)
						end
					end

					for k,v in pairs(self.scenario.multiplayer.allplayers)do
						local player=v
						if(not player:IsDeadInGame())then
							local x,y=player.position.x,player.position.y
							if(player~=self.scenario.player)then
								if(player.velocity.x~=0 or player.velocity.y~=0)then
									x=player.position.x+player.velocity.x*XPRACTICE.PAINSMITH.Config.PhaseTimeLagEstimate
									y=player.position.y+player.velocity.y*XPRACTICE.PAINSMITH.Config.PhaseTimeLagEstimate
								end
							end
							local x2,y2=XPRACTICE.RandomPointInCircle(player.position.x,player.position.y,1)
							local swirl=XPRACTICE.PAINSMITH.Swirl.new()
							swirl.scenario=self.scenario
							swirl:Setup(self.environment,x2,y2)
							--TODO: final swirls spawn adds
							if(self.spikecount==10)then
								swirl.adds=true
							end
						end
					end
					
					if(self.spikecount==2)then
						--spikedballs right to left
						for i=1,13,2 do
							local ball=XPRACTICE.PAINSMITH.SpikedBallTelegraph.new()
							ball.scenario=self.scenario
							ball.direction=-1						
							ball:Setup(self.environment,13.5*XPRACTICE.PAINSMITH.Config.ArenaTileSize,(i+0.5)*XPRACTICE.PAINSMITH.Config.ArenaTileSize)
						end					
					elseif(self.spikecount==6)then
						--spikedballs left to right
						for i=1,13,2 do
							local ball=XPRACTICE.PAINSMITH.SpikedBallTelegraph.new()
							ball.scenario=self.scenario
							ball.direction=1
							ball:Setup(self.environment,1.5*XPRACTICE.PAINSMITH.Config.ArenaTileSize,(i+0.5)*XPRACTICE.PAINSMITH.Config.ArenaTileSize)
						end					
					elseif(self.spikecount==9)then
						self.scenario.statuslabel:SetText("Adds soon!",3.0)
					elseif(self.spikecount==10)then
						self:Deactivate()
						local scenario=self.scenario
						scenario.statuslabel:SetText("Phase complete!",3.0)
						if(scenario.multiplayer.host)then
							scenario.multiplayer.Send.UNLOCK(scenario.multiplayer)
						end
					end
				end
			end
		end
	end
end