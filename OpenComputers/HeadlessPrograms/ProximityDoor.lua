--[[
Proximity door by Gangsir
To use, provide how long to stay open, and a list of acceptable entities for the door to open in args.
ex: door 5 Gangsir dan200 Sangar
requires a motion detector attached to the computer, and a redstone card.
Headless, screen not needed after run
If door is too large for one detector, multiple can be used
Switches:
-a : Accept all mode, opens for any motion
-i : Inverted mode, turns off redstone on detect, good for piston doors
-b : Blacklist mode, prevents entity on blacklist from opening the door, accepts all others
-l : Logs all door activity to a file.
--]]

component = require("component")
redstone = component.redstone
sides = require("sides")
event = require("event")
io = require("io")

--set Sensitivity of all connected motion detectors
for address in component.list("motion_sensor", true) do
  local dev = component.proxy(address)
  dev.setSensitivity(0.2)
end

--change these to your liking, default is good, however ----------
local range = 3 --distance away from motion sensor to check
local side = sides.top --side to output redstone to
local logFilePath = "/usr/misc/doorLog.txt" --where to save log, if logging is on
--end user variables ---------------------------------------------


allowed = {} --holds whitelist of players/entities
banned = {} --holds blacklist, if in use
local acceptableEntities, options = require("shell").parse(...)
if type(tonumber(acceptableEntities[1])) ~= "number" then error("Please provide time for door to stay open as the first arg.") end
local stayOpen = tonumber(acceptableEntities[1])

if options.a and options.b then error("You can't accept all and have a blacklist. Remove one or the other.") end

if options.l then
  print("Logging is on, logging all attempted entries into door, in file "..logFilePath)
  if not require("filesystem").exists(logFilePath) then --if non existant log file, create new
    print("Log file does not exist, creating new at "..logFilePath)
    local file = assert(io.open(logFilePath,"w"),"Failed to open new file. Things won't work.")
    file:close()
  end
end

if not options.a then --if not accept all mode
  if #acceptableEntities <= 1 then error("Someone needs to be on the list!") end
  table.remove(acceptableEntities,1) --remove time from list of entities
  print("Listing names of provided entities: ")
  --add list of players to lookup list
  if not options.b then --if using list as whitelist
    print("Running in whitelist mode, whitelisting provided names...")
    for _,name in pairs(acceptableEntities) do
      allowed[name] = true --set value in table to true, for quick lookup later
      print("Allowed: "..name) --print the name of the registered entity
    end
  else --whitelist acts as blacklist
    print("Running in blacklist mode, blacklisting provided names...")
    for _,name in pairs(acceptableEntities) do
      banned[name] = true --set value in table to true, for quick lookup later
      print("Banned: "..name) --print the name of the registered entity
    end
  end
else
  print("Running in accept all mode, door opens for any motion.")
end

--toggles current output of redstone on and off, returns new state as bool
function toggleRedstone()
  if redstone.getOutput(side) >=1 then
    redstone.setOutput(side,0)
    return false
  else
    redstone.setOutput(side,15)
    return true
  end
end

function logAttempt(entity,perm)
  local file = assert(io.open(logFilePath,"a"),"Failed to open existing file, Things won't work.") --opens the file to append
  assert(file:write("Door Access: "..entity.."| Permission: "..perm.."| Ingame Time: "..os.date().."\n")) --writes data about attempt to file
  file:close()
end

if options.i then --if running inverted mode, keep redstone on by default
  redstone.setOutput(side,15)
  print("Running in inverted mode, redstone turns off on detect.")
else
  redstone.setOutput(side,0)
end

print("Program setup complete. You may now remove all graphics components. Door will toggle state for "..tostring(stayOpen).." seconds on detection.")
while true do
  local _,_,x,y,z,entity = event.pull("motion")
  if math.abs(x)<= tonumber(range) and math.abs(y)<= tonumber(range) and math.abs(z)<= tonumber(range) then --if recieved motion was within range
    if options.a or allowed[entity] or (options.b and banned[entity]==nil) then --if entity is on whitelist, or accept all mode is on, or not banned
      if options.l then logAttempt(entity,"Yes") end --log the door attempt
      toggleRedstone()
      os.sleep(stayOpen) --manipulate door
      toggleRedstone()
    else
      print("Banned entity "..entity.." tried opening the door!") --print for security logs
      if options.l then logAttempt(entity,"No") end --log the door attempt
    end
  end
end
--eof
