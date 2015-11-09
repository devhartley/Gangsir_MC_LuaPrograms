--[[
This is a small program similar to the components program that comes with OpenOS.
It lists all open modem ports when run, and allows opening and closing
Note: Maximum port in oc is 65535, min 1
Arguments can be specified to only scan within them, 2 numbers
--]]


local component = require("component")
if not component.isAvailable("modem") then error("Need some kind of modem card installed for this program.") end

--arguments
local pargs = {...}
local lower = pargs[1] or 1
local upper = pargs[2] or 65535
--sanity checking
lower = tonumber(lower) or 1
upper = tonumber(upper) or 65535
if lower <1 or lower>upper then lower = 1 end
if upper > 65535 or upper < lower then upper = 65535 end


modem = component.modem
io = require("io")
numFoundPorts = 0

print("Listing all open ports between "..lower.." and "..upper..". This will take time, depending on your computer and search range...")

--define functions
--open ports
function openSomePorts()
  print("Would you like to open a port? y/n")
  local answer = tostring(io.read())
  if answer == "y" or answer == "yes" then
    while true do
      print("What port should be opened? Enter exit to stop opening ports.")
      local openPort = io.read()
      if openPort == "exit" then
        print("Stopped opening ports.")
        return
      elseif type(tonumber(openPort)) == "number" then
        local success = modem.open(tonumber(openPort))
        if not success then
          print("Failed to open port, it's probably already open.")
        else
          print("Opened port "..tonumber(openPort)..".")
        end
      end
    end
  end
end

--close ports
function closeSomePorts()
  print("Would you like to close a port? y/n")
  local answer = tostring(io.read())
  if answer == "y" or answer == "yes" then
    while true do
      print("What port should be closed? Enter all to close them all, enter exit to stop closing ports.")
      local closePort = io.read()
      if closePort == "all" then
        modem.close()
        print("Closed all ports.")
        return
      elseif closePort == "exit" then
        print("Stopped closing ports.")
        break
      elseif type(tonumber(closePort)) == "number" then
        local success = modem.close(tonumber(closePort))
        if not success then
          print("Failed to close port, it's probably already closed.")
        else
        print("Closed port "..tonumber(closePort)..".")
        end
      end
    end
  end
end

--begin loop to scan
for port = lower,upper do
  if modem.isOpen(port) then
    io.write(tostring(port..", "))
    numFoundPorts = numFoundPorts+1
  end
end
if numFoundPorts == 0 then --if no ports are open
  print("No ports are currently open.")
  openSomePorts()
else
  print("\nFound a total of "..numFoundPorts.." open ports.")
  closeSomePorts()
  openSomePorts()
end
--eof
