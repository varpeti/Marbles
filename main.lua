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

	DEBUG = true

	map:load("w1.lua")

	map:save("w3.lua")

	canvas = love.graphics.newCanvas(kepernyo.asz,kepernyo.am)


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
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Back",0,0)

		env.draw()

		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Front",100,100)

		
	kamera:unset()
	love.graphics.setCanvas()

	love.graphics.draw(canvas)

	love.graphics.print("HUD",10,10)
end

function love.mousepressed(x, y, button, istouch)
	player.kattintas(x,y,button,istouch)
end