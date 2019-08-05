--               [EnergyMonitor]
-- for Mekanism's Inductionmatrix (by BrainGamer)
--
--                 [IMPORTANT]
-- This requires the graphing lib by BrainGamer (use the Installer and type "graphing")
-- This is coded to fit a 5 wide and 4 high display (Tier 3)
--
--                 [Options]
--
-- Energy unit (RF, EU, MJ, J)
energyUnit = "RF"   -- Default: RF
-- Refreshtime (Time between refreshes)
refreshTime = 1   -- Default: 0.5
zet = 0.5
--
--         [DONT CHANGE THE CODE BELOW]
--------------------------------------------------
--------------------------------------------------
--
--  [Functions]

local function fit()
    local component = require("component")
    --local gpu = component.gpu
    local x, y = component.proxy(gpu.getScreen()).getAspectRatio()
    x = x - 0.25
    y = y - 0.25
    local max_x, max_y = gpu.maxResolution()
    local end_x, end_y
    if x == y then
        end_x = max_y * 2
        end_y = max_y
    elseif x > y then
        end_x = max_x
        end_y = max_x / x * y / 2
        if end_y > max_y then
            local v = max_y / end_y
            end_x = end_x * v
            end_y = end_y * v
        end
    elseif x < y then
        end_x = max_y / y * x * 2
        end_y = max_y
        if end_x > max_x then
            local v = max_x / end_x
            end_x = end_x * v
            end_y = end_y * v
        end
    end
    return end_x, end_y
end

function round(x, dez)  -- round floats
  local m = 10^(dez or 0)
  return ((x * m + 0.5) - (x * m + 0.5) % 1) / m
end

function adjustUnit(value, unit)  -- prevent big numbers
  if value >= 1000000000000 then
    return tostring(round(value/1000000000000, 2)) .. "T" .. unit
  elseif value >= 1000000000 then
    return tostring(round(value/1000000000, 2)) .. "G" .. unit
  elseif value >= 1000000 then
    return tostring(round(value/1000000, 2)) .. "M" .. unit
  elseif value >= 1000 then
    return tostring(round(value/1000, 2)) .. "k" .. unit
  else
    return tostring(round(value)) .. unit
  end
end

function adjustTime(time)  -- prevent big numbers
  if time > 8553600 then
    return "99+ days"
  elseif time > 172800 then
    return tostring(round(time/86400,1)) .. " days"
  elseif time > 7200 then
    return tostring(round(time/3600,1)) .. " hours"
  elseif time > 120 then
    return tostring(round(time/60,1)) .. " min."
  else
    return tostring(time,1) .. " sec."
  end
end

function removeOverflow(input, maxNum)  -- delete old data
  while #input > maxNum do
    table.remove(input,maxNum+1)
  end
  return input
end

