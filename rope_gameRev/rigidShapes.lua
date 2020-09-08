require 'lib'
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
local vector2d = class('vector2d')
function vector2d:init(cord,cord2)
	self.x = cord.x
	self.y = cord.y
	self.x2 = cord2.x
	self.y2 = cord2.y
end
function vector2d:normalize()

end
function vector2d:getLen()
    return getHyp({x=self.x,y=self.y},{x=self.x2,y=self.y2})
end
function vector2d:getXDist()
	return self.x - self.x2
end
function vector2d:getYDist()
	return self.y - self.y2
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
local shapeClasses = {['vector2d']=vector2d,['cord2d']=cord2d,['rect']=rect,['circ']=circ}
return shapeClasses

