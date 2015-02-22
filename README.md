#LAB02

#Purpose

The purpose of this lab was to create an oscilloscope which would take in an electrical signal through an auxillary port and then output that signal onto a screen as a visual signal. 
This was done with the ATLYS Spartan 6, an FPGA.  

#Approach/Planning

At the beginning of the lab, a large schematic was given with all of the desired pieces of the oscilloscope.  The building process then, was to build this design up piece by piece.
The schematic can be seen below: 

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Pictures/givenSchematic.gif "original Schematic")

In lab 1, the counter and video module, which drew images onto the screen was developed.  This takes care of the top right three boxes.  The two other largest components were the BRAM and the AC'97.  Luckily, these files were already given, and only instantiations of them had to be made in this lab.  The original files are shown below: 

[ac97.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Code/Given%20Code/ac97.vhd)
Converts the incoming signal into a 18 bit std_logic_vector.  
[lab2.ucf](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Code/Given%20Code/lab2.ucf)
Defines the inputs and outputs on the ATLYS board. 
[lab2.vhd](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Code/Given%20Code/lab2.vhd)
The overall shell for the lab.  
[lab2_pack.vhdl](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Code/Given%20Code/lab2_pack.vhdl)
Contains component declarations so only the instantiation has to be declared in the lab2 file, or any other file which feeds off of it.  



#Trials/Building Process


#Final Product/Code



#Conclusion


#Documentation
