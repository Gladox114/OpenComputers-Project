--Micro_controller for ic2 Reactor coolant
--local component = require("component")
--local event = require("event")
--local computer = require("computer")
--local 
t,r,s,sr = component.proxy(component.list("transposer")()),component.proxy(component.list("redstone")()),1,2
--local

function a(v)
m=t.getTankLevel(s)/t.getTankCapacity(s)
  if m > v then
    return true
  else
    return false
  end
end

while true do
--repeat
if not a(0.75) then
  r.setOutput(sr,15)
--  print("not full")
else
  r.setOutput(sr,0)
--  print("full")
  while a(0.25) do
  computer.pullSignal(1)
  end
end
--e = event.pull(0,"key_down")
--until e
end