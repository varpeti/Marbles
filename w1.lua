local w1 = {
	{															--objektum
		0, 															--0 új kinematic body, 1 új dynamic body, 2 hozzáadás az előzőhöz
		0, 															--0 poligon, 1 kör
		{-10,-10,10,-10,70,70,-10,10}, 								--coords
		{100,100,0}, 												--szin
		"Data/n10.png", 											--kép
		[[return {													--eseményekkor ezek a függvények hívódnak meg 
			init=function() end,										--létrehozáskor hívódik meg, forgást, mozgást, stb-t lehet állítani.
			time=function(dt) end,										--updattel hívódik meg, időbeli eseményeket lehet vele állítani
			beginContact=function(b,coll) end,							--ütközés
			endContact=function(b,coll) end,							--szétválás
			preSolve=function(b,coll) end,								--pont ütk elött
			postSolve=function(b,coll,normalimpulse,tangentimpulse) end,--pont ütk után
			user=function(...) print(...) end 						--user hívhatja meg, de pl ha a12 ütközik akkor meghívhatja b34-nek ezt a funkcióját.
		}]]
	},
	{																--objektum
		2,																--hozzáadás
		1,																--kör
		{20,-100,0},													--range, x, y
		{0,100,100},
		"Data/n10.png",
		[[return {
			init=function(fixture) fixture:getBody():setAngularVelocity(0.4) end,
			time=function(fixture,dt) end,
			beginContact=function(fixture,b,coll) end,
			endContact=function(fixture,b,coll) end,
			preSolve=function(fixture,b,coll) end,
			postSolve=function(fixture,b,coll,normalimpulse,tangentimpulse) end,
			user=function(...) end
		}]]
	}
}

return w1