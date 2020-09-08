function crossProductScalar(a,b,c)
    --b is the center, a,b,c are 2d cordinates
   -- return (vect1.x*vect2.y) - (v1.y*v2.x)
    return (a.x-b.x)*(c.y - b.y) - (a.y-b.y)*(c.x-b.x)
end
function isLeft(a,b,c)
    return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) < 0;
end