local arg ={...}
if arg[1] and arg[2] then
  arg[1] = tostring(arg[1])
  arg[2] = tostring(arg[2])
  local c = require("component")
  local gpu2 = c.proxy(c.get(arg[1]))
  local screen2 = c.get(arg[2])
  gpu2.bind(screen2)
  local x,y = gpu2.getResolution()
  gpu2.fill(1,1,x,y," ")
end