XPRACTICE.FATESCRIBEMULTIPLAYER.Config={}

--------------------------------------------------------------------------------
--
--	User-editable values.
--  Changes will not take effect until you /reload World of Warcraft.
--
--  When playing with a group, all players should have identical config files.
--------------------------------------------------------------------------------

---------------------------------------------------------------------
-- WORLD MARKERS
---------------------------------------------------------------------
-- World markers have been moved in-game.
-- /xp wm # to place a marker.
-- /xp cwm # to clear a marker, or /xp cwm all to clear all of them.

---------------------------------------------------------------------
-- LAYOUT
---------------------------------------------------------------------
-- Default 60.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.ArenaRadius=60

---------------------------------------------------------------------
-- KNOCKBACK
---------------------------------------------------------------------
-- Default 6.8.  Includes spawn/despawn animations.  Knockback happens when despawn animation has completed.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.SwirlyWindDuration=6.8

---------------------------------------------------------------------
-- RINGS (The Loom of Fates)
---------------------------------------------------------------------
-- Default 0.15.  Radians per second.
-- (Approx 43 seconds for full revolution.)
-- (Seems to be about 20% faster than it was on PTR.)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingSpeed=0.15
-- Higher number = more inertia when ring is stopped.  (Mindeadzone speed is subtracted from current speed.)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MinRingSpeedDeadZone=0.0875
-- Higher number = more inertia when ring is moving.  (Speed increases past RingSpeed until it hits maxdeadzone.)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.MaxRingSpeedDeadZone=0.175

-- Default 0.115.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingAcceleration=0.115
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingDeceleration=0.115
-- Used only during the initial animation.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingScrambleSpeed=0.125*5
-- Measured in radians.  Might be 0 in the actual game.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingScrambleMinimumDistance=math.pi/8
-- Default 2.25.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.RingRuneHitboxRadius=2.25


-- "Exposed Threads of Fate"
-- Default 1.0.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathHitbox=1.0
-- If player is within this distance of the center of the line's control rune, the line won't kill them.
	-- (mostly used to avoid killing player if they step off the rune towards the center)
-- Default 0.0.  (Was 8.0 during playtesting; apparently the real game isn't as merciful)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathRingRuneTolerance=0.0
-- Default 3.0.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.LineOfDeathDistanceFromRune=3.0

---------------------------------------------------------------------
-- ORBS (Fragmented Fate)
---------------------------------------------------------------------
-- Default 1.0.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbMovementDelay=1.0
-- Default 3.4.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpeed=3.4
-- Default 5.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.EternityOrbCount=5
-- Default 6.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerCount=6
-- Default 50.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerDistance=53.5
-- Default -0.03125.  Radians per second.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerSpeed=-0.03125
-- Default 4.0.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnRate=4.0
-- Default 1.66.  (Was 2.75 during playtesting, but we forgot to apply square root.)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbHitboxRadius=1.66
-- (no longer used; orbs are now soakable)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbGracePeriod=2.0
-- Default 1.0.  (Not sure if this grace period exists in the real game, so we made it very brief)
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerGracePeriod=1.0
-- Default 4.0.
XPRACTICE.FATESCRIBEMULTIPLAYER.Config.OrbSpawnerHitboxRadius=4.0

