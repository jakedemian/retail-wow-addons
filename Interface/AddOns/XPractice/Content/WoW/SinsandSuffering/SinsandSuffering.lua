
do	
	local super=XPRACTICE.Spell
	XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Calculate=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Calculate

	XPRACTICE.SINSANDSUFFERING.ROLE={}
	XPRACTICE.SINSANDSUFFERING.ROLE.ANCHOR=1
	XPRACTICE.SINSANDSUFFERING.ROLE.POINTMAN=2
	XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_2=3
	XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_3=4
	
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Sins and Suffering (Calculate)"
		--self.icon="interface/icons/ui_venthyranimaboss_orblines.blp"
		self.icon="interface/icons/ability_iyyokuk_calculate.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		self.basecastduration=0.0
		self.basechannelduration=nil
		self.basechannelticks=nil
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
	
		local x={}
		local y={}
		x[1],y[1],x[2],y[2],x[3],y[3]=XPRACTICE.SINSANDSUFFERING.RandomTriangle1.Generate()
		
		local solutionpoints={}
	
		
		-- self.scenario:DeleteMarkers()		
		self.scenario.solutionpoints={}
		for i=1,3 do
			--self.scenario:QuickMarker1(x[i],y[i])
			self.scenario.solutionpoints[i]={x=x[i],y=y[i]}			
		end
		
		--x[1],y[1],x[2],y[2],x[3],y[3],x[4],y[4]=XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_2Anchors(self.scenario.solutionpoints)		
		--x[1],y[1],x[2],y[2],x[3],y[3],x[4],y[4]=XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_1Anchor(self.scenario.solutionpoints)
		self.scenario.sinpoints={}
		-- x[1],y[1],x[2],y[2],x[3],y[3],x[4],y[4]=XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_0Anchors(self.scenario.solutionpoints)
		-- for i=1,4 do
			-- --self.scenario:QuickMarker2(x[i],y[i])
			-- self.scenario.sinpoints[i]={x=x[i],y=y[i]}
		-- end
		
		local functions={}
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1)then
			tinsert(functions,XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_2Anchors)
		end
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2)then
			tinsert(functions,XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_1Anchor)
		end
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3)then
			tinsert(functions,XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_0Anchors)
		end
		
		
		local i=math.floor(math.random()*#functions)+1
		local f=functions[i]
		self.scenario.sinpoints=f(self.scenario.solutionpoints)
		
		--self.scenario.sinpoints=XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_2Anchors(self.scenario.solutionpoints)
		--self.scenario.sinpoints=XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_1Anchor(self.scenario.solutionpoints)
		--self.scenario.sinpoints=XPRACTICE.SINSANDSUFFERING.Random4Points.Generate_0Anchors(self.scenario.solutionpoints)
		
		self.scenario:ClickButtonAfterDelay(self.scenario.projectilesbutton,0.0)
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Projectiles=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Projectiles

	XPRACTICE.SINSANDSUFFERING.ROLE={}
	XPRACTICE.SINSANDSUFFERING.ROLE.ANCHOR=1
	XPRACTICE.SINSANDSUFFERING.ROLE.POINTMAN=2
	XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_2=3
	XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_3=4
	
	XPRACTICE.SINSANDSUFFERING.SHAPE={}
	XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR2={}
	XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR1={}
	XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR0={}
	
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Sins and Suffering (Projectiles)"
		self.icon="interface/icons/ability_xavius_corruptionmeteor.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		self.basecastduration=0.0
		self.basechannelduration=nil
		self.basechannelticks=nil
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
		local scenario=self.scenario
		if(scenario.firstround)then
			local iconsize="20"
			local icon="\124Tinterface\\icons\\spell_animarevendreth_orb:"..iconsize.."\124t"
			local link="\124cffff0000\124Hspell:326040\124h[Sins of the Past]\124h\124r"			
			local message=icon.." Lady Inerva Darkvein conjures "..link.."!"
			XPRACTICE_RaidBossEmote(message,2.0,true)
		end
		local darkvein=spellinstancepointer.castercombat.mob		
		
		for i=1,#scenario.sinpoints do
			local projectile=XPRACTICE.SINSANDSUFFERING.SinProjectile.new()
			local STARTZ=5
			projectile:Setup(scenario.game.environment_gameplay,darkvein.position.x,darkvein.position.y,STARTZ)
			projectile.startposition={x=darkvein.position.x,y=darkvein.position.y,z=STARTZ}
			projectile.destination={x=scenario.sinpoints[i].x,y=scenario.sinpoints[i].y,z=0}
			local telegraph=XPRACTICE.SINSANDSUFFERING.SASTelegraph.new()
			telegraph:Setup(scenario.game.environment_gameplay,projectile.destination.x,projectile.destination.y,0)
		end
		
		self.scenario:ClickButtonAfterDelay(self.scenario.spawnbutton,0.75)
	end
end


do	
	local super=XPRACTICE.Spell
	XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Spawn=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_Spawn


	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Sins and Suffering (Spawn)"
		self.icon="interface/icons/spell_animarevendreth_orb.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		self.basecastduration=0.0
		self.basechannelduration=nil
		self.basechannelticks=nil
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)			
		local scenario=self.scenario
		scenario:DeleteOrbsAndShadows()
		scenario.sinorb_cosmetics={}
		for i=1,#scenario.sinpoints do
			local orb=XPRACTICE.SINSANDSUFFERING.SinOrb.new()
			orb.scenario=scenario
			orb:Setup(self.scenario.game.environment_gameplay,scenario.sinpoints[i].x,scenario.sinpoints[i].y,0)
			tinsert(scenario.sinorb_cosmetics,orb)			
		end
		if(self.scenario.firstround)then		
			self.scenario.firstround=false
			self.scenario:ClickButtonAfterDelay(self.scenario.sharedsufferingtelegraphbutton,1.0)
		end
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel>=2)then
			scenario:ClickButtonAfterDelay(scenario.animawebbutton,0.0)
		end
	end
