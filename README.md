# Minecraft Lua Programs
A repository of all the lua programs i've written for the OpenComputers and Computercraft mods for Minecraft.
Computercraft is a mod written by `dan200`, and adds lua based computers into Minecraft. OpenComputers is a mod written by `Sangar`, and works similarly to Computercraft, but with more features.

All of these are mine, however some use APIs written by others. The needed APIs can be found in comments of the program in question, or in the Explanations section for the program below. I generally try to avoid using libraries that are not standard
to openOS.

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

This is an OpenComputers port of my old base manager for Computercraft. This program scans and manages a reactor, a power bank of some sort, (Mekanism, Ender IO, Thermal Expansion) and a tank. (Mekanism portable tanks, drums, or Ender IO tanks) This is my most frequently updated program. This program can be used with my tablet client, found at my [Github](https://github.com/NoahNMorton/MinecraftLuaPrograms). Both this and my table client use port `21481`.

***-Geometry GUI***

This is a program meant for tablets that creates a gui that can be used to run 3 smaller programs for calculating geometry.
The programs are distance, midpoint, and volume, and are included in the program.
To use, ensure you have the gui library made by `sirdabalot` for opencomputers in the /lib folder. His gui program is called
[SOCGUIF](https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua). Place this library in the /lib
folder of the computer. The library should be called `SOCGUIF.lua`, and can be retrieved with the command `wget https://raw.githubusercontent.com/sirdabalot/OCGUIFramework/master/SOCGUIF.lua /lib/SOCGUIF.lua`, if you have an internet
card.


***-OpenComputers Big reactor controller***

This is a simple headless big reactors controller, that keeps it from filling up it's buffer
and adjusts it's production according to use. Runs without user interface, graphics not needed.
Emits rapid beeping if reactor gets low on fuel.

***Jerky Automater***

This is a small program to automatically make TConstruct jerky out of meats. This program takes a stack of meat and converts it to jerky. Place the meat to be converted in the first slot of the chest, and the drying rack above the chest. Connect the computer to the chest. This program has no check for jerky, so ensure only meats to be converted land in the first slot.

***-Wireless Command Sender***

**Warning: Both this program and my wireless receiver program are potential security hazards on large servers. Finding out the port someone is using for this will allow for command-jacking, which can be a serious computer threat. Use with caution.**

This is a program to use a Wireless network card to send commands to a computer running the receiver program, and have it executed. It takes 3 arguments: The address of the receiving computer, the port to use, and optionally the signal strength to use. The program also listens for a reply from the target, to ensure the connection went through.

***-Wireless Command Receiver***

This is the mirror program to my WCS, receiving the commands and executing them. It takes one argument, the port to listen on.

***-Base info getter tablet client***

This is a tablet client that receives info from a base info computer and displays it on the tablet. Must be run with my base info getter, and tablet/controller must contain a wireless network card. In order to keep persistence, will write the home address of the home computer running the base controller to file, allowing for it to pick up from where it left off without having to reset both programs. The file is written at `/usr/misc/homeAddress.txt`

***-Pulse OC Port***

OpenComputers port of pulse by `KingofGamesYami`, who's original thread can be found [here.](http://www.computercraft.info/forums2/index.php?/topic/24500-pulse-it-just-looks-cool/)
At least tier 2 screen and graphics card required, but use tier 3 for best results.
This program generates cool looking designs using text.
Causes high power usage when using tier 3 screens, so plan accordingly, a power converter is recommended.

***-Motion sensor base welcomer***

This is a program that uses data from a motion sensor to display a welcome message to the entity that triggered it. Requires a
motion detector.

***-Screen welcome mat***

This is a program to display a welcome message on a horizontal screen when it is walked on. Will not trigger for other
entities. Screen must be tier 2+.

***-Simple Sugarcane harvester***

Gangsir's simple Sugarcane harvester robot program.
Robot can be completely tier 1, although at least 1 inventory upgrade is required.
Chest goes on bottom of robot for output, robot needs to be 1 block off the ground, lined up with Sugarcane column on the right.
There should be 2 columns of the same length of sugarcane. Each row should follow the same pattern of WSSW, with the robot below the last row, on the right column. Make sure there are no blocks between the end of the sugarcane and the chest below the robot.
Light colors are blue for waiting, green for harvesting, yellow for returning to home, and red for dropping items.

***-Mob farm redstone controller***

Gangsir's mob farm controller
TankNut's gui framework required for use. Gui lib can be found at
`https://github.com/OpenPrograms/MiscPrograms/blob/master/TankNut/interface.lua`
If an internet card is present, the program will auto-fetch it.
To set up, connect a bundled redstone cable that OC supports to the computer,
and set colours on other ends to be as follows: Red:Mob spawner, White:Lights, Orange:Door, Black:Killing Method
I recommend using some type of wireless redstone to avoid having to place cables everywhere.

***-Modem port manager***

A simple program to manage ports of a modem card. Lists all open ports, and
allows closing and opening of said ports. Text based.

###OpenComputers Microcontroller Programs

***-S.L.D.R.R.***

Short for Super Long Delay Redstone Repeater, this is a Microcontroller program that makes the Microcontroller work like a vanilla repeater, while being able to reach delays up to 4 mins. To use, place the Microcontroller containing the program. The following directions are from the player's perspective, facing the MC. Imput to start the delay goes in on the left side. Output after the delay comes out the right side. The back is the amount of delay, set by the redstone signal strength, from 0-15. The front is the multiplier, with 1 added. So, for example, 3 in the back and 2 in the front would create a 9 second delay. The formula is:
`delay = backPower*(frontPower+1)`. The 1 added to the multiplier is to allow lack of a multiplier for a x1 delay. With this, it's possible to get up to 4 mins of delay with full signal in front and back. Of course, you can't get any amount of seconds you want, so fine tuning with repeaters may be necessary.
