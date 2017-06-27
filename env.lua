local env = {}

env.world = love.physics.newWorld(0, 900, true)

--[[
	data t
		szin l {r,g,b}
		img u
		ese t
]]

env.esepro = { -- deffault értékek
		init=function(fixture) end,
		time=function(fixture,dt) end,
		beginContact=function(fixture,b,coll) end,
		endContact=function(fixture,b,coll) end,
		preSolve=function(fixture,b,coll) end,
		postSolve=function(fixture,b,coll,normalimpulse,tangentimpulse) end,
		delete=function(fixture) end,
		user=function(...) end
	}
env.esemeta = {__index=env.esepro}

local function CoM(coords) -- vissza adja a tömegközépontot, és az eltolási távot
	local legkx = coords[1]
	local legky = coords[2]
	local maxx = 0
	local maxy = 0
	local i = 1
	while i<=#coords do
		maxx=maxx+coords[i]
		maxy=maxy+coords[i+1]
		if coords[i]  <=legkx then legkx = coords[i]   end
		if coords[i+1]<=legky then legky = coords[i+1] end
		i=i+2
	end
	local o = #coords/2
	local x, y = maxx/o, maxy/o
	return x, y, x-legkx, y-legky
end

local function createshape(x,y,coords)
	for i=1,#coords,2 do
		coords[i]=coords[i]-x
		coords[i+1]=coords[i+1]-y
	end
	return love.physics.newPolygonShape(unpack(coords))
end

local function padImagedata(source)  --Készítő: Maurice
    local w, h = source:getWidth(), source:getHeight()
   
    -- Find closest power-of-two.
    local wp = math.pow(2, math.ceil(math.log(w)/math.log(2)))
    local hp = math.pow(2, math.ceil(math.log(h)/math.log(2)))
   
    -- Only pad if needed:
    if wp ~= w or hp ~= h then
        local padded = love.image.newImageData(wp, hp)
        padded:paste(source, 0, 0)
        return love.graphics.newImage(padded)
    end
   
    return love.graphics.newImage(source)
end

local function cutimage(fixture,img,rx,ry,mx,my)  -- rávágja egy formára a képet

	local imd = img:getData() 

	local width = imd:getWidth()
	local height = imd:getHeight()

	local angle = fixture:getBody():getAngle()
	local shape = fixture:getShape()
	
	for y = 0, height-1 do
		for x = 0, width-1 do
			if not shape:testPoint(rx-mx,ry-my,angle,x,y) then
				imd:setPixel(x, y, 255, 255, 255, 0)
			end
		end
	end
	
	return padImagedata(imd)
end

local function udata(fixture,szin,img,ese,rx,ry,mx,my,usd)
	mx = mx or 0
	my = my or 0
	ese = ese or {}

	setmetatable(ese,env.esemeta)

	local data = {
		szin=szin,
		img=nil,
		ese=ese,--események
		mx=mx,--tömeg középpont
		my=my,
		rx=rx,--tömegközép-balfelsősarok vektor
		ry=ry,
		fixture=fixture,
		usd=usd --userdata
	}
	if img then 
		data.img=cutimage(fixture,love.graphics.newImage(img),rx,ry,mx,my) 
	end

	fixture:setUserData(data)

	data.ese.init(fixture) -- meghívja hogy elkészült
end


function env:newPoli(coords,szin,img,dynamic,ese,usd)

	if #coords<(2*3) or #coords>(2*8) then return end

	local koords = {}

	for i=1,#coords,2 do
		koords[i]=coords[i]
		koords[i+1]=coords[i+1]
	end

	local x,y,rx,ry = CoM(koords)

	local body 
	if dynamic then
		body = love.physics.newBody(self.world, x, y, "dynamic") -- fizikai test
	else
		body = love.physics.newBody(self.world, x, y, "kinematic") -- nem befojásolják más objektumok, de mozgatható
	end
	local shape = createshape(x,y,koords)-- shape: a coords (0;0) pontja az x,y-on van
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	udata(fixture,szin,img,ese,rx,ry,0,0,usd)


	return fixture
	
end

