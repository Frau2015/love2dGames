function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
tetrisPieces ={
    {0,1,0,
     1,1,1,
     0,0,0},
     {0,1,0,
      0,1,0,
      0,1,1},
     {0,1,0,0,
      0,1,0,0,
      0,1,0,0,
      0,1,0,0
      }
    }
colors = {'red','blue','green'}
controlPiece = tetrisPieces[1]
controlPieceLen = 4
controlPieceColor = 'red'

function love.load()
    local abc = {5,12,1}
    local bdc = shallowcopy(abc)
    table.sort(bdc)
    print(abc[2] .. ' ' .. bdc[2])
    love.graphics.setBackgroundColor(1,1,1)
    win_width = love.graphics.getWidth()
    win_height = love.graphics.getHeight()

    playGrid = 
            {0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0,
             0,0,0,0,0,0,0,0,0,0
             }
    playGridW = 10
    playGridX = 100
    playGridY = 100
    sqrD = 20
    tetx = 4
    tety = 0
    offsetx = 0
    timer = 0

    restControlPiece()
end
function genRandom(min,max)
    ran_seed = (os.time())
    return math.random(min,max)
end
function restControlPiece()
    ran_num = genRandom(1,#tetrisPieces)
    controlPieceColor = colors[genRandom(1,#colors)]
    tetx = 4
    tety = 0
    controlPiece = shallowcopy(tetrisPieces[ran_num])
    controlPieceLen = math.sqrt(#controlPiece)
end
function clearPlayGrid()
    for i=1,#playGrid do
        playGrid[i] = 0
    end
end
function genSquareMatrix(msize)
    tmpmatrx = {}
    for i=1,msize do
        tmpmatrx[i] = 0
    end
    return tmpmatrx
end

function rotCounterClockWise(matrx) 
    --tmpmatrx = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    tmpmatrx = genSquareMatrix(#matrx)
    for i, val in pairs(matrx) do
        newIndx = (#matrx-controlPieceLen) - ((i-1)%controlPieceLen*controlPieceLen) + math.floor((i-1)/controlPieceLen)
        tmpmatrx[newIndx+1] = matrx[i] 
    end
    for i, val in pairs(tmpmatrx) do 
        matrx[i] = val
    end
    return matrx
end

function rotClockWise(matrx) 
    tmpmatrx = genSquareMatrix(#matrx) 
    for i, val in pairs(tmpmatrx) do 
        --newIndx = 4 - ((i-1)%2+1) + math.floor((i-1)/2)
        newIndx = (#matrx-controlPieceLen) - ((i-1)%controlPieceLen*controlPieceLen) + math.floor((i-1)/controlPieceLen)
        tmpmatrx[i] =  matrx[newIndx+1]
    end
    for i, val in pairs(tmpmatrx) do 
        matrx[i] = val
    end
    return matrx
end

function drawPlayGrid(grid)
    for i, val in pairs(grid) do
        x = (i-1)%10 *sqrD
        y = math.floor((i-1)/10)*sqrD
        love.graphics.rectangle('line',playGridX+x,playGridY+y,sqrD,sqrD)
        if val == 1 then
            love.graphics.rectangle('fill',playGridX+x,playGridY+y,sqrD,sqrD)
        end
    end
end
function mapTetris2() 
    for y=1,controlPieceLen do
        for x=1,controlPieceLen do
            if tety+y <= playGridW and controlPiece[(y-1)*controlPieceLen+x] == 1 then
                --playgrid[tetx+(tety-1)*10] = 1
                playGrid[tetx+x+(tety+y-1)*10] = 1
            end
        end
    end
end

function love.keypressed(key)
    if key == 'up' then
        rotate = 1
        controlPiece = rotClockWise(controlPiece)
    end
    if key == 'down' then
        -- rotate = -1
        -- controlPiece = rotCounterClockWise(tetrisPieces[1])
        tety = tety + 1
    end

    if key == 'right' then
        offsetx = 1
    end
    if key == 'left' then
        -- tetx = tetx - 1
        offsetx = -1
    end
    if key == 'space' then
        restControlPiece()
        timer = 0

    end
end

function drawControlPiece(drawMode)
    for y=1,controlPieceLen do
        for x=1,controlPieceLen do
            if controlPiece[(y-1)*controlPieceLen+x] == 1 then
                newx = (x+tetx-1)*sqrD
                newy = (y+tety-1)*sqrD
                love.graphics.rectangle(drawMode,playGridX+newx,playGridY+newy,sqrD,sqrD)
            end
        end
    end
end

function getGridVal(x,y)
    return playGrid[tetx+x+(tety+y-1)*playGridW]
end
function checkGridCol(x,y)
        --playGrid[tetx+(tety-1)*10] = 1
        if tety+y > playGridW  or  playGrid[tetx+x+(tety+y-1)*10] == 1 then
            return true
        end
end

function canStepX(xstep,tetpiece)
    for y=1,controlPieceLen  do
        for x=1,controlPieceLen  do
            if tetpiece[(y-1)*controlPieceLen+x] == 1 and (getGridVal(x+xstep,y) == 1 or tetx+xstep+x < 1 or  tetx+xstep+x > playGridW)  then
                return false
            end
        end
    end
    return true
end

function canStepY(tetpiece)
    ystep = 1
    for y=1,controlPieceLen  do
        for x=1,controlPieceLen  do
            if tetpiece[(y-1)*controlPieceLen+x] == 1 and (getGridVal(x,y+ystep) == 1 or tety+y+ystep > playGridW)  then
                --put on the grid
                return false
            end
        end
    end
    return true
end
function love.update(dt)
    timer = timer + dt
    -- clearPlayGrid()
    -- mapTetris2()
    tetx = canStepX(offsetx,controlPiece) and tetx + offsetx or tetx
    offsetx = 0
    if timer > dt*25 then
        if canStepY(controlPiece) then
            tety = tety + 1 
        else
            if tety == 0 then
                print('you lose')
            end
            mapTetris2()
            restControlPiece()
        end
        timer = 0
        -- clearPlayGrid()
        -- rotClockWise(controlPiece)
        -- mapTetris2()
    end
    if love.keyboard.isDown('space')then
        print(timer)
    end
end

function love.draw()
    if controlPieceColor == 'red' then
        love.graphics.setColor(1,0,0)
    elseif controlPieceColor == 'green' then
        love.graphics.setColor(0,1,0)
    elseif controlPieceColor == 'blue' then
        love.graphics.setColor(0,0,1)
    end
    drawPlayGrid(playGrid)
    -- drawtoGrid(controlPiece,playGridX,playGridY)
    drawControlPiece('fill')
    love.graphics.setColor(0,0,0)
    drawControlPiece('line')
end