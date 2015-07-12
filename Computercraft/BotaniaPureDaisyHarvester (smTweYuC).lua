--PURE DAISY HARVESTER Copyright Gangsir, 2015. Free to use, with credit.

--INSTRUCTIONS
--Set up computer near 3x3 rings of block breakers and block placers.
--Each machine should activate on strong redstone signal. 
--I recommend openblocks, or Mine factory reloaded for rednet cables.
--Then, connect rednet cables to the left and right sides of the computer.
--Ensure that breakers are on right and placers on left cables.
--You will also need to handle piping in/out items.
 
function breakBlocks()
 redstone.setOutput("right",true)
 sleep(2)
 redstone.setOutput("right",false)
 print("Blocks broken.")
end

function placeBlocks()
 redstone.setOutput("left",true)
 sleep(2)
 redstone.setOutput("left",false)
 print("Blocks placed, waiting 30 seconds for conversion.")
end

while true do
 placeBlocks()
 sleep(30)
 breakBlocks()
end