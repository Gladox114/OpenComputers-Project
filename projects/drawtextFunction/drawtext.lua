-- Made by Gladox114 https://github.com/Gladox114/OpenComputers-Project
--its cheap but it is working
local c = require("component")
--local gpu2 = c.proxy(c.get("009"))
--local screen2 = c.get("2ed")
--gpu2.bind(screen2)
--Variables--
local pass = false
--Global Variables--
drawT = {}
drawT.lastStringLen = nil
drawT.x = 1
drawT.count = 1
---------------------


function drawText(setString,gpu2p)
  local maxX,maxY = gpu2p.getResolution()
  local out = type(setString)
  local y,w,h,newString
  y = drawT.count
  --print("maxX/Y:"..maxX.."/"..maxY.."|stringType:"..out.."|y:"..y) -- print for info
    
  if drawT.lastStringLen then  -- Addiere die länge vom letzten string zu jetzigem und entferne vielleicht die lastStringLen
  --print("from laststring add x")           -- print for info
    drawT.x = drawT.x+drawT.lastStringLen
  end
  local function copy()
  if out == "string" then
    if setString:find("\n") then
      if y == maxY and passed == true then
        w = maxX
        h = maxY
        gpu2p.copy(1,2,w,h-1,0,-1)
        --print("copied")                   -- print for info
        gpu2p.fill(1,maxY,maxX,maxY," ")
      end
    end
  end
  end
  --print(setString)
  if type(setString) == "number" then
    newString = tostring(setString)
  elseif type(setString) == "string" then
    newString = string.gsub(setString,"\n","")
  else
    newString = setString
  end
  --print(newString,setString)
  
  gpu2p.set(drawT.x,y,newString)
  
  copy()
  
                                 -- wenn der input ein string ist
    if out == "string" then
      if setString:find("\n") then    -- wenn der string "\n" beinhaltet dann gehe runter zur der nächsten zeile
        drawT.x = 1
        if y < maxY then
          drawT.count = drawT.count+1
     --     print("count added:"..drawT.count) --print for info
        else
        passed = true
        end
        drawT.lastStringLen = nil
      else
    --   print("no \\n in there so carry lastStringLen") -- print for info
       drawT.lastStringLen = string.len(newString)
      end
    elseif out == "number" then
      drawT.lastStringLen = string.len(newString)
    end
  
  
  
  
  
  -- printing info section --
  --local justprinten
  --if not drawT.lastStringLen then            -- print for info
  --  justprinten = "nil"                      -- print for info
  --else                                       -- print for info
  --  justprinten = drawT.lastStringLen        -- print for info
  --end                                        -- print for info
  --print("LastStrLen:"..justprinten.."|x:"..drawT.x.."|count:"..drawT.count)   -- print for info
end