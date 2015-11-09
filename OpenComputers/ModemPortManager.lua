--[[
This is a small program similar to the components program that comes with OpenOS.
It lists all open modem ports when run, and allows opening and closing
Note: Maximum port in oc is 65535, min 1
Arguments can be specified to only scan within them, 2 numbers
Parameter letters:
-n : No scan
-s : Silent mode, no questions
--]]


local component = require("component")
if not component.isAvailable("modem") then error("Need some kind of network card installed for this program.") end

print("Init port manager...")

--arguments
local pargs, options = require("shell").parse(...)
local lower = tonumber(pargs[1]) or 1
local upper = tonumber(pargs[2]) or 65535
--sanity checking
if lower <1 or lower>upper then lower = 1 end
if upper > 65535 or upper < lower then upper = 65535 end

modem = component.modem
io = require("io")
numFoundPorts = 0


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
        if tonumber(openPort) > 65535 then openPort = 65535 end
        if tonumber(openPort) < 1 then openPort = 1 end
        if not modem.open(tonumber(openPort)) then --if unable to open port
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
  if answer:lower() == "y" or answer == "yes" then
    while true do
      print("What port should be closed? Enter all to close them all, enter exit to stop closing ports.")
      local closePort = io.read()
      if closePort == "all" then
        modem.close() --close all ports
        print("Closed all ports.")
        return
      elseif closePort == "exit" then
        print("Stopped closing ports.")
        return
      elseif type(tonumber(closePort)) == "number" then
        if tonumber(closePort) > 65535 then closePort = 65535 end
        if tonumber(closePort) < 1 then closePort = 1 end
        if not modem.close(tonumber(closePort)) then --if unable to close port
          print("Failed to close port, it's probably already closed.")
        else
          print("Closed port "..tonumber(closePort)..".")
        end
      end
    end
  end
end

if not options.n then --if switch -n is not given, thus scan
--begin loop to scan
  print("Listing all open ports between "..lower.." and "..upper..". This will take time, depending on your computer and search range...")
  for port = lower,upper do
    if modem.isOpen(port) then
      io.write(tostring(port..", "))
      numFoundPorts = numFoundPorts+1
    end
    if port == require("math").floor(upper/lower) then require("os").sleep() end --pauses halfway through to reduce chance of fail to yield
  end
  if numFoundPorts == 0 then --if no ports are open
    print("No ports are currently open.")
    if options.s then return end --if silent mode
    openSomePorts()
  else
    print("\nFound a total of "..numFoundPorts.." open ports.")
    if options.s then return end -- if silent mode
    closeSomePorts()
    openSomePorts()
  end
else --if switch -n is given, no scan
  print("Not scanning for open ports.")
  if options.s then return end --if silent mode
  openSomePorts()
  closeSomePorts()
end

--eof
