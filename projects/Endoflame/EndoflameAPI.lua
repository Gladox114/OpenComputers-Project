--[[
EndoflameAPI: OpenComputers Feeder for Endoflame
Copyright (c) 2018, 2019 Gladox114

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local API = {}
local clear = require("clearAPI")
local component = require("component")
if component.isAvailable("redstone") then rs = component.redstone end
if component.isAvailable("transposer") then tran = component.transposer end
local sides = require("sides")
local keyboard = require("keyboard")
local term = require("term")
local thread = require("thread")
local event = require("event")
local gpu = component.gpu
local Feeded,mana,run = 0,nil,nil
local sideone,sidetwo,sideinput = sides.south,sides.east,sides.top
local val = 12



function API.endoflame(n,s,m)
local one = true
while true do
if m == "rs" then
	if rs.getInput(sideinput) > val then
		mana = "full"
		
	elseif rs.getInput(sideinput) <= val then
		mana = "empty"
	end
 	if mana == "full" then					--if full
	if gpu.getDepth() >= 4 then
		gpu.setBackground(0x006DFF) --Changing the Background Blue
	else
		gpu.setBackground(0xFFFFFF) --Switching between Black and white
		gpu.setForeground(0x000000)
	end
		gpu.fill(14,6,21,3," ")
		gpu.set(16,7,"Mana Pool is full")
		gpu.setBackground(0x000000)	--Changing back to normal (Black/White)
		gpu.setForeground(0xFFFFFF)
	elseif mana == "empty" then				--if empty
		gpu.setBackground(0x00000)	--Removing the "full" notification
		gpu.fill(14,6,21,3," ")
	end
	
elseif tonumber(m) and one then
  mana,one = nil
	if tonumber(m) > 0 then
		term.setCursor(33,9)
		if tonumber(m) > 1 then
		 io.write(m.." loops Remain")
		else
		 io.write(m.." loop Remain")
		end
		run = m
	end
elseif not m then
 run,mana = nil
end

term.setCursor(1,10)
io.write("Feeded "..Feeded.." times")
   if mana == "empty" or mana == nil then
   	   tran.transferItem(sideone, sidetwo, n)
	thread.create(function()
 		for i=1,n do
		   Feeded = Feeded + 1
		   term.setCursor(1,10)
 		   --rs.setOutput(sidetwo, 15)
		   io.write("Feeded "..Feeded.." times")
 		   os.sleep(0.1)
 		   --rs.setOutput(sidetwo, 0)
		   if Feeded >= 99999 then
		   		Feeded = 0
		   end
	 	end
	end)
  end
  
if run then
	run = run - 1
		term.setCursor(33,9)
		io.write("                ")
		term.setCursor(33,9)
		if tonumber(run) > 1 then
		 io.write(run.." loops Remain")
		else
		 io.write(run.." loop Remain")
		end
end
if tonumber(run) then
if run <= 0 then
	Settings = false
	return Settings
end
end
 
 if mana == "empty" or not mana then ntime = os.time() + (s * 72)
 else ntime = 0
  end
while os.time() < ntime or mana == "full" do
os.sleep(0)
	if keyboard.isKeyDown(keyboard.keys.space) == true then
		term.setCursor(1,4)
		io.write("Do you want to stop the program?")
		term.setCursor(1,5)
		io.write("Y/N  ")
		yn = io.read()
				if yn:lower() == "y" or yn:lower() == "yes" then
					Settings = false
					return Settings
				elseif yn:lower() == "n" or yn:lower() == "no" then
					clear.line(4,5)
				else
					clear.line(4,5)
			end
	end
	os.sleep(0.05)
	if keyboard.isKeyDown(keyboard.keys.s) == true then
		term.setCursor(1,4)
		io.write("Do you want to change the settings?")
		term.setCursor(1,5)
		io.write("Y/N ")
		yn = io.read()
				if yn:lower() == "y" or yn:lower() == "yes" then
					Settings = true
					return Settings
				elseif yn:lower() == "n" or yn:lower() == "no" then
					clear.line(4,5)
				else
					clear.line(4,5)
			end
	end
	os.sleep(0.05)
  	Remain = math.floor((ntime - os.time()) / 72)
 if Remain >= 0 then
 term.setCursor(32,10)
 io.write("                  ")
 term.setCursor(32,10)
 io.write("Time Remain "..Remain)
 elseif Remain < 0 and mana == "full" then
  term.setCursor(32,10)
 io.write("                  ")
 term.setCursor(32,10)
 io.write("Mana Pool is Full")
end
if m == "rs" then
		if rs.getInput(sideinput) > val then
			mana = "full"
		elseif rs.getInput(sideinput) <= val then
			mana = "empty"
		end
 	if mana == "full" then
		if gpu.getDepth() >= 4 then
			gpu.setBackground(0x006DFF)
		else
			gpu.setBackground(0xFFFFFF)
			gpu.setForeground(0x000000)
		end
		gpu.fill(14,6,21,3," ")
		gpu.set(16,7,"Mana Pool is full")
		gpu.setBackground(0x000000)
		gpu.setForeground(0xFFFFFF)
		event.pullMultiple("redstone_changed","key_down")
	elseif mana == "empty" then
		gpu.setBackground(0x000000)
		gpu.fill(14,6,21,3," ")
	end
end
 end
end
return settings
end

function API.burntime(t)
time = t / 40
return time
end

function API.feed(b)
if b:lower() == "coal" then
	time = 40
elseif b:lower() == "coalblock" then
	time = 400
elseif b:lower() == "charcoalblock" then
	time = 360
elseif b:lower() == "wood" then
	time = 7.5
else
    time = 999
end
return time
end

return API
