do
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_ShatteringPain=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_ShatteringPain
		

		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Shattering Pain"
			self.icon="interface/icons/sha_spell_fire_blueflamestrike_nightmare.blp" -- but the icon is red

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=3.0			
			self.basechannelticks=3  --actually 9 ticks according to wowhead
			self.tickonchannelstart=true
			self.usablewhilemoving=true -- to make sure Shattering Pain #6 doesn't fail
		end
		
		function class:OnChannelTick(spellinstancepointer,tickcount)
			local denathrius=spellinstancepointer.castercombat.mob
			if(tickcount<=2)then
				denathrius.animationmodule:ResetAnimation(XPRACTICE.INDIGNATION.AnimationList.IdleAttack2H)
			else
				denathrius.animationmodule:PlayAnimation(XPRACTICE.AnimationList.CombatAbility2HBig01)
				denathrius.walking=true
				denathrius.autoattacktimer=denathrius.autoattackspeed
				--print("yaw:",denathrius.orientation.yaw)
				local angle=denathrius.orientation.yaw --TODO: always face current target instead
				local dist=3
				local x=denathrius.position.x+math.cos(angle)*dist
				local y=denathrius.position.y+math.sin(angle)*dist
				denathrius.ai:SetTargetPosition(x,y)
				local event={}
				event.time=self.scenario.game.environment_gameplay.localtime+0.61
				event.func=function(scenario)
						self:ShatteringPainKnockback(spellinstancepointer,scenario)
						denathrius.walking=false
					end
				event.alwayshappens=true				
				tinsert(self.scenario.events,event)				

				if(self.scenario.shatteringpaincallback)then
					local event={}
					event.time=self.scenario.game.environment_gameplay.localtime+0.61+0.1
					event.func=function(scenario)					
							scenario:shatteringpaincallback()
							scenario.shatteringpaincallback=nil
						
					end
					--event.alwayshappens=true				
					tinsert(self.scenario.events,event)				
				end				
					

			end



		end
		
		function class:ShatteringPainKnockback(spellinstancepointer,scenario)
		-- wow.tools/dbc/?dbc=spelleffect&build=9.0.5.38134#page=35&search=98
		-- wow.tools/dbc/?dbc=spelleffect&build=9.0.5.38134#page=1&search=332626
			scenario.shatteringpaincount=scenario.shatteringpaincount+1
			local denathrius=spellinstancepointer.castercombat.mob
			for i=1,#scenario.allplayers do
				local ghost=scenario.allplayers[i]
				if(not ghost:IsDeadInGame())then
					local angle=math.atan2(ghost.position.y-denathrius.position.y,ghost.position.x-denathrius.position.x)
					if(ghost.mirrorrealm)then 
						angle=angle+math.pi
					end
					ghost.velocity.z=5	--base points 50
					local xyvelocity=50 --misc value[0] 500
					--knockback resistance check
					local resist=false		
					if(i<=2)then	-- CPU tanks get to charge/leap every time
						resist=true
					end
					-- if(scenario.shatteringpaincount==1)then
						-- if(i<=2)then
							-- resist=true
						-- end					
					-- end
					
					if(scenario.shatteringpaincount==6)then
						--print("SPC",scenario.shatteringpaincount,i,ghost,scenario.player)
						if(i<=10 or (ghost==scenario.player and ghost.mirrorrealm))then
							-- on 6th knockback, ALL mirrors use immune
							-- -- give player immune if they're mirror
							resist=true
							if(XPRACTICE_SAVEDATA.INDIGNATION.mirrorknockbackresist==false and ghost==scenario.player and ghost.mirrorrealm)then
								resist=false
							end
						end
					end
					if(resist)then
						xyvelocity=10
					end
					ghost.velocity.x=math.cos(angle)*xyvelocity
					ghost.velocity.y=math.sin(angle)*xyvelocity
					
				end				
			end
		end
	end

end