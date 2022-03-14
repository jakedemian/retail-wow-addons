--TODO: less function closures to preserve RAM

do
	XPRACTICE.INDIGNATION.Phase3Schedule_Type2={}
	local schedule=XPRACTICE.INDIGNATION.Phase3Schedule_Type2
	--local XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=60*6+43.28
	XPRACTICE.INDIGNATION.Phase3Schedule_Type2.DEFAULTSTARTTIME=60*6+51.28
	XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=XPRACTICE.INDIGNATION.Phase3Schedule_Type2.DEFAULTSTARTTIME
	
	local standardminreact=0.1
	local standardmaxreact=1.5
	local seedminreact=0.5
	local seedmaxreact=1.5		
	local emergencyminreact=0.0
	local emergencymaxreact=0.4
	local standardmincurvetime=2.0	--used to determine how long FF players run back to previous camp before changing direction.
	local standardmaxcurvetime=3.0
	local maxmelee=7
	local minmelee=3
	
	local CSC=XPRACTICE.INDIGNATION.Layout.ConvertScreenshotCoords
	
	--DEBUG_FASTSTART=true--!!!
	
	local function CalcDelay(casttime)
		--print("delay:",casttime-XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime)		
		return casttime-XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime
	end

	function schedule.Run(sc)
		--XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=60*6+43.28
		
		-- --!!!--------------
		if(DEBUG_FASTSTART)then

			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*9+28.51)--BP3
			sc.ravagecount=2
			sc.fatalfinessecount=5
			sc.shatteringpaincount=6
		end


		if(DEBUG_FASTSTART)then
			for i=1,20 do
				local ghost=sc.allplayers[i]
				ghost.destx=nil
				ghost.desty=nil
				ghost.ai.targetposition=nil
				--ghost.basemovespeed=14
			end
			for i=1,10 do
				local ghost=sc.allplayers[i]
				ghost.remainingreactiontime=-1
				ghost.mirrorrealm=true			
			end
			sc.player.mirrorrealm=false
			--sc.player.mirrorrealm=true
			if(sc.player.mirrorrealm)then
				--print("mirrorgroup")
				tinsert(sc.mirrorgroup,sc.player)
			else
				--print("rangedgroup")
				tinsert(sc.rangedgroup,sc.player)
			end			
		end
		-- --!!!--------------

	

		-- BEGIN		
		XPRACTICE.INDIGNATION.Phase3Schedule_TextForecast.RunTextForecast(self,sc,CalcDelay)
		
		sc:SetCampAfterDelay(sc.bosscamp,CSC( 9357.82,  -1901.48 ) ,CalcDelay(60*6+49.28))
		sc:SetCampAfterDelay(sc.mirrorcamp,CSC ( 9336.94, -1901.31 ) ,CalcDelay(60*6+49.28))
		sc:SetCampAfterDelay(sc.rangedcamp,CSC  ( 9362.92, -1901.38 ) ,CalcDelay(60*6+49.28))
		
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*6+56.63)) --SP1
		sc:ShatteringPainCallbackAfterDelay(function()											
															sc:UpdateBossCamp()
															sc:UpdateFakeRangedCamp()
															sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,10,0,0)
															sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,0,math.pi/4,maxmelee,minmelee,0,0)
															sc:GroupFaceCamp(sc.mirrorgroup,sc.bosscamp)
													end,CalcDelay(60*6+56.63))
		
		sc:ClickButtonAfterDelay(sc.bloodpricebutton,CalcDelay(60*7+03.93)) --BP1
		sc:BloodPriceCallbackAfterDelay(function()
											sc:SetCamp(sc.bosscamp,{x=0,y=0})								
											sc:BossToCamp()
											sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,0,math.pi*2,maxmelee,minmelee,0,0)
											sc:GroupFaceCamp(sc.mirrorgroup,sc.bosscamp)
											sc:SetCamp(sc.rangedcamp,{x=-17,y=0})
											sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,10,0,0)
												end,CalcDelay(60*7+03.93))
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*7+10.89)) --FF1
		sc:FatalFinesseCallbackAfterDelay(function()
								--sc:SetCamp(sc.bosscamp,CSC( 9351.83, -1907.58 ))
								--sc:BossToCamp()
								--sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.75,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)
								--sc:SetCamp(sc.rangedcamp,CSC( 9334.36, -1893.91 ) )
								sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,standardminreact,standardmaxreact)								
								--sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-12.69,y=-16.97},{x=-26.84,y=-14.95})
								sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-20.16,y=-14.27},{x=-8.70,y=-15.44})
								sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,{x=-6.43,y=15.00},{x=6.09,y=15.00})
								
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.75,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:SendFFPlayersToCamp(seedminreact,seedmaxreact) 
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*7+10.89))
		sc:DropSeedsCallbackAfterDelay(function()
								sc:FFPlayersRunBack(standardmincurvetime,standardmaxcurvetime)
								sc:BossCampCopyFFCamp(sc.ffrangedcamp)
								sc:BossToCamp()
								sc:SoakSeeds()
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*7+10.89))													
		sc:AfterSoakCallbackAfterDelay(function()
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.25,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,26,21,standardminreact,standardmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)								
											end,CalcDelay(60*7+10.89))		
		
		--if melee isn't at correct angle, stop everything when shatteringpain is cast and change position
		sc:FunctionAfterDelay(function()sc:CheckMirrorSafeAngle(math.pi*1.25,math.pi/8,emergencyminreact,emergencymaxreact)end,CalcDelay(60*7+22.14))
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*7+22.14)) --SP2 interrupts soak!  (not really, only a brief moment left to soak when you land)
		sc:ShatteringPainCallbackAfterDelay(function()																									
									sc.aftersoakcallback=function()
										sc:SetCamp(sc.rangedcamp,{x=2.60,y=18.94})
										sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,standardminreact,standardmaxreact)
										sc:SetCamp(sc.bosscamp,CSC( 9347.48 , -1902.28 ))								
										sc:BossToCamp()
										sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.25,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)																		
										--local point=CSC(9344.94,-1898.45)
										--sc.tanks[1].destx,sc.tanks[1].desty=point.x,point.y
										--sc.denathrius:FaceTowardsTank1Destination()
										sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
										
									end
									sc:RepeatPreviousDropSeedsCallback()
														end,CalcDelay(60*7+22.14)) 
										

		--Ranged timewarp goes here 60*7+26.26
		sc:FunctionAfterDelay(function()
					for i=1,#sc.rangedgroup do
						local ghost=sc.rangedgroup[i]
						local effect=XPRACTICE.INDIGNATION.TimeWarpEffect.new()
						effect.player=ghost
						effect:Setup(ghost.environment,ghost.position.x,ghost.position.y,ghost.position.z+2.5)
					end
				end,CalcDelay(60*7+26.26))
				
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*7+32.76)) --FF2
		sc:FatalFinesseCallbackAfterDelay(function()
								--sc:SetCamp(sc.bosscamp,CSC( 9343.75 , -1900.28 ))
								--sc:BossToCamp()
								--sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)
								--sc:SetCamp(sc.rangedcamp,CSC( 9363.64 , -1882.86 ) )
								--sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,standardminreact,standardmaxreact)								
								--sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-14.78,y=16.08},{x=-27.47,y=16.69})	--not CSC
								sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-14.16,y=10.67},{x=-15.38,y=23.62})	--not CSC
								sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,{x=1.12,y=1.33},{x=-1.20,y=-11.54},{x=1.12,y=1.33})
								sc:SendFFPlayersToCamp(seedminreact,seedmaxreact)
								--print("FF2 callback")
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*7+32.76))		
				sc:DropSeedsCallbackAfterDelay(function()
				--print("FF2 drop callback")
								sc:FFPlayersRunBack(standardmincurvetime,standardmaxcurvetime)
								sc:BossCampCopyFFCamp(sc.ffrangedcamp)
								sc:BossToCamp()
								sc:SoakSeeds()
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*7+32.76))
				sc:AfterSoakCallbackAfterDelay(function()
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*0.75,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,15,standardminreact,standardmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)								
											end,CalcDelay(60*7+32.76))												
		
		sc:FunctionAfterDelay(function()sc:CheckMirrorSafeAngle(math.pi*0.75,math.pi/8,emergencyminreact,emergencymaxreact)end,CalcDelay(60*7+44.03))
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*7+44.03)) --SP3
		sc:ShatteringPainCallbackAfterDelay(function()																									
								sc.aftersoakcallback=function()
									sc:SetCamp(sc.bosscamp,{x=math.cos(-math.pi/6)*5,y=math.sin(-math.pi/6)*5})
									sc:BossToCamp()
									sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,-math.pi/6,math.pi/16,maxmelee,minmelee,standardminreact,standardmaxreact)
									--sc:GroupToAngle(sc.rangedgroup,sc.bosscamp,-math.pi/6,math.pi/32,35,20,standardminreact,standardmaxreact)
									sc:GroupToAngle(sc.rangedgroup,sc.bosscamp,-math.pi/6,math.pi/64,15,10,standardminreact,standardmaxreact)
									sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)									
								end
								sc:RepeatPreviousDropSeedsCallback()
													end,CalcDelay(60*7+44.03)) 
		
		sc:ClickButtonAfterDelay(sc.sinisterreflectionbutton,CalcDelay(60*7+53.73)) --SR1
		sc:FunctionAfterDelay(function()
									XPRACTICE.INDIGNATION.QuickStampedingRoar(sc)
									sc:SetCamp(sc.bosscamp,{x=-21.78,y=6.62})
									sc:BossToCamp()									
									--new plan: ranged run far northeast, then back to {-.99,9.83} after a couple seconds
									sc:SetCamp(sc.rangedcamp,{x=11.28,y=19.30})
									
									
									sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi,math.pi/4,maxmelee,minmelee,0.1,0.5)
									sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,0.1,0.5)
									sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
										end,CalcDelay(60*7+53.73+3.0+XPRACTICE.Config.Indignation.RavageReflectionDelay))
		
		sc:FunctionAfterDelay(function()
								sc:SetCamp(sc.rangedcamp,{x=-.99,y=9.83})
								sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,0.1,0.5)
								sc:SendFFPlayersToCamp(0.1,0.5,sc.rangedgroup,true) -- in case of double, player is always near drop
										end,CalcDelay(60*7+57.78+2.0+XPRACTICE.Config.Indignation.RavageReflectionDelay))
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*7+57.78)) --FF3
		sc:FatalFinesseCallbackAfterDelay(function()								

								sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-14.81,y=23.36}, {x=-16.75,y=36.01}  ,{x=-14.81,y=23.36})
								--sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,{x=-11.41,y=-7.71},  {x=-9.91,y=-19.98}    , {x=-11.41,y=-7.71})
								sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,{x=-9.30,y=-3.18},  {x=-6.99,y=-16.36}    , {x=-9.30,y=-3.18})
								sc:SendFFPlayersToCamp(0.1,0.5,sc.rangedgroup,true) -- in case of double, player is always "near" drop
								sc:SendFFPlayersToCamp(0.1,0.5,sc.mirrorgroup)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*7+57.78+XPRACTICE.Config.Indignation.RavageReflectionDelay))		
				sc:DropSeedsCallbackAfterDelay(function()
								sc:FFPlayersRunBack(standardmincurvetime,standardmaxcurvetime)
								sc:BossCampCopyFFCamp(sc.ffrangedcamp)
								sc:BossToCamp()
								sc:SoakSeeds()
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*7+57.78+XPRACTICE.Config.Indignation.RavageReflectionDelay))
				sc:AfterSoakCallbackAfterDelay(function()
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi/2+math.pi/8,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,15,standardminreact,standardmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)								
											end,CalcDelay(60*7+57.78+XPRACTICE.Config.Indignation.RavageReflectionDelay))			
		
		sc:FunctionAfterDelay(function() sc:CheckMirrorSafeAngle(math.pi/2+math.pi/8,math.pi/8,emergencyminreact,emergencymaxreact)end,CalcDelay(60*8+08.36))
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*8+08.36)) --SP4
		sc:ShatteringPainCallbackAfterDelay(function()																																		
									sc.aftersoakcallback=function()
										--ranged moves first, approach OLD bosscamp position!
										sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,31,26,standardminreact,standardmaxreact)						
										sc:SetCamp(sc.bosscamp,CSC( 9344.62 , -1884.74 ))
										sc:BossToCamp()					
										sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi/2+math.pi/8,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)										
										sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)		
										sc.denathrius:FaceTowardsTank1Destination()
									end
									sc:RepeatPreviousDropSeedsCallback()
														end,CalcDelay(60*8+08.36)) 		
		
		sc:ClickButtonAfterDelay(sc.bloodpricebutton,CalcDelay(60*8+16.86)) --BP2
		sc:BloodPriceCallbackAfterDelay(function()
									sc:SetCamp(sc.bosscamp,CSC( 9348.19 , -1888.76 ))
									sc:BossToCamp()	
									sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi/2-math.pi/8,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
									sc:SetCamp(sc.rangedcamp,{x=-17.80,y=-14.49} )
									--sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,3.75,standardminreact,standardmaxreact)								
									sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,2.5,standardminreact,standardmaxreact)								

									sc:GroupFaceCamp(sc.mirrorgroup,sc.bosscamp)
									sc.denathrius:FaceTowardsTank1Destination()
										end,CalcDelay(60*8+16.86))
										
		--Mirror timewarp goes here 60*8+22.27
		sc:FunctionAfterDelay(function()
					for i=1,#sc.mirrorgroup do
						local ghost=sc.mirrorgroup[i]
						local effect=XPRACTICE.INDIGNATION.TimeWarpEffect.new()
						effect.player=ghost
						effect:Setup(ghost.environment,ghost.position.x,ghost.position.y,ghost.position.z+2.5)
					end
				end,CalcDelay(60*8+22.27))
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*8+22.77)) --FF4
				sc:FatalFinesseCallbackAfterDelay(function()
								--sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.5+math.pi/8,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-3.15,y=-0.56},{x=-2.93,y=-13.42},{x=-3.15,y=-0.56})								
								--sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,{x=-26.91,y=19.83},{x=-33.30,y=8.89})
								sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,{x=-17.72,y=0.12},{x=-29.50,y=0.28})
								
								sc:SendFFPlayersToCamp(seedminreact,seedmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
										end,CalcDelay(60*8+22.77))
				sc:DropSeedsCallbackAfterDelay(function()
								sc:FFPlayersRunBack(standardmincurvetime,standardmaxcurvetime)
								sc:BossCampCopyFFCamp(sc.ffrangedcamp)
								sc:BossToCamp()
								sc:SoakSeeds()
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*8+22.77))	
				sc:AfterSoakCallbackAfterDelay(function()
								--sc:SetCamp(sc.bosscamp,CSC( 9349.35 , -1923.34 ))
								--sc:BossToCamp()	
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.5,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,15,10,standardminreact,standardmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)								
											end,CalcDelay(60*8+22.77))	
		
		sc:FunctionAfterDelay(function()sc:CheckMirrorSafeAngle(math.pi*1.5,math.pi/8,emergencyminreact,emergencymaxreact)end,CalcDelay(60*8+32.63))
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*8+32.63)) --SP5
		sc:ShatteringPainCallbackAfterDelay(function()																									
							sc.aftersoakcallback=function()
								sc:SetCamp(sc.bosscamp,{x=-2.73,y=10.38})
								sc:BossToCamp()					
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi/2-math.pi/8,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,15,standardminreact,standardmaxreact)						
								sc:SetCamp(sc.rangedcamp,CSC ( 9337.09 , -1883.47 ))								
								sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,2.5,standardminreact,standardmaxreact)																
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)		
								sc.denathrius:FaceTowardsTank1Destination()
							end
							sc:RepeatPreviousDropSeedsCallback()
												end,CalcDelay(60*8+32.63)) 		
		
		--TODO: Downtime notice goes here maybe?
		
		--if we change lock gate to be a spell, it's ok for denath to cast, lots of downtime
		--wait another second or two before spawning gateway, ranged is still running to camp
		sc:FunctionAfterDelay(function()sc.portal1=XPRACTICE.INDIGNATION.QuickDemonicGateway(sc)end,CalcDelay(60*8+39.23+4.0))
		
		sc:ClickButtonAfterDelay(sc.sinisterreflectionbutton,CalcDelay(60*8+53.27)) --SR2
		


		sc:FunctionAfterDelay(function()
			if(sc.portal1)then
				for i=11,20 do
					sc.allplayers[i].portal_TEMP=sc.portal1		--destx/y must also be set in order to use portal, but we're about to do that
					--sc.allplayers[i].remainingreactiontime=XPRACTICE.RandomNumberInBetween(0.25,0.5)
					sc.allplayers[i].remainingreactiontime=XPRACTICE.RandomNumberInBetween(0.25,1.0)
				end
			end
		--end,CalcDelay(60*8+57.25))	
		end,CalcDelay(60*8+56.27+XPRACTICE.Config.Indignation.RavageReflectionDelay))	
		
		
		sc:FunctionAfterDelay(function()
				if(sc.player.mirrorrealm and not sc.player:IsDeadInGame())then
					if(XPRACTICE_SAVEDATA.INDIGNATION.mirrorknockbackresist)then
						XPRACTICE_RaidBossEmote("You have temporary resistance to knockback.",2.0)
					end
				end
				--sc:SetCamp(sc.rangedcamp,CSC( 9349.27 , -1910.45 ))
				--sc:SetCamp(sc.rangedcamp,{x=-5.40,y=-5.58})
				--sc:SetCamp(sc.rangedcamp,{x=-12.07,y=-10.21})
				sc:SetCamp(sc.rangedcamp,{x=-6.02,y=-9.78})
				--sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,0.25,0.5)				
				sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,0.25,1.0)
				--sc:SetCamp(sc.mirrorcamp,CSC( 9328.03 , -1903.59 ))
				sc:SetCamp(sc.mirrorcamp,{x=-20.39,y=-2.02})
				sc:GroupSpreadCamp(sc.mirrorgroup,sc.mirrorcamp,5,0.5,1.5)						
				--sc:SetCamp(sc.bosscamp,CSC( 9350.09 , -1885.72 ))
				--sc:SetCamp(sc.bosscamp,{x=-11.46,y=6.31})
				--sc:SetCamp(sc.bosscamp,{x=-3.52,y=1.49})
				sc:SetCamp(sc.bosscamp,{x=-6.02,y=1.49})
				sc:BossToCamp(0.1)	
				--sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)		
			--end,CalcDelay(60*8+57.11))
			end,CalcDelay(60*8+56.27+XPRACTICE.Config.Indignation.RavageReflectionDelay))
			
		
			
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*8+58.11)) --SP6
		sc:ShatteringPainCallbackAfterDelay(function()	
				--sc:SetCamp(sc.bosscamp,{x=-15.58,y=-1.47})
				sc:SetCamp(sc.bosscamp,{x=-3.70,y=-2.16})
				sc:BossToCamp()	
				sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.25,math.pi/4,maxmelee/2,minmelee,0,0)
				--sc:SetCamp(sc.rangedcamp,{x=-15.76,y=-27.71})
				sc:SetCamp(sc.rangedcamp,{x=-17.92,y=-21.83})
				sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,3.75,0,0)
			end,CalcDelay(60*8+58.11))
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*9+01.79)) --FF5
				sc:FatalFinesseCallbackAfterDelay(function()				
								--sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-5.18,y=-1.89},{x=-3.80,y=-15.59})
								sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,{x=-4.12,y=-26.76},{x=-3.80,y=-15.59})
								sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,CSC( 9328.95 , -1910.75 ))
								sc:SendFFPlayersToCamp(seedminreact,seedmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
										end,CalcDelay(60*9+01.79))
				sc:DropSeedsCallbackAfterDelay(function()
								sc:FFPlayersRunBack(standardmincurvetime,standardmaxcurvetime)
								sc:BossCampCopyFFCamp(sc.ffrangedcamp)
								sc:BossToCamp()
								sc:SoakSeeds()
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*9+01.79))	
				sc:AfterSoakCallbackAfterDelay(function()
								--TODO: bosscamp south
								sc:SetCamp(sc.bosscamp,{x=-13.0,y=-23})
								sc:BossToCamp()
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.5,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,15,10,standardminreact,standardmaxreact)
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
											end,CalcDelay(60*9+01.79))	
		
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*9+20.00)) --SP7
		sc:ShatteringPainCallbackAfterDelay(function()	
				sc:SetCamp(sc.bosscamp,CSC( 9347.99 , -1925.53 ))
				sc:BossToCamp()	
				sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.5,math.pi/8,maxmelee,minmelee,0,0)
				sc:SetCamp(sc.rangedcamp,CSC( 9349.27 , -1933.07 ))
				sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,15,10,standardminreact,standardmaxreact)
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)	
			end,CalcDelay(60*9+20.00))
			
		sc:ClickButtonAfterDelay(sc.bloodpricebutton,CalcDelay(60*9+28.51)) --BP3
		sc:BloodPriceCallbackAfterDelay(function()	
				--sc:SetCamp(sc.bosscamp,CSC( 9347.99 , -1925.53 ))
				--sc:SetCamp(sc.bosscamp,{x=-18.12,y=-23.38})
				sc:SetCamp(sc.bosscamp,{x=-12.83,y=-23.44})
				sc:BossToCamp()	
				--sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.5,math.pi/6,maxmelee,minmelee,0,0)
				sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.25,math.pi/6,maxmelee,minmelee,0,0)
				--sc:SetCamp(sc.rangedcamp,CSC( 9332.84 , -1901.48+5+10 ))
				sc:SetCamp(sc.rangedcamp,{x=-23.89,y=-0.38})
				sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,2.5,standardminreact,standardmaxreact)	
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)				
			end,CalcDelay(60*9+28.51))
		
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*9+34.76)) --FF6
		sc:FatalFinesseCallbackAfterDelay(function()
				sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp,CSC( 9327.21 , -1917.00 ))
				--sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp,CSC( 9348.87 , -1902.67 ),CSC( 9354.12 , -1913.21 ))
				---- these new drop points overlap a bit but only one of them will be a double seed
				--sc:SetFFCamp(sc.ffrangedcamp,sc.rangedcamp, {x=-23.40,y=-17.71}, {x=-36.54,y=-17.51}   ,{x=-23.40,y=-17.71})
				sc:SetFFCamp(sc.ffmirrorcamp,sc.bosscamp, {x=-12.05,y=-13.98} , {x=-11.20,y=-0.96} ,{x=-12.89,y=-9.76})
				--print("to camp")
				-- if(DevTools_Dump)then
					-- DevTools_Dump(sc.ffmirrorcamp)
				-- end
				sc:SendFFPlayersToCamp(seedminreact,seedmaxreact/2)
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
			end,CalcDelay(60*9+34.76))
		sc:DropSeedsCallbackAfterDelay(function()
				--print("dropseeds callback FF6")
				if(sc.fatalfinessecount<7)then
					-- if FF count was 7, this would have cleared FF7 players' seed status and cause them to drop seeds in main camp
					--print("run back")
					sc:FFPlayersRunBack(0.75,1.0)
				end				
				sc:BossCampCopyFFCamp(sc.ffrangedcamp)
				sc:BossToCamp()
				sc:SoakSeeds(true)
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)				
			end,CalcDelay(60*9+34.76))
			-- don't have to worry about aftersoak just yet, SP8 is coming
			
		sc:FunctionAfterDelay(function()
			--print("warning SP8")
			-- this will override FF7 player-to-FFcamp, so we have to call it again during SP8 callback
			sc:CheckMirrorSafeAngle(math.pi,math.pi/8,0.1,0.25)
			sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,15,10,standardminreact,standardmaxreact)
			end,CalcDelay(60*9+44.29))			
		sc:ClickButtonAfterDelay(sc.shatteringpainbutton,CalcDelay(60*9+44.29)) --SP8
		sc:ShatteringPainCallbackAfterDelay(function()			
							--sc.desolationtimer=-2.5
							--print("set aftersoak")
							sc:SendFFPlayersToCamp(0,0)
							sc.aftersoakcallback=function()		
								--print("aftersoak FF6")
								sc:SetCamp(sc.bosscamp,CSC( 9328.65 , -1907.87 ))
								sc:BossToCamp()
								sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
								sc:SetCamp(sc.rangedcamp,CSC ( 9350.1, -1902.15 ))
								sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,2.5,standardminreact,standardmaxreact)	
								
								sc:SendFFPlayersToCamp(seedminreact,seedmaxreact) -- the previous lines can override the next FF callback, so we send it again here
								sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)		
								sc.denathrius:FaceTowardsTank1Destination()
								--print("aftersoak FF6 done")
							end
							sc:RepeatPreviousDropSeedsCallback() 
							
												end,CalcDelay(60*9+44.29)) 			
		
		
		sc:ClickButtonAfterDelay(sc.fatalfinessebutton,CalcDelay(60*9+47.80)) --FF7
		sc:FatalFinesseCallbackAfterDelay(function()
				--print("apply FF7")
				local mirrorseedplayers,rangedseedplayers=sc:GetFFPlayers()				
				sc.ffmirrorcamp[1]={x=-35.23,y=-22.81}
				if(#mirrorseedplayers>1)then sc.ffmirrorcamp[2]={x=-22.84,y=-21.07} else sc.ffmirrorcamp[2]=nil end				
				--sc.ffrangedcamp[1]={x=-2.66,y=-21.64}
				--if(#rangedseedplayers>1)then sc.ffrangedcamp[2]={x=-23.89,y=10.62} else sc.ffrangedcamp[2]=nil end
				sc.ffrangedcamp[1]={x=-23.89,y=10.62}
				if(#rangedseedplayers>1)then sc.ffrangedcamp[2]={x=-2.66,y=-21.64} else sc.ffrangedcamp[2]=nil end
				sc:SendFFPlayersToCamp(seedminreact,seedmaxreact)
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)
				--at some point we need to clear aftersoakcallback so FF7 players don't try to run back to group if FF6 finishes soaking late
				sc.aftersoakcallback=nil
				--print("nil aftersoak")
			end,CalcDelay(60*9+47.80))
		sc:DropSeedsCallbackAfterDelay(function()				
				--print("FF7 dropseedscallback")
				--only melee FFplayer needs to run back.  we're not soaking and ranged FFplayers can attack from where they're standing
				sc:FFPlayersRunBack(nil,nil,sc.mirrorgroup)	--don't soak seeds as FF either
				
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)				
			end,CalcDelay(60*9+47.80))
			
		
		sc:ClickButtonAfterDelay(sc.sinisterreflectionbutton,CalcDelay(60*9+52.81)) --SR3
		
		
		sc:FunctionAfterDelay(function()
				--all groups pretend to dodge initial massacre lines here						
				
				sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,0,math.pi*2,maxmelee,minmelee,standardminreact,standardmaxreact)						
				--sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,10,20,standardminreact,standardmaxreact)
				sc:SetCamp(sc.rangedcamp,{x=-14.69,y=-7.14})
				sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,7,standardminreact,standardmaxreact)	
				sc:SendFFPlayersToCamp(0,0,sc.rangedgroup) --FFranged stays planted
				sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)		
			end,CalcDelay(60*9+52.81+3.0+1.5))
		
		
		
		-- endsc button goes here 60*10+00.00
		sc:FunctionAfterDelay(function()
			sc.bossdead=true
			local aura=sc.denathrius.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,sc.denathrius.combatmodule,sc.denathrius.environment.localtime)
			if(sc.ravagetelegraphs[3])then
				sc.ravagetelegraphs[3]:Die()
			end
			local message="You died "..tostring(sc.cheatdeathcount).." time"
			if(sc.cheatdeathcount==0)then
				message=message.."s!"	
				if(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway~=0)then
					message=message.."\nCan you survive from the very start of phase 3?"
				else
					--"best ending", message won't be displayed
				end
			elseif(sc.cheatdeathcount==1)then
				message=message.."."
			else
				message=message.."s."
			end
			
			if(not(sc.cheatdeathcount==0 and XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway==0))then
				sc.statuslabel:SetText(message,20.0)
			end
			
			--if(sc.cheatdeathcount==0 and sc.stoodinfiretime==0)then
				--C_ChatInfo.SendAddonMessage("D4", "GCE\t".."2424".."\t6\t0\t".."10 minutes".."\t".."16".."\t".."0".."\t".."Sire Denathrius", "GUILD")
			--end
			--sc.denathrius.nameplate.hp_TEMP=0;sc.denathrius.nameplate.displayobject:SetFillPoints()
			sc.denathrius.nameplate:Die()
			sc.denathrius.mobclickzone:Die()	
			sc.phaseinprogress=false

			if(not (sc.cheatdeathcount==0 and XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway==0))then			
				sc:EnableButtons(sc.buttongroup[3],false)	
				sc:EnableButtons(sc.buttongroup[2],true)
			end
					
		end,CalcDelay(60*10+00.00+XPRACTICE.Config.Indignation.RavageReflectionDelay))
		
		-- blunder-safe mode: display restart button at 60*10+01.00
		
		-- 60*10+01.81 ravage end (not used)
		
		-- 60*10+02.81 wipe time (only used for wipe clock)
		sc:FunctionAfterDelay(function()
			
			if(sc.cheatdeathcount==0 and XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway==0)then				
			--if(true)then --!!!
				sc:ClickButtonAfterDelay(sc.crescendo2button,0)
			end
		end,CalcDelay(60*10+01.00+2.5+XPRACTICE.Config.Indignation.RavageReflectionDelay))
		-- crescendo goes hereabouts 60*10+01.00+2 (impact at 10:05+2)

		
		-- extra mode: display restart button at 60*10+06.00
		sc:FunctionAfterDelay(function()
			if(sc.cheatdeathcount==0 and XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway==0)then
			--if(true)then --!!!
				if(not sc.hitbysurprisefinalattack)then
					sc.statuslabel:SetText("Sire Denathrius has been defeated!",20.0)				
					--
					--sc:EnableButtons(sc.buttongroup[6],true)
					sc:EnableButtons(sc.buttongroup[3],false)	
					sc:EnableButtons(sc.buttongroup[2],true)				
					local aura=sc.player.combatmodule:ApplyAuraByClass(XPRACTICE.INDIGNATION.Aura_ScenarioComplete_Cheer,sc.player.combatmodule,sc.localtime)
				end
			end
		end,CalcDelay(60*10+06.00+2.5+XPRACTICE.Config.Indignation.RavageReflectionDelay))
		
		
	end
	
	function schedule.StartFromMidway(sc,ffcount)
		if(ffcount==0)then return end
		
		sc.fatalfinessecount=ffcount-1
		
		for i=1,10 do
			local ghost=sc.allplayers[i]
			ghost.mirrorrealm=true
		end		
		for i=11,20 do
			local ghost=sc.allplayers[i]
			ghost.mirrorrealm=false
		end				
		if(sc.player.mirrorrealm)then
			tinsert(sc.mirrorgroup,sc.player)
		else
			tinsert(sc.rangedgroup,sc.player)
		end
		
		if(ffcount==1)then
			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=60*7+03.93
			
			sc.shatteringpaincount=1
			sc:SetCamp(sc.bosscamp,{x=3,y=0})
			sc:BossToCamp()
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,0,math.pi/4,maxmelee,minmelee,0,0)
			sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,10,0,0)			
		elseif(ffcount==2)then		
			--XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*7+22.14) --SP2		
			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*7+32.76)
			sc.shatteringpaincount=2
			sc:SetCamp(sc.rangedcamp,{x=2.60,y=18.94})
			sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,5,standardminreact,standardmaxreact)
			sc:SetCamp(sc.bosscamp,CSC( 9347.48 , -1902.28 ))								
			sc:BossToCamp()
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.25,math.pi/4,maxmelee,minmelee,standardminreact,standardmaxreact)																		
		elseif(ffcount==3)then			
			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*7+53.73) --SR1
			sc.shatteringpaincount=3
			sc:SetCamp(sc.bosscamp,{x=math.cos(-math.pi/6)*5,y=math.sin(-math.pi/6)*5})
			sc:BossToCamp()
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,-math.pi/6,math.pi/16,maxmelee,minmelee,standardminreact,standardmaxreact)
			sc:GroupToAngle(sc.rangedgroup,sc.bosscamp,-math.pi/6,math.pi/64,15,10,standardminreact,standardmaxreact)		
		elseif(ffcount==4)then
			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*8+16.86) --BP2
			sc.ravagecount=1
			sc.shatteringpaincount=4
			sc:SetCamp(sc.bosscamp,CSC( 9344.62 , -1884.74 ))
			sc:BossToCamp()					
			sc:SetCamp(sc.rangedcamp,{x=-11.30,y=-8.03})
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi/2+math.pi/8,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
			sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,3.75,standardminreact,standardmaxreact)						
			--sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,26,21,standardminreact,standardmaxreact)						
		elseif(ffcount==5)then
			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*8+53.27) --SR2
			sc.ravagecount=1
			sc.shatteringpaincount=5
			sc:SetCamp(sc.bosscamp,{x=-2.73,y=10.38})
			sc:BossToCamp()					
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi/2-math.pi/8,math.pi/8,maxmelee,minmelee,standardminreact,standardmaxreact)
			--sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,21,15,standardminreact,standardmaxreact)						
			sc:SetCamp(sc.rangedcamp,CSC ( 9337.09 , -1883.47 ))								
			sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,2.5,standardminreact,standardmaxreact)																
			
		elseif(ffcount==6)then
			XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime=(60*9+28.51) --BP3
			sc.ravagecount=2
			sc.shatteringpaincount=7
			sc:SetCamp(sc.bosscamp,CSC( 9347.99 , -1925.53 ))
			sc:BossToCamp()	
			sc:GroupToAngle(sc.mirrorgroup,sc.bosscamp,math.pi*1.5,math.pi/8,maxmelee,minmelee,0,0)
			sc:SetCamp(sc.rangedcamp,{x=-19.63,y=-15.99})								
			sc:GroupSpreadCamp(sc.rangedgroup,sc.rangedcamp,2.5,standardminreact,standardmaxreact)																			
			--sc:GroupApproachCamp(sc.rangedgroup,sc.bosscamp,15,10,standardminreact,standardmaxreact)

		end
		if(sc.ravagecount>0)then
			XPRACTICE.INDIGNATION.RavageController.CreateRavageTelegraphs(sc,0)
			sc.ravagecontroller:DrawSafetyLines()
		end
		if(ffcount==5)then
			sc.portal1=XPRACTICE.INDIGNATION.QuickDemonicGateway(sc)
		end
		


		sc:GroupFaceCamp(sc.allplayers,sc.bosscamp)

		for i=1,21 do
			local ghost=sc.allplayers[i]
			if(ghost.destx)then
				--local angle=math.atan2(ghost.desty-ghost.position.y,ghost.destx-ghost.position.x)				
				ghost:FreezeOrientation(ghost.destyaw)
				ghost.destyaw=nil
				ghost.position.x=ghost.destx;ghost.position.y=ghost.desty
				ghost.destx=nil;ghost.desty=nil
				ghost.remainingreactiontime=nil
			end
		end
		local denathrius=sc.denathrius
		if(denathrius.destx)then
			local angle=math.atan2(denathrius.desty-denathrius.position.y,denathrius.destx-denathrius.position.x)
			denathrius:FreezeOrientation(angle)		
			denathrius.position.x=denathrius.destx;denathrius.position.y=denathrius.desty
			denathrius.destx=nil;denathrius.desty=nil
			denathrius.remainingreactiontime=nil
		end		
		--!!!
		local angle=math.atan2(sc.allplayers[1].position.y-denathrius.position.y,sc.allplayers[1].position.x-denathrius.position.x)	
		denathrius:FreezeOrientation(angle)
		
		sc.game.environment_gameplay.cameramanager.camera.orientation.yaw=sc.player.orientation.yaw
		
		
		if(sc.rangedcamp.x==0 and sc.rangedcamp.y==0)then	
			local ghost=sc.allplayers[11];sc:SetCamp(sc.rangedcamp,{x=ghost.x,y=ghost.y})
		end		
		
		local TOTALPHASETIME=196.72+XPRACTICE.Config.Indignation.RavageReflectionDelay
		sc.phasetime=XPRACTICE.INDIGNATION.Phase3Schedule_Type2.phase3starttime-(60*6+43.28)
		denathrius.nameplate.hp_TEMP=0.377 - (0.377 * sc.phasetime/TOTALPHASETIME)
		denathrius.nameplate.displayobject:SetFillPoints()

		sc:UpdateFakeRangedCamp()
	end

	function schedule.NeverTargetOK()
		for i=1,7 do
			local var="target_ff_"..tostring(i)
			if(XPRACTICE_SAVEDATA.INDIGNATION[var]==2)then
				return false
			end
		end
		return true	
	end
	
	
	
end