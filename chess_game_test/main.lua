require 'etc'
require 'piece'
require 'util'
function love.load()
    love.graphics.setBackgroundColor(1,1,1)
    win_width = love.graphics.getWidth()
    win_height = love.graphics.getHeight()
    board = {
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0
    }
    piecesGrid = {
        1,0,1,0,1,0,1,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,2,0,2,0,2,0,2
    }
    boardX = 150
    boardY = 100
    boardSize = 8
    tileSize = 20
    playerTurn = true
    pathlist = {}
    tilex = 0
    tiley = 0 
    px = 0
    py = 0
    mx = 0
    my = 0
    colorBoard()
    timer = 0
    holding = false
    holdPiece = {x=0,y=0,type=0}
    playerTile = 2
end

function love.mousepressed(x,y,button)
    boardD = boardSize * tileSize
    tilex = math.floor((x-boardX)/tileSize) + 1
    tiley = math.floor((y-boardY)/tileSize) + 1 
    tileDisx = tilex - holdPiece.x
    tileDisy = tiley - holdPiece.y
    local i = get1DIndex(tilex,tiley)
    if button == 1 and playerTurn and isOverlap(x,y,1,1,boardX,boardY,boardD,boardD) then
        timer = 0
        if holding and piecesGrid[i] == 0 then
            if math.abs(tileDisx) == 1 and tileDisy == -1 then
                piecesGrid[i] = playerTile
                holding = false
                playerTurn = false
            end
            if math.abs(tileDisx) == 2 and tileDisy == -2 then
                print(tileDisy)
                backx = holdPiece.x + (tileDisx/2)
                backy = holdPiece.y + (tileDisy/2)
                stepbacki = get1DIndex(backx,backy) 
                if piecesGrid[stepbacki] == 1 then
                    print('can capture')
                    piecesGrid[i] = playerTile
                    piecesGrid[stepbacki] = 0
                    holding = false
                end
            elseif tileDisx == 0 and tileDisy == 0 then
                piecesGrid[i] = playerTile
                holding = false
            end
        elseif holding == false and piecesGrid[i] == playerTile then
            holdPiece.x = tilex
            holdPiece.y = tiley
            holdPiece.type = piecesGrid[i]
            piecesGrid[i] = 0
            holding = true
        end
    end
end
function nextStepPath(x,y) 
    local right = x+1 
    local left = x-1
    local top = y-1
    local btm = y+1
    local topr = get1DIndex(right,top)
    local topl = get1DIndex(left,top)
    local btmr = get1DIndex(right,btm)
    local btml = get1DIndex(left,btm)
    local moves = {}
    if inBounds(right,btm) and piecesGrid[btmr] == 0 then
        table.insert(moves,1)
    end
    if inBounds(left,btm) and piecesGrid[btml] == 0 then
        table.insert(moves,-1)
    end
    if #moves > 0 then
        math.randomseed(os.time())
        local ran = math.random(1,#moves)
        return moves[ran]
    else
        return 0
    end
end

-- capture and step moves
function step(x,y,xdir)
    local i = get1DIndex(x,y)
    px = x+xdir
    py = y+1
    local nexti = get1DIndex(px,py)
    piecesGrid[nexti] = piecesGrid[i]
    piecesGrid[i] = 0
end
function caputreNmove(x,y,xdir,ydir)
    local i = get1DIndex(x,y)
    px = x+xdir*2
    py = y+2*ydir
    local nexti = get1DIndex(px,py)
    local enemi = get1DIndex(x+xdir,y+ydir)
    local type = piecesGrid[i]
    piecesGrid[i] = 0
    piecesGrid[enemi] = 0
    piecesGrid[nexti] = type
end
function chooseBestCapture()
    local pieces = {}
    for y=1, boardSize do 
        for x=1, boardSize do 
            local i = get1DIndex(x,y)
            if piecesGrid[i] == 1 then
                local temp_piece = piece:new(x,y)
                local pathlen = findCapturePathWNumOfSteps(x,y)
                -- local capture_path_len = math.abs(pathlen)
                local dir = (pathlen < 1) and -1 or 1
                temp_piece:setCapture_PathLen(math.abs(pathlen))
                temp_piece:setCapture_Dir(dir)
                table.insert(pieces,temp_piece)
            end
        end
    end
    keepLargestPaths = function(ary)
        table.sort(ary,function(a,b) return a.capture_pathLen > b.capture_pathLen end)
        largestVal = ary[1].capture_pathLen
        print(largestVal)
        for i=#ary,1,-1 do
            p = ary[i]
            if math.abs(p.capture_pathLen) < largestVal then
                table.remove(ary,i)
            elseif largestVal == 0 and nextStepPath(p.x,p.y) == 0 then
                table.remove(ary,i)
            end
        end
        return ary
    end
    pieces = keepLargestPaths(pieces)
    for _,i in pairs(pieces) do 
        print(i.x .. 'x ' .. i.y .. 'y ' .. (i.capture_pathLen * i.capture_dir))
    end
    ranPiece = pickRandom(pieces)
    return {ranPiece.x,ranPiece.y,totalCapturePaths=#pieces}
end

function love.update(dt)
    timer = timer + dt
    mx = love.mouse.getX()
    my = love.mouse.getY()
    if timer >= dt * 40 then
        if playerTurn == false then
            local movePiece = chooseBestCapture()
            px = movePiece[1] 
            py = movePiece[2] 
            nextCaptureMove = findCapturePath(px,py)
            nextMove = nextStepPath(px,py)
            if nextCaptureMove ~= 0 then
                caputreNmove(px,py,nextCaptureMove,1)                
            -- elseif nextCaptureMove == 0 and chooseBestCapture().totalCapturePaths > 0 then
            --     local movePiece = chooseBestCapture()
            --     px = movePiece[1] 
            --     py = movePiece[2] 
            elseif nextMove ~= 0 then
                step(px,py,nextMove)
                playerTurn = true
                print('turn is finnished')
            else
                playerTurn = true
                print('turn is finnished')
            end
            -- print(nextCaptureMove)
        end
        timer = 0
    end
end

function love.draw()
    draw_board()
end