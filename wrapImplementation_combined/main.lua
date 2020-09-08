require 'vector'
require 'wrap_mechanic'
require 'cable'
shapelib = require('rigidShapes')
circle2d = shapelib.circ
local spool =  class('spool',circle2d)
spool.isAttached = false
function spool:init(x,y,rad)
	circle2d.init(self,x,y,rad)
end
function love.load()
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	startNode = spool:new(250,100,1)
	spool1 = spool:new(300,200,30)
	spool2 = spool:new(400,300,50)
	spool3 = spool:new(400,210,20)
	pointer = spool:new(0,0,1)
	spools = {startNode,spool1,spool2,spool3}
	cableAry = {cable:new(startNode,'left'),cable:new(pointer,'left')}
	spools[1].isAttached = true
	spoolSystemObj = require('spoolSystem')
	spoolSystem = spoolSystemObj:new(spools,cableAry)
	gfx = love.graphics
end
function drawSpools(spools)
	love.graphics.setColor(0,0,0)
	for i,spool in pairs(spools) do
		drawType = (i == 1) and 'fill' or 'line'
		color = spool.isAttached and {1,0,0} or {0,0,0}
		gfx.setColor(color[1],color[2],color[3])
		gfx.circle(drawType,spool.x,spool.y,spool.rad)
		gfx.setColor(0,0,0)
	end
end

function drawCables(cables)
	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		-- print(a.overlapped)
		local color = {0,0,0}
		if a.overlapped and b.overlapped then
			color = {0,1,0}
		end 
		local color = (a.overlapped and b.overlapped) and {0,1,0} or {0,0,0}
		gfx.setColor(color[1],color[2],color[3])
		gfx.line(a.outPos.x,a.outPos.y,b.inPos.x,b.inPos.y)
	end

end
function printCord(name,pos)
	print(name .. ' x:' .. pos.x .. ' y:' .. pos.y )
end

function love.update()
	pointer.x = love.mouse.getX()
	pointer.y = love.mouse.getY()
	-- updateCableTangents(cableAry)
	spoolSystem:update()
	-- print(whichSide(cableAry[1].spool,pointer,spool1))
end
function lineBtwnVectors(v1,v2)
	gfx.line(v1.x,v1.y,v2.x,v2.y)
end
function love.draw()
	drawSpools(spools)
	drawCables(cableAry)
	-- gfx.print(angle,30,40)
	gfx.setColor(1,0,0)
	gfx.circle('fill',spool2.x,spool2.y,1)
	gfx.setColor(0,0,0)
	gfx.circle('fill',startNode.x,startNode.y,10)
	gfx.print('fps ' .. love.timer.getFPS(),20,60)
	gfx.print('angle ' .. spoolSystem:getAngle(),20,80)
end
