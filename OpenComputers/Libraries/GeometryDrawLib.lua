--Gangsir's Geometry drawing library, useful for drawing basic shapes to the screen.

term = require("term")
io = require("io")
fs = require("filesystem")
math = require("math")
component = require("component")

gpu = component.gpu

funcList = {} --table of all functions


--internal quick method to draw a pixel
local function drawPixelInternal( xPos, yPos ) --draws a pixel to the screen.
    gpu.set(xPos,yPos,"█")
end

--method to get the centre of the screen quickly. returns x,y
function funcList.screenCentre()
  local maxX, maxY = gpu.getResolution()
  return math.floor(maxX/2), math.floor(maxY/2)
end


--draws a single pixel to the screen, provide location and colour in 0x?????? format
function funcList.drawPixel( xPos, yPos, nColour )
    local oldFore = gpu.getForeground() --saves the previous text colour
    if type( xPos ) ~= "number" or type( yPos ) ~= "number" or (nColour ~= nil and type( nColour ) ~= "number") then
        error( "Expected x, y, colour", 2 )
    end
    if nColour then
        gpu.setForeground( nColour )
    end
    drawPixelInternal( xPos, yPos )
    gpu.setForeground(oldFore) --return the colour back to the original
end

--draws a line to the screen, provide start point and end point and colour in 0x?????? format
function funcList.drawLine( startX, startY, endX, endY, nColour )
    local oldFore = gpu.getForeground() --saves the previous text colour

    if type( startX ) ~= "number" or type( startX ) ~= "number" or
       type( endX ) ~= "number" or type( endY ) ~= "number" or
       (nColour ~= nil and type( nColour ) ~= "number") then
        error( "Expected startX, startY, endX, endY, colour", 2 )
    end

    startX = math.floor(startX)
    startY = math.floor(startY)
    endX = math.floor(endX)
    endY = math.floor(endY)

    if nColour then
        gpu.setForeground( nColour )
    end
    if startX == endX and startY == endY then
        drawPixelInternal( startX, startY )
        return
    end

    local minX = math.min( startX, endX )
    if minX == startX then
        minY = startY
        maxX = endX
        maxY = endY
    else
        minY = endY
        maxX = startX
        maxY = startY
    end

    local xDiff = maxX - minX
    local yDiff = maxY - minY

    if xDiff > math.abs(yDiff) then
        local y = minY
        local dy = yDiff / xDiff
        for x=minX,maxX do
            drawPixelInternal( x, math.floor( y + 0.5 ) )
            y = y + dy
        end
    else
        local x = minX
        local dx = xDiff / yDiff
        if maxY >= minY then
            for y=minY,maxY do
                drawPixelInternal( math.floor( x + 0.5 ), y )
                x = x + dx
            end
        else
            for y=minY,maxY,-1 do
                drawPixelInternal( math.floor( x + 0.5 ), y )
                x = x - dx
            end
        end
    end
    gpu.setForeground(oldFore) --return the colour back to the original
end

--draws an unfilled box to the screen, provide start x and y, end x and y, and a colour in 0x?????? format
function funcList.drawBox( startX, startY, endX, endY, nColour )
    local oldFore = gpu.getForeground() --saves the previous text colour
    if type( startX ) ~= "number" or type( startX ) ~= "number" or
       type( endX ) ~= "number" or type( endY ) ~= "number" or
       (nColour ~= nil and type( nColour ) ~= "number") then
        error( "Expected startX, startY, endX, endY, colour", 2 )
    end

    startX = math.floor(startX)
    startY = math.floor(startY)
    endX = math.floor(endX)
    endY = math.floor(endY)

    if nColour then
        gpu.setForeground( nColour )
    end
    if startX == endX and startY == endY then
        drawPixelInternal( startX, startY )
        return
    end

    local minX = math.min( startX, endX )
    if minX == startX then
        minY = startY
        maxX = endX
        maxY = endY
    else
        minY = endY
        maxX = startX
        maxY = startY
    end

    for x=minX,maxX do
        drawPixelInternal( x, minY )
        drawPixelInternal( x, maxY )
    end

    if (maxY - minY) >= 2 then
        for y=(minY+1),(maxY-1) do
            drawPixelInternal( minX, y )
            drawPixelInternal( maxX, y )
        end
    end
    gpu.setForeground(oldFore) --return the colour back to the original
end


--draws a circle, provide centre coords and radius and colour. Common C implement, ported to lua
--note that this actually ends up drawing an ellipse, due to each "pixel" on an oc screen being a rectangle. Why, Sangar, why?
function funcList.drawCircle(x0,y0,radius,colour)
  local oldFore = gpu.getForeground() --saves the previous text colour
  gpu.setForeground(colour)

  --sanity check
  if type( y0 ) ~= "number" or type( x0 ) ~= "number" or type( radius ) ~= "number" or type( colour ) ~= "number" then
      error( "Expected xPos, yPos, radius, colour", 2 )
  end

  local x = radius;
  local y = 0;
  local decisionOver2 = 1 - x;   --Decision criterion divided by 2 evaluated at x=r, y=0

  while y <= x do
    drawPixelInternal( x + x0,  y + y0) --Octant 1
    drawPixelInternal( y + x0,  x + y0) --Octant 2
    drawPixelInternal(-x + x0,  y + y0) --Octant 4
    drawPixelInternal(-y + x0,  x + y0) --Octant 3
    drawPixelInternal(-x + x0, -y + y0) --Octant 5
    drawPixelInternal(-y + x0, -x + y0) --Octant 6
    drawPixelInternal( x + x0, -y + y0) --Octant 8
    drawPixelInternal( y + x0, -x + y0) --Octant 7
    y = y+1
    if decisionOver2<=0 then
      decisionOver2 = (decisionOver2) + 2 * y + 1;   --Change in decision criterion for y -> y+1
    else
      x=x-1
      decisionOver2 = (decisionOver2) + 2 * (y - x) + 1;   --Change for y -> y+1, x -> x-1
    end
  end
  gpu.setForeground(oldFore) --return the colour back to the original
end

return funcList
