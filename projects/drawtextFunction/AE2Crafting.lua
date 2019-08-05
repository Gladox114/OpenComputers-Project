-- Original by Palagius : https://oc.cil.li/index.php?/topic/1426-ae2-level-auto-crafting/
-- Modfied by Dalden 2018-07-28 
--           - Store crafting result object to check for status
--           - If crafting job is not yet finished from previous cycle then skip this cycle
-- Modified by Gladox114 2019-03-30 https://github.com/Gladox114/OpenComputers-Project
-- and thanks to cptmercury for help! https://oc.cil.li/profile/4116-cptmercury/
--           - Can run in the background
--           - Uses a second GPU and Screen for Displaying
local arg = {...}
if not arg[1] or not arg[2] then print("argument is needed.") print("- 1. GPU Adress(at least 3 symbols)") print("- 2. Screen Adress(at least 3 symbols)") os.exit() end
--if not arg[1] then
--arg[1] = "eb3" else arg[1] = tostring(arg[1]) end
--if not arg[2] then
--arg[2] = "5f1" else arg[2] = tostring(arg[2]) end
local component = require("component")
local term = require("term")
local thread = require("thread")
local event = require("event")
local meController = component.proxy(component.me_controller.address)
local gpu2p = component.proxy(component.get(arg[1]))
local screen2 = component.get(arg[2])
local count,off = 0
startScreen(arg[1],arg[2])
background = 0x000000
gpu2p.setForeground(0xFFFFFF)
local path = "/home/projects/drawtextFunction/"  -- Not sure if you can put itemList.cfg in the same folder and let this blank
--local path = "/mnt/798/data/"
-- Each element of the array is "item", "damage", "number wanted", "max craft size"
-- Damage value should be zero for base items
--items = {{"minecraft:coal",1,1,1}}
items = {}
os.execute(path.."itemList.cfg")  

loopDelay = 30 -- Seconds between runs

-- Init list with crafting status
for curIdx = 1, #items do
    items[curIdx][5] = false -- Crafting status set to false
    items[curIdx][6] = nil -- Crafting object null
end

x,y = gpu2p.getResolution()
local function func()

    --os.execute(path.."itemList.cfg")
    for curIdx = 1, #items do
        curName = items[curIdx][1]
        curDamage = items[curIdx][2]
        curMinValue = items[curIdx][3]
        curMaxRequest = items[curIdx][4]
        curCrafting = items[curIdx][5]
        curCraftStatus = items[curIdx][6]

        -- io.write("Checking for " .. curMinValue .. " of " .. curName .. "\n")
        storedItem = meController.getItemsInNetwork({
            name = curName,
            damage = curDamage
            })
        drawText("Network contains ",gpu2p)
        gpu2p.setForeground(0xCC24C0) -- Purple-ish
        --print(storedItem[1].size)
        drawText(storedItem[1].size,gpu2p)
        gpu2p.setForeground(0xFFFFFF) -- White
        drawText(" items with label ",gpu2p)
        gpu2p.setForeground(0x00FF00) -- Green
        drawText(storedItem[1].label .. "\n",gpu2p)
        gpu2p.setForeground(0xFFFFFF) -- White
        if storedItem[1].size < curMinValue then
            delta = curMinValue - storedItem[1].size
            craftAmount = delta
            if delta > curMaxRequest then
                craftAmount = curMaxRequest
            end

            drawText("  Need to craft ",gpu2p)
            gpu2p.setForeground(0xFF0000) -- Red
            drawText(delta,gpu2p)
            gpu2p.setForeground(0xFFFFFF) -- White
            drawText(", requesting ",gpu2p)
            gpu2p.setForeground(0xCC24C0) -- Purple-ish
            drawText(craftAmount .. "... ",gpu2p)
            gpu2p.setForeground(0xFFFFFF) -- White

            craftables = meController.getCraftables({
                name = curName,
                damage = curDamage
                })
            if craftables.n >= 1 then
                cItem = craftables[1]
                if curCrafting then
                    if curCraftStatus.isCanceled() or curCraftStatus.isDone() then
                        drawText("Previous Craft completed\n",gpu2p)
                        items[curIdx][5] = false
                        curCrafting = false
                    end
                end
                if curCrafting then
                        drawText("Previous Craft busy\n",gpu2p)
                end
                if not curCrafting then
                    retval = cItem.request(craftAmount)
                    items[curIdx][5] = true
                    items[curIdx][6] = retval
                    gpu2p.setForeground(0x00FF00) -- Green
                    drawText("Requested - ",gpu2p)
		    --while (not retval.isCanceled()) and (not retval.isDone()) do
	            --		os.sleep(1)
                    --        io.write(".")
		    -- end
                    gpu2p.setForeground(0xFFFFFF) -- White
                    drawText("Done \n",gpu2p)
                end
            else
                gpu2p.setForeground(0xFF0000) -- Red
                drawText("    Unable to locate craftable for " .. storedItem[1].name .. "\n",gpu2p)
                gpu2p.setForeground(0xFFFFFF) -- White
            end
        end
    end
    drawText("Sleeping for " .. loopDelay .. " seconds...\n\n",gpu2p)
end

local function loop()
  if not pcall(func) then
    gpu2p.setBackground(0x343434)
    gpu2p.setForeground(0xFF0060)
    gpu2p.fill(1,1,x,y," ")
    local stringe = "ME LOST"
    local f = (x/2-stringe:len()/2)
    --gpu2p.setBackground(0x9933ff)
    --gpu2p.fill(f-1,y/2-1,stringe:len()+2,3," ")
    gpu2p.set(f,y/2,stringe)
    computer.beep(800,0.3)
    --gpu2p.setBackground(background)
    --gpu2p.setForeground(0xFFFFFF)
    off = true
  else
    if off then
      gpu2p.setBackground(background)
      gpu2p.fill(1,1,x,y," ")
      off = false
    end
  end
end

loop()
ae2timer = event.timer(loopDelay, loop, math.huge)