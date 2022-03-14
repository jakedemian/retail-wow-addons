do
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_GetPlayerPosition=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_GetPlayerPosition
		
		
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="(Get Player Position)"
			self.icon="interface/icons/icon_treasuremap.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		
		--/run WorldMapFrame:SetFrameStrata("BACKGROUND");ChatFrame1:SetFrameStrata("DIALOG")
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local player=self.scenario.player
			local camera=self.scenario.game.environment_gameplay.cameramanager.camera
			print("XYZ",player.position.x,player.position.y,player.position.z)
			print("dist:",math.sqrt(player.position.x*player.position.x+player.position.y*player.position.y))			
			print("Camera:",camera.cdist)
			print("Yaw",player.orientation_displayed.yaw)
			local playerangle=math.atan2(player.position.x,player.position.y)
			print("Angle:",playerangle)
			
			local safeangle=-math.pi/6
			local playerangle=math.atan2(player.position.x,player.position.y)
			local x1=10*math.cos(safeangle)
			local y1=10*math.sin(safeangle)
			local x2=40*math.cos(safeangle)
			local y2=40*math.sin(safeangle)
			-- print("1",XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,1))
			-- print("2",XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,2))
			-- print("3",XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,3))
			-- print("4",XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,4))
			-- print("5",XPRACTICE.LineCircleCollision(x1,y1,x2,y2,player.position.x,player.position.y,5))
		end
	end

	XPRACTICE.INDIGNATION.Layout={}
	local layout=XPRACTICE.INDIGNATION.Layout
	-- 572-221=90yds?
	--layout.scale=90.0/(572-221)	
	layout.scale=100.0/(572-221)	
	layout.center={x=0,y=0}
	--TODO LATER: don't keep points as global static memory after we're done with them
	layout.points={}
	--local OUTLINEZ=0.25
	local OUTLINEZ=0.05
	
	local centerx=946
	local centery=572
	
	function layout.Reset()
		layout.points={}
	end
	
	function layout.SetCenter(x,y)
		x,y=x,-y
		layout.center={x=x,y=y}
	end

	function XPRACTICE.INDIGNATION.Layout.Point(x,y,rotation)
		--x,y=-y,-x
		x,y=x,-y
		
		local xx=(x-layout.center.x)*layout.scale
		local yy=(y-layout.center.y)*layout.scale	
		xx,yy=XPRACTICE.Transform_Rotate2D(xx,yy,-math.pi/2*rotation,0,0)	--clockwise		
		tinsert(layout.points,{x=xx,y=yy,z=OUTLINEZ})
	end
	
	function XPRACTICE.INDIGNATION.Layout.Reflect(rotation)
		local p=#layout.points
		for i=p-1,2,-1 do		
			local xx,yy
			xx,yy=layout.points[i].x,layout.points[i].y
			if(rotation==0 or rotation==2)then
				xx,yy=-xx,yy
			else
				xx,yy=xx,-yy
			end
			tinsert(layout.points,{x=xx,y=yy,z=OUTLINEZ})
		end
	end
	
	function XPRACTICE.INDIGNATION.Layout.ReflectRotate4()
		local p=#layout.points
		for r=1,3 do
			for i=1,p do	
				local xx,yy
				xx,yy=layout.points[i].x,layout.points[i].y
				xx,yy=XPRACTICE.Transform_Rotate2D(xx,yy,-math.pi/2*r,0,0)	--clockwise
				tinsert(layout.points,{x=xx,y=yy,z=OUTLINEZ})
			end
		end
	end
	
	function XPRACTICE.INDIGNATION.Layout.Bake(scenario,movespeed)
		movespeed=movespeed or 2
		local line
		line=XPRACTICE.MultiVisibleLine.new()
		line:Setup(scenario.game.environment_gameplay,layout.points[1].x,layout.points[1].y,layout.points[1].z)
		for i=2,#layout.points do
			line:AddPoint(layout.points[i].x,layout.points[i].y,layout.points[i].z)
		end
		line:ChangeLineActorID(970786,0,0)
		line.movespeed=movespeed	--default 2
	end
	
	function XPRACTICE.INDIGNATION.Layout.CreatePoints(rotation)
		layout.SetCenter(centerx,centery)			
		layout.Reset()
		--INNER CORNER
		local offset=0
		--offset=-58	-- comment out; used for corner alignment testing only
		--layout.Point(centerx-78.5+offset,centery-78.5+offset,rotation) -- align with red mist	
		--layout.Point(866+offset,467+offset,rotation)	
		--layout.Point(861+offset,444+offset,rotation)			
		layout.Point(centerx-80+offset,centery-80+offset,rotation) -- do not align with red mist -- corner
		layout.Point(863+offset,467+offset,rotation)	-- corner 2				
		
		--INVERT CIRCLE
		layout.Point(855+offset,448+offset,rotation)	-- corner 3 (widest)
		layout.Point(872,427,rotation)	--mid
		layout.Point(879,405,rotation)	--wide
		
		--WIDE/THIN BOUNDARY
		--layout.Point(890,295,rotation)
		--layout.Point(920,291,rotation)	-- align with red mist
		--layout.Point(920,228,rotation)		
		layout.Point(890,301,rotation)
		layout.Point(912,292,rotation)		-- inside red mist
		layout.Point(915,228,rotation)		
		
		--NORTH
		layout.Point(946,221,rotation)

		layout.Reflect(rotation)
		layout.ReflectRotate4()	
	end

	function XPRACTICE.INDIGNATION.Layout.CreateFloorOutline(scenario,rotation)
		if(rotation==nil)then rotation=0 end
		layout.CreatePoints(rotation)
		layout.Bake(scenario)
	end
	
	function XPRACTICE.INDIGNATION.Layout.CreateOuterPlatformsPoints(rotation)
		layout.SetCenter(centerx,centery)			
		layout.Reset()
		layout.Point(centerx-253,centery-253,0) -- curve mid
		layout.Point(649,371,0) -- curve halfway
		layout.Point(619,431,0) -- curve west
		layout.Point(648,443,0) -- indent
		layout.Point(649,460,0) -- hook
		layout.Point(714,447,0) -- halfway to corner
		layout.Point(761,427,0) -- corner west
		layout.Point(784,434,0) -- corner halfway
		--layout.Point(810,437,0) -- corner point
		layout.Point(centerx-137,centery-137,0) -- corner point
		-- if(DevTools_Dump)then
			-- DevTools_Dump(layout.points[#layout.points])
		-- end		
		layout.OuterPlatformsReflect()

		for i=1,#layout.points do
			local x,y=layout.points[i].x,layout.points[i].y
			x,y=XPRACTICE.Transform_Rotate2D(x,y,-math.pi/2*rotation,0,0)	--clockwise
			layout.points[i].x,layout.points[i].y=x,y
		end
	end
	
	function XPRACTICE.INDIGNATION.Layout.OuterPlatformsReflect()	
		for i=#layout.points-1,2,-1 do
			local x,y=layout.points[i].x,layout.points[i].y
			x,y=-y,-x
			tinsert(layout.points,{x=x,y=y,z=OUTLINEZ})
		end
	end
	
	function XPRACTICE.INDIGNATION.Layout.CreateOuterPlatformsOutline(scenario)
		for i=0,3 do
			layout.CreateOuterPlatformsPoints(i)
			layout.Bake(scenario,4)
		end
	end
	
	function XPRACTICE.INDIGNATION.Layout.CreateInnerCirclePoints(rotation)
		layout.SetCenter(centerx,centery)			
		layout.Reset()
		--INNER CORNER
		local offset=0
		layout.Point(centerx-80+offset,centery-80+offset,rotation) -- do not align with red mist -- corner
		layout.Point(863+offset,467+offset,rotation)	-- corner 2						
		--INVERT CIRCLE
		layout.Point(855+offset,448+offset,rotation)	-- corner 3 (widest)
		layout.Point(872,427,rotation)	--mid
		for i=4,5,0.5 do
			local angle=-math.pi*(0.1*i)+math.pi
			local dist=165	--this is still measured in screenshot pixels, not yards			
			layout.Point(centerx+dist*math.cos(angle),centery-dist*math.sin(angle),rotation)
		end
		
		layout.Reflect(rotation)
		layout.ReflectRotate4()	
	end	
	
	function XPRACTICE.INDIGNATION.Layout.CreateInnerCircleOutline(scenario,rotation)
		if(rotation==nil)then rotation=0 end
		layout.CreateInnerCirclePoints(rotation)
		layout.Bake(scenario)
	end
	
	function XPRACTICE.INDIGNATION.Layout.BakeEdgeDetectionLines(scenario)
		for i=1,#layout.points do
			local i2=i+1
			if(i2>#layout.points)then i2=1 end
			local x1=layout.points[i].x
			local y1=layout.points[i].y
			local x2=layout.points[i2].x
			local y2=layout.points[i2].y
			if(y1>y2)then x1,x2=x2,x1; y1,y2=y2,y1 end
			--if(y1~=y2)then	--TODO: uncomment maybe?
				tinsert(scenario.edgelines,{x1=x1,y1=y1,x2=x2,y2=y2})
			--end
		end		
	end
	
	function XPRACTICE.INDIGNATION.Layout.CreateEdgeDetectionLines(scenario)
		for i=0,3 do
			layout.CreateOuterPlatformsPoints(i)
			layout.BakeEdgeDetectionLines(scenario)
		end
		layout.CreatePoints(0)
		layout.BakeEdgeDetectionLines(scenario)
	end
	
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------
	
	layout.replaycenterx=9357.82
	layout.replaycentery=-1901.48
	
	function XPRACTICE.INDIGNATION.Layout.ConvertScreenshotCoords(x,y)
		return {x=x-layout.replaycenterx,y=y-layout.replaycentery}
	end
	
	
end