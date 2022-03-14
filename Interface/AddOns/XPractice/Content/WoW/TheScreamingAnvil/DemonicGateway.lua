do

 -- cast time 2.0 (not important)
	--purple->green	
	--607022	warlock_demonicportal_purple
	--607506	warlock_demonicportal_missile
	--607277	warlock_demonicportal_green
	--607510	warlock_demonicportal_travel_purple
	--607508	warlock_demonicportal_travel_green
	
	do
		XPRACTICE.PAINSMITH.QuickDemonicGateway=function(scenario)
			local point1,point2
			point1={x=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5,y=XPRACTICE.PAINSMITH.Config.ArenaTileSize*4}
			point2={x=XPRACTICE.PAINSMITH.Config.ArenaTileSize*7.5,y=XPRACTICE.PAINSMITH.Config.ArenaTileSize*13}
			
			
			
			local angle=math.atan2(point2.y-point1.y,point2.x-point1.x)
			local purple=XPRACTICE.PAINSMITH.DemonicGatewayPurple.new()
			purple:Setup(scenario.game.environment_gameplay,point1.x,point1.y,0)
			purple:FreezeOrientation(angle)
			purple.scenario=scenario
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(scenario.game.environment_gameplay,purple)				
			local green=XPRACTICE.PAINSMITH.DemonicGatewayGreen.new()
			green:Setup(scenario.game.environment_gameplay,point2.x,point2.y,0)
			green:FreezeOrientation(angle+math.pi)
			green.scenario=scenario
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(scenario.game.environment_gameplay,green)
			green.alpha=0
			purple.partner=green
			green.partner=purple
			local missile=XPRACTICE.PAINSMITH.DemonicGatewayMissile.new()
			missile:Setup(scenario.game.environment_gameplay,point1.x,point1.y,2)
			local dist=math.sqrt((point2.x-point1.x)*(point2.x-point1.x)+(point2.y-point1.y)*(point2.y-point1.y))			
			missile.scale=2
			local TRAVELSPEED=60
			missile.expirytime=scenario.game.environment_gameplay.localtime+dist/TRAVELSPEED
			missile.orientation_displayed.yaw=angle
			missile.velocity.x=math.cos(angle)*TRAVELSPEED
			missile.velocity.y=math.sin(angle)*TRAVELSPEED
			missile.green=green
			return purple
		end
	end
	
		
	do
		local super=XPRACTICE.Mob
		XPRACTICE.PAINSMITH.DemonicGatewayPurple=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.DemonicGatewayPurple
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(607022)	-- warlock_demonicportal_purple		
		end
		
		-- function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
			-- local radius=1.5
			-- local base=2
			-- local height=2.5
			-- displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
		-- end	
		
		function class:OnClick(player,environment,button)
			if((not player.portaldebuff) and (not player:IsDeadInGame()))then					
				if(self:IsInClickRange(player))then			
					self:TeleportToOtherGateway(player)
				else
					self:CreateSpeechBubble("Too far away!")
				end
			end
		end
		
		--TODO: this might become a generic Mob function later?
		function class:IsInClickRange(player)
			local distx=player.position.x-self.position.x
			local disty=player.position.y-self.position.y
			local distsqr=distx*distx+disty*disty
			local dist=math.sqrt(distsqr)	
			return(dist<=5)
		end
		
		function class:GetTeleportGraphicFileID()
			--return XPRACTICE.PAINSMITH.DemonicGatewayTeleportGraphicPurple
			return 607510
		end
		
		function class:TeleportToOtherGateway(player)
			--TODO: has player already clicked gateway?  (ghosts can do whatever)
				-- (we are currently checking for this in OnClick)
			player.position.x=self.position.x
			player.position.y=self.position.y
			player.position.z=1
			player:FreezeOrientation(self.orientation_displayed.yaw)
			local xdist=self.partner.position.x-self.position.x
			local ydist=self.partner.position.y-self.position.y
			local angle=math.atan2(ydist,xdist)
			local bubble=XPRACTICE.PAINSMITH.DemonicGatewayTravelPurple.new()
			bubble:Setup(self.environment,self.position.x,self.position.y,2)
			bubble.player=player
			bubble.dest=self.partner
			local SPEED=60
			local dist=math.sqrt(xdist*xdist+ydist*ydist)
			bubble.expirytime=self.environment.localtime+dist/SPEED
			bubble.velocity.x=math.cos(angle)*SPEED
			bubble.velocity.y=math.sin(angle)*SPEED
			bubble.displayobject.drawable:SetModelByFileID(self:GetTeleportGraphicFileID())
			player.portaldebuff=true			
			local scenario=player.scenario
			scenario.multiplayer:FormatAndSend("MIDAIR",self.partner.position.x,self.partner.position.y,1,0,0,0,scenario.player.orientation.yaw,false)
			scenario.multiplayer.prevmidair=true
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
			if(#auras==0)then
				local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.PAINSMITH.Aura_PallyBubble)
				aura.expirytime=player.environment.localtime+1
				aura.visual:Die()
			else
				local aura=auras[1]
				if(not aura.expirytime or aura.expirytime<player.environment.localtime+1)then
					aura.expirytime=player.environment.localtime+1
				end
			end			
		end
		
	end
	
	do
		local super=XPRACTICE.PAINSMITH.DemonicGatewayPurple
		XPRACTICE.PAINSMITH.DemonicGatewayGreen=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.DemonicGatewayGreen
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(607277)	-- warlock_demonicportal_green
		end
		function class:GetTeleportGraphicFileID()
			--return XPRACTICE.PAINSMITH.DemonicGatewayTeleportGraphicGreen
			return 607508
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.DemonicGatewayMissile=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.DemonicGatewayMissile
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(607506)
		end
		
		function class:OnExpiry()
			super.OnExpiry(self)
			self.green.alpha=1
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.DemonicGatewayTravelPurple=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.DemonicGatewayTravelPurple
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(607510)
		end
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(not self.dying)then
				self.player.position.x=self.position.x
				self.player.position.y=self.position.y
				self.player.position.z=self.position.z
			end
			if(self.player:IsDeadInGame())then
				self:Die()
			end			
		end
		function class:OnExpiry()
			super.OnExpiry(self)
			self.player.velocity.x=0
			self.player.velocity.y=0
			self.player.velocity.z=0
			self.player.position.x=self.dest.position.x
			self.player.position.y=self.dest.position.y
			self.player.position.z=0
			--self.player.scenario.multiplayer:FormatAndSend("MIDAIR",self.player.position.x,self.player.position.y,2,0,0,0,self.player.orientation.yaw,false)
			--self.player.scenario.multiplayer.prevmidair=true
		end
	end
	
	-- do
		-- local super=XPRACTICE.DemonicGatewayTravelPurple
		-- XPRACTICE.PAINSMITH.DemonicGatewayTravelGreen=XPRACTICE.inheritsFrom(super)
		-- local class=XPRACTICE.PAINSMITH.DemonicGatewayTravelGreen
		
		-- function class:SetActorAppearanceViaOwner(actor)
			-- actor:SetModelByFileID(607508)
		-- end
	-- end
end