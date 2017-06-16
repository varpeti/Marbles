return {[1]={[1]=0,[2]=0,[3]={[1]=-25,[2]=-25,[3]=-5,[4]=-25,[5]=55,[6]=55,[7]=-25,[8]=-5,},[4]={[1]=100,[2]=100,[3]=0,},[5]="Data/n10.png",[6]=
"return {\9\9\9\9\9\9\9\9\9\9\9\9\9--eseményekkor ezek a függvények hívódnak meg \
\9\9\9init=function() end,\9\9\9\9\9\9\9\9\9\9--létrehozáskor hívódik meg, forgást, mozgást, stb-t lehet állítani.\
\9\9\9time=function(dt) end,\9\9\9\9\9\9\9\9\9\9--updattel hívódik meg, időbeli eseményeket lehet vele állítani\
\9\9\9beginContact=function(b,coll) end,\9\9\9\9\9\9\9--ütközés\
\9\9\9endContact=function(b,coll) end,\9\9\9\9\9\9\9--szétválás\
\9\9\9preSolve=function(b,coll) end,\9\9\9\9\9\9\9\9--pont ütk elött\
\9\9\9postSolve=function(b,coll,normalimpulse,tangentimpulse) end,--pont ütk után\
\9\9\9user=function(...) print(...) end \9\9\9\9\9\9--user hívhatja meg, de pl ha a12 ütközik akkor meghívhatja b34-nek ezt a funkcióját.\
\9\9}"
,},[2]={[1]=2,[2]=1,[3]={[1]=20,[2]=-100,[3]=0,},[4]={[1]=0,[2]=100,[3]=100,},[5]="Data/n10.png",[6]=
"return {\
\9\9\9init=function(fixture) fixture:getBody():setAngularVelocity(0.4) end,\
\9\9\9time=function(fixture,dt) end,\
\9\9\9beginContact=function(fixture,b,coll) end,\
\9\9\9endContact=function(fixture,b,coll) end,\
\9\9\9preSolve=function(fixture,b,coll) end,\
\9\9\9postSolve=function(fixture,b,coll,normalimpulse,tangentimpulse) end,\
\9\9\9user=function(...) end\
\9\9}"
,},}