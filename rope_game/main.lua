require 'lib'
function love.load()
	gfx = love.graphics
	rigidShapes = require('rigidShapes')
	rectClass = rigidShapes.rect
	circ2d = rigidShapes.circ
	cord2d = rigidShapes.cord2d
	vector2d = rigidShapes.vector2d
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	--var defs
	rCirc = circ2d:new(200,200,30)
	initialPoint = cord2d:new(200,100)
	points = {initialPoint}
	mx = 0
	my = 0
	pointer = cord2d:new(mx,my)
	angle = 0
end
function love.mousepressed(x,y,button)
	if button == 2 then
		--points[#points+1] = cord2d:new(x,y)
		genNewPoint(rCirc,{pointer,points[#points]},points[#points])
	end
end
function love.keypressed(key)
	if key == 'u' and #points > 1 then
		table.remove(points,#points)
	end
	if key == 'space' then
		print(#points)
	end
end
function drawNodes(nodeAry)
	love.graphics.setColor(0,0,0)
	for _,node in pairs(nodeAry) do
		love.graphics.circle('line',node.x,node.y,node.rad)
	end
	love.graphics.setColor(1,1,1)
end
function love.update()
	mx = love.mouse.getX()
	my = love.mouse.getY()
	pointer.x = mx
	pointer.y = my
end
function drawRope()
	for i, p in pairs(points) do
		if i == #points then
			rad = ((mx - p.x)^2 + (my - p.y)^2)^0.5
			dis = mx - p.x 
			dpy = 100
			love.graphics.line(p.x,p.y,mx,my)
			drawIntersectionPoints(rCirc,{pointer,points[#points]},p)
		else
			love.graphics.line(p.x,p.y,points[i+1].x,points[i+1].y)
		end
	end
end
function genNewPoint(circ,lineSeg,p)
	getSlope = function(cord1,cord2)
		local ydiff = (cord1.y - cord2.y) 
		local xdiff = (cord1.x - cord2.x)
		return (ydiff/xdiff)
	end
	local m = getSlope(pointer,p)
    local invertM = -1/m
	local b =  p.y - p.x*m
	local b2 = circ.y - circ.x*invertM 
	local x = (b-b2)/(invertM-m)
	local y = x*m+b
	local isectRad = (x-circ.x)^2 + (y - circ.y)^2
	if isectRad < circ.rad^2 then
		local scale = circ.rad/math.sqrt(isectRad)
		local width = x-circ.x 
		local height = y-circ.y
		local newx = circ.x+width*scale
		local newy = circ.y+height*scale 
		table.insert(points,cord2d:new(newx,newy))
		gfx.line(circ.x,circ.y,circ.x+width*scale,circ.y+height*scale)
	end
end
function drawIntersectionPoints(circ,lineSeg,p)
	getSlope = function(cord1,cord2)
		local ydiff = (cord1.y - cord2.y) 
		local xdiff = (cord1.x - cord2.x)
		return (ydiff/xdiff)
	end
	local m = getSlope(pointer,p)
    local invertM = -1/m
	local b =  p.y - p.x*m
	local b2 = circ.y - circ.x*invertM 
	local x = (b-b2)/(invertM-m)
	local y = x*m+b
	local isectRad = (x-circ.x)^2 + (y - circ.y)^2
	local halfbase = math.sqrt(circ.rad^2 - isectRad)
	local rightX = (x+m^2*x - halfbase*math.sqrt(m^2+1))/(1+m^2)
	local rightY = rightX*m+b
	
	-- gfx.circle('line',x,y,halfbase)
	 gfx.circle('fill',x,y,3)
	-- gfx.circle('fill',rightX,rightY,3)
	isLeft = function (a,b,c)
		return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) > 0;
	end
	
	local point = {x=0,y=0}	
	if isectRad < circ.rad^2 then
		local scale = circ.rad/math.sqrt(isectRad)
		local width = x-circ.x 
		local height = y-circ.y
		local newx = circ.x+width*scale
		local newy = circ.y+height*scale 
		point = {x=newx,y=newy}
		--gfx.circle('fill',point.x,point.y,3)
		gfx.line(circ.x,circ.y,newx,newy)
		-- opposite = getHyp(circ,pointer)
		-- adjacent = getHyp(p,pointer)
		local vectA = vector2d:new(p,pointer)
		local vectB = vector2d:new(p,circ)
		local a = cord2d:new(pointer.x-p.x,pointer.y-p.y)
		local b = cord2d:new(circ.x-p.x,circ.y-p.y)
		--print('opp: ' .. opposite .. ' adjacent: ' .. adjacent)
		if #points > 1 then
			-- local tempa = math.atan2(opposite,adjacent)
			angle = angleBetweenVectors(vectA,vectB)
			print(angle)
			isleft = isLeft(circ,p,point)
			if angle > 0.01 then
				table.insert(points,cord2d:new(newx,newy))
			else
				table.remove(points,#points)
			end
		end
	end
	-- gfx.setColor(1,0,0)
	-- gfx.line(circ.x,circ.y,mx,my)
	-- gfx.setColor(0,0,0)
	--gfx.setColor(1,0,0)
	--gfx.circle('fill',circ.x,circ.y,5)
	--gfx.circle('fill',p.x,p.y,5)
	--gfx.setColor(0,0,0)
	--gfx.line(circ.x,circ.y,x,y)
end
function love.draw()
	love.graphics.setColor(0,0,0)
	--drawIntersection()
	drawIntersectionPoints(rCirc,{pointer,points[#points]},points[#points])
	love.graphics.circle('line',rCirc.x,rCirc.y,rCirc.rad)
	drawRope()
	if #points > 1 then
		gfx.setColor(1,0,0)
		gfx.line(rCirc.x,rCirc.y,points[#points].x,points[#points].y)
		gfx.setColor(0,0,0)
	end
	gfx.print('angle ' .. angle,30,40)
	--drawTangentLine(rCirc,{pointer,points[#points]})
end
function drawBalls()
	local anchor = points[#points]
	local lineH = ball.y - anchor.y
	local lineW = ball.x - anchor.x 
	local lineHyp = math.sqrt((lineH)^2 + (lineW)^2)
	local anchorRat = anchor.rad/lineHyp
	local ballRat = ball.rad/lineHyp
	local newanchorX = anchor.x+lineW*anchorRat
	local newanchorY = anchor.y+lineH*anchorRat
	local newballX = ball.x-lineW*ballRat
	local newballY = ball.y-lineH*ballRat
	love.graphics.line(newanchorX,newanchorY,newballX,newballY)
	drawNodes(nodes)
end
