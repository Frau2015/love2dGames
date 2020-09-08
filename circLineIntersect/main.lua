require "wrap_mechanic"
require "math_lib"
function createPoint(x,y)
	local this = {}
	this.x = x
	this.y = y
	return this
end
function createCirc(x,y,rad)
	local this = createPoint(x,y)
	this.rad = rad
	return this
end
function love.load()
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	gfx = love.graphics
	line = {createPoint(200,100),createPoint(300,100)}
	circ = createCirc(300,150,20)
	--print(circ.x)
end

function love.update()
	line[2].x = love.mouse.getX()
	line[2].y = love.mouse.getY()
	--print(line[2].getX())
end

function love.draw()
	local p1 = line[1] 
	local p2 = line[2]
	gfx.setColor(0,0,0)
	gfx.line(p1.x,p1.y,p2.x,p2.y)
	gfx.circle('line',circ.x,circ.y,circ.rad)
	gfx.print(tostring(lineCircleIntersect(p1,p2,circ)),30,30)
end

