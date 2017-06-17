local marbles = {}

function marbles.start()
	for i=1,10 do
		local s = math.random(0,math.pi*2)
		local r = math.random(0,245)
		env:newKor(15,math.cos(s)*r,math.sin(s)*r,{i*7,i*17,255-i*5},nil,true,nil):getBody():setLinearVelocity(math.cos(s)*r*10,math.sin(s)*r*10)
	end
end

return marbles