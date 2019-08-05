-- Farming drone originally by DrManganese ( https://github.com/DrManganese/OpenComputers-Projects/blob/master/Farming%20Drone/farm.lua )
-- Modified by nzHook http://youtube.com/nzhook
-- Modified by Gladox114 (https://github.com/Gladox114/My-Programs/blob/master/Modified/farm.lua)
local drone = component.proxy(component.list("drone")()) local nav = component.proxy(component.list("navigation")()) local baseSleep = 5 local waypointLookRadius = 64 local colours = {["travelling"] = 0xFFFFFF, ["farming"] = 0x332400, ["waiting"] = 0x0092FF, ["dropping"] = 0x33B640} local cx, cy, cz local BASE local DROPOFF local FARMROWs function getWaypoints() BASE, DROPOFF, FARMROWs = {}, {}, {} cx, cy, cz = 0, 0, 0 local waypoints = nav.findWaypoints(waypointLookRadius) for i=1, waypoints.n do if waypoints[i].label == "FARMBASE" then BASE.x = waypoints[i].position[1] BASE.y = waypoints[i].position[2] BASE.z = waypoints[i].position[3] elseif waypoints[i].label == "DROPOFF" then DROPOFF.x = waypoints[i].position[1] DROPOFF.y = waypoints[i].position[2] DROPOFF.z = waypoints[i].position[3] elseif waypoints[i].label:find("FARMROW") == 1 then local tempTable = {} tempTable.x = waypoints[i].position[1] tempTable.y = waypoints[i].position[2] tempTable.z = waypoints[i].position[3] tempTable.len = waypoints[i].label:match("LEN(%d+)") tempTable.r = waypoints[i].label:match("R(%d+)") table.insert(FARMROWs, tempTable) end end end function colour(state) drone.setLightColor(colours[state] or 0x000000) end function move(tx, ty, tz) local dx = tx - cx local dy = ty - cy local dz = tz - cz drone.move(dx, dy, dz) while drone.getOffset() > 0.7 or drone.getVelocity() > 0.7 do computer.pullSignal(0.2) end cx, cy, cz = tx, ty, tz end function getCharge() return computer.energy()/computer.maxEnergy() end function waitAtBase() colour("travelling") move(BASE.x, BASE.y+1, BASE.z) colour("waiting") while getCharge() < 0.8 do computer.pullSignal(1) end computer.beep(783.99) computer.pullSignal(.25) computer.beep(783.99) computer.pullSignal(.25) computer.beep(783.99) computer.beep(659.25) computer.beep(1046.5) end function findCrop() for i=2, 5 do local isBlock, type = drone.detect(i) if type == "passable" then return i end end end function farm() for i=1, #FARMROWs do local row = FARMROWs[i] colour("travelling") move(row.x, row.y, row.z) colour("farming") local direction = findCrop() local l, r, tx, tz if direction == 2 then l,r,tx,tz,ttx,ttz = 4,5,0,-1,1,0 end if direction == 3 then l,r,tx,tz,ttx,ttz = 5,4,0,1,-1,0 end if direction == 4 then l,r,tx,tz,ttx,ttz = 3,2,-1,0,0,-1 end if direction == 5 then l,r,tx,tz,ttx,ttz = 2,3,1,0,0,1 end for x=0, row.r do move(row.x+3*x*ttx, row.y, row.z+3*x*ttz) drone.use(direction) for i=1, row.len do move(cx+tx, cy, cz+tz) colour("farming") drone.use(l) drone.use(r) if i < tonumber(row.len) then drone.use(direction) end end if drone.count(drone.inventorySize()) >= 1 then dropoff() end if getCharge() < 0.8 then waitAtBase() end end end end function dropoff() local havesome = false for i=1, drone.inventorySize() do if drone.count(i) > 0 then havesome = true end end if not havesome then return end colour("travelling") move(DROPOFF.x, DROPOFF.y+1, DROPOFF.z) colour("dropping") for i=drone.inventorySize(),1,-1 do drone.select(i) drone.drop(0, 64) computer.pullSignal(1) end end function init() getWaypoints() waitAtBase() while true do farm() dropoff() if getCharge() < 0.8 then getWaypoints() waitAtBase() end end end init()