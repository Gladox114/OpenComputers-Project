--[[
Endoflame: OpenComputers Feeder for Endoflame
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

local clear = require("clearAPI")
local api = require("EndoflameAPI")
local component = require("component")
local gpu = component.gpu
local sides = require("sides")
local term = require("term")
local lineC = 32
local oldResx,oldResy = gpu.getResolution()
gpu.setResolution(50,10)
on = true
Settings = true


while on == true do
	if Settings == true then
		local trueRead = false
		term.clear()
		while trueRead == false do
		clear.line(2)
		clear.line(1)
 		io.write("Endoflames: \nHow many Endoflames")
		if wrong == true then
			clear.line(3)
			io.stderr:write("Type a number in")
		end
        term.setCursor(13,1)
		lineA = io.read()
			if tonumber(lineA) then
				trueRead = true
				clear.line(3)
			elseif not tonumber(lineA) then
			wrong = true
			end
		end
		clear.line(2)
		io.write("Feed: \nWrite Wood/Coal/Coalblock/Charcoalblock or\nif you want to write the burntime then write \"bt\"")
		term.setCursor(7,2)
		lineB = io.read()
		if lineB == "bt" then
		clear.line(3,4)
		local trueRead = false
		 while trueRead == false do
			clear.line(2)
			io.write("Burntime: ")	
			lineC = io.read()
			if not tonumber(lineC) then
				clear.line(3)
				io.write("Type a number in") 
			elseif tonumber(lineC) > 32000 then
				clear.line(3)
				io.write("The number is too big")
			elseif tonumber(lineC) <= 32000 then
				trueRead = true
				clear.line(3)
			end
		 end
			burntime = api.burntime(lineC)
		elseif lineB ~= "bt" then
			burntime = api.feed(lineB)
			clear.line(3,4)
		end
		local trueRead = false
		while trueRead == false do
			clear.line(4,5)
			clear.line(3)
			io.write("Mode: \n\"Redstone\" for detecting mana pool or a value for how often feed them all or write \"always\"")
			term.setCursor(7,3)
			lineD = io.read()
			if lineD:lower() == "redstone" or lineD:lower() == "rs" then
				mode,modeshow = "rs","Redstone Input"
				clear.line(3,6)
				trueRead = true
			elseif tonumber(lineD) then
				mode,modeshow = lineD,"Looped"
				clear.line(3,6)
				trueRead = true
			elseif lineD:lower(lineD) == "always" then
				mode,modeshow = nil,"Always"
				clear.line(3,6)
				trueRead = true
			else
				term.setCursor(1,6)
				io.stderr:write("error/wrong input")
			end
			clear.line(3)
			io.write("Mode: "..modeshow)
		end
	Settings = false
	clear.line(9)
	io.write("Time in sec: "..burntime)
    end
sett = api.endoflame(tonumber(lineA),burntime,mode)
if sett == false then
	gpu.setResolution(oldResx,oldResy)
	term.clear()
	os.exit()
elseif sett == true then
	Settings = true
end

end

os.execute("endoflame")

