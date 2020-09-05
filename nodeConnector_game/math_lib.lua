--vector rad, vect rad
function getTangents(p1,r1,p2,r2)
	local d_sq = (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);

    if (d_sq <= (r1 - r2) * (r1 - r2)) then return {} end

    local d = math.sqrt(d_sq);
    local vx = (p2.x - p1.x) / d;
    local vy = (p2.y - p1.y) / d;

    -- double[][] res = new double[4][4];
	local result = {};
	local i = 1;
	for sign1 = 1,-1, -2 do
    	local c = (r1 - sign1 * r2) / d
		local continue = true
        -- Now we're just intersecting a line with a circle: v*n=c, n*n=1
		if (c * c > 1.0) then 
			continue = false
		end
		if continue then
			local h = math.sqrt(math.max(0.0, 1.0 - c * c));
			for	sign2 = 1,-1, -2 do
				local nx = vx * c - sign2 * h * vy;
				local ny = vy * c + sign2 * h * vx;
				result[i] = {};
				local a = result[i]
				a[1] = {x=(p1.x + r1 * nx), y=(p1.y + r1 * ny)};
				a[2] = {x=(p2.x + sign1 * r2 * nx), y=(p2.y + sign1 * r2 * ny)};
				i = i + 1
			end
		end
    end
    return result
end
function lineLineIntersect(line1a, line1b, line2a, line2b) 
    -- var s1_x, s1_y, s2_x, s2_y;
    local s1_x = line1b.x - line1a.x;
    local s1_y = line1b.y - line1a.y;
    local s2_x = line2b.x - line2a.x;
    local s2_y = line2b.y - line2a.y;

    -- var s, t;
    local s = (-s1_y * (line1a.x - line2a.x) + s1_x * (line1a.y - line2a.y)) / (-s2_x * s1_y + s1_x * s2_y);
    local t = (s2_x * (line1a.y - line2a.y) - s2_y * (line1a.x - line2a.x)) / (-s2_x * s1_y + s1_x * s2_y);

    return s >= 0 and s <= 1 and t >= 0 and t <= 1;
end


function lineCircleIntersect(lineA,lineB,circle)
	local dist = 0;
	local radius = circle.rad
    local v1x = lineB.x - lineA.x;
    local v1y = lineB.y - lineA.y;
    local v2x = circle.x - lineA.x;
    local v2y = circle.y - lineA.y;
    -- get the unit distance along the line of the closest point to
    -- circle center
    local u = (v2x * v1x + v2y * v1y) / (v1y * v1y + v1x * v1x);

    -- if the point is on the line segment get the distance squared
    -- from that point to the circle center
    if (u >= 0 and u <= 1) then
        dist = (lineA.x + v1x * u - circle.x)^2 + (lineA.y + v1y * u - circle.y)^2;
    else
        -- if closest point not on the line segment
        -- use the unit distance to determine which end is closest
        -- and get dist square to circle
        dist = u < 0 and
            (lineA.x - circle.x)^2 + (lineA.y - circle.y)^2 or
            (lineB.x - circle.x)^2 + (lineB.y - circle.y)^2
	end
    return dist < radius * radius;
end

function distSqr(p1,p2)
	return (p1.x - p2.x)^2 + (p1.y - p2.y)^2
end