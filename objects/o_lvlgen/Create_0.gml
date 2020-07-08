/// @description Map Initalization

// Grid Size and Tile size constants set here
#macro mapWidth		16  												// world size is set here - max Height is 99
#macro mapHeight	16 												

#macro tileWidth	48													// tile size is dependant on the sprite being used
#macro tileHeight	52													

#macro totalRooms	70													// Rooms are binary 0 - 63 plus custom rooms
#macro totalDoors    6													// rooms have 6 doors
#macro randRooms	64													// first 64 rooms can be randomly chosen

viewWidth = (mapWidth+1)  *  tileWidth									// adjust window size to map dimensions
viewHeight = (mapHeight+1.5) * tileHeight
camera_set_view_size(view_camera[0], viewWidth, viewHeight);
camera_set_view_pos(view_camera[0], 0, -(tileHeight/2));
window_set_size( viewWidth, viewHeight);
surface_resize(application_surface,viewWidth,viewHeight);
													
gridEntropy = ds_grid_create(mapWidth+2,mapHeight+2);					// Grid of entropy value for each cell
gridIndex =   ds_grid_create(mapWidth+2,mapHeight+2);					// Grid of room indexes
gridRooms =   ds_grid_create(totalDoors,totalRooms)						// Grid of door states of all rooms
																		
Entropy = -1;															// Entropy of the entire map														
																		
#region																	// fill gridRooms with data
																		
// ╔════ 0 ════╗														// doors are numbered clockwise, with the top door starting at 0
// 5           1														// ═ 0 ═ 1 ═ 2 ═ 3 ═ 4 ═ 5 ═	
// ║           ║														
// 4           2														
// ╚════ 3 ════╝														
																		
ds_grid_set_region(gridRooms,0,0,totalDoors,totalRooms,0)				// all doors start at zero ( open )
																		
for (var _RoomIndex = 0; _RoomIndex < randRooms; _RoomIndex += 1; ){	// First 64 rooms are generated as 6 digit binary 0 - 63
	if ( _RoomIndex mod 64 >= 32 ) { 									
		ds_grid_set(gridRooms,0,_RoomIndex,1) // door0
	}
	if ( _RoomIndex mod 32 >= 16 ) && ( _RoomIndex mod 32 <= 31 ) {	
		ds_grid_set(gridRooms,1,_RoomIndex,1) // door1
	}
	if ( _RoomIndex mod 16 >=  8 ) && ( _RoomIndex mod 16 <= 15 ) {
		ds_grid_set(gridRooms,2,_RoomIndex,1) // door2
	}
	if ( _RoomIndex mod 8  >=  4 ) && ( _RoomIndex mod 8  <=  7 ) {
		ds_grid_set(gridRooms,3,_RoomIndex,1) // door3
	}
	if ( _RoomIndex mod 4  >=  2 ) && ( _RoomIndex mod 4  <=  3 ) {	
		ds_grid_set(gridRooms,4,_RoomIndex,1) // door4
	}
	if ( _RoomIndex mod 2  ==  1 ) {									
		ds_grid_set(gridRooms,5,_RoomIndex,1) // door5 
}	}
			
// Custom rooms follow

// room_222222
ds_grid_set(gridRooms, 0, 64, 2);
ds_grid_set(gridRooms, 1, 64, 2);
ds_grid_set(gridRooms, 2, 64, 2);
ds_grid_set(gridRooms, 3, 64, 2);
ds_grid_set(gridRooms, 4, 64, 2);
ds_grid_set(gridRooms, 5, 64, 2);

// two vertical rooms with no blocks in their middle
// room 211011
ds_grid_set(gridRooms, 0, 65, 0);
ds_grid_set(gridRooms, 1, 65, 1);
ds_grid_set(gridRooms, 2, 65, 1);
ds_grid_set(gridRooms, 3, 65, 2);
ds_grid_set(gridRooms, 4, 65, 1);
ds_grid_set(gridRooms, 5, 65, 1);
// room 011211
ds_grid_set(gridRooms, 0, 66, 2);
ds_grid_set(gridRooms, 1, 66, 1);
ds_grid_set(gridRooms, 2, 66, 1);
ds_grid_set(gridRooms, 3, 66, 0);
ds_grid_set(gridRooms, 4, 66, 1);
ds_grid_set(gridRooms, 5, 66, 1);

