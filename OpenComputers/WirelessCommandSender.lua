--Opencomputers wireless command sender
--This is a program to send a command to a computer, and have it executed by my wireless command receiver program
--To use, provide the the port to use, and the signal strength, in that order, in the program args.
--The strength is 30 unless specified.

local component = require("component")
local modem = component.modem

pargs = {...}

modem.open(tonumber(pargs[1]))
modem.setStrength(tonumber(pargs[2]) or 30)
print("Warning: Using this on a public server may result in someone command-jacking you. Use at your own risk.")

while true do
    print("Command to send?")
    command = require("term").read()
    sent = modem.broadcast(tonumber(pargs[1]),tostring(command))
    if sent then print("Command Sent.") end

    _,_,sender,_,_,message = require("event").pull(8,"modem") -- wait 8 secs for reply

    if message ~= nil then
        print("Confirmation of execution from "..tostring(sender))
    else
        print("Did not receive confirmation in time from "..tostring(pargs[1])..".")
        print("The connection may be too weak, or the message is blank. The command probably was not executed.")
    end
end
--eof
