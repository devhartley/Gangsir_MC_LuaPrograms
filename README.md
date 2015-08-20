# Minecraft Lua Programs
A repository of all the lua programs i've written for the OpenComputers and Computercraft mods for Minecraft.
Computercraft is a mod written by `dan200`, and adds lua based computers into Minecraft. OpenComputers is a mod written by `Sangar`, and works similarly to Computercraft, but with more features.

All of these are mine, however some use APIs written by others. The needed APIs can be found in comments of the program in question, or in the Explanations section for the program below.

If you use any of these programs, please follow the MIT license and give credit if using them publicly. Also feel free to modify my programs for *personal use.*

#Explanations

###Computercraft
Note: The author is currently focused on OpenComputers, so many of these programs have not been touched in several months. A few of them are especially old, so they may not work in the most effective way possible.


***-Botania Endoflame Automation***

This program manages an Endoflame from Botania, pulsing redstone in order to drop an item once the old one burns up. When run, specify the type of fuel in the program arguments.

***-Botania pure daisy harvester***

This program pulses redstone on the right and left, in order to control block breakers and placers, from a mod of your choosing. This program is used to automate a Botania pure daisy.

***-Computercraft Base Info***

This is a very basic base manager for Computercraft.

***-Computercraft Big Reactor Controller***

This is a big reactor controller, for a power outputting reactor. It turns it off when the reactor gets full of power, and on when the reactor empties. This allows for the reactor to run at full capacity without wasting power.

***-Computercraft tank analyser***

This is a program to scan a tank's info and print it. Prints the liquid in the tank, the amount in mb, and the percentage full. Only supports extra utilities drums.

***-Display metbods of a block***
Program takes a peripheral on the arguments-specified side of the computer and gives all methods of that block to an attached monitor on the left.


###OpenComputers


***-Gangsir's base info getter***

This is an OpenComputers port of my old base manager for Computercraft. This program scans and manages a reactor, a power bank of some sort, (Mekanism, Ender IO) and a tank. (Mekanism portable tanks, drums, or Ender IO tanks) This is my most frequently updated program.

***-GUI Program launcher***

This is a program meant for tablets that creates a gui that can be used to run 3 smaller programs for calculating geometry. The programs are distance, midpoint, and volume, and are included in the program. To use, ensure you have the gui library made by sirdabalot for opencomputers in the /lib folder. His gui program is called [SOCGUIF.](https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua) Place this library in the /lib folder of the computer. The library should be called `GUI.lua`.


***-OpenComputers Big reactor controller***

This is an opencomputers port of my Big reactors controller.

***Jerky Automater***

This is a small program to automatically make TConstruct jerky out of meats. This program takes a stack of meat and converts it to jerky. Place the meat to be converted in the first slot of the chest, and the drying rack above the chest. Connect the computer to the chest. This program has no check for jerky, so ensure only meats to be converted land in the first slot.

***-OC Robot underground room digger***

*This program is currently a WIP and probably won't work. I will update documentation when it is finished and tested.*

This is a program to make a robot dig out a room underground. On run, it will ask the user for the size of the room to be dug out. Ensure that the robot is in the lower left corner, facing the room direction.