// T junction of three rooms, Two vertical, one to the right
// top room 
ds_grid_set(gridRooms, 0, 67, 0);
ds_grid_set(gridRooms, 1, 67, 1);
ds_grid_set(gridRooms, 2, 67, 2);
ds_grid_set(gridRooms, 3, 67, 2);
ds_grid_set(gridRooms, 4, 67, 1);
ds_grid_set(gridRooms, 5, 67, 1);
//bottom room
ds_grid_set(gridRooms, 0, 68, 2);
ds_grid_set(gridRooms, 1, 68, 2);
ds_grid_set(gridRooms, 2, 68, 1);
ds_grid_set(gridRooms, 3, 68, 0);
ds_grid_set(gridRooms, 4, 68, 1);
ds_grid_set(gridRooms, 5, 68, 1);
//right room
ds_grid_set(gridRooms, 0, 69, 1);
ds_grid_set(gridRooms, 1, 69, 1);
ds_grid_set(gridRooms, 2, 69, 0);
ds_grid_set(gridRooms, 3, 69, 1);
ds_grid_set(gridRooms, 4, 69, 2);
ds_grid_set(gridRooms, 5, 69, 2);

#endregion

#region																		// create knock out lists for each doorway & type

listNotStart =	 ds_list_create(); ds_list_add (listNotStart, 222222);		// start room knockout - any room on this list cannot be a start room
listSingleOpen = ds_list_create(); ds_list_add (listSingleOpen, 31, 47, 55, 59, 61, 62, 222222);	// random rooms will not include those listed here
listRandRoom =	 ds_list_create(); ds_list_add (listRandRoom, 31, 47, 55, 59, 61, 62, 63, 64, 65, 66, 67, 68, 69, 222222) 
																
listDoor0_0 =	 ds_list_create(); ds_list_add ( listDoor0_0, 222222);		// 0th door not open
listDoor0_1 =	 ds_list_create(); ds_list_add ( listDoor0_1, 222222);		// 0th door not closed
listDoor0_2 =	 ds_list_create(); ds_list_add ( listDoor0_2, 222222);		// 0th door not wide	
				 				 									 
listDoor1_0 =	 ds_list_create(); ds_list_add ( listDoor1_0, 222222);		// 1st door not open
listDoor1_1 =	 ds_list_create(); ds_list_add ( listDoor1_1, 222222);		// 1st door not closed
listDoor1_2 =	 ds_list_create(); ds_list_add ( listDoor1_2, 222222);		// 1st door not wide	
				 				 									 
listDoor2_0 =	 ds_list_create(); ds_list_add ( listDoor2_0, 222222);		// 2nd door not open
listDoor2_1 =	 ds_list_create(); ds_list_add ( listDoor2_1, 222222);		// 2nd door not closed
listDoor2_2 =	 ds_list_create(); ds_list_add ( listDoor2_2, 222222);		// 2nd door not wide
				 				 									 
listDoor3_0 =	 ds_list_create(); ds_list_add ( listDoor3_0, 222222);		// 3rd door not open
listDoor3_1 =	 ds_list_create(); ds_list_add ( listDoor3_1, 222222);		// 3rd door not closed
listDoor3_2 =	 ds_list_create(); ds_list_add ( listDoor3_2, 222222);		// 3rd door not wide  
				 				 									 
listDoor4_0 =	 ds_list_create(); ds_list_add ( listDoor4_0, 222222);		// 4th door not open
listDoor4_1 =	 ds_list_create(); ds_list_add ( listDoor4_1, 222222);		// 4th door not closed
listDoor4_2 =	 ds_list_create(); ds_list_add ( listDoor4_2, 222222);		// 4th door not wide	
				 				 									 
