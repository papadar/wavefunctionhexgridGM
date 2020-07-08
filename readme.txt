
wavefunctionhexgridGM
==================================

Implementation of a Wave Function Collapse on a Hex Grid in GameMaker Studio 2.x
by Aladar Apponyi

based on work of Maxim Gumin
https://github.com/mxgmn/WaveFunctionCollapse

and processing example by solub
https://discourse.processing.org/t/wave-collapse-function-algorithm-in-processing/12983

------------- Hex Room Doors ----------------

Hex grid cells are described as Rooms with 6 Doors
The 6 possible connections between each room are numbered clockwise;

			╔════ 0 ════╗
			5           1
			║           ║
			4           2
			╚════ 3 ════╝

This allows all possible rooms with only open or closed doors ( 0 / 1 )
to be represented by binary numbers 0 - 63 ( 000000 - 111111 )

Connection type 2 is also handled,
I have added a small set of custom made rooms / clusters of rooms.

(These rooms are not placed in this release)


------------- Hex Grid Arrangement ----------------

In order to store the hex grid data in standard data structures,
alternate columns of a square grid are shifted by a half grid height
This is then taken into account when checking neighbour entropy

		       ╠════╣         
		  ╠════╣ 10 ╠════╣    
		 ═╣ 00 ╠════╣ 20 ╠═    
		  ╠════╣ 11 ╠════╣    
		 ═╣ 01 ╠════╣ 21 ╠═   
		  ╠════╣ 12 ╠════╣    
		 ═╣ 02 ╠════╣ 22 ╠═   
		  ╠════╣    ╠════╣    

------------- lists ----------------

most work is done by two scripts that compare lists of possible rooms for each cell

ds_list_combine - adds any new values to an original list from a second list

ds_list_trim - removes any values from an original list that occur in the second list

