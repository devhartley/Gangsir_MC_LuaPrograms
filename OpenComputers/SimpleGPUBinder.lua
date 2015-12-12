--Auto gpu binder by Gangsir
--Run to easily bind multiple gpus in a computer to different screens.
--run or use with rc on boot.

term = require("term")
component = require("component")
io = require("io")

print("Init gpu binder...")
print("Current primary gpu is "..component.gpu.address..", and is bound to screen "..component.gpu.getScreen())

while true do

  print("------GPUs-------")

  --list and choose gpu ---------------------------------------------------
  local gpus = {}
  for address in component.list("gpu", true) do
    local dev = component.proxy(address)
    table.insert(gpus, dev)
  end

  for i = 1, #gpus do
    local address = gpus[i].address
    print(i..") "..address)
  end

  print("Please select a gpu to bind.")
  local choice = tonumber(io.read())
  if choice <= 0 then choice = 1 end
  if choice > #gpus then choice = #gpus end

  local gpuToBind = component.proxy(gpus[choice].address) --turn the choice into an actual component

  --list and choose screen to bind to ----------------------------------
  print("-----Screens------")
  local screens = {}
  for address in component.list("screen", true) do
    local dev = component.proxy(address)
    table.insert(screens, dev)
  end

  for i = 1, #screens do --print list of attached screens
    print(i..") "..screens[i].address)
  end

  print("Please select a screen to bind to.")
  local choice = tonumber(io.read())
  if choice <= 0 then choice = 1 end
  if choice > #screens then choice = #screens end

  local screenToBind = component.proxy(screens[choice].address) --turn the choice into an actual component

  --bind the screen to the previously selected gpu
  if not gpuToBind.bind(screenToBind.address) then
    print("Seems there was an issue. Ensure that both the screen and gpu are still connected.")
  else
    print("Bound.")
  end
  --Continue or not
  print("Continue changing binds? y/n")
  local continue = tostring(io.read())
  if continue:lower() ~= "y" then break end
end --while true do...
print("Exiting.")

--eof
