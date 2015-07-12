--Gangsir's base info getter OpenComputers port
--This program requires the computer is connected to a Big Reactors(R) reactor, and an Ender IO Capacitor bank.
--Needs at least 1.5 tier RAM.

local term = require("term")
local component = require("component")
local react = component.br_reactor
local os = require("os")
local cap1 = component.tile_blockcapacitorbank_name --(Note: Capacitor bank will require adapter)

local pargs = {...}
local refreshrate=pargs[1] or 5 --allows setting to a lower refresh rate to reduce strain, 5 if not specified
local totalPow = 0

print("Base info running...") --intro screen
--Define functions

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
 if react.getFuelAmount() < react.getFuelAmountMax()-react.getWasteAmount() then
  term.setCursor(1,8)
  print("Reactor needs fuel!") --if the reactor is low on fuel, or very full of waste
 end
 if cap1.getEnergyStored()<1000000 then --if capacitor bank is nearly empty
  term.setCursor(1,9)
  print("Power Storage is low!")
 end
end

function refresh() --refreshes the screen with new data
 totalPow = cap1.getEnergyStored()+react.getEnergyStored()
 term.setCursor(1,1)
 print("Reactor Power: "..react.getEnergyStored())
 term.setCursor(1,2)
 print("Reactor Activated: "..tostring(react.getActive()))
 term.setCursor(1,3)
 print("Power Storage: "..cap1.getEnergyStored())
 term.setCursor(1,4)
 print("Total Power: "..totalPow)
 term.setCursor(1,5)
 print("Current power per tick: "..react.getEnergyProducedLastTick())
end

while true do
 os.sleep(refreshrate)
 term.clear()
 refresh()
 alerts()
 manageReactor()
end