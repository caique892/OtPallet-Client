local updaterName = "WakiVAuto-Update"
local start = 0
function init()	
	cycleEvent(updateStart, 1000)
end

function updateStart()
	if g_app.isRunning() and not g_game.isOnline() then
		if start == 0 then
			local cmd = "C:\\OTClient\\OTClient\\"..updaterName..".exe" 
			os.execute('start /min cmd /c ' .. cmd)
			start = 1
		end
	end
end

function terminate()
    start = 0
end