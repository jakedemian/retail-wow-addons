do
	--TODO: generic collision base class?
	XPRACTICE.KELTHUZADMULTIPLAYER.Collision = {}
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.Collision
	class.__index = class

	function class.new(scenario)
		local self=setmetatable({}, class)
		self.scenario=scenario
		return self 
	end


	function class:OutOfBoundsCheck()
		local scenario=self.scenario
		if(not scenario.player)then return end
		if(scenario.player.inphase)then
			if(scenario.player.position.z<-5)then
				--scenario:AttemptKillPlayer(1,"You fell off the arena.",false)
				-- scenario.player.position.x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3
				-- scenario.player.position.y=0
				-- scenario.player.position.z=2
				-- scenario.player.velocity.x=0
				-- scenario.player.velocity.y=0
				-- scenario.player.velocity.z=0
				-- scenario.player:FreezeOrientation(0)
				-- scenario.game.environment_gameplay.cameramanager.camera.orientation.yaw=scenario.player.orientation.yaw
				-- scenario.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05	
				-- scenario.player.floorbelow=true	
				if(not scenario.player:IsDeadInGame())then
					-- pally bubble can't save you here
					local aura=scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.player.combatmodule,scenario.player.environment.localtime)
					scenario.statuslabel:SetText("Fell off the arena.",3.0)
					scenario.multiplayer:FormatAndSendCustom("DEAD_RINGOUT")
					local player=scenario.player
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced,player.combatmodule,player.environment.localtime)
					aura.scenario=scenario;aura.actiontick=2	--immediate phase change on ringout?
				end
			end
		else		
			local y=scenario.player.position.y-XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset+20
			local distsqr=scenario.player.position.x*scenario.player.position.x+y*y
			local dist=math.sqrt(distsqr)
			local maxradius=20
			if(dist>maxradius)then
				local unitvectorx=scenario.player.position.x/dist
				local unitvectory=y/dist			
				scenario.player.position.x=unitvectorx*maxradius
				scenario.player.position.y=unitvectory*maxradius+XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-20				
				scenario.player.position.y=unitvectory*maxradius+XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-20
			end
		end
		
		-- for k,v in pairs(scenario.multiplayer.allplayers)do
			-- local player=v
			-- if(player~=scenario.player)then
				-- if(player.position.z<-10)then
					-- player.position.x=-XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius+3
					-- player.position.y=0
					-- player.position.z=2
				-- end
			-- end
		-- end
		
	end
	
	function class:ChangePhaseButtonCheck()
		local scenario=self.scenario
		local player=self.scenario.player
		if(not player)then return end
		if(player:IsDeadInGame())then
			scenario.changephasebutton.targetalpha=0
			scenario.changephasebutton.displayobject.drawable:EnableMouse(false)
			return
		end
		if(#player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhase)>0)then
			scenario.changephasebutton.targetalpha=0
			scenario.changephasebutton.displayobject.drawable:EnableMouse(false)
			return
		end
		if(scenario.player.inphase)then
			local ok=false
			if(true)then		-- OK, so technically you can leave at any time but on heroic/mythic you get locked out after you do so.
			--if(not scenario.exitportallocked)then			
				local xdist=scenario.player.position.x-scenario.exitportal.position.x
				local ydist=scenario.player.position.y-scenario.exitportal.position.y
				local distsqr=xdist*xdist+ydist*ydist
				local dist=math.sqrt(distsqr)
				local maxradius=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ExitPortalTriggerRadius
				if(dist<=maxradius)then
					ok=true
				end
			end
			if(not ok)then
				scenario.changephasebutton.targetalpha=0
				scenario.changephasebutton.displayobject.drawable:EnableMouse(false)				
			else
				scenario.changephasebutton.targetalpha=1
				scenario.changephasebutton.displayobject.drawable:EnableMouse(true)			
			end

		else
			local y=scenario.player.position.y-XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset-XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerYOffset
			local distsqr=scenario.player.position.x*scenario.player.position.x+y*y
			local dist=math.sqrt(distsqr)
			local maxradius=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerRadius
			if(dist>maxradius)then
				scenario.changephasebutton.targetalpha=0
				scenario.changephasebutton.displayobject.drawable:EnableMouse(false)				
			else
				scenario.changephasebutton.targetalpha=1
				scenario.changephasebutton.displayobject.drawable:EnableMouse(true)			
			end
		end

	end
	

	function class:EdgeCheck(player)
		local scenario=self.scenario
		if(not scenario.player)then return true end
		if(player~=scenario.player and player.z==0)then return true end
		if(player.inphase)then
			local distsqr=player.position.x*player.position.x+player.position.y*player.position.y
			local dist=math.sqrt(distsqr)
			local maxradius=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius
			if(dist>maxradius)then
				--local unitvectorx=scenario.player.position.x/dist
				--local unitvectory=scenario.player.position.y/dist			
				--scenario.player.position.x=unitvectorx*maxradius
				--scenario.player.position.y=unitvectory*maxradius
				return false
			end			
			return true
		else
			return true
		end
	end
	
	
	function class:TornadoCheck()
		local scenario=self.scenario		
		if(not scenario.player)then return end
		local player=scenario.player
		if(player:IsDeadInGame())then return end
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
		if(#auras>0)then return end
		
		if(scenario.tornadograceperiod and scenario.tornadograceperiod>player.environment.localtime)then return end
		
		if(player.inphase)then
			for i=1,#scenario.tornadoes do				
				local torn=scenario.tornadoes[i]
				local distx=torn.position.x-player.position.x
				local disty=torn.position.y-player.position.y
				local distsqr=distx*distx+disty*disty
				--print(distsqr)
				if(distsqr<=XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoRadius*XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoRadius)then
					local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze)
					if(#auras>0 and not auras[1].dying)then
						auras[1].expirytime=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoFreezeTime
					else
						local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_Freeze,player.combatmodule,self.localtime)
						player.velocity.x=0;player.velocity.y=0
						aura.expirytime=player.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoFreezeTime
						aura.locaicon="interface/icons/ability_skyreach_four_wind.blp"
						local visual=XPRACTICE.KELTHUZADMULTIPLAYER.FreezeVisualEffect.new()
						visual:Setup(player.environment,player.position.x,player.position.y,0)
						visual.player=player
						visual.orientation_displayed.yaw=player.orientation.yaw
						scenario.statuslabel:SetText("Frozen by Glacial Winds.",3.0)						
					end
					scenario.multiplayer:FormatAndSendCustom("FREEZE_CYCLO",player.position.x,player.position.y)
				end
			end
		end
	end
	
	
	function class:PoolCheck(elapsed)
		local scenario=self.scenario		
		if(not scenario.player)then return end
		local player=scenario.player
		if(player:IsDeadInGame())then scenario.inpool=false;scenario.pooltime=0 return end
		
		
		
		if(player.inphase)then
			scenario.inpool=false
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
			if(#auras>0)then
				-- do nothing; player is immune
			else
				for i=1,#scenario.pools do				
					local pool=scenario.pools[i]
					local distx=pool.position.x-player.position.x
					local disty=pool.position.y-player.position.y
					local distsqr=distx*distx+disty*disty
					--print(distsqr)
					if(distsqr<=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRadius*XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRadius)then
						scenario.inpool=true
						pool.rim.targetalpha=1
					else
						pool.rim.targetalpha=0
					end
				end
			end
			if(scenario.inpool)then
				scenario.pooltime=scenario.pooltime+elapsed
				--TODO: display pool collision visual
				if(scenario.pooltime>=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolTolerance)then
					local aura=scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.player.combatmodule,scenario.player.environment.localtime)
					scenario.statuslabel:SetText("Died from Shadow Pool.",3.0)
					scenario.multiplayer:FormatAndSendCustom("DEAD_POOL")
					local player=scenario.player
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced,player.combatmodule,player.environment.localtime)
					aura.scenario=scenario
				end
			else
				scenario.pooltime=scenario.pooltime-elapsed*XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRecoveryRate
				if(scenario.pooltime<=0)then scenario.pooltime=0 end
			end
		end
	end

end