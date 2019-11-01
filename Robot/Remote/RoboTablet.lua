--[[ OpenComputers Удалённое управление роботом by serafim
     http://pastebin.com/MY7qcets
 
с защитой от угона при помощи авторизации
программа для планшета или пк !
 
требования:
планшет первого уровня, карта wi-fi
 
Edited into english and added piston support -Gladox114
]]--
 
local comp = require("component")
local event = require("event")
local term = require("term")
local gpu = comp.gpu
 
local x_max, y_max = gpu.maxResolution()
local x_min, y_min = 2, 1
local full = false
local port = 123
 
if comp.isAvailable("modem") then
  modem = comp.modem
else
  print("No modem !")
  os.exit()
end
 
local function info()
term.clear()

--[[
1 Verbinden
E Abbauen                         Hoch
R Setzen
F Verwenden
X Turn 180°
C Farbe ändern                     Runter
T Items Aufnehmen
G Items Droppen
V Redstone Signal
Z Bildschirm Vergrößern/Verkleinern
Q Beenden

]]
print("\n".."\n"..[[
1 Connect
E Dick                         Hoch
R Place                        W    Space
F Use                         A D
X Turn 180°                    S    Runter
C Change Color                      LShift
T Pickup all Items
G Drop all Items
CTRL Piston Push    Arrow Down/Up
V Redstone Signal
Z Hide Screen
Q Quit
]])
end
 
local function link()
  term.clear()
  term.write("Pin ")
  io.write(">>")
  modem.broadcast(port,io.read())
  local e = {event.pull(1,'modem_message')}
  if e[6] == "false" then
    term.write("pin is not true !")
    os.sleep(1)
    term.clear()
    link()
  elseif e[6] == "true" then
    term.write("Connect !")
  else
    term.write("No Answer !")
  end
  os.sleep(1)
end
 
modem.open(port)
link()
info()
 
while true do
  local e = {event.pull('key_down')}
  modem.broadcast(port, e[4])
  term.setCursor(1,1)
  term.clearLine()
  term.write(e[4])
  if e[4] == 44 then
    full = not full
    if full then
      gpu.setResolution(x_min,y_min)
    else
      gpu.setResolution(x_max,y_max)
      info()
    end
  elseif e[4] == 16 then
    gpu.setResolution(x_max,y_max)
    term.write("  Exit")
    os.sleep(1)
    term.clear()
    os.exit()
  elseif e[4] == 2 then
    link()
    info()
  end
end