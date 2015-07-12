local directions = {...}
local reactor = peripheral.wrap(directions[1])

if directions[1] == nil then
  print("Usage: Provide dir of reactor, and modem if applicable.")
  return nil
end

if peripheral.isPresent(directions[2]) then rednet.open(directions[2]) end --activates rednet on the available modem.

while true do
  print("Energy Stored: "..reactor.getEnergyStored())
  if reactor.getEnergyStored()>=7000000 then
    reactor.setActive(false) --turns off the reactor.
    if peripheral.isPresent(directions[2]) then
      rednet.broadcast("Disabling Reactor.")  
    end
  end
  sleep(5)
  if reactor.getEnergyStored()<=5000 then
    reactor.setActive(true)
    if peripheral.isPresent(directions[2]) then
      rednet.broadcast("Activating Reactor.")  
    end
  end
  sleep(10)
end