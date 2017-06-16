local player = {
	x=0,
	y=0,
	speed=500,
	mozgas=function(self,dt)
			if love.keyboard.isDown("right") then
					self.x = self.x + (self.speed*dt)
			end
			if love.keyboard.isDown("left") then
					self.x = self.x - (self.speed*dt)
			end
			if love.keyboard.isDown("down") then
					self.y = self.y + (self.speed*dt)
			end
			if love.keyboard.isDown("up") then
					self.y = self.y - (self.speed*dt)
			end
		end,
	kattintas=function(self,x,y,button,istouch)
	end,
	}

return player
