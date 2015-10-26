--[[
Gangsir's base info getter OpenComputers port
Not all must be connected, as the program will limit itself to only what is present.
Needs at least 1.5 tier RAM, tier 2 graphics and screen, and TankNut's interface library.
The program will auto fetch the interface if an internet card is found. It can also be found at:
https://raw.githubusercontent.com/OpenPrograms/MiscPrograms/master/TankNut/interface.lua
Uses port 21481 by default.
Writes file to /usr/misc/clientAddress.txt by default
--]]

--requires
local term = require("term")
local component = require("component")
local os = require("os")
port = 21481 --port the wireless part should use
gui = nil

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

if(component.gpu.getDepth()<2) then
  error("Graphics are not sufficient to run this program. Requires tier 2 or higher.")
end

local maxX, maxY = 60, 25
component.gpu.setResolution(maxX,maxY) --Set the resolution to make text more visible, even on powerful screens.


--check for presence of gui library
if require("filesystem").exists("/lib/interface.lua") then
  gui = require("interface")
elseif component.isAvailable("internet") then
  print("Gui lib not found, internet card installed, trying to auto-fetch.")
  os.execute("wget https://raw.githubusercontent.com/OpenPrograms/MiscPrograms/master/TankNut/interface.lua /lib/interface.lua")
  print("Computer needs to reboot to note changes to available libs, rebooting in 3 seconds...")
  os.sleep(3)
  require("computer").shutdown(true) --reboots the computer
else
  error("TankNut's GUI framework must be present and available to use this program. Download from his github at openprograms, and place in /lib, or install an internet card.")
end


--sets up the tablet to receive info
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

for tempaddress,type in component.list("tile_thermalexpansion_cell") do ecAdd = tempaddress end --check for anything called tile_thermalexpansion_cell
if ecAdd ~= nil then
  cap1 = component.proxy(ecAdd)
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

--setup for gui
gui.clearAllObjects()
--energy
gui.newLabel("totpow","Total Power: ",0,0,maxX,1,0xFF0000)
gui.newLabel("reactpow","Reactor Power: ",0,3,maxX,1,0xFF0000)
gui.newLabel("reacton","Reactor Running: ",0,5,maxX,1,0xFF0000)
gui.newLabel("powatick","Power Per Tick: ",0,7,maxX,1,0xFF0000)
gui.newLabel("powstorage","Power Storage: ",0,9,maxX,1,0xFF0000)
--tank
gui.newLabel("contents","Current Tank Contents:",0,11,maxX,1,0x0000FF)
gui.newLabel("amount","Amount:",0,13,maxX,1,0x0000FF)
gui.newLabel("percentfill","Percent Filled:",0,15,maxX,1,0x0000FF)
gui.newLabel("barbanner","Tank Percentage Full Bar",0,18,maxX,1,0x0000FF)
gui.newBar("tankbar",5,19,maxX-10,1,0x333333,0xCCCCCC,0) --tank progress bar
--alerts
gui.newLabel("alertsbanner","Alerts: ----------------",0,21,maxX,1,0x000000)
gui.newLabel("reactfuel","",0,23,maxX,1,0x000000)
gui.newLabel("powstorelow","",0,25,maxX,1,0x000000)


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
   gui.setLabelText("contents","Current Tank Contents: Tank is Empty.")
   if hasModem then modem.send(tabletAddress,port,"Tank Empty.") end
  else --if the tank has a liquid in it

   pcall(function() amount = info[1]["contents"]["amount"] end) --gets the amount of liquid in millibuckets
   local contentName = "Current Tank Contents: "..tostring(name)
   gui.setLabelText("contents",contentName)
   if hasModem then modem.send(tabletAddress,port,contentName) end --Send the tank's liquid content

   local amountS = "Amount: "..tostring(amount).."/"..tostring(info[1]["capacity"])
   if hasModem then modem.send(tabletAddress,port,amountS) end --Send the tank's liquid content
   gui.setLabelText("amount",amountS) --print the data about the amount of liquid

   local tankPercent = tostring((amount / info[1]["capacity"] )*100)
   gui.setBarValue("tankbar",tonumber(tankPercent)) --update the bar
   local percentFilled = "Percent Filled: "..tankPercent.."%"
   gui.setLabelText("percentfill",percentFilled)
   if hasModem then modem.send(tabletAddress,port,percentFilled) end --Send the tank's liquid content
  end
end

function manageReactor() --manage the reactor
  react.setActive(true)
  react.setAllControlRodLevels(require("math").floor(react.getEnergyStored()/100000)) --adjusts the fuel rods based on stored energy
end

function alerts() --shows any problems with connected components
 if hasModem then modem.send(tabletAddress,port,"Alerts: ----------------") end
 if hasReactor then --only alert if reactor is present
  if react.getFuelAmount() < react.getFuelAmountMax()-react.getWasteAmount() then
   gui.setLabelText("reactfuel","Reactor needs fuel!") --if the reactor is low on fuel, or very full of waste
   require("computer").beep(100,1) --beep to alert players
   if hasModem then modem.send(tabletAddress,port,"REACTOR NEEDS FUEL",false,true) end --alerts the tablet user that the reactor needs fuel
  else
    gui.setLabelText("reactfuel","") --remove warning
  end --if react.getFuelAmount...
 end --if has reactor


 if hasPowerBank then --only alert if power bank is present
  if cap1.getEnergyStored()<(cap1.getMaxEnergyStored()/10) then --if capacitor bank is nearly empty, <10% left
   gui.setLabelText("powstorelow","Power Storage is low!")
   require("computer").beep(100,1)
   if hasModem then modem.send(tabletAddress,port,"POWER STORAGE LOW",false,true) end --alerts the tablet user that the reactor needs fuel
  else
    gui.setLabelText("powstorelow","") --remove warning
  end --if cap1.getEnergyStored...

 end --if hasPowerBank
end --function alerts

function refresh() --refreshes the screen with new data
 if hasReactor and hasPowerBank then
  local totalPow = cap1.getEnergyStored()+react.getEnergyStored()
  gui.setLabelText("totpow","Total Power: "..tostring(totalPow))
  if hasModem then modem.send(tabletAddress,port,totalPowS) end
 end
 if hasReactor then
  local reactPow = "Reactor Power: "..react.getEnergyStored()
  gui.setLabelText("reactpow",reactPow)
  if hasModem then modem.send(tabletAddress,port,reactPow) end

  local reactOn = "Reactor Activated: "..tostring(react.getActive())
  gui.setLabelText("reacton",reactOn)
  if hasModem then modem.send(tabletAddress,port,reactOn) end

  local currentPowerTick = "Current power per tick: "..react.getEnergyProducedLastTick()
  gui.setLabelText("powatick",currentPowerTick)
  if hasModem then modem.send(tabletAddress,port,currentPowerTick) end
 end --if hasReactor
 if hasPowerBank then

  local powerStore = "Power Storage: "..cap1.getEnergyStored()
  gui.setLabelText("powstorage",powerStore)
  if hasModem then modem.send(tabletAddress,port,powerStore) end
 end --if hasPowerBank
end --function refresh

while true do
  --get new data for everything
 os.sleep(refreshrate) --wait for specified time
 if hasModem then modem.send(tabletAddress,port,"",true) end --clear the tablet
 refresh()
 alerts()
 if hasReactor then manageReactor() end --manage the reactor, making sure no power is wasted
 if hasTank then scanTank() end --scan and print info about the attached drum.

 gui.updateAll()
end
--eof
