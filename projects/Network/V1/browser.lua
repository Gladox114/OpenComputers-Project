--function start()
component = require("component")
term = require("term")
modem = component.modem
event = require("event")
ip = 8887
--[[
local arg = {...}
if not arg[1] then
    print("Connent to which ip?")
    ip = io.read("*n")
else ip = tonumber(arg[1]) end
]]
m = modem.broadcast

modem.open(ip)
term.clear()
print([[
(Space) Open door (temp)
(J) Open door
(K) Close door
]])

e = {event.pull(1,"key_down")}

while true do
    while true do
        local e = {event.pull('key_down')}
        
        if e[4] == 57 then m(ip, 0x12) break
        elseif e[4] == 36 then m(ip, 0x10) break
        elseif e[4] == 37 then m(ip, 0x11) break
        elseif e[3] == 15 and e[4] == 24 then os.exit()
        end
    end

    local _, _, from, port, _, message = event.pull(10,"modem_message")
    if not message then 
        print("No Response") 
    else 
        if message == 1 then
            print("Open")
        elseif message == 0 then
           print("Closed") 
        elseif message == 2 then
            print("Opening Temporarly")
        end
        --print("Shutting down...")
        --os.shutdown() 
        os.sleep(0.4)
    end
    
end
--end