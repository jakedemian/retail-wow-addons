do

	--TODO NEXT: volatile code reuse -- only use function in multiplayer/messagehandler.lua
	local function IsRealOfficer(unit)
		unit=strsplit("-",unit)
		return ((UnitIsGroupLeader(unit)==true) or (UnitIsGroupAssistant(unit)==true) or not IsInGroup(unit))
	end


	local ids={4035512,4035513,4035514,4035515,4035516,4035517}	--9mw_torghastraid_ring	
	XPRACTICE.FATESCRIBEMULTIPLAYER.BOUNDS={{4,9},{11.5,16.5},{19,24},{26.5,31.5},{34,39},{41.5,46.5}}
	local bounds=XPRACTICE.FATESCRIBEMULTIPLAYER.BOUNDS
	--local indicatorids={4035518,4035519,4035520,4035521,4035522,4035523} --9mw_torghastraid_indicator01
	local indicatorids={4035518,4035518,4035518,4035518,4035518,4035518} --9mw_torghastraid_indicator01
	local indicatordists={9.5,17,24.5,32,39.5,46.5}
	
	XPRACTICE.FATESCRIBEMULTIPLAYER.RINGANIMATIONS={{213,214,215},{216,217,218},{219,220,221},{222,1500,1502},{1504,1506,1508},{1510,1512,1514}}
	local animations=XPRACTICE.FATESCRIBEMULTIPLAYER.RINGANIMATIONS
	
	
	--TODO: is there a mathematical solution to runeangles?
	XPRACTICE.FATESCRIBEMULTIPLAYER.RUNEANGLES={{-1.57,-2.62,-0.56,0.51,1.57,2.61},
						{-2.71,-1.16,2.73,1.94,-1.97,-0.38},
						{-0.16,-0.78,0.46,2.35,-1.40,2.97},
						{-1.24,-0.78,0.57,1.46,2.34,1.91},
						{-1.28,-0.88,0.29,1.09,2.64,1.49},
						{-1.31,-0.61,0.43,1.13,2.52,1.48}}
	local runeangles=XPRACTICE.FATESCRIBEMULTIPLAYER.RUNEANGLES
	-- btw, we accidentally used math.atan2(x,y) instead of math.atan2(y,x) for player position, so those angles will be off
	-- fixing it now...
	for i=1,6 do
		for j=1,6 do
			runeangles[i][j]=XPRACTICE.WrapAngle(math.pi*.5-runeangles[i][j])
		end
	end
	local runedistances={6.61,14.18,20.88,29.07,36.35,43.52}
	
	
	
	for i=1,6 do
		local classname="Ring"..tostring(i)
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER[classname]=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER[classname]
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.bounds=bounds[i]
			self.active=false
			self.ringindex=i
			self.playercount=0	-- real players + ghosts			
			self.realplayercount=0
			self.ghostplayercount=0
			self.indicator=nil	-- the always-visible metal widget attached to the ring
			self.ringindicator=nil	-- the light-up blue target indicator
			self.movementarrow={nil,nil}	
			self.movementarrowvisible={false,false}
			
			self.lastdirection=0
			self.scrambling=false
			self.storedscramblestopangle=0
			self.storedscrambledirection=1
			self.storedscramblering=1
			self.scrambledirection=1
			self.scramblerunetimer=0
			self.scrambleremainingmovement=0
			self.ringindicatorvisible=false
			self.runeindex=1
			self.ringvelocity=0
			self.ringdirection=0
			--self.ringmomentum=0
			self.goaloffsetyaw=0
			self.lineofdeath=nil
			self.lineofdeathactive=false
			
			
		end
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(ids[i])
			self.displayedpositionoffset={x=0,y=0,z=-1}
			self.orientation_displayed.yaw=0-math.pi/2
		end
		
		function class:SetDefaultAnimation()			
			--TODO: rewrite AnimationModule so we don't have to override Idle animation
			self.animationmodule.animations={}
			self.animationmodule.currentanimation=nil
			--self.displayobject.drawable:SetAnimation(animations[i][1])
			--local RUNE=2
			--self.displayobject.drawable:SetAnimation(animations[RUNE][1])
			self.displayobject.drawable:SetAnimation(0)
			-- local test=XPRACTICE.FATESCRIBEMULTIPLAYER.Orb.new()
			-- test:Setup(self.environment)
			-- test.position.x=math.cos(runeangles[i][RUNE])*runedistances[i]
			-- test.position.y=math.sin(runeangles[i][RUNE])*runedistances[i]
			-- test.angle=0
		end

		function class:CreateAssociatedObjects()
			self.rune=XPRACTICE.FATESCRIBEMULTIPLAYER.RingRune.new()
			self.rune:Setup(self.environment)
			for m=1,2 do
				self.movementarrow[m]=XPRACTICE.FATESCRIBEMULTIPLAYER.RingMovementArrow.new()
				self.movementarrow[m]:Setup(self.environment)
			end
			local line=XPRACTICE.LineOfDeath.new()					
			line:Setup(self.environment,0,0,1,0,0,1)
			line.visible=false
			self.lineofdeath=line
			self:RandomizeIndicator() --TODO: less duct tape; trying to prevent potential crash on scenario load
			
			if(XPRACTICE.TOCVersion<90100)then	
				local tempindicator=XPRACTICE.FATESCRIBEMULTIPLAYER.RingRuneTempIndicator.new()
				tempindicator:Setup(self.environment)
				tempindicator.rune=self.rune
			end
			
		
			if(XPRACTICE.TOCVersion<90100)then				
				local tempindicator=XPRACTICE.FATESCRIBEMULTIPLAYER.RingGoalTempIndicator.new()
				tempindicator:Setup(self.environment)
				tempindicator.ring=self
			end
		
		end

		function class:RandomizeIndicator()
			if(self.scrambling or self.ringindicatorvisible)then return -1 end
			if(self.indicator)then
				self.indicator:Die()
			end
			local classname="Indicator"..tostring(i)
			local ind=XPRACTICE.FATESCRIBEMULTIPLAYER[classname].new()
			ind:Setup(self.environment)
			ind.angle=math.random()*math.pi*2
			ind.angle=XPRACTICE.WrapAngle(ind.angle) --
			--ind.angle=math.pi+0.2--!!!
			ind.position.x=math.cos(ind.angle)*indicatordists[i]
			ind.position.y=math.sin(ind.angle)*indicatordists[i]
			ind.orientation_displayed.yaw=ind.angle+math.pi/2			
			self.indicator=ind			
		end

		function class:SetIndicator(angle)
			angle=XPRACTICE.WrapAngle(angle)
			if(self.scrambling or self.ringindicatorvisible)then return -1 end
			if(self.indicator)then
				self.indicator:Die()
			end
			local classname="Indicator"..tostring(i)
			local ind=XPRACTICE.FATESCRIBEMULTIPLAYER[classname].new()
			ind:Setup(self.environment)
			ind.angle=angle
			--ind.angle=math.pi+0.2--!!!
			ind.position.x=math.cos(ind.angle)*indicatordists[i]
			ind.position.y=math.sin(ind.angle)*indicatordists[i]
			ind.orientation_displayed.yaw=ind.angle+math.pi/2			
			self.indicator=ind			
		end
		
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			
			local actualvelocity=0
			
			if(self.scramblerunetimer>0)then
				self.scramblerunetimer=self.scramblerunetimer-elapsed
				if(self.scramblerunetimer<=0)then
					self.scramblerunetimer=0
					-- curiously, these animations don't appear to loop, so we can just call [1] now and [3] later
					--TODO: is that still the case post-PTR?
					self.displayobject.drawable:SetAnimation(animations[self.runeindex][1])
				end
			end
			if(self.scrambling)then
				--self.ringvelocity=self.ringvelocity+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingAcceleration*elapsed*elapsed
				self.ringvelocity=self.ringvelocity+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingAcceleration*elapsed
				if(self.ringvelocity>XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingScrambleSpeed)then self.ringvelocity=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingScrambleSpeed end
				--self.orientation_displayed.yaw=self.orientation_displayed.yaw+self.ringvelocity*elapsed*self.scrambledirection
				--local movement=(self.ringvelocity*elapsed+0.5*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingAcceleration*elapsed*elapsed)
				local movement=(self.ringvelocity*elapsed)
				self.orientation_displayed.yaw=self.orientation_displayed.yaw+self.scrambledirection*movement
				self.orientation_displayed.yaw=XPRACTICE.WrapAngle(self.orientation_displayed.yaw)
				
				self.scrambleremainingmovement=self.scrambleremainingmovement-movement
				if(self.scrambleremainingmovement<=0)then
					self.scrambling=false
					self.scrambleremainingmovement=0
					self.ringvelocity=0
					self:DrawRingIndicator()
					self.goaloffsetyaw=-1*(self.orientation_displayed.yaw-self.indicator.angle+runeangles[self.ringindex][self.runeindex])
					self.goaloffsetyaw=XPRACTICE.WrapAngle(self.goaloffsetyaw)
					if(self.goaloffsetyaw<0)then self.goaloffsetyaw=self.goaloffsetyaw+math.pi*2 end
					-- if(self.ringindex==1)then
						-- print("Offset:",self.goaloffsetyaw)
					-- end
					
					local alldone=true
					for j=1,#self.scenario.rings do
						local ring=self.scenario.rings[j]
						if(ring.scrambling)then alldone=false end					
					end
					if(alldone)then
						for j=1,#self.scenario.rings do
							local ring=self.scenario.rings[j]
							ring.active=true
						end
						--TODO: time limit starts here
					end
				end
				
			elseif(self.active)then
				self.playercount=self.realplayercount+self.ghostplayercount
				local prevsignum=XPRACTICE.signum(self.ringvelocity)
				if(self.playercount>0)then
					if(self.scenario.ringlasers==true)then
						self.lineofdeathactive=true
					else
						self.lineofdeathactive=false
					end
					
					local direction
					--self.ringmomentum=self.ringmomentum+elapsed
					if(self.playercount%2==1)then
						direction=-1
					else
						direction=1
					end
					self.lastdirection=direction
					local prevvelocity=self.ringvelocity
					--self.ringvelocity=self.ringvelocity+direction*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingAcceleration*elapsed*elapsed
					self.ringvelocity=self.ringvelocity+direction*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingAcceleration*elapsed
					local maxvelocity=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MaxRingSpeedDeadZone+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MinRingSpeedDeadZone
					if(math.abs(self.ringvelocity)>maxvelocity)then						
						self.ringvelocity=maxvelocity*XPRACTICE.signum(self.ringvelocity)
						if(math.abs(prevvelocity)<maxvelocity)then
							local signum=true
							if(self.ringvelocity<0)then signum=false end
							self.scenario.multiplayer:FormatAndSendCustom("RINGMAXSPEED",self.ringindex,signum,self.orientation_displayed.yaw,self.goaloffsetyaw)
						end
					end
				else
					self.lineofdeathactive=false					
					--self.ringvelocity=self.ringvelocity-prevsignum*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingDeceleration*elapsed*elapsed	
					self.ringvelocity=self.ringvelocity-prevsignum*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingDeceleration*elapsed
					if(XPRACTICE.signum(self.ringvelocity)~=prevsignum)then 
						self.ringvelocity=0						
					end									
				end
				
				-- send RINGSTOP even if somebody thinks there are still players on the ring
				if(XPRACTICE.signum(self.ringvelocity)~=prevsignum and prevsignum~=0)then 
					--TODO: still doesn't seem to send in all situations
					
					self.scenario.multiplayer:FormatAndSendCustom("RINGSTOP",self.ringindex,self.orientation_displayed.yaw,self.goaloffsetyaw)
					
				end
				
				actualvelocity=(math.abs(self.ringvelocity)-XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MinRingSpeedDeadZone)
				if(actualvelocity<0)then actualvelocity=0 end
				if(actualvelocity>XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingSpeed)then actualvelocity=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingSpeed end
				actualvelocity=actualvelocity*XPRACTICE.signum(self.ringvelocity)
				-- print("Ring:",self.ringvelocity)
				-- print("Actual:",actualvelocity)
				
				if(actualvelocity~=0)then
					self.orientation_displayed.yaw=self.orientation_displayed.yaw+actualvelocity*elapsed
					self.orientation_displayed.yaw=XPRACTICE.WrapAngle(self.orientation_displayed.yaw)
					self.goaloffsetyaw=self.goaloffsetyaw-actualvelocity*elapsed				
				end
				if(self.goaloffsetyaw<=0 or self.goaloffsetyaw>=math.pi*2)then
					self.scenario.multiplayer:FormatAndSendCustom("RINGCLEAR",self.ringindex,self.orientation_displayed.yaw)
					-- self.active=false
					-- self.ringindicator.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2DespawnCustomDuration)
					-- self.ringindicatorvisible=false
					-- self.realplayercount=0
					-- self.ghostplayercount=0
					-- if(self.scenario.playercurrentring==self.ringindex)then self.scenario.playercurrentring=nil end
					-- self.displayobject.drawable:SetAnimation(animations[self.runeindex][3])
					-- self.ringvelocity=0
					-- local success=true
					-- --check if all rings are now inactive
					-- for j=1,#self.scenario.rings do
						-- if(self.scenario.rings[j].active)then success=false end
					-- end
					-- if(success)then
						-- self.scenario.orbspawnercontroller:Deactivate()
						-- local decor=XPRACTICE.FATESCRIBEMULTIPLAYER.DecorRingSuccess.new()
						-- decor:Setup(self.environment)
						-- decor.scenario=self.scenario						
						-- self.scenario.statuslabel:SetText("Phase complete!",3.0)
					-- end
				end
				for m=1,2 do
					if(not self.movementarrowvisible[m])then
						--if(self.active==true and self.ringvelocity~=0 and self.lastdirection~=0)then
						if(self.active==true and (self.playercount~=0 and self.playercount%2==m-1))then
							--if(XPRACTICE.signum(self.ringvelocity)==self.lastdirection)then
								self.movementarrowvisible[m]=true
								self.movementarrow[m].alpha=1
								self.movementarrow[m].animationmodule:PlayAnimation(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.ProjectileSpawnCustomDuration)
							--end
						end
					else
						--if((actualvelocity==0 and XPRACTICE.signum(self.ringvelocity)~=self.lastdirection)
						--if((XPRACTICE.signum(self.ringvelocity)~=self.lastdirection)
						if(false
						--or (actualvelocity==0 and self.playercount==0)
						or(self.playercount==0 or self.playercount%2~=m-1)
						or (not self.active))then		-- reminder that we're nested inside another check for self.active
							self.movementarrowvisible[m]=false
							self.lastdirection=0	--TODO: less duct tape (we're trying to prevent arrow from repeatedly flipping vis/invis)
							self.movementarrow[m].animationmodule:PlayAnimation(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.ProjectileDespawnCustomDuration)
						end						
					end	
				end
			end
			for m=1,2 do
				if(self.movementarrowvisible[m])and (not self.active)then
					self.movementarrowvisible[m]=false
					self.lastdirection=0	--TODO: less duct tape (we're trying to prevent arrow from repeatedly flipping vis/invis)
					self.movementarrow[m].animationmodule:PlayAnimation(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.ProjectileDespawnCustomDuration)			
				end
			end
			
			if(not self.active)then
				self.lineofdeathactive=false
			end

			if(self.rune)then				
				self.rune.position.x=math.cos(self.orientation_displayed.yaw+runeangles[i][self.runeindex])*runedistances[i]
				self.rune.position.y=math.sin(self.orientation_displayed.yaw+runeangles[i][self.runeindex])*runedistances[i]
			end
			for m=1,2 do
				if(self.movementarrow[m] and self.lastdirection~=0 and self.movementarrowvisible[m])then
					local dir
					if(m==1)then dir=1 else dir=-1 end
					local orthogonal=self.orientation_displayed.yaw+runeangles[i][self.runeindex]+dir*math.pi/2
					local offsetdist=2.75
					local offsetx=math.cos(orthogonal)*offsetdist
					local offsety=math.sin(orthogonal)*offsetdist
					
					self.movementarrow[m].position.x=math.cos(self.orientation_displayed.yaw+runeangles[i][self.runeindex])*runedistances[i]+offsetx
					self.movementarrow[m].position.y=math.sin(self.orientation_displayed.yaw+runeangles[i][self.runeindex])*runedistances[i]+offsety
					self.movementarrow[m].position.z=-.5		-- movement arrow floats rather high when pitched, so use negative Z here
					self.movementarrow[m].orientation_displayed.pitch=-math.pi/2
					--TODO: better arrow
					self.movementarrow[m].orientation_displayed.yaw=orthogonal
					----(this doesn't quite work either)
				end
			end
			
			if(self.lineofdeathactive)then				
				self.lineofdeath.visible=true
				local VELOCITYMULTIPLIER=20
				self.lineofdeath.linesegment.x1=math.cos(self.orientation_displayed.yaw+runeangles[i][self.runeindex]+actualvelocity*elapsed*VELOCITYMULTIPLIER)*(.5)
				self.lineofdeath.linesegment.y1=math.sin(self.orientation_displayed.yaw+runeangles[i][self.runeindex]+actualvelocity*elapsed*VELOCITYMULTIPLIER)*(.5)
				self.lineofdeath.linesegment.x2=math.cos(self.orientation_displayed.yaw+runeangles[i][self.runeindex]+actualvelocity*elapsed*VELOCITYMULTIPLIER)*(runedistances[i]-XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathDistanceFromRune)
				self.lineofdeath.linesegment.y2=math.sin(self.orientation_displayed.yaw+runeangles[i][self.runeindex]+actualvelocity*elapsed*VELOCITYMULTIPLIER)*(runedistances[i]-XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathDistanceFromRune)
				self.lineofdeath:SetMissileOrientationAlongLine()
			else
				self.lineofdeath.visible=false
			end
		end
		
		function class:DrawRingIndicator()
			if(self.ringindicator)then
				self.ringindicator:Die()  --REMINDER: always Die instead of Cleanup.  otherwise cleanedup object will still be in environment object list and crash on shutdown.
			end			
			self.ringindicatorvisible=true
			local ri=XPRACTICE.FATESCRIBEMULTIPLAYER.RingIndicator.new()
			ri:Setup(self.environment)			
			ri.angle=self.indicator.angle
			local distoffset=-1.5
			ri.position.x=math.cos(ri.angle)*(indicatordists[i]+distoffset)
			ri.position.y=math.sin(ri.angle)*(indicatordists[i]+distoffset)			
			ri.orientation_displayed.yaw=ri.angle+math.pi
			self.ringindicator=ri
		end
	end
	
	for i=1,6 do
		local classname="Indicator"..tostring(i)
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER[classname]=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER[classname]
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(indicatorids[i])
			self.displayedpositionoffset={x=0,y=0,z=-1}
		end		
	end
	
	-- floor radius:   (runes are smaller)
	-- 0 - 4		center
	-- 4 - 9 		ring1
	-- 9 - 11.5		mid
	-- 11.5 - 16.5	ring2
	-- 16.5 - 19	mid
	-- 19 - 24		ring3
	-- 24 - 26.5	mid
	-- 26.5 - 31.5  ring4
	-- 31.5 - 34	mid
	-- 34 - 39		ring5			rings 5+6 are irregularly-shaped but shouldn't matter for rune collision
	-- 39 - 41.5	mid
	-- 41.5 - 46.5	ring6
	-- 46.5 - 48.5	edge			top of edge.  lower part goes to about 49.5
	
		
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.RingIndicator=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.RingIndicator
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.angle=0
		end			
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4067361)	--9fx_raid2_korrath_fatescribe_ringindicator_state
			self.scale=0.4
			self.displayedpositionoffset={x=0,y=0,z=.1}
		end		
		
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2SpawnCustomDuration)
			self.projectilespawncustomduration=1.0
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end				

	end
	
	do
		local super=XPRACTICE.GameObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.RingRune=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.RingRune
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.bounds=bounds[i]
			self.active=false
			self.playercount=0
		end			
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.RingRuneTempIndicator=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.RingRuneTempIndicator
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1303238)
			self.scale=1			
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.position.x=self.rune.position.x
			self.position.y=self.rune.position.y
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.RingGoalTempIndicator=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.RingGoalTempIndicator		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(352998)
			--actor:SetModelByFileID(1303238)
			self.scale=1			
		end		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.position.x=self.ring.indicator.position.x
			self.position.y=self.ring.indicator.position.y
			
			--print(self.ind.position.x,self.ind.position.y)
		end
	end			

	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RandomizeAllIndicators=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RandomizeAllIndicators
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Randomize indicators)"
			self.icon="interface/icons/ability_druid_typhoon.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			if(scenario.multiplayer.roomlocked)then
				scenario.statuslabel:SetText("Can't adjust goals while encounter is in progress.",3.0)
				return
			end		
			
			local failed=true
			for i=1,#scenario.rings do				
				local result=scenario.rings[i]:RandomizeIndicator()
				--print("Ring",i,result)
				if(result~=-1)then
					failed=false
				end				
			end
			if(failed)then
				scenario.statuslabel:SetText("Can't move goal indicators while rings are active.",3.0)
			end
			
		end
	end	
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateCosmetic=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateCosmetic
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			-- Multiplayer trigger starts the scenario for everyone.
			-- Actual cast effects are handled in multiplayer.lua
			-- This cast just gives him a cast bar and plays and animation			
			self.name="Realign Fate"
			self.icon="interface/icons/ability_vehicle_sonicshockwave.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=3.0
			self.basechannelduration=nil
			self.basechannelticks=nil
			
			self.skipintro=false
			self.fixed=false
		end
		function class:StartCastingEffect(spellinstancepointer)	
		
		end			
		function class:CastingAnimationFunction(spellinstancepointer)				
			spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
		end		
		-- function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			-- local scenario=spellinstancepointer.castercombat.mob.scenario		
			-- --TODO: apply Runic Affinity debuff here
			-- --TODO: maybe only show message if not using quickstart
			-- scenario.statuslabel:SetText("Runic Affinity would be applied NOW-ish.")			
		-- end			
	end
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateTrigger=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateTrigger
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Realign Fate (multiplayer trigger)"
			self.icon="interface/icons/ability_vehicle_sonicshockwave.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			--self.basecastduration=3.0
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
			
			self.skipintro=false
			self.fixed=false
			

		end
				
		function class:StartCastingEffect(spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			
			if(not IsRealOfficer("player"))then
				scenario.statuslabel:SetText("When you are in a group, you must be lead/assist to start the game.",3.0)
				return 
			end
			
			if(scenario.multiplayer.roomlocked)then 
				scenario.statuslabel:SetText("Seems to be a game in progress already.",3.0)
				return 
			end
			
			local args={}
			tinsert(args,self.skipintro)
			for i=1,#scenario.rings do
				--tinsert(args,XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["goalangle"..tostring(i)])			
				tinsert(args,scenario.rings[i].indicator.angle)
			end
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				tinsert(args,ring.orientation_displayed.yaw)
			end
			for i=1,#scenario.rings do
				local dir=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["ringdir"..tostring(i)]
				if(dir==3)then dir=math.floor(math.random()*2+1) end
				tinsert(args,tostring(dir))
			end			
			-- ring.runeindex doesn't get set here in multiplayer, so we need to remember which runes we've chosen
			local temprune={}
			for i=1,#scenario.rings do
				local rune=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["ringrune"..tostring(i)]
				if(rune==7)then rune=math.floor(math.random()*2+1) end
				temprune[i]=rune
				tinsert(args,tostring(rune))
			end	
			for i=1,#scenario.rings do		
				local angle=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["ringangle"..tostring(i)]
				local ring=scenario.rings[i]								
				stopangle=angle-runeangles[ring.ringindex][temprune[ring.ringindex]]
				-- print("Angle",angle)
				-- print("Runeangle",runeangles[ring.ringindex][temprune[ring.ringindex]])
				-- print("Stopangle",stopangle)
				if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customrunes==false)then 
					--angle=math.random()*math.pi*2-math.pi 					
					local targetangle=ring.indicator.angle-runeangles[ring.ringindex][temprune[ring.ringindex]] --goal angle minus rune angle,
																								-- i.e. ring's final yaw when solved
					stopangle=targetangle+XPRACTICE.RandomNumberInBetween(XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingScrambleMinimumDistance,math.pi*2-XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingScrambleMinimumDistance)
																									-- ring's initial yaw after scramble
					if(stopangle<0)then stopangle=stopangle+math.pi*2 end
				end
				tinsert(args,stopangle)
			end			
			tinsert(args,scenario.orbspawnercontroller.angle)
			tinsert(args,scenario.orbspawnercontroller.nextid)
			
			local rings=scenario.rings
			scenario.multiplayer:FormatAndSend("LOCK")
			--scenario.multiplayer:FormatAndSendCustom("PLACEGOALSWITHOUTSAVING",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)
			scenario.multiplayer:FormatAndSendCustom("SCRAMBLE",unpack(args))
		end
	end	
	
	do	
		local super=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateTrigger
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SkipIntroRealignFate=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SkipIntroRealignFate
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.icon="interface/icons/timelesscoin.blp"
			self.skipintro=true
			self.fixed=false
		end
	end
	
	do	
		local super=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateTrigger
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateFixed=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateFixed
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.icon="interface/icons/priest_icon_chakra_red.blp"
			self.skipintro=false
			self.fixed=true
		end
	end	
	do	
		local super=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateTrigger
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SkipIntroRealignFateFixed=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SkipIntroRealignFateFixed
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.icon="interface/icons/timelesscoin_yellow.blp"
			self.skipintro=true
			self.fixed=true
		end
	end		


	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.RingMovementArrow=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.RingMovementArrow
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(2995659)	--8fx_rl_personalresponsibility_arrow_blue
			self.scale=1.5		
			self.despawning=false
			self.alpha=0
		end		
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end	
		function class:OnProjectileDespawning()
			self.despawning=true
		end
		function class:OnProjectileDespawned()
			--don't die!
			self.alpha=0
		end			
	end
	
	
	
	do
		--TODO: move targetalpha to base class
		local super=XPRACTICE.VisibleLine
		XPRACTICE.LineOfDeath=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.LineOfDeath
		
		function class:SetActorAppearanceViaOwner(actor)
			--self.fileid=970786
			self.fileid=166331	--holy_missile_low
			--self.fileid=610625	--priest_divinestar_missile_yellow
			self.particlexoffset=0
			self.particleyoffset=0				
			actor:SetModelByFileID(self.fileid)	
			self.scale=1
		end	
	end
	
	
	do
		local super=XPRACTICE.GameObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.DecorRingSuccess=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.DecorRingSuccess
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.phasetime=0
			self.phase=-6			
		end
		local PHASERATE=0.25
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.phasetime=self.phasetime+elapsed
			if(self.phasetime>=PHASERATE)then
				self.phasetime=self.phasetime-PHASERATE
				self.phase=self.phase+1
				if(self.phase>=1 and self.phase<=6)then
					local ring=self.scenario.rings[self.phase]
					if(ring)then
						ring.displayobject.drawable:SetAnimation(animations[ring.runeindex][3])
					end
				elseif(self.phase>=7)then
					self:Die()
				end
			end
		end			
	end		
	
	
	
	
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRuneInitialPosition=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRuneInitialPosition
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Set rune initial position)"
			self.icon="interface/icons/spell_holy_rune.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				local distx=scenario.player.position.x
				local disty=scenario.player.position.y
				local distsqr=distx*distx+disty*disty
				local dist=math.sqrt(distsqr)		
				local mindist=bounds[ring.ringindex][1]
				local maxdist=bounds[ring.ringindex][2]				
				if(mindist<=dist and dist<=maxdist)then
					success=true
					local varname="ringangle"..tostring(ring.ringindex)
					local angle=math.atan2(scenario.player.position.y,scenario.player.position.x)
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]=angle
					local message="Changed ring #"..tostring(ring.ringindex).." rune's initial position to your current position."
					if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customrunes==false)then
						message=message.."\n(However, you are currently using random rune mode.)"
					end
					scenario.statuslabel:SetText(message,3.0)
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("Stand directly on a ring before trying to adjust it.")
			end
		end
	end		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingScrambleDirection=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingScrambleDirection		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Set ring scramble direction)"
			self.icon="interface/icons/spell_nature_rune.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				local distx=scenario.player.position.x
				local disty=scenario.player.position.y
				local distsqr=distx*distx+disty*disty
				local dist=math.sqrt(distsqr)		
				local mindist=bounds[ring.ringindex][1]
				local maxdist=bounds[ring.ringindex][2]
				
				if(mindist<=dist and dist<=maxdist)then
					success=true
					local varname="ringdir"..tostring(ring.ringindex)
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]+1
					if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]>3)then XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]=1 end
					local dirtxt
					if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]==1)then
						dirtxt="clockwise"
					elseif(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]==2)then
						dirtxt="counterclockwise"
					else
						dirtxt="randomly"
					end
					scenario.statuslabel:SetText("Changed ring #"..tostring(ring.ringindex).." to move "..dirtxt.." while the loom is scrambling.",3.0)
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("Stand directly on a ring before trying to adjust it.")
			end
		end
	end		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingWhichRune=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingWhichRune		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Set ring which rune)"
			self.icon="interface/icons/spell_ice_rune.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				local distx=scenario.player.position.x
				local disty=scenario.player.position.y
				local distsqr=distx*distx+disty*disty
				local dist=math.sqrt(distsqr)		
				local mindist=bounds[ring.ringindex][1]
				local maxdist=bounds[ring.ringindex][2]
				
				if(mindist<=dist and dist<=maxdist)then
					success=true
					local varname="ringrune"..tostring(ring.ringindex)
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]=XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]+1
					if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]>7)then XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]=1 end
					local message
					if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname]<7)then
						message="rune #"..tostring(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[varname])..".  (Does that even make a difference?)"
					else
						message="a random rune."
					end
					scenario.statuslabel:SetText("Changed ring #"..tostring(ring.ringindex).." to activate "..message,3.0)
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("Stand directly on a ring before trying to adjust it.")
			end
		end
	end		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingReset=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetRingReset
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Set ring - reset)"
			--self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
			self.icon="interface/icons/ability_iyyokuk_drum_red.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				local distx=scenario.player.position.x
				local disty=scenario.player.position.y
				local distsqr=distx*distx+disty*disty
				local dist=math.sqrt(distsqr)		
				local mindist=bounds[ring.ringindex][1]
				local maxdist=bounds[ring.ringindex][2]
				
				if(mindist<=dist and dist<=maxdist)then
					success=true
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["ringangle"..tostring(ring.ringindex)]=99
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["ringdir"..tostring(ring.ringindex)]=3
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER["ringrune"..tostring(ring.ringindex)]=7
					
					scenario.statuslabel:SetText("Randomized ring #"..tostring(ring.ringindex)..".",3.0)
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("Stand directly on a ring before trying to adjust it.")
			end
		end		
	end		

	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetIndicator=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SetIndicator
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Set goal indicator)"
			self.icon="interface/icons/inv_checkered_flag.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			if(scenario.multiplayer.roomlocked)then
				scenario.statuslabel:SetText("Can't adjust goals while encounter is in progress.")
				return
			end
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				local distx=scenario.player.position.x
				local disty=scenario.player.position.y
				local distsqr=distx*distx+disty*disty
				local dist=math.sqrt(distsqr)		
				local mindist=bounds[ring.ringindex][1]
				local maxdist=bounds[ring.ringindex][2]
				
				if(mindist<=dist and dist<=maxdist)then
					success=true
					local var="goalangle"..tostring(i)
					local angle=math.atan2(scenario.player.position.y,scenario.player.position.x)
					XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[var]=angle	
					local message="Changed goal #"..tostring(ring.ringindex).." to your current position."
					if(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER.customrunes==false)then
						message=message.."\n(However, you are currently using fixed goal mode.)"
					else						
						ring:SetIndicator(angle)										
						local rings=scenario.rings
						scenario.multiplayer:FormatAndSendCustom("CUSTOMGOALS",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)
					end
					scenario.statuslabel:SetText(message,3.0)
				end
			end
			if(not success)then
				scenario.statuslabel:SetText("To adjust a goal indicator, stand directly on its corresponding ring first.")
			end
		end
	end			
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SaveIndicator=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_SaveIndicator
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Save goal indicators)"
			self.icon="interface/icons/inv_misc_book_16.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false

			local rings=scenario.rings
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				local var="goalangle"..tostring(i)
				XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[var]=ring.indicator.angle						
			end
			scenario.statuslabel:SetText("Recorded current goal positions to addon savedata.",3.0)
		end
	end		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LoadIndicator=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_LoadIndicator
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Load goal indicators)"
			self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			local success=false
			if(scenario.multiplayer.roomlocked)then
				scenario.statuslabel:SetText("Can't adjust goals while encounter is in progress.")
				return
			end
			for i=1,#self.scenario.rings do	
				local var="goalangle"..tostring(i)
				self.scenario.rings[i]:SetIndicator(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[var])				
			end
			local rings=scenario.rings
			scenario.multiplayer:FormatAndSendCustom("CUSTOMGOALS",rings[1].indicator.angle,rings[2].indicator.angle,rings[3].indicator.angle,rings[4].indicator.angle,rings[5].indicator.angle,rings[6].indicator.angle)

			----TODO: only send message when somebody clicked goal button
			--if(not scenario.suppressloadmessage)then
				--scenario.statuslabel:SetText("Loaded goal positions from addon savedata.",3.0)
			--end
		end
	end		
	function XPRACTICE.FATESCRIBEMULTIPLAYER.LoadCustomGoals(scenario)
		for i=1,#scenario.rings do	
			local var="goalangle"..tostring(i)
			scenario.rings[i]:SetIndicator(XPRACTICE_SAVEDATA.FATESCRIBEMULTIPLAYER[var])				
		end
	end
	function XPRACTICE.FATESCRIBEMULTIPLAYER.LoadStandardGoals(scenario)
		scenario.rings[1]:SetIndicator(-1*-0.981031)
		scenario.rings[2]:SetIndicator(-1*2.569171)
		scenario.rings[3]:SetIndicator(-1*-1.548367)
		scenario.rings[4]:SetIndicator(-1*1.059856)
		scenario.rings[5]:SetIndicator(-1*-2.090060)
		scenario.rings[6]:SetIndicator(-1*0.027821)
	end	
end