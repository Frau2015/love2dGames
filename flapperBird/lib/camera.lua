camera = {}
camera.x = 0
camera.y = 0
camera.sx = 1
camera.sy = 1
camera.rotation = 0
camera.timer = 0
camera.animations = {}
camera.lockMode = 'target'
camera.isLocked = true


-- dr = duration, v = velocity
function camera:addAnimation(type,vy,vx,dr)
	self.animations[#self.animations+1] = {type,vy,vx,dr}
	-- body
end
function camera:runAnimations(dt)
	if #(self.animations) > 0 then
		-- print(#self.animations)
		-- print(dt)
		anim = self.animations[1]
		if anim[1] == 'shake' then
			if self:shake(anim[2],anim[3],anim[4],dt)then
				table.remove(self.animations,1)
				-- print(#self.animations)
				camera.timer = 0
			end 
		end
		return true
	else 
		return false
	end
end
-- rumble is type animation, only works in func addAnimation
function camera:shake(vy,vx,dr,dt)
	-- .25 ,.5,.75,1 velocityY and duration
	if self.timer <= dr then
		-- self:setScale(.9,.9)
		if self.timer <= dr*0.25 then
			self:move(vx,-vy)
			-- self:rotate(.2)
		elseif self.timer <= dr* 0.5 then
			-- self:rotate(-.2)
			self:move(-vx,vy)
		elseif self.timer <= dr*0.75 then
			-- self:rotate(.2)
			self:move(-vx,vy)
		elseif self.timer <= dr then
			-- self:rotate(-.2)
			self:move(vx,-vy)
		end
	else
		-- self:setScale(1,1)
		return true
	end
	self.timer = self.timer + dt
	return false
	-- body
end

function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1/self.sx, 1/self.sy)
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:rotate(dr)
  self.rotation = self.rotation + dr
end

function camera:move(dx, dy)
  self.x = self.x + (dx or 0)
  self.y = self.y + (dy or 0)
end

function camera:scale(sx, sy)
  sx = sx or 1
  sy = sy or 1
  self.sx = self.sx * sx
  self.sy = self.sy * sy
end

function camera:setX(value)
  if self._bounds then
    self.x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self.x = value
  end
end

function camera:setY(value)
  if self._bounds then
    self.y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self.y = value
  end
end

function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end

function camera:setScale(sx, sy)
  self.sx = sx or self.sx
  self.sy = sy or self.sy
end

function camera:getBounds()
  return unpack(self._bounds)
end

function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end

function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end
