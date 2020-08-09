require 'scene'
require 'lib/camera'
require 'lib/delay'
function love.load()
    screenH = love.graphics.getHeight()/2
    screenW = love.graphics.getWidth()/2
    gamestate = 'menu'
    love.graphics.setDefaultFilter('linear','nearest')
    love.graphics.setBackgroundColor(1,1,1)
    gameSprites = love.graphics.newImage('gfx/flappybirdSprites.png')
    flappyBatch = love.graphics.newSpriteBatch(gameSprites)
    background = {love.graphics.newQuad(0,0,144,256,gameSprites:getDimensions())}
    background.quads = {love.graphics.newQuad(0,0,144,256,gameSprites:getDimensions()),love.graphics.newQuad(144+2,0,144,256,gameSprites:getDimensions())}
    roads[#roads+1] = newRoad(0)
    msx = 0
    msy = 0
    menuProps = {}
    num = 123456789
    numstr = tostring(num)
    delta = 0
    flashDelay = delay:new(0.048)
    menuProps.startLogo = {love.graphics.newQuad(351,91,89,24,gameSprites:getDimensions()),screenW/2 - 89/2,(screenH -56)/2 -24  }
    menuProps.startButton = {love.graphics.newQuad(354,118,52,29,gameSprites:getDimensions()), screenW/2 - 52/2,menuProps.startLogo[3] + 24 + 30}
    bird = player:new(1.4)
    if gamestate == 'playing' then
        loadScene()
    end
end


function love.mousereleased(x,y,btn)
    if btn == 1 and isColliding(msx,msy,2,2,menuProps.startButton[2]*2,menuProps.startButton[3]*2,52*2,29*2) then
        gamestate = 'playing'
        -- print('mouseDOWN')

        loadScene()
    end
end

function love.update(dt)
    delta = dt
    msx = love.mouse.getX()
    msy = love.mouse.getY()
    flappyBatch:clear()
    
    background.id = flappyBatch:add(background.quads[1],0,0)

    -- addRoads()
    roads:updateRoads()
    batchRoads(-bird.velX)

    if gamestate == 'menu' then
        flappyBatch:add(menuProps.startLogo[1],menuProps.startLogo[2],menuProps.startLogo[3])
        flappyBatch:add(menuProps.startButton[1],menuProps.startButton[2],menuProps.startButton[3])
        bird:updateTimer(dt)
    	bird:animate(dt)
    	flappyBatch:add(bird.yellowQds[bird.frame+1],(screenW - bird.width)/2, 110,0)
    end

    if gamestate == 'playing' then
        updateScene(dt)
    end
    flappyBatch:flush()
    if camera:runAnimations(dt) == false then
        camera:setPosition(0,0)
    end

end

function love.draw(dt)

    camera:set()
    love.graphics.draw(flappyBatch, 0,0,0,2,2)

    if bird.alive == false then
        flashDelay:run(delta)
        if flashDelay:check() then
            love.graphics.setColor(1,1,1,0.7)
            love.graphics.rectangle('fill',0,0,screenW*2,screenH*2)
        end 
    end
    if gamestate == 'playing' then
    	drawScene()
    end
    love.graphics.setColor(0,0,0)
    -- love.graphics.rectangle('fill',msx,msy,2,2)
    -- love.graphics.rectangle('line',menuProps.startButton[2]*2,menuProps.startButton[3]*2,52*2,29*2)
    love.graphics.setColor(1,1,1)
    camera:unset()
end
