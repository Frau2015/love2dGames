function isOverlap(x1,y1,w,h,x2,y2,w2,h2)
    --[1] = x, [2] = y, [3] = length, [4] = height
    if x1 + w > x2  and x1 < x2 + w2 and y1 + h > y2 and y1 < y2 + h2 then
        return true
    else 
        return false
    end
end

function isOverlapObj(obj1,obj2)
    --if x1 + w > x2  and x1 < x2 + w2 and y1 + h > y2 and y1 < y2 + h2 then
    if obj1.x + obj1.w > obj2.x  and obj1.x < obj2.x + obj2.w and obj1.y + obj1.h > obj2.y and obj1.y < obj2.y + obj2.h then
        return true
    else 
        return false
    end
end

-- function checkBoundaries()
--     overlapping = false
--     for _, i in pairs(platformAry) do
--         if isOverlapObj(i,player) then
--             overlapping = true 
--             if player.gforce > player.vely and player.y+player.h - 10 < i.y and player.touchingFloor == false then
--                 player:groundPlayer()
--                 player.touchingFloor = true
--             end
--             if player.y > i.y then
--                     print('touching below the platform')
--                 player.touchingFloor = false
--             end
--         end
--     end
--     for _, i in pairs(worldObjs) do
--         if isOverlapObj(i,player) then
--             overlapping = true

--             if i.type =='floor' then
--                 if player.y < floor.y then
--                     player:groundPlayer()
--                     player.touchingFloor = true
--                 else
--                     player.touchingFloor = false
--                 end
--             end
--             if i.type =='spring' then
--                 if love.keyboard.isDown('up') and i.carrying == false then
--                     i.carrying = true
--                 end
--                 if player.jumping then
--                     player.vely = 8
--                 end
--             end
--             if i.type=='ladder' then
--                 player.touchingFloor = true
--                 if love.keyboard.isDown('up') then
--                     player.y = player.y - 1
--                 end
--             end
--         end
--         if i.carrying == true then
--             carryObj(i)
--         end
--     end
--     if not overlapping then
--         player.touchingFloor = false 
--     end
--     --print(overlapping)
-- end
