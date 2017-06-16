-- Nah én is írtam egy serilizálót
local function serialize(o)
	local ki = "return "
	local function ser(o)
		if type(o) == "number" then
			ki=ki..o
		elseif type(o) == "string" then
			if o:find("return") then
				ki=ki.."\n"..string.format("%q", o).."\n"
			else
				ki=ki..string.format("%q", o)
			end
		elseif type(o) == "table" then
			ki=ki.."{"
			for k,v in pairs(o) do
				ki=ki.."["..k.."]".."="
				ser(v,ki)
				ki=ki..","
			end
			ki=ki.."}"
		else
			ki=ki..type(o)
		end
	end

	ser(o)
	return ki
end

return serialize