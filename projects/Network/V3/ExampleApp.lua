local GUI = require("GUI")
local term = require("term")

--------------------------------------------------------------------------------

local application = GUI.application()

-- Event handler
application.eventHandler = function(application,object,e1,e2,e3,e4)
    if e1 == "key_down" then
        if e3 == 15 and e4 == 24 then -- #That one is Nice because it's the way i found out to close the application with ctrl+O
            application:addChild(GUI.panel(1, 1, application.width, application.height, 0x000000))
            application:draw()
            os.exit()
        elseif e4 == 57 then -- #some keys like SPACE to execute code.
            --code
        elseif e4 == 36 then
            --code
        elseif e4 == 37 then
            --code
        end
    end
end


local label_top = "Enrichment Center Control Tablet"

-- Add a panel
application:addChild(GUI.panel(1, 1, application.width, application.height, 0xC3C3C3))
application:addChild(GUI.panel(application.width/2-label_top:len()/2-1,2, label_top:len()+2, 3, 0xA5A5A5))

-- Add a Label
application:addChild(GUI.text( application.width/2-label_top:len()/2 , 3 , 0xFF0000, label_top ))


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

--------------------------------------------------------------------------------

application:draw(true)
application:start()