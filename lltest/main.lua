require 'math_lib'
function love.load()
	love.graphics.setBackgroundColor(1,1,1)
	screenW = love.graphics.getWidth()
	screenH = love.graphics.getHeight()
	origin = {50,50}
	mx = origin[1]
	my = origin[2]
	pointer = {mx,my}
	lines = {origin,pointer}
	line1a = {x=100,y=200}
	line1b = {x=200,y=200}
	line2a = {x=100,y=200}
	line2b = {x=200,y=200}
end
function love.mousepressed(x,y,button)
	if button == 2 then
		print('clicked')
		table.insert(lines,#lines,{x,y})
	end
end

function love.update()
	mx = love.mouse.getX()
	my = love.mouse.getY()
	pointer[1] = mx
	pointer[2] = my
end
function drawLine(line)
	love.graphics.line(line[1].x,line[1].y,line[2].x,line[2].y)
end
function drawLines(lines)
	for i=1,#lines-1 do
		local interseting = false
		local linea = {x=lines[i][1],y=lines[i][2]}
		local lineb = {x=lines[i+1][1],y=lines[i+1][2]}
		for j=1,#lines-1 do
			local inea2 = {x=lines[j][1],y=lines[j][2]}
			local ineb2 = {x=lines[j+1][1],y=lines[j+1][2]}
			if j ~= i then
				intersecting = lineLineIntersect(linea2,lineb2,linea,lineb)
				if intersecting then print(j .. ' ' .. i)break end
			end
		end
		local color = intersecting and {0,1,0} or {0,0,0}
		love.graphics.setColor(color[1],color[2],color[3])
		love.graphics.line(linea.x,linea.y,lineb.x,lineb.y)
	end
end
function love.draw()
	drawLine({line1a,line1b})
	drawLine({line2a,line2b})
	love.graphics.print('isintersecting ' .. tostring(lineLineIntersect(line1a,line1b,line2a,line2b)),10,20)
	drawLines(lines)
end

