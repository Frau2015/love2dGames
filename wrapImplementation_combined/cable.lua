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