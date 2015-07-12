--Gangsir's opencomputers Distance Calculator
--Good for tablet computers, for an easy distance calculator utility on the go!

local term = require("term")
print("Enter x1.")
local x1 = tonumber(term.read())
print("Enter X2.")
local x2 = tonumber(term.read())
print("Enter y1.")
local y1 = tonumber(term.read())
print("Enter y2.")
local y2 = tonumber(term.read())
print("Enter z1.")
local z1 = tonumber(term.read())
print("Enter z2.")
local z2 = tonumber(term.read())

local math = require("math")
distance = math.sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2)) --calculate distance using 3d distance formula
print("The distance from ("..x1..","..y1..","..z1..") and ("..x2..","..y2..","..z2..") is "..distance.." blocks.")