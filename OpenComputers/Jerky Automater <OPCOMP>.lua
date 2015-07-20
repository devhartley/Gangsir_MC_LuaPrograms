--Gangsir's jerky automater. Attach a wood chest via adapter to the computer, and place a drying rack on top of the chest.
component = require("component")
chest = component.container_chest

print("Gangsir's TConstruct jerky automater init")
print("To use, place rotten flesh or uncooked meat in the attached chest. One stack at a time.")


while true do
  chest.pushItem("UP",1,1) --todo add a way to check for and find !jerky
  require("os").sleep(301) --sleep for 301 seconds, to allow for conversion
  chest.pullItem("UP",2,1)
end
