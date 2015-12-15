PROPELLER_D = 8*25.4;
SIZE = 270;
BASE_SHAPE_R = 3;
BASE_SHAPE_WIDTH = 60;
HALF_SIZE = SIZE/2;
FRONT_ARM_ANGLE = 15;
REAR_ARM_ANGLE = 35;
FRONT_ARM_SIZE = HALF_SIZE/cos(FRONT_ARM_ANGLE);
REAR_ARM_SIZE = HALF_SIZE/cos(REAR_ARM_ANGLE);
/*
translate([HALF_SIZE,HALF_SIZE,0]) propeller();
translate([-HALF_SIZE,HALF_SIZE,0]) propeller();
translate([HALF_SIZE,-HALF_SIZE,0]) propeller();
translate([-HALF_SIZE,-HALF_SIZE,0]) propeller();
*/
//translate([25,0,5]) cube([185,60,10], true);

color("white") {
    frontArms();
    rearArms();
    baseShape();
}

module baseShape(h=10) {
    
    frontDelta = HALF_SIZE - sqrt(FRONT_ARM_SIZE*FRONT_ARM_SIZE - HALF_SIZE*HALF_SIZE);
    rearDelta = HALF_SIZE - sqrt(REAR_ARM_SIZE*REAR_ARM_SIZE - HALF_SIZE*HALF_SIZE);

    color("gray") hull() {
        translate([frontDelta,0,0]) {
            rotate([0,0,90-FRONT_ARM_ANGLE]) {
                translate([BASE_SHAPE_WIDTH/2,0,5]) cube([1,25,14], true);
            }
            rotate([0,0,-90+FRONT_ARM_ANGLE]) {
                translate([BASE_SHAPE_WIDTH/2,0,5]) cube([1,25,14], true);
            }        
        }
        translate([-rearDelta,0,0]) {
            rotate([0,0,-90-REAR_ARM_ANGLE]) {
                translate([BASE_SHAPE_WIDTH/2,0,5]) cube([1,25,14], true);
            }
            rotate([0,0,90+REAR_ARM_ANGLE]) {
                translate([BASE_SHAPE_WIDTH/2,0,5]) cube([1,25,14], true);
            }        
        }    
    }
    
}

module rearArms() {
    rearArmLeft();
    rearArmRight();
}

module rearArmLeft() {
    translate([-HALF_SIZE,HALF_SIZE,0]) {
        cylinder(d=32, h=10);
        rotate([0,0,90+REAR_ARM_ANGLE]) translate([-REAR_ARM_SIZE/2,0,5]) {
            cube([REAR_ARM_SIZE, 10, 10], true);
        }
    }
}

module rearArmRight() {
    translate([-HALF_SIZE,-HALF_SIZE,0]) {
        cylinder(d=32, h=10);
        rotate([0,0,-90-REAR_ARM_ANGLE]) translate([-REAR_ARM_SIZE/2,0,5]) {
            cube([REAR_ARM_SIZE, 10, 10], true);
        }
    }
}

module frontArms() {
    frontArmLeft();
    frontArmRight();
}

module frontArmLeft() {
    translate([HALF_SIZE,HALF_SIZE,0]) {
        cylinder(d=32, h=10);
        rotate([0,0,90-FRONT_ARM_ANGLE]) translate([-FRONT_ARM_SIZE/2,0,5]) {
            cube([FRONT_ARM_SIZE, 10, 10], true);
        }
    }
}

module frontArmRight() {
    translate([HALF_SIZE,-HALF_SIZE,0]) {
        cylinder(d=32, h=10);
        rotate([0,0,-90+FRONT_ARM_ANGLE]) translate([-FRONT_ARM_SIZE/2,0,5]) {
            cube([FRONT_ARM_SIZE, 10, 10], true);
        }
    }
}

module propeller() {
    //translate([0,0,35]) #cylinder(d=PROPELLER_D, h=5);
    translate([0,0,5]) {
        color("gold") cylinder(d=28, h=25);
        color("gray") cylinder(d=3.17, h=37);
    }
}

