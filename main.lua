kamera = require('kamera')
kepernyo = require('kepernyo')
player = require('player')
env = require('env')
marbles = require('marbles')
map = require('map')


function love.load()

	kepernyo:setmode(1920-192,1080-108,0,true)
	love.window.setTitle("Marble Race - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))

	DEBUG = false

	env.setCallbacks()

	map:load("w1.luw")

	canvas = love.graphics.newCanvas(kepernyo.asz,kepernyo.am)

	math.randomseed(os.time())


end

function love.update(dt)
	player:mozgas(dt)
	env:update(dt)

	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function love.draw()
	--love.graphics.setCanvas(canvas)
	kamera:aPos(player.x,player.y)
	kamera:set()

		env.draw()
		player.draw()
		
	kamera:unset()
	love.graphics.setCanvas()

	love.graphics.draw(canvas)

	love.graphics.print("HUD",10,10)
end

function love.quit()
	map:save("w1.luw")
end

function love.mousepressed(x, y, button, istouch)
	player.kattintas(x,y,button,istouch)
end

function love.wheelmoved(x,y)
	if y>0 then kamera:rScale(-0.1) end
	if y<0 then kamera:rScale(0.1) end
end

function love.keypressed(key, scancode, isrepeat )
	if key=="space" then
		marbles.start()
	end
end