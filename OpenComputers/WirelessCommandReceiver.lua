--Gangsir's wireless command receiver and executer
--To use, simply provide the port to listen on in the program args.
--Note: I wouldn't recommend using this on a public server, if someone finds out the port you're using, they can cause harm

local component = require("component")
local modem = component.modem
print("Warning: Using this on a public server may result in someone command-jacking you. Use at your own risk.")
pargs = {...}

modem.close()
modem.open(tonumber(pargs[1])) --open the specified port

while true do
    require("term").clear()
    _,_,sender,_,_,message = require("event").pull("modem") --wait for command

    if message ~= nil then
        os.sleep(1)
        modem.send(sender,tonumber(pargs[1]),"Received.") --send a reply back to the sender.
        os.execute(message) --execute the command sent.
    else
        print("An invalid message was received.")
    end
end
--eof
