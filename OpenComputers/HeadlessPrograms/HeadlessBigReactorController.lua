--Headless reactor management program
local component = require("component")
local os = require("os")
local computer = require("computer")
local react = component.br_reactor

computer.beep(100,0.2)
computer.beep(2000,1)
require("term").clear()

while true do
  os.sleep(3)
  react.setAllControlRodLevels(math.floor(react.getEnergyStored()/100000)) --adjusts production according to use
  while react.getFuelAmount() < react.getFuelAmountMax()-react.getWasteAmount() do --if reactor needs fuel, or is full of waste
    react.setActive(false) --turns off the reactor
    computer.beep(2000,1) --beep to alert players
    os.sleep(0.2)
  end
  if not react.getActive() then react.setActive(true) end --turn it on again if it was off.
end
--eof
