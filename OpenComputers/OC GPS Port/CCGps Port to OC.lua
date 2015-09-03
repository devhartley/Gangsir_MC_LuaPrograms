--Opencomputers port of CC gps program, by Gangsir
--Each computer, both receiving and sending, needs a wireless network card.
--Uses port 3505 by default. This value must be changed in the libraries as well, if using other.
term = require("term")
component = require("component")
math = require("math")
serialization = require("serialization")
gps = require("gps")

modem = component.modem
modem.setStrength(400)
port = 3509
modem.open(port)

local function printUsage()
	print( "Usages:" )
	print( "gps host" )
	print( "gps host <x> <y> <z>" )
	print( "gps locate" )
end

local tArgs = { ... }
if #tArgs < 1 then
	printUsage()
	return
end

--reads a number from the terminal
local function readNumber()
	local num = nil
	while num == nil do
		num = tonumber(term.read())
		if not num then
			print( "Not a number. Try again: " )
		end
	end
	return math.floor( num + 0.5 )
end

--Checks to see if the modem is open, and working
local function open() 
	if component.isAvailable("modem") and modem.isOpen(port) and modem.isWireless() then
		return true
	else
		return false
	end
end

local sCommand = tArgs[1]
if sCommand == "locate" then
	if open() then
		gps.locate( 2, true )
	end
--if the computer is a host
elseif sCommand == "host" then
	if component.isAvailable("robot") then
		print( "Robots cannot act as GPS hosts." )
		return
	end

	if open() then
		local x,y,z
		if #tArgs >= 4 then
			x = tonumber(tArgs[2])
			y = tonumber(tArgs[3])
			z = tonumber(tArgs[4])
			if x == nil or y == nil or z == nil then
				printUsage()
				return
			end
			print( "Position is "..x..","..y..","..z )
	end
		print( "Serving GPS requests" )

		local nServed = 0
		while true do
			_,_,sender,_,distance, message = require("event").pull("modem")
			if message == "PING" then
				modem.send(sender,port,serialization.serialize({x,y,z}))
				nServed = nServed + 1
				if nServed > 1 then
					local x,y = term.getCursor()
					term.setCursor(1,y-1)
				end
				print( nServed.." GPS Requests served" )
			end
		end
	end
else
	printUsage()
	return
end
--eof
