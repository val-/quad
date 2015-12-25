//$fn=100;

PROPELLER_D = 8*25.4;
SIZE = 260;
MOTOR_D = 28;
MOTOR_WRAPPER_DELTA = 1;
BASE_SHAPE_R = 3;
BASE_SHAPE_WIDTH = 60;
HALF_SIZE = SIZE/2;
ARM_MULTIPLIER = 1;
ARM_THICKNESS = 10 * ARM_MULTIPLIER;
FRONT_ARM_ANGLE = 15;
REAR_ARM_ANGLE = 35;
FRONT_ARM_SIZE = HALF_SIZE/cos(FRONT_ARM_ANGLE);
REAR_ARM_SIZE = HALF_SIZE/cos(REAR_ARM_ANGLE);

ARM_MOTOR_PADDING = MOTOR_D/2 + MOTOR_WRAPPER_DELTA*2;
ARM_BASE_SHAPE_PADDING = BASE_SHAPE_WIDTH/3;

BASE_FRAME_HOLE_D = 3;

frontDelta = HALF_SIZE - sqrt(FRONT_ARM_SIZE*FRONT_ARM_SIZE - HALF_SIZE*HALF_SIZE);
rearDelta = HALF_SIZE - sqrt(REAR_ARM_SIZE*REAR_ARM_SIZE - HALF_SIZE*HALF_SIZE);
middlePoint = (frontDelta-rearDelta)/2;

//propellers();

//color("white") render() arms();

color("gray") baseFrame();
color("gray") middleFrame();

color("gray") topFrame();
color("yellow") battery();
color("green") naze32();

//color("white") render() armTube(FRONT_ARM_SIZE);


//frameTesting();

module frameTesting() {
    color("gray") render() difference() {
        union() {
            color("gray") baseFrame();
            color("gray") middleFrame();
        }
        translate([middlePoint, 0, -50]) cube([300,300,300]);
    }
}

module baseFrame() {
    render() difference() {
        translate([0,0,-ARM_THICKNESS*0.2]) baseShape();
        difference() {
            translate([0,0,-ARM_THICKNESS*0.1]) baseShape(16, BASE_SHAPE_WIDTH*2/3, ARM_BASE_SHAPE_PADDING, 50, 100);
            translate([middlePoint,0,-ARM_THICKNESS*0.2]) {
                cylinder(d=BASE_FRAME_HOLE_D*2.5, h=6);
            }
            translate([middlePoint,0,0]) {
                rotate([0,0,30]) cube([BASE_SHAPE_WIDTH*2, 3, 5], true);
                rotate([0,0,-30]) cube([BASE_SHAPE_WIDTH*2, 3, 5], true);
            }
        }
        armFrameWrappers();
        baseFrameHoles();
    }
}

module middleFrame() {
    render() difference() {
        translate([0,0,ARM_THICKNESS*1 + 0.05]) baseShape(2);
        baseFrameHoles();
        translate([middlePoint,0,10]) {
            translate([-BASE_SHAPE_WIDTH/1.5,0,0]) roundedRect([BASE_SHAPE_WIDTH/2, BASE_SHAPE_WIDTH/2, 10], 5);
            translate([BASE_SHAPE_WIDTH/1.5,0,0]) roundedRect([BASE_SHAPE_WIDTH/2, BASE_SHAPE_WIDTH/2, 10], 5);
        }
    }
}

module topFrame() {
    render() difference() {
        translate([0,0,ARM_THICKNESS*1 + 10]) baseShape(2);
    }
}

module baseShape(h=ARM_THICKNESS*1.2, width=BASE_SHAPE_WIDTH, padding=BASE_SHAPE_WIDTH/2, innerWidth=0, innerLength=0) {
    
