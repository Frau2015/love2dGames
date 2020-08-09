function pickRandom(ary)
    math.randomseed(os.time())
    return ary[math.random(1,#ary)]
end
function isOverlap(x1,y1,w,h,x2,y2,w2,h2)
	--[1] = x, [2] = y, [3] = length, [4] = height
	if x1 + w > x2  and x1 < x2 + w2 and y1 + h > y2 and y1 < y2 + h2 then
		return true
	else 
		return false
	end
end
function inBounds(x,y)
    if x >= 1 and x <= boardSize and y >= 1 and y <= boardSize then
        return true
    end
    return false
end
function get1DIndex(x,y)
    local i = x+(y-1)*boardSize
    return i
end