-- # Open source GUI made by Gladox114
-- # github.com/Gladox114
-- # https://github.com/Gladox114/OpenComputers-Project/tree/master/projects/Network/V3

local GUI = require("GUI")
local buffer = require("doubleBuffering")
local term = require("term")
local c = require("component")
local m = c.modem
local color1,color2 = 0x2D2D2D,0xC3C3C3--0xC3C3C3,0xA5A5A5
local ip = 8887

local function confRead()
local file = io.open("config.txt","r")
if file then
    IP = file:read()
    ip = IP
    file:close()
end
end
confRead()
--------------------------------------------------------------------------------

local label_top = "Enrichment Center Control Tablet"

local application = GUI.application()

-- Event handler
application.eventHandler = function(application,object,e1,e2,e3,e4)
    if e1 == "key_down" then
        if e3 == 15 and e4 == 24 then
            application:addChild(GUI.panel(1, 1, application.width, application.height, 0x000000))
            application:draw()
            application:stop() -- # new method i didn't saw
        elseif e4 == 57 then 
            m(ip, 0x12)
        elseif e4 == 36 then
            m(ip, 0x10)
        elseif e4 == 37 then
            m(ip, 0x11)
        end
    end
end

-- Add a panel
application:addChild(GUI.panel(1, 1, application.width, application.height, color1))
application:addChild(GUI.panel(application.width/2-label_top:len()/2-1,2, label_top:len()+2, 3, color2))

-- Add a Label
application:addChild(GUI.text( application.width/2-label_top:len()/2 , 3 , 0xFF0000, label_top ))

------ Settings -----
-- Add a button to application and .onTouch() method
application:addChild(GUI.button(1, 1, 10, 3, 0xE1E1E1, 0x4B4B4B, color2, 0x0, "Settings")).onTouch = function()

    -- Add a container to application
    local container = application:addChild(GUI.container(1, 1, application.width, application.height))
    -- Add a panel with onTouch() method to container 
    container.panel = container:addChild(GUI.panel(1, 1, container.width, container.height, GUI.BACKGROUND_CONTAINER_PANEL_COLOR, GUI.BACKGROUND_CONTAINER_PANEL_TRANSPARENCY))
    container.panel.eventHandler = function(application, object, e1)
        if e1 == "touch" then
            container:remove()
            application:draw()
        end
    end
    -- Add a layout to container
    container.layout = container:addChild(GUI.layout(1, 1, container.width, container.height, 1, 1))
    -- Add a label to layout
    container.label = container.layout:addChild(GUI.label(1, 1, 1, 1, GUI.BACKGROUND_CONTAINER_TITLE_COLOR, "Settings")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)
    
    -- Add a input field to layout
    local textfield = container.layout:addChild(GUI.input(1, 1, 30, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, newIP or IP or "" , "Input IP", false))
    -- Add a button to layout
    container.layout:addChild(GUI.button(1,3,10,3,0xA5A5A5,0xFFFFFF, 0x696969, 0xFFFFFF,"OK")).onTouch = function()
        newIP = textfield.text
        local config = io.open("config.txt","w")
        config:write(newIP)
        config:close()
        confRead()
        container:remove()
        application:draw()
    end
end

--------------------------------------------------------------------------------

application:draw(true)
application:start()