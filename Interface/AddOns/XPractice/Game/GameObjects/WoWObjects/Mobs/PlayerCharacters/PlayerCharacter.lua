do
	local super=XPRACTICE.Mob
	XPRACTICE.PlayerCharacter=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PlayerCharacter

	function class:Setup(environment,x,y,z)
		super.Setup(self,environment,x,y,z)
		self.nextpulltime=0
		self.playername=UnitName("player") --TODO: move to addon startup
	end
	
	function class:CreateCombatModule()
		super.CreateCombatModule(self)
		local spell_roll=XPRACTICE.Spell_Roll.new()
		spell_roll:Setup(self.combatmodule)
		--TODO: don't hardcode roll.  it's already spellbook[1]
		self.combatmodule.spellbook.roll=spell_roll
	end
	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)		
		
		--self.displayobject.drawable:SetModelByFileID(1350103) -- not quite ghostwolf
		
		--TODO: if game is reloaded, must TryOn player model first before TryOn any other creatures
				-- (and simply SetModelByUnit(player) isn't enough)
		
		--self.displayobject.drawable:SetSpellVisualKit(nil)			
		--self.displayobject.drawable:SetModelByCreatureDisplayID(80327)	-- Vulpera Firefox
		--self.displayobject.drawable:SetModelByCreatureDisplayID(80328)	-- Vulpera Firefox
		--self.displayobject.drawable:SetModelByCreatureDisplayID(92797)	-- Sire Denathrius		
		--self.displayobject.drawable:SetModelByCreatureDisplayID(97115)	-- Sire Denathrius		
		--self.displayobject.drawable:SetModelByCreatureDisplayID(97378)	-- Echo of Denathrius		
		--self.displayobject.drawable:SetModelByCreatureDisplayID(96665)	-- Remornia
		--self.displayobject.drawable:SetModelByCreatureDisplayID(69082)	-- Elisande
		self.displayobject.drawable:SetModelByUnit("player")
		--to find displayIDs without wowhead: wow.tools/dbc/?dbc=creature&build=9.0.5.38134#page=1
		--self.displayobject.drawable:SetModelByCreatureDisplayID(87892) -- jaina, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(31232) -- voljin, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(78345) -- alleria, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(90805) -- gazlowe, CAN equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(26353) -- brann, CAN equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(67345) -- thalyssra, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(75898) -- talanji, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(29814) -- wilfred, CAN equip (but why isn't he in the database?)
		--self.displayobject.drawable:SetModelByCreatureDisplayID(89342) -- garona, CAN equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(85799) -- lilian, CAN equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(79658) -- t'paartos, CAN equip (but ... isn't lightforged yet?)
		--self.displayobject.drawable:SetModelByCreatureDisplayID(64797) -- gamon, CAN equip (but ... full armor!?)
		--self.displayobject.drawable:SetModelByCreatureDisplayID(26365) -- valeera, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(67812) -- murky, can't equip (some models come pre-equipped but are faction-specific)
		--self.displayobject.drawable:SetModelByCreatureDisplayID(35095) -- malfurion, can't equip (horns and wings) (other models are equippable but lack druid features)
		--self.displayobject.drawable:SetModelByCreatureDisplayID(71591) -- akama, can't equip		
		--self.displayobject.drawable:SetModelByCreatureDisplayID(82772) -- moira, CAN equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(41667) -- aysa, CAN equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(31177) -- genn, can't equip
		--self.displayobject.drawable:SetModelByCreatureDisplayID(63703) -- mayla, CAN equip		
		
		--a=self.displayobject.drawable--!!!
		
		
		
		--C_Timer.After(0.1,function()self.displayobject.drawable:Undress()end)
		--C_Timer.After(0.5,function()self.displayobject.drawable:TryOn("|cffa335ee|Hitem:50048:3870:40111:40111:40111:0:0:0:0|h[Quel'Delar, Might of the Faithful]\124h\124r")end)
		--a=self.displayobject.drawable --!!!
		--self.displayobject.drawable:TryOn("|cffa335ee|Hitem:50048::::::::|h[QuelDelar]|h|r")
		--self.displayobject.drawable:TryOn("\124cffa335ee\124Hitem:50048::::::::\124h[QuelDelar]\124h\124r")
		--self.displayobject.drawable:TryOn("|cffa335ee|Hitem:50048::::::::|h[Remornia]|h|r")
		--self.displayobject.drawable:TryOn("\124cffa335ee\124Hitem:179391::::::::\124h[Remornia]\124h\124r")
		
		--"\124cffa335ee\124Hitem:179391::::::::\124h[Remornia]\124h\124r"
		--"\124cffa335ee\124Hitem:42850::::::::\124h[Remornia]\124h\124r"
		--"\124cffa335ee\124Hitem:184402::::::::\124h[Remornia]\124h\124r"
		
		
		--self.displayobject.drawable:TryOn("|cffa335ee|Hitem:179391::::::::|h[Remornia]|h|r")
		--self.displayobject.drawable:TryOn("|cffa335ee|Hitem:42850::::::::|h[Remornia]|h|r")
		-- Remornia is itemID 179391
		-- FileDataID 3307325 ("item/objectcomponents/weapon/sword_2h_denathrius_d_01.m2")
		-- ModelResourcesID 57042
		-- ItemDisplayInfoID 184402		
		-- ItemModifiedAppearanceID 111679   -- ItemAppearanceID 42850
		-- wow.tools visible tooltip: wow.tools/dbc/?dbc=itemmodifiedappearance&build=9.0.5.38134#page=1&search=179391
		-- wow.tools/dbc/?dbc=itemappearance&build=9.0.5.38134#page=1&search=42850
		-- DefaultIconFileDataID 3502072
		
		--self.displayobject.drawable:TryOn("\124cffa335ee\124Hitem:179391::::::::\124h[Remornia]\124h\124r")
		--self.displayobject.drawable:TryOn("\124cffa335ee\124Hitem:57042::::::::\124h[Remornia]\124h\124r")
		--self.displayobject.drawable:TryOn("|cffa335ee|Hitem:412566::::::::|h[Remornia]|h|r")
		--self.displayobject.drawable:TryOn("|cffa335ee|Hitem:322903::::::::|h[Remornia]|h|r")
		
		--last thing to try before giving up -- can we still equip shoulders+weapon on NPC vulpera model?
		--TODO: what about actor:ClearModel?
		
		--self.displayobject.drawable:TryOn(180273) -- this won't work, must use itemlink instead
		--self.displayobject.drawable:TryOn(179484) --might have been remornia, but no longer in database
		--self.displayobject.drawable:SetSheathed(false)
		-- self.displayobject.drawable:SetSpellVisualKit(84687) --!!!
		 --self.displayobject.drawable:SetSpellVisualKit(40172) --!!! fishing rod
		 --self.displayobject.drawable:SetSpellVisualKit(129659) --!!! Remornia
		-- self.displayobject.drawable:SetSpellVisualKit(136040) --!!!
		--self.displayobject.drawable:SetSpellVisualKit(131725) --!!! substitute spiky sword
		-- self.displayobject.drawable:SetSpellVisualKit(121712) --!!!
		-- --self.displayobject.drawable:SetSpellVisualKit(125800) --!!!
		
		--SpellVisualKitModelAttach AttachmentID exact:1 (scroll right) ParentSpellVisualKitID (subtract 1)
			--										click SpellVisualEffectNameID, click ModelFileDataID
						--AttachmentID exact:1
						--ParentID  128043-131214
						--ParentID  138707-143776 (EOF)  (but we weren't sorting list by parentID)
						--AttachmentID exact:22
						--ParentID 121885-123350
						--ParentID 129017-129374
						--ParentID 129602-129690
			
		---- this one seems to work
		--SpellVisualEffectName ModelFileDataID exact:0 Type exact: 1 click ID (highlight SpellVisualKitModelAttach::...) 
				-- check AttachmentID 1 or 22  --wowdev.wiki/M2#Attachments
				-- view in new tab scroll right ParentSpellVisualKitID (subtract 1)
										-- but maybe type creature instead of item?
						--ID 25264 - 26525
						--ID 32422 - 38342 (EOF)
		
	end
	
	function class:Step(elapsed)
		self.destyaw=nil --!!!
		self.remainingreactiontime=nil--!!!
		--print("yaw",self.orientation.yaw,self.orientation_displayed.yaw,self.target_orientation_displayed.yaw)
		super.Step(self,elapsed)
		if(self.localtime>self.nextpulltime)then
			self.nextpulltime=self.nextpulltime+1.0
			self:AttemptFacepull()
		end
	end
	
	function class:PlayAttackStanceAnimation()
		if(self.scenario and self.scenario.PlayPlayerAttackStanceAnimation)then
			self.scenario:PlayPlayerAttackStanceAnimation()
		else
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Ready1H)
		end
	end
	

	--temporary thing so we can copy ghosts
	function class:ApproachPoint(x,y,mindistance,maxdistance,override)		
		--TODO: have scenario specify which PlayerGhost we're supposed to use
		self.destyaw=nil --!!!		
		local dist=(mindistance+maxdistance)/2.0
		local r=XPRACTICE.INDIGNATION.PlayerGhost.ApproachPoint(self,x,y,dist,dist,override)
		self.remainingreactiontime=nil--!!!
		return r
		
	end


end







do
	local super=XPRACTICE.GameObject
	XPRACTICE.PlayerController=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PlayerController	
	
	function class:Setup(environment,player,camera)
		super.Setup(self,environment)
		self.player=player
		self.camera=camera
		self.potentialclicktarget=nil
		self.potentialclicktargetcoordinates={x=0,y=0}
	end

	function class:GetPlayerInput(elapsed)
		local keys=self.player.environment.game.keys	
		
		local xcameradelta=0
		local ycameradelta=0
		
		----------CAMERA--------------------
		
		local camera=self.camera		
		--TODO: take a look at zoom controls from old version
		local delta=keys.wmouse.pressed
		if(delta)then
			--print("delta:",delta)
			camera:AdjustZoomViaScrollWheel(delta)
		end
		
		local SCROLL_SPEED=20
		
		
		local mousepressed=false
		local mousecurrent=false
		local mousereleased=false
		if(keys.lmouse.pressed or keys.rmouse.pressed)then
			mousepressed=true
		end
		if(keys.lmouse.current or keys.rmouse.current)then
			mousecurrent=true
		end
		if(keys.lmouse.released or keys.rmouse.released)then
			-- note that this detects whether EITHER mouse button was released, even if the other is still held down.
			-- to determine check if mousecurrent=false
			mousereleased=true
		end		
		
		if(mousepressed)then
			local globalx,globaly=GetCursorPosition()
			camera.camerarotationprevmousex=globalx
			camera.camerarotationprevmousey=globaly
			XPRACTICE.CVars:Override("enableMouseSpeed",1)
				-- -- turns out using 0 doesn't work -- camera rotation becomes too granular
			--XPRACTICE.CVars:Override("mouseSpeed",0)
			
			--TODO: first check if mouse sensitivity is enabled and already lower than override!
				-- don't speed the mouse up unwittingly!
			XPRACTICE.CVars:Override("mouseSpeed",XPRACTICE.Config.Camera.MouseSpeed)
		end
		if(mousecurrent)then	
			local globalx,globaly=GetCursorPosition()

			local TEMP_MULTIPLIER=XPRACTICE.Config.Camera.CameraSpeed 	--6-7 for windowed, 9-10 for fullscreen
			--TODO: can we use the GetScaledRect trick for cameraspeed?
			--TODO: attempt to detect whether mouse sensitivity was already set by player, and calculate multiplier from that
			local speed=0.006*(XPRACTICE.CVars.cvarvalues["cameraYawMoveSpeed"]/180)*TEMP_MULTIPLIER

			if(camera.camerarotationprevmousex and camera.camerarotationprevmousey)then
				xcameradelta=(globalx-camera.camerarotationprevmousex)
				ycameradelta=(globaly-camera.camerarotationprevmousey)
			end
			local inversionmultiplier=1
			if(XPRACTICE.CVars.cvarvalues["mouseInvertYaw"]=="1")then
				inversionmultiplier=-1
			end		
			camera.orientation.yaw=camera.orientation.yaw+ -1*xcameradelta*inversionmultiplier*speed
			
			local inversionmultiplier=1
			if(XPRACTICE.CVars.cvarvalues["mouseInvertPitch"]=="1")then			
				inversionmultiplier=-1
			end
			camera.orientation.pitch=camera.orientation.pitch+ -1*ycameradelta*inversionmultiplier*speed
			
			if(camera.orientation.yaw<-math.pi) then camera.orientation.yaw=camera.orientation.yaw+math.pi*2 end
			if(camera.orientation.yaw>math.pi) then camera.orientation.yaw=camera.orientation.yaw-math.pi*2 end				
			
			camera.camerarotationprevmousex=globalx
			camera.camerarotationprevmousey=globaly

			--TODO: move min/max consts to camera
			local MIN_VERTICAL_ANGLE=math.pi*-0.0	--ground
			--local MAX_VERTICAL_ANGLE=math.pi*0.5	--some objects disappear at 0.5
			local MAX_VERTICAL_ANGLE=math.pi*0.49	--overhead
			if(camera.orientation.pitch<MIN_VERTICAL_ANGLE)then camera.orientation.pitch=MIN_VERTICAL_ANGLE end
			if(camera.orientation.pitch>MAX_VERTICAL_ANGLE)then camera.orientation.pitch=MAX_VERTICAL_ANGLE end			
		else
			--else not mousecurrent
			--TODO: look for "self.player" instead (which is apparently never nil)
			-- local player=self.scenario.controls.player
			-- if(player)then
				-- player.targetfacing_3D_button=0
			-- end
		end

		if(mousereleased and not mousecurrent)then
			--TODO: does it matter which order we do this in?  does it need to be reverse order instead?
			XPRACTICE.CVars:Restore("enableMouseSpeed")
			XPRACTICE.CVars:Restore("mouseSpeed")			
		end
		
		local delta=keys.wmouse.pressed
		if(delta)then		
			local DELTA_MULTIPLIER=1
			
			camera.cdist=camera.cdist-delta*DELTA_MULTIPLIER
			local MIN_DIST=5	--TODO: move to camera
			--local MAX_DIST=40	
			--local MAX_DIST=60
			local MAX_DIST=80			
			if(camera.cdist<MIN_DIST)then camera.cdist=MIN_DIST end
			if(camera.cdist>MAX_DIST)then camera.cdist=MAX_DIST end
		end	
	
	
	

		
		------PLAYER CHARACTER------------
	
		if(self.player) then
			local player=self.player
			
			if(keys.rmouse.current and (keys.lmouse.current or xcameradelta~=0 or ycameradelta~=0))then
				if(player:IsAbleToTurnAround())then
					player.orientation.yaw=camera.orientation.yaw
					player.target_orientation_displayed.yaw=player.orientation.yaw
				end
			elseif(not keys.rmouse.current)then
				local turnvector=0
				if(keys.turnQ.current)then
					turnvector=turnvector+1
				end
				if(keys.turnE.current)then
					turnvector=turnvector-1
				end				
				if(turnvector~=0)then
					if(player:IsAbleToTurnAround())then
						--TODO: move to AI?
						if(turnvector>0)then
							self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ShuffleLeft)
						elseif(turnvector<0)then
							self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ShuffleRight)
						end
						local TURN_SPEED=2.5											
						player.orientation.yaw=player.orientation.yaw+turnvector*elapsed*TURN_SPEED
						player.orientation.yaw=XPRACTICE.WrapAngle(player.orientation.yaw)
						player.orientation_displayed.yaw=player.target_orientation_displayed.yaw+turnvector*elapsed*TURN_SPEED
						player.orientation_displayed.yaw=XPRACTICE.WrapAngle(player.orientation_displayed.yaw)					
						player.target_orientation_displayed.yaw=player.target_orientation_displayed.yaw+turnvector*elapsed*TURN_SPEED
						player.target_orientation_displayed.yaw=XPRACTICE.WrapAngle(player.target_orientation_displayed.yaw)
						
						--print("turning",player.target_orientation_displayed.yaw)
						if(not keys.lmouse.current)then
							camera.orientation.yaw=camera.orientation.yaw+turnvector*elapsed*TURN_SPEED
							camera.orientation.yaw=XPRACTICE.WrapAngle(camera.orientation.yaw)
						end
					end
				end
			end
			
			local vectorx,vectory			
			vectorx,vectory=self:GetCharacterMovementInputUnitVector()
			if(#player.combatmodule.auras.forcedmovement>0)then			
				local aura=player.combatmodule.auras.forcedmovement[#player.combatmodule.auras.forcedmovement]
				player.backpedal=aura.backpedal
			else				
				player.backpedal=(vectorx<0)
			end
			
			player.lockorientationtocamera=(vectorx~=0 and vectory==0 and (xcameradelta~=0 or ycameradelta~=0))
			--player.lockorientationtocamera=(player.lockorientationtocamera or (player.position.z>0))
			
			if(vectorx==0 and vectory==0)then
				player.ai.targetposition=nil
			else
				player.ai.targetlocation={}			
				local yaw=player.orientation.yaw
				
				vectorx,vectory=XPRACTICE.Transform_Rotate2D(vectorx,vectory,yaw,0,0)
				local movespeed=player:GetFinalMoveSpeed()
				player.ai.targetposition={x=player.position.x+vectorx*movespeed*2,y=player.position.y+vectory*movespeed*2}
			end
		end
			

		--------- MOBCLICKZONES and NAMEPLATES -------------------------------
		
		-- target enemy on mouseup, not mousedown
		-- don't target enemy if:
			-- if both mousebuttons were pressed before either button was released
			-- if mouse moves off of enemy before mouseup (or enemy moves away from mouse)
			-- if mouse moves more than a certain distance between mousedown and mouseup
			-- don't target enemy even if mouse moves back (maybe not feasible to implement)
			
		
		if(self.player)then
			local globalx,globaly
			--print("nameplates:",#self.environment.nameplates)
			if(mousepressed)then
				local nameplates={unpack(self.environment.nameplates)}
				table.sort(nameplates,function(a,b)return a.zsort>b.zsort end)
				globalx,globaly=GetCursorPosition()
				local foundmob=false
				for i=1,#nameplates do					
					local nameplate=nameplates[i]
					if(nameplate:IsUnderMouse(globalx,globaly))then						
						self.potentialclicktarget=nameplate
						self.potentialclicktargetcoordinates={x=globalx,y=globaly}
						foundmob=true
						break
					end
				end
				if(not foundmob)then
					local mobclickzones={unpack(self.environment.mobclickzones)}
					table.sort(mobclickzones,function(a,b)
						--print(a.mob.nameplate.zsort,b.mob.nameplate.zsort)
						return a.zsort>b.zsort
					end)
					for i=1,#mobclickzones do
						local mobclickzone=mobclickzones[i]
						--local nameplate=mobclickzone.mob.nameplate
						if(mobclickzone:IsUnderMouse(globalx,globaly))then
							self.potentialclicktarget=mobclickzone
							self.potentialclicktargetcoordinates={x=globalx,y=globaly}
							foundmob=true
							break
						end
					end
				end
			end
			
			if(self.potentialclicktarget)then 
				if(not globalx)then globalx,globaly=GetCursorPosition() end
				if(not self.potentialclicktarget:IsUnderMouse(globalx,globaly))then
					self.potentialclicktarget=nil
				end
				if(keys.lmouse.current and keys.rmouse.current)then
					self.potentialclicktarget=nil
				end
			end
			if(self.potentialclicktarget)then 
				local distx=globalx-self.potentialclicktargetcoordinates.x
				local disty=globaly-self.potentialclicktargetcoordinates.y
				local distsqr=distx*distx+disty*disty
				--TODO: does mouse position scale properly with screen size?
				--print(globalx,globaly)
				if(distsqr>4*4)then
					self.potentialclicktarget=nil
				end
			end			
			if(self.potentialclicktarget)then 
				if(mousereleased)then
					local button=1;	if(keys.rmouse.released)then button=2 end
					self.potentialclicktarget.mob:OnClick(self.player,self.environment,button)
					self.potentialclicktarget=nil				
				end						
			end
			
			
			
		end
		
		
		---------- JUMP KEY -------------------------------------
		if(self.player)then
			if(keys.jump.pressed)then
				if(not self.player:IsInMidair())then
					if(#self.player.combatmodule.auras.forcedmovement==0)then
						if(self.player:IsIncapacitated()==false)then
							--TODO: move to AI?
							self.player.velocity.z=self.player.jumpvelocity.z
							self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.JumpStart)
							--self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.JumpLandRun)
						end
					end
				end
			end
		end
		
		
		---------- TOGGLE RUN/WALK KEY -------------------------
		if(self.player)then
			if(keys.togglerunwalk.pressed)then
				self.player.walking=not self.player.walking
			end
		end
		
		
		---------- ESC KEY -------------------------------------
		if(self.player)then
			if(keys.esc.pressed)then
				--TODO: move to AI?
				self.player:SetTargetMob(nil)
				self.environment:SelectMob(nil)
			end
		
		end
	
		
		--------- MIDDLE MOUSE BUTTON --------------------------
		-- TODO: move to spellcasting block
		if(keys.mmouse.pressed)then
			if(self.player:IsIncapacitated()==false)then
				--print("Roll",self:GetCharacterMovementInputUnitVector())
				
				--XPRACTICE.TEMP_CastSpellOnTargetMobile(self.player,XPRACTICE.Spell_Roll,self.player)
				--TODO: self.player.spellbook.roll
				--local spell_roll=XPRACTICE.Spell_Roll.new()
				--spell_roll:Setup()
				local spell_roll=self.player.combatmodule.spellbook.roll
				local queuepointer=spell_roll:NewQueue()
				queuepointer.castercombat=self.player.combatmodule
				local errorcode=self.player.combatmodule:TryQueue(queuepointer)
			end			
		end
		
		
		
	end
	
	
		
	function class:GetCharacterMovementInputUnitVector()
		-- this function assumes the camera is facing "right" (angle 0 radians)
		local environment_gameplay=self.environment.game.environment_gameplay		
		local vectorx,vectory=0,0
		local fwdvector=false
		local keys=self.environment.game.keys

				
		if(keys.leftA.current or (keys.turnQ.current and keys.rmouse.current))then		vectory=vectory+1		end		
		if(keys.rightD.current or (keys.turnE.current and keys.rmouse.current))then	vectory=vectory-1		end	
		if(keys.downS.current)then			vectorx=vectorx-1		end	
		if(keys.upW.current)then			fwdvector=true		end
		----TODO: figure out what we want to do with middle mouse button (hint: we want to dodgeroll)
		--if(self.environment.game.keys.mmouse.current)then			fwdvector=true		end
		if(self.environment.game.keys.lmouse.current and self.environment.game.keys.rmouse.current)then			fwdvector=true		end	--LMB+RMB
		if(fwdvector)then
			vectorx=vectorx+1
		end		
		return vectorx,vectory				
	end		
end

-- YOU ARE LOOKING AT THE playerCONTROLLER CLASS.
-- playerCHARACTER IS FURTHER UP.