--[[ OpenComputers Удалённое управление роботом by serafim
     http://pastebin.com/g8NCXBeY
с защитой от угона при помощи авторизации
программа для робота !

требования:
робот первого уровня,
карта wi-fi, контроллер редстоуна

использование:
запустить, на экране появится pin код,
ввести на планшете.

Edited into english and added piston support -Gladox114
]]--

local comp = require("component")
local event = require("event")
local sides = require("sides")
local user,redstate = false,false
local pin = tostring(math.random(100,999))
local port = 123

if not comp.isAvailable("robot") then
  print("Only robots can use this program")
  os.exit()
end
local r = require("robot")

if comp.isAvailable("modem") then
  modem = comp.modem
else
  print("No modem !")
  os.exit()
end
if comp.isAvailable("piston") then
    piston = comp.piston
    pist = true
end

modem.open(port)

if comp.isAvailable("redstone") then
  rs = comp.redstone
  red = true
end

local actions = {
[17] = r.forward,
[31] = r.back,
[32] = r.turnRight,
[30] = r.turnLeft,
[57] = r.up,
[29] = r.down,
[18] = r.swing,
[33] = r.use,
[19] = r.place,
[45] = r.turnAround,
[42] = piston.push
}

function authoriz(pin)
  local _,_,kard,_,_,key = event.pull("modem_message")
  if pin == key then
    modem.broadcast(port,"true")
    return kard
  else
   modem.broadcast(port,"false")
  end
end
r.setLightColor(0xFF0000)
print("pin: "..pin)
while not user do
  user = authoriz(pin)
end
r.setLightColor(0x0000FF)
print("Logged in")

while true do
  local _,_,kard,_,_,key = event.pull("modem_message")
  if kard == user and actions[key] then actions[key]() end
  if key == 34 then
    for i = 1, r.inventorySize() do if r.count(i) > 0 then r.select(i) r.drop() end end r.select(1)
  elseif key == 20 then
    r.select(1) for i = 1, r.inventorySize() do r.suck() end
  elseif key == 46 then
    local col = math.random(0x0, 0xFFFFFF) r.setLightColor(col)
  elseif key == 47 then
    if red then
      redstate = not redstate
	  if redstate then rs.setOutput(sides.front, 15) else rs.setOutput(sides.front, 0) end
    end
  elseif key == 200 then
    if pist then
        piston.push(1)
    end
  elseif key == 208 then
    if pist then
        piston.push(0)
    end
  end
end