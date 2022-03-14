do
	--TODO: generic collision base class?
	XPRACTICE.INDIGNATION.Collision = {}
	local class=XPRACTICE.INDIGNATION.Collision
	class.__index = class

	function class.new(scenario)
		local self=setmetatable({}, class)
		self.scenario=scenario
		return self 
	end
		
	function class:CheckMirrors()
		local scenario=self.scenario
		local mirrorok=false
		if(scenario.mirrorsactive)then
			if(scenario.player.position.x<-87 or scenario.player.position.x>87)then
				if(scenario.player.position.y>=-9 and scenario.player.position.y<=9)then
					scenario.player.position.x=-80*XPRACTICE.signum(scenario.player.position.x)				
					scenario.player.position.y=0
					scenario.player.orientation_displayed.yaw=math.pi*(1+XPRACTICE.signum(scenario.player.position.x))/2	--signum is different now from what it was a moment ago
					mirrorok=true
				end
			end
			if(scenario.player.position.y<-93 or scenario.player.position.y>93)then
				if(scenario.player.position.x>=-9 and scenario.player.position.x<=9)then
					scenario.player.position.y=-85*XPRACTICE.signum(scenario.player.position.y)				
					scenario.player.position.x=0
					scenario.player.orientation_displayed.yaw=math.pi/2+math.pi*(1+XPRACTICE.signum(scenario.player.position.y))/2	--signum is different now from what it was a moment ago
					mirrorok=true
				end
			end		
			if(mirrorok)then
				scenario.player.orientation.yaw=scenario.player.orientation_displayed.yaw
				scenario.game.environment_gameplay.cameramanager.camera.orientation.yaw=scenario.player.orientation_displayed.yaw
				scenario.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.49
				scenario.game.environment_gameplay.cameramanager.camera.cdist=40
				if(scenario.currentphase==3)then
					scenario.player.mirrorrealm=not scenario.player.mirrorrealm		
					if(scenario.player.mirrorrealm)then
						scenario:SetMirrorLights()
					else
						scenario:SetNormalLights()
					end
				end
			end
			
			for i=1,#scenario.allplayers do
				local ghost=scenario.allplayers[i]
				if(ghost.cpu)then
					if(ghost.position.x<-87)then
						--TODO: set AI new target position
						ghost.position.x=-80*XPRACTICE.signum(ghost.position.x)				
						ghost.position.y=0
						ghost.orientation_displayed.yaw=math.pi*(1+XPRACTICE.signum(ghost.position.x))/2	--signum is different now from what it was a moment ago
						if(scenario.currentphase==3)then
							ghost.mirrorrealm=true
							ghost:ApproachPoint(0,0,3.2,4.8,true)
							if(math.random()<0.3)then							
								ghost.remainingrolltime=math.random()*6.0+1.0
							end
							if(ghost==self.scenario.tanks[1])then									
								scenario.tanks[1].remainingrolltime=math.random()*1.0+0.2																
								--tank needs to double roll since we don't have charge or leap implemented
								local event={}
								event.time=self.scenario.game.environment_gameplay.localtime+2.5
								event.func=function(scenario)
										scenario.tanks[1].remainingrolltime=0.25
									end
								tinsert(self.scenario.events,event)					
							end						
						end
					end
				end
			end
	
		end
	end


	function class:EdgelineCheck(yoffset)
		--TODO: optimize?
		local ok=false
		local x=self.scenario.player.position.x
		local y=self.scenario.player.position.y+yoffset
		local OOB=-110
		for i=1,#self.scenario.edgelines do
			local flip=false
			local line=self.scenario.edgelines[i]			
			--TODO: dedicated hz line / line intersection function?
			--expect y1 always <= y2
			if(line.y1<y and y<line.y2)then	
				if(line.x1==line.x2)then
					if(x>line2.x1)then flip=true end
				else
					local targetx=line.x1+(line.x2-line.x1)*(y-line.y1)/(line.y2-line.y1)
					if(x>targetx)then flip=true end
				end
			end
			if(flip)then
				ok=not ok
			end			
		end	
		return ok
	end

	function class:OutOfBoundsCheck()
		local scenario=self.scenario
		local distsqr=scenario.player.position.x*scenario.player.position.x+scenario.player.position.y*scenario.player.position.y
		local dist=math.sqrt(distsqr)
		local maxradius=99
		if(dist>maxradius)then
			local unitvectorx=scenario.player.position.x/dist
			local unitvectory=scenario.player.position.y/dist
			
			scenario.player.position.x=unitvectorx*maxradius
			scenario.player.position.y=unitvectory*maxradius
		end
		if(scenario.player.position.z<-10)then
			scenario:AttemptKillPlayer(1,"You fell off the arena.",false)
			--kill player BEFORE resetting position! otherwise final-surprise sequence will fail
			scenario.player.position.x=0
			scenario.player.position.y=0
			scenario.player.position.z=2
			scenario.player.velocity.x=0
			scenario.player.velocity.y=0
			scenario.player.velocity.z=0
			scenario.player.floorbelow=true			
		end

	end

	function class:DesolationCheck(elapsed)
		if(self.scenario.hitbysurprisefinalattack)then return end
		local ok=true
		local redtype=1
		local scenario=self.scenario
		if(scenario.currentphase==3 and not scenario.mirrorsactive)then
			local distx=scenario.player.position.x
			local disty=scenario.player.position.y
			local distsqr=distx*distx+disty*disty
			if(distsqr>=48*48)then
				ok=false
				redtype=1
			end	
		end
		if(scenario.ravagecount==3)then
			ok=false
			redtype=2
		else
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==1)then
				if(scenario.ravagecount>0)then			
					local angle=math.atan2(scenario.player.position.y,scenario.player.position.x)				
					if(angle<0)then angle=angle+math.pi*2 end
					local minsafeangle,maxsafeangle
					maxsafeangle=math.pi*2-math.pi*1/3				
					if(scenario.ravagecount==1)then
						minsafeangle=maxsafeangle-math.pi*4/3
					else
						minsafeangle=maxsafeangle-math.pi*2/3
					end
					--print("angle:",minsafeangle,angle,maxsafeangle)
					if(minsafeangle<angle and angle<maxsafeangle)then
						-- do nothing
					else
						ok=false
						redtype=2
					end
				end
			elseif(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				if(scenario.ravagecount>0)then			
					local angle=math.atan2(scenario.player.position.y,scenario.player.position.x)				
					if(angle<0)then angle=angle+math.pi*2 end
					local minsafeangle,maxsafeangle
					maxsafeangle=math.pi*2-math.pi/6-math.pi*1/3				
					if(scenario.ravagecount==1)then
						minsafeangle=maxsafeangle-math.pi*4/3
					else
						minsafeangle=maxsafeangle-math.pi*2/3
					end
					--print("angle:",minsafeangle,angle,maxsafeangle)
					if(minsafeangle<angle and angle<maxsafeangle)then
						-- do nothing
					else
						ok=false
						redtype=2
					end
				end
			end
		end
	
		if(ok)then
			if(scenario.desolationtimer>0)then
				scenario.desolationtimer=scenario.desolationtimer-elapsed*0.5
				if(scenario.desolationtimer<0)then scenario.desolationtimer=0 end
			end
		else
			scenario.desolationtimer=scenario.desolationtimer+elapsed
			if(scenario.desolationtimer>=XPRACTICE.Config.Indignation.DesolationTolerance)then
				if(redtype==1)then
					scenario:AttemptKillPlayer(1,"You died from standing in Indignation.",true)
				else
					scenario:AttemptKillPlayer(1,"You died from standing in Desolation.",true)
				end
			end
		end
	end

	function class:RavageAngleCheck()
		local scenario=self.scenario
		if(scenario.ravagecount<=0)then return false end
		local distx=scenario.player.position.x
		local disty=scenario.player.position.y		
		local angle=math.atan2(disty,distx)
		if(angle<0)then angle=angle+math.pi*2 end
		if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==1)then
			if(scenario.ravagecount==1)then
				local minsafeangle=0+math.pi/3
				local maxsafeangle=math.pi*2-0-math.pi/3
				if(minsafeangle<angle and angle<maxsafeangle)then
					return false
				else
					return true
				end
			elseif(scenario.ravagecount==2)then
				local mindangerangle=0+math.pi/3
				local maxdangerangle=mindangerangle+math.pi*(2/3)
				if(angle<mindangerangle or angle>maxdangerangle)then
					return false
				else
					return true
				end
			elseif(scenario.ravagecount==3)then
				local mindangerangle=0+math.pi/3+math.pi*(2/3)
				local maxdangerangle=mindangerangle+math.pi*(2/3)
				if(angle<mindangerangle or angle>maxdangerangle)then
					return false
				else
					return true
				end		
			else
				return false
			end			
		
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
			if(scenario.ravagecount==1)then
				local minsafeangle=-math.pi/6+math.pi/3
				local maxsafeangle=math.pi*2-math.pi/6-math.pi/3
				if(minsafeangle<angle and angle<maxsafeangle)then
					return false
				else
					return true
				end
			elseif(scenario.ravagecount==2)then
				local mindangerangle=-math.pi/6+math.pi/3
				local maxdangerangle=mindangerangle+math.pi*(2/3)
				if(angle<mindangerangle or angle>maxdangerangle)then
					return false
				else
					return true
				end
			elseif(scenario.ravagecount==3)then
				local mindangerangle=-math.pi/6+math.pi/3+math.pi*(2/3)
				local maxdangerangle=mindangerangle+math.pi*(2/3)
				if(angle<mindangerangle or angle>maxdangerangle)then
					return false
				else
					return true
				end		
			else
				return false
			end	
		end
	end
	
	function class:CheckPlayerFFCleaveGhosts(telegraph)
		local scenario=self.scenario		
		local player=self.scenario.player
		for i=1,20 do
			local ghost=scenario.allplayers[i]
			local distx=player.position.x-ghost.position.x
			local disty=player.position.y-ghost.position.y
			local distsqr=distx*distx+disty*disty
			if(distsqr<=9*9)then
				scenario:AttemptKillPlayer(2,"You clipped another player with Fatal Finesse.",false)
			end
		end
	end
	function class:CheckGhostsFFCleavePlayer(telegraph)
		local scenario=self.scenario
		local player=self.scenario.player
		local distx=player.position.x-telegraph.position.x
		local disty=player.position.y-telegraph.position.y
		local distsqr=distx*distx+disty*disty
		if(distsqr<=9*9)then
			--delay very slightly so that if player also clips a ghost at the same time, the cause of death will be listed as player clip
			local event={}		
			event.time=self.scenario.game.environment_gameplay.localtime+0.1
			event.func=function(scenario)
					scenario:AttemptKillPlayer(1,"You died from another player's Fatal Finesse.",false)
				end
			tinsert(self.scenario.events,event)
		end
	end	
	
	function class:CheckPlayerNearFFCamp()
		local scenario=self.scenario
		if(scenario.fatalfinessecount>=7)then return end
		
		local player=self.scenario.player
		local destx,desty
		local tolerance
		local message
		if(player.FFpartner)then
			destx=player.FFpartner.position.x
			desty=player.FFpartner.position.y
			--tolerance=19
			tolerance=XPRACTICE.Config.Indignation.FatalFinessePairTolerance
			message="You dropped your Fatal Finesse too far from the other player."
		else
			--tolerance=30
			--tolerance=20
			tolerance=XPRACTICE.Config.Indignation.FatalFinesseSoloTolerance
			if(not XPRACTICE_SAVEDATA.INDIGNATION.hintarrow)then
				tolerance=XPRACTICE.Config.Indignation.FatalFinesseSoloToleranceNoHints
			end
			message="You dropped your Fatal Finesse in the wrong place."
			if(player.mirrorrealm)then
				destx=scenario.ffmirrorcamp[1].x
				desty=scenario.ffmirrorcamp[1].y
			else
				destx=scenario.ffrangedcamp[1].x
				desty=scenario.ffrangedcamp[1].y			
			end
		end
		local distx=player.position.x-destx
		local disty=player.position.y-desty
		local distsqr=distx*distx+disty*disty
		if(distsqr>tolerance*tolerance)then
			scenario:AttemptKillPlayer(2,message,false)
		end
	end

	function class:NeutralizeCheck()
		--local RADIUS=2.5
		local RADIUS=XPRACTICE.Config.Indignation.NeutralizeRadius
		local scenario=self.scenario
		local player=self.scenario.player
		for i=1,20 do
			local ghost=scenario.allplayers[i]
			if(ghost.mirrorrealm~=player.mirrorrealm)then
				local distx=player.position.x-ghost.position.x
				local disty=player.position.y-ghost.position.y
				local distsqr=distx*distx+disty*disty
				if(distsqr<=RADIUS*RADIUS)then
					scenario:AttemptKillPlayer(1,"You died from Neutralize.",true)
				end
			end
		end
	end
	
	function class:RavageBaitCheck()
		local scenario=self.scenario
		local player=self.scenario.player
		if(scenario.ravagecount==0)then			
			local safeangle=0
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				safeangle=-math.pi/6+math.pi*2
			end
			-- local playerangle=math.atan2(player.position.x,player.position.y)
			-- if(playerangle<0)then playerangle=playerangle+math.pi*2
			local x1=10*math.cos(safeangle)
			local y1=10*math.sin(safeangle)
			local x2=40*math.cos(safeangle)
			local y2=40*math.sin(safeangle)
			local TOLERANCE
			--if(player.mirrorrealm)then TOLERANCE=1.5 else TOLERANCE=3 end
			if(player.mirrorrealm)then TOLERANCE=5 else TOLERANCE=10 end
			if(not XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,TOLERANCE))then
				scenario:AttemptKillPlayer(2,"You were too far away from the Ravage bait group.",false)
			end
		elseif(scenario.ravagecount==1)then
			-- probably just check player is near bait groups, angle doesn't seem to matter here
			local baitcamp
			-- for now, use hardcoded numbers
			-- because camps are already updated to next position before we check collision
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==1)then
				if(player.mirrorrealm)then 
					--baitcamp={x=-10.91,y=12.25}
					--baitcamp={x=-2.73,y=10.38}
					baitcamp={x=-6.34,y=5.78}
				else
					baitcamp={x=-31.60,y=5.0}
				end			
			elseif(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				if(player.mirrorrealm)then 
					baitcamp={x=-2.73,y=10.38}
				else
					baitcamp=XPRACTICE.INDIGNATION.Layout.ConvertScreenshotCoords(9337.09 , -1883.47)
				end
			end
			--print("bait",baitcamp,baitcamp.x,baitcamp.y)
			local distx=player.position.x-baitcamp.x
			local disty=player.position.y-baitcamp.y
			local distsqr=distx*distx+disty*disty			
			if(distsqr>10*10)then				
				scenario:AttemptKillPlayer(2,"You were too far away from the Ravage bait group.",false)
			end
		end
	end

end