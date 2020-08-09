require 'player'
require 'boundaries'
spring = {x=0,y=480-32*11,w=32,h=32,class='spring',carried=false}
function love.load()
    --platform, width in num of bricks,x,y block x,y
    blockD = 32
    spring.grounded = true
    spring.vely = 0
    spring.velx = 0
    spring.gforce = 0
    spring.gaccel = 0.5
    spring.terminalGvel = 10
    spring.updateGforce = function()
            -- print('spring gforce' .. spring.gforce)
            -- print('spring terminalGvel' .. spring.terminalGvel)
        if spring.gforce < spring.terminalGvel then
            spring.gforce = spring.gforce + spring.gaccel 
        end
    end
    spring.updateCords = function()
        spring.y = spring.y + spring.gforce - spring.vely
    end
    --spring2 = {x=300,y=480-32*8,w=32,h=32,class='spring',carried=false}
    ladder = {x=300,y=480-32*7,w=32,h=32*6,class='ladder'}
    door = {x=32*12,y=480-32*9,w=32,h=64,class='door'}
    tileset = love.graphics.newImage('tileset.png')
    ladder.quad = love.graphics.newQuad(64,0,32,32,tileset:getDimensions())
    brickQuad = love.graphics.newQuad(0,0,32,32,tileset:getDimensions())
    stoneQuad = love.graphics.newQuad(32,0,32,32,tileset:getDimensions())
    batchGFX = love.graphics.newSpriteBatch(tileset) 
    player = playerTemp:new(0,100,32,64,'mario.png')
    player.class = 'player'
    win_width = love.graphics.getWidth()
    win_height = love.graphics.getHeight()
    love.graphics.setBackgroundColor(1,1,1)
    overlapDIR = 'none'
    gameState = 'play'
    overlapping = false
    touchingLadder = false
    grabbingLadder = false
    touchingGround = false
    platformAry = {
        {x=0,y=480-32*4,w=8*32,h=32,quad=stoneQuad,class='platform'},
        {x=0,y=480-32*10,w=4*32,h=32,quad=stoneQuad,class='platform'},
        {x=264,y=480-32*7,w=6*32,h=32,quad=stoneQuad,class='platform'},
        -- {x=0,y=480-32,w=15*32,h=32,quad=stoneQuad,class='platform'}
    }
    -- floor={x=264,y=480-32*7,w=6*32,h=32,quad=brickQuad,class='floor'}
    -- floor = {x=0,y=480-32,w=15*32,h=32,class='floor'}
    floor = {x=0,y=480-32,w=15*32,h=32,quad=brickQuad,class='floor'}
    worldObjs = {ladder,spring,platformAry[1],platformAry[2],platformAry[3],floor}
    sceneObjs = {player,ladder,spring,platformAry[1],platformAry[2],platformAry[3],floor,door}
    -- floor.quad = brickQuad
    timer = 0
    jumpTimer = 0
end
function spring:groundPlayer(groundY)
    self.gforce = 0
    self.velx = 0
    self.vely = 0
    self.y = groundY - self.h
    self.grounded = true
end
function addLadders()
    for i=0,ladder.h-32,32 do
        batchGFX:add(ladder.quad,ladder.x,ladder.y+i)
    end
end

function addPlatformBatch(platform)
    for i=0,platform.w-32,32 do
        batchGFX:add(platform.quad,platform.x+i,platform.y)
    end
end
function PlayerClimbUpLadder()
    if player.mountLadder then
        player.y = player.y - 2
    end
end
function updateBatch()
    batchGFX:clear()
    addPlatformBatch(floor)
    for _,i in pairs(platformAry )do
        addPlatformBatch(i)
    end
    addLadders()
    batchGFX:flush()
end

function carryObj(obj)
    obj.x = player.x + player.w/2 - obj.w/2
    obj.y = player.y - obj.h
