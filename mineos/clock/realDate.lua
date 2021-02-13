internet = require("internet")
 
function getString(point,offset,length)  
  return webpage:sub(point+offset,point+offset+length)
end
 
function getCurrentDate()
 point = nil
 while not point do
   webpage = internet.request("http://worldtimeapi.org/api/timezone/Europe/Berlin")()
   i,point = webpage:find("\"datetime")
 end
 offset=4
 year = getString(point,offset,3)
 
 offset=offset+11
 hour = getString(point,offset,1)
 
 offset=offset+3
 minute = getString(point,offset,1)
 
 offset=offset+3 
 seconds = getString(point,offset,1)
  
 return hour..":"..minute..":"..seconds
end
 
--print(getCurrentDate())
