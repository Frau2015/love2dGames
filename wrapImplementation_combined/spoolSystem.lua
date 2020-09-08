require 'cable'
require 'math_lib'
local shapelib = require('rigidShapes')

class = require('middleclass/middleclass')
local angle = 0 
spoolSystem = class('spoolSystem')
function spoolSystem:init(spools,cables)
    self.spools = spools
	self.cables = cables
end
function spoolSystem:getAngle()
	return angle
end
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
		if a.side == 'left' and b.side == 'right' then return 4
		elseif a.side == 'right' and b.side == 'left' then return 3
		elseif a.side =='left' and b.side == 'left' then return 2 end
		return 1
	end
	local idx = 1
	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		local tangents = getTangents(a.spool,a.spool.rad,b.spool,b.spool.rad)
		idx = determineIdx(a,b)
		if tangents[idx] then
			a.outPos = tangents[idx][1]
			b.inPos = tangents[idx][2]
			print('updated value ' .. i)
		else
			print('could not set value')
		end
	end
end
function getIntersected(outPos,inPos,ignoreA,ignoreB,spools)
	for _, spool in pairs(spools) do
		--local tangents = getTangents(inPos,ignoreB.rad,spool,spool.rad)
		if spool ~= ignoreA and spool ~= ignoreB and lineCircleIntersect(outPos,inPos,spool) and (not spool.isAttached)then
			if distSqr(spool,ignoreA) > (spool.rad+ignoreA.rad)^2 and distSqr(spool,ignoreB) > (spool.rad + ignoreB.rad)^2 then
		--if spool ~= ignoreA and spool ~= ignoreB and (not spool.isAttached) and lineCircleIntersect(outPos,inPos,spool) then
			--if #tangents == 4 then
				return spool
			end
		end
	end
	return nil
end
-- don't insert if there is not tangents
function createSuitableAttachments(spools,cables)

	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		local spl = getIntersected(a.outPos,b.inPos,a.spool,b.spool,spools)
		-- print('..')
		if spl then
			print('inserted ' .. i)
			--print(spl)
			spl.isAttached = true
			local side = whichSide(a.outPos,spl,b.inPos)
			local newCable = cable:new(spl,side)
			table.insert(cables,#cables,newCable)
			updateCableTangents(cables)
		end
	end
end
function removeDisconnected(spools,cables)
	if #cables > 2 then
		updateAngle(cables)
		local lastspool = cables[#cables-1].spool 
		local lastcable = cables[#cables-1]
		for i, spool in pairs(spools) do
			-- print(spool == lastspool)
			if spool == lastspool then 
				if (lastcable.side == 'left' and angle > 320) or (lastcable.side == 'right' and angle < 20) then
					-- print(lastcable.side)
					spools[i].isAttached = false
					table.remove(cables,#cables-1)
				end
				-- print(angle)
			end
		end
	end
end
function spoolSystem:update()
	updateCableTangents(self.cables)
	createSuitableAttachments(self.spools,self.cables)
	removeDisconnected(self.spools,self.cables)
end
return spoolSystem