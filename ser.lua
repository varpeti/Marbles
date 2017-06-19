-- Nah én is írtam egy serilizálót
local function serialize(o)
	local ki = "return "
	local function ser(o)
		if type(o) == "number" then
			ki=ki..o
		elseif type(o) == "string" then
			ki=ki.."\n[["..o.."]]"
		elseif type(o) == "table" then
			ki=ki.."\n{"
			for k,v in pairs(o) do
				if type(k) == "number" then
					ki=ki.."["..k.."]".."="
				else
					ki=ki..k.."="
				end
				ser(v,ki)
				ki=ki..","
			end
			ki=ki.."}"
		elseif type(o) == "boolean" then
			if o then ki=ki.."true" else ki=ki.."false" end
		else
			ki=ki..type(o)
		end
	end

	ser(o)
	return ki
end

return serialize