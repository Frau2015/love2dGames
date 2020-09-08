function rectCol(rect1,rect2)
	if rect1.x < rect2.x + rect2.w and rect1.x + rect1.w > rect2.x and rect1.y < rect2.y + rect2.h and rect1.y + rect1.h > rect2.y then
		return true
	end
	return false
end

function circCol(circ1,circ2) 
	if (circ1.x - circ2.x)^2 + (circ1.y - circ2.y)^2 < (circ1.rad + circ2.rad)^2 then
		return true
	end
	return false
end
