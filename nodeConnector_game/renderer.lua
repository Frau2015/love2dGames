function createRenderer(spools,cables) 
	this = {}
	this.cables = cables
	this.spools = spools
	this._pickSpoolColor = function(spool)
		color = {0,0,0}
		if spool.isAttached then 
			color = {1,0,0}
		end
		if spool.type == "endNode" then
			color = {0,1,1}
		end
		return color
	end
	this._drawSpools = function(spools)
		love.graphics.setColor(0,0,0)
		for i,spool in pairs(spools) do
			local drawType = (i == 1 or spool.type == "endNode") and 'fill' or 'line'
			color = this._pickSpoolColor(spool)
			gfx.setColor(color[1],color[2],color[3])
			gfx.circle(drawType,spool.x,spool.y,spool.rad)
			gfx.setColor(0,0,0)
		end
	end
	this._drawCables = function(cables)
		for i=1,#cables-1 do
			local a = cables[i]
			local b = cables[i+1]
			-- print(a.overlapped)
			local color = {0,0,0}
			--if a.overlapped and b.overlapped then
			local color = (a.overlapped) and {0,1,0} or {0,0,0}
			gfx.setColor(color[1],color[2],color[3])
			gfx.line(a.outPos.x,a.outPos.y,b.inPos.x,b.inPos.y)
		end
	end
	this.draw = function ()
		this._drawCables(this.cables)
		this._drawSpools(this.spools)
	end	
	return this
end