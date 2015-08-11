--Gangsir's opencomputers robot underground room digger-- (WIP, still needs testing)
--To use, place the robot in the lower left part of the room, facing into the room, on the lowest part of the room.
--make sure it has a pickaxe for digging.
local term = component.term


print("To use, place the robot in the lower left part of the room, facing into the room, on the lowest part of the room.")
print("How tall will the room be? Note that this is inclusive of the y level the robot is currently on, ie 3 would mean 3 air blocks in-between the floor and ceiling. By default, this is 2.")
 local height = term.read()
print("How deep is the room? Note that this is the amount of blocks the robot will move forward, ensure the robot is placed correctly.")
 local depth = term.read()
print("Width of the room? (Distance to the right from the perspective of the robot)")
 local width = term.read()
for w = 1, width do
 for i =1,depth do
  robot.swing()
  robot.swingUp()
  if height >2 then
   blocksUp = 0
   for h = 2,height do
    robot.up()
    blocksUp++
    robot.swingUp()
   end
   for u = 1,blocksUp do
    robot.down()
   end
  end
 end
 robot.turnRight()
 robot.swing()
 robot.turnRight()
end
