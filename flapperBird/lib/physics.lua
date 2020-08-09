gravity = {}
gravity.accel = 0
gravity.vel = 0

function gravity:new(a)
    o = {}
    o.accel = a
    setmetatable(o,{__index=self})
    return o
end
function gravity:getVel()
    return self.vel
end
function gravity:update()
    self.vel = self.vel + self.accel
end
function gravity:reset()
    self.vel = 0
end

function isColliding(x1,y1,w,h,x2,y2,w2,h2)
	--[1] = x, [2] = y, [3] = length, [4] = height
	if x1 + w > x2  and x1 < x2 + w2 and y1 + h > y2 and y1 < y2 + h2 then
		return true
	else 
		return false
	end
end