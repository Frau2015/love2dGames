class = require('middleclass/middleclass')
cable = class('cable')
cable.inPos = nil
cable.outPos = nil
cable.side = 'left'
function cable:init(spool,side)
	self.spool = spool
	self.side = side
	self.overlapped = false
end
spool = class('spool',circle2d)
spool.isAttached = false
function spool:init(x,y,rad)
	circle2d.init(self,x,y,rad)
	self.type = "node"
end