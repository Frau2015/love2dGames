delay = {}
delay.max  = 0
delay.current = 0
function delay:new(x)
    o = {}
    o.max = x
    o.current = 0
    setmetatable(o,{__index=self})
    return o
end
function delay:run(dt)
    self.current = self.current + dt
end
function delay:check()
    if  self.current >= self.max then
        return false
    else
        return true
    end
end