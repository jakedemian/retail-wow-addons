do
	--TODO: generic collision base class?
	XPRACTICE.FATESCRIBEMULTIPLAYER.Collision = {}
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Collision
	class.__index = class

	function class.new(scenario)
		local self=setmetatable({}, class)
		self.scenario=scenario
		return self 
	end

	function class:OutOfBoundsCheck()
		local scenario=self.scenario
		for k,v in pairs(scenario.multiplayer.allplayers) do
			local player=v
			if(player==scenario.player or player.position.z>0)then
				local distsqr=player.position.x*player.position.x+player.position.y*player.position.y
				local dist=math.sqrt(distsqr)
				local maxradius=60
				if(dist>maxradius)then
					local unitvectorx=player.position.x/dist
					local unitvectory=player.position.y/dist
					
					player.position.x=unitvectorx*maxradius
					player.position.y=unitvectory*maxradius
				end
			end
		end
	end
	
	
	
	function class:RingRuneCheck()
		local scenario=self.scenario
		local player=scenario.player
		if(player:IsDeadInGame())then
			if(scenario.playercurrentring)then
				scenario.multiplayer:FormatAndSendCustom("OFFRING",tostring(scenario.playercurrentring))
				scenario.playercurrentring=nil
			end
		else
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				if(ring.active and ring.rune)then
					local distx=ring.rune.position.x-scenario.player.position.x
					local disty=ring.rune.position.y-scenario.player.position.y				
					local distsqr=distx*distx+disty*disty
					if(distsqr<=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingRuneHitboxRadius*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingRuneHitboxRadius and not player:IsDeadInGame())then
						if(scenario.playercurrentring==nil)then
							scenario.multiplayer:FormatAndSendCustom("ONRING",tostring(ring.ringindex))
							scenario.playercurrentring=ring.ringindex
						end
						--ring.orientation_displayed.yaw=ring.orientation_displayed.yaw-XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingSpeed*elapsed
						--ring.playercount=1 --!!!
						--ring.playercount=1+ring.ghostplayercount --!!!
					else					--!!!
						if(ring.ringindex==scenario.playercurrentring)then
							scenario.multiplayer:FormatAndSendCustom("OFFRING",tostring(scenario.playercurrentring))
							scenario.playercurrentring=nil
						end
						--ring.playercount=0 --!!!
						--ring.playercount=0+ring.ghostplayercount --!!!
					end
				end
			end
		end
	end
	
	function class:LineOfDeathCheck()
		local scenario=self.scenario
		local player=scenario.player
		if(not player:IsDeadInGame())then
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
			if(#auras>0)then return end
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff)
			if(#auras>0)then return end
			for i=1,#scenario.rings do
				local ring=scenario.rings[i]
				if(ring.lineofdeathactive)then				
					if(XPRACTICE.LineCircleCollision(ring.lineofdeath.linesegment.x1,ring.lineofdeath.linesegment.y1,ring.lineofdeath.linesegment.x2,ring.lineofdeath.linesegment.y2,
					player.position.x,player.position.y,XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathHitbox))then
						local distx=ring.rune.position.x-scenario.player.position.x
						local disty=ring.rune.position.y-scenario.player.position.y				
						local distsqr=distx*distx+disty*disty
						if(distsqr>XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathRingRuneTolerance)then							
							scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff,scenario.boss.combatmodule,player.environment.localtime)			
						end
					end
				end
			end
		end
	end
	
	function class:SpawnerCollisionCheck()
		local scenario=self.scenario
		local player=scenario.player
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
		if(#auras>0)then return end
		if(not player:IsDeadInGame())then
			local controller=scenario.orbspawnercontroller
			if(not controller.active)then return end
			if(scenario.player.environment.localtime<=controller.graceperiodendtime)then return end
			for i=1,#controller.spawners do
				local spawner=controller.spawners[i]
				local distx=spawner.position.x-player.position.x
				local disty=spawner.position.y-player.position.y				
				local distsqr=distx*distx+disty*disty
				if(distsqr<=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerHitboxRadius*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerHitboxRadius)then
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
					scenario.statuslabel:SetText("Died from a Fate Fragment spawner.",3.0)
					scenario.multiplayer:FormatAndSendCustom("DEAD_ORBSPAWNER")
				end
			end
		end
	
	end
	
	
	function class:OrbCollisionCheck()
		local scenario=self.scenario
		local player=scenario.player
		if(not player:IsDeadInGame())then
			for i=1,#scenario.orbs do
				local orb=scenario.orbs[i]
				if(not orb.dying and not orb.dead and not orb.despawning)then
					if(scenario.player.environment.localtime>orb.graceperiodendtime)then					
						local distx=orb.position.x-player.position.x
						local disty=orb.position.y-player.position.y				
						local distsqr=distx*distx+disty*disty
						if(distsqr<=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbHitboxRadius*XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbHitboxRadius)then
							orb.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2DespawnCustomDuration)
							scenario.orbhits=scenario.orbhits+1				
							local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
							if(#auras>0)then
								local id=orb.id or 1
								scenario.multiplayer:FormatAndSendCustom("HIT_ORB",orb.id,string.char(1))
							else
								--orb.graceperiodendtime=player.environment.localtime+XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbGracePeriod
								local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate)
								if(#auras==0)then
									scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_FragmentedFate,scenario.boss.combatmodule,player.environment.localtime)
									scenario.statuslabel:SetText("Hit by a Fate Fragment.",3.0)
									local id=orb.id or 1
									scenario.multiplayer:FormatAndSendCustom("HIT_ORB",orb.id,string.char(2))
								else
									--auras[1].expirytime=player.environment.localtime+auras[1].baseduration
									local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)	
									scenario.statuslabel:SetText("Died from two Fate Fragments in a row.",3.0)
									local id=orb.id or 1
									scenario.multiplayer:FormatAndSendCustom("HIT_ORB",orb.id,string.char(3))
									--print("?",auras[1].expirytime)
								end
							end
						end
					end
				end
			end
		end
	end

end