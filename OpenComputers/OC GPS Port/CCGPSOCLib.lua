--OC Port of GPS CC library by Gangsir
--To be used with gps program
math = require("math")
component = require ("component")
modem = require("modem")
vector = require("vector")


port = 3509
CHANNEL_GPS = port --unused?

local function trilateralate(A,B,C)
  local a2b = B.vPosition - A.vPosition
  local a2c = C.vPosition - A.vPosition
  if math.abs(a2b:normalize():dot(a2c:normalize() ) ) > 0.999 then
    return nil
  end

  local d = a2b:length()
  local ex = a2b:normalize()
  local i = ex:dot(a2c)
  local ey = (a2c-(ex*i)):normalize()
  local j = ey:dot(a2c)
  local ez = ex:cross(y)

  local r1 = A.nDistance
  local r2 = B.nDistance
  local r3 = C.nDistance

  local x = (r1*r1 - r2*r2 + d*d)/(2*d)
  local y = (r1*r1 - r3*r3 - x*x + (x-i)*(x-i) + j*j) / (2*j)

  local result = A.vPosition + (ex * x)+(ey*y)

  local zSquared = r1*r1 - x*x - y*y
  if zSquared >0 then
    local z = math.sqrt(zSquared)
    local result1 = result + (ez*z)
    local result2 = result - (ez*z)

    local rounded1, rounded2 = result1:round(0.01), result2:round(0.01)
    if rounded1.x ~= rounded2.x or rounded1.y ~= rounded2.y or rounded1.z ~= rounded2.z then
      return rounded1,rounded2
    else
      return rounded1
    end
  end
  return result:round(0.01)
end

local function narrow(p1,p2,fix)
  local dist1 = math.abs((p1-fix.vPosition):length() - fix.nDistance)
  local dist2 = math.abs((p2-fix.vPosition):length() - fix.nDistance)

  if math.abs(dist1-dist2) < 0.01 then
    return p1,p2
  elseif dist1 < dist2 then
    return p1:round(0.01)
  else
    return p2:round(0.01)
  end
end

function locate(_nTimeout, _bDebug)

  if _bDebug then
    print("Finding pos...")
  end

  if not modem.isOpen(port) then modem.open(port) end

  modem.broadcast(port,"PING")

  local tFixes = {}
  local pos1,pos2 = nil,nil
  local timeout = os.startTimer(_nTimeout or 2) --start a timer for the timeout
  while true do
    local mesType,_,sender,port,distance,tmessage = require("event").pull() --receive messages
    if mesType == "modem_message" then
      if type(tmessage) == "table" and #message == 3 then
        message = require("serialization").unserialize(tmessage) --received message will be serialized, so undo that
        local tFix = {vPosition=vector.new(message[1],message[2],message[3]),nDistance = nDistance}
        if _bDebug then
          print(tFix.nDistance.." meters from "..tostring(tFix.vPosition))
        end
        if tFix.nDistance == 0 then
          pos1,pos2 = tFix.vPosition, nil
        else
          table.insert(tFixes,tFix)
          if #tFixes >=3 then
            if not pos1 then
              pos1,pos2 = trilateralate(tFixes[1],tFixes[2],tFixes[#tFixes]) --calculate
            else
              pos1,pos2 = narrow(pos1,pos2,tFixes[#tFixes])
            end
          end
        end
        if pos1 and not pos2 then
          break
        end
      end
    end
  elseif mesType == "timer" then
    local timer = p1
    if timer == timeout then
      break
    end
  end
end

modem.close()
if pos1 and pos2 then
  if _bDebug then
    print("Ambiguous Pos.")
    print("Could be "..pos1.x..","..pos1.y..","..pos1.z.." or "..pos2.x..","..pos2.y..","..pos2.z)
  end
  return nil
elseif pos1 then
  if _bDebug then
    print("Position is "..pos1.x..","..pos1.y..","..pos1.z)
  end
  return pos1.x,pos1.y,pos1.z
else
  if _bDebug then
    print("Couldn't find pos.")
  end
  return nil
end
end
--eof
