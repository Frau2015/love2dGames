require 'math_lib'
require 'vector'
require 'wrap_mechanic'
class = require('middleclass/middleclass')
local cable = class('cable')
cable.inPos = nil
cable.outPos = nil
cable.side = 'left'
function cable:init(spool,side)
	self.spool = spool
	self.inPos = inPos
	self.outPos = outPos
	self.side = side
end
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
	spools = {startNode,spool1,spool2}
	cableAry = {cable:new(startNode,'left'),cable:new(pointer,'left')}
	spools[1].isAttached = true
	gfx = love.graphics
	angle = 0 
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
		gfx.line(a.outPos.x,a.outPos.y,b.inPos.x,b.inPos.y)
	end
end
function printCord(name,pos)
	print(name .. ' x:' .. pos.x .. ' y:' .. pos.y )
end
function createSuitableAttachments(spools,cables)
	local getIntersected = function(outPos,inPos,ignoreA,ignoreB,spools)
		for _, spool in pairs(spools) do
			if spool ~= ignoreA and spool ~= ignoreB and (not spool.isAttached) and lineCircleIntersect(outPos,inPos,spool) then
				return spool
			end
		end
		return nil
	end
	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		local spl = getIntersected(a.outPos,b.inPos,a.spool,b.spool,spools)
		print('..')
		if spl then
			print(spl)
			spl.isAttached = true
			local side = whichSide(a.spool,b.spool,spl)
			-- print(side)
			local newCable = cable:new(spl,side)
			newCable.side = whichSide(a.outPos,newCable.spool,b.inPos)
			table.insert(cableAry,#cableAry,newCable)
			updateCableTangents(cableAry)
		end
	end
end
function removeDisconnected(spools,cables)
	updateAngle(cableAry)
	if #cableAry > 2 then
		local lastspool = cableAry[#cableAry-1].spool 
		local lastcable = cableAry[#cableAry-1]
		for i, spool in pairs(spools) do
			-- print(spool == lastspool)
			if spool == lastspool then 
				if (lastcable.side == 'left' and angle > 320) or (lastcable.side == 'right' and angle < 20) then
					print(lastcable.side)
					spools[i].isAttached = false
					table.remove(cableAry,#cableAry-1)
				end
				-- print(angle)
			end
		end
	end
end
function love.update()
	pointer.x = love.mouse.getX()
	pointer.y = love.mouse.getY()
	updateCableTangents(cableAry)
	createSuitableAttachments(spools,cableAry)
	removeDisconnected(spools,cableAry)
	-- print(whichSide(cableAry[1].spool,pointer,spool1))
end
function lineBtwnVectors(v1,v2)
	gfx.line(v1.x,v1.y,v2.x,v2.y)
end
function love.draw()
	drawSpools(spools)
	drawCables(cableAry)
	gfx.print(angle,30,40)
	gfx.setColor(1,0,0)
	gfx.circle('fill',spool2.x,spool2.y,1)
	gfx.setColor(0,0,0)
	gfx.circle('fill',startNode.x,startNode.y,10)
	gfx.print(love.timer.getFPS(),20,60)
	-- gfx.setColor(0,1,0)
	-- lineBtwnVectors(startNode,pointer)
	-- gfx.setColor(0,1,0)
	-- lineBtwnVectors(pointer,spool1)
end