listDoor5_0 =	 ds_list_create(); ds_list_add ( listDoor5_0, 222222);		// 5th door not open
listDoor5_1 =	 ds_list_create(); ds_list_add ( listDoor5_1, 222222);		// 5th door not closed
listDoor5_2 =	 ds_list_create(); ds_list_add ( listDoor5_2, 222222);		// 5th door not wide


for (var _RoomIndex = 0; _RoomIndex < totalRooms; _RoomIndex += 1; ){		// cycle through all rooms & add them to lists depending on their door state
	for (var _DoorIndex = 0; _DoorIndex < totalDoors; _DoorIndex += 1; ) {					
		var _DoorRoom = ds_grid_get(gridRooms, _DoorIndex, _RoomIndex)						
		switch _DoorIndex {
		case 0: switch (_DoorRoom) {										
			case 0: ds_list_add ( listDoor0_1, _RoomIndex); 
					ds_list_add ( listDoor0_2, _RoomIndex); break; 
			case 1: ds_list_add ( listDoor0_0, _RoomIndex); 
					ds_list_add ( listDoor0_2, _RoomIndex); break; 
			case 2: ds_list_add ( listDoor0_0, _RoomIndex);
					ds_list_add ( listDoor0_1, _RoomIndex); break; 
			} break;															
		case 1: switch (_DoorRoom) {	
			case 0: ds_list_add ( listDoor1_1, _RoomIndex); 
					ds_list_add ( listDoor1_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor1_0, _RoomIndex); 
					ds_list_add ( listDoor1_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor1_0, _RoomIndex); 
					ds_list_add ( listDoor1_1, _RoomIndex); break;  
			} break;															
		case 2: switch (_DoorRoom) {
			case 0: ds_list_add ( listDoor2_1, _RoomIndex); 
					ds_list_add ( listDoor2_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor2_0, _RoomIndex); 
					ds_list_add ( listDoor2_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor2_0, _RoomIndex); 
					ds_list_add ( listDoor2_1, _RoomIndex); break;  
			} break;											
		case 3: switch (_DoorRoom) {
			case 0: ds_list_add ( listDoor3_1, _RoomIndex); 
					ds_list_add ( listDoor3_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor3_0, _RoomIndex); 
					ds_list_add ( listDoor3_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor3_0, _RoomIndex); 
					ds_list_add ( listDoor3_1, _RoomIndex); break;  
			} break;																
		case 4: switch (_DoorRoom) {
			case 0: ds_list_add ( listDoor4_1, _RoomIndex); 
					ds_list_add ( listDoor4_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor4_0, _RoomIndex); 
					ds_list_add ( listDoor4_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor4_0, _RoomIndex); 
					ds_list_add ( listDoor4_1, _RoomIndex); break;  
			} break;																
		case 5:	switch (_DoorRoom) {
			case 0: ds_list_add ( listDoor5_1, _RoomIndex); 
					ds_list_add ( listDoor5_2, _RoomIndex); break;  
			case 1: ds_list_add ( listDoor5_0, _RoomIndex); 
					ds_list_add ( listDoor5_2, _RoomIndex); break;  
			case 2: ds_list_add ( listDoor5_0, _RoomIndex); 
					ds_list_add ( listDoor5_1, _RoomIndex); break;  
			} break;
		}
	}
}

#endregion

gridCol0 = c_white
backCol0 = c_black

gridCol1 = make_colour_rgb(243,182,67);
backCol1 = make_colour_rgb(47, 85, 57);

gridCol2 = make_colour_rgb(86,230,180);
backCol2 = make_colour_rgb(59,36,21);

gridCol3 = make_colour_rgb(34,205,242);
backCol3 = make_colour_rgb(78,12,37);

gridCol4 = make_colour_rgb(255,229,145);
backCol4 = make_colour_rgb(110,6,4);

gridCol5 = make_colour_rgb(100,252,143);
backCol5 = make_colour_rgb(71,14,69);

gridCol6 = make_colour_rgb(128,118,255);
backCol6 = make_colour_rgb(21,59,76);

gridCol7 = make_colour_rgb(197,255,0);
backCol7 = make_colour_rgb(5,63,106);

gridCol8 = make_colour_rgb(252,111,115);
backCol8 = make_colour_rgb(48,42,62);