local player = {
	x=0,
	y=0,
	speed=500,
	--vonal={Wrath={},Lust={},Greed={},Sloth={},Gluttony={},Envy={},Pride={}},
	--counter=0,
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
			if player.kamlock then 
				local min = {0,0}
				local avg = {0,0,0}
				local vok = false
				--player.counter=player.counter+dt if player.counter>0.5 then player.counter=player.counter-0.5 vok=true end
				for b,body in ipairs(env.world:getBodyList()) do
					if body:getFixtureList()[1]:getShape():getType()=="circle" then
						local x,y = body:getPosition()
						--if vok then table.insert(player.vonal[body:getFixtureList()[1]:getUserData().usd],{x,y}) end
						avg = {avg[1]+x,avg[2]+y,avg[3]+1}
						if min[2]<y then 
							min = {x,y}
						end
					end
				end
				avg = {avg[1]/avg[3],avg[2]/avg[3]}
				local v = --{avg[1]-self.x,avg[2]-self.y}
						{min[1]-self.x,min[2]-self.y}
				local tav = 15--(v[1]^2+v[2]^2)^(1/2)
				self.x=self.x+(v[1])/tav
				self.y=self.y+(v[2])/tav
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
							if kijelolve~=nil and kijelolve:getBody()==fixture:getBody() then print(fixture:getUserData().usd) return end
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
	kamlock=false,
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
			--[[for name,sin in pairs(player.vonal) do
				if name=="Wrath" 		then		love.graphics.setColor(255,000,000)
				elseif name=="Lust" 	then		love.graphics.setColor(000,000,255)
				elseif name=="Greed" 	then		love.graphics.setColor(255,255,000)
				elseif name=="Sloth" 	then		love.graphics.setColor(000,200,200)
				elseif name=="Gluttony" then		love.graphics.setColor(200,100,000)
				elseif name=="Envy" 	then		love.graphics.setColor(100,200,000)
				elseif name=="Pride" 	then		love.graphics.setColor(100,000,200) end
				local e={0,0}
				for i,xy in ipairs(sin) do
					love.graphics.line(e[1],e[2],xy[1],xy[2])
					e=xy
				end
			end]]
		end,
	billentyu=function(key, scancode, isrepeat)
			if key=="space" then
				marbles.start()
			elseif key=="m" then
				player.kamlock= not player.kamlock
			elseif key=="n" then
				player.csakegy= not player.csakegy
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
				elseif key=="g" then
					map:setObj(kijelolve:getUserData().usd,[[return {
						endContact=function(fixture,b,coll)
							if b:getShape():getType()=="circle" and b:getUserData().usd~="Ghost" then
								fixture:getBody():setUserData({'ghost',0,0})
							end
						end,
						}]])
				elseif key=="h" then
					map:setObj(kijelolve:getUserData().usd,[[return {
						endContact=function(fixture,b,coll)
							if b:getShape():getType()=="circle" and b:getUserData().usd~="Ghost" then
								fixture:getBody():setUserData({'d2',b:getUserData(),0,0})
							end
						end,
						}]])
				end
				kijelolve=nil
				env:delObj() map.init() marbles.beert={}
			end
		end,
		csakegy=false,
	}

return player
