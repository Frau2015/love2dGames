function getHyp(point, point2)
    local hyp = (point.x - point2.x)^2 + (point.y - point2.y)^2
    return math.sqrt(hyp)
end
function vectDotProd(vect,vect2)
    return (vect:getXDist() * vect2:getXDist()) + (vect:getYDist() * vect2:getYDist()) 
end
function angleBetweenVectors(vect,vect2)
    local dotProd = vectDotProd(vect,vect2)
    local vectLenProd = vect:getLen()*vect2:getLen()
    local cos = dotProd/vectLenProd
    return cos
end
-- this doesn't work LoL atleast in the computer cordinate system
function getAngleVect2(a,b)
    cross = function(v,v2)
        return v.x*v2.x + v.y*v2.y
    end
    dot = function(v,v2)
        return v.x*v2.y + v.y*v2.x
    end
    return math.atan2(cross(a,b),dot(a,b))
end