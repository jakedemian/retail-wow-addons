do

 -- cast time 2.0 (not important)
	--purple->green	
	--607022	warlock_demonicportal_purple
	--607506	warlock_demonicportal_missile
	--607277	warlock_demonicportal_green
	--607510	warlock_demonicportal_travel_purple
	--607508	warlock_demonicportal_travel_green
	
	do
		XPRACTICE.INDIGNATION.QuickDemonicGateway=function(scenario)
			local CSC=XPRACTICE.INDIGNATION.Layout.ConvertScreenshotCoords
			local point1,point2
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==1)then
				point1={x=-28.53,y=3.14}
				--point2={x=-10.46,y=-16.16}
				point2={x=-9.10,y=-10.50}
			elseif(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				point1={x=-22.25,y=15.80}
				point2={x=-6.02,y=-9.78}
			end
			
			
			local angle=math.atan2(point2.y-point1.y,point2.x-point1.x)
			local purple=XPRACTICE.INDIGNATION.DemonicGatewayPurple.new()
			purple:Setup(scenario.game.environment_gameplay,point1.x,point1.y,0)
			purple:FreezeOrientation(angle)
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(scenario.game.environment_gameplay,purple)				
			local green=XPRACTICE.INDIGNATION.DemonicGatewayGreen.new()
			green:Setup(scenario.game.environment_gameplay,point2.x,point2.y,0)
			green:FreezeOrientation(angle+math.pi)
			local mobclickzone=XPRACTICE.MobClickZone.new()
			mobclickzone:Setup(scenario.game.environment_gameplay,green)
			green.alpha=0
			purple.partner=green
			green.partner=purple
			local missile=XPRACTICE.INDIGNATION.DemonicGatewayMissile.new()
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
		XPRACTICE.INDIGNATION.DemonicGatewayPurple=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.DemonicGatewayPurple
		
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
			--return XPRACTICE.INDIGNATION.DemonicGatewayTeleportGraphicPurple
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
			local bubble=XPRACTICE.INDIGNATION.DemonicGatewayTravelPurple.new()
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
		end
		
	end
	
	do
		local super=XPRACTICE.INDIGNATION.DemonicGatewayPurple
		XPRACTICE.INDIGNATION.DemonicGatewayGreen=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.DemonicGatewayGreen
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(607277)	-- warlock_demonicportal_green
		end
		function class:GetTeleportGraphicFileID()
			--return XPRACTICE.INDIGNATION.DemonicGatewayTeleportGraphicGreen
			return 607508
		end
	end
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.DemonicGatewayMissile=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.DemonicGatewayMissile
		
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
		XPRACTICE.INDIGNATION.DemonicGatewayTravelPurple=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.DemonicGatewayTravelPurple
		
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
		end
	end
	
	-- do
		-- local super=XPRACTICE.DemonicGatewayTravelPurple
		-- XPRACTICE.INDIGNATION.DemonicGatewayTravelGreen=XPRACTICE.inheritsFrom(super)
		-- local class=XPRACTICE.INDIGNATION.DemonicGatewayTravelGreen
		
		-- function class:SetActorAppearanceViaOwner(actor)
			-- actor:SetModelByFileID(607508)
		-- end
	-- end
end