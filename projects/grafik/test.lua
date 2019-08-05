local c = require("component")
local main,gpu = "3ba"
local t = require("thread")
local arg = {...}
if c.get(main) then gpu = c.proxy(c.get(main))
else gpu = c.gpu end
local xmax,ymax = gpu.getResolution()

function drawRandomLine()
  input = math.random(tonumber(0x000000),tonumber(0xFFFFFF))
  --print(input)
  gpu.setBackground(input)
  --gpu.setBackground(0xFFFFFF)
  ran = math.random(1,2)
  num = math.random(-2,2)
  num = num+math.random()
  num2 = math.random(0,ymax/2)
  for x=-xmax/2,xmax/2 do
    if ran == 1 then
      y=x*num+num2
    elseif ran == 2 then
      y=x*num-num2
    end
    y=y+ymax/2
    x=xmax/2+x
    if x <= xmax and y <= ymax and x >= 0 and y >= 0then
      gpu.set(x,y," ")
    end
  end

end
if not arg[1] then arg[1] = 1 end

--grafik = t.create(function()
for i=1,arg[1] do
drawRandomLine()
os.sleep(0)
end
--end)

--while true do
--pulled = event.pull("81")
--if pelled = 
--end