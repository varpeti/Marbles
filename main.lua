kamera = require('kamera')
kepernyo = require('kepernyo')
player = require('player')
env = require('env')
marbles = require('marbles')
map = require('map')


function love.load()

	kepernyo:setmode(0,0,2,true)
	love.window.setTitle("Marble Race - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))

	font = love.graphics.newFont(12)

	DEBUG = true

	env.setCallbacks()

	map:load("w1.luw")

	math.randomseed(os.time())


end

function love.update(dt)
	player:mozgas(dt)
	env:update(dt)
	marbles.update(dt)

	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function love.draw()

	kamera:aPos(player.x,player.y)
	kamera:set()

		env.draw()
		player.draw()
		
	kamera:unset()

	marbles.hud()
end

function love.quit()
	map:save("w1.luw")
end

function love.mousepressed(x, y, button, istouch)
	player.kattintas(x,y,button,istouch)
end

function love.wheelmoved(x,y)
	if y>0 then kamera:rScale(-0.0125) player.speed=player.speed-10 end
	if y<0 then kamera:rScale(0.0125) player.speed=player.speed+10 end
end

function love.keypressed(key, scancode, isrepeat)
	player.billentyu(key, scancode, isrepeat)
end