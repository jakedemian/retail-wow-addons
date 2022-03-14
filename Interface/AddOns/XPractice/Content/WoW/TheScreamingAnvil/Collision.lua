do
	--TODO: generic collision base class?
	XPRACTICE.PAINSMITH.Collision = {}
	local class=XPRACTICE.PAINSMITH.Collision
	class.__index = class

	function class.new(scenario)
		local self=setmetatable({}, class)
		self.scenario=scenario
		return self 
	end


	function class:OutOfBoundsCheck()
		local scenario=self.scenario
		if(not scenario.player)then return end

		if(scenario.player.position.z<-5)then
			if(not scenario.player:IsDeadInGame())then
				-- pally bubble can't save you here
				local aura=scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.player.combatmodule,scenario.player.environment.localtime)
				scenario.statuslabel:SetText("Fell off the arena.",3.0)
				scenario.multiplayer:FormatAndSendCustom("DEAD_RINGOUT")
				local player=scenario.player
				player.position.x=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5
				player.position.y=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5
				player.position.z=2				
			end
		end
	
		for k,v in pairs(scenario.multiplayer.allplayers)do
			local player=v
			if(player~=scenario.player)then
				if(player.position.z<-10)then
					player.position.x=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5
					player.position.y=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5
					player.position.z=2
				end
			end
		end
		
	end
	

	function class:EdgeCheck(player)
		local scenario=self.scenario
		if(not scenario.player)then return true end
		if(player~=scenario.player and player.z==0)then return true end
		if(player.position.x<XPRACTICE.PAINSMITH.Config.ArenaTileSize*1)then return false end
		if(player.position.y<XPRACTICE.PAINSMITH.Config.ArenaTileSize*1)then return false end
		if(player.position.x>XPRACTICE.PAINSMITH.Config.ArenaTileSize*(13+1))then return false end
		if(player.position.y>XPRACTICE.PAINSMITH.Config.ArenaTileSize*(13+1))then return false end
		
		return true
		
	end
	
	function class:SpikedBallsCheck()
		local scenario=self.scenario		
		if(not scenario.player)then return end
		local player=scenario.player
		if(player:IsDeadInGame())then return end	
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
		if(#auras>0)then
			-- do nothing; player is immune			
		else
			for i=1,#scenario.spikedballs do
				local ball=scenario.spikedballs[i]
				
				local xdist=ball.position.x-player.position.x
				local ydist=ball.position.y-player.position.y
				local distsqr=xdist*xdist+ydist*ydist
				local radius=XPRACTICE.PAINSMITH.Config.ArenaTileSize/2+XPRACTICE.PAINSMITH.Config.IntermissionSpikedBallExtraHitboxSize
				if(distsqr<=radius*radius)then
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
					scenario.statuslabel:SetText("Died from a Spiked Ball.",3.0)
					scenario.multiplayer:FormatAndSendCustom("DEAD_SPIKEDBALL")
				end
			
			end			
		end
	end
	
	function class:SpikesCheck()
		local scenario=self.scenario		
		if(not scenario.player)then return end
		local player=scenario.player
		if(player:IsDeadInGame())then return end	
		local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
		if(#auras>0)then
			-- do nothing; player is immune
		else
			for i=1,#scenario.spikes do
				local spike=scenario.spikes[i]
				if(spike.alivetime>0.5 and spike.alivetime<1.5)then
					local x1=spike.position.x-XPRACTICE.PAINSMITH.Config.ArenaTileSize/2-XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
					local x2=spike.position.x+XPRACTICE.PAINSMITH.Config.ArenaTileSize/2+XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
					local y1=spike.position.y-XPRACTICE.PAINSMITH.Config.ArenaTileSize/2-XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
					local y2=spike.position.y+XPRACTICE.PAINSMITH.Config.ArenaTileSize/2+XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
					if(player.position.x>=x1 and player.position.x<=x2)then
						if(player.position.y>=y1 and player.position.y<=y2)then
							local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
							scenario.statuslabel:SetText("Died from floor spikes.",3.0)
							scenario.multiplayer:FormatAndSendCustom("DEAD_FLOORSPIKES")
						end
					end
				end
			end
		end
	end	
	
	-- function class:PoolCheck(elapsed)
		-- local scenario=self.scenario		
		-- if(not scenario.player)then return end
		-- local player=scenario.player
		-- if(player:IsDeadInGame())then scenario.inpool=false;scenario.pooltime=0 return end
		
		
		
		-- if(player.inphase)then
			-- scenario.inpool=false
			-- local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
			-- if(#auras>0)then
				-- -- do nothing; player is immune
			-- else
				-- for i=1,#scenario.pools do				
					-- local pool=scenario.pools[i]
					-- local distx=pool.position.x-player.position.x
					-- local disty=pool.position.y-player.position.y
					-- local distsqr=distx*distx+disty*disty
					-- --print(distsqr)
					-- if(distsqr<=XPRACTICE.PAINSMITH.Config.PoolRadius*XPRACTICE.PAINSMITH.Config.PoolRadius)then
						-- scenario.inpool=true
						-- pool.rim.targetalpha=1
					-- else
						-- pool.rim.targetalpha=0
					-- end
				-- end
			-- end
			-- if(scenario.inpool)then
				-- scenario.pooltime=scenario.pooltime+elapsed
				-- --TODO: display pool collision visual
				-- if(scenario.pooltime>=XPRACTICE.PAINSMITH.Config.PoolTolerance)then
					-- local aura=scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.player.combatmodule,scenario.player.environment.localtime)
					-- scenario.statuslabel:SetText("Died from Shadow Pool.",3.0)
					-- scenario.multiplayer:FormatAndSendCustom("DEAD_POOL")
					-- local player=scenario.player
					-- local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.PAINSMITH.Aura_ChangePhaseForced,player.combatmodule,player.environment.localtime)
					-- aura.scenario=scenario
				-- end
			-- else
				-- scenario.pooltime=scenario.pooltime-elapsed*XPRACTICE.PAINSMITH.Config.PoolRecoveryRate
				-- if(scenario.pooltime<=0)then scenario.pooltime=0 end
			-- end
		-- end
	-- end

end