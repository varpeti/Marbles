ser = require('ser')

local map = {}
map.world = {}
map.lastbody={}

function map:load(file)
	if not love.filesystem.exists(file) then
		print("Could not load file .. " .. file)
		return
	end
	map.world = loadfile(file)()

	for i,obj in ipairs(map.world) do
		if obj[1]==2 then -- Hozzáadás az előző testhez
			if map.lastbody==nil then return end

			if obj[2]==0 then --polygnom
				env:addPoli(map.lastbody,obj[3],obj[4],obj[5],loadstring(obj[6])())
			elseif obj[2]==1 then --kör
				env:addKor(map.lastbody,obj[3][1],obj[3][2],obj[3][3],obj[4],obj[5],loadstring(obj[6])())
			end

		else -- Új test

			if obj[2]==0 then --polygnom
				map.lastbody = env:newPoli(obj[3],obj[4],obj[5],obj[1]==1,loadstring(obj[6])()):getBody()
			elseif obj[2]==1 then --kör
				map.lastbody = env:newKor(obj[3][1],obj[3][2],obj[3][3],obj[4],obj[5],obj[1]==1,loadstring(obj[6])())
			end

		end
	end
	
end

function map:save(filename)
	file = io.open(filename,"w")
	file:write(ser(map.world))
end

return map