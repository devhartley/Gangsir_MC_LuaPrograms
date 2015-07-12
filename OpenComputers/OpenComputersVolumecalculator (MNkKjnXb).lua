--Gangsir's rectangular prism volume calculator
--Good for tablet computers, so you can calculate volume on the go!

print("(X) length of the rectangular prism?")
local xLength = require("term").read()
print("(Z) depth of the rectangular prism?")
local zLength = require("term").read()
print("(Y) height of the rectangular prism?")
local yHeight = require("term").read()
volume = xLength*yHeight*zLength
print("There are/is "..volume.." block(s) in the "..xLength.."x"..zLength.."x"..yHeight.." space defined.")