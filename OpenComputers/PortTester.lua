--[[
This is a small program similar to the components program that comes with OpenOS.
It lists all open modem ports when run.
Note: Maximum port in oc is 65535, min 1
--]]


local component = require("component")
if not component.isAvailable("modem") then error("Need some kind of modem card installed for this program.") end

local modem = component.modem
local io = require("io")
foundOnePort = false --used for displaying no ports found message
numFoundPorts = 0

print("Listing all open ports. This should only take a bit, depending on your computer...")

--begin loop
for port = 1,65535 do
  if modem.isOpen(port) then
    foundOnePort = true
    io.write(tostring(port..", "))
    numFoundPorts = numFoundPorts+1
  end
end
if not foundOnePort then --if no ports are open
  print("No ports are currently open.")
  require("os").exit()
else
  print("\nFound a total of "..numFoundPorts.." open ports.")
end

print("Would you like to close a port? y/n")
local answer = tostring(io.read())
if answer == "y" or answer == "yes" then
  print("What port should be closed? Enter all to close them all.")
  local closePort = io.read()
  if closePort == "all" then
    modem.close()
    print("Closed all ports.")
  elseif type(tonumber(closePort)) == "number" then
    modem.close(tonumber(closePort))
    print("Closed port "..tonumber(closePort)..".")
  end
end
--eof
