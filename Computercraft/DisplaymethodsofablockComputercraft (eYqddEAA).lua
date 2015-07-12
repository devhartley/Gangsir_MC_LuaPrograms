local progargs = {...}
if progargs[1] == nil then
    print("Usage: Provide a direction to check methods on.\nAlso make sure that the monitor is directly to the left of the computer.")
end

local methods = peripheral.getMethods(progargs[1])
--goes through the methods of the block, and prints them.
for i = 0, #methods do
    print(methods[i])
end