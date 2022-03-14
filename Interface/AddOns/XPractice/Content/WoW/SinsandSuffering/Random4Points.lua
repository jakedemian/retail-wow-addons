do
	XPRACTICE.SINSANDSUFFERING.Random4Points={}
	local class=XPRACTICE.SINSANDSUFFERING.Random4Points
	-- commissioners are using "anchor" and "point man" to refer to the vertices of the player triangle.
	
	function class.GetAnchorOffset()
		if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.ContainerLevel>=2)then
			--return 2.5
			--return 2.0
			return 4.0
		else
			--return 1
			return 0.5
		end
	end
	
	--static function!
	function class.Generate_2Anchors(solutionpoints)
		local ANCHOROFFSET=class.GetAnchorOffset()
		
		local finalx={}
		local finaly={}
		local sinpoints={}
		
		
		local x={}
		local y={}
		for i=1,3 do
			x[i]=solutionpoints[i].x;y[i]=solutionpoints[i].y
		end
		
		--anchors are the ends of the shortest line segment
		local shortestsegment=nil
		local shortestdistsqr=nil		
		for i=1,3 do
			local k
			k=1
			local ind={}
			for j=1,3 do
				if(j~=i)then
					-- segment that does NOT include point i
					ind[k]=j
					k=k+1
				end
			end
			local distsqr=XPRACTICE.distsqr(x[ind[1]],y[ind[1]],x[ind[2]],y[ind[2]])
			if(shortestsegment==nil or distsqr<shortestdistsqr)then
				shortestdistsqr=distsqr
				shortestsegment=i
			end
		end
		local pointman=shortestsegment
		
		--local pointman=math.floor(math.random()*3)+1
		local anchors={}
		local j=1
		for i=1,3 do
			solutionpoints[i].shape=XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR2
			if(i~=pointman)then				
				solutionpoints[i].role=XPRACTICE.SINSANDSUFFERING.ROLE.ANCHOR
				anchors[j]=i
				j=j+1
			else
				solutionpoints[i].role=XPRACTICE.SINSANDSUFFERING.ROLE.POINTMAN
			end
		end
		-- print("anchors:",anchors[1],anchors[2])
		-- print("pointman:",pointman)
		
		
		for j=1,2 do			
			local i=anchors[j]
			local otheranchor
			if(j==1)then otheranchor=2 else otheranchor=1 end
			local whichline
			if(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUAnchorAlignment==1)then
				whichline=pointman
			elseif(XPRACTICE_SAVEDATA.SINSANDSUFFERING.CPUAnchorAlignment==2)then
				whichline=anchors[otheranchor]
			else
				if(math.random()>0.5)then whichline=anchors[otheranchor] else whichline=pointman end
			end
			local distx=(x[whichline]-x[i])
			local disty=(y[whichline]-y[i])
			local dist=math.sqrt(distx*distx+disty*disty)
			local unitvectorx=distx/dist
			local unitvectory=disty/dist
			sinpoints[j]={}
			sinpoints[j].x=x[i]+unitvectorx*ANCHOROFFSET
			sinpoints[j].y=y[i]+unitvectory*ANCHOROFFSET
		end
		
		for j=1,2 do
			local i=anchors[j]
			local x1=x[i]
			local y1=y[i]
			local x2=x[pointman]
			local y2=y[pointman]	
			sinpoints[j+2]={}
			sinpoints[j+2].x,sinpoints[j+2].y=class.PointAlongLine(x1,y1,x2,y2)
		end

		class.LinkPointsTogether(sinpoints,1,2)
		class.LinkPointsTogether(sinpoints,2,4)
		class.LinkPointsTogether(sinpoints,4,3)
		class.LinkPointsTogether(sinpoints,3,1)

		
		--print(finalx[1],finaly[1],finalx[2],finaly[2],finalx[3],finaly[3],finalx[4],finaly[4])
		--return finalx[1],finaly[1],finalx[2],finaly[2],finalx[3],finaly[3],finalx[4],finaly[4]		
		return sinpoints
	end
	
	function class.Generate_1Anchor(solutionpoints)
		local ANCHOROFFSET=class.GetAnchorOffset()
		
		local finalx={}
		local finaly={}
		local sinpoints={}		
		
		local x={}
		local y={}
		for i=1,3 do
			x[i]=solutionpoints[i].x;y[i]=solutionpoints[i].y
		end
		
		--pointmans are the end of the longest segment
		local longestsegment=nil
		local longestdistsqr=nil		
		for i=1,3 do
			local k
			k=1
			local ind={}
			for j=1,3 do
				if(j~=i)then
					-- segment that does NOT include point i
					ind[k]=j
					k=k+1
				end
			end
			local distsqr=XPRACTICE.distsqr(x[ind[1]],y[ind[1]],x[ind[2]],y[ind[2]])
			if(longestsegment==nil or distsqr>longestdistsqr)then
				longestdistsqr=distsqr
				longestsegment=i
			end
		end
		local anchor=longestsegment
		--local anchor=math.floor(math.random()*3)+1
		local pointmans={}
		local j=1
		for i=1,3 do
			solutionpoints[i].shape=XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR1
			if(i~=anchor)then
				solutionpoints[i].role=XPRACTICE.SINSANDSUFFERING.ROLE.POINTMAN
				pointmans[j]=i
				j=j+1
			else
				solutionpoints[i].role=XPRACTICE.SINSANDSUFFERING.ROLE.ANCHOR
			end
		end
		-- print("anchors:",anchors[1],anchors[2])
		-- print("pointman:",pointman)		

		local whichline
		if(math.random()>0.5)then whichline=pointmans[1] else whichline=pointmans[2] end
		local distx=(x[whichline]-x[anchor])
		local disty=(y[whichline]-y[anchor])
		local dist=math.sqrt(distx*distx+disty*disty)
		local unitvectorx=distx/dist
		local unitvectory=disty/dist
		sinpoints[1]={}
		sinpoints[1].x=x[anchor]+unitvectorx*ANCHOROFFSET
		sinpoints[1].y=y[anchor]+unitvectory*ANCHOROFFSET
		
		sinpoints[2]={}
		sinpoints[2].x,sinpoints[2].y=class.PointAlongLine(x[anchor],y[anchor],x[pointmans[1]],y[pointmans[1]])
		sinpoints[3]={}
		sinpoints[3].x,sinpoints[3].y=class.PointAlongLine(x[anchor],y[anchor],x[pointmans[2]],y[pointmans[2]])
		sinpoints[4]={}
		sinpoints[4].x,sinpoints[4].y=class.PointAlongLine(x[pointmans[1]],y[pointmans[1]],x[pointmans[2]],y[pointmans[2]],0.25,0.75)

		class.LinkPointsTogether(sinpoints,1,2)
		class.LinkPointsTogether(sinpoints,2,4)
		class.LinkPointsTogether(sinpoints,4,3)
		class.LinkPointsTogether(sinpoints,3,1)

		
		--print(finalx[1],finaly[1],finalx[2],finaly[2],finalx[3],finaly[3],finalx[4],finaly[4])
		--return finalx[1],finaly[1],finalx[2],finaly[2],finalx[3],finaly[3],finalx[4],finaly[4]		
		return sinpoints
	end	
	
	
	function class.Generate_0Anchors(solutionpoints)
		local finalx={}
		local finaly={}
		local sinpoints={}
		
		local x={}
		local y={}
		for i=1,3 do
			x[i]=solutionpoints[i].x;y[i]=solutionpoints[i].y
		end
		
		--pointman3s are the ends of the shortest line segment
		local shortestsegment=nil
		local shortestdistsqr=nil		
		for i=1,3 do
			local k
			k=1
			local ind={}
			for j=1,3 do
				if(j~=i)then
					-- segment that does NOT include point i
					ind[k]=j
					k=k+1
				end
			end
			local distsqr=XPRACTICE.distsqr(x[ind[1]],y[ind[1]],x[ind[2]],y[ind[2]])
			if(shortestsegment==nil or distsqr<shortestdistsqr)then
				shortestdistsqr=distsqr
				shortestsegment=i
			end
		end
		local pointman2=shortestsegment
		
		--local pointman2=math.floor(math.random()*3)+1
		local pointman3s={}
		local j=1
		for i=1,3 do
			solutionpoints[i].shape=XPRACTICE.SINSANDSUFFERING.SHAPE.ANCHOR0
			if(i~=pointman2)then
				solutionpoints[i].role=XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_3
				pointman3s[j]=i
				j=j+1
			else
				solutionpoints[i].role=XPRACTICE.SINSANDSUFFERING.ROLE.INVERSE_POINTMAN_2
			end
		end
		
		
		for j=1,2 do
			local whichline=pointman3s[j]
			local x1=x[pointman2]
			local y1=y[pointman2]
			local x2=x[whichline]
			local y2=y[whichline]	
			sinpoints[j]={}
			sinpoints[j].x,sinpoints[j].y=class.PointAlongLine(x1,y1,x2,y2)
		end
		
		local x1=x[pointman3s[1]]
		local y1=y[pointman3s[1]]
		local x2=x[pointman3s[2]]
		local y2=y[pointman3s[2]]	
		sinpoints[3]={}
		sinpoints[4]={}
		sinpoints[3].x,sinpoints[3].y,sinpoints[4].x,sinpoints[4].y=class.TwoPointsAlongLine(x1,y1,x2,y2)
		
		
		class.LinkPointsTogether(sinpoints,1,2)
		class.LinkPointsTogether(sinpoints,2,4)
		class.LinkPointsTogether(sinpoints,4,3)
		class.LinkPointsTogether(sinpoints,3,1)
		
		--print(finalx[1],finaly[1],finalx[2],finaly[2],finalx[3],finaly[3],finalx[4],finaly[4])
		--return finalx[1],finaly[1],finalx[2],finaly[2],finalx[3],finaly[3],finalx[4],finaly[4]		
		return sinpoints
	end
	
	function class.PointAlongLine(x1,y1,x2,y2,MINDIST,MAXDIST)
		if(not MINDIST)then MINDIST=1/4.0 end
		if(not MAXDIST)then MAXDIST=3/4.0 end
		local dist=math.random()*(MAXDIST-MINDIST)+MINDIST
		local x=x1+(x2-x1)*dist
		local y=y1+(y2-y1)*dist
		return x,y
	end
	
	function class.TwoPointsAlongLine(x1,y1,x2,y2,MINDIST,MAXDIST,MINBETWEENDIST,MAXBETWEENDIST)
		if(not MINDIST)then MINDIST=1/4.0 end
		if(not MAXDIST)then MAXDIST=3/4.0 end
		if(not MINBETWEENDIST)then MINBETWEENDIST=1/4.0 end
		if(not MAXBETWEENDIST)then MAXBETWEENDIST=MAXDIST-MINDIST end
		local betweendist=math.random()*(MAXBETWEENDIST-MINBETWEENDIST)+MINBETWEENDIST
		local dist=math.random()*(MAXDIST-betweendist-MINDIST)+MINDIST
		local xA=x1+(x2-x1)*dist
		local yA=y1+(y2-y1)*dist
		local xB=x1+(x2-x1)*(dist+betweendist)
		local yB=y1+(y2-y1)*(dist+betweendist)
		--print("dists",dist,dist+betweendist)
		return xA,yA,xB,yB
	end

	function class.LinkPointsTogether(sinpoints,one,two)
		sinpoints[one].next=sinpoints[two]
		sinpoints[two].prev=sinpoints[one]
	end
end