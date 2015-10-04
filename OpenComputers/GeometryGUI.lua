--Gangsir's gui Program launcher
--To use, ensure you have the gui library made by sirdabalot for opencomputers in the /lib folder, or /usr/lib.
--his gui program can be found at https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua
--Place this library in the /lib folder of the computer.
--This program was made to run with a tier 2 graphics card and screen. Must have touch capabilities.

gui = nil
computer = require("computer")
term = require("term")
os = require("os")
guix, guiy = require("component").gpu.getResolution() --size of screen

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

--set up main window
mainwindow = window(point(0,0),guix,guiy,"Main",0x000000,0x000000)
table.insert(windowTable,mainwindow)

--define functions
function midpoint() --runs my midpoint program
 computer.beep()
 term.clear()
 --first point
 print("First X coord?")
 local x1 = tonumber(require("term").read())
 print("First y coord?")
 local y1 = tonumber(require("term").read())
 print("First z coord?")
 local z1 = tonumber(require("term").read())
 --second point
 print("Second x coord?")
 local x2 = tonumber(require("term").read())
 print("Second y coord?")
 local y2 = tonumber(require("term").read())
 print("Second z coord?")
 local z2 = tonumber(require("term").read())
 --calculations
 midX = (x2-x1)/2
 midY = (y2-y1)/2
 midZ = (z2-z1)/2
 print("The midpoint between ("..x1..","..y1..","..z1..") and ("..x2..","..y2..","..z2..") is ("..midX..","..midY..","..midZ..")")
 print("Press [Enter] when done reading result.")
 term.read() --pause so result can be read
end

function distance() --runs my distance program.
 computer.beep()
 term.clear()
 print("Enter x1.")
 local x1 = tonumber(term.read())
 print("Enter X2.")
 local x2 = tonumber(term.read())
 print("Enter y1.")
 local y1 = tonumber(term.read())
 print("Enter y2.")
 local y2 = tonumber(term.read())
 print("Enter z1.")
 local z1 = tonumber(term.read())
 print("Enter z2.")
 local z2 = tonumber(term.read())
 local math = require("math")
 distance = math.sqrt(((x2-x1)^2)+((y2-y1)^2)+((z2-z1)^2)) --calculate distance using 3d distance formula
 print("The distance from ("..x1..","..y1..","..z1..") and ("..x2..","..y2..","..z2..") is "..distance.." blocks.")
 print("Press [Enter] when done reading result.")
 term.read()
end

function volume() --runs my volume program
 computer.beep()
 term.clear()
 print("(X) length of the rectangular prism?")
 local xLength = require("term").read()
 print("(Z) depth of the rectangular prism?")
 local zLength = require("term").read()
 print("(Y) height of the rectangular prism?")
 local yHeight = require("term").read()
 volume = xLength*yHeight*zLength
 print("There are/is "..volume.." block(s) in the "..xLength.."x"..zLength.."x"..yHeight.." space defined.")
 print("Press [Enter] when done reading result.")
 term.read()
end

function exit() --exits the program.
 term.clear()
 os.exit() --exit to terminal, for launching other programs
end

function runlua() --runs the lua interpreter built into opencomputers
 computer.beep()
 term.clear()
 os.execute("lua")
end

--define buttons
midbutton = button(mainwindow,point(guix/2-10,3),10,3,"Midpoint",0x000000,0x0000FF,midpoint)
disbutton = button(mainwindow,point(guix/2-10,5),10,3,"Distance",0x000000,0x0000FF,distance)
volbutton = button(mainwindow,point(guix/2-10,7),10,3,"Volume",0x000000,0x0000FF,volume)
luabutton = button(mainwindow,point(guix/2-20,9),20,3,"Lua Interp",0x000000,0x0000FF,runlua)

exitbutton = button(mainwindow,point(0,13),10,3,"Exit",0x000000,0xFF0000,exit)

GUILoop(0x000000) --display everything
--eof