    hull() {
        translate([frontDelta,0,h/2]) {
            rotate([0,0,90-FRONT_ARM_ANGLE]) {
                translate([padding,0,0]) cube([1,width/2,h], true);
            }
            rotate([0,0,-90+FRONT_ARM_ANGLE]) {
                translate([padding,0,0]) cube([1,width/2,h], true);
            }        
        }
        translate([-rearDelta,0,h/2]) {
            rotate([0,0,-90-REAR_ARM_ANGLE]) {
                translate([padding,0,0]) cube([1,width/2,h], true);
            }
            rotate([0,0,90+REAR_ARM_ANGLE]) {
                translate([padding,0,0]) cube([1,width/2,h], true);
            }        
        }
        translate([middlePoint,0,h/2]) {
            cube([innerLength,innerWidth,h], true);
        }
    }
    
}

module baseFrameHoles(padding=BASE_SHAPE_WIDTH/2.4) {
        translate([frontDelta,0,0]) {
            rotate([0,0,90-FRONT_ARM_ANGLE]) {
                translate([padding,-ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
                translate([padding,+ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
            }
            rotate([0,0,-90+FRONT_ARM_ANGLE]) {
                translate([padding,-ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
                translate([padding,+ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
            }        
        }
        translate([middlePoint,0,-10]) {
            cylinder(d=BASE_FRAME_HOLE_D, h=50);
        }
        translate([-rearDelta,0,0]) {
            rotate([0,0,-90-REAR_ARM_ANGLE]) {
                translate([padding,-ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
                translate([padding,+ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
            }
            rotate([0,0,90+REAR_ARM_ANGLE]) {
                translate([padding,-ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
                translate([padding,+ARM_THICKNESS*1.1,-10]) cylinder(d=BASE_FRAME_HOLE_D, h=50);
            }        
        }
}

module arms() {
    //rearArms
    arm(REAR_ARM_SIZE, REAR_ARM_ANGLE, +1, -1);
    arm(REAR_ARM_SIZE, REAR_ARM_ANGLE, -1, -1);

    //frontArms
    arm(FRONT_ARM_SIZE, FRONT_ARM_ANGLE, +1, +1);
    arm(FRONT_ARM_SIZE, FRONT_ARM_ANGLE, -1, +1);
}

module arm(size, angle, sideX, sideY) {
    translate([sideY*HALF_SIZE, sideX*HALF_SIZE, 0]) {
        difference() {
            union() {
                motorHolder();
                rotate([0, 0, sideX*90 - sideX*sideY*angle]) {
                    translate([-size/2+ARM_BASE_SHAPE_PADDING/2,0,5]) {
                        armTube(size-ARM_BASE_SHAPE_PADDING);
                    }
                    translate([-size+ARM_BASE_SHAPE_PADDING+5.5,0,5]) {
                        cube([3, ARM_THICKNESS*1.4, ARM_THICKNESS], true);
                    }                    
                }
            }
            motorHolderWrapper();
            rotate([0, 0, sideX*90 - sideX*sideY*angle]) translate([-size/2+ARM_BASE_SHAPE_PADDING/2,0,5]) {
                armTubeInner(size-ARM_BASE_SHAPE_PADDING);
            }
        }
        rotate([0, 0, sideX*90 - sideX*sideY*angle]) {
            translate([-size/2-ARM_MOTOR_PADDING/2+ARM_BASE_SHAPE_PADDING/2,0,5]) {
                armTubeSpacers(size-ARM_MOTOR_PADDING-ARM_BASE_SHAPE_PADDING);
            }
        }        
    }
}


module motorHolder() {
    cylinder(d=MOTOR_WRAPPER_DELTA*2+MOTOR_D+ARM_THICKNESS*0.4, h=ARM_THICKNESS);
}


module motorHolderWrapper() {
    translate([0,0,ARM_THICKNESS*0.075]) cylinder(d=MOTOR_WRAPPER_DELTA*2+MOTOR_D, h=ARM_THICKNESS);
}

module armTube(size) {
    armTubeShape(size, ARM_THICKNESS);
}

module armTubeInner(size) {
    translate([-1,0,0]) armTubeShape(size+2, ARM_THICKNESS*0.85);
}

module armTubeSpacers(size) {
    translate([0,ARM_THICKNESS*0.2,0]) cube([size, ARM_THICKNESS*0.1, ARM_THICKNESS], true);
    translate([0,-ARM_THICKNESS*0.2,0]) cube([size, ARM_THICKNESS*0.1, ARM_THICKNESS], true);
}

module armTubeShape(size, thickness) {
    difference() {
        cube([size, thickness*1.2, thickness], true);
        rotate([45,0,0]) translate([-1,thickness*1.2,0]) cube([size+2, thickness*1.2, thickness], true);
        rotate([90+45,0,0]) translate([-1,thickness*1.2,0]) cube([size+2, thickness*1.2, thickness], true);
        rotate([180+45,0,0]) translate([-1,thickness*1.2,0]) cube([size+2, thickness*1.2, thickness], true);
        rotate([270+45,0,0]) translate([-1,thickness*1.2,0]) cube([size+2, thickness*1.2, thickness], true);
    }
}

module armTubeShapeWrap(size, thickness) {
    difference() {
        cube([size, thickness*1.2, thickness], true);
        rotate([180+45,0,0]) translate([-1,thickness*1.2,0]) cube([size+2, thickness*1.2, thickness], true);
        rotate([270+45,0,0]) translate([-1,thickness*1.2,0]) cube([size+2, thickness*1.2, thickness], true);
    }
}

module armFrameWrappers() {
    //rearArms
    armFrameWrapper(REAR_ARM_SIZE, REAR_ARM_ANGLE, +1, -1);
    armFrameWrapper(REAR_ARM_SIZE, REAR_ARM_ANGLE, -1, -1);

    //frontArms
    armFrameWrapper(FRONT_ARM_SIZE, FRONT_ARM_ANGLE, +1, +1);
    armFrameWrapper(FRONT_ARM_SIZE, FRONT_ARM_ANGLE, -1, +1);
}

module armFrameWrapper(size, angle, sideX, sideY) {
    translate([sideY*HALF_SIZE, sideX*HALF_SIZE, 0]) {

        rotate([0, 0, sideX*90 - sideX*sideY*angle]) {
            translate([-size/2+ARM_BASE_SHAPE_PADDING/2,0,5]) {
                armTubeShapeWrap(size-ARM_BASE_SHAPE_PADDING, ARM_THICKNESS);
            }
            translate([-size+ARM_BASE_SHAPE_PADDING+5.5,0,5]) {
                cube([3, ARM_THICKNESS*1.4, ARM_THICKNESS], true);
            }                    
        }
      
    }
}

module propellers() {
    translate([HALF_SIZE,HALF_SIZE,0]) propeller();
    translate([-HALF_SIZE,HALF_SIZE,0]) propeller();
    translate([HALF_SIZE,-HALF_SIZE,0]) propeller();
    translate([-HALF_SIZE,-HALF_SIZE,0]) propeller();
}

module propeller() {
    translate([0,0,35]) #cylinder(d=PROPELLER_D, h=5);
    translate([0,0,5]) {
        color("gold") cylinder(d=28, h=25);
        color("gray") cylinder(d=3.17, h=37);
    }
}

module battery() {

    translate([-15,0,22.5]) roundedRect([107,34,21], 3);

}

module naze32() {

    translate([95,0,26]) {
        render() difference() {
            roundedRect([36,36,2], 5.5);
            translate([15.25,15.25,-1]) cylinder(d=4, h=10);
            translate([15.25,-15.25,-1]) cylinder(d=4, h=10);
            translate([-15.25,15.25,-1]) cylinder(d=4, h=10);
            translate([-15.25,-15.25,-1]) cylinder(d=4, h=10);
        }
    }

}

module roundedRect(size, radius) {
    x = size[0];
    y = size[1];
    z = size[2];
    linear_extrude(height=z)
    hull() {
        translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0])
            circle(r=radius);   
        translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0])
            circle(r=radius);   
        translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0])
            circle(r=radius);
        translate([(x/2)-(radius/2), (y/2)-(radius/2), 0])
            circle(r=radius);
    }
}

