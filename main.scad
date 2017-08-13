include <parts.scad>;

// fillet radius
mink_r_ = 2;

// sensor dimensions
length = 45;
width = 20;
plate_height = 1.5;
whole_sensor_height = 15;
wall_thikness = mink_r_;
el_parts_height = 2;
tube_radius = 8;
tube_height = whole_sensor_height - plate_height;
tubes_between = 27;
tube_x_position = (length - tubes_between) / 2;
tube_y_position = width / 2;

luft = 0.5;

// connector sizes
dupont_length = 14;

// fastener properties
cap_r = 3;
top_diam = 3;
bottom_diam = 2.1;
fastener_x_position = 10;
fastener_y_position = 28;

//cable properties
cable_width = 6;
cable_hole_deep = 3;

// cover properties
cover_height = 0.3;
cover_inner_height = 4.5;

module hcsr04_common_case() {
    difference () {
        // case
        union () {
            // the outer case
            difference () {
                // outer outline
                minkowski() {
                    cube([length + 2 * luft, width + dupont_length + 2 * luft, whole_sensor_height + el_parts_height + wall_thikness]);
                
                    difference () {
                        sphere(r=mink_r_, $fn=45);
                        translate ([-mink_r_, -mink_r_, 0])
                            cube([2 * mink_r_, 2 * mink_r_, 2 * mink_r_]);
                    }
                };
        
                // inner outline
                cube([length + 2 * luft, width + dupont_length + 2 * luft, whole_sensor_height + el_parts_height + wall_thikness]);
            }
        
            // the sensor tubes
            translate([tube_x_position + luft, tube_y_position + luft, -mink_r_])
                cylinder(h = tube_height, r = (tube_radius + wall_thikness), $fn=45);
            translate([tube_x_position + tubes_between + luft, tube_y_position + luft, -mink_r_])
                cylinder(h = tube_height, r = (tube_radius + wall_thikness), $fn=45);
            
            // fastener tubes
            translate([fastener_x_position + luft, fastener_y_position, 0])
                cylinder(h = whole_sensor_height + el_parts_height + wall_thikness, r = top_diam, $fn=45);
            translate([length - fastener_x_position, fastener_y_position, 0])
                cylinder(h = whole_sensor_height + el_parts_height + wall_thikness, r = top_diam, $fn=45);
        }
        
        // holes for tubes
        translate([tube_x_position + luft, tube_y_position + luft, -mink_r_])
            cylinder(h = whole_sensor_height + el_parts_height + wall_thikness, r = tube_radius + luft, $fn=45);
        translate([tube_x_position + tubes_between + luft, tube_y_position + luft, -mink_r_])
            cylinder(h = whole_sensor_height + el_parts_height + wall_thikness, r = tube_radius + luft, $fn=45);
        
        //holes for fasteners
            translate([fastener_x_position + luft, fastener_y_position, 0])
                cylinder(h = whole_sensor_height + el_parts_height + wall_thikness, r = bottom_diam / 2, $fn=45);
            translate([length - fastener_x_position, fastener_y_position, 0])
                cylinder(h = whole_sensor_height + el_parts_height + wall_thikness, r = bottom_diam / 2, $fn=45);
        
        //hole for cable
        translate([length / 2 + luft - cable_width / 2, width + dupont_length + 2 * luft, whole_sensor_height + el_parts_height + wall_thikness - cable_hole_deep])
            cube([cable_width, mink_r_, cable_hole_deep]);
    }
}

module hcsr04_case_cover() {
    difference () {
        union () {
            // base
            minkowski() {
                cube([length + 2 * luft, width + dupont_length + 2 * luft, cover_height]);
                
                difference () {
                    sphere(r=mink_r_, $fn=45);
                    translate ([-mink_r_, -mink_r_, 0])
                        cube([2 * mink_r_, 2 * mink_r_, 2 * mink_r_]);
                }
            }
                
            // inner walls
            translate ([luft, luft, cover_height])
                cube([wall_thikness, width + dupont_length, cover_inner_height]);
            translate ([length + luft - wall_thikness, luft, cover_height])
                cube([wall_thikness, width + dupont_length, cover_inner_height]);
        }
        
        //holes for fasteners
        // holes for caps
        translate([fastener_x_position + luft, width + dupont_length + 2 * luft - fastener_y_position, -mink_r_])
            cylinder(h = mink_r_ / 2, r = cap_r, $fn=45);
        translate([length - fastener_x_position, width + dupont_length + 2 * luft - fastener_y_position, -mink_r_])
            cylinder(h = mink_r_ / 2, r = cap_r, $fn=45);
        
        // holes for bodies
        translate([fastener_x_position + luft, width + dupont_length + 2 * luft - fastener_y_position, -mink_r_])
            cylinder(h = mink_r_ + cover_height, r = top_diam / 2 + top_diam * 0.1, $fn=45);
        translate([length - fastener_x_position, width + dupont_length + 2 * luft - fastener_y_position, -mink_r_])
            cylinder(h = mink_r_ + cover_height, r = top_diam / 2 + top_diam * 0.1, $fn=45);
    }
}

module hcsr04_holder_case() {
    beam_length = 5;
    
    hcsr04_common_case();
    
    translate([luft + length / 2 - beam_height / 2, - beam_height / 2 - mink_r_, beam_length * beam_height - mink_r_ - beam_height / 2])
        rotate([0, 90, 0])
            rounded_beam(5);
}

module hcsr04_neurobot_case() {
    plate_width = 28;
    plate_height = 6;
    holes_distance = 15.5;
    hole_d = 7;

    union() {
        hcsr04_common_case();
    
        translate([luft + length / 2 - plate_width / 2, - plate_height - mink_r_, - mink_r_])
            difference() {
                union() {
                    cube([plate_width, plate_height, holes_distance * 3]);
                    translate([plate_width/2, plate_height, holes_distance * 3])
                        rotate([90, 0, 0])
                            cylinder(d=plate_width, h=plate_height);
                }
            
                translate([plate_width/2, plate_height, holes_distance * 3])
                    rotate([90, 0, 0])
                        cylinder(d=hole_d, h=plate_height);
            }
    }
}

hcsr04_neurobot_case();

translate ([0, 45, 0])
    hcsr04_case_cover();
