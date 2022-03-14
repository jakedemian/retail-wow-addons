XPRACTICE.Config.Indignation={}

--------------------------------------------------------------------------------
--
--	User-editable values.
--  Changes will not take effect until you /reload World of Warcraft.
--
--------------------------------------------------------------------------------

---------------------------------------------------------------------
-- WORLD MARKERS
---------------------------------------------------------------------
-- Positions MUST be in the format {x= , y= , z=0}
-- To hide a world marker, comment out the line with a double hyphen.
-- The SILVER MOON marker is automatically hidden when ravage bait is set to 0 degrees (default).

-- Default 24.
local WORLDMARKERDISTANCE=6*4
XPRACTICE.Config.Indignation.WorldMarkerREDXPosition =	 		{x=-WORLDMARKERDISTANCE, y=0, z=0}
XPRACTICE.Config.Indignation.WorldMarkerPURPLEDIAMONDPosition = {x=0, y=WORLDMARKERDISTANCE, z=0}
XPRACTICE.Config.Indignation.WorldMarkerGREENTRIANGLEPosition = {x=WORLDMARKERDISTANCE, y=0, z=0}
XPRACTICE.Config.Indignation.WorldMarkerYELLOWSTARPosition = 	{x=0, y=-WORLDMARKERDISTANCE, z=0}
-- Default 35.
local MOONDISTANCE=35
XPRACTICE.Config.Indignation.WorldMarkerSILVERMOONPosition =	{x=math.cos(-math.pi/6)*MOONDISTANCE,y=math.sin(-math.pi/6)*MOONDISTANCE,z=0}

---------------------------------------------------------------------
-- MASSACRE
---------------------------------------------------------------------
-- Default 0.333.  Time between Massacre telegraphs appearing from the same corner of the room.
XPRACTICE.Config.Indignation.MassacreTimeBetweenSwords=0.333
-- Default 0.333*2.5.  Time between Massacre triplets (three telegraphs per corner).
XPRACTICE.Config.Indignation.MassacreTimeBetweenTriplets=0.333*2.5
-- Default 3.75.  Width of Massacre's telegraph and hit detection.  (Telegraph size hasn't been thoroughly playtested and might not be accurate for different widths.)
XPRACTICE.Config.Indignation.MassacreLineWidth=3.75
-- Default 2.0.  Time between telegraph appearing and sword strike.  
-- A random number is picked between min and max.
-- (Actual time to hit will be slightly longer due to sword travel time.)	
XPRACTICE.Config.Indignation.MassacreTelegraphTimeMinimum=2.0
-- Default 2.5.  
XPRACTICE.Config.Indignation.MassacreTelegraphTimeMaximum=2.5

---------------------------------------------------------------------
-- FATAL FINESSE / SMOLDERING IRE DROPS
---------------------------------------------------------------------
-- Default 15.  Maximum tolerable distance from other player when dropping Fatal Finesse in pairs.
XPRACTICE.Config.Indignation.FatalFinessePairTolerance=15
-- Default 15.  Maximum tolerable distance from hint arrow when dropping Fatal Finesse solo.
XPRACTICE.Config.Indignation.FatalFinesseSoloTolerance=15
-- Default 15.  Maximum tolerable distance from where the hint arrow would have been when dropping Fatal Finesse solo with hint arrow turned off.
XPRACTICE.Config.Indignation.FatalFinesseSoloToleranceNoHints=15

---------------------------------------------------------------------
-- NEUTRALIZE
---------------------------------------------------------------------
-- Default 2.0.  Distance at which Neutralize triggers from opposite-realm players.
XPRACTICE.Config.Indignation.NeutralizeRadius=2.0

---------------------------------------------------------------------
-- DESOLATION
---------------------------------------------------------------------
-- Default 2.0.  Time at which the player dies from prolonged exposure to Desolation or Indignation.
XPRACTICE.Config.Indignation.DesolationTolerance=2.0

---------------------------------------------------------------------
-- CHANGE THESE LINES AT YOUR OWN RISK
---------------------------------------------------------------------
-- Default 0.0.  Approximate.
XPRACTICE.Config.Indignation.MassacreReflectionDelay=0.0
-- Default 1.0.  Must be greater than massacre delay.  If delay is too high, CPU dance might break.
XPRACTICE.Config.Indignation.RavageReflectionDelay=1.0