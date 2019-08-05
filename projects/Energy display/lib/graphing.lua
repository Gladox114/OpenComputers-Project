-- Graphing Lib by BrainGamer
-- Use the installer: pastebin.com/GiZ18Hk9
local comp = require("component")
local gpu
--if comp.get("d72") then
  gpu = comp.proxy(comp.get("009"))
  screen = comp.get("975")
  gpu.bind(screen)
--else
  --gpu = comp.gpu
--end
local lib = {} 
 
lib.horizontalBar = function(x, y, mx, my, value, maxValue, color, bgcolor, textcolor, text)
 
  -- Calculate all values before changing the screen
  -- This prevents flickering
 
  if value > maxValue then
    value = maxValue
  end
 
  local factor = mx / maxValue
  local currX = factor * value
 
  if not bgcolor then
    bgcolor = gpu.getBackground()
  end
 
  if text then
    strX = x + mx / 2 - text:len() / 2
    strY = y + my / 2
  end
 
  -- Start graphing
 
  -- Rest screen area and set background color
  gpu.setBackground(bgcolor)
  gpu.fill(x, y, mx, my, " ")
 
  -- Fill in the bar
  gpu.setBackground(color)
  gpu.fill(x, y, currX, my, " ")
 
  -- Write the optional text
  if text then
    gpu.setBackground(bgcolor)
    gpu.setForeground(textcolor)
    --gpu.set(strX ,strY, text)
    for i=0,text:len() do
      local a,b = 1+i,2+i
      local X = strX+i
      if X < currX+1 then
       gpu.setBackground(color)
      else
        gpu.setBackground(bgcolor)
      end
      gpu.set(X, strY, text:sub(a,b))
    end
  end
end
 
lib.verticalBar = function(x, y, mx, my, value, maxValue, color, bgcolor, textcolor, text)
 
  -- Same as horizontalBar but vertical
 
  if value > maxValue then
    value = maxValue
  end
 
  local factor = my / maxValue
  local currY = factor * value
 
  if not bgcolor then
    bgcolor = gpu.getBackground()
  end
 
  if text then
    strX = x + mx / 2 - text:len() / 2
    strY = y + my / 2
  end
 
  -- Start graphing
 
  gpu.setBackground(color)
  gpu.fill(x, y, mx, my, " ")
 
  gpu.setBackground(bgcolor)
  gpu.fill(x, y, mx,my - currY, " ")
 
  if text then
    gpu.setBackground(bgcolor)
    gpu.setForeground(textcolor)
    gpu.set(strX, strY, text)
  end
end
 
lib.horizontalDiagram = function(x, y, mx, my, spacing, valuesNum, values, maxValue, color, bgcolor)
 
  -- A horizontal diagram using the horizontalBar function
 
  local yScale = (my - y) / valuesNum
 
  if not bgcolor then
    bgcolor = gpu.getBackground()
  end
 
  for i = 1, valuesNum do
    currY = yScale * (i - 1) + y
 
    lib.horizontalBar(x, currY, mx, yScale, values[i], maxValue, color, bgcolor)
 
    if spacing > 0 then
      gpu.setBackground(bgcolor)
      if i < valuesNum then
        gpu.fill(x, currY+yScale-spacing, mx, spacing, " ")
      end
    end
  end
end
 
lib.verticalDiagram = function(x, y, mx, my, spacing, valuesNum, values, maxValue, color, bgcolor)
 
  -- A vertical diagram using the verticalBar function
 
  local xScale = (mx - x) / valuesNum
 
  if not bgcolor then
    bgcolor = gpu.getBackground()
  end
 
  for i = 1, valuesNum do
    currX = xScale * (i - 1) + x
 
    lib.verticalBar(currX, y, xScale, my, values[i], maxValue, color, bgcolor)
 
    if spacing > 0 then
      gpu.setBackground(bgcolor)
      if i < valuesNum then
        gpu.fill(currX+xScale-spacing, y, spacing, my, " ")
      end
    end
  end
end

return lib