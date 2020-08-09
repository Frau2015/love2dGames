function newRoad(x)    
    scale = 2
    road = {}
    road.quad = love.graphics.newQuad(292,0,168,56,gameSprites:getDimensions())
    road.objs = {}
    road.width = 168
    road.height = 56
    road.x = x
    road.y = screenH - road.height
    function road:move(x)
        self.x = self.x + x 
    end
    -- road:move = function(x) self.x = self.x + x end
    return road
end
roads = {}

function roads:updateRoads()
    if #self > 0 and #self < 2 then
        a = self[1]
        if a.x <= 0 then
            roads[#roads+1] = newRoad(roads[1].x+roads[1].width)
        end
    end
    if roads[1].x + roads[1].width <= 0 then
        table.remove(roads,1)
    end
end

pipe = {}
pipe.width = 26
pipe.len = 0
pipe.screenH = love.graphics.getHeight()/2
pipe.screenW = love.graphics.getWidth()/2
pipe.x = nil
pipe.y = nil
pipe.height = 160
pipe.spritesCords = {56,323,56+26+2,323} -- space between pipe sprites is 2px
pipe.quad = nil
platformH = 562
pipePile = {}

function pipe:new() 
    local o  = {}
    o.x = love.graphics.getWidth()/2 + self.width
    setmetatable(o,{__index=self})
    return o
end
function pipe:move(x)
    self.x = self.x + x
end
function pipePile:new()
    local o = {}
    setmetatable(o,{__index=self})
    return o
end
function pipePile:addPair()
    screenH = love.graphics.getHeight()/2
    pipeOpening = 48
    totalpipeLen = screenH - (pipeOpening + 56)
    pipePieces = 4 -- should be a factor of totalpipeLen
    pipepieceLen = totalpipeLen/pipePieces -- how long each piece of pipe, each piece is 38
    self[#self+1] = {pipe:new(),pipe:new()}
    love.math.setRandomSeed(love.timer.getTime())
    pipe1Len = love.math.random(1,pipePieces-1) 
    pipe2Len = (pipePieces - pipe1Len)* pipepieceLen
    pipe1Len = pipe1Len* pipepieceLen
    self[#self][1].len = pipe1Len 
    self[#self][2].len = pipe2Len 
    self[#self][1].y = 0
    self[#self][2].y = screenH - (56+pipe2Len)
    self[#self][1].quad = love.graphics.newQuad(56,323+(160-pipe1Len),26,pipe1Len, gameSprites:getDimensions())
    self[#self][2].quad = love.graphics.newQuad(56+26+2,323,26,pipe2Len, gameSprites:getDimensions())
end
function pipePile:movePile(x)
    for _, v in ipairs(self) do
        v[1]:move(x)
        v[2]:move(x)
    end
end
function pipePile:cleanUp()
    for i, v in ipairs(self) do
        if v[1].x + v[1].width < 0  then
            table.remove(self,i)
        end
    end
end
