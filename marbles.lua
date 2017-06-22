local marbles = {}

marbles.beert = {}

function marbles.start()

	local colors = {
		{"Wrath",		{255,000,000},	"Data/wrath.png"},
		{"Lust",		{000,000,255},	"Data/lust.png"	},
		{"Greed",		{255,255,000},	"Data/greed.png"},
		{"Sloth",		{000,200,200},	"Data/sloth.png"},
		{"Gluttony",	{200,100,000},	"Data/gluttony.png"},
		{"Envy",		{100,200,000},	"Data/envy.png"	},
		{"Pride",		{100,000,200},	"Data/pride.png"},
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
			local data = fixture:getUserData()
	
			local bd = body:getUserData() 
			if bd then
				if bd[1]=="pos" then 
					body:setPosition(bd[2],bd[3]) 
				elseif bd[1]=="ghost" then 
					env:newKor(30,bd[2],bd[3],{255,255,255},nil,true,nil,"Ghost")
				end
				body:setUserData(nil)
			end

			if shape:getType()=="circle" then 

				if bd then 
					if bd[1]=="del" then env:delObj(fixture)
					elseif bd[1]=="cel" then 
						table.insert(marbles.beert,{data.usd,data.szin,data.img})
						env:delObj(fixture)
					end
				end

			end

			data.ese.time(fixture,dt)

		end
	end
end

function marbles.hud()
	for i,be in ipairs(marbles.beert) do
		love.graphics.setColor(be[2][1],be[2][2],be[2][3],255)

		local x,y = i*35*2-35, 35
		local mkep = math.floor(kepernyo.Asz/35)*35
		local tul = math.floor(x/mkep)
		x = x-(mkep)*tul
		y = y+2*40*tul

		love.graphics.circle("fill",x,y,30)
		love.graphics.setColor(255,255,255,255)
		if be[1] then love.graphics.print(be[1],x,y+50,0,1,1,font:getWidth(be[1])/2,font:getHeight()) end
		if be[3] then love.graphics.draw(be[3],x,y,0,1,1,30,30) end
	end
end

return marbles