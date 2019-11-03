local event = require("event")
local interface = require("interface")
local term = require("term")
local c = require("component")
local gpu = c.gpu
local x,y = gpu.getResolution()
local m = c.modem.broadcast
local ip = 8887
local Label = "Enrichment Center Control Tablet"
local message = " "
local color1,color2,color3,color4 = --[[0xC3C3C3]]0xFFFFFF,0x2D2D2D,0x00B600,0xC3C3C3
local count = 0
local timeoutcheck = false
c.modem.open(ip)
z = (x-Label:len()+2)/2


function open()
    m(ip,0x12)
    --timeoutcheck = true
end

function toggle()
    if toggled then
        m(ip,0x10)
        toggled = nil
        --timeoutcheck = true
    else
        m(ip,0x11)
        toggled = 1
        --timeoutcheck = true
    end
end


function screen()
    interface.clearAllObjects()
    interface.newLabel("0","",1,1,x,y,color1)
    interface.newLabel("1",Label,z,3,Label:len()+2,3,color2)
    interface.newLabel("2","Terminal message:",6,23,19,3,color2)
    interface.newLabel("3","  ",25,23,20,3,color2) --20
    interface.newButton("5","Open",33,13,6,3,open,nil,color3,color2,0)
    interface.newButton("6","Toggle",41,13,8,3,toggle,nil,color3,color2,1)
    interface.updateAll()
end

screen()



while true do
    local type,_,x,y, _, message = event.pullMultiple(1,"touch","key_down","modem_message")
--[[
    if timeoutcheck == true then
        interface.setLabelText("3",tostring(count))
        if message == " " and count < 4 then
            interface.setLabelText("3",tostring(count))
            count = count + 1
        elseif message == " " and count >= 4 then
            message = "no response"
            interface.setLabelText("3",tostring(message))
            count = 0
        elseif message ~= " " then 
            message = " " 
            interface.setLabelText("3",tostring(message))
            timeoutcheck = false
        end
    end
]]
    if type == "touch" then
        interface.processClick(x,y)
    elseif type == "key_down" then
        if x == 15 and y == 24 then
            term.clear()
            os.exit()
        end
    elseif type == "modem_message" then
        if message == 1 then
            message = "Open"
        elseif message == 0 then
            message = "Closed"
        elseif message == 2 then
            message = "Opening Temporarly"
        end
        interface.setLabelText("3",tostring(message))
    end
end