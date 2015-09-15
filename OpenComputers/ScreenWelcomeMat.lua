--[[
Screen welcome mat program by Gangsir
This program displays the message: Welcome, <Playername>! when the screen is walked on.
Only works one way, the direction the screen was placed in.
Requires tier 2 graphics card and screen.
To use, place a screen into the floor, run the program, and walk on it. Thats it.
Program will not pick up other non-player entities
--]]

local component = require("component")
local screen = component.screen
local gpu = component.gpu
local event = require("event")
local io = require("io")
local term = require("term")

local maxX,maxY = gpu.maxResolution()

print("Init Welcome mat...")
os.sleep(2)
gpu.setResolution(25,9)
local maxX,maxY = gpu.getResolution()

while true do
 _,x,y,direction,entName = event.pull("walk")
 if entName ~= nil then
   require("computer").beep()
   term.clear() --remove previous welcome
   local nameX = require("math").floor((maxX/2)-(entName:len()/2)) --centre the entity name
   term.setCursor(nameX,maxY/3) --place the welcome in the upper third of the screen, in the centre
   io.write("Welcome,")
   term.setCursor(nameX,(maxY/3)+1) --place name one line lower than the welcome
   io.write(entName)
   os.sleep(3) --cooldown time, to avoid spam
 end
end
