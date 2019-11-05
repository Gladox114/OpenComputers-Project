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
end
file:close()
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
            os.exit()
        elseif e4 == 57 then 
            m(ip, 0x12)
        elseif e4 == 36 then
            m(ip, 0x10)
        elseif e4 == 37 then
            m(ip, 0x11)
        end
    end
end
--[[
function settings()

    local application2 = GUI.application(application.width/2-20,application.height/2-4,40,8)

    local oldPixels = buffer.copy(application2.x, application2.y, application2.width, application2.height)

    local textfield = application2:addChild(GUI.input(2,2,30,3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", "Input IP", false))

    application2:addChild(GUI.button(1,3,36,3,0xA5A5A5,0xFFFFFF, 0x696969, 0xFFFFFF,"OK")).onTouch = function()
        IP = textfield.text
        application2:stop()
        buffer.paste(application2.x, application2.y, oldPixels)
		buffer.drawChanges()
    end 
end
]]

-- Add a panel
application:addChild(GUI.panel(1, 1, application.width, application.height, color1))
application:addChild(GUI.panel(application.width/2-label_top:len()/2-1,2, label_top:len()+2, 3, color2))

-- Add a Label
application:addChild(GUI.text( application.width/2-label_top:len()/2 , 3 , 0xFF0000, label_top ))

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
 
    -- Add a background container to application with background panel and layout
    --local container = GUI.addBackgroundContainer(application, true, true, "Settings")
    -- Add a switch and label to it's layout
    --container.layout:addChild(GUI.switchAndLabel(1, 1, 36, 8, 0x66DB80, 0x2D2D2D, 0xE1E1E1, 0x878787, "I like to suck big dicks:", true))

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






--[[
-- Add a regular button
local regularButton = application:addChild(GUI.button(2, 2, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Regular button"))
regularButton.onTouch = function()
	GUI.alert("Regular button was pressed")
end

-- Add a regular button with disabled state
local disabledButton = application:addChild(GUI.button(2, 6, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Disabled button"))
disabledButton.disabled = true

-- Add a regular button with switchMode state
local switchButton = application:addChild(GUI.button(2, 10, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Switch button"))
switchButton.switchMode = true
switchButton.onTouch = function()
	GUI.alert("Switch button was pressed")
end

-- Add a regular button with disabled animation
local notAnimatedButton = application:addChild(GUI.button(2, 14, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Not animated button"))
notAnimatedButton.animated = false
notAnimatedButton.onTouch = function()
	GUI.alert("Not animated button was pressed")
end

-- Add a rounded button
application:addChild(GUI.roundedButton(2, 18, 30, 3, 0xFFFFFF, 0x555555, 0x880000, 0xFFFFFF, "Rounded button")).onTouch = function()
	GUI.alert("Rounded button was pressed")
end

-- Add a framed button
application:addChild(GUI.framedButton(2, 22, 30, 3, 0xFFFFFF, 0xFFFFFF, 0x880000, 0x880000, "Framed button")).onTouch = function()
	GUI.alert("Framed button was pressed")
end
]]
--------------------------------------------------------------------------------

application:draw(true)
application:start()