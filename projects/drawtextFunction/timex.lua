local component = require("component")
local event = require("event")
local gpu = component.proxy(secgpu)
gpu.bind(ae2mon)
if timex then event.cancel(timex) timex=nil end
local function loop()
  x = gpu.getResolution()
  if not event.pull(0,"key_down") then
    str = os.date():sub(9,-4)
    gpu.set(x-str:len(),1,str)
  end
end

timex = event.timer(0.9,loop,math.huge)