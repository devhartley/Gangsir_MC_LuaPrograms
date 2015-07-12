--Gangsir's 3D midpoint calculator
--Good for tablet computers, for midpoint calculation on the go!

--first point
print("First X coord?")
local x1 = tonumber(require("term").read())
print("First y coord?")
local y1 = tonumber(require("term").read())
print("First z coord?") 
local z1 = tonumber(require("term").read())
--second point
print("Second x coord?") 
local x2 = tonumber(require("term").read())
print("Second y coord?") 
local y2 = tonumber(require("term").read())
print("Second z coord?") 
local z2 = tonumber(require("term").read())
--calculations
midX = (x2-x1)/2
midY = (y2-y1)/2
midZ = (z2-z1)/2

print("The midpoint between ("..x1..","..y1..","..z1..") and ("..x2..","..y2..","..z2..") is ("..midX..","..midY..","..midZ..")")