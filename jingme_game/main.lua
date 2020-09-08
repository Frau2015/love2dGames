function love.load()
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	shapeLib = require('rigidShapes')
	rectShape = shapeLib.rect
	sqr = rectShape:new(100,100,50,50)
	velx = 5
	gforce = 4
	gaccel = 1.1
end
function love.keypressed(key)
	if key == 'up' then
		sqr.y = sqr.y - 100
	end
end
function love.update()
	if love.keyboard.isDown('right') then
		sqr.x = sqr.x + velx
	end
	if love.keyboard.isDown('left') then
		sqr.x = sqr.x - velx
	end
	if sqr.y < 300 then
		if gforce == 0 then
			gforce = 4
		end
		gforce = gforce * gaccel
	else 
		gforce = 0
	end
		sqr.y = sqr.y + gforce
end

function love.draw()
	love.graphics.setColor(1,0,0)
	love.graphics.rectangle('fill',sqr.x,sqr.y,sqr.w,sqr.h)
	
end

