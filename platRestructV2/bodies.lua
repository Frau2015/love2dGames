physicsBody = {}
physicsBody.velx = 3
physicsBody.vely = 0
physicsBody.gforce = 0
physicsBody.gaccel = 0.16
physicsBody.terminalGvel = 12
function physicsBody:new()
    
end
function physicsBody:updateGforce()
    if self.gforce < self.terminalGvel then
        self.gforce = self.gforce + self.gaccel 
    end
end
function physicsBody:setGaccel(x)
    self.gaccel = x
end

function physicsBody:resetGforce()
    self.gforce = 0
end

function physicsBody:isFalling()
    if self.gforce > self.vely then
        return true
    end
end