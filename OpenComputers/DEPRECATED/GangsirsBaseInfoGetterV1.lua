--[[
THIS PROGRAM IS NOW DEPRECATED, AVOID USING AS MANY THINGS ARE PROBABLY BROKEN.
Gangsir's base info getter OpenComputers port
Not all must be connected, as the program will limit itself to only what is present.
Needs at least 1.5 tier RAM.
Uses port 21481 by default.
Writes file to /usr/misc/clientAddress.txt by default
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
filePath = "/usr/misc/clientAddress.txt"
--xres,yres = component.gpu.maxResolution() --get the resolution of the current setup <unused>
component.gpu.setResolution(50,16) --Set the resolution to make text more visible, even on powerful screens.

function setupTablet()
  print("Checking for pre-existing tablet...")
  if require("filesystem").exists(filePath) then
   print("Tablet address found.")
   local file = assert(io.open(filePath,"r"),"Failed to open existing file. Things won't work.")
   tabletAddress = file:read() --grab the home address from the file.
   file:close()
  else
   print("Finding tablet...") --gets the address of the new computer home
   print("Waiting for tablet client to send address. Please run the client on your tablet.")
   local _,_,sender,_,_,message = require("event").pull("modem") --waits for the tablet message
   tabletAddress = message --sets the client's address
   os.sleep(1)
   print("Sending self address back to tablet...")
   modem.send(tabletAddress,port,"*") --sends self address, so tablet can stop broadcasting
   print("Tablet acquired. Address is "..sender)
   tabletAddress = tostring(sender)
   local file = assert(io.open(filePath,"w"),"Failed to open new file. Things won't work.")
   assert(file:write(sender)) --writes home to file, for persistance.
   file:close()
   print("New client written to file.")
  end
end

--begin program
local pargs = {...}
local refreshrate=tonumber(pargs[1]) or 5 --allows setting to a lower refresh rate to reduce strain, 5 if not specified
local totalPow = 0

print("Base info running...") --intro screen
print("Initialising program and scanning components...")
--Check for connected components.
if component.isAvailable("modem") then
  print("Network Card found.")
   hasModem = true
   modem = component.modem
   modem.open(port)
   setupTablet() --set up the wireless tablet
   if component.isAvailable("relay") then component.relay.setStrength(400) end --max out the relay
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
--find mekanism energy cubes, as power storage
for tempaddress,type in component.list("energy_cube") do ecAdd = tempaddress end --check for anything called energy_cube
if ecAdd ~= nil then
  cap1 = component.proxy(ecAdd)
  hasPowerBank = true
  print("Mekanism(tm) energy cube found.")
end
if component.isAvailable("tile_thermalexpansion_cell_basic_name") then --look for thermal expansion power storage
  cap1 = component.tile_thermalexpansion_cell_basic_name
  hasPowerBank = true
  print("Thermal expansion energy cell found.")
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
   if hasModem then modem.send(tabletAddress,port,"Tank Empty.") end
  else --if the tank has a liquid in it
  term.setCursor(1,12)
  pcall(function() amount = info[1]["contents"]["amount"] end) --gets the amount of liquid in millibuckets
  local contentName = "Current tank contents: "..tostring(name)
  print(contentName) --prints out the name of the tank's contents
  if hasModem then modem.send(tabletAddress,port,contentName) end --Send the tank's liquid content
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
   require("computer").beep(100,1) --beep to alert players
   if hasModem then modem.send(tabletAddress,port,"REACTOR NEEDS FUEL",false,true) end --alerts the tablet user that the reactor needs fuel
  end
 end
 if hasPowerBank then --only alert if power bank is present
  if cap1.getEnergyStored()<(cap1.getMaxEnergyStored()/10) then --if capacitor bank is nearly empty, <10% left
   term.setCursor(1,9)
   print("Power Storage is low!")
   require("computer").beep(100,1)
   if hasModem then modem.send(tabletAddress,port,"POWER STORAGE LOW",false,true) end --alerts the tablet user that the reactor needs fuel
  end
 end
end

function refresh() --refreshes the screen with new data
 if hasReactor and hasPowerBank then
  totalPow = cap1.getEnergyStored()+react.getEnergyStored()
  term.setCursor(1,4)
  local totalPowS = "Total Power: "..totalPow
  print(totalPowS)
  if hasModem then modem.send(tabletAddress,port,totalPowS) end
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
 if hasModem then modem.send(tabletAddress,port,"",true) end --clear the tablet
 refresh()
 alerts()
 if hasReactor then manageReactor() end --manage the reactor, making sure no power is wasted
 if hasTank then scanTank() end --scan and print info about the attached drum.
end
--eof
