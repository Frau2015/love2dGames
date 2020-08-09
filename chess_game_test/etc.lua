function canCapture(x,y,xdir,ydir)
    local step = get1DIndex(x+xdir,y+ydir)
    local step2x = x+xdir*2
    local step2y = y+ydir*2
    local step2 = get1DIndex(step2x,step2y)
    if inBounds(step2x,step2y) and piecesGrid[step] == 2 and piecesGrid[step2] == 0 then 
        return true
    end
    return false
end

function pathlookup(x,y,depth,ary)
    local canStep = false
    local i = get1DIndex(x,y)
    for nexty=1,2 do
        for nextx=1,2 do 
            local stepY = (nexty+1)%3-1
            local stepX = (nextx+1)%3-1
            local newx = x+stepX*2
            local newy = y+stepY*2
            local stepi = get1DIndex(newx,newy)
            local stepuno = get1DIndex(x+stepX,y+stepY)
            if piecesGrid[stepuno] == 2 and piecesGrid[stepi] == 0 then
                if (stepX == -1 or stepX == 1) and stepY == 1 then
                    if newy >= 1 and newx >= 1 and newx <= boardSize then
                        canStep = true
                        pathlookup(newx,newy,depth+1,ary)
                    end
                end
            end
        end
    end
    if canStep == false then
        table.insert(ary,depth)
    end
end
function findCapturePathWNumOfSteps(x,y)
    local optiPathsL = {}
    local optiPathsR = {}
    if canCapture(x,y,-1,1) then
        pathlookup(x-2,y+2,1,optiPathsL)
        table.sort(optiPathsL)
    end
    if canCapture(x,y,1,1) then
        pathlookup(x+2,y+2,1,optiPathsR)
        table.sort(optiPathsR)
    end
    print1DAry = function(ary)
        for _, val in pairs(ary) do
            print(val)
        end
    end
    if #optiPathsR > 0 and #optiPathsL > 0 then
        math.randomseed(os.time())
        local ranNum = math.random(1,2)
        local r = optiPathsR[#optiPathsR] 
        local l = optiPathsL[#optiPathsL] * -1
        local maxAry = {r,l}
        -- print(r)
        -- print(l)
        if optiPathsR[#optiPathsR] > optiPathsL[#optiPathsL] then
            return maxAry[1]
        elseif optiPathsR[#optiPathsR] < optiPathsL[#optiPathsL] then
            return maxAry[2]
        else
            return maxAry[ranNum]
        end
    elseif #optiPathsL == 0 and #optiPathsR > 0 then
        return optiPathsR[#optiPathsR]
    elseif #optiPathsR == 0 and #optiPathsL > 0 then
        return optiPathsL[#optiPathsL] * -1
    else
        return 0
    end
end
function findCapturePath(x,y)
    local left = x-2
    local topr = get1DIndex(x+1,y-1)
    local topl = get1DIndex(x-1,y-1)
    local optiPathsL = {}
    local optiPathsR = {}
    if canCapture(x,y,-1,1) then
        pathlookup(x-2,y-2,1,optiPathsL)
        table.sort(optiPathsL)
    end
    if canCapture(x,y,1,1) then
        pathlookup(x+2,y-2,1,optiPathsR)
        table.sort(optiPathsR)
    end
    print1DAry = function(ary)
        for _, val in pairs(ary) do
            print(val)
        end
    end
    -- print('paths the left branch can take')
    -- print1DAry(optiPathsL)
    -- print('paths the right branch can take')
    -- print1DAry(optiPathsR)
    if #optiPathsR > 0 and #optiPathsL > 0 then
        math.randomseed(os.time())
        local ranNum = math.random(1,2)
        local r = optiPathsR[#optiPathsR] .. ' r'
        local l = optiPathsL[#optiPathsL] .. ' l'
        local maxAry = {1,-1}
        -- print(r)
        -- print(l)
        if optiPathsR[#optiPathsR] > optiPathsL[#optiPathsL] then
            -- print('right path is better')
            return 1
        elseif optiPathsR[#optiPathsR] < optiPathsL[#optiPathsL] then
            -- print('left path is better')
            return -1
        else
            -- print('left path is better')
            return maxAry[ranNum]
        end
    elseif #optiPathsL == 0 and #optiPathsR > 0 then
        -- print('right ' .. optiPathsR[#optiPathsR])
        return 1
    elseif #optiPathsR == 0 and #optiPathsL > 0 then
        -- print('left ' .. optiPathsL[#optiPathsL])
        return -1
    else
        -- return 'neigther'
        return 0
    end
end

function colorBoard()
    for y=1, boardSize do
        for x=1,boardSize do 
            i = x + (y-1)*boardSize
            board[i] = (i+y-1)%2
        end
    end
end

function draw_board() 
    love.graphics.setColor(186/255, 141/255, 69/255)
    love.graphics.setLineWidth(6)
    love.graphics.rectangle('line',boardX,boardY,boardSize*tileSize,boardSize*tileSize)

    love.graphics.setColor(1,1,1)
    for y=1,boardSize do
        for x=1,boardSize do
            i = x + (y-1)*boardSize
            if board[i] == 0 then
                love.graphics.setColor(1,1,1)
            elseif board[i] == 1 then
                love.graphics.setColor(186/255, 141/255, 69/255)
            end
            love.graphics.rectangle('fill',(x-1)*tileSize + boardX,(y-1)*tileSize + boardY,tileSize,tileSize)

            -- draw checker pieces
            circRad = tileSize/2
            if piecesGrid[i] == 1 or piecesGrid[i] == 3 then
                love.graphics.setColor(0,0,0)
                love.graphics.circle('fill',(x-1)*tileSize + boardX + circRad,(y-1)*tileSize + boardY + circRad,circRad)
                if piecesGrid[i] == 3 then
                    
                end
            elseif piecesGrid[i] == 2 or piecesGrid[i] == 4 then
                love.graphics.setColor(1,0,0)
                love.graphics.circle('fill',(x-1)*tileSize + boardX + circRad,(y-1)*tileSize + boardY + circRad,circRad)
            end

            if holding and (holdPiece.type == 2 or holdPiece.type == 4) then
                love.graphics.setColor(1,0,0)
                love.graphics.circle('fill',mx,my, circRad)
            end
        end
    end
end