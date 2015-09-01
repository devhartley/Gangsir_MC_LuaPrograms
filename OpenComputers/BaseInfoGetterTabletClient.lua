--Gangsir's base info getter tablet client
--This program is meant to be used with a tablet, and my base info getter program.
--Ensure a wireless network card is installed in your tablet.
--Using port 21481

local term = require("term")
local component = require("component")
local os = require("os")
local event = require("event")
local io = require("io")
filePath = "/usr/misc/homeAddress.txt"
port = 21481 --port the wireless part should use
modem = component.modem
homeAddress = ""

modem.setStrength(60)
modem.open(port) --open the port for sending
print("Init client... Checking for pre-existing home...")
if require("filesystem").exists(filePath) then
 local file = assert(io.open(filePath,"r"),"Failed to open existing file. Things won't work.")
 homeAddress = file:read() --grab the home address from the file.
 file:close()
else
 print("Init client... Finding home...") --gets the address of the new computer home
 modem.broadcast(port,tostring(modem.address))
 print("Waiting for home address...")
 local _,_,sender,_,_,message = event.pull("modem")
 print("Home acquired. Address is "..sender)
 homeAddress = tostring(sender)
 local file = assert(io.open(filePath,"w"),"Failed to open new file. Things won't work.")
 assert(file:write(sender)) --writes home to file, for persistance.
 file:close()
 print("New home written to file.")
end

os.sleep(2)
term.clear()
while true do --keep recieving info and displaying it
  local _,_,_,_,_,message,clear,beep = event.pull("modem")
  print(message) --print received data to screen
  --evaluate extra actions
  if clear == true then os.execute("clear") end --Allows home to clear tablet terminal
  if beep == true then require("computer").beep(100,1) end --beeps to alert user if alert is present
end
