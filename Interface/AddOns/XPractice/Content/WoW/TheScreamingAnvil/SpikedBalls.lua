do
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.SpikedBallTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.SpikedBallTelegraph
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.scale=3/4+0.1
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1034184)	--target_fire_state_centeronly
			--actor:SetModelByFileID(3642466)	--target_anima_revendreth_state_centeronly
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=XPRACTICE.PAINSMITH.Config.IntermissionSpikedBallTelegraphTime-self.projectilespawncustomduration
			self.projectiledespawncustomduration=0.25		
		end	
		
		function class:OnProjectileDespawning()
			local ball=XPRACTICE.PAINSMITH.SpikedBall.new()
			ball:Setup(self.environment,self.position.x,self.position.y)
			ball.scenario=self.scenario
			ball.direction=self.direction			
			--ball.orientation.yaw=math.pi;ball.orientation_displayed.yaw=ball.orientation.yaw
			ball:FreezeOrientation((ball.direction-1)/2*math.pi)
			tinsert(self.scenario.spikedballs,ball)
		end
		
		
		-- function class:Step(elapsed)
			-- super.Step(self,elapsed)
			-- -- self.alivetime=self.alivetime+elapsed
			-- -- --self.alpha=self.alivetime/XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration
			-- -- if(self.alivetime>=XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration)then
				-- -- self:Die()
			-- -- end
		-- end
	end	
	
	do
		--4004996 --9mw_domination_bossfloorspiketrap05
		local super=XPRACTICE.Mob
		XPRACTICE.PAINSMITH.SpikedBall=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.SpikedBall
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.scale=3/4			
			self.walkspeed=3.2499394416809	-- about 13/4
			self.scale=0.45
			self.startingphasealpha=1.0
			self.alivetime=0
			self.state=0
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3886939)	--9mw_ironmaiden_spikeball01
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.PAINSMITH.AnimationList.SpikedBallFall)
		end
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.alivetime=self.alivetime+elapsed
			if(self.state==0)then
				if(self.alivetime>=0.5)then
					self.ai.targetposition={x=self.position.x+self.direction*XPRACTICE.PAINSMITH.Config.ArenaTileSize*14,y=self.position.y}
					self.walking=true
					self.state=1					
				end
			elseif(self.state==1)then
				if(self.position.x<=XPRACTICE.PAINSMITH.Config.ArenaTileSize*1 or self.position.x>XPRACTICE.PAINSMITH.Config.ArenaTileSize*14)then
					self.ai.targetposition=nil
					self.animationmodule:PlayAnimation(XPRACTICE.PAINSMITH.AnimationList.SpikedBallDestroy)
					self.expirytime=self.environment.localtime+1.0
					self.state=2
				end
			end
			
		end
	end		
end