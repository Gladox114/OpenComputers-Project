local component = require("component")
local event = require("event")
local computer = require("computer")
local gpu = component.gpu
local y = 2
local arg = {...}

if energx then event.cancel(energx) energx=nil end

if arg[1] ~= "stop" then
    local function loop()
        x = gpu.getResolution()
        oldColor = gpu.getForeground()
--        if not event.pull(0,"key_down") then
            str = math.floor(computer.energy()/computer.maxEnergy()*100)

            if str >= 80 then color = 0x00FF00
            elseif str >= 60 then color = 0x66FF00
            elseif str >= 40 then color = 0xFFFF00
            elseif str >= 20 then color = 0xFF9200
            elseif str >= 0 then color = 0xFF0000 end

            gpu.setForeground(color)
            if str == 100 then 
                str = tostring(str)
            else 
                str = tostring(" "..str)
            end
            
            gpu.set(x-str:len()-1,y,str.."%")
            gpu.setForeground(oldColor)
        
--        end

    end
    loop()
    energx = event.timer(1,loop,math.huge)
end