function display()  -- display

  --  get all data
  local maxTransfer = s.getTransferCap() * energyMultiplier * zet
  local maxStored = s.getMaxEnergy() * energyMultiplier
  local curOutput = s.getOutput() * energyMultiplier
  local curInput = s.getInput() * energyMultiplier
  local stored = s.getEnergy() * energyMultiplier
  table.insert(output,1,curOutput)
  table.insert(input,1,curInput)
  output = removeOverflow(output,40)
  input = removeOverflow(input,40)

  --  generate texts
  local text_i = "INPUT: " .. adjustUnit(input[1], energyUnit) .. "/t"
  local len_i = text_i:len()

  local text_o = "OUTPUT: " .. adjustUnit(output[1], energyUnit) .. "/t"
  local len_o = text_o:len()

  local text_t = "---"
  if curOutput < curInput then
    local ticks = (maxStored - stored) / (curInput - curOutput) / 20
    text_t = "CHARGED IN: " .. adjustTime(ticks)
  elseif curOutput > curInput then
    local ticks = stored / (curOutput - curInput) / 20
    text_t = "EMPTY IN: " .. adjustTime(ticks)
  end
  local len_t = text_t:len()

  local text_s = "ENERGY STORED: " .. adjustUnit(stored, energyUnit)
  local len_s = text_s:len()

  --  clear textfields
  gpu.setBackground(0x343434)
  gpu.setForeground(0xEFEFEF)
  gpu.fill(1,13,x,2," ")
  gpu.fill(x/2,2,2,11," ")
  gpu.fill(1,25,x,1," ")

  --  print texts
  gpu.set((x/2)-(len_s/2),25,text_s)
  gpu.setForeground(0x0ADF0A)
  gpu.set((x/4)-(len_i/2),13,text_i)
  gpu.setForeground(0xFF0A0A)
  gpu.set((x-(x/2))+(len_o/2),13,text_o)
  if curOutput < curInput then
    gpu.setForeground(0x0ADF0A)
    gpu.set((x/2)-(len_t/2),14,text_t)
  elseif curOutput > curInput then
    gpu.setForeground(0xFF0A0A)
    gpu.set((x/2)-(len_t/2),14,text_t)
  else
    gpu.setForeground(0xEFEFEF)
    gpu.set((x/2)-(len_t/2)+1,14,text_t)
  end

  --  draw graphs/diagrams (graphing lib required!)
  g.verticalDiagram(2,2,x/2,11,0,v,input,maxTransfer,0x0ADF0A,0x0A0A0A)
  g.horizontalBar(2,15,x-2,10,stored,maxStored,0xFE9A00,0x0A0A0A,0xEFEFEF,"("..tostring(round(stored/maxStored*100,2)).."%)")
  g.verticalDiagram(x/2+2,2,x,11,0,v,output,maxTransfer,0xFF0A0A,0x0A0A0A)
end

--  [Main Code]

--    [INIT]
computer = require("computer")
comp = require("component")
g = require("graphing")
ev = require("event")
--if comp.list("induction_matrix") then
s = comp.proxy(comp.list("induction_matrix")())
--else
--error(nil)
--end
if comp.get("009") and comp.get("975") then
  gpu = comp.proxy(comp.get("009"))
  screen = comp.proxy(comp.get("975"))
  gpu.bind(comp.get("975"))
else
  screen = comp.screen
  gpu = comp.gpu
  gpu.bind(screen)
end

energyMultiplier = 0
x,y = fit()
v = math.floor(x/2.0833333)
print("Display running")
--x = 129/2
--y = 50/2

--  Screen setup
gpu.setResolution(x,y)
screen.setTouchModeInverted(true)

--  use the right multiplier
if energyUnit == "RF" then
  energyMultiplier= 0.4
elseif energyUnit == "EU" then
  energyMultiplier= 0.1
elseif energyUnit == "MJ" then
  energyMultiplier= 0.04
else
  energyMultiplier= 1
end

-- create tables for diagrams
output = {}
input = {}
for i=1,40 do
  table.insert(output,1,s.getOutput() * energyMultiplier)
  table.insert(input,1,s.getInput() * energyMultiplier)
end

-- clear screen
gpu.setBackground(0x343434)
gpu.fill(1,1,x,y," ")

--repeat  --  repeat until a button is pressed

  --  test if everything is working
local function loop()
  if not pcall(display) then  --  an error occured
    gpu.setBackground(0x343434)
    gpu.setForeground(0xFF00CC)
    gpu.fill(1,1,x,y," ")
    local text = "CONNECTION LOST"
    local len = text:len()
    gpu.set((x/2)-(len/2),y/2,text)
    computer.beep(800,0.3)
    e = ev.pull(1, "key_down")
  else							-- everything fine
    e = ev.pull(refreshTime,"key_down")
  end
  if e then ev.cancel(energy) print(" ") print("Stopped the Information Display")end
end
if energy then ev.cancel(energy) end
energy = ev.timer(refreshTime,loop,math.huge)
--until e

--  reset screen and reboot
--screen.setTouchModeInverted(false)
--gpu.setResolution(x*2,y*2)
--computer.shutdown(true)