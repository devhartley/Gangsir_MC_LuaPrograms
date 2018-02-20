--check for presence of gui library
if require("filesystem").exists("/lib/interface.lua") then
  gui = require("interface")
elseif component.isAvailable("internet") then
  print("Gui lib not found, internet card installed, trying to auto-fetch.")
  os.execute("wget https://raw.githubusercontent.com/OpenPrograms/MiscPrograms/master/TankNut/interface.lua /lib/interface.lua")
  print("Computer needs to reboot to note changes to available libs, rebooting in 3 seconds...")
  os.sleep(3)
  computer.shutdown(true) --reboots the computer
else
  error("TankNut's GUI framework must be present and available to use this program. Download from his github at openprograms, and place in /lib, or install an internet card.")
end

--setup for gui
gui.clearAllObjects()

term.setCursor(1,1)
print("Loading...")
--energy
gui.newLabel("totpow","Total Power: ",0,0,maxX,1,0xFF0000)
gui.newLabel("reactpow","Reactor Power: No Reactor",0,3,maxX,1,0xFF0000)
gui.newLabel("reacton","Reactor Running: No Reactor",0,5,maxX,1,0xFF0000)
gui.newLabel("powatick","Power Per Tick: No Reactor",0,7,maxX,1,0xFF0000)
gui.newLabel("powstorage","Power Storage: No Power Storage",0,9,maxX,1,0xFF0000)
--tank
gui.newLabel("contents","Current Tank Contents: No Tank.",0,11,maxX,1,0x0000FF)
gui.newLabel("amount","Amount:",0,13,maxX,1,0x0000FF)
gui.newLabel("percentfill","Percent Filled:",0,15,maxX,1,0x0000FF)
gui.newLabel("barbanner","Tank Percentage Full Bar",0,18,maxX,1,0x0000FF)
gui.newBar("tankbar",5,19,maxX-10,1,0x333333,0xCCCCCC,0) --tank progress bar
--alerts
gui.newLabel("alertsbanner","Alerts: ----------------",0,21,maxX,1,0x000000)
gui.newLabel("reactfuel","",0,22,maxX,1,0x000000)
gui.newLabel("powstorelow","",0,23,maxX,1,0x000000)
--time
gui.newLabel("ingametime","",0,25,maxX,1,0x333333) --ingame time display

 gui.updateAll()
end
--eof
