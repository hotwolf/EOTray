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

//! This is a tray for essential oil bottles. It is designed to fit inside a box
//! Din A4 footprint. The tray is divided into four pieces to fit on a standard 
//! 3D printer bed.

include <NopSCADlib/lib.scad>

//Shape of a bottle holder
module holder() {
    translate([0,0,0])  poly_cylinder(h=30,r=15);
    translate([0,0,15]) cylinder(15,d1=28,d2=34);
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
    difference() {
        union() {
            cube([106,150,27]);          
            for (yoffs = [46:58:150]) {
                translate([97+8/13,yoffs,0]) poly_cylinder(h=2,r=14.9);
            }
        }
        union() {
            for (xoffs = [17:2100/65:138]) {
                for (yoffs = [17:58:150]) {
                    translate([xoffs,yoffs,2]) holder();
                }
            }
            for (xoffs = [33:2100/65:106]) {
                for (yoffs = [46:58:150]) {
                    translate([xoffs,yoffs,2]) holder();
                }
            }         
            for (yoffs = [17:58:150]) {
                translate([113+12/13,yoffs,-2]) poly_cylinder(h=32,r=15);
            }
        }
    }
}

//! Second corner piece        
module EOTray_q2_stl() {
    stl("EOTray_q2");

    color(pp1_colour)
    difference() {
        union() {
            translate([106,0,0]) cube([106,150,27]);
            for (yoffs = [17:58:150]) {
                translate([113+12/13,yoffs,0]) poly_cylinder(h=2,r=14.9);
            }
        }
        union() {
            for (xoffs = [17:2100/65:210]) {
                for (yoffs = [17:58:150]) {
                    translate([xoffs,yoffs,2]) holder();
                }
            }
            for (xoffs = [33:2100/65:211]) {
                for (yoffs = [46:58:150]) {
                    translate([xoffs,yoffs,2]) holder();
                }
            }         
            for (yoffs = [46:58:150]) {
                translate([97+8/13,yoffs,-2]) poly_cylinder(h=32,r=15);
            }
           
        }
    }            
}    
 
//! Reducer piece        
module EOTray_reducer_stl() {
    stl("EOTray_reducer");

    color(pp1_colour)
    difference() {
        union() {
            translate([0,0,0])  poly_cylinder(h=25,r=14.7);
            translate([0,0,15]) cylinder(10,d1=27.9,d2=31.6);
        }
        union() {
            
            translate([0,0,-2])  poly_cylinder(h=30,r=12);
            translate([0,0,15]) cylinder(15,d1=22,d2=28);
            translate([-18,0,0]) rotate([0,90,0]) cylinder(36,d=15);
         }
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

    explode([-10,-10,0]) EOTray_q1_stl();  
    explode([10,-10,0])  EOTray_q2_stl();    
    translate([212,300,0]) rotate([0,0,180]) explode([-10,-10,0]) EOTray_q1_stl();  
    translate([212,300,0]) rotate([0,0,180]) explode([10,-10,0])  EOTray_q2_stl();
        
    translate([17,17,2]) explode([-10,-10,40]) EOTray_reducer_stl();   
    }    
}


if($preview) {
    
   main_assembly();
}