end
function updateScene()
    for i, obj in pairs(sceneObjs) do
        if obj.class == 'player' then
            -- playerCheckForOthers(i)
        end
        if obj.class == 'spring' then
            if obj.grounded == false then
                spring.updateGforce()
                spring.y = spring.y + spring.gforce - spring.vely
                spring.x = spring.x + spring.velx
                -- spring.updateCords()
                -- springCheckForOthers(obj)
            end
        end

        --an overlap event loop only for physics objs
        if obj.class == 'spring' or obj.class == 'player' then
            OverlapLoop(obj)
        end

        --check if anyobjs is being carried by player
        if obj.carried == true then
            if player.carrying then
                player:carryObj(obj) --item tells player to carry it
            else
                -- print(obj.class)
                if obj.velx == 0 then
                    obj.velx = player.velx * player.xdir
                    -- print(player.velx)
                end
                obj.grounded = false
                obj.carried = false
            end
        end
    end
end

function canPlayerPickupObj(obj) 
    if love.keyboard.isDown('up') and obj.carried == false and obj.grounded == true and player.carrying == false then
        return true
    end
    return false
end

function OverlapLoop(physObj)
    overlapping = false
    if physObj.class == 'player' then
        physObj.touchingLadder = false
    end
    for i, obj in pairs(sceneObjs) do
        --make sure doesn't check for overlap self
        if obj.class ~= physObj.class then
            if isOverlapObj(obj,physObj) then
                overlapping = true
                --check if obj is falling
                if physObj.gforce > physObj.vely then
                    if obj.class =='floor' then
                        -- check if physObj is above floor and is falling 
                        if physObj.y < obj.y then
                            physObj:groundPlayer(obj.y)
                        end
                    end
                    if obj.class == 'platform' then
                        if physObj.y+physObj.h - 10 < obj.y and physObj.grounded == false then
                            physObj:groundPlayer(obj.y)
                        end
                    end
                end
                --Player Overlap Code
                if physObj.class == 'player' then
                    --logic for player and other entties
                    --better to not have grounded outside
                    --rather you should check grounded inside the obj class logic
                    if physObj.grounded == true then
                        if canPlayerPickupObj(obj) then
                            if obj.class == 'spring' then
                                obj.carried = true
                                player.carrying = true
                            end
                        end
                        if obj.class == 'door' then
                            if love.keyboard.isDown('up') then
                                gameState = 'win'
                            end
                        end
                    end
                    if obj.class =='ladder' then
                        player.touchingLadder = true
                    end
                end
            end
            --end of Overlap
        end
    end

    if overlapping == false then
        physObj.grounded = false 
    end
end
function updateKeyEvents()
    if love.keyboard.isDown('right')then
        player:move('right')
    elseif love.keyboard.isDown('left')then
        player:move('left')
    else
        player.velx = 0
    end
end
function love.keypressed(key)
    --WARNING the keypressed is a callback(), the time it triggers can't be controlled
    player:checkKeypressEvents(key)
end

function love.update(dt)
    timer = timer + dt
    -- checkBoundaries()
    updateKeyEvents()
    if love.mouse.isDown(1) then
        player.y = love.mouse.getY()
        player.x = love.mouse.getX()
    end
    if love.keyboard.isDown('up') then
        PlayerClimbUpLadder()
    end
    if love.keyboard.isDown('space')then
        player:jump()
        jumpTimer = jumpTimer + dt
        if player.gaccel > 0.2 then
            player.gaccel = player.gaccel - 0.04 
        end
    else
        player.gaccel = 0.4
        jumpTimer = 0
    end
    updateScene()
    player:update()
    updateBatch()
end

function love.draw()
    --love.graphics.rectangle('fill',spring2.x,spring2.y,spring2.w,spring2.h)
    love.graphics.setColor(0.5,0.2,0.2)
    love.graphics.rectangle('fill',door.x,door.y,door.w,door.h) 
    love.graphics.setColor(1,1,1)
    love.graphics.draw(batchGFX)
    player:draw()
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle('fill',spring.x,spring.y,spring.w,spring.h) 
    love.graphics.setColor(0,0,0)
    love.graphics.print('Player.isTouchingLadder? ' .. tostring(player.touchingLadder),10,20);
    love.graphics.print('Player.isGrounded? ' .. tostring(player.grounded),10,36);
    love.graphics.print('Gamestat ' .. tostring(gameState),10,52);
    --love.graphics.rectangle('fill',platformAry[1][2],platformAry[1][3],10,10)
    --love.graphics.rectangle('fill',platformAry[2][2],platformAry[2][3],10,10)
    --love.graphics.rectangle('fill',player.x,player.y+64,10,10)
end
