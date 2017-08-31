local player = {
	x=0, -- kamera koord
	y=0,
	speed=500,
	mozgas=function(self,dt) -- kamera mozgás
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
			if player.kamlock==1 then
				local min = {0,0}
				for b,body in ipairs(env.world:getBodyList()) do
					if body:getFixtureList()[1]:getShape():getType()=="circle" then -- ha golyó
						local x,y = body:getPosition()
						if min[2]<y then --minimum kiválasztás
							min = {x,y}
						end
					end
				end
				local v ={min[1]-self.x,min[2]-self.y} --vektorképzés
				local tav = 15--(v[1]^2+v[2]^2)^(1/2) --10-15 körül jó
				self.x=self.x+(v[1])/tav
				self.y=self.y+(v[2])/tav

			elseif player.kamlock==2 then
				local avg = {0,0,0}
				for b,body in ipairs(env.world:getBodyList()) do
					if body:getFixtureList()[1]:getShape():getType()=="circle" then -- ha golyó
						local x,y = body:getPosition()
						avg={avg[1]+x,avg[2]+y,avg[3]+1}
					end
				end
				if avg[3]==0 then return end
				local v ={avg[1]/avg[3]-self.x,avg[2]/avg[3]-self.y}
				local tav=20
				self.x=self.x+(v[1])/tav
				self.y=self.y+(v[2])/tav
			end
		end,
	pontok={}, -- építéshez használt csúcsok
	kijelolve=nil,
	kattintas=function(x,y,button,istouch)
			x,y = kamera:worldCoords(x-kepernyo.Asz/2,y-kepernyo.Am/2)
			if button==1 then
				local van = false
				for i,pont in ipairs(player.pontok) do
					if math.sqrt((pont.x-x)^2+(pont.y-y)^2,2)<10 then --ha közel kattint az előzőhöz, létrehozza
						van=true
						break
					end
				end
				if van then --létrehozás
					if #player.pontok>=3 and #player.pontok<=8 then -- 8 és 3 szög közötti
						local coords = {}
						for i,pont in ipairs(player.pontok) do -- coordsra átírás
							table.insert(coords,pont.x)
							table.insert(coords,pont.y)
						end
						local rr,gg,bb = math.random(0,255),math.random(0,255),math.random(0,255) 
						local s = {
								cor=coords,
								col={rr,gg,bb},
								img=nil,
								ese=[[return {beginContact=function(fixture,b,coll) b:getBody():applyLinearImpulse(math.random(-9e4,9e4),math.random(-9e4,9e4)) end, endContact=function(fixture,b,coll)  fixture:getBody():setUserData({'pos',math.random(-2100,2100),math.random(-1100,1100)}) end,}]]--[[return {}]],
								nev=math.random(0,9e9),
							} -- objektum
						if player.kijelolve then -- ha van kijelölve objektum, annak a body-ához adja
							map:addObj(player.kijelolve,s)
						else
							map:newObj({dyn=false,sha={s}}) -- különben újat hoz létre
						end
					end
					player.pontok={}
				else -- új pont hozzáadása
					if #player.pontok>=8 then return end
					table.insert(player.pontok,{x=x,y=y})
				end

			elseif button==2 then -- kijelölés
				for b,body in ipairs(env.world:getBodyList()) do
					for f,fixture in ipairs(body:getFixtureList()) do
						if fixture:testPoint(x,y) then -- ha van találat

							print(fixture:getUserData().usd) -- kiírja a nevét
							if player.kijelolve~=nil and player.kijelolve:getBody()==fixture:getBody() then break end -- ha ugyan arra kattint mégegyszer átugorja, így lehet alatta lévőt kijelölni
							if player.kijelolve and player.kijelolve:getBody():getType()=="dynamic" then -- ha dinamikus-ról kattintanak kinematikusra akkor rope-jointot hoz létre
								map:addJoint(player.kijelolve,fixture)
								player.kijelolve=nil
								return
							end
							player.kijelolve=fixture
							return

						end
					end
				end
				player.kijelolve=nil -- ha mellékattintanak
			elseif button==3 then
				env:newKor(30,x,y,{255,255,255},nil,true,nil,"Ghost") -- görgővel egy próbagolyó
			elseif button==4 then -- instant törlés
				for b,body in ipairs(env.world:getBodyList()) do
					for f,fixture in ipairs(body:getFixtureList()) do
						if fixture:testPoint(x,y) then
							map:delObj(fixture:getUserData().usd)
							env:delObj(fixture)
							player.kijelolve=nil -- fontos!
							return
						end
					end
				end
			
			elseif button==5 then -- 7 próbagolyó
				for i=1,7 do
					env:newKor(30,x,y,{255,255,255},nil,true,nil,"Ghost")
				end
			end
		end,
	kamlock=0,
	draw=function()
			if player.pontok then -- építő pontok kirajzolása, koordinátákkal
				love.graphics.setColor(255,255,255,255)
				for i,pont in ipairs(player.pontok) do
					love.graphics.circle("fill",pont.x,pont.y,2)
					love.graphics.print(math.floor(pont.x).." "..math.floor(pont.y),pont.x,pont.y)
				end
				love.graphics.circle("line",0,0,255)
			end
			if player.kijelolve then -- kijelölt megjelölése
				love.graphics.setColor(255,255,255,255)
				local x,y = player.kijelolve:getBody():getPosition()
				love.graphics.circle("line",x,y,10)
			end
		end,
	billentyu=function(key, scancode, isrepeat)
			if key=="space" then -- start
				marbles.start()
			elseif key=="m" then -- kamlock
				player.kamlock=player.kamlock+1
				if player.kamlock==3 then player.kamlock=0 end
			elseif key=="n" then -- egy bemegy a többi ugyan olyan eltünik
				player.csakegy= not player.csakegy
			end

			if player.kijelolve then
				if key=="e" then -- idéglenes törlés
					env:delObj(player.kijelolve)
					player.kijelolve=nil
					return
				elseif key=="q" then -- törlés
					map:delObj(player.kijelolve:getUserData().usd)
				elseif key=="r" then --forgás
					map:setObj(player.kijelolve:getUserData().usd,[[return {init=function(fixture) fixture:getBody():setAngularVelocity(2.34567) end}]])
				elseif key=="t" then -- lökés
					map:setObj(player.kijelolve:getUserData().usd,[[return {beginContact=function(fixture,b,coll) b:getBody():applyLinearImpulse(0,-6.54e3) end}]])
				elseif key=="z" then -- emelkedés
					local x, y = player.kijelolve:getBody():getPosition()
					map:setObj(player.kijelolve:getUserData().usd,[[return {
						init=function(fixture) fixture:getBody():setLinearVelocity(0,-100) end, 
						time=function(fixture,dt) if os.time()%5==0 then fixture:getBody():setUserData({'pos',]]..x..[[,]]..y..[[}) end end}]])
				elseif key=="u" then -- teleport
					map:setObj(player.kijelolve:getUserData().usd,[[return {beginContact=function(fixture,b,coll) b:getBody():setUserData({'pos',0,0}) end}]])
				elseif key=="i" then -- dynamic-kinematic
					map:setDyn(player.kijelolve:getUserData().usd)
				elseif key=="o" then -- nullázás
					map:setObj(player.kijelolve:getUserData().usd,[[return {}]])
				elseif key=="p" then -- cél
					map:setObj(player.kijelolve:getUserData().usd,[[return {beginContact=function(fixture,b,coll) b:getBody():setUserData({'cel'}) end}]])
				elseif key=="f" then -- felrakás
					local x, y = player.kijelolve:getBody():getPosition()
					map:setObj(player.kijelolve:getUserData().usd,[[return {
						beginContact=function(fixture,b,coll) 
							local x1,y1 = b:getBody():getPosition()
							local x2,y2 = fixture:getBody():getPosition()
							if y1>y2 then		
								b:getBody():setUserData({'pos',x1,y2-(y1-y2)})
							end
						end,
						}]])
				elseif key=="g" then -- Ghost gyártás
					map:setObj(player.kijelolve:getUserData().usd,[[return {
						endContact=function(fixture,b,coll)
							if b:getShape():getType()=="circle" and b:getUserData().usd~="Ghost" then
								fixture:getBody():setUserData({'ghost',0,0})
							end
						end,
						}]])
				elseif key=="h" then -- Duplázás
					map:setObj(player.kijelolve:getUserData().usd,[[return {
						endContact=function(fixture,b,coll)
							if b:getShape():getType()=="circle" and b:getUserData().usd~="Ghost" then
								fixture:getBody():setUserData({'d2',b:getUserData(),0,0})
							end
						end,
						}]])
				elseif key=="j" then
					map:setObj(player.kijelolve:getUserData().usd,[[return {
							beginContact=function(fixture,b,coll) b:getBody():applyLinearImpulse(math.random(-9e4,9e4),math.random(-9e4,9e4)) end,
							endContact=function(fixture,b,coll)  fixture:getBody():setUserData({'pos',math.random(-2100,2100),math.random(-1100,1100)}) end,
						}]])
				end
				player.kijelolve=nil
				env:delObj() map.init() marbles.beert={}
			end
		end,
		csakegy=false,
	}

return player
