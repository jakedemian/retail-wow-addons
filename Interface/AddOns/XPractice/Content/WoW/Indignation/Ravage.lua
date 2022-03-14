do

	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.INDIGNATION.RavageController=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.RavageController

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.enabled=false
			self.safetylines={}
		end

		function class:Precast()
			--TODO: delay 2 seconds!
				--maybe we need to delay massacre cast too?
			self.scenario.collision:RavageBaitCheck()
			for i=1,#self.scenario.ravagetelegraphs do
				local telegraph=self.scenario.ravagetelegraphs[i]
				telegraph:Die()
			end
			class.CreateRavageTelegraphs(self.scenario,1)
		end
		
		-- global static!
		function class.CreateRavageTelegraphs(scenario,offset)
			offset=offset or 0
			scenario.ravagetelegraphs={}
			for i=1,scenario.ravagecount+offset do
				local telegraph=XPRACTICE.INDIGNATION.RavageTelegraph.new()
				telegraph:Setup(scenario.game.environment_gameplay)
				local angle=(math.pi*2/3)*(i-1)
				if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
					angle=angle-math.pi/6
				end
				telegraph.orientation_displayed.yaw=angle
				local scale=1.25
				local dist=26*scale		
				telegraph.position={x=dist*math.cos(angle),y=dist*math.sin(angle),z=0.5}
				telegraph.scale=scale		
				if(i==3)then telegraph.alpha=0.5 end 	-- make 3rd ravage transparent so it's easier to dodge our fake massacre telegraphs
				tinsert(scenario.ravagetelegraphs,telegraph)
			end
		end

		function class:Activate()
			local graphic=XPRACTICE.INDIGNATION.RavageImpact.new()
			graphic:Setup(self.environment)
			local angle=(math.pi*2/3)*self.scenario.ravagecount
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				angle=angle-math.pi/6
			end

			graphic.orientation_displayed.yaw=angle
			local scale=1.25
			local dist=26*scale		
			graphic.position={x=dist*math.cos(angle),y=dist*math.sin(angle),z=0.5}
			graphic.scale=scale	
			
			self.scenario.ravagecount=self.scenario.ravagecount+1
			if(self.scenario.collision:RavageAngleCheck())then
				self.scenario:AttemptKillPlayer(1,"You died from Ravage.",false)
			end
			--
			self:DrawSafetyLines()
		end
		
		function class:DrawSafetyLines()
			local baseangle=-(math.pi*1/3)
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				baseangle=baseangle-math.pi/6
			end
			for i=1,#self.safetylines do
				self.safetylines[i]:Die()
			end
			self.safetylines={}
			if(self.scenario.ravagecount==1 or self.scenario.ravagecount==2)then
				for i=0,1 do
					local LINEZ=0.25
					local DIST=48
					local line=XPRACTICE.VisibleLine.new()		
					local angle=baseangle+i*math.pi*(2/3)*self.scenario.ravagecount
					line:Setup(self.environment,0,0,LINEZ,math.cos(angle)*DIST,math.sin(angle)*DIST,LINEZ)
					local fileid=1363271-- cfx_deathknight_deathscaress_missile
					--local scale=0.25
					local scale=1.0
					line:ChangeLineActorID(fileid,0,0);line.scale=scale;line.visible=true	
					tinsert(self.safetylines,line)
				end
			else
				return
			end

		end

	end
	
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.RavageTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.RavageTelegraph
		
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2SpawnCustomDuration)
			self.projectilespawncustomduration=0.5
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.5
		end	

		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3592456)	-- 9fx_raid1_denathrius_ravage_precastcone
		end
		

	end

	do
		local super=XPRACTICE.VisibleLine
		XPRACTICE.INDIGNATION.Ravage1Guideline=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Ravage1Guideline
		
		function class:Setup(environment)
			local safeangle=0
			if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2)then
				safeangle=safeangle-math.pi/6
			end
			local LINEZ=1
			super.Setup(self,environment,math.cos(safeangle)*10,math.sin(safeangle)*10,LINEZ,math.cos(safeangle)*40,math.sin(safeangle)*40,LINEZ)
			self.visible=true
		end
	end

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.RavageImpact=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.RavageImpact
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.expirytime=self.environment.localtime+1.0
		end

		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3592455)	-- 9fx_raid1_denathrius_ravage_castcone
		end
	end



end