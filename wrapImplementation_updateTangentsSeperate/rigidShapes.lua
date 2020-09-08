class = require('middleclass/middleclass')
local vect2 = class('vect2')
function vect2:init(x,y)
	self.x = x
	self.y = y
end
function vect2:getX()
	return self.x
end
function vect2:getY()
	return self.y
end
function vect2:setX()
	return self.x
end
function vect2:setY()
	return self.y
end
local vector2d = class('vector2d')
function vector2d:init(cord,cord2)
	self.x = cord.x
	self.y = cord.y
	self.x2 = cord2.x
	self.y2 = cord2.y
end
local rect = class('rect',vect2)
function rect:init(x,y,w,h)
	vect2.init(self,x,y)
	self.w = w
	self.h = h
end
local circ = class('cirlce',vect2)
function circ:init(x,y,rad)
	vect2.init(self,x,y)
	self.rad = rad
end
local shapeClasses = {['vect2']=vect2,['rect']=rect,['circ']=circ}
return shapeClasses

