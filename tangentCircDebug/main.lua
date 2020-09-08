require 'math_lib'
function love.load()
	shapeLib = require('rigidShapes')
	circ2d = shapeLib.circ
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	gfx = love.graphics
	nodes = {circ2d:new(210,100,20),circ2d:new(250,100,50)}
end
function drawTangentLines()
	local circ1 = nodes[1]
	local circ2 = nodes[2]
	local tangents = getTangents(circ1,circ1.rad,circ2,circ2.rad)
	local a = tangents[1]
	local b = tangents[2]
	if #tangents > 0 then
		gfx.line(a[1].x,a[1].y,a[2].x,a[2].y)
		gfx.line(b[1].x,b[1].y,b[2].x,b[2].y)
		--print( tostring(a[1].x) .. tostring(a[1].y) .. tostring(a[2].x) .. tostring(a[2].y))
		print(string.format("%fx %fy %fx %fy",a[1].x,a[1].y,a[2].x,a[2].y))
	end
	print(#tangents)
	--print('line1 x' .. a[1].x .. ' y ' .. a[1].y .. ' x2 ' .. a[2].x .. ' y2 ' .. a[2].y)
	--print('line2 x' .. b[1].x .. ' y ' .. b[1].y .. ' x2 ' .. b[2].x .. ' y2 ' .. b[2].y)
end
function drawNodes(nodes)
	gfx.setColor(0,0,0)
	for _, node in pairs(nodes) do
		gfx.circle('line',node.x,node.y,node.rad)
	end
end
function love.update()
	if love.mouse.isDown(1) then
		nodes[1].x = love.mouse.getX()
		nodes[1].y = love.mouse.getY()
	end
end

function love.draw()
	drawNodes(nodes)
	drawTangentLines()
end

