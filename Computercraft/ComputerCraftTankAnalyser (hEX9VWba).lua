--Gangsir's tank analyser
--To use, provide the side of the monitor, and tank in the running args, respectively.
--Monitor should be at least 2x2
local pargs = {...}
local monitor = peripheral.wrap(pargs[1])
local tank = peripheral.wrap(pargs[2])
name = nil
amount = nil --flush data
info = nil
if tank == nil then
 error("Ain't no tank there, son.")
 return nil
end
if monitor == nil then
 error("Ain't no monitor there, son.")
 return nil
end

monitor.setTextScale(0.5)
monitor.setCursorPos(1,1)

while true do
 name = nil
 amount = nil --flush data
 info = nil
 
 info = tank.getTankInfo()
 
 --use pcall so code doesn't crash with empty tank
 pcall(function() name = info[1]["contents"]["rawName"] or nil end)
 monitor.clear() --clear the monitor, removing any artefacts
 
 if name == nil then --if tank liquid name is nil, thus is empty
  monitor.setCursorPos(1,1)
  monitor.write("Tank is Empty.")
 else --if the tank has a liquid in it
  monitor.setCursorPos(1,1)
  pcall(function() amount = info[1]["contents"]["amount"] end)
  monitor.write("Current tank contents: "..name) --prints out the name of the tank's contents
  monitor.setCursorPos(1,3)
  monitor.write("Amount: "..tostring(amount).."/"..tostring(info[1]["capacity"]))
  monitor.setCursorPos(1,5)
  monitor.write("Percent Filled: "..tostring((amount / info[1]["capacity"] )*100))
 end
 sleep(15) --slow update, as most tanks don't update that often. You can set lower if you wish.
end