
do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_SonarShriek=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_SonarShriek


	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Sonar Shriek"
		self.icon="interface/icons/spell_shadow_deathscream.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		--"cast time" is 4 seconds
			--TODO: maybe it's 6 seconds now?
		--animation begins about 2 seconds into cast
		--shriekwing's cast bar should be hidden, so it's okay to fake this with a 1.75sec cast instead of a 4sec cast
		local DELAY=1.75	-- lower DELAY means channel will tick LATER in animation
		self.basecastduration=DELAY
		self.basechannelduration=4.000-DELAY		
		self.basechannelticks=1
		self.tickonchannelstart=false
	end
	

	
	-- function class:CastingAnimationFunction(spellinstancepointer)	
		-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.RoarCast)
	-- end
	-- function class:ChannelingAnimationFunction(spellinstancepointer)	
		-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.RoarCast)
	-- end
	
	function class:StartCastingEffect(spellinstancepointer)
		local iconsize="20"
		--local icon="\124Tinterface\\icons\\spell_shadow_coneofsilence:"..iconsize.."\124t"
		--local link="\124cffff0000\124Hspell:340047\124h[Sonar Shriek]\124h\124r"			
		--local message=icon.." Shriekwing begins to unleash a "..link.."!"
		local icon="\124Tinterface\\icons\\spell_nzinsanity_bloodthirst:"..iconsize.."\124t"
		local link="\124cffff0000\124Hspell:330711\124h[Earsplitting Shriek]\124h\124r"			
		local message=icon.." Shriekwing begins to unleash an "..link.."!"
		XPRACTICE_RaidBossEmote(message,5.0,true)
	end
	
	function class:StartChannelingEffect(spellinstancepointer)
		spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.RoarCast)
	end
	
	
	function class:OnChannelTick(spellinstancepointer,tickcount)	
		local nova=XPRACTICE.TERROROFCASTLENATHRIA.SonarShriekNova.new()		
		local shriekwing=spellinstancepointer.castercombat.mob		
		nova:Setup(shriekwing.environment,shriekwing.position.x,shriekwing.position.y,2)
		local scenario=shriekwing.scenario
		local player=scenario.player		
		if(player and (not player:IsDeadInGame()))then
			----------------------------------------------
			-- SONAR SHRIEK HIT DETECTION
			----------------------------------------------		
			if(shriekwing and player)then
				local loslines=scenario:GetShriekLOSLines(player)
				local safe=true
				for i=1,#loslines do	
					local collision=scenario:LOSLineCollisionTest(loslines[i])			
					if(not collision)then
						safe=false
					end
				end
				if(not safe)then					
					if(XPRACTICE.Config.Shriekwing.SonarShriekCausesDescent)then
						scenario:QuickDeadlyDescent(player)						
					else
						local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,targetcombat,scenario.localtime)
						player.scenario.statuslabel:SetText("You were hit by Earsplitting Shriek.",3.0)
					end
					if(XPRACTICE.Config.Shriekwing.ShriekLOSVisibility==false)then
						----TODO LATER: maybe restore this line
						--scenario.statuslabel:SetText("You were hit by Sonar Shriek.  You can make it more obvious by turning on \"ShriekLOSVisibility\" in the scenario config file.",4.0)
					end
				end
				----------------------------------------------
				-- GHOSTS
				----------------------------------------------		
				if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EnemyGhosts>0)then
					if(XPRACTICE.Config.Shriekwing.SonarShriekCausesDescent)then
						for j=1,XPRACTICE.Config.Shriekwing.EnemyGhostShriekAttempts do
							local rate=XPRACTICE.Config.Shriekwing.EnemyGhostShriekRate
							if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EnemyGhosts==1)then
								rate=rate/3.0
							end
							if(math.random()<rate)then
								local x,y=XPRACTICE.RandomPointInCircle(player.position.x,player.position.y,XPRACTICE.Config.Shriekwing.EnemyGhostRadius)
								local target={}
								target.position={}
								target.position.x=x
								target.position.y=y
								local loslines=scenario:GetShriekLOSLines(target)
								local safe=true	
								for i=1,#loslines do	
									local collision=scenario:LOSLineCollisionTest(loslines[i])			
									if(not collision)then
										safe=false
									end
								end
								if(not safe)then
									scenario:QuickEnemyGhost(x,y,0)
								end						
							end
						end
					end
				end
			end
		end	
		shriekwing.totalshrieks=shriekwing.totalshrieks+1
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.IntermissionLength<0 or shriekwing.totalshrieks<XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.IntermissionLength)then
			self.scenario:ClickButtonAfterDelay(self.scenario.moveshriekwingbutton,2.0)
		else
			self.scenario:ClickButtonAfterDelay(self.scenario.endphasebutton,2.0)
		end
	end
end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.SonarShriekNova=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.SonarShriekNova

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=3.0
		self.expirytime=self.environment.localtime+0.67
	end
	function class:SetActorAppearanceViaOwner(actor)		
		actor:SetModelByFileID(3621938) --9fx_raid1_gargoylebat_sonicwave_nova_raidlow
	end

end
