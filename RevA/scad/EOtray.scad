//###############################################################################
//# EOTray                                                                      #
//###############################################################################
//#    Copyright 2020 Dirk Heisswolf                                            #
//#    This file is part of the MK3 Filament Guide project.                     #
//#                                                                             #
//#    This project is free software: you can redistribute it and/or modify     #
//#    it under the terms of the GNU General Public License as published by     #
//#    the Free Software Foundation, either version 3 of the License, or        #
//#    (at your option) any later version.                                      #
//#                                                                             #
//#    This project is distributed in the hope that it will be useful,          #
//#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
//#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
//#    GNU General Public License for more details.                             #
//#                                                                             #
//#    You should have received a copy of the GNU General Public License        #
//#    along with this project.  If not, see <http://www.gnu.org/licenses/>.    #
//#                                                                             #
//#    This project makes use of the NopSCADlib library                         #
//#    (see https://github.com/nophead/NopSCADlib).                             #
//#                                                                             #
//###############################################################################
//# Description:                                                                #
//#   A tray for essential oil bottles                                          #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   June 27, 2020                                                             #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################

//! This is a tray foe essential oil bottles. It is designed to fit inside a box
//! Din A4 footprint. The tray is divided into four pieces to fit on a standard 
//! 3D printer bed.

include <NopSCADlib/lib.scad>

//Shape of the full tray in one piece
module full_tray() {
    difference() {
        cube([212,300,27]);
    
        union() {
            for (xoffs = [16:30:212]) {
                for (yoffs = [16:53.6:300]) {
                    translate([xoffs,yoffs,2])poly_cylinder(h=80,r=14.5);
                }
            }
            for (xoffs = [31:30:182]) {
                for (yoffs = [16+26.8:53.6:300]) {
                    translate([xoffs,yoffs,2])poly_cylinder(h=80,r=14.5);
                }
            }
        }  
    }
}

//$explode=1;
//$vpr = [30,0,10];
//$vpt = [150, 150, 0];

//3D printed parts
//================
//! First corner piece
module EOTray_q1_stl() {
    stl("EOTray_q1");

    color(pp1_colour)
    union() {   
       for (xoffs = [31:30:106]) {
            translate([xoffs,16+26.8+2*53.6,0])poly_cylinder(h=2,r=14.5-0.2);
       }
       difference() { 
            intersection() {
                cube([106,150,30]);
                full_tray();
            }
            for (yoffs = [16:53.6:150]) {
               translate([106,yoffs,-2])poly_cylinder(h=80,r=14.5);
            }
        }    
    }
}

//! Second corner piece        
module EOTray_q2_stl() {
    stl("EOTray_q2");

    color(pp1_colour)
    union() {
        for (yoffs = [16:53.6:150]) {
           translate([106,yoffs,0])poly_cylinder(h=2,r=14.5-0.2);
        }
        difference() { 
            intersection() {
                translate([106,0,0]
                ) cube([106,150,30]);
                full_tray();
            }
            for (xoffs = [121:30:182]) {
                translate([xoffs,16+26.8+2*53.6,-2])poly_cylinder(h=80,r=14.5);
            }
        }
    }
}    
 
//! Reducer piece        
module EOTray_reducer_stl() {
    stl("EOTray_reducer");

    color(pp1_colour)
    difference() {
        translate([0,0,0])  poly_cylinder(h=30,r=14.3);
        translate([0,0,-2]) poly_cylinder(h=34,r=11.75);
    }
}

//Assembly
//========
//! 1. Print each type of corner piece (EOTray_q1 and EOTray_q1) twice.
//! 2. Glue the pices together if desired.
//! 3. Print as many reducer pieces as required 
module main_assembly() {
    pose([30, 0, 10], [150,150,0])
    assembly("main") {
 
    explode([-20,-20,0]) EOTray_q1_stl();  
    explode([20,-20,0])  EOTray_q2_stl();    
    translate([212,300,0]) rotate([0,0,180]) explode([-20,-20,0]) EOTray_q1_stl();  
    translate([212,300,0]) rotate([0,0,180]) explode([20,-20,0])  EOTray_q2_stl();
        
    translate([106,123.2,2]) explode([0,0,40]) EOTray_reducer_stl();
        
        
    }    
}


if($preview) {
    
   main_assembly();
}