--[[
component = require("component")
modem = require("modem")
rs = component.redstone
event = require("event")
ip = 8887
side = 4

modem.open(ip)

--while true do
local _,_, From, port, _, message = event.pull("modem_message")
print(message)
x = message:find " "
command = message:sub(0,x)
clock = message:sub(x,-0)

if clock > os.clock() and os.clock()+0.1 > clock then
    if command = 0x10 then
        rs.setOuput(side,15)
        modem.send(from, ip, 1)
    elseif command 0x20 then
        rs.setOutput(side, 0)
        modem.send(from, ip, 0)
    elseif command 0x30 then
        local Input = rs.getInput()
        modem.send(from, ip, Input)
    end
end

--end
]]


component = require("component")
modem = component.modem
rs = component.redstone
event = require("event")
term = require("term")

ip = 8887
side = 5
closedown = 5

modem.open(ip)
term.clear()

function close()
    rs.setOutput(side, 0)
end

while true do
    while true do
        _,_, from, port, _, message = event.pull(1,"modem_message")
        if message then break end
    end
print(from, message)
command = message

if command == 0x10 then
    rs.setOutput(side, 15)
    print(from.." OK")
    modem.send(from, ip, 1)
elseif command == 0x11 then
    rs.setOutput(side, 0)
    print(from.." OK")
    modem.send(from, ip, 0)
elseif command == 0x12 then
    rs.setOutput(side, 15)
    print(from.." OK")
    modem.send(from, ip, 2)
    timex = event.timer(closedown, close, 1)
--elseif command 0x30 then
--    local Input = rs.getInput()
--    modem.send(from, ip, Input)
end

os.sleep(0.1)
end