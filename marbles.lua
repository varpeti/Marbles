local marbles = {}

marbles.beert = {}

function marbles.start()

	local colors = {
		{"Wrath",		{255,000,000},	"Data/wrath2.png"},
		{"Lust",		{000,000,255},	nil},
		{"Greed",		{255,255,000},	nil},
		{"Sloth",		{000,200,200},	nil},
		{"Gluttony",	{200,100,000},	nil},
		{"Envy",		{100,200,000},	"Data/envy1.png"},
		{"Pride",		{100,000,200},	nil},
	}


	for i,color in ipairs(colors) do
		local s = math.random(0,math.pi*2)
		local r = math.random(0,245)

		env:newKor(30,math.cos(s)*r,math.sin(s)*r,color[2],color[3],true,nil,color[1]):getBody():setLinearVelocity(math.cos(s)*r*-10,-1000)
	end
end

function marbles.update(dt)
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			local shape = fixture:getShape()
			if shape:getType()~="circle" then break end
			local data = fixture:getUserData()
	
			local bd = body:getUserData() 
			if bd then 
				if bd[1]=="pos" then body:setPosition(bd[2],bd[3]) end
				body:setUserData(nil)
			end

			if bd then 
				if bd[1]=="del" then env:delObj(fixture) end
			end

			if bd then 
				if bd[1]=="cel" then 
					table.insert(marbles.beert,{data.usd,data.szin,data.img})
					env:delObj(fixture) 
				end
			end

			data.ese.time(fixture,dt)

		end
	end
end

function marbles.hud()
	for i,be in ipairs(marbles.beert) do
		love.graphics.setColor(be[2][1],be[2][2],be[2][3],255)
		local x,y = i*35*2-35,35
		love.graphics.circle("fill",x,y,30)
		love.graphics.setColor(be[2][1],be[2][2],be[2][3],255)
		if be[1] then love.graphics.print(be[1],x,y+50,0,1,1,font:getWidth(be[1])/2,font:getHeight()) end
	end
end

return marbles