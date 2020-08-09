require 'props'
require 'player'
require 'lib/physics'

function collidingIntoPipes(ary)

    if isColliding(bird.x,bird.y,bird.width,bird.height,ary[1].x, ary[1].y,ary[1].width,ary[1].len) then
        bird.alive = false
    elseif isColliding(bird.x,bird.y,bird.width,bird.height,ary[2].x, ary[2].y,ary[2].width,ary[2].len) then
        bird.alive = false
    end
end
function getTotalLen(str)
    total = 0
    for i=1, string.len(str) do
        inum = tonumber(string.sub(str,i,i))
        if inum == 1 then
            total = total + 8 + 1
        else 
            total = total + 12 + 1
        end
    end
    return total
end
function batchCountStr(str)
    spacing = 0
    totalLen = getTotalLen(str)
    for i=1, string.len(str) do
        inum = tonumber(string.sub(str,i,i))
        flappyBatch:add(numbers[inum+1],spacing + (love.graphics.getWidth()/4 - totalLen/2),35) 
        if inum == 1 then
            spacing = spacing + 8 + 1
        else 
            spacing = spacing + 12 + 1
        end
    end
end
function love.keypressed(key)
    if key == 'space' and gamestate == 'playing' and bird.alive then
        start = true
        flapSound:play()
    end
end
function batchRoads(x) -- adds current roads to road batch
    for i=1,#roads do 
        roads[i]:move(x)
        flappyBatch:add(roads[i].quad,roads[i].x, roads[i].y)
    end
end
function batchPipes()
    for i,pipe in ipairs(pipes) do
        if  bird.x + bird.width > pipes[1][1].x and bird.x < pipes[1][1].x+pipes[1][1].width then
            collision = true
        elseif bird.x > pipes[1][1].x+pipes[1][1].width and collision == true then
            score = score + 1
            winPoint:stop()
            winPoint:play()
            collision = false
        end
        -- print(collision)
        -- print(pipe[1].x)
        flappyBatch:add(pipe[1].quad,pipe[1].x,pipe[1].y)
        flappyBatch:add(pipe[2].quad,pipe[2].x, pipe[2].y)
    end
end
function loadScene() 
    startSprites ={ love.graphics.newQuad(292,91,57,49,gameSprites:getDimensions()),
                    love.graphics.newQuad(295,59,92,25,gameSprites:getDimensions())
                }
    numbers = { love.graphics.newQuad(496,60,12,18,gameSprites:getDimensions()),love.graphics.newQuad(136,455,8,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292,160,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292 + 14,160,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292 + 14*2,160,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292 + 14*3,160,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292,184,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292 + 14,184,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292 + 14 *2,184,12,18,gameSprites:getDimensions()),
                love.graphics.newQuad(292 + 14 * 3,184,12,18,gameSprites:getDimensions()),
            }
    start = false
    flapSound = love.audio.newSource("sfx/sfx_wing.mp3", "static")
    winPoint = love.audio.newSource("sfx/sfx_point.mp3", "static")
    hitSound = love.audio.newSource("sfx/sfx_hit.mp3", "static")
    winPoint:setVolume(0.2)
    gforce = gravity:new(0.1)
    -- pipeQuad = love.graphics.newQuad(56,323,26,160,gameSprites:getDimensions())
    background.id = flappyBatch:add(background.quads[1],0,0)
    collision = false
    score = 0
    isDead = false
    bird.batchId = flappyBatch:add(bird.yellowQds[1],bird.x,bird.y)
    pipes = pipePile:new()
    pipes:addPair()

    bird:resetCords()
    bird.angle = 0
    bird.alive = true
    bird.velX = 1.4
    flashDelay.current = 0
    isDead = false
    startOpacity = 1
    pipeTimer = 0
end

function sucessSound(bird,i,sfx)
    if bird.x > i.x + i.width then
        sfx:play()
    end
end

function updateScene(dt)
    pipeTimer = pipeTimer + dt
    pipes:cleanUp()
    bird:updateTimer(dt)
    bird:animate(dt)
    if isDead == false and bird.alive == false then
        hitSound:play()
        camera:addAnimation('shake',0,1,0.2)
        camera:addAnimation('shake',0,0.5,0.2)
    end
    if start then
        gforce:update()
        bird:update(dt,gforce:getVel())
    end
    if bird.alive then
        if start then
            pipes:movePile(-bird.velX)
            if #pipes > 0 then
                if pipes[#pipes][1].x < screenW - 60 then 
                    pipes:addPair()
                end
            end
            for _, v in ipairs(pipes) do
                collidingIntoPipes(v)
            end
            startOpacity = startOpacity - 0.04
        else
            -- love.graphics.setColor(0,0,0)
            -- flappyBatch:add(startSprites[1],bird.x + 6,bird.y -13)
            -- flappyBatch:add(startSprites[2],(screenW - 92)/2,bird.y -50)
            -- love.graphics.setColor(1,1,1)
        end
    else
        bird:setFrame(1)
        isDead = true
        bird.velX = 0
    end 

    roads:updateRoads()
    -- if pipeTimer >= dt*70 then
    --     -- print(pipeTimer)
    --     pipes:addPair()
    --     pipeTimer = 0
    --     -- print(#pipes*2)
    -- end

    batchPipes()  
    batchCountStr(tostring(score))
    -- print(score )
    flappyBatch:add(bird.yellowQds[bird.frame+1],bird.x,bird.y,bird.angle)
end

function drawScene( )
    if startOpacity > 0 then
        -- startOpacity = startOpacity - 0.2
        -- love.graphics.setColor(0,0,0)
        love.graphics.setColor(1,1,1,startOpacity)
        love.graphics.draw(gameSprites,startSprites[1],(39.5 + 6) * 2,(122 -13)*2,0,2,2)
        love.graphics.draw(gameSprites,startSprites[2],((screenW - 92)/2)*2,(122 -50)*2,0,2,2)
        love.graphics.setColor(1,1,1)

    end
    -- body
end
