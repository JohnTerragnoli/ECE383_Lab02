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



To tackle the rest of the lab, the schematic was split up into different areas, as shown below.  The logic for these areas was then written in separate blocks in the datapath file, which I was to make.  

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Pictures/Marked%20Original%20Schematic.jpg "marked original Schematic")


Also, I then realized that the wiring on the first diagram was wrong, so that it should be as below: 

![alt tag](https://raw.githubusercontent.com/JohnTerragnoli/ECE383_Lab02/master/Pictures/Fixed%20Wire%20Schematic.jpg "fixed wire Schematic")

The read is the where the wire should be, and the green is crossing out the wrong wire.  

After the project was segmented like this, I decided to delve right in to building each piece.  


#Trials/Building Process

1. The first step was to hook up the ac97 component.  The instantiation was given on the online website, seen [here](http://ecse.bd.psu.edu/cenbd452/lab/lab2/lab2.html), although some slight alterations had to be made to the code.  The signals R_bus_out, L_bus_out, R_bus_in, and L_bus_in somehow got switched around.  To fix this issue I first picked an order which makes sense (connecting the ins to the ins and outs to outs) and decided to move on until I could find a way to test it.  I made a note of this guess in my code and in my digital notebook.  
2. Next, I decided to create a feedback loop to output the signal being input, to make sure the AC97 could deconstruct and construct the signal properly.  I went to compile my code so that I could physically test it, but it would not make it past the mapping stage.  I then realized that I uncommented everything in the .ucf file before implementing it.  Turns out the program didn't like this at all.  I recommented the signals that I was not using, and the error messages dissapeared.   
3. I couldn't figure out what was going on, then I realized that many of the instantiations would have to be made before compiling anything.  So I set out to finish video and BRAM before I could test this.  
4. Next I tackled the video instantiation, since I already knew that worked from lab1.  This job was just a copy and paste, including the two processes which take care of the button presses (all from lab1).  I had to change some signal names and such, but after I did this, everything worked smoothly. 
5. Then I took care of the BRAM instantiation.  This was one of the hardest parts, since I had no idea what most of the signals meant.  I filled in most of the slots by looking at the original schematic, although for the WE I had to ask Jeremy Gruska what that meant, and he said "11" goes there.  With all of the other signals, I would get standard errors and just kept changing things, such as the data type from std_logic_vector to unsigned, until all of the syntax errors went away.
6. I then noticed something.  The outputs coming from the datapath schematic were only 16 bits long.  Meaning, that it was likely the lab had another error in it.  So I started changing everything around in all of my modules to fit this new variable length.  After I did this, it became impossible for it to compile so I just threw out all of my code, since so many errors were showing up and I had no idead what they were, and Google was little help.  I wasted a ton of time on this, because the syntax was checking out while I was making the changes but it wouldn't compile when I asked it to.  Luckily, I save a folder of my code before I make any changes to it, so I have something semi-working to fall back on.  I uploaded this immediately and decided to leave the bus signals after debating with some classmates who already got it working.  
7. Then I re-did all of the instantiations and tried to fix all of the error messages which popped up at me.  Some signals weren't declared and such.  They were relatively easy fixes, althought there were a lot of them.  
8. I immediately started working on all of the logic sections I divided up at the beginning.  First up was the BRAM counter, since I felt like I could use my old counter to make this work.  I was able to do so, except I had to modify my cw(1 downto 0), which was sent from the control unit, to be accepted by my counter frame.  This involved turning the two bit control signal into two different one bit signals.  This was fairly easy.  I then declared and instantiated the BRAM_counter, and hooked up the control signals to it.  Also, instead of the comparator, I just had the roll over go straight to the sw(1) signal.  The output, wrtie_cntr, went to be an input of the WRADDR in BRAM.  
9. Then I instantiated the comparator between the readL and row and set sw(2) = 1 all the time.  
10. I took some time to analyze the control and status signals which would be required, then I built a fsm diagam with codes for cw and sw to match the datapath.  After the diagram was made, building the fsm was easy.  Something actually came on the screen when I ran it!  It wasn't a waveform, it was like pulsing lines on the screen that would go with the music (I have a video of it).  This was pretty exciting.
11. After that, I realized that I forgot to hook up two of the wires, write_cntr and WRADDR.  This means that the address was not being input into BRAM, but an output signal was still occuring.  Then, when I connected the two wires, it was back to nothing but a grid.  So much for that.  
12. So this got me thinking, do I even need a BRAM?  What if I just delay the unsigned input to readL by one cycle?  Well I tried that just for kicks because it was 0342 at night, but it still didn't work.  Although that would've been cool.
13. Then I realized I could still get the other parts of the functionality, so I started working on the testbench for the fsm.  I created a simple testbench for the control unit, which would receive various sw signals during simulation, to check that it kept moving to the correct states.  It in fact did, meaning it would control the computer correctly.  
14. The waveform and a screenshot of the waveform can be seen below: 


#Final Product/Code



#Conclusion


#Documentation
