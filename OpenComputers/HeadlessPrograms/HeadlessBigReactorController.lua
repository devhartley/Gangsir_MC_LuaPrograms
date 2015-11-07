--Headless reactor management program
local component = require("component")
local os = require("os")
local computer = require("computer")
local react = component.br_reactor

os.sleep(1)
computer.beep(100,0.5)
computer.beep(2000,1)
require("term").clear()
print("The program is running. You may now remove any graphics components.")
while true do
  os.sleep(3)
  react.setAllControlRodLevels(math.floor(react.getEnergyStored()/100000)) --adjusts production according to use
  if not react.getActive() then react.setActive(true) end --turn it on again if it was off.
end
--eof