end

do	
	local super=XPRACTICE.Spell
	XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_AnnounceRole=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.Spell_SinsandSuffering_AnnounceRole

	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Sins and Suffering (Announce Role)"
		self.icon="interface/icons/inv_misc_questionmark.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		self.basecastduration=0.0
		self.basechannelduration=nil
		self.basechannelticks=nil
	end
	

	function class:CompleteCastingEffect(castendtime,spellinstancepointer)			
		local scenario=self.scenario
		--print("settings:",XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnnounceShapeType,XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnnounceRole)
		if(not scenario.player:IsDeadInGame())then	-- don't override a "you died" message
			local point=self.scenario.player.solutionpoint
			if(point)then
				local message=""
				local shapecount=0
				if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType1)then shapecount=shapecount+1 end
				if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType2)then shapecount=shapecount+1 end
				if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ShapesType3)then shapecount=shapecount+1 end
				if(shapecount>1 and XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnnounceShapeType)then			
					if(point.shape==XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR2)then
						message=message.."Two anchors.\n"
					elseif(point.shape==XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR1)then
						message=message.."One anchor.\n"
					elseif(point.shape==XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR0)then
						message=message.."No anchors.\n"
					end
				end
				if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUGhostCount==2 and XPRACTICE_SAVEDATA.SINSANDSUFFERING.AnnounceRole)then	
					if(point.role==XPRACTICE.SINSANDSUFFERING.ROLE.ANCHOR)then
						message=message.."You are \"ANCHOR\".\n"
					elseif(point.role==XPRACTICE.SINSANDSUFFERING.ROLE.POINTMAN)then
						message=message.."You are \"POINT MAN\".\n"
					elseif(point.role==XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_2)then
						message=message.."You are \"connecting TWO\".\n"
					elseif(point.role==XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_3)then
						message=message.."You are \"connecting THREE\".\n"
					end					
				end
				if(message~="")then
					scenario.statuslabel:SetText(message,5.0)
				end
			end
		end
	end
end

do	
	--static function
	function XPRACTICE.SINSANDSUFFERING.SinsandSuffering_Hint(scenario)
		if(scenario.redx)then
			if(not scenario.redx.dead)then
				return
			end
		end
		for i=1,#scenario.solutionpoints do
			local point = scenario.solutionpoints[i]
			obj=XPRACTICE.WoWObject.new();obj:Setup(scenario.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(456041)	-- raid_ui_fx_red
			obj.position.x=point.x
			obj.position.y=point.y
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=0.0;obj.projectiledespawncustomduration=2.0		
			scenario.redx=obj
		end
	end
end