--[[
Gangsir's base info getter
To use this program, connect a monitor, a Big Reactor, an EnderIO capacitor bank to a computer. You can add more things to watch if you wish. If you already have a CC network elsewhere, you may need to change names in the code below.
--]]

local mon = peripheral.wrap("monitor_0") --Monitor to display things to, should be at least 2x4
local react = peripheral.wrap("BigReactors-Reactor_0")
local cap1 = peripheral.wrap("tile_blockcapacitorbank_name_0") --EnderIO Cap bank
local pargs = {...}
local refreshrate=pargs[1] or 5
local totalPow = 0

mon.setTextScale(0.5)
print("Base info running...")

function refresh()
 totalPow = cap1.getEnergyStored()+react.getEnergyStored()
 mon.setCursorPos(1,1)
 mon.write("Reactor Power: "..react.getEnergyStored())
 mon.setCursorPos(1,3)
 mon.write("Reactor Activated: "..tostring(react.getActive()))
 mon.setCursorPos(1,5)
 mon.write("Power Storage: "..cap1.getEnergyStored())
 mon.setCursorPos(1,7) 
 mon.write("Total Power: "..totalPow)
end 

while true do 
 sleep(refreshrate) 
 mon.clear()
 refresh()
end