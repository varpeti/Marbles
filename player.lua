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
	pontok={},
	kattintas=function(x,y,button,istouch)
			x,y = kamera:worldCoords(x-kepernyo.Asz/2,y-kepernyo.Am/2)
			if button==1 then
				local van = false
				for i,pont in ipairs(player.pontok) do
					if math.sqrt((pont.x-x)^2+(pont.y-y)^2,2)<10 then
						van=true
						break
					end
				end
				if van then
					if #player.pontok>=3 and #player.pontok<=8 then
						local coords = {}
						for i,pont in ipairs(player.pontok) do
							table.insert(coords,pont.x)
							table.insert(coords,pont.y)
						end
						local rr,gg = math.random(0,255),math.random(0,255),0
						local bb = math.floor(255-(rr+gg)/2)
						local name = math.random(0,9e9)
						name = map:addObj(coords,{rr,gg,bb},name)
						env:newPoli(coords,{rr,gg,bb},nil,false,nil,name)
					end
					player.pontok={};
				else
					if #player.pontok>8 then return end
					table.insert(player.pontok,{x=x,y=y})
				end

			elseif button==2 then
				for b,body in ipairs(env.world:getBodyList()) do
					for f,fixture in ipairs(body:getFixtureList()) do
						if fixture:testPoint(x,y) then 
							map:delObj(fixture:getUserData().usd)
							env:delObj(fixture)
							return
						end
					end
				end
			elseif button==3 then
				env:newKor(15,x,y,{255,255,255},nil,true,nil)
			end
		end,
	draw=function()
			if not player.pontok then return end
			love.graphics.setColor(255,255,255,255)
			for i,pont in ipairs(player.pontok) do
				love.graphics.circle("fill",pont.x,pont.y,2)
				love.graphics.print(math.floor(pont.x).." "..math.floor(pont.y),pont.x,pont.y)
			end
			love.graphics.circle("line",0,0,255)
		end
	}

return player
