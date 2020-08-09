piece = {}
piece.x = 0
piece.y = 0
piece.capture_pathLen = 0
piece.capture_dir = 1
function piece:new(x,y)
    o = {}
    o.x = x
    o.y = y
    setmetatable(o,{__index=self})
    return o
end
function piece:setCapture_PathLen(x)
    self.capture_pathLen = x
end
function piece:setCapture_Dir(x)
    self.capture_dir = x
end