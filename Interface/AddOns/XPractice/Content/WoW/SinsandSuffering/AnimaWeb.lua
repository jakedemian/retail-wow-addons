do
	local WEBZ1=3.0
	local WEBZ2=3.0*2/3
	local INITIAL_LENGTH=-4
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.SINSANDSUFFERING.Spell_AnimaWeb=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.Spell_AnimaWeb
		
		
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Anima Web"
			self.icon="interface/icons/spell_animarevendreth_wave.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			self.scenario.animaweblinecontroller:Activate()
			
			-- self.scenario.weblines={}--TODO: cleanup
			-- for i=1,#self.scenario.sinpoints do
				-- local p1=self.scenario.sinpoints[i]
				-- local p2=self.scenario.sinpoints[i].next
				-- local line=XPRACTICE.VisibleLine.new()
				-- line:Setup(self.scenario.game.environment_gameplay,p1.x,p1.y,WEBZ1,p2.x,p2.y,WEBZ2)
				-- line.visible=true			
				-- --line:ChangeLineActorID(166497,0,0) -- lightning, wrong offset
				-- --line:ChangeLineActorID(167213,0,0) -- wrath, wrong offset
				-- --line:ChangeLineActorID(167229,0,0) -- zig
				-- --line:ChangeLineActorID(610625,0,0) -- priest_divinestar_missile_yellow
				-- --line:ChangeLineActorID(659082,0,0) -- red lightning
				-- --line:ChangeLineActorID(852566,0,0) -- missile_corrupted_01
				-- --line:ChangeLineActorID(875215,0,0) -- missile_template_01
				-- --line:ChangeLineActorID(959522,0,0) -- solar_heavy_missile
				-- --line:ChangeLineActorID(959924,0,0) -- solar_chakram_missile
				-- line:ChangeLineActorID(970786,0,0) -- hunter_focusingshot_missile --use this
				-- line.scale=1
				-- --line:ChangeLineActorID(1027152,0,0) -- missile_shadow_bolt --use this
				-- --line:ChangeLineActorID(1242716,0,0) --  cfx_deathknight_bloodplague_missile
				-- --line:ChangeLineActorID(1266190,0,0) -- 7fx_jailer_solgorged_missile
				-- --line:ChangeLineActorID(1337655,0,0) -- 7fx_soul_missile_shadow
				-- --line:ChangeLineActorID(1363139,0,0) -- cfx_demonhunter_shatteredsouls_missile
				-- --line:ChangeLineActorID(1363271,0,0) -- cfx_deathknight_deathscaress_missile --use this
				-- --line:ChangeLineActorID(1368707,0,0) -- cfx_mage_cinderstorm_missile
				-- --line:ChangeLineActorID(1452722,0,0) -- 7fx_deathknight_consumption_missile			
				-- tinsert(self.scenario.weblines,line)
			-- end		
		end
	end

	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.SINSANDSUFFERING.AnimaWebLineController=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.AnimaWebLineController

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.enabled=false
		end

		function class:CreateAssociatedObjects()
			local scenario=self.scenario
			self.weblines={}
			self.webdots={}
			
			self.reverse=false			
			for i=1,4 do
				local line=XPRACTICE.VisibleLine.new()					
				line:Setup(self.scenario.game.environment_gameplay,0,0,0,0,0,0)
				line.visible=true
				if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnimaWebLineType==1)then
					line:ChangeLineActorID(970786,0,0) -- hunter_focusingshot_missile
					line.scale=1	
				elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnimaWebLineType==2)then
					line:ChangeLineActorID(1363271,0,0) -- cfx_deathknight_deathscaress_missile
					line.scale=0.75
				end
				line.alpha=0				
				line.length=INITIAL_LENGTH
				line.angleoffset=0
				tinsert(self.weblines,line)
				local dot=XPRACTICE.SINSANDSUFFERING.AnimaWeb_Dot.new()
				dot:Setup(self.scenario.game.environment_gameplay,0,0,0,0,0,0)
				dot.alpha=0
				tinsert(self.webdots,dot)
			end
		end
		
		function class:Step(elapsed)
			local LINESPEED=XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnimaWebGrowthRate
			
			local scenario=self.scenario
			local targetalpha
			if(not self.enabled)then
				targetalpha=0
			else
				targetalpha=1
			end
			
			local linesatmaxlength=0
			for i=1,#scenario.sinpoints do
				local line=self.weblines[i]
				local dot=self.webdots[i]
				local p1,p2
				
				local ALPHARATE=2
				if(line.alpha<targetalpha)then
					line.alpha=line.alpha+elapsed*ALPHARATE
					if(line.alpha>targetalpha)then line.alpha=targetalpha end
				end
				if(line.alpha>targetalpha)then
					line.alpha=line.alpha-elapsed*ALPHARATE
					if(line.alpha<targetalpha)then line.alpha=targetalpha end
				end
				if(line.length<=0)then 
					line.alpha=0 
				else
					if(dot.enabled==false)then
						dot:Activate()
					end
				end
			
				p1=scenario.sinpoints[i]
				if(not self.reverse)then p2=p1.next else p2=p1.prev end
				
				--TODO LATER: clean up logic
				local maxlength
				if(self.enabled)then
					maxlength=math.sqrt((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y))
					line.length=line.length+elapsed*LINESPEED
					if(line.length>=maxlength)then 
						line.length=maxlength 						
						linesatmaxlength=linesatmaxlength+1						
					end
				else
					line.length=INITIAL_LENGTH
					line.angleoffset=0
				end
				local displayedlength=line.length
				if(displayedlength<0)then displayedlength=0 end
				
				if(self.enabled)then
					line.linesegment.x1=p1.x
					line.linesegment.y1=p1.y
					line.linesegment.z1=WEBZ1
					local angle=math.atan2(p2.y-p1.y,p2.x-p1.x)
					line.linesegment.x2=p1.x+math.cos(angle+line.angleoffset)*displayedlength
					line.linesegment.y2=p1.y+math.sin(angle+line.angleoffset)*displayedlength
					line.linesegment.z2=(WEBZ2-WEBZ1)*(displayedlength/maxlength)+WEBZ1
					dot.position.x=line.linesegment.x2
					dot.position.y=line.linesegment.y2
					dot.position.z=line.linesegment.z2
					
					--line:SetMissileOrientationAgainstLine()
					line:SetMissileOrientationAlongLine()
				-- else
					-- line.linesegment.x1=0
					-- line.linesegment.y1=0
					-- line.linesegment.z1=0
					-- line.linesegment.x2=0
					-- line.linesegment.y2=0
					-- line.linesegment.z2=0
				end
			end
			if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel==3)then
				if(linesatmaxlength==#scenario.sinpoints)then
					for i=1,#scenario.sinpoints do
						local SWEEPSPEED=XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnimaWebSpinRate
						local line=self.weblines[i]
						local circ=line.length*math.pi*2
						--TODO LATER: these 2pis cancel each other out
						local anglechange=elapsed*(SWEEPSPEED/circ)*(math.pi*2)					
						line.angleoffset=line.angleoffset+anglechange*line.sweepdirection					
					end
				end
			end
		end
		
		function class:Activate()
			self.enabled=true
			for i=1,#self.weblines do
				self.weblines[i].length=INITIAL_LENGTH
				self.weblines[i].angleoffset=0
				if(math.random()>0.5)then self.weblines[i].sweepdirection=1 else self.weblines[i].sweepdirection=-1 end
			end
			-- for i=1,#self.webdots do
				-- self.webdots[i]:Activate()
			-- end			
			if(math.random()>0.5) then self.reverse=false else self.reverse=true end --TODO: savedata
		end
		function class:Deactivate()
			self.enabled=false
			for i=1,#self.webdots do
				self.webdots[i]:Deactivate()
			end
		end		
	end
	
do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.SINSANDSUFFERING.AnimaWeb_Dot=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.AnimaWeb_Dot
		
		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByFileID(3581779)	--9fx_raid1_sommelier_sharedsuffering_dot
			actor:SetModelByFileID(3581781)	-- 9fx_raid1_sommelier_sinsofthepast_dot
			self.scale=1		
			self.enabled=false
		end
		
		function class:SetDefaultAnimation()
			-- play despawn animation so the spawn animation plays properly on activation
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			self.projectilespawncustomduration=1
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=1
		end	
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			-- if(self.player)then			
				-- self.alpha=self.player.alpha
				-- self.position.x=self.player.position.x
				-- self.position.y=self.player.position.y
				-- self.position.z=self.player.position.z+SWIRLZ
				-- self.orientation_displayed.yaw=self.player.orientation_displayed.yaw
			-- end
			if(not self.enabled)then
				self.alpha=0
			else
				self.alpha=1
			end
		end
		
		function class:Activate()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.enabled=true
		end
		function class:Deactivate()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		end	
		
		function class:OnProjectileDespawned()
			-- don't call super		
			self.enabled=false
		end
	end	
	

end