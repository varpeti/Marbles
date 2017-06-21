local player = {
	x=0,
	y=0,
	speed=500,
	mozgas=function(self,dt)
			if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
					self.x = self.x + (self.speed*dt)
			end
			if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
					self.x = self.x - (self.speed*dt)
			end
			if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
					self.y = self.y + (self.speed*dt)
			end
			if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
					self.y = self.y - (self.speed*dt)
			end
		end,
	pontok={},
	kijelolve=nil,
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
						local rr,gg,bb = math.random(0,255),math.random(0,255),math.random(0,255)
						local s = {
								cor=coords,
								col={rr,gg,bb},
								img=nil,
								ese=[[return {}]],
								nev=math.random(0,9e9),
							}
						if kijelolve then 
							map:addObj(kijelolve,s)
						else
							map:newObj({dyn=false,sha={s}})
						end
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
							if kijelolve==fixture then print(fixture:getUserData().usd) return end
							if kijelolve and kijelolve:getBody():getType()=="dynamic" then
								map:addJoint(kijelolve,fixture)
								kijelolve=nil
								return
							end
							kijelolve=fixture
							print(fixture:getUserData().usd)
							return
						end
					end
				end
				kijelolve=nil
			elseif button==3 then
				env:newKor(30,x,y,{255,255,255},nil,true,nil,"Ghost")
			elseif button==4 then
				for b,body in ipairs(env.world:getBodyList()) do
					for f,fixture in ipairs(body:getFixtureList()) do
						if fixture:testPoint(x,y) then
							map:delObj(fixture:getUserData().usd)
							env:delObj(fixture)
							kijelolve=nil
							return
						end
					end
				end
			
			elseif button==5 then
				for i=1,7 do
					env:newKor(30,x,y,{255,255,255},nil,true,nil,"Ghost")
				end
			end
		end,
	draw=function()
			if player.pontok then 
				love.graphics.setColor(255,255,255,255)
				for i,pont in ipairs(player.pontok) do
					love.graphics.circle("fill",pont.x,pont.y,2)
					love.graphics.print(math.floor(pont.x).." "..math.floor(pont.y),pont.x,pont.y)
				end
				love.graphics.circle("line",0,0,255)
			end
			if kijelolve then 
				love.graphics.setColor(255,255,255,255)
				local x,y = kijelolve:getBody():getPosition()
				love.graphics.circle("line",x,y,10)
			end
		end,
	billentyu=function(key, scancode, isrepeat)
			if key=="space" then
				marbles.start()
			end

			if kijelolve then
				if key=="e" then
					env:delObj(kijelolve)
					kijelolve=nil
					return
				elseif key=="q" then
					map:delObj(kijelolve:getUserData().usd)
				elseif key=="r" then
					map:setObj(kijelolve:getUserData().usd,[[return {init=function(fixture) fixture:getBody():setAngularVelocity(2.34567) end}]])
				elseif key=="t" then
					map:setObj(kijelolve:getUserData().usd,[[return {beginContact=function(fixture,b,coll) b:getBody():applyLinearImpulse(0,-6.54e3) end}]])
				elseif key=="z" then
					local x, y = kijelolve:getBody():getPosition()
					map:setObj(kijelolve:getUserData().usd,[[return {
						init=function(fixture) fixture:getBody():setLinearVelocity(0,-100) end, 
						time=function(fixture,dt) if os.time()%5==0 then fixture:getBody():setUserData({'pos',]]..x..[[,]]..y..[[}) end end}]])
				elseif key=="u" then
					map:setObj(kijelolve:getUserData().usd,[[return {beginContact=function(fixture,b,coll) b:getBody():setUserData({'pos',0,0}) end}]])
				elseif key=="i" then
					map:setDyn(kijelolve:getUserData().usd)
				elseif key=="o" then
					map:setObj(kijelolve:getUserData().usd,[[return {}]])
				elseif key=="p" then
					map:setObj(kijelolve:getUserData().usd,[[return {beginContact=function(fixture,b,coll) b:getBody():setUserData({'cel'}) end}]])
				elseif key=="f" then
					local x, y = kijelolve:getBody():getPosition()
					map:setObj(kijelolve:getUserData().usd,[[return {
						beginContact=function(fixture,b,coll) 
							local x1,y1 = b:getBody():getPosition()
							local x2,y2 = fixture:getBody():getPosition()
							if y1>y2 then		
								b:getBody():setUserData({'pos',x1,y2-(y1-y2)})
							end
						end,
						}]])
				end
				kijelolve=nil
				env:delObj() map.init() marbles.beert={}
			end
		end,
	}

return player
