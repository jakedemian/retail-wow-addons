XPRACTICE.Config.Shriekwing={}

--------------------------------------------------------------------------------
--
--	User-editable values.
--  Changes will not take effect until you /reload World of Warcraft.
--
--------------------------------------------------------------------------------


---------------------------------------------------------------------
-- ROOM SIZE
---------------------------------------------------------------------
-- Default 12.  North/south distance between the center of the room and the center of the pillars.
XPRACTICE.Config.Shriekwing.PillarNSDistance=12

-- Default 15.  East/west distance between the center of the room and the center of the pillars.
XPRACTICE.Config.Shriekwing.PillarEWDistance=15

-- Default 40.  Distance between the center of the room and the north/south walls.
XPRACTICE.Config.Shriekwing.RoomNSRadius=40

-- Default 70.  Distance between the center of the room and the east/west walls.
XPRACTICE.Config.Shriekwing.RoomEWRadius=70

---------------------------------------------------------------------
-- PILLAR AND WALL COLLISION
---------------------------------------------------------------------
-- Default 1.0.  Distance the player can approach solid objects before running into them.
XPRACTICE.Config.Shriekwing.PlayerObjectCollisionRadius=1.0

-- Default 1.0.  Scales visible size of pillars.
XPRACTICE.Config.Shriekwing.PillarScale=1.0

-- Default 4.0*XPRACTICE.Config.Shriekwing.PillarScale.
-- Collision radius of pillars when checked against sonar projectiles (circle shape).
XPRACTICE.Config.Shriekwing.PillarRoughCollisionRadius=4.0*XPRACTICE.Config.Shriekwing.PillarScale

-- Default 5.25*XPRACTICE.Config.Shriekwing.PillarScale.  
-- Collision size of pillars when checked against the player (diamond shape).
-- (Specifically, the distance from the center of the pillar to the corner.)
XPRACTICE.Config.Shriekwing.PillarPreciseCollisionSize=5.25*XPRACTICE.Config.Shriekwing.PillarScale

-- Default false.  When true, collision lines will be visible around pillars.
XPRACTICE.Config.Shriekwing.PillarCollisionVisibility=false


---------------------------------------------------------------------
-- ECHOING SONAR
---------------------------------------------------------------------

-- Default 1.0.  DO NOT CHANGE THIS SETTING, HIT DETECTION WILL NOT SCALE WITH IT.
XPRACTICE.Config.Shriekwing.SonarScale=1.0

-- Default 1.0.  DO NOT CHANGE THIS SETTING, HIT DETECTION WILL NOT SCALE WITH IT.
XPRACTICE.Config.Shriekwing.SonarHeroicScaleMultiplier=1.0

-- Default 3.0.
-- Maximum distance between player and sonar projectile which will register a hit.
XPRACTICE.Config.Shriekwing.SonarPlayerCollisionRadiusStandard=3.0

-- Default 5.0.
-- Affects hit detection when set to "difficult" mode.
XPRACTICE.Config.Shriekwing.SonarPlayerCollisionRadiusDifficult=5.0

-- Default 3.0.
-- Collision radius of sonar projectiles when bouncing off objects.
XPRACTICE.Config.Shriekwing.SonarObjectCollisionRadius=3.0

