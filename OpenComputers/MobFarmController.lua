--[[
Gangsir's mob farm controller
This program uses TankNut's interface program. Download at
https://github.com/OpenPrograms/MiscPrograms/blob/master/TankNut/interface.lua
If an internet card is present, the program will auto-fetch it.
To set up, connect a bundled redstone cable that OC supports to the computer,
and set colours on other ends to be as follows:
Red:Mob spawner
White:Lights
Orange:Door
Black:Killing Method
I recommend using some type of wireless redstone to avoid having to place cables everywhere.
--]]

os = require("os")
component = require("component")
gui = nil --variable for the gui library
redstone = nil
colors = require("colors")
outputSide = require("sides").bottom --change this if you want to use a different side.
maxX , maxY = component.gpu.maxResolution() --get the size of the resolution
computer = require("computer")

--check if screen is correct, ie tier 2 or greater
if component.gpu.getDepth() < 4 then
  error("Screen/gpu does not meet graphics requirements.")
end
component.gpu.setResolution(80,25) --set the resolution to be correct
component.screen.setTouchModeInverted(true) --inverts touch mode.

if not component.isAvailable("redstone") then
  error("This program requires a connection to a redstone io block or a tier 2 redstone card.")
else
  redstone = component.redstone
end


print("Init mob farm manager...")
os.sleep(1)
print("Connect bundled redstone cables to mob spawner(red), lights(white), door(orange), and killing method(black). Set each machine to be active on the same type of signal.")
print("If the gui messes up and starts turning things off and on again quickly, just reboot the computer and script.")
os.sleep(8)

--check for gui library
if require("filesystem").exists("/lib/interface.lua") then
  gui = require("interface")
elseif component.isAvailable("internet") then
  print("Gui lib not found, internet card installed, trying to auto-fetch.")
  os.execute("wget https://raw.githubusercontent.com/OpenPrograms/MiscPrograms/master/TankNut/interface.lua /lib/interface.lua")
  print("Computer needs to reboot to note changes to available libs, rebooting in 3 seconds...")
  os.sleep(3)
  computer.shutdown(true) --reboots the computer
else
  error("TankNut's GUI framework must be present and available to use this program. Download from his github at openprograms, and place in /lib, or install an internet card.")
end

if not require("filesystem").exists("/lib/interface.lua") then --if the library is still unloadable
  error("Still can't load the library, program won't work.")
end

--init all functions

--toggles output on specified colour, returns boolean based on success
local function toggle(color)
  if redstone.getBundledOutput(outputSide,color) == 15 then
    redstone.setBundledOutput(outputSide,color,0)
    return true
  else
    redstone.setBundledOutput(outputSide,color,15)
    return true
  end
  return false
end

--init gui
redstone.setBundledOutput(outputSide,colors.red,0)
redstone.setBundledOutput(outputSide,colors.white,0)
redstone.setBundledOutput(outputSide,colors.orange,0)
redstone.setBundledOutput(outputSide,colors.black,0)

--setup gui, button args are id,label,x,y,width,function,params,oncolour,offcolour
gui.clearAllObjects()
gui.newButton("mobspawner","Mob Spawner",5,2,17,9,function() toggle(colors.red) end,nil,0x00FF00,0xFF0000,true)
gui.newButton("lights","Lights",5,14,17,9,function() toggle(colors.white) end,nil,0x00FF00,0xFF0000,true)
gui.newButton("door","Door",27,2,17,9,function() toggle(colors.orange) end,nil,0x00FF00,0xFF0000,true)
gui.newButton("kill","Killing",27,14,17,9,function() toggle(colors.black) end,nil,0x00FF00,0xFF0000,true)
API.newLabel("title","Mob Farm",0,0,maxX,3,color) --title label

gui.updateAll()

--check for clicks
while true do
    local _,_,x,y = require("event").pull("touch")
    if x and y then
        gui.processClick(x,y)
    end
end
--eof
