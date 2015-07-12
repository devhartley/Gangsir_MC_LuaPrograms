--Gangsir's gui Program launcher
--To use, ensure you have the gui library made by sirdabalot for opencomputers in the /lib folder.
--his gui program can be found at https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua
--then, add my three programs, midpoint, distance and volume to the /prog folder. You will need to create this.
--This program was made to run with a tier 2 graphics card and screen. Must have touch capabilities.

gui = require("SOCGUIF")
computer = require("computer")
term = require("term")
os = require("os")
guix, guiy = require("component").gpu.getResolution() 

mainwindow = window(point(0,0),guix,guiy,"Main",0x000000,0x000000)
table.insert(windowTable,mainwindow)

function midpoint() 
 computer.beep()
 term.clear()
 os.execute("/prog/midpoint.lua")
 term.read() --pause so result can be read
end

function distance()
 computer.beep()
 term.clear()
 os.execute("/prog/distance.lua")
 term.read()
end

function volume()
 computer.beep()
 term.clear()
 os.execute("/prog/volume.lua")
 term.read()
end 

function exit()
 term.clear()
 os.exit() --exit to terminal, for launching other programs
end

function runlua()
 computer.beep()
 term.clear()
 os.execute("lua")
end

midbutton = button(mainwindow,point(guix/2-10,3),10,3,"Midpoint",0x000000,0x0000FF,midpoint)
disbutton = button(mainwindow,point(guix/2-10,5),10,3,"Distance",0x000000,0x0000FF,distance)
volbutton = button(mainwindow,point(guix/2-10,7),10,3,"Volume",0x000000,0x0000FF,volume)
luabutton = button(mainwindow,point(guix/2-20,9),20,3,"Lua Interp",0x000000,0x0000FF,runlua)

exitbutton = button(mainwindow,point(0,13),10,3,"Exit",0x000000,0xFF0000,exit)

GUILoop(0x000000) --display everything
--eof