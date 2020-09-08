require 'vector'
require 'wrap_mechanic'
require 'game_objs'
require 'renderer'
class = require('middleclass/middleclass')
shapelib = require('rigidShapes')
circle2d = shapelib.circ
game = {}
function game:new()
	local o = {}
	o.pointer = spool:new(0,0,1)
	o.playerSpool = spool:new(o.pointer.x,o.pointer.y,10)
	o.loaded = false
	o.spools = {}
	o.cableAry = nil
	o.endNode = nil
	o.startNode = nil
	o.spoolSystem = nil
	o.renderer = nil
	setmetatable(o,{__index=self})
	return o
end
function game:load(level)
	self.loaded = true
	self.startNode = spool:new(level.startNode[1],level.startNode[2],level.startNode[3])
	self.endNode = spool:new(level.endNode[1],level.endNode[2],level.endNode[3])
	print('level spools len ' .. #level.spools)
	for idx, i in pairs(level.spools) do
		local spl = spool:new(i[1],i[2],i[3])
		print(i[3])
		table.insert(self.spools,spool:new(i[1],i[2],i[3]))
	end
	table.insert(self.spools,self.endNode)
	print(#self.spools)
	self.cableAry = {cable:new(self.startNode,'left'),cable:new(self.pointer,'left')}
	-- table.insert(self.cableAry, 
	-- table.insert(self.cableAry, 
	local spoolSystemObj = require('spoolSystem')
    self.spoolSystem = spoolSystemObj:new(self.spools,self.cableAry)
    self.renderer = createRenderer(self.spools,self.cableAry)
end
-- function game:new(level)
--     local o = {}
--     local startNode = spool:new(250,100,1)
-- 	local spool1 = spool:new(300,200,30)
-- 	local spool2 = spool:new(400,300,50)
-- 	local spool3 = spool:new(400,210,20)
-- 	o.endNode = spool:new(600,400,20)
-- 	o.endNode.type = "endNode"
-- 	o.pointer = spool:new(0,0,1)
-- 	o.playerSpool = spool:new(o.pointer.x,o.pointer.y,10)
-- 	o.spools = {startNode,spool1,o.endNode,spool2,spool3}
--     local cableAry = {cable:new(startNode,'left'),cable:new(o.pointer,'left')}
-- 	o.spools[1].isAttached = true
-- 	local spoolSystemObj = require('spoolSystem')
--     o.spoolSystem = spoolSystemObj:new(o.spools,cableAry)
--     o.renderer = createRenderer(o.spools,cableAry)
--     setmetatable(o,{__index=self})
--     return o
-- end
function game:update()
	self.pointer.x = love.mouse.getX()
	self.pointer.y = love.mouse.getY()
	self.spoolSystem:update()
	self.playerSpool.x = self.pointer.x
	self.playerSpool.y = self.pointer.y
	--game:won()
end
function game:won()
	-- if self.spoolSystem:getNumofAttached() == #self.spools then
	-- 	print('game is won')
	-- end
	-- print(self.spoolSystem:getNumofAttached())
	-- for 
	-- self.cables
end
function game:draw()
	local plyer =self.playerSpool
    self.renderer.draw()
	love.graphics.circle('fill',plyer.x,plyer.y,plyer.rad)
end