require 'lib/physics'
player = {}
--stores the quads for the yellow player spirtes 
player.scale = 2
player.width = 17
player.height = 12
player.x = love.graphics.getWidth()/2 * (1/3) - player.width/2
player.y = (love.graphics.getHeight()/2 - 12) * (1/2)  
player.timer = 0
player.frame = 0
player.totalFrames = 4
player.yellowQds = {}
player.batchId = nil
player.velX = 1.4
player.velY = 1.8
player.rotating = false
player.angle = 0
player.alive = true
player.animations = {}

function player:new(x,w,h)
    o = {}
    o.velX = x
    o.width = w or self.width
    o.height = h or self.height
    o.yellowQds = {}
    for i=1,3 do
        o.yellowQds[i] = love.graphics.newQuad(3 + (o.width + 11) * (i-1),491,o.width,o.height,gameSprites:getDimensions())
    end
    o.yellowQds[#o.yellowQds+1] = o.yellowQds[2]
    -- o.x = x 
    -- o.y = y
    setmetatable(o,{__index=self})
    return o
end

function player:turn(direction)
    uforce = 0.0174533 * 2
    dforce = 0.0174533 
    if direction == 'down' and self.angle < math.pi/2 then
        self.angle = self.angle + dforce
        return false
    elseif direction == 'up' and self.angle > -math.pi/6 then
        self.angle = self.angle - uforce
        return false
    else 
        return true
    end
end

function player:update(dt,gVel)
    if love.keyboard.isDown('space') and self.alive then
        gforce:reset()
    end
    if self.y + self.height  < love.graphics.getHeight()/2 - 56 then
        self.y = self.y + gVel - self.velY
         self.angle = self.angle + 0.05 + gVel*0.025 - (self.velY*0.055 + 0.01)
         if self.angle > math.pi/2  then 
             self.angle = math.pi/2
         elseif self.angle < -math.pi/6 then
             self.angle = -math.pi/6
         end
    else
        self.alive = false
    end
end

function player:updateTimer(x)
    self.timer = self.timer + x
end


function player:animate(dt)
    if self.timer >= dt*4 then
        self:nextFrame()
        self.timer = 0
    end
    if self.angle > 0 then
        self.frame = 1
    end
end
function player:setFrame(f)
	self.frame = f
end
function player:nextFrame()
    self.frame = (self.frame + 1)%self.totalFrames
end
function player:resetCords()
    self.x = player.x 
    self.y = player.y
end
