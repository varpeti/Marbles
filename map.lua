ser = require('ser')

local map = {}
map.world = {}


function map:load(file) -- betölti a pályát
	if not love.filesystem.exists(file) then
		print("Could not load file .. " .. file)
		return
	end
	map.world = loadfile(file)()

	map.init() -- meg is nyitja
end

function map.init() -- a betöltött pályát megnyitja
	for ib,b in ipairs(map.world) do
		local body
		for is,s in ipairs(b.sha) do
			if body then 
				env:addPoli(body,s.cor,s.col,s.img,loadstring(s.ese)(),s.nev) -- hozzáadás az előző body-hoz
			else
				body = env:newPoli(s.cor,s.col,s.img,b.dyn,loadstring(s.ese)(),s.nev):getBody() -- új body létrehozása
			end
		end
	end
	for ib,b in ipairs(map.world) do --végig megy még 1x és összeköti a rope-jointokal a megadott testeket
		if b.joa then
			local b1,b2
			for k,body in ipairs(env.world:getBodyList()) do  --megkeresi a 2 body-t név alapján
				for f,fixture in ipairs(body:getFixtureList()) do
					if fixture:getUserData().usd==b.joa[1] then
						b1=body
					end
					if fixture:getUserData().usd==b.joa[2] then
						b2=body
					end
				end
			end
			if b1==nil or b2==nil then table.remove(map.world,ib) else -- ha az egyik nem létezik törli a jointot
				local x1,y1 = b1:getPosition()
				local x2,y2 = b2:getPosition()
				love.physics.newRopeJoint(b1,b2,x1,y1,x2,y2,math.sqrt((x1-x2)^2+(y1-y2)^2,2),false) -- különben létrehozza
			end
		end
	end
end

function map:save(filename) -- lementi serilializálva a pályát
	file = io.open(filename,"w")
	file:write(ser(map.world))
end

local function nevok(nev) -- megvizsgája hogy egyedi-e a név, ha nem keres egyet
	local ok = true
	repeat
	for ib,b2 in ipairs(map.world) do
		for is,s2 in ipairs(b2.sha) do
			if s2.nev==nev then
				s.nev=nev+1
				ok=false
			end
		end
	end
	until (ok)
	return nev
end

function map:newObj(b) -- új objektum hozzáadása a pályához (új body)
	local s = b.sha[1]

	s.nev=nevok(s.nev)

	env:newPoli(s.cor,s.col,s.img,b.dyn,loadstring(s.ese)(),s.nev)

	local b2={
		dyn=b.dyn,
		sha={b.sha[1]},
	}

	table.insert(self.world,b2)
end

function map:addObj(fix,s) --új objektum hozzáadása egy meglévő body-hoz
	s.nev=nevok(s.nev)
	env:addPoli(fix:getBody(),s.cor,s.col,s.img,loadstring(s.ese)(),s.nev)

	local name=fix:getUserData().usd

	for ib,b in pairs(self.world) do
		for is,s2 in ipairs(b.sha) do
			if s2.nev==name then
				table.insert(b.sha,s)
			end
		end
	end
end

function map:delObj(name) -- egy objektum törlése
	for ib,b in pairs(self.world) do
		for is,s in ipairs(b.sha) do
			if s.nev==name then
				table.remove(self.world,ib)
				return
			end
		end
	end
end

function map:setObj(name,ese) -- objektum ese függvényeit módosítja (csak szövegesen)
	for ib,b in pairs(self.world) do
		for is,s in ipairs(b.sha) do
			if s.nev==name then
				s.ese=ese
				return
			end
		end
	end
end

function map:setDyn(name) -- Átállítja kinematikusról dynamikusra, ill fordítva az objektumot
	for ib,b in pairs(self.world) do
		for is,s in ipairs(b.sha) do
			if s.nev==name then
				b.dyn=not b.dyn
				return
			end
		end
	end
end

function map:addJoint(fix1,fix2) -- új rope-joint

	table.insert(map.world,{joa={fix1:getUserData().usd,fix2:getUserData().usd},sha={}})

	env:delObj() map.init() marbles.beert={} -- resetel rakja be
end


return map