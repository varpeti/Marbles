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

	local kor = env:newKor(20,100,0,{100,100,0},"Data/n10.png",true)

	coords = {-10,-10,10,-10,70,70,-10,10}
	env:addPoli(kor:getBody(),coords,{0,100,100},"Data/n10.png")

	env:addKor(kor:getBody(),20,50,-200,{80,200,100},'Data/n10.png')

	kor:getBody():setLinearVelocity(0,-4)



	coords = {-10+60,-10+60,10+60,-10+60,70+60,70+60,-10+60,10+60}
	local kocka = env:newPoli(coords,{100,0,100},"Data/n10.png")

	env:addKor(kocka:getBody(),20,-100,0,{80,200,100},'Data/n10.png')

	coords = {-150,-150,-60,-80,-60,-60,-80,-60}
	env:addPoli(kocka:getBody(),coords,{0,100,100},"Data/n10.png")

	kocka:getBody():setAngularVelocity(0.4)


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