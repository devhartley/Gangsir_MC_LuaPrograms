red = component.proxy(component.list("redstone")())

--reimplement of OpenOS sleep function to work in MCs
local function sleep(timeout)
  local deadline = computer.uptime() + (timeout or 0)
  repeat
    computer.pullSignal(deadline - computer.uptime())
  until computer.uptime() >= deadline
end


while true do
  computer.pullSignal()
  if red.getInput(4) > 0 then --check to left of mc, from player persp.
    local delay = red.getInput(2)*(red.getInput(3)+1) --back*(front+1)
    if delay >0 then
      sleep(delay-1) --delay, remove extra second
    end
    while red.getInput(4) > 0 do --while signal still on left of mc
      red.setOutput(5,15) --set right on
    end
    red.setOutput(5,15) --set right on
    red.setOutput(5,0) --set right off
  end
end
