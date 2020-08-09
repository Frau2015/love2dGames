playerTemp = {} -- player template
--gfx
playerTemp.img = nil
playerTemp.frame = 0
playerTemp.idleFrames = {}
playerTemp.walkImg = nil
playerTemp.walkQuads = {}
playerTemp.state = "idle"
playerTemp.imageObj = nil
playerTemp.imgPath = "imgs"
playerTemp.quad = nil
playerTemp.walkTimer = 0
--player game states
playerTemp.touchingLadder = false
playerTemp.canWalkLadder = false
playerTemp.mountLadder = false
playerTemp.carrying = false
--quant data
playerTemp.x = 0
playerTemp.y = 0
playerTemp.h = 80
playerTemp.w = 72
--physcics
playerTemp.velx = 0
playerTemp.speedx = 3
playerTemp.vely = 0
playerTemp.gforce = 0
-- playerTemp.gaccel = 0.16
playerTemp.gaccel = 0.4
playerTemp.terminalGvel = 12
playerTemp.jumpvel = 6
playerTemp.jumping = false
playerTemp.jumpcount = 0
playerTemp.xdir = 1

function playerTemp:new(x,y,width,height,img_path)
    o = {}
    o.x = x
    o.y = y
    o.h = height
    o.w = width

    o.xdir = 1
    o.grounded = false
    o.floorstop = nil

    o.img = love.graphics.newImage(img_path)
    setmetatable(o,{__index=self})
    return o
end

function playerTemp:draw(dt)
    xoffset = 0
    if self.xdir == -1 then
        xoffset = self.w
    end
    love.graphics.draw(self.img,self.x,self.y,0,self.xdir,1,xoffset)
end

function playerTemp:update()
    self:updateCords()
    if self.grounded == false then
        self:updateGforce()
    end
    if self.touchingLadder == false then
        if self.mountLadder then
            self.grounded = false
        end
        self.mountLadder = false
    end
    if self.mountLadder then
        self.grounded = true
        --player = grabbingLadder
    end
    -- if self.mountLadder and 
end
function playerTemp:updateCords()
    if player.jumping and self.vely == 0 then
        self.vely = self.jumpvel
    end
    self.y = self.y + self.gforce - self.vely
end
function playerTemp:checkKeypressEvents(key)
    if key == 'up' then
        if self:canMountLadder() and self.carrying == false then
            self.mountLadder = true
        end
        if self.carrying then
            self.carrying = false
        end
    end
end
function playerTemp:canMountLadder()
    if self.touchingLadder == true and self.mountLadder == false  and self.grounded == true then
        return true
    end
    return false
end
function playerTemp:jump()
    if self.grounded == true then
        self.jumping = true 
        -- print(self.jumping)
        self.grounded = false
    end
    self.mountLadder = false
end

function playerTemp:move(keydir) 
    if keydir == 'right' then
        self.state = "walking"
        -- end
        self.xdir = 1
        self.velx = 3
        self.x = self.x + self.velx
    elseif keydir == 'left' then
        self.state = "walking"
        -- end
        self.xdir = -1
        self.velx = 3
        self.x = self.x - self.velx
    end
end
function playerTemp:carryObj(obj)
    obj.grounded = true
    obj.x = self.x + self.w/2 - obj.w/2
    obj.y = self.y - obj.h
    
end
function playerTemp:dropObj(obj)
    obj.grounded = false
end
-- physics
function playerTemp:groundPlayer(groundY)
    self.gforce = 0
    self.jumping = false
    self.vely = 0
    self.y = groundY - self.h + 2
    self.grounded = true
end

function playerTemp:updateGforce()
    if self.gforce < self.terminalGvel then
        self.gforce = self.gforce + self.gaccel 
        -- print('player gforce' .. self.gforce)
    end
end
function playerTemp:setGaccel(x)
    self.gaccel = x
end

function playerTemp:resetGforce()
    self.gforce = 0
end

function playerTemp:isFalling()
    if player.gforce > player.vely then
        return true
    end
    return false
end
