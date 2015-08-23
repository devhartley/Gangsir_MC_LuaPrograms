--Gangsir's base info getter tablet client
--This program is meant to be used with a tablet, and my base info getter program.
--Ensure a wireless network card is installed in your tablet.
--Using port 21481

local term = require("term")
local component = require("component")
local os = require("os")
port = 21481 --port the wireless part should use
modem = component.modem
homeAddress = ""

modem.setStrength(60)
modem.open(port) --open the port for sending
print("Init client... Phoning home...")
modem.broadcast(port,tostring(modem.address))
print("Waiting for home address...")
local _,sender,_,_,message = event.pull("modem")
print("Home acquired. Address is "..sender)
homeAddress = sender
os.sleep(2)

term.clear()
while true do --keep recieving info and displaying it
  local _,_,_,_,message = event.pull("modem")
  print(message)
end
