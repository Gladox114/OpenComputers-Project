local config1 = {}
config1[1] = {"Setting","test"}
config1[2] = {"Name","yeet"}
config1[3] = {"IP","8887"}

----
file = io.open("config.txt","w")

for i,k in ipairs(config1) do
print(config1[i][1],config1[i][2])
file:write(config1[i][1].."="..config1[i][2].."\n")
end

file:close() 
----

local config = {}

for line in io.lines "config.txt" do
  table.insert(config, line)
end

----

for i,v in ipairs(config) do
  local pos = v:find("=")
   config[i] = v:sub(pos+1,-1)
end
  

print(config[3]) -- # 3rd line in your config
-- # this is probably the simplest way but there are others.