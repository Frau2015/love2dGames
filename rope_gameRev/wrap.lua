require 'lib'
function getSlope(vect1,vect2)
		local ydiff = (vect1.y - vect2.y) 
		local xdiff = (vect1.x - vect2.x)
		return (ydiff/xdiff)
end
function genNewPoint(circ,lineSeg,p)
	local m = getSlope(pointer,p)
    local invertM = -1/m
	local b =  p.y - p.x*m
	local b2 = circ.y - circ.x*invertM 
	local x = (b-b2)/(invertM-m)
	local y = x*m+b
	local isectRad = (x-circ.x)^2 + (y - circ.y)^2
	if isectRad < circ.rad^2 then
		local scale = circ.rad/math.sqrt(isectRad)
		local width = x-circ.x 
		local height = y-circ.y
		local newx = circ.x+width*scale
		local newy = circ.y+height*scale 
		table.insert(points,cord2d:new(newx,newy))
	end
end

function addIntersectionPoints(circ,lineSeg,p)
	local m = getSlope(pointer,p)
    local invertM = -1/m
	local b =  p.y - p.x*m
	local b2 = circ.y - circ.x*invertM 
	local x = (b-b2)/(invertM-m)
	local y = x*m+b
	local isectRad = (x-circ.x)^2 + (y - circ.y)^2
	local halfbase = math.sqrt(circ.rad^2 - isectRad)
	local rightX = (x+m^2*x - halfbase*math.sqrt(m^2+1))/(1+m^2)
	local rightY = rightX*m+b
	if isectRad < circ.rad^2 and getHyp(pointer,circ) > circ.rad then
		local scale = circ.rad/math.sqrt(isectRad)
		local width = x-circ.x 
		local height = y-circ.y
		local newx = circ.x+width*scale
		local newy = circ.y+height*scale 
		local vectA = vector2d:new(p,pointer)
		local vectB = vector2d:new(p,circ)
		if #points > 1 then
			angle = angleBetweenVectors(vectA,vectB)
			print(angle)
			if angle > 0.01 then
				table.insert(points,cord2d:new(newx,newy))
			else
				table.remove(points,#points)
			end
		end
	end
end