local map = {}
map.world = {}

function map:load(filename)
	if not love.filesystem.exists(file) then
		print("Could not load file .. " .. file)
		return
	end
	
end

function map:save(filename)
	for b,body in ipairs(env.world:getBodyList()) do
		for f,fixture in ipairs(body:getFixtureList()) do
			local shape = fixture:getShape()
			local shapeType = shape:getType()
			local data = fixture:getUserData()
	
			if (shapeType == "circle") then
				
			elseif (shapeType == "polygon") then
				
			end

		end
	end
end

return map