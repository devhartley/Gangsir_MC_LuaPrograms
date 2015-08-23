--[[
Gangsir's base info getter OpenComputers port
Not all must be connected, as the program will limit itself to only what is present.
Needs at least 1.5 tier RAM.
Uses port 21481 by default.
--]]

--requires
local term = require("term")
local component = require("component")
local os = require("os")
port = 21481 --port the wireless part should use

--component connected variables
react = nil
cap1 = nil
tank = nil
modem = nil
hasPowerBank = false
hasReactor = false
hasTank=false
hasModem = false
tabletAddress = ""

xres,yres = component.gpu.getResolution() --get the resolution of the current setup <unused>

--begin program
local pargs = {...}
local refreshrate=pargs[1] or 5 --allows setting to a lower refresh rate to reduce strain, 5 if not specified
local totalPow = 0

print("Base info running...") --intro screen
print("Initialising program and scanning components...")
--Check for connected components.
if component.isAvailable("modem") then
  print("Network Card found. Note:Do not include a wireless card unless trying to use my tablet client, will cause issues.")
  hasModem = true
  modem = component.modem
  modem.open(port)
  modem.setStrength(400)
  print("Waiting for tablet client to send address. Please run the client on your tablet.")
  local _,_,_,_,message = require("event").pull("modem") --waits for the tablet message
  tabletAddress = message --sets the client's address
  os.sleep(1)
  print("Sending self address back to tablet...")
  modem.send(tabletAddress,port,"*") --sends self address, so tablet can stop broadcasting
end
if component.isAvailable("br_reactor") then --check if a reactor is connected
  print("Big Reactors(tm) Reactor found.")
  hasReactor=true
  react = component.br_reactor --access the reactor
end
--check if power storage is connected
if component.isAvailable("tile_blockcapacitorbank_name") then
  print("Ender IO(tm) Capacitor bank found.")
  cap1 = component.tile_blockcapacitorbank_name
  hasPowerBank =true
end
if component.isAvailable("basic_energy_cube") then
  print("Mekanism(tm) basic energy cube found.")
  cap1 = component.basic_energy_cube
  hasPowerBank =true
end
if component.isAvailable("advanced_energy_cube") then
  print("Mekanism(tm) advanced energy cube found.")
  cap1 = component.advanced_energy_cube
  hasPowerBank =true
end
if component.isAvailable("elite_energy_cube") then
  print("Mekanism(tm) elite energy cube found.")
  cap1 = component.elite_energy_cube
  hasPowerBank =true
end
if component.isAvailable("ultimate_energy_cube") then
  print("Mekanism(tm) ultimate energy cube found.")
  cap1 = component.ultimate_energy_cube
  hasPowerBank =true
end
--Check if a tank is connected
if component.isAvailable("drum") then --check if a drum is connected
  print("Extra Utilites(tm) drum found.")
  hasTank=true
  tank = component.drum --access the drum
end
if component.isAvailable("tank") then --check if a tank is connected
  print("Ender IO(tm) fluid tank Found.")
  hasTank=true
  tank = component.tank --access the tank
end
if component.isAvailable("portable_tank") then --check if a portable tank is connected
  print("Mekanism(tm) portable tank Found.")
  hasTank=true
  tank = component.portable_tank --access the tank
end

os.sleep(2) --sleep to allow reading of init page
--Define functions

function scanTank()
  term.setCursor(1,11)
  name = nil
  amount = nil --flush data
  info = nil

  info = tank.getTankInfo()

  --use pcall so code doesn't crash with empty tank (Really shouldn't crash, just print nil, but that's just my opinion)
  pcall(function() name = info[1]["contents"]["rawName"] or nil end)
  if name == nil then --if tank liquid name is nil, thus is empty/invalid fluid
   term.setCursor(1,11)
   print("Tank is Empty.")
  else --if the tank has a liquid in it
  term.setCursor(1,12)
  pcall(function() amount = info[1]["contents"]["amount"] end) --gets the amount of liquid in millibuckets
  local contentName = "Current tank contents: "..tostring(name)
  print(contentName) --prints out the name of the tank's contents
  if hasModem then modem.send(tabletAddress,port,) end --Send the tank's liquid content
  term.setCursor(1,13)
  local amountS = "Amount: "..tostring(amount).."/"..tostring(info[1]["capacity"])
  if hasModem then modem.send(tabletAddress,port,amountS) end --Send the tank's liquid content
  print(amountS) --print the data about the amount of liquid
  term.setCursor(1,14)
  local percentFilled = "Percent Filled: "..tostring((amount / info[1]["capacity"] )*100).."%"
  print(percentFilled)
  if hasModem then modem.send(tabletAddress,port,percentFilled) end --Send the tank's liquid content
  end
end

function manageReactor() --a mini bare-bones version of my reactor controller, to manage the reactor
 if react.getEnergyStored()>=7000000 then
    react.setActive(false) --turns off the reactor.
 end
 if react.getEnergyStored()<=5000 then
   react.setActive(true)
 end
end

function alerts() --shows any problems with connected components
 term.setCursor(1,6)
 print("Alerts: ----------------")
 if hasModem then modem.send(tabletAddress,port,"Alerts: ----------------") end
 if hasReactor then --only alert if reactor is present
  if react.getFuelAmount() < react.getFuelAmountMax()-react.getWasteAmount() then
   term.setCursor(1,8)
   print("Reactor needs fuel!") --if the reactor is low on fuel, or very full of waste
   require("computer").beep(100,2) --beep to alert players
   if hasModem then modem.send(tabletAddress,port,"REACTOR NEEDS FUEL") end --alerts the tablet user that the reactor needs fuel
  end
 end
 if hasPowerBank then --only alert if power bank is present
  if cap1.getEnergyStored()<(cap1.getMaxEnergyStored()/10) then --if capacitor bank is nearly empty, <10% left
   term.setCursor(1,9)
   print("Power Storage is low!")
   require("computer").beep(100,2)
   if hasModem then modem.send(tabletAddress,port,"POWER STORAGE LOW") end --alerts the tablet user that the reactor needs fuel
  end
 end
end

function refresh() --refreshes the screen with new data
 if hasReactor and hasPowerBank then
  totalPow = cap1.getEnergyStored()+react.getEnergyStored()
  term.setCursor(1,4)
  local totalPowS = "Total Power: "..totalPow
  print(totalPowS)
  if hasModem then modem.send(tabletAddress,port,totalPowS.."\n\n") end
 end
 if hasReactor then
  term.setCursor(1,1)
  local reactPow = "Reactor Power: "..react.getEnergyStored()
  print(reactPow)
  if hasModem then modem.send(tabletAddress,port,reactPow) end
  term.setCursor(1,2)
  local reactOn = "Reactor Activated: "..tostring(react.getActive())
  print(reactOn)
  if hasModem then modem.send(tabletAddress,port,reactOn) end
  term.setCursor(1,5)
  local currentPowerTick = "Current power per tick: "..react.getEnergyProducedLastTick()
  print(currentPowerTick)
  if hasModem then modem.send(tabletAddress,port,currentPowerTick) end
 end
 if hasPowerBank then
  term.setCursor(1,3)
  local powerStore = "Power Storage: "..cap1.getEnergyStored()
  print(powerStore)
  if hasModem then modem.send(tabletAddress,port,powerStore) end
 end
end

while true do
  --get new data for everything
 os.sleep(refreshrate) --sleep for the specified time
 term.clear()
 refresh()
 alerts()
 if hasReactor then manageReactor() end --manage the reactor, making sure no power is wasted
 if hasTank then scanTank() end --scan and print info about the attached drum.
end
--eof
