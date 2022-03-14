--TODO: less function closures to preserve RAM

do
	XPRACTICE.INDIGNATION.Phase3Schedule_TextForecast={}
	local class=XPRACTICE.INDIGNATION.Phase3Schedule_TextForecast

	function class.RunTextForecast(schedule,sc,CalcDelay)
		sc:ForecastLabelAfterDelay("Next: Knockback",CalcDelay(60*6+56.63-5.0),6.0)
		sc:ForecastLabelAfterDelay("Next: Blood Price > Seeds 1",CalcDelay(60*7+03.93-5.0),9.0)
		sc:ForecastLabelAfterDelay("Next: Knockback > Ranged Time Warp",CalcDelay(60*7+22.14-6.0))
		sc:ForecastLabelAfterDelay("Next: Seeds 2",CalcDelay(60*7+32.76-6.0))
		sc:ForecastLabelAfterDelay("Next: Knockback > Bait",CalcDelay(60*7+44.03-6.0))
		sc:ForecastLabelAfterDelay("Next: Massacre > Speed Boost > Seeds 3",CalcDelay(60*7+53.73-6.0),9.0)
		sc:ForecastLabelAfterDelay("Next: Knockback",CalcDelay(60*8+08.36-6.0))
		sc:ForecastLabelAfterDelay("Next: Blood Price > Seeds 4 > Mirror Time Warp",CalcDelay(60*8+16.86-6.0),9.0) --TODO: we're TWing half a second early
		sc:ForecastLabelAfterDelay("Next: Knockback > Bait",CalcDelay(60*8+32.63-6.0))
		sc:ForecastLabelAfterDelay("(About 15 seconds of free time!)",CalcDelay(60*8+33.63+5.0))
		sc:ForecastLabelAfterDelay("Next: Massacre > Knockback > Seeds 5",CalcDelay(60*8+53.27-6.0),11.0)
		sc:ForecastLabelAfterDelay("Next: Knockback > Blood Price",CalcDelay(60*9+20.00-6.0),11.0)
		sc:ForecastLabelAfterDelay("Next: Seeds 6 > FAST SOAK > Knockback",CalcDelay(60*9+34.76-6.0),9.0)
		sc:ForecastLabelAfterDelay("Next: Seeds 7 (not soaked) > Massacre > END",CalcDelay(60*9+47.80-3.0),11.0)
	end
	
end