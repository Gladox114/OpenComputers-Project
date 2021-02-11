component = require("component")
computer = require("computer")
unicode = require("unicode")
bit32 = require("bit32")


local bootFilesystemProxy = component.proxy(component.proxy(component.list("eeprom")()).getData())

GPUProxy = component.proxy(component.list("gpu")())
local screenWidth, screenHeight = GPUProxy.getResolution()

requireExists = function(variant)
  return filesystem.exists(variant)
end

-- Loading libraries
bit32 = bit32 or require("Bit32")
paths = require("Paths")
event = require("Event")
filesystem = require("Filesystem")

filesystem.setProxy(bootFilesystemProxy)

-- Loading other libraries
require("Component")
require("Keyboard")
require("Color")
require("Text")
require("Number")
image = require("Image")
screen = require("Screen")
bigletters = require("BigLetters")

-- Setting currently chosen GPU component as screen buffer main one
screen.setGPUProxy(GPUProxy)

GUI = require("GUI")
system = require("System")
require("Network")
--[[
-- Filling package.loaded with default global variables for OpenOS bitches
package.loaded.bit32 = bit32
package.loaded.computer = computer
package.loaded.component = component
package.loaded.unicode = unicode
]]

local workspace = GUI.workspace()
system.setWorkspace(workspace)

system.authorize()
