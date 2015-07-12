--Botania Endoflame redstone dropper automation 
--Copyright 2015 Gangsir
--Provide args on launch for fuel type. either coal,coalblock,coalcoke,coalcokeblock.

local fueltype = {...} --get args
local dir = fueltype[2] --direction to output redstone on

function isCoal()
    while true do
        rs.setOutput(dir,true)
        sleep(1)
        rs.setOutput(dir,false)
        sleep(80)
    end
end

function isCoalBlock()
    while true do
        rs.setOutput(dir,true)
        sleep(1)
        rs.setOutput(dir,false)
        sleep(720)
    end
end

function isCoalCoke()
    while true do
        rs.setOutput(dir,true)
        sleep(1)
        rs.setOutput(dir,false)
        sleep(320)
    end
end

function isCoalCokeBlock()
    while true do
        rs.setOutput(dir,true)
        sleep(1)
        rs.setOutput(dir,false)
        sleep(2880)
    end
end

if fueltype[1] == nil then
    print("Usage: Provide fuel type. coal,coalblock,coalcoke,coalcokeblock. Also provide direction to output redstone.")
    return nil
end

if fueltype[1] == "coal" then
    print("Fuel type is coal, dropping every 80 seconds.")
    isCoal()
end

if fueltype[1] == "coalblock" then
    print("Fuel type is coal blocks, dropping every 12 mins.")
    isCoalBlock()
end

if fueltype[1] == "coalcoke" then
    print("Fuel type is coal blocks, dropping every 5 mins 20 secs.")
    isCoalCoke()
end

if fueltype[1] == "coalcokeblock" then
    print("Fuel type is coal coke blocks, dropping every 48 mins.")
    isCoalCokeBlock()
end