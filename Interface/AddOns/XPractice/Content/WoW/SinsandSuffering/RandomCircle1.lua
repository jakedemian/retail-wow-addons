do
	XPRACTICE.SINSANDSUFFERING.RandomCircle1={}
	
	--static function!
	function XPRACTICE.SINSANDSUFFERING.RandomCircle1.Generate()
		-- local MINRADIUS=20		
		-- local MAXRADIUS=40		
		-- local ARENARADIUS=50
		--local MINRADIUS=15
		local MINRADIUS=20
		local MAXRADIUS=30		
		local ARENARADIUS=40
			
		local radius=math.random()*(MAXRADIUS-MINRADIUS)+MINRADIUS
		
		--print("radius:",radius)
		local max_center_variance=ARENARADIUS-radius
		if(max_center_variance<0)then max_center_variance=0 end
		local centerx,centery=XPRACTICE.RandomPointInCircle(0,0,max_center_variance)
		
		return centerx,centery,radius
	end


end