-- (At some point in the future, sonar size may be further modified by savedata.)
-- (don't change this line)
XPRACTICE.Config.Shriekwing.SonarSavedataSizeMultiplier=1/16.0

-- Default 7.0.  Movement speed of sonar projectiles.  (Further modified by savedata.)
XPRACTICE.Config.Shriekwing.SonarSpeed=7.0

-- Default 0.25.  Affects how often sonar projectiles bounce directly towards the player when collision style is set to "cruel".
XPRACTICE.Config.Shriekwing.CrueltyRate=0.25



---------------------------------------------------------------------
-- SONAR SHRIEK
---------------------------------------------------------------------
-- Default true.  When true, Sonar Shriek causes Deadly Descent (and ghosts appear, if enabled).
-- When false, the player simply dies when hit (and no ghosts appear).
XPRACTICE.Config.Shriekwing.SonarShriekCausesDescent=false

-- Default false.  When true, the LOS detection line(s) for Sonar Shriek will be visible.
XPRACTICE.Config.Shriekwing.ShriekLOSVisibility=false

-- Default 4.5.  Shriekwing's LOS radius when ShriekLOSEdges is true.
XPRACTICE.Config.Shriekwing.ShriekwingShriekRadius=4.5

-- Default 0.5.  Player's LOS radius when ShriekLOSEdges is true.
XPRACTICE.Config.Shriekwing.PlayerShriekRadius=0.5

-- Determines Shriekwing's location when moving to the edge of the room to cast Sonar Shriek.
-- Used to be 40, 35, 25, 22.
-- Now 35, 30, 21, 19.
XPRACTICE.Config.Shriekwing.EastwestXCoordinate=35
XPRACTICE.Config.Shriekwing.DiagonalXCoordinate=30
XPRACTICE.Config.Shriekwing.NorthsouthYCoordinate=21
XPRACTICE.Config.Shriekwing.DiagonalYCoordinate=19


---------------------------------------------------------------------
-- DEADLY DESCENT
---------------------------------------------------------------------
-- Default 4.0.  Time player spends horrified during Deadly Descent.
XPRACTICE.Config.Shriekwing.DeadlyDescentHorrifyTime=4.0

-- Default 4.0.  Time until Shriekwing hits horrified player with Deadly Descent.
-- (Dungeon journal suggests this should be 5.0, but didn't appear to be that way during raid testing.)
XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionTime=4.0

-- Default 4.1.  Affects the grace period ("iframes") between sonar hits.
XPRACTICE.Config.Shriekwing.DeadlyDescentGracePeriod=4.1

-- Default 1.0*XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionRadius.
-- Scales visible size of the Deadly Descent telegraph circle.
XPRACTICE.Config.Shriekwing.DeadlyDescentTelegraphScale=1.0

-- Default 6.0*XPRACTICE.Config.Shriekwing.DeadlyDescentTelegraphScale.  
-- Radius of Deadly Descent's collision zone.
XPRACTICE.Config.Shriekwing.DeadlyDescentCollisionRadius=6.0*XPRACTICE.Config.Shriekwing.DeadlyDescentTelegraphScale

-- Default false.
-- If false, Deadly Descent will hit where the player was struck by sonar.
-- If true, Deadly Descent will hit the player's current position.
-- (This is relevant if collision time is greater than horrify time.)
XPRACTICE.Config.Shriekwing.DeadlyDescentTracksPlayer=false


---------------------------------------------------------------------
-- MURDER PREY
---------------------------------------------------------------------
-- Default 7.0.  Shriekwing's movement speed during intermission.  (Further modified by savedata.)
XPRACTICE.Config.Shriekwing.BossWalkSpeed=7.0

-- Default 12.0.  Radius of Murder Prey and its telegraph.
XPRACTICE.Config.Shriekwing.MurderPreyRadius=12.0

-- Default -0.00*XPRACTICE.Config.Shriekwing.MurderPreyRadius.  Affects the appearance of Murder Prey's telegraph.
-- (If the hit detection feels too forgiving, try changing this to -0.03*XPRACTICE.Config.Shriekwing.MurderPreyRadius)
XPRACTICE.Config.Shriekwing.MurderPreyTelegraphAdjustment=-0.00*XPRACTICE.Config.Shriekwing.MurderPreyRadius


---------------------------------------------------------------------
-- BLOOD LANTERN
---------------------------------------------------------------------
-- Default 4.0.  Blood Lantern's radius of effect when on the floor.
-- To disable, set to -1.
-- (Might also be disabled via savedata in the options menu.)
XPRACTICE.Config.Shriekwing.BloodLanternFloorRadius=4.0
-- Default 14.0.  Blood Lantern's radius of effect when carried.
XPRACTICE.Config.Shriekwing.BloodLanternCarriedRadius=14.0

-- Default 8.0.
XPRACTICE.Config.Shriekwing.BloodlightDuration=8.0
-- Default 2.0.  Unclear from logs exactly what the stack rate should be.
XPRACTICE.Config.Shriekwing.BloodlightApplicationRate=2.0

-- Default 0.25.  Affects how quickly the lantern ghost reacts to your Bloodlight stacks
-- when its behavior is set to "careful".
-- (Used to be 0.75, but travel time between lantern and hiding spot was too much.)
XPRACTICE.Config.Shriekwing.LanternGhostReactionTime=0.25
-- Default 2.0.  Affects how long the lantern ghost will hold the lantern before dropping it
-- when its behavior is set to "careful".
XPRACTICE.Config.Shriekwing.LanternGhostMaxHoldTime=3.0
-- Default 6.0.  Affects how long the lantern ghost will keep the lantern on the floor
-- when its behavior is set to "careful" and the player's stacks are low.
-- (Ghost will try not to drop the lantern while moving between hiding spots.)
--XPRACTICE.Config.Shriekwing.LanternGhostMaxFloorTime=6.0
XPRACTICE.Config.Shriekwing.LanternGhostMaxFloorTime=4.0

---------------------------------------------------------------------
-- ENEMY GHOSTS
---------------------------------------------------------------------
-- Default 12.0.  Maximum radius within which enemy ghosts will appear.
XPRACTICE.Config.Shriekwing.EnemyGhostRadius=12.0
-- Default 0.0015.  Affects the rate at which enemy ghosts spawn from Echoing Sonar.
XPRACTICE.Config.Shriekwing.EnemyGhostSonarRate=0.0015
-- Default 2.0.  Affects the rate at which enemy ghosts spawn from Echoing Sonar.
XPRACTICE.Config.Shriekwing.EnemyGhostSonarCooldown=2.0
-- Default 5.  Affects the rate at which enemy ghosts spawn from Sonar Shriek.
XPRACTICE.Config.Shriekwing.EnemyGhostShriekAttempts=5
-- Default 5.  Affects the rate at which enemy ghosts spawn from Sonar Shriek.
XPRACTICE.Config.Shriekwing.EnemyGhostShriekRate=0.5

