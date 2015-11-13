--[[
Small test of the openperipherals terminal glasses. Displays current ingame time.
--]]

component = require("component")
glass = component.openperipheral_bridge
os = require("os")

glass.addBox(1,1,80,10,0xFFFFFF,0.2)

while true do
  glass.clear()
  time = os.date("TIME: %I:%M %p")
  text = glass.addText(5,2,tostring(time), 0xFF0000)
  glass.sync()
  os.sleep(5)
end
