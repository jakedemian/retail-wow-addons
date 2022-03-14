--TODO:
-- maybe replace smoldering ire graphic with sins+suffering graphic, still not identical but pretty close
-- smoldering ire explosion effect?
-- maybe blood price explosion effect?
-- maybe shattering pain explosion effect?
-- 9fx_raid1_denathrius_massacre_swordcast trail behind sword?
-- fatal finesse ghost flourish done, maybe ghost flourish explosion too?
-- raid markers on FF players?
-- smoother seed soak scaling animation?
--------
-- disable debug features
--------
-- later: spell visual effects are displayed even when modelsceneframe isn't!
-- later: re-enable guild broadcast success message?


do
	local super=XPRACTICE.Scenario
	XPRACTICE.INDIGNATION.Scenario=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.Scenario
	
	
	local FLOORZ=-0.425*(1.8/3)
	
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		
		self.savedataname="INDIGNATION"

		self.firstround=true
		self.phaseinprogress=false
		self.phasecomplete=false
		self.currentphase=2
		self.mirrorsactive=true

		self.phase3tempobjs={}
		self.debugobjects={}
		
		self.player=nil
		self.startbutton=nil
		self.lastmovetime=0
		
		self.playershouldntsoak=false
		
		self.events={}
		self.stopallevents=false
		
		self.edgelines={}
		
		self.currenttick=0
		self.previoustick=0
	end
	

	function class:GetScheduleClass()
		if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==1)then
			return XPRACTICE.INDIGNATION.Phase3Schedule_Type1
		else
			return XPRACTICE.INDIGNATION.Phase3Schedule_Type2
		end
	end

	function class:Populate()
		super.Populate(self)
		
		local scenario=self

		XPRACTICE.INDIGNATION.Phase3Schedule_Type1.phase3starttime=XPRACTICE.INDIGNATION.Phase3Schedule_Type1.DEFAULTSTARTTIME
		XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=XPRACTICE.INDIGNATION.Phase3Schedule_Type2.DEFAULTSTARTTIME
	
		self.phaseinprogress=false
		self.phasetime=0
		
		self.buttongroup={}
		self.buttongroup[1]={}		-- Options/Go
		self.buttongroup[2]={}		-- Restart
		self.buttongroup[3]={}		-- Brez/Restart
		self.buttongroup[4]={}		-- Starting time
		self.buttongroup[5]={}		-- Mirror group?
		self.buttongroup[6]={}		-- DBM announcement
		
		self.markers={}
		
		self.sinsofthepast={}
		self.sinpoints={}
		self.sinorb_cosmetics={}
		self.solutionpoints={}
		self.weblines={}
		self.webdots={}
		
		self.allplayers={}
		self.mirrorgroup={}
		self.rangedgroup={}
		self.tanks={}
		self.shatteringpaincount=0
		self.fatalfinessecount=0
		self.ravagecount=0 -- don't increment this until the cast ends
		self.seeds={}
		self.ravagetelegraphs={}	-- keep track of these so we can clear them and sync them up later
										-- (also so we can delete the 3rd telegraph when denathrius dies)
		
		
		self.desolationtimer=0
		self.bossdead=false
		
		self.mirrorcamp={x=0,y=0}
		self.rangedcamp={x=0,y=0}
		self.fakerangedcamp={x=0,y=0} -- used for player hint arrow in case player isn't standing with the rest of ranged during Approach command
		self.bosscamp={x=0,y=0}
				
		self.ffmirrorcamp={{x=0,y=0},{x=0,y=0}}
		self.ffrangedcamp={{x=0,y=0},nil}
		
		self.cheatdeathcount=0
		self.dontincrementcheatdeath=false
		self.stoodinfiretime=0
		
		self.shatteringpaincallback=nil
		self.bloodpricecallback=nil
		self.fatalfinessecallback=nil
		self.dropseedscallback=nil
		self.previousdropseedscallback=nil	--in case we need to finish soaking after a knockback
		self.aftersoakcallback=nil
		
		self.reversedoubleseedcount=0
		self.reversedoubleseedtracker={}
		XPRACTICE.INDIGNATION.Spell_FatalFinesse.InitFatalFinesseCounts(self)
		
		
		self.hitbysurprisefinalattack=false
		self.wipereason=nil
		
		local scenario=self
		local gamemenu=XPRACTICE.GameMenu.new()
		gamemenu:Setup(self.game.environment_gameplay,self.game.SCREEN_WIDTH/2-180/2,self.game.SCREEN_HEIGHT/2-270/2)
		self.gamemenu=gamemenu
		
		self.collision=XPRACTICE.INDIGNATION.Collision.new(scenario)	-- no setup
		
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0.5,1,-0.25)
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0.5,1,0)
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0.5,1,-2)
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0.5,1,-2)
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0.5,1,-2)
		self.game.environment_gameplay.modelsceneframe:SetLightDirection(.2,0,-1)
		
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0,1,0)
		--self.game.environment_gameplay.modelsceneframe:SetLightPosition(0,0,10)
		--local ambient=1.0
		--local diffuse=1.0
		--self.game.environment_gameplay.modelsceneframe:SetLightAmbientColor(ambient,ambient,ambient)
		--self.game.environment_gameplay.modelsceneframe:SetLightDiffuseColor(diffuse,diffuse,diffuse)

		--self.game.environment_gameplay.modelsceneframe:SetLightType(2)
		--self.game.environment_gameplay.modelsceneframe:SetLightVisible(true)
		--self.game.environment_gameplay.modelsceneframe:SetLightDirection(0,1,0)
		--self.game.environment_gameplay.modelsceneframe:SetLightPosition(0,0,1)

		-- local ambient=0.7
		-- local diffuse=0.8

		--TODO: if start-from-midway's first action is Shattering Pain, denath must face in the correct direction or knockback will be 3yd off		
			-- (this is not currently the case for any start-from-midway point)
		if(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway==0 or XPRACTICE_SAVEDATA.INDIGNATION.mirrorgroup==false)then
			self:SetNormalLights()
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.mirrorgroup)then
			self:SetMirrorLights()
		end

		
		local button

		local massacrecontroller=XPRACTICE.INDIGNATION.MassacreController.new()
		massacrecontroller.scenario=self
		massacrecontroller:Setup(self.game.environment_gameplay)
		self.massacrecontroller=massacrecontroller
		local ravagecontroller=XPRACTICE.INDIGNATION.RavageController.new()
		ravagecontroller.scenario=self
		ravagecontroller:Setup(self.game.environment_gameplay)
		self.ravagecontroller=ravagecontroller
		
		
		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=150,z=0}
		label:SetSize(600,300)
		label:SetText("")
		self.statuslabel=label
		
		local label=XPRACTICE.FadingLabel.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=175,z=0}
		label:SetSize(600,300)
		label.displayobject.drawable.fontstring:SetFont("Fonts\\FRIZQT__.TTF",20,"OUTLINE")
		--label:SetText("Next: Seeds > FAST soak > knockback")
		self.forecastlabel=label		

		local label=XPRACTICE.Label.new()		
		label:Setup(self.game.environment_gameplay)
		label.position={x=self.game.SCREEN_WIDTH/2-600/2,y=540,z=0}
		label:SetSize(600,300)
		label:SetText("")
		label.visible=true
		label.alpha=1
		--label.displayobject.drawable.fontstring:SetScale(3)
		label.displayobject.drawable.fontstring:SetFont("Fonts\\FRIZQT__.TTF",40,"OUTLINE")
		label.displayobject.drawable:SetFrameLevel(210)
		self.clocklabel=label


		self.debugbuttonx=self.game.SCREEN_WIDTH/2-25
		self.debugbuttony=104
				
	
		--self:QuickSonar(0,0,0,math.pi)
		
		self.descenttelegraphs={}

		local mob,obj
		local player
		
		denathrius=XPRACTICE.INDIGNATION.SireDenathrius.new()
		denathrius:Setup(self.game.environment_gameplay)
		denathrius.displayobject.drawable:SetSheathed(false)
		
		-- denathrius.orientation.yaw=math.pi*1.5;denathrius.orientation_displayed.yaw=math.pi*1.5
		--denathrius.position={x=0,y=-18,z=0}
		--denathrius.position={x=-20,y=0,z=0}		
		denathrius.position.x=-72.5		
		denathrius.position.y=3
		--facing EAST-ish
		denathrius.orientation.yaw=-2.89+math.pi;denathrius.orientation_displayed.yaw=denathrius.orientation.yaw
		denathrius.scenario=self
		self.denathrius=denathrius		
		
		remornia=XPRACTICE.INDIGNATION.Remornia.new()
		remornia:Setup(self.game.environment_gameplay)
		remornia.position={x=-62.82,y=4.97,z=0}
		remornia.orientation.yaw=2.023702;remornia.orientation_displayed.yaw=remornia.orientation.yaw
		remornia.scenario=self
		self.remornia=remornia			
		
		cabalist=XPRACTICE.INDIGNATION.CrimsonCabalist.new()
		cabalist:Setup(self.game.environment_gameplay)
		cabalist.position.x=-65
		cabalist.position.y=10
		cabalist.orientation.yaw=-math.pi/2;cabalist.orientation_displayed.yaw=cabalist.orientation.yaw
		cabalist.scenario=self
		self.cabalist=cabalist		
		
		-- we use a separate mob for FF so we can cast while boss is already casting
			-- pick a mob class at random.  we can't use Mob because the game doesn't know how to handle FileID(1) after rebooting
				-- (function crashes silently, no lua error!)
		local obj=XPRACTICE.INDIGNATION.CrimsonCabalist.new()
		obj:Setup(self.game.environment_gameplay)
		obj.alpha=0		-- invisible bunny
		self.FFbunny=obj

		for i=1,20 do
			local ghost
			ghost=XPRACTICE.INDIGNATION.PlayerGhost.new()
			ghost.index=i
			ghost:Setup(self.game.environment_gameplay)
			ghost.cpu=true
			if(i==1)then
				ghost.position={x=-64.06,y=7.23,z=0}
			elseif(i==2)then
				ghost.position={x=-68.86,y=3.84,z=0}
			elseif(i<=10)then
				ghost.position={x=XPRACTICE.RandomNumberInBetween(-75.03,-64.31),y=XPRACTICE.RandomNumberInBetween(3.65,12.44),z=0}
			elseif(i<=20)then
				ghost.position={x=XPRACTICE.RandomNumberInBetween(-72.06,-44.13),y=XPRACTICE.RandomNumberInBetween(-9.2,0.06),z=0}
			else
				ghost.position={x=-72.5+i*2,y=0,z=0}
			end			
			local angle
			if(i==1)then
				angle=math.atan2(remornia.position.y-ghost.position.y,remornia.position.x-ghost.position.x)
			elseif(i>=3 and i<=10)then
				angle=math.atan2(cabalist.position.y-ghost.position.y,cabalist.position.x-ghost.position.x)
			else
				angle=math.atan2(denathrius.position.y-ghost.position.y,denathrius.position.x-ghost.position.x)
			end

			ghost.orientation.yaw=angle;ghost.orientation_displayed.yaw=ghost.orientation.yaw
			ghost.mirrorrealm=false
			ghost.scenario=self
			tinsert(self.allplayers,ghost)
			if(i<=2)then 
				tinsert(self.tanks,ghost)
				tinsert(self.mirrorgroup,ghost)
			elseif(i<=10)then
				tinsert(self.mirrorgroup,ghost)
			else
				tinsert(self.rangedgroup,ghost)
			end
			--ghost.combatmodule:SetTargetMob(denathrius)
			--ghost.combatmodule:StartAutoAttacking()
		end
		

		
		--mob=XPRACTICE.Mob.new()
		player=XPRACTICE.PlayerCharacter.new()		
		player:Setup(self.game.environment_gameplay)
		player.displayobject.drawable:SetSheathed(false) 
		--player.orientation.yaw=math.pi*1.5;player.orientation_displayed.yaw=math.pi*1.5
		--player.position={x=0,y=-18,z=0}
		player.position={x=-72.5,y=-5.5,z=0}	
		player.mirrorrealm=false		


		--facing SOUTH
		player.orientation.yaw=math.pi*.5;player.orientation_displayed.yaw=math.pi*.5
		player.scenario=self
		self.player=player		
		tinsert(self.allplayers,player)
	--	player.position={x=0,y=0,z=0}--!!!
	

	


		self.game.environment_gameplay.cameramanager.camera.focus=player
		self.game.environment_gameplay.cameramanager.camera.orientation.yaw=player.orientation.yaw
		self.game.environment_gameplay.cameramanager.camera.orientation.pitch=math.pi*0.05
		--self.game.environment_gameplay.cameramanager.camera.cdist=30
		self.game.environment_gameplay.cameramanager.camera.cdist=60
		
		
		local lossofcontrolalert=XPRACTICE.LossOfControlAlert.new()
		self.lossofcontrolalert=lossofcontrolalert
		lossofcontrolalert:Setup(self.game.environment_gameplay)
		lossofcontrolalert.position={x=self.game.SCREEN_WIDTH/2-180/2,y=self.game.SCREEN_HEIGHT/2,z=0}
		lossofcontrolalert.focus=player

		
		--TODO: move elsewhere
		local maincastingbar=XPRACTICE.CastingBar.new()
		self.maincastingbar=maincastingbar
		maincastingbar:Setup(self.game.environment_gameplay)
		maincastingbar.position={x=self.game.SCREEN_WIDTH/2-196/2,y=150,z=0}
		maincastingbar.focus=player
		
		
		
		local controller=XPRACTICE.PlayerController.new()
		controller:Setup(self.game.environment_gameplay,player,self.game.environment_gameplay.cameramanager.camera)

		self.mirrors={}		
		local mirrorscale=2
		local mirrorz=-1.05
		local mirror
		for i=0,3 do

			local dist=95			
			if(i==0 or i==2)then dist=90 end
			local angle=i*math.pi/2+math.pi
			mirror=XPRACTICE.INDIGNATION.Mirror.new()
			mirror:Setup(self.game.environment_gameplay,math.cos(angle)*dist,math.sin(angle)*dist,mirrorz*mirrorscale);mirror.scale=mirrorscale			
			mirror.orientation_displayed.yaw=angle
			mirror.visiblefromallphases=true
			--mirror.alpha=0
			tinsert(self.mirrors,mirror)
		end
		local scenerycontroller=XPRACTICE.INDIGNATION.SceneryAlphaController.new()
		scenerycontroller:Setup(self.game.environment_gameplay)
		scenerycontroller.objs=self.mirrors		
		self.scenerycontroller_mirrors=scenerycontroller		
		local floorobj
		floorobj=XPRACTICE.INDIGNATION.Floor_InnerCircle.new()
		floorobj:Setup(self.game.environment_gameplay)
		self.floor_innercircle=floorobj


		local floorobj
		floorobj=XPRACTICE.INDIGNATION.Floor_OuterWings.new()
		floorobj:Setup(self.game.environment_gameplay)
		self.floor_outerwings=floorobj				
		local scenerycontroller=XPRACTICE.INDIGNATION.SceneryAlphaController.new()
		scenerycontroller:Setup(self.game.environment_gameplay)
		scenerycontroller.multisolid=floorobj		
		self.scenerycontroller_outerwings=scenerycontroller
		--self.scenerycontroller_outerwings:SetDesaturation(1)
		
		
		local floorobj
		floorobj=XPRACTICE.INDIGNATION.Floor_CornerPlatforms.new()
		floorobj:Setup(self.game.environment_gameplay)
		self.floor_cornerplatforms=floorobj			
		local scenerycontroller=XPRACTICE.INDIGNATION.SceneryAlphaController.new()
		scenerycontroller:Setup(self.game.environment_gameplay)
		scenerycontroller.multisolid=floorobj		
		self.scenerycontroller_cornerplatforms=scenerycontroller		
		
		

		





		
		

		

		XPRACTICE.INDIGNATION.Layout.CreateEdgeDetectionLines(self)	

		--XPRACTICE.INDIGNATION.Layout.CreateFloorOutline(self)
		--XPRACTICE.INDIGNATION.Layout.CreateFloorOutline(self,1)
		--XPRACTICE.INDIGNATION.Layout.CreateFloorOutline(self,2)
		--XPRACTICE.INDIGNATION.Layout.CreateFloorOutline(self,3)
		--XPRACTICE.INDIGNATION.Layout.CreateOuterPlatformsOutline(self)
		--XPRACTICE.INDIGNATION.Layout.CreateInnerCircleOutline(self)
		-- XPRACTICE.INDIGNATION.Layout.CreateInnerCircleOutline(self,1)
		--XPRACTICE.INDIGNATION.Layout.CreateInnerCircleOutline(self,2)
		-- XPRACTICE.INDIGNATION.Layout.CreateInnerCircleOutline(self,3)

		
			


	




		--


		-- See backups folder for the old VSK list.

		-- (131724) mainhand large red spiky sword
	
		
		 -- local msf=self.game.environment_gameplay.modelsceneframe
		-- -- local remo=msf:CreateActor()
		-- -- remo:SetModelByCreatureDisplayID(96665)
		-- -- remo:SetPosition(0,0,1)
		-- -- remo:SetScale(2)
		-- -- remo:SetAlpha(1)
		-- -- remo:Show()
		-- local denath=msf:CreateActor()
		-- denath:SetModelByCreatureDisplayID(92797)
		-- denath:SetPosition(0,0,0)
		-- denath:SetScale(1)
		-- denath:SetAlpha(1)		
		-- denath:SetAnimation(91)
		-- -- remo:AttachToMount(denath,91)
		-- -- remo:SetAnimation(1)

		
		
		-- --!!!
		-- local obj=XPRACTICE.INDIGNATION.Ravage1Guideline.new()
		-- obj:Setup(self.game.environment_gameplay)
		
		

		
	
		
		
		--TODO: HP decreases as time passes
		local nameplate=XPRACTICE.Nameplate.new()
		nameplate.hp_TEMP=0.377
		nameplate:Setup(self.game.environment_gameplay,denathrius)
		nameplate:SetText("Sire Denathrius")
		local castingbar=XPRACTICE.CastingBarTiny.new()
		castingbar:Setup(self.game.environment_gameplay,0,0,0)
		castingbar.focus=denathrius
		castingbar:AnchorToNameplate(nameplate)
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(self.game.environment_gameplay,denathrius)	
		


		local nameplate=XPRACTICE.Nameplate.new()
		nameplate.hp_TEMP=0.02
		nameplate:Setup(self.game.environment_gameplay,cabalist)
		nameplate:SetText("Crimson Cabalist")
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(self.game.environment_gameplay,cabalist)	
				
		local nameplate=XPRACTICE.Nameplate.new()
		nameplate.hp_TEMP=0.675
		nameplate:Setup(self.game.environment_gameplay,remornia)
		nameplate:SetText("Remornia")
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(self.game.environment_gameplay,remornia)
						
		
		local hintarrow=XPRACTICE.INDIGNATION.HintArrow.new()
		hintarrow.scenario=self
		hintarrow:Setup(self.game.environment_gameplay)
		
		XPRACTICE.BossDebugButton.ResetPosition()
		self.bossdebugbuttons={}
		local button
		
		self.debugstopbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Debug_StopEvents,self.denathrius)
		self.debugbosscampbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Debug_MoveBossCamp,self.denathrius)
		self.debugrangedcampbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Debug_MoveRangedCamp,self.denathrius)
		self.debugplaceringbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Debug_PlaceRing,self.denathrius)
		self.removeringbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Debug_RemoveRing,self.denathrius)
		XPRACTICE.BossDebugButton.CarriageReturn()
		
		--self.getplayerpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_GetPlayerPosition,self.denathrius)
		self.getplayerpositionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_GetPlayerPosition,self.FFbunny)
		self.crescendobutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Crescendo,self.cabalist)		
		self.indignationbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Indignation,self.denathrius)
		self.shatteringpainbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_ShatteringPain,self.denathrius)
		self.bloodpricebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_BloodPrice,self.denathrius)
		self.fatalfinessebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_FatalFinesse,self.FFbunny)
		--self.fatalfinessebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_FatalFinesse,self.denathrius)
		self.sinisterreflectionbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_SinisterReflection,self.denathrius)
		self.crescendo2button=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Crescendo,self.denathrius)

		XPRACTICE.BossDebugButton.CarriageReturn()
		self.massacrebutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Massacre,self.denathrius)
		
		


		-- self.spawnbutton2=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_Massacre_Spawn,self.denathrius)
		-- XPRACTICE.BossDebugButton.CarriageReturn()
		-- self.animawebbutton=XPRACTICE.BossDebugButton.QuickButton(self.game.environment_gameplay,self,XPRACTICE.INDIGNATION.Spell_AnimaWeb,self.denathrius)

		--local dist=10*4	-- 10*4 matches the .pngs we're using
		--local dist=6*4		-- 6*4 works better with xp's limited FOV (and matches the logs we're using)
		if(XPRACTICE.Config.Indignation.WorldMarkerREDXPosition)then
			obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(456041)	-- raid_ui_fx_red
			obj.position=XPRACTICE.Config.Indignation.WorldMarkerREDXPosition
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0
		end
		if(XPRACTICE.Config.Indignation.WorldMarkerPURPLEDIAMONDPosition)then
			obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(456039)	-- raid_ui_fx_purple
			obj.position=XPRACTICE.Config.Indignation.WorldMarkerPURPLEDIAMONDPosition
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0
		end
		if(XPRACTICE.Config.Indignation.WorldMarkerGREENTRIANGLEPosition)then
			obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(456037)	-- raid_ui_fx_green
			obj.position=XPRACTICE.Config.Indignation.WorldMarkerGREENTRIANGLEPosition
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0
		end
		if(XPRACTICE.Config.Indignation.WorldMarkerYELLOWSTARPosition)then
			obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(456043)	-- raid_ui_fx_yellow
			obj.position=XPRACTICE.Config.Indignation.WorldMarkerYELLOWSTARPosition
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0		
		end
		if(XPRACTICE_SAVEDATA.INDIGNATION.dancetype==2 and XPRACTICE.Config.Indignation.WorldMarkerSILVERMOONPosition)then
			obj=XPRACTICE.WoWObject.new();obj:Setup(self.game.environment_gameplay)		
			obj.displayobject.drawable:SetModelByFileID(1014628)	-- raid_ui_fx_silver
			obj.position=XPRACTICE.Config.Indignation.WorldMarkerSILVERMOONPosition
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=2.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=2.0	
		end
		
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Start")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 					
					scenario.phaseinprogress=true
					scenario:EnableButtons(scenario.buttongroup[1],false)
					scenario:EnableButtons(scenario.buttongroup[4],false)
					scenario:EnableButtons(scenario.buttongroup[5],false)
					scenario:ClickButtonAfterDelay(scenario.indignationbutton,0.0)
				end
			end)
		tinsert(self.buttongroup[1],button)
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=200-80,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Options")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(button=="LeftButton" and down)then 					
					self:EnableMouse(false)
					scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario_Options)
				end
			end)
		tinsert(self.buttongroup[1],button)			

		
		
		
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Restart")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 					
					self:EnableMouse(false)
					scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
				end
			end)
		tinsert(self.buttongroup[2],button)		
		self:EnableButtons(self.buttongroup[2],false)		
		
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2-100,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Brez")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 								
					self:EnableMouse(false)
					scenario:EnableButtons(scenario.buttongroup[3],false)
					scenario:Brez()
				end
			end)
		tinsert(self.buttongroup[3],button)		
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-150/2+100,y=200,z=0}
		button:SetSize(150,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Restart")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 					
					self:EnableMouse(false)
					scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
				end
			end)
		tinsert(self.buttongroup[3],button)				
		self:EnableButtons(self.buttongroup[3],false)			
		
		
		
		local label
		label=XPRACTICE.Label.new()
		label:Setup(self.game.environment_gameplay)
		label.position={x=-50,y=650,z=0}
		label:SetSize(250,50)
		label:SetText("Start time:")
		tinsert(self.buttongroup[4],label)
		for i=0,6 do
			button=XPRACTICE.Button.new()
			button:Setup(self.game.environment_gameplay)
			button.position={x=-50+150/2,y=650-(i+.75)*42,z=0}
			button:SetSize(200,35)
			button:SetLockedStartingAlpha(1.0)
			local text
			if(i==0)then
				text="Start of phase 3"
			elseif(i<6)then
				text="Fatal Finesse "..tostring(i)
			else
				text="Fatal Finesse 6+7"
			end
			button:SetText(text)
			button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
					if(down)then 					
						self:EnableMouse(false)
						XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway=i
						scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
					end
				end)			
			if(i==XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway)then
				button:Select(true)
			end
			tinsert(self.buttongroup[4],button)
			--print(600-(i+1)*70)
		end		
		-- local label
		-- label=XPRACTICE.Label.new()
		-- label:Setup(self.game.environment_gameplay)
		-- label.position={x=-50,y=300,z=0}
		-- label:SetSize(250,50)
		-- label:SetText("Hint arrow:")
		-- tinsert(self.buttongroup[4],label)
		self.hintarrowbuttons={}
		-- for i=1,2 do
			-- button=XPRACTICE.Button.new()
			-- button:Setup(self.game.environment_gameplay)
			-- button.position={x=-50+150/2,y=300-(i-1+.75)*42,z=0}
			-- button:SetSize(67,35)
			-- button:SetLockedStartingAlpha(1.0)
			-- local text,value
			-- if(i==1)then
				-- text="On"
				-- value=true				
			-- else
				-- text="Off"
				-- value=false
			-- end
			-- self.hintarrowbuttons[i]=button
			-- button:SetText(text)
			-- button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
					-- if(down)then 					
						-- self:EnableMouse(false)
						-- XPRACTICE_SAVEDATA.INDIGNATION.hintarrow=value
						-- if(i==1)then
							-- scenario.hintarrowbuttons[1]:Select(true)
							-- scenario.hintarrowbuttons[2]:Select(false)
						-- else
							-- scenario.hintarrowbuttons[1]:Select(false)
							-- scenario.hintarrowbuttons[2]:Select(true)
						-- end
					-- end
				-- end)			
			-- if(value==XPRACTICE_SAVEDATA.INDIGNATION.hintarrow)then
				-- button:Select(true)
			-- end
			-- tinsert(self.buttongroup[4],button)
			-- --print(600-(i+1)*70)
		-- end		
		-- self:EnableButtons(self.buttongroup[4],true)
	
		
		local label
		label=XPRACTICE.Label.new()
		label:Setup(self.game.environment_gameplay)
		label.position={x=200,y=650,z=0}
		label:SetSize(250,50)
		label:SetText("Player group:")
		tinsert(self.buttongroup[5],label)
		for i=0,1 do
			button=XPRACTICE.Button.new()
			button:Setup(self.game.environment_gameplay)
			button.position={x=200+150/2,y=650-(i+.75)*42,z=0}
			button:SetSize(150,35)
			button:SetLockedStartingAlpha(1.0)
			local text,mirrorsetting
			if(i==0)then	
				text="Ranged"
				mirrorsetting=false
			else
				text="Mirror"
				mirrorsetting=true
			end
			button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
					if(down)then 					
						self:EnableMouse(false)
						XPRACTICE_SAVEDATA.INDIGNATION.mirrorgroup=mirrorsetting
						--print("mirror",mirrorsetting,i)
						scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
					end
				end)				
			if(mirrorsetting==XPRACTICE_SAVEDATA.INDIGNATION.mirrorgroup)then
				button:Select(true)
			end			
			button:SetText(text)
			tinsert(self.buttongroup[5],button)
		end
		if(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway>0)then
			self:EnableButtons(self.buttongroup[5],true)	
			player.mirrorrealm=XPRACTICE_SAVEDATA.INDIGNATION.mirrorgroup
			self:GetScheduleClass().StartFromMidway(self,XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway)			
			self.scenerycontroller_mirrors.fadestarttime=0
			self.scenerycontroller_mirrors.fadestoptime=0
			XPRACTICE.INDIGNATION.Spell_Indignation.CreateIndignationEffects(self)
			self.currentphase=3
			self.remornia.mobclickzone:Die()
			self.remornia.nameplate:Die()
			self.remornia:Die()			
			self.cabalist.mobclickzone:Die()
			self.cabalist.nameplate:Die()			
			self.cabalist:Die()
		else
			self:EnableButtons(self.buttongroup[5],false)	
		end
		
		button=XPRACTICE.Button.new()		
		button:Setup(self.game.environment_gameplay)
		button.position={x=self.game.SCREEN_WIDTH/2-500/2,y=400,z=0}
		button:SetSize(500,60)
		button:SetLockedStartingAlpha(1.0)
		button:SetText("Announce your victory to the guild!")
		button.displayobject.drawable:SetScript("OnClick",function(self,button,down)
				if(down)then 					
					--self:EnableMouse(false)
					--scenario.game:LoadScenarioByClass(XPRACTICE.INDIGNATION.Scenario)
					C_ChatInfo.SendAddonMessage("D4", "GCE\t".."2424".."\t6\t0\t".."10 minutes".."\t".."16".."\t".."0".."\t".."Sire Denathrius", "GUILD")
					scenario.statuslabel:SetText("Guildmates who have DeadlyBossMods installed\nhave been sent a notification of your victory.",20.0)
					scenario:EnableButtons(scenario.buttongroup[6],false)
					
				end
			end)
		tinsert(self.buttongroup[6],button)				
		self:EnableButtons(self.buttongroup[6],false)
		

		
		
	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)

		self.previoustick=self.currenttick 						-- only used as a substitute for Elapsed during AKP.
		self.currenttick=self.game.environment_gameplay.localtime

		if(self.player)then			
			self.collision:CheckMirrors()
		end
		
		if(self.phaseinprogress and not self.bossdead)then
			self.phasetime=self.phasetime+elapsed
			if(self.denathrius)then
				--TODO LATER: why does this still work even though hp bar is based on 43.28, not 51.28?
									 -- (because we start from Indignation start cast, not end cast)
				local TOTALPHASETIME=196.72+XPRACTICE.Config.Indignation.RavageReflectionDelay
				self.denathrius.nameplate.hp_TEMP=0.377 - (0.377 * self.phasetime/TOTALPHASETIME)
				if(math.random()<.01)then
					self.denathrius.nameplate.displayobject:SetFillPoints()
				end
			end
		end
		
		if(self.denathrius and self.bossdead)then
			self.denathrius.targetable=false
		end

		---------------------------------------------------------------
		-- CLOCK
		---------------------------------------------------------------
		if(self.phaseinprogress and not self.bossdead)then
			local displayedtime=nil
			local displayedtimestring=""
			local schedule=self:GetScheduleClass()
			if(XPRACTICE_SAVEDATA.INDIGNATION.clock==1)then
				displayedtime=self.phasetime
			elseif(XPRACTICE_SAVEDATA.INDIGNATION.clock==2)then
				displayedtime=self.phasetime+(403.28)
			elseif(XPRACTICE_SAVEDATA.INDIGNATION.clock==3)then
				displayedtime=60*10+02.81-(self.phasetime+403) -- time until FF7 wipe, about 1.81 seconds after the scenario actually ends
				
			end
			if(displayedtime~=nil)then
				local minutes=math.floor(displayedtime/60)
				local seconds=string.format("%02d",math.floor(displayedtime-minutes*60))
				displayedtimestring=tostring(minutes..":"..seconds)
			end
			self.clocklabel:SetText(displayedtimestring)
			
		end

		---------------------------------------------------------------
		--OUT OF BOUNDS CHECK
		---------------------------------------------------------------
		
		if(self.player)then
			self.collision:OutOfBoundsCheck()
			self.collision:DesolationCheck(elapsed)
			self.collision:NeutralizeCheck()
		end
		
		
		
		------------------------------------------------------------------------------
		-- MENU BUTTONS
		------------------------------------------------------------------------------	
	
		

		
		
		------------------------------------------------------------------------------
		-- TIMED EVENTS
		------------------------------------------------------------------------------	
		-- process this loop forward so events are executed usually in the order they are queued
		
		for i=1,#self.events do
			local event=self.events[i]
			if(self.stopallevents==false or event.alwayshappens)then
				if(self.game.environment_gameplay.localtime>=event.time)then
					--print("event",event,event.time)
					if(event.button)then
						event.button:BossButtonClick()				
					end
					if(event.func)then
						event.func(self)
					end
					event.dead=true
					--TODO LATER: due to the way spell queues are currently set up, queueing up two buttons on the same frame will overwrite the former spell with the latter
					-- so for now, we break to limit one event per frame
					break
				end
			end
		end

		-- removal loop goes backward as usual
		for i=#self.events,1,-1 do
			if(self.events[i].dead)then
				tremove(self.events,i)
			end
		end
		
		
		for i=#self.seeds,1,-1 do
			if(self.seeds[i].dead)then
				tremove(self.seeds,i)
				if(#self.seeds==1)then
					--print("switch")
					self:SwitchToRemainingSeed()
				elseif(#self.seeds==0)then
					--print("aftersoak")
					if(self.aftersoakcallback)then
						local event={}
						event.time=self.game.environment_gameplay.localtime+0.1
						event.func=function(scenario)					
								scenario:aftersoakcallback()
								scenario.aftersoakcallback=nil							
						end
						--event.alwayshappens=true				
						tinsert(self.events,event)
					end	
				end
			end		
		end
	end
	
	function class:AttemptKillPlayer(killtype,reason,everyframe)
		if(not self.phaseinprogress and not self.hitbysurprisefinalattack)then return end
		
		--ignore Neutralize, etc. while flying through the air
		if(self.hitbysurprisefinalattack and self.player.position.z>0)then return end
		
		--ignore kills if player is already dead
		if(self.player:IsDeadInGame())then 
			-- but if player is crying and gets hit with killtype 1, they play the death animation
			
			if(killtype==1)then
				local auras=self.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.Aura_DeadFromHumiliation)
				if(#auras>0)then
					auras[1]:Die()
					local aura=self.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,self.player.combatmodule,self.localtime)
				end
			end
			return			
		end
		
		if(not self.dontincrementcheatdeath)then
			self.cheatdeathcount=self.cheatdeathcount+1
			self.dontincrementcheatdeath=true
		end
		
		local message=""
		--announce kill if game is in progress		
		if(self.phaseinprogress)then		
			--announce kill even if player can continue after death.
			--however, if player is going to die every frame, don't announce
			--if(everyframe==false or XPRACTICE_SAVEDATA.INDIGNATION.dontdieuntilend==false)then
			--if(everyframe==false)then
			if(true)then
				if(self.bossdead==false)then
					--also don't say anything if denathrius is supposed to be dead
					local i=math.floor(math.random()*3)+1
					if(i==1)then
						message="Brought to heel!"
					elseif(i==2)then
						message="You were never my equal!"
					elseif(i==3)then
						message="Your defiance is ended!"
					end
					self.denathrius:CreateSpeechBubble("\124cffff3f40"..message.."\124r")
				end
			end
		end
		--track cause of 1st death
		if(not self.wipereason)then 
			self.wipereason=reason 			
		end
		--print(self.wipereason,reason )
		--actually kill player, if applicable
		--if(not everyframe)then		
			-- self.cheatdeathcount=self.cheatdeathcount+1
		-- else
			-- self.stoodinfiretime=self.stoodinfiretime+self.currenttick-self.previoustick
			-- --print("!",self.stoodinfiretime)
		-- end
		
		--if(not XPRACTICE_SAVEDATA.INDIGNATION.dontdieuntilend)then
		--if(false)then
		if(true)then
			local killauraclass
			if(killtype==1)then
				killauraclass=XPRACTICE.Aura_DeadInGame
			elseif(killtype==2)then
				killauraclass=XPRACTICE.Aura_DeadFromHumiliation
			else
				killauraclass=XPRACTICE.Aura_DeadInGame
			end		
			local aura=self.player.combatmodule:ApplyAuraByClass(killauraclass,self.player.combatmodule,self.localtime)
			--self.stopallevents=true
			--TODO: remove ghosts?
			self.statuslabel:SetText(self.wipereason,3.0)
			if(not self.hitbysurprisefinalattack)then 
				self:EnableButtons(self.buttongroup[3],true)
			else
				self:EnableButtons(self.buttongroup[2],true)
			end
		end		
	end
	
	function class:Brez()
		local auras=self.player.combatmodule.auras.deadingame
		for i=1,#auras do
			auras[i]:Die()
		end
		self.wipereason=nil
		self.playershouldntsoak=false
		local brezindex
		local ghost
		local brezpoint
		if(self.player.mirrorrealm)then
			brezindex=math.floor(math.random()*2)+1
			ghost=self.allplayers[brezindex]
			brezpoint={x=ghost.position.x,y=ghost.position.y}
		else
			brezindex=math.floor(math.random()*10)+11
			ghost=self.allplayers[brezindex]
			if(self.allplayers[brezindex].ffcamp)then
				brezpoint={x=self.rangedcamp.x,y=self.rangedcamp.y}
			else
				brezpoint={x=ghost.position.x,y=ghost.position.y}
			end
		end
		self.desolationtimer=0
		self.player.position.x=brezpoint.x
		self.player.position.y=brezpoint.y
		self.player:FreezeOrientation(ghost.orientation.yaw)
		self.dontincrementcheatdeath=false
		-- if we were "dead from humiliation" earlier, weapon got sheathed
		self.player.displayobject.drawable:SetSheathed(false)
	end

	function class:UpdatePlayerFloorbelowStatus()
		--overridden function is base scenario class, so we can't move the entire thing to collision
		if(not self.player)then return end
		if(self.player.floorbelow==false and self.player.position.z<0)then return end
		
		local ok=self.collision:EdgelineCheck(0)
		if(ok==false)then
			ok=self.collision:EdgelineCheck(-0.01) or self.collision:EdgelineCheck(-0.01)
		end
		self.player.floorbelow=ok
	end

	function class:SetNormalLights()
		local ambient=0.5
		local diffuse=0.7		
		self.game.environment_gameplay.modelsceneframe:SetLightAmbientColor(ambient,ambient,ambient)
		self.game.environment_gameplay.modelsceneframe:SetLightDiffuseColor(diffuse,diffuse,diffuse)
		-- local ambient=0.5
		-- local diffuse=0.7		
		-- self.game.environment_gameplay.modelsceneframe:SetLightAmbientColor(ambient*.4,ambient*0.25,ambient)
		-- self.game.environment_gameplay.modelsceneframe:SetLightDiffuseColor(diffuse*.4,diffuse*0.25,diffuse)
	end
	
	function class:SetMirrorLights()
		local ambient=0.4	
		local diffuse=0.4
		local rgmultiplier=0.75
		self.game.environment_gameplay.modelsceneframe:SetLightAmbientColor(ambient*rgmultiplier,ambient*rgmultiplier,ambient,1)			
		self.game.environment_gameplay.modelsceneframe:SetLightDiffuseColor(diffuse*rgmultiplier,diffuse*rgmultiplier,diffuse,1)	
	end

	-- function class:EnableButtons(buttongroup,toggle)
		-- for i=1,#buttongroup do
			-- local button=buttongroup[i]
			-- if(toggle)then
				-- button.displayobject.drawable:SetAlpha(1)
			-- else
				-- button.displayobject.drawable:SetAlpha(0)
			-- end
			-- button:EnableMouse(toggle)
		-- end
	-- end
	function class:EnableButtons(buttongroup,toggle)
		for i=1,#buttongroup do
			local button=buttongroup[i]
			if(toggle)then
				button.displayobject.drawable:SetAlpha(1) -- for labels
				button.alpha=1
				button:SetLockedStartingAlpha(1.0)	-- for buttons
			else
				button.displayobject.drawable:SetAlpha(0)
				button.alpha=0
				button:SetLockedStartingAlpha(0.0)
			end
			button:EnableMouse(toggle)
		end
	end	
	
	
	function class:DeselectButtons(buttongroup)
		for i=1,#buttongroup do
			local button=buttongroup[i]
			button:Select(false)
		end
	end
	

	function class:ForecastLabelAfterDelay(text,delay,duration)			
		if(not XPRACTICE_SAVEDATA.INDIGNATION.forecast)then return end
		if(delay<0)then return end
		duration=duration or 7.0
		local event={}
		event.func=function(scenario)	scenario.forecastlabel:SetText(text,duration) end
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end


	function class:ClickButtonAfterDelay(button,delay)		
		if(delay<0)then return end --cheap way to skip events when we fastforward
		local event={}
		event.button=button
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end
	
	function class:FunctionAfterDelay(func,delay)		
		if(delay<0)then return end --cheap way to skip events when we fastforward
		local event={}
		event.func=func
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end
	
	function class:SetCampAfterDelay(camp,point,delay)
		if(delay<0)then return end --cheap way to skip events when we fastforward
		local event={}
		event.func=function(scenario)	scenario:SetCamp(camp,point) end
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end
	function class:SetCamp(camp,point)
		camp.x=point.x;camp.y=point.y
	end
	function class:UpdateBossCamp()
		self.bosscamp.x=self.denathrius.position.x;self.bosscamp.y=self.denathrius.position.y		
	end
	function class:UpdateFakeRangedCamp()
		local totalx=0
		local totaly=0
		for i=11,20 do
			totalx=totalx+self.allplayers[i].position.x
			totaly=totaly+self.allplayers[i].position.y
		end
		self.fakerangedcamp.x=totalx/10
		self.fakerangedcamp.y=totaly/10
	end	
	
	function class:BossToCamp(react)
		react=react or 1.0
		self.denathrius.destx=self.bosscamp.x;self.denathrius.desty=self.bosscamp.y
		self.denathrius.remainingreactiontime=react
	end	
	function class:GroupApproachCamp(group,camp,maxdist,mindist,minreaction,maxreaction)
		self:UpdateFakeRangedCamp() --!!!
		for i=1,#group do
			local ghost=group[i]
			if(ghost:ApproachPoint(camp.x,camp.y,maxdist,mindist))then
				--ghost:CreateSpeechBubble(string.format("%0.1f",camp.x)..","..string.format("%0.1f",camp.y))
				ghost.remainingreactiontime=XPRACTICE.RandomNumberInBetween(minreaction,maxreaction)
			end
		end		
	end
	function class:FFPlayerRejoinGroup(ghost)
		--print("rejoin")
		ghost.fatalfinesse=false
		ghost.ffcamp=nil
		self:PlayerToSeed(ghost)
		ghost.remainingreactiontime=0
	end
	
	function class:FFPlayersRunBack(mincurvetime,maxcurvetime,group)
		group=group or self.allplayers
		local minreact=0.1
		local maxreact=0.5
		for i=1,#group do
			local ghost=group[i]
			if(ghost.fatalfinesse)then
				local camp
				--if(ghost.mirrorrealm)then camp=self.mirrorcamp else camp=self.rangedcamp end
				if(ghost.mirrorrealm)then camp=self.bosscamp else camp=self.rangedcamp end
				if(ghost:ApproachPoint(camp.x,camp.y,0,0,true))then
					ghost.remainingreactiontime=XPRACTICE.RandomNumberInBetween(minreact,maxreact)
					--ghost:CreateSpeechBubble("FFcamp") --!!!
				end
				if(mincurvetime and maxcurvetime)then
					local delay=XPRACTICE.RandomNumberInBetween(mincurvetime,maxcurvetime)
					--print("delay:",delay)
					self:FunctionAfterDelay(function() self:FFPlayerRejoinGroup(ghost) end,delay)
				end
			end
		end		
	end	
	
	function class:SoakSeeds(emergency)
		
		for j=0,1 do
			--TODO LATER: tanks soak furthest away
			local list={1,1,1,1,1,2,2,2,2,2}
			XPRACTICE.ShuffleList(list)
			for i=1,10 do
				self.allplayers[i+j*10].whichdoublesoak=list[i]
			end			
		end		
		self.player.whichdoublesoak=math.floor(math.random()*2)+1
		for i=1,21 do
			local ghost=self.allplayers[i]
			--print("ghost",i,ghost.fatalfinesse)
			if(not ghost.fatalfinesse)then								
				self:PlayerToSeed(ghost,emergency)
			else
				----do nothing
				--print("skipping ghost",i,"with fatalfinesse")
			end
		end		
		
		local totalx=0
		local totaly=0
		for i=1,#self.ffmirrorcamp do
			local ffcamp=self.ffmirrorcamp[i]
			totalx=totalx+ffcamp.x
			totaly=totaly+ffcamp.y			
		end
		self:SetCamp(self.fakerangedcamp,{x=totalx/#self.ffmirrorcamp,y=totaly/#self.ffmirrorcamp})
	
	end
	function class:PlayerToSeed(ghost,emergency)
		local minreact=0.1
		local maxreact=0.5			-- but if player is FF rejoining main group, react will be set to 0 after function ends
		local ffcamp
		if(ghost.mirrorrealm)then ffcamp=self.ffrangedcamp else ffcamp=self.ffmirrorcamp end
		local RADIUS=3
		if(not ghost.cpu) then RADIUS=0 end
		if(#ffcamp==1)then		
			campindex=1
		else
			campindex=ghost.whichdoublesoak
		end
		ghost.destx,ghost.desty=XPRACTICE.RandomPointInCircle(ffcamp[campindex].x,ffcamp[campindex].y,RADIUS)			
		--print("move",ghost.destx,ghost.desty)
		ghost.remainingreactiontime=XPRACTICE.RandomNumberInBetween(minreact,maxreact)
		if(emergency)then ghost.remainingreactiontime=minreact end
	end
	function class:SwitchToRemainingSeed()
		--if denathrius is in the middle of shattering pain, return
		--print("switch seeds!")
		if(self.denathrius.combatmodule.channeledspell)then
			if(self.denathrius.combatmodule.channeledspell.spellbookspell:GetName()=="Shattering Pain")then
				--print("SP, never mind")
				return
			end
		end
		--don't switch on 6 or 7 -- there's not enough time and FFplayers can get confused and run into camp after knockback
		if(self.fatalfinessecount>=6)then 
			return 	-- btw, FatalFinesse already doesn't add seeds to the scenario seed list for 7th FF
		end 
		local seed=self.seeds[1]
		local minreact=0.1
		local maxreact=1.5			-- but if player is FF rejoining main group, react will be set to 0 after function ends		
		for i=1,#self.allplayers do
			local ghost=self.allplayers[i]
			if(ghost.mirrorrealm~=seed.mirrorrealm)then
				local RADIUS=3		
				if(not ghost.cpu)then RADIUS=0 end
				ghost.destx,ghost.desty=XPRACTICE.RandomPointInCircle(seed.position.x,seed.position.y,RADIUS)			
				ghost.remainingreactiontime=XPRACTICE.RandomNumberInBetween(minreact,maxreact)
			end
		end
	end
	
	function class:BossCampCopyFFCamp(ffcamp)
		if(#ffcamp==1)then
			local distx=(ffcamp[1].x-self.bosscamp.x)
			local disty=(ffcamp[1].y-self.bosscamp.y)
			local dist=math.sqrt(distx*distx+disty*disty)
			local targetdist=XPRACTICE.RandomNumberInBetween(3,5) 		-- single circle? walk to edge
			local angle=math.atan2(disty,distx)+math.pi
			self.bosscamp.x=ffcamp[1].x+math.cos(angle)*targetdist
			self.bosscamp.y=ffcamp[1].y+math.sin(angle)*targetdist
		elseif(#ffcamp==2)then				-- double circle? walk between
			self.bosscamp.x=(ffcamp[1].x+ffcamp[2].x)/2
			self.bosscamp.y=(ffcamp[1].y+ffcamp[2].y)/2
		end
	end
	function class:GroupSpreadCamp(group,camp,ghostradius,minreaction,maxreaction)
		for i=1,#group do
			local ghost=group[i]
			local RADIUS=ghostradius
			if(not ghost.cpu)then RADIUS=0 end
			ghost.destx,ghost.desty=XPRACTICE.RandomPointInCircle(camp.x,camp.y,RADIUS)
			ghost.remainingreactiontime=XPRACTICE.RandomNumberInBetween(minreaction,maxreaction)			
			--ghost:CreateSpeechBubble("Spread") --!!!
		end		
	end	
	function class:GroupToAngle(group,camp,angle,maxvariation,maxdist,mindist,minreaction,maxreaction)
		for i=1,#group do
			self:OnePlayerToAngle(group[i],group,camp,angle,maxvariation,maxdist,mindist,minreaction,maxreaction)
		end		
	end	
	function class:OnePlayerToAngle(ghost,group,camp,angle,maxvariation,maxdist,mindist,minreaction,maxreaction)
		if(not ghost.cpu)then maxvariation=0;maxdist,mindist=(maxdist+mindist)/2.0,(maxdist+mindist)/2.0 end
		local angle=XPRACTICE.RandomNumberInBetween(angle-maxvariation,angle+maxvariation)
		local dist=XPRACTICE.RandomNumberInBetween(mindist,maxdist)
		local x=camp.x+math.cos(angle)*dist
		local y=camp.y+math.sin(angle)*dist
		ghost.destx=x
		ghost.desty=y
		ghost.remainingreactiontime=XPRACTICE.RandomNumberInBetween(minreaction,maxreaction)
	end
	function class:GroupFaceCamp(group,camp)
		for i=1,#group do
			local ghost=group[i]
			local x2=ghost.position.x
			local y2=ghost.position.y
			if(ghost.destx)then
				x2=ghost.destx
				y2=ghost.desty
				--print("!")
			end
			
			local angle=math.atan2(camp.y-y2,camp.x-x2)
			ghost.destyaw=angle
			-- reaction time is NOT included as we assume we'll be calling this right after move
			--print("angle:",angle,x2,y2,ghost.remainingreactiontime)
		end
	end
	
	function class:GetFFPlayers(group)
		group=group or self.allplayers
		local mirrorseedplayers={}
		local rangedseedplayers={}
		--print("---")
		for i=1,#group do
			local ghost=group[i]			
			if(ghost.fatalfinesse)then		
				--print("ghost!",ghost,ghost.fatalfinesse,ghost.mirrorrealm,i) 	
				
				if(ghost.mirrorrealm)then 
					tinsert(mirrorseedplayers,ghost) 
				else 
					tinsert(rangedseedplayers,ghost)
				end
			end
		end
		return mirrorseedplayers,rangedseedplayers
	end
	
	function class:SetFFCamp(ffcamp, sourcecamp, point1, optionalpoint2, optionalsinglepoint)
		local point={x=0,y=0}
		local doubleangle=0
		if(optionalpoint2)then
			point.x=(point1.x+optionalpoint2.x)/2
			point.y=(point1.y+optionalpoint2.y)/2			
			doubleangle=math.atan2(optionalpoint2.y-point1.y,optionalpoint2.x-point1.x)
			--print("2 points avg",point.x,point.y,"angle",doubleangle)
		else
			point.x,point.y=point1.x,point1.y
			doubleangle=math.pi/2+math.atan2(point1.y-sourcecamp.y,point1.x-sourcecamp.x)			
			--print("1 point",point.x,point.y,"anglecalc",doubleangle)
		end		
		local mirrorseedplayers,rangedseedplayers=self:GetFFPlayers(self.allplayers)
		local double=false
		if(ffcamp==self.ffrangedcamp and #rangedseedplayers>1)then double=true
		elseif(ffcamp==self.ffmirrorcamp and #mirrorseedplayers>1) then double=true
		end	
		if(not double)then
			if(not optionalsinglepoint)then
				ffcamp[1]={x=point.x,y=point.y}
				ffcamp[2]=nil
			else
				ffcamp[1]={x=optionalsinglepoint.x,y=optionalsinglepoint.y}
				ffcamp[2]=nil
			end
		else
			local DISTANCE=12
			for i=1,2 do
				local angle=doubleangle+math.pi*(i-1)				
				ffcamp[i]={x=point.x+math.cos(angle)*DISTANCE/2,y=point.y+math.sin(angle)*DISTANCE/2}
				--print("double",ffcamp[i].x,ffcamp[i].y)
			end
		end
		
	end
	
	
	
	function class:SendFFPlayersToCamp(minreact,maxreact,group,playeralwaysnear)		
		group=group or self.allplayers
		playeralwaysnear=playeralwaysnear or false
		local mirrorseedplayers,rangedseedplayers=self:GetFFPlayers(group)
		--print("Send players to camp",#mirrorseedplayers,#rangedseedplayers)
		if(#mirrorseedplayers==0 and #rangedseedplayers==0)then return end
		local singlereact=XPRACTICE.RandomNumberInBetween(minreact,maxreact)
		local fastreact=XPRACTICE.RandomNumberInBetween(minreact,maxreact)
		local slowreact=XPRACTICE.RandomNumberInBetween(minreact,maxreact)
		if(slowreact<fastreact)then slowreact,fastreact=fastreact,slowreact end
		
		if(#rangedseedplayers>0)then
			self:SendFFPlayersToOneCamp(rangedseedplayers,self.ffrangedcamp,singlereact,fastreact,slowreact,playeralwaysnear)
		end
		if(#mirrorseedplayers>0)then
			self:SendFFPlayersToOneCamp(mirrorseedplayers,self.ffmirrorcamp,singlereact,fastreact,slowreact,playeralwaysnear)
		end
	end
	
	function class:SendFFPlayersToOneCamp(seedplayers,ffcamp,singlereact,fastreact,slowreact,playeralwaysnear)
		--print("react",fastreact,slowreact)
		local double=false
		if(#seedplayers>1)then double=true end
		--print("#players",#seedplayers,"#ffcamp",#ffcamp)
		if(not double)then
			local ghost=seedplayers[1]
			ghost.destx=ffcamp[1].x
			ghost.desty=ffcamp[1].y
			--print("singleghost to ",ghost.destx,ghost.desty,ghost)
			ghost.remainingreactiontime=singlereact
			ghost.ffcamp=ffcamp[1]
		else
			local ghost1=seedplayers[1]
			local ghost2=seedplayers[2]
			local ghostmidx=(ghost1.position.x+ghost2.position.x)/2
			local ghostmidy=(ghost1.position.y+ghost2.position.y)/2
			local soakdistsqr1=(ghostmidx-ffcamp[1].x)*(ghostmidx-ffcamp[1].x)+(ghostmidy-ffcamp[1].y)*(ghostmidy-ffcamp[1].y)
			local soakdistsqr2=(ghostmidx-ffcamp[2].x)*(ghostmidx-ffcamp[2].x)+(ghostmidy-ffcamp[2].y)*(ghostmidy-ffcamp[2].y)
			local closesoak,farsoak				
			if(soakdistsqr1<=soakdistsqr2)then closesoak,farsoak=ffcamp[1],ffcamp[2] else closesoak,farsoak=ffcamp[2],ffcamp[1] end
			local ghostdistsqr1=(ghost1.position.x-farsoak.x)*(ghost1.position.x-farsoak.x)+(ghost1.position.y-farsoak.y)*(ghost1.position.y-farsoak.y)
			local ghostdistsqr2=(ghost2.position.x-farsoak.x)*(ghost2.position.x-farsoak.x)+(ghost2.position.y-farsoak.y)*(ghost2.position.y-farsoak.y)
			local closeghost,farghost
			--TODO LATER: for some drops (e.g. FF2) this produces weird results as both drops are equally close to group but player may be close to the wrong seed
			if(ghostdistsqr1<=ghostdistsqr2)then closeghost,farghost=ghost1,ghost2 else closeghost,farghost=ghost2,ghost1 end
			if(playeralwaysnear)then
				if(ghost1==self.player)then closeghost,farghost=ghost2,ghost1 end
				if(ghost2==self.player)then closeghost,farghost=ghost1,ghost2 end
			end			
			closeghost.ffcamp=farsoak
			closeghost.destx=farsoak.x	--the ghost closest to the far soak goes there
			closeghost.desty=farsoak.y
			closeghost.remainingreactiontime=fastreact	-- and it has to move first.  if it moves second, the far ghost might overtake it
			--print("farsoak",farsoak.x,farsoak.y,closeghost)
			closeghost.remainingrolltime=XPRACTICE.RandomNumberInBetween(fastreact,fastreact+1.0)
			farghost.ffcamp=closesoak
			farghost.destx=closesoak.x	--the ghost farthest from the far soak goes to the close soak
			farghost.desty=closesoak.y
			farghost.remainingreactiontime=slowreact
			--print("closesoak",closesoak.x,closesoak.y,farghost)			
		end
	end
	
	function class:CheckMirrorSafeAngle(safeangle,maxvariance,minreact,maxreact)
		local move=false
		for i=1,#self.mirrorgroup do
			local ghost=self.mirrorgroup[i]
			local currentangle=math.atan2(ghost.position.y-self.bosscamp.y,ghost.position.x-self.bosscamp.x)
			if(math.abs(XPRACTICE.AngleDifference(safeangle,currentangle))>maxvariance)then
				self:OnePlayerToAngle(ghost,group,self.bosscamp,safeangle,maxvariance/2,7,5,minreact,maxreact)
				move=true
			end
		end
		--if(move)then
		if(true)then
			self.denathrius:FaceTowardsSafeAngle(safeangle)
		end
	end


	function class:ShatteringPainCallbackAfterDelay(func,delay)
		--print("SPCAD",delay)
		if(delay<0)then return end 
		local event={}
		event.func=function(scenario) scenario.shatteringpaincallback=func end
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
		
	end
	function class:BloodPriceCallbackAfterDelay(func,delay)
		if(delay<0)then return end 
		local event={}
		event.func=function(scenario) scenario.bloodpricecallback=func end
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end
	--to make sure the callback is set before FF is cast, this function automatically reduces delay by 1.
	function class:FatalFinesseCallbackAfterDelay(func,delay)
		if(delay<0)then return end 
		delay=delay-1.0
		local event={}
		event.func=function(scenario) scenario.fatalfinessecallback=func end
		event.time=self.game.environment_gameplay.localtime+delay
		event.dead=false
		tinsert(self.events,event)
	end	
	function class:DropSeedsCallbackAfterDelay(func,delay)
		if(delay<0)then return end 
		local event={}
		event.func=function(scenario) scenario.dropseedscallback=func end
		event.time=self.game.environment_gameplay.localtime+delay		
		event.dead=false
		tinsert(self.events,event)
	end
	function class:AfterSoakCallbackAfterDelay(func,delay)
		if(delay<0)then return end 
		local event={}
		event.func=function(scenario) scenario.aftersoakcallback=func end
		event.time=self.game.environment_gameplay.localtime+delay		
		event.dead=false
		tinsert(self.events,event)
	end
	
	function class:RepeatPreviousDropSeedsCallback()
		-- Call this AFTER manually setting aftersoakcallback in the schedule knockback function.
		-- Otherwise, aftersoakcallback will be nil.
		if(#self.seeds>0)then
			if(self.previousdropseedscallback)then
				--print("repeat soak")
				self:previousdropseedscallback()
				--since we just came out of a knockback, cancel reaction time
				for i=1,#self.allplayers do
					self.allplayers[i].reactiontime=0
				end
			end
		else
			if(self.aftersoakcallback)then
				--print("already soaked, skip to aftersoak")
				-- 
				self:aftersoakcallback()
			end
		end
	end
	
	function class:PlayPlayerAttackStanceAnimation()
		if(self.player.mirrorrealm==true)then
			self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Ready1H)
		else		
			--self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ReadySpellDirected)
			self.player.animationmodule:PlayAnimation(XPRACTICE.AnimationList.MagReadySpellCast)
		end
		
	end
	
	function class:OnEscapeKey()
		if(self.gamemenu)then
			if(self.gamemenu.shown)then
				self.gamemenu:Hide()
			else
				local ok=true
				if(self.player)then					
					if(self.player.combatmodule.targetmob)then
						ok=false
					end
				end
				if(ok)then
					self.gamemenu:Show()
				end
			end
		end
	end	
	
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.INDIGNATION.Scenario,"Indignation","(Sire Denathrius)")
	XPRACTICE.ScenarioList.RegisterScenario(XPRACTICE.VOIDRITUAL.Scenario,"9.0","Castle Nathria","SEPARATOR")
end

