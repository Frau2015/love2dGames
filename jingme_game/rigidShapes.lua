class = require('middleclass/middleclass')
local cord2d = class('cord2d')
function cord2d:init(x,y)
	self.x = x
	self.y = y
end
function cord2d:getX()
	return self.x
end
function cord2d:getY()
	return self.y
end
function cord2d:setX()
	return self.x
end
function cord2d:setY()
	return self.y
end
local rect = class('rect',cord2d)
function rect:init(x,y,w,h)
	cord2d.init(self,x,y)
	self.w = w
	self.h = h
end
local circ = class('rect',cord2d)
function circ:init(x,y,rad)
	cord2d.init(self,x,y)
	self.rad = rad
end
local shapeClasses = {['cord2d']=cord2d,['rect']=rect,['circ']=circ}
return shapeClasses
