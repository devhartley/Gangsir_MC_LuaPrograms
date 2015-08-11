--Gangsir's base info getter OpenComputers port
--This program can monitor and manage a big Reactors reactor, a extra utilites drum, and or Mekanism/Ender IO power storage.
--Not all must be connected, as the program will limit itself to only what is present.
--Needs at least 1.5 tier RAM.

local term = require("term")
local component = require("component")
react = nil
local os = require("os")
cap1 = nil
tank = nil
--component connected variables
hasPowerBank = false
hasReactor = false
hasDrum=false


--begin program
local pargs = {...}
local refreshrate=pargs[1] or 5 --allows setting to a lower refresh rate to reduce strain, 5 if not specified
local totalPow = 0

print("Base info running...") --intro screen
print("Initialising program and scanning components...")
--Check for connected components.
if not component.br_reactor == nil then --check if a reactor is connected
  print("Big Reactors(tm) Reactor found.")
  hasReactor=true
  react = component.br_reactor --access the reactor
end
--check if power storage is connected
if not component.tile_blockcapacitorbank_name == nil then
  print("Ender IO(tm) Capacitor bank found.")
  cap1 = component.tile_blockcapacitorbank_name
  hasPowerBank =true
end
if not component.basic_energy_cube == nil then
  print("Mekanism(tm) energy cube found.")
  cap1 = component.basic_energy_cube
  hasPowerBank =true
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
   print("Current tank contents: "..name) --prints out the name of the tank's contents
   term.setCursor(1,13)
   print("Amount: "..tostring(amount).."/"..tostring(info[1]["capacity"]))
   term.setCursor(1,14)
   print("Percent Filled: "..tostring((amount / info[1]["capacity"] )*100).."%")
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
 if hasReactor then --only alert if reactor is present
  if react.getFuelAmount() < react.getFuelAmountMax()-react.getWasteAmount() then
   term.setCursor(1,8)
   print("Reactor needs fuel!") --if the reactor is low on fuel, or very full of waste
   require("computer").beep(100,2) --beep to alert players
  end
 end
 if hasPowerBank then --only alert if power bank is present
  if cap1.getEnergyStored()<1000000 then --if capacitor bank is nearly empty
   term.setCursor(1,9)
   print("Power Storage is low!")
   require("computer").beep(100,2)
  end
 end
end

function refresh() --refreshes the screen with new data
 if hasReactor and hasPowerBank then
  totalPow = cap1.getEnergyStored()+react.getEnergyStored()
  term.setCursor(1,4)
  print("Total Power: "..totalPow)
 end
 if hasReactor then
  term.setCursor(1,1)
  print("Reactor Power: "..react.getEnergyStored())
  term.setCursor(1,2)
  print("Reactor Activated: "..tostring(react.getActive()))
  term.setCursor(1,5)
  print("Current power per tick: "..react.getEnergyProducedLastTick())
 end
 if hasPowerBank then
  term.setCursor(1,3)
  print("Power Storage: "..cap1.getEnergyStored())
 end
end

while true do
  --get new data for everything
 os.sleep(refreshrate) --sleep for the specified time
 term.clear()
 refresh()
 alerts()
 if hasReactor then manageReactor() end --manage the reactor, making sure no power is wasted
 if hasDrum then scanTank() end --scan and print info about the attached drum.
end
--eof
