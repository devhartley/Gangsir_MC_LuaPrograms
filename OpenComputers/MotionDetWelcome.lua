--[[
Motion detector welcoming program by Gangsir
A small quality of life program to welcome you to your base.
Range of the detector is set to program argument 1, so place the detector where you walk past when you enter
Requires a motion sensor. Duh. Everything else can be tier 1.
--]]

local component = require("component")
local gpu = component.gpu
local event = require("event")
local io = require("io")
local pargs = {...}
local term = require("term")

if not component.isAvailable("motion_sensor") then error("This program requires a motion sensor to function.") end



print("Init Welcome...")
local range = tonumber(pargs[1]) or 2 --set the range of the mot detector to argument
if range >8 then error("Range cannot be higher than Mot. Sensor's max, 8.") end
print("Current range to scan is: "..tostring(range))
os.sleep(2)

while true do
  term.clear()
  _,_,x,y,z,entName = event.pull("motion") --wait for movement
  if x<= tonumber(range) and y<= tonumber(range) and z<= tonumber(range) then --if recieved motion was within range
    require("computer").beep()
    gpu.setResolution(25,9)
    term.clear() --remove previous welcome
    local maxX,maxY = gpu.getResolution()
    local nameX = require("math").floor((maxX/2)-(entName:len()/2)) --centre the entity name
    term.setCursor(1,maxY/3) --place the welcome in the upper third of the screen, in the centre
    io.write("Welcome,")
    term.setCursor(nameX,(maxY/3)+1) --place name one line lower than the welcome
    io.write(entName)
    os.sleep(3) --cooldown time, to avoid spam
  end
  --else, movement is ignored
end
--eof
