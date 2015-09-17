--[[
Gangsir's simple Sugarcane harvester robot program.
Robot can be completely tier 1, although at least 1 inventory upgrade is required.
To set up, place blocks in this configuration:
R = Robot,S = Sugarcane, W = water, C = charger
WSSW
WSSW
WSSW
WSSW
WSSW
WSSW
 CR

Chest goes on bottom of robot for output, robot needs to be 1 block off the ground.
Light colors are blue for waiting, green for harvesting, yellow for returning, and red for dropping items.
--]]

local component = require("component")
local robot = require("robot")
local pargs ={...}


print("Light colors are blue for waiting, green for harvesting, yellow for returning, and red for dropping items.")

--makes like skrillex and drops the (bass)inventory down
function dropInventoryDown()
  for i = 1, robot.inventorySize() do --drop entire inventory
    robot.select(i)
    robot.dropDown()
  end
  robot.select(1)
end

--Checks to see if the robot should stop moving back.
function checkForStop()
 local _,block = robot.detectDown()
 if block == "solid" then --if object is not sugarcane, which is passable
   return true
 else
   return false
 end
end

--main driving loop
while true do
  robot.setLightColor(0x0000FF) --blue
  print("Waiting...")
  while true do
    local _,block = robot.detect()
    if block ~= "air" then break end --start running
    os.sleep(3) --prevent spam
  end
  robot.setLightColor(0x00FF00) --green
  print("Harvesting...")
  robot.swing()
  while not robot.forward() do robot.swing() end --if it still can't move, swing again
  while robot.detectDown() do --move forward and chop down Sugarcane, stop when out of sugarcane
    robot.swing()
    robot.turnLeft()
    robot.swing()
    robot.turnRight()
    if not robot.forward() then --if unable to move, such as block or entity in way
      robot.swing()
    end
    robot.suckDown()
  end
  robot.setLightColor(0xF4FF0D) --yellow
  while not checkForStop() do --move back to home
    if not robot.back() then --if unable to move, such as block or entity in way
      robot.turnAround()
      robot.swing()
      robot.turnAround()
    end
  end
  robot.setLightColor(0xFF0000) --red
  print("Dropping items...")
  dropInventoryDown()
end
--eof
