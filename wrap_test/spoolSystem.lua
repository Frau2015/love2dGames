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
			a.outPos = tangents[idx][1]
			b.inPos = tangents[idx][2]
		else
			print('could not set value')
		end
	end
end
function getIntersected(outPos,inPos,ignoreA,ignoreB,spools)
	for _, spool in pairs(spools) do
		local tangents = getTangents(inPos,ignoreB.rad,spool,spool.rad)
		if spool ~= ignoreA and spool ~= ignoreB and (not spool.isAttached) and lineCircleIntersect(outPos,inPos,spool) then
			-- if #tangents == 4 then
			if math.sqrt(distSqr(spool,ignoreB)) > (spool.rad+ignoreB.rad) then
			-- if distSqr(spool,ignoreA)^0.5 > (spool.rad^2+ignoreA.rad^2)^0.5 +1 and distSqr(spool,ignoreB)^0.5 > (spool.rad^2+ignoreB.rad^2)^0.5+1 then
				return spool
			-- end
			else 
				print('node is inside cannot attach')
			end
		end
	end
	return nil
end

function determineIdx(a,b)
		if a.side == 'left' and b.side == 'right' then
			return 4
		elseif a.side == 'right' and b.side == 'left' then
			return 3
		elseif a.side =='left' and b.side == 'left' then
			return 2
		end
		return 1
end
-- don't insert if there is not tangents
function createSuitableAttachments2(spools,cables)
	local repeatCount = 0
	repeat
		local attached = false
		for i=1,#cables-1 do
			local a = cables[i]
			local b = cables[i+1]
			-- print('..')
			local tangents = getTangents(a.spool,a.spool.rad,b.spool,b.spool.rad)
			idx = determineIdx(a,b)
				--print(a.spool.rad)
			print('num of tans ' .. #tangents)
			print('num of cables ' .. #cables)
			--print('First data ' .. i .. ' set: '.. a.outPos.x .. ' ' .. b.inPos.x)
			-- only 2 tangets if overlapping, and 4 for not overlapping
			if #tangents == 4 then
				a.outPos = tangents[idx][1]
				b.inPos = tangents[idx][2]
				print('First data ' .. i .. ' set: '.. a.outPos.x .. ' ' .. b.inPos.x)
				local spl = getIntersected(a.outPos,b.inPos,a.spool,b.spool,spools) --print(spl)
				if spl then
					spl.isAttached = true
					local side = whichSide(a.outPos,spl,b.inPos)
					print(side)
					local newCable = cable:new(spl, side)
					table.insert(cables,#cables,newCable)
					print('Inserted ' .. i .. ' set: '.. a.outPos.x .. ' ' .. b.inPos.x)
					attached = true
					break
				end
			end
		end
		print('repeated ' ..repeatCount .. ' times')
		repeatCount = repeatCount + 1
	until(not attached)
end
function createSuitableAttachments(spools,cables)
	local overlapped = false
	local LastCable = cables[#cables]
	local SecondLastCable = cables[#cables-1]

	for i=1,#cables-1 do
		local a = cables[i]
		local b = cables[i+1]
		local spl = getIntersected(a.outPos,b.inPos,a.spool,b.spool,spools)
		-- print('..')
		if spl and not a.overlapped and not b.overlapped then
			--print(spl)
			spl.isAttached = true
			local side = whichSide(a.spool,b.spool,spl) local newCable = cable:new(spl,side)
			newCable.side = whichSide(a.outPos,newCable.spool,b.inPos)
			table.insert(cables,#cables,newCable)
			updateCableTangents(cables)
			LastCable = cables[#cables]
			SecondLastCable = cables[#cables-1]
		end
		a.overlapped = false
		b.overlapped = false
		-- if (#cables > 2) and i < #cables-1 then
		-- 	-- print('inPos ' .. tostring(SecondLastCable.inPos.x) )
		-- 	-- print('outPos ' .. tostring(SecondLastCable.outPos.x))
		-- 	if lineLineIntersect(cables[i].outPos, cables[i+1].inPos,SecondLastCable.outPos,LastCable.inPos) then
		-- 		overlapped = true
		-- 	end
		-- end
		-- print(cables[2].inPos.x)
	end
	if overlapped then
		LastCable.overlapped = true
		SecondLastCable.overlapped = true
	end
end
function removeDisconnected(spools,cables)
	updateAngle(cables)
	if #cables > 2 then
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
	-- updateCableTangents(self.cables)
	createSuitableAttachments2(self.spools,self.cables)
	removeDisconnected(self.spools,self.cables)
end
return spoolSystem