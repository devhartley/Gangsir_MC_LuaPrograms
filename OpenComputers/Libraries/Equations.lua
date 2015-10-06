--[[
Gangsir's equations library
This is a math library of random geometry, physics, and algebra equations.
--]]

math = require("math") --duh

local functList = {} --list of all of the equations

--Pythagorian theorem, provide lengths of both legs of a triangle. a^2+b^2=c^2. Returns Hypotenuse.
function functList.pythagT(a,b)
  return math.sqrt(a^2)+(b^2))
end

--Acceleration, provide delta velocity, and delta time. Returns Acceleration.
function functList.accel(dv,dt)
  return dv/dt
end

--fahrenheit to celsius, provide fahrenheit temp, returns celsius
function functList.fahrenheitToCelsius(temp)
  return ((temp-32)/9)*5
end

--celsius to fahrenheit, provide celsius temp, returns fahrenheit
function functList.celsiusToFahrenheit(temp)
  return ((temp*9)/5)+32
end

--Returns standard Acceleration towards earth, on earth, in metres per second.
function functList.earthDownAccel() return -9.8 end

--solves quadraticFormula, based on a,b,c. Returns plus and minus solution.
function functList.quadraticFormula(a,b,c)
  local one = (-b+math.sqrt(b^2)-(4*a*c))/2*a
  local two = (-b-math.sqrt(b^2)-(4*a*c))/2*a
  return one, two
end

--circumference formula, provide diameter, returns circumference
function functList.circumference(diameter)
  return math.pi*diameter
end

--area of a circle, provide radius, returns area
function functList.circleArea(r)
  return math.pi*r^2
end

--distance formula, provide 2 points, returns distance
function functList.distance(x1,y1,x2,y2)
  return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end

--geometry slope equation, provide 2 points. returns slope
function functList.slope(x1,y1,x2,y2)
  return (y2-y1)/(x2-x1)
end

--volume of a rectangular prism, provide length,depth,height. Returns volume
function functList.rectPrismVol(a,b,c)
  return a*b*c
end

--volume of a cylinder, provide radius and height, returns volume
function functList.cylinderVol(r,h)
  return math.pi*(r^2)*h
end

return functList
--eof
