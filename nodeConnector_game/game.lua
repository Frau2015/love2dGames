require 'vector'
require 'wrap_mechanic'
require 'cable'
require 'renderer'
class = require('middleclass/middleclass')
shapelib = require('rigidShapes')
circle2d = shapelib.circ
spool = class('spool',circle2d)
spool.isAttached = false
function spool:init(x,y,rad)
	circle2d.init(self,x,y,rad)
	self.type = "node"
end
game = {}
function game:new()
    local o = {}
    local startNode = spool:new(250,100,1)
	local spool1 = spool:new(300,200,30)
	local spool2 = spool:new(400,300,50)
	local spool3 = spool:new(400,210,20)
	o.endNode = spool:new(600,400,20)
	o.endNode.type = "endNode"
	o.pointer = spool:new(0,0,1)
	o.playerSpool = spool:new(o.pointer.x,o.pointer.y,10)
	o.spools = {startNode,spool1,o.endNode,spool2,spool3}
    local cableAry = {cable:new(startNode,'left'),cable:new(o.pointer,'left')}
	o.spools[1].isAttached = true
	local spoolSystemObj = require('spoolSystem')
    o.spoolSystem = spoolSystemObj:new(o.spools,cableAry)
    o.renderer = createRenderer(o.spools,cableAry)
    setmetatable(o,{__index=self})
    return o
end
function game:update()
	self.pointer.x = mx
	self.pointer.y = my
	self.spoolSystem:update()
	self.playerSpool.x = self.pointer.x
	self.playerSpool.y = self.pointer.y
	--game:won()
end
function game:won()
	if self.spoolSystem:getNumofAttached() == #self.spools then
		print('game is won')
	end
	print(self.spoolSystem:getNumofAttached())
	-- for 
	-- self.cables
end
function game:draw()
	local plyer =self.playerSpool
    self.renderer.draw()
	love.graphics.circle('fill',plyer.x,plyer.y,plyer.rad)
end