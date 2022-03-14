do
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Debug_StopEvents=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Debug_StopEvents

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Debug) Stop Events"
			self.icon="interface/icons/spell_nature_timestop.blp"
			--self.icon="interface/icons/spell_shadow_vampiricaura.blp"
			--self.icon="interface/icons/inv_sword_1h_newplayer_a_03.blp"
			--self.icon="interface/icons/inv_weapon_bow_02.blp"
			--self.icon="interface/icons/ability_hunter_markedfordeath.blp"
			--self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil			
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			self.scenario.stopallevents=true
			self.scenario.dropseedscallback=nil
			self.scenario.aftersoakcallback=nil
		end
	end
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Debug_MoveBossCamp=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Debug_MoveBossCamp

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Debug) Move Boss Camp"
			self.icon="interface/icons/inv_sword_1h_newplayer_a_03.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil			
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local sc=self.scenario;	local player=sc.player
			sc:SetCamp(sc.bosscamp,{x=player.position.x,y=player.position.y})
			sc:BossToCamp()
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,0,math.pi/2,7,3,0,0)
			sc:GroupFaceCamp(sc.mirrorgroup,sc.bosscamp)
			sc:GroupFaceCamp(sc.rangedgroup,sc.bosscamp)
		end
	end	


	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Debug_MoveRangedCamp=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Debug_MoveRangedCamp

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Debug) Move Ranged Camp"
			self.icon="interface/icons/inv_weapon_bow_02.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil			
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local sc=self.scenario;	local player=sc.player
			sc:SetCamp(sc.rangedcamp,{x=player.position.x,y=player.position.y})
			sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,0,0)
			sc:GroupFaceCamp(sc.rangedgroup,sc.bosscamp)
		end
	end		
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Debug_PlaceRing=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Debug_PlaceRing

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Debug) Place Ring"
			self.icon="interface/icons/ability_hunter_markedfordeath.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil			
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local sc=self.scenario;	local player=sc.player
			local telegraph=XPRACTICE.INDIGNATION.FatalFinesseDropTelegraph.new()
			telegraph:Setup(player.environment,player.position.x,player.position.y,0)
			tinsert(sc.debugobjects,telegraph)
			telegraph.player=nil
			telegraph.projectileloopcustomduration=nil
		end
	end			
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Debug_RemoveRing=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Debug_RemoveRing

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Debug) Remove Ring"
			self.icon="interface/icons/achievement_bg_returnxflags_def_wsg.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil			
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local sc=self.scenario;	local player=sc.player
			local closestobj=nil
			local closestindex=nil
			local closestdistsqr=0
			for i=1,#sc.debugobjects do
				local obj=sc.debugobjects[i]
				local distsqr=(player.position.x-obj.position.x)*(player.position.x-obj.position.x)+(player.position.y-obj.position.y)*(player.position.y-obj.position.y)
				
				if(closestobj==nil or distsqr<closestdistsqr) then
					closestdistsqr=distsqr
					closestobj=obj
					closestindex=i
				end
			end
			if(closestobj)then
				closestobj:Die()
				tremove(sc.debugobjects,closestindex)
			end
		end
	end		
				
end