clear = {}
local term = require("term")

function clear.line(a,b,c)
if not b then
 	term.setCursor(1,a)
 	term.clearLine()
 elseif b and c then
 	for i=a,b,c do
		term.setCursor(1,i)
		term.clearLine()
	end
elseif b and not c then
 	for i=a,b do
		term.setCursor(1,i)
		term.clearLine()
	end
 end
 end
 
 return clear