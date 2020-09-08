function whichSide(v1,v2,v3)
	-- direction = crossProductScalar(v1,v2,v3) > 0 and 'right' or 'left'
	return crossProductScalar(v1,v2,v3) < 0 and 'right' or 'left'
end
function updateAngle(cables)
	function subV(v,v2)
		return shapelib.vect2:new(v.x-v2.x,v.y-v2.y)
	end
	for i=2,#cables-1 do
		local a = cables[i-1]
		local b = cables[i]
		local c = cables[i+1]
		local vAB = subV(a.outPos,b.inPos)
		local vBC = subV(b.outPos,c.inPos)
		local teta = math.atan2(vBC.y,vBC.x) - math.atan2(vAB.y,vAB.x)
		if teta < 0 then
			teta = teta + math.pi*2
		end
		angle = math.deg(teta)
	end
end
function updateCableTangents(cables)
	determineIdx = function (a,b)
		if a.side == 'left' and b.side == 'right' then
			return 4
		elseif a.side == 'right' and b.side == 'left' then
			return 3
		elseif a.side =='left' and b.side == 'left' then
			return 2
		end
		return 1
	end
	local idx = 1
	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		local tangents = getTangents(a.spool,a.spool.rad,b.spool,b.spool.rad)
		idx = determineIdx(a,b)
		if #tangents > 0 then
			a.outPos = tangents[idx][0]
			b.inPos = tangents[idx][1]
		end
	end
end