function env:addPoli(body,coords,szin,img,ese,usd)

	if #coords<(2*3) or #coords>(2*8) then return end

	local x,y = body:getPosition()

	local koords = {}

	for i=1,#coords,2 do
		koords[i]=coords[i]-x
		koords[i+1]=coords[i+1]-y
	end


	local mx,my,rx,ry = CoM(koords)
	local shape = love.physics.newPolygonShape(unpack(koords)) 
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	udata(fixture,szin,img,ese,rx,ry,mx,my,usd)

	return fixture
end

function env:newKor(r,x,y,szin,img,dynamic,ese,usd)

	if r<1 then return end

	local body 
	if dynamic then
		body = love.physics.newBody(self.world, x, y, "dynamic") -- fizikai test
	else
		body = love.physics.newBody(self.world, x, y, "kinematic") -- nem befojásolják más objektumok, de mozgatható
	end
	local shape = love.physics.newCircleShape(r)
	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	udata(fixture,szin,img,ese,r,r,0,0,usd)

	return fixture
	
end

function env:addKor(body,r,x,y,szin,img,ese,usd)

	if r<1 then return end

	local shape = love.physics.newCircleShape(x,y,r)

	local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás

	udata(fixture,szin,img,ese,r,r,x,y,usd)

	return fixture
end

function env:delObj(fixture)
	if fixture~=nil then
		local body = fixture:getBody()
		if #body:getFixtureList()==1 then -- ha egyetlen forma van csak hozzákapcsolva, az egészet testet törli.
			body:destroy()
		else
			fixture:destroy()
		end
	else -- teljes törlés ha nincs paraméter
		for b,body in ipairs(env.world:getBodyList()) do
			body:destroy()
		end
	end

end

function env:draw()
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			local shape = fixture:getShape()
			local shapeType = shape:getType()
			local data = fixture:getUserData()
	
			if (shapeType == "circle") then

				local x,y = body:getWorldPoint(shape:getPoint())
				local radius = shape:getRadius()
				love.graphics.setColor(data.szin[1],data.szin[2],data.szin[3],255)
				love.graphics.circle("fill",x,y,radius)
				love.graphics.setColor(255,255,255,255)
				if data.img then love.graphics.draw(data.img,x,y,body:getAngle(),1,1,radius,radius) end

			elseif (shapeType == "polygon") then
				local points = {body:getWorldPoints(shape:getPoints())}
				love.graphics.setColor(data.szin[1],data.szin[2],data.szin[3],180)
				love.graphics.polygon("fill",points)
				love.graphics.setColor(0,0,0,255)
				love.graphics.polygon("line",points)
				love.graphics.setColor(255,255,255,255)
				local x,y = body:getWorldPoints(data.mx,data.my)
				if data.img then love.graphics.draw(data.img,x,y,body:getAngle(),1,1,data.rx,data.ry) end
					if DEBUG then 
						local bx,by = body:getPosition()
						love.graphics.setColor(255,255,255,255)
						love.graphics.circle("fill",x,y,5)
						--love.graphics.line(x,y,bx,by)
					end
			end

		end

		--[[if DEBUG then
			love.graphics.setColor(255,255,255,255)
			local x,y = body:getPosition()
			love.graphics.circle("line",x,y,9)
			x,y = body:getWorldCenter()
			love.graphics.circle("line",x,y,7)
		end]]
	end	
	if DEBUG then
		love.graphics.setColor(255,255,255,255)
		for j,joint in pairs(env.world:getJointList()) do
			local x1, y1, x2, y2 = joint:getAnchors()
				love.graphics.line(x1,y1,x2,y2)
		end
	end
end

function env:update(dt)
	self.world:update(dt)
end

--Ütközések

function env.setCallbacks()
	env.world:setCallbacks(beginContact, endContact, preSolve, postSolve) --Ütközés lekérdezés
end

function beginContact(a, b, coll)
	a:getUserData().ese.beginContact(a,b,coll)
	b:getUserData().ese.beginContact(b,a,coll)
end

function endContact(a, b, coll)
	a:getUserData().ese.endContact(a,b,coll)
	b:getUserData().ese.endContact(b,a,coll)
end

function preSolve(a, b, coll)
	a:getUserData().ese.preSolve(a,b,coll)
	b:getUserData().ese.preSolve(b,a,coll)
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	a:getUserData().ese.postSolve(a,b,coll,normalimpulse,tangentimpulse)
	b:getUserData().ese.postSolve(b,a,coll,normalimpulse,tangentimpulse)
end


return env