require("adjustScreen")
c = require("component")
gpuID = c.gpu.address
screenID = c.screen.address
print(gpuID,screenID)
startScreen(gpuID,screenID)
