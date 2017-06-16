local kepernyo = {}
kepernyo.modes = {}

local function getResolutions(monitorid)
	monitorid = monitorid or 1 
	local modes = love.window.getFullscreenModes(monitorid)
	table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end) -- sort from largest to smallest
	return modes
end

function kepernyo:getModes(monitorid)
	monitorid = monitorid or 1
	self.modes = getResolutions(monitorid)
	return self.modes()
end

function kepernyo:setmode(w,h,wind_full_bord,vsync,msaa,display)
	w = w or 0
	h = h or 0
	wind_full_bord = wind_full_bord or 0
	msaa = msaa or 0
	display = display or 1
	local mode = {}
	if wind_full_bord==0 then
		mode = {
			fullscreen = false,
			fullscreentype = "desktop",
			vsync = vsync,
			msaa = msaa,
			display = display
		}
	elseif wind_full_bord==1 then
		mode = {
			fullscreen = true,
			fullscreentype = "exclusive",
			vsync = vsync,
			msaa = msaa,
			display = display
		}
	elseif wind_full_bord==2 then
		mode = {
			fullscreen = true,
			fullscreentype = "desktop",
			vsync = vsync,
			msaa = msaa,
			display = display
		}
	end
	love.window.setMode(w,h,mode)
	kepernyo.Asz=love.graphics.getWidth()
	kepernyo.Am=love.graphics.getHeight()
end

kepernyo.modes = getResolutions()
kepernyo.Asz=love.graphics.getWidth()
kepernyo.Am=love.graphics.getHeight()

return kepernyo