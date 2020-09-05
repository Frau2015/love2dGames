require 'cable'
require 'math_lib'
local shapelib = require('rigidShapes')

class = require('middleclass/middleclass')
local angle = 0 
spoolSystem = class('spoolSystem')
function spoolSystem:init(spools,cables)
    self.spools = spools
	self.cables = cables
	self.numofAttached = 0
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
			--print('updated value ' .. i)
		else
			--print('could not set value')
		end
	end
end
function getIntersected(outPos,inPos,ignoreA,ignoreB,spools)
	-- local possibleSpools = {}
	for _, spool in pairs(spools) do
		if spool.type == 'node' and spool ~= ignoreA and spool ~= ignoreB and lineCircleIntersect(outPos,inPos,spool) and (not spool.isAttached)then
			if distSqr(spool,ignoreA) > (spool.rad+ignoreA.rad)^2 and distSqr(spool,ignoreB) > (spool.rad + ignoreB.rad)^2 then
				return spool
				-- table.insert(possibleSpool,spool)
			end
		end
	end
	return nil
	-- return possibleSpools[1]
end
-- don't insert if there is not tangents
function createSuitableAttachments(spools,cables)
	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		local spl = getIntersected(a.outPos,b.inPos,a.spool,b.spool,spools)
		if spl then
			-- print('inserted ' .. i)
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
			if spool == lastspool then 
				if (lastcable.side == 'left' and angle > 320) or (lastcable.side == 'right' and angle < 20) then
					spools[i].isAttached = false
					table.remove(cables,#cables-1)
				end
			end
		end
	end
end
function spoolSystem:getNumofAttached()
	return self.numofAttached
end
function spoolSystem:update()
	updateCableTangents(self.cables)
	createSuitableAttachments(self.spools,self.cables)
	removeDisconnected(self.spools,self.cables)
	local attachedCount = 0
	local endNode = nil
	for _, cable in pairs(self.cables) do
		cable.overlapped = false
	end
	for _, spool in pairs(self.spools) do 
		if spool.isAttached  then 
			attachedCount = attachedCount + 1 
		end
		if spool.type == 'endNode' then 
			print('found endnode')
			endNode = spool 
		end
	end
	print(attachedCount)
	self.numofAttached = attachedCount
	local anyOverlapped = false
	for i=1,#self.cables-1 do
		local a = self.cables[i]
		local b = self.cables[i+1]
		for j=1,#self.cables-1 do
			local a2 = self.cables[j]
			local b2 = self.cables[j+1]
			if lineLineIntersect(a.outPos,b.inPos,a2.outPos,b2.inPos) then
				a2.overlapped = true
				b2.overlapped = true
				anyOverlapped = true
			end
		end
	end
	-- print(string.format('pointer cord x: %d y:%d ',self.pointer.x,self.pointer.y))
	local pointer = self.cables[#self.cables].spool
	if endNode then
		if distSqr(pointer,endNode) <= endNode.rad^2 then
			pointer.x = endNode.x
			pointer.y = endNode.y
			attachedCount = attachedCount + 1
		end
	end
	if (not anyOverlapped) and attachedCount == #self.spools then
		print('game is won')
	end
end
return spoolSystem