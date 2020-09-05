require 'game'
function love.load()
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	gfx = love.graphics
	game = game:new()
end
function printCord(name,pos)
	print(name .. ' x:' .. pos.x .. ' y:' .. pos.y )
end

function love.update()
	mx = love.mouse.getX()
	my = love.mouse.getY()
	game:update()
end
function lineBtwnVectors(v1,v2)
	gfx.line(v1.x,v1.y,v2.x,v2.y)
end
function love.draw()
	game:draw()
	-- gfx.print('fps ' .. love.timer.getFPS(),20,60)
	-- gfx.print('angle ' .. spoolSystem:getAngle(),20,80)
end
