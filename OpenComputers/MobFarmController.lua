--[[
Gangsir's mob farm controller
Sirdabalot's gui framework required for use. Gui lib can be found at
https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua
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

--check if screen is correct
if component.gpu.getDepth() ~= 4 then
  error("Screen/gpu does not meet graphics requirements.")
end
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
if require("filesystem").exists("/lib/SOCGUIF.lua") then
  gui = require("SOCGUIF")
elseif component.isAvailable("internet") then
  print("Gui lib not found, internet card installed, trying to auto-fetch.")
  os.execute("wget https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua /lib/SOCGUIF.lua")
  print("Computer needs to reboot to note changes to available libs, rebooting in 3 seconds...")
  os.sleep(3)
  computer.shutdown(true) --reboots the computer
else
  error("sirdabalot's GUI framework must be present and available to use this program. Download from his github, and place in /lib, or install an internet card.")
end

if not require("filesystem").exists("/lib/SOCGUIF.lua") then --if the library is still unloadable
  error("Still can't load the library, program won't work.")
end

--init all functions

--sets the state of all outputs, returns new output. Provide nil for state if setting to manual value
local function setAllStates(state,value)
  if state then
    redstone.setBundledOutput(outputSide,colors.red,15)
    redstone.setBundledOutput(outputSide,colors.white,15)
    redstone.setBundledOutput(outputSide,colors.orange,15)
    redstone.setBundledOutput(outputSide,colors.black,15)
    computer.beep(1500,1)
    if value == nil then return 15 end
  end
  if state == false then
    redstone.setBundledOutput(outputSide,colors.red,0)
    redstone.setBundledOutput(outputSide,colors.white,0)
    redstone.setBundledOutput(outputSide,colors.orange,0)
    redstone.setBundledOutput(outputSide,colors.black,0)
    computer.beep(200,1)
    if value == nil then return 0 end
  end
  if value ~= nil and value < 16 then
    redstone.setBundledOutput(outputSide,colors.red,value)
    redstone.setBundledOutput(outputSide,colors.white,value)
    redstone.setBundledOutput(outputSide,colors.orange,value)
    redstone.setBundledOutput(outputSide,colors.black,value)
    return value
  end
end

--toggles output on specified colour, returns boolean based on success
local function toggle(color)
  if redstone.getBundledOutput(outputSide,color) == 15 then
    redstone.setBundledOutput(outputSide,color,0)
    computer.beep(200,0.3)
    return true
  else
    redstone.setBundledOutput(outputSide,color,15)
    computer.beep(1500,0.3)
    return true
  end
  return false
end

--init gui
setAllStates(false) --turns all outputs off

window1 = window(point(0,0),maxX,maxY,"Buttons",0xFFFFFF,0x000000) --fill the whole screen with a window
table.insert(windowTable,window1)

--button args are window,startpoint,width,height,label,forecolour, backcolour,function
msButton = button(window1,point(5,2),17,9,"Mob Spawner",0x000000,0xFF0000,function() toggle(colors.red) end) --top left
lightsButton = button(window1,point(5,14),17,9,"Lights",0x000000,0xFFFFFF,function() toggle(colors.white) end) --bottom left
doorButton = button(window1,point(27,2),17,9,"Door",0x000000,0x0000CC,function() toggle(colors.orange) end) --top middle
killButton = button(window1,point(27,14),17,9,"Kill",0xFFFFFF,0x8E01E8,function() toggle(colors.black) end) --bottom middle

allOn = button(window1,point(48,2),29,9,"All On",0xFFFFFF,0x00FF00,function() setAllStates(true) end)
allOff = button(window1,point(48,14),29,9,"All Off",0xFFFFFF,0xFF0000,function() setAllStates(false) end)

require("term").clear()

--show the gui
GUILoop(0x000000)
--eof
