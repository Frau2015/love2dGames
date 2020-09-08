require 'lib'
require 'wrap'
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
	nodes = {rCirc,circ2d:new(300,300,30)}
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
end
function love.update()
	mx = love.mouse.getX()
	my = love.mouse.getY()
	pointer.x = mx
	pointer.y = my
end
function drawRope()
	local count = 0
	addIntersectionPoints(rCirc,{pointer,points[#points]},points[#points])
	for i, p in ipairs(points) do
		if i == #points then
			count = count + 1
			love.graphics.line(p.x,p.y,mx,my)
			print(count)
		else
			love.graphics.line(p.x,p.y,points[i+1].x,points[i+1].y)
		end
	end
end
function love.draw()
	love.graphics.setColor(0,0,0)
	drawNodes(nodes)
	drawRope()
	if #points > 1 then
		local p = points[2]
		gfx.setColor(0,1,0)
		gfx.line(rCirc.x,rCirc.y,p.x,p.y)
		gfx.setColor(0,0,0)
	end
	--addIntersectionPoints(rCirc,{pointer,points[#points]},points[#points])
	gfx.print('angle ' .. angle,30,40)
end
