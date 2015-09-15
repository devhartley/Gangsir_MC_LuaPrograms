--OpenComputers port of my reactor control program.
local component = require("component")
local os = require("os")
local reactor = component.br_reactor


while true do
  require("term").clear()
  print("Energy Stored: "..reactor.getEnergyStored())
  if reactor.getEnergyStored()>=7000000 then
    reactor.setActive(false) --turns off the reactor.
  end
  os.sleep(5)
  if reactor.getEnergyStored()<=5000 then
    reactor.setActive(true)
  end
  print("Reactor is running: "..tostring(reactor.getActive()))
  os.sleep(10)
end
