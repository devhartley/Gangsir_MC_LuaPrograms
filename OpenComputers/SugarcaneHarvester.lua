--[[
Gangsir's simple Sugarcane harvester robot program. To use, provide the length of the farm in the program arguments.
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
(For example, to run the program with this config you would provide 6 for the program argument)
Chest goes on bottom of robot for output, robot needs to be 1 block off the ground.
Light colors are blue for waiting, green for harvesting, and red for dropping items.
--]]

local component = require("component")
local robot = require("robot")
local pargs ={...}

length=tonumber(pargs[1])
if length == nil then error("Provide length of Sugarcane rows in program args.") end
print("Light colors are blue for waiting, green for harvesting, and red for dropping items.")

--makes like skrillex and drops the (bass)inventory down
function dropInventoryDown()
  for i = 1, robot.inventorySize() do --drop entire inventory
    robot.select(i)
    robot.dropDown()
  end
  robot.select(1)
end
--main driving loop
while true do
  robot.setLightColor(0x0000FF) --blue
  print("Waiting...")
  while true do
    local _,block = robot.detect()
    if block ~= "air" then break end --start running
    os.sleep(3)
  end
  robot.setLightColor(0x00FF00) --green
  print("Harvesting...")
  robot.swing()
  if not robot.forward() then robot.swing() robot.forward() end --if it still can't move, swing again
  local blocksForward = 1 --how many blocks the robot has moved forward
  for a = 1,length do --move forward and chop down Sugarcane
    robot.swing()
    robot.turnLeft()
    robot.swing()
    robot.turnRight()
    if not robot.forward() then --if unable to move, such as block or entity in way
      robot.swing()
      a = a-1
    end
    robot.suckDown()
    blocksForward = blocksForward+1
  end
  for b = 1,blocksForward do --move back to home
    if not robot.back() then --if unable to move, such as block or entity in way
      robot.turnAround()
      robot.swing()
      robot.turnAround()
      b = b-1
    end
  end
  blocksForward=0
  robot.setLightColor(0xFF0000) --red
  print("Dropping items...")
  dropInventoryDown()
end
--eof
