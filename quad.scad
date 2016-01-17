$fn=80;

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

color("white") render() arms();

//color("gray") baseFrame();
/*
color("gray") middleFrame();

color("black") vibroBalls();
color("gray") topFrame();
color("yellow") battery();
color("green") naze32();
color([0.4,0.4,0.4]) receiver();
*/
//color("white") render() armTube(FRONT_ARM_SIZE);


//frameTesting();

module frameTesting() {
    color("gray") render() difference() {
        union() {
            color("gray") baseFrame();
            color("gray") middleFrame();
            color("black") vibroBalls();
            color("gray") topFrame();
        }
        translate([middlePoint, 0, -50]) cube([300,300,300]);
    }
}

module baseFrame() {
    render() difference() {
        translate([0,0,-ARM_THICKNESS*0.2]) baseShape();
        difference() {
            translate([0,0,-ARM_THICKNESS*0.1]) baseFrameInnerWrapper(16);
            translate([middlePoint,0,-ARM_THICKNESS*0.2]) {
                cylinder(d=BASE_FRAME_HOLE_D*2.5, h=7);
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

module baseFrameInnerWrapper(h) {
    baseShape(h, BASE_SHAPE_WIDTH*2/3, ARM_BASE_SHAPE_PADDING, 50, 100);
}

module middleFrame() {
    union() {
        render() difference() {
            union() {
                translate([0,0,ARM_THICKNESS*1 + 0.05]) {
                    baseShape(2);
                    translate([0,0,-1]) scale([0.998,0.99,1]) baseFrameInnerWrapper(3);
                }
                armMiddleFrameHolders();
            }
            translate([0,0,ARM_THICKNESS*1 + 0.05-2]) scale([0.9,0.9,1]) baseFrameInnerWrapper(3);
            baseFrameHoles();
            vibroBallsHoles();
            
            translate([middlePoint,0,10]) {
                translate([-BASE_SHAPE_WIDTH/2,0,0]) roundedRect([BASE_SHAPE_WIDTH/1.6, BASE_SHAPE_WIDTH/1.6, 10], 5);
                translate([BASE_SHAPE_WIDTH/2.2,0,0]) roundedRect([BASE_SHAPE_WIDTH/1.8, BASE_SHAPE_WIDTH/1.6, 10], 5);
            }
        }
        render() difference() {
            translate([middlePoint,0,ARM_THICKNESS-3.5]) {
                cylinder(d=BASE_FRAME_HOLE_D*2.5, h=5);
            }
            baseFrameHoles();      
        }
        translate([middlePoint,0,ARM_THICKNESS]) {
            rotate([0,0,20]) cube([2,BASE_SHAPE_WIDTH*0.95,1.9],true);
            rotate([0,0,-20]) cube([2,BASE_SHAPE_WIDTH*0.95,1.9],true);
        }
    }
}

module topFrame() {
    render() difference() {
        translate([0,0,ARM_THICKNESS*1 + 10]) baseShape(2);
        vibroBallsHoles();
    }
}

module baseShape(h=ARM_THICKNESS*1.2, width=BASE_SHAPE_WIDTH, padding=BASE_SHAPE_WIDTH/2, innerWidth=0, innerLength=0) {
    
    render() union() {
        hull() {
            translate([frontDelta,0,h/2]) {
                rotate([0,0,90-FRONT_ARM_ANGLE]) {
                    //translate([padding,0,0]) cube([1,width/2,h], true);
                    translate([padding,0,0]) baseShapeStend(width/2,h);
                }
                rotate([0,0,-90+FRONT_ARM_ANGLE]) {
                    translate([padding,0,0]) baseShapeStend(width/2,h);
                }        
            }
            translate([-rearDelta,0,h/2]) {
                rotate([0,0,-90-REAR_ARM_ANGLE]) {
                    translate([padding,0,0]) baseShapeStend(width/2,h);
                }
                rotate([0,0,90+REAR_ARM_ANGLE]) {
                    translate([padding,0,0]) baseShapeStend(width/2,h);
                }        
            }
        }
        hull() {
            translate([middlePoint,0,0]) {
                roundedRect([innerLength,innerWidth,h], 5);
            }
            translate([frontDelta,0,0]) {
                cylinder(d=30, h=h);
            }
            translate([-rearDelta,0,0]) {
                cylinder(d=30, h=h);
            }
        }
    }
    
}

module baseShapeStend(w, h) {
    translate([-0.99,w/2,-h/2]) cylinder(d=2, h=h);
    translate([-0.99,-w/2,-h/2]) cylinder(d=2, h=h);
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

module vibroBallsHoles() {
    
    translate([middlePoint,BASE_SHAPE_WIDTH/2.9,0]) cylinder(d=5.5, h=30);
    translate([middlePoint,-BASE_SHAPE_WIDTH/2.9,0]) cylinder(d=5.5, h=30);
    
    translate([frontDelta,BASE_SHAPE_WIDTH/4.9,0]) cylinder(d=5.5, h=30);
    translate([frontDelta,-BASE_SHAPE_WIDTH/4.9,0]) cylinder(d=5.5, h=30);    
    
    translate([-rearDelta,BASE_SHAPE_WIDTH/4.9,0]) cylinder(d=5.5, h=30);
    translate([-rearDelta,-BASE_SHAPE_WIDTH/4.9,0]) cylinder(d=5.5, h=30);   
    
}

module vibroBalls() {
    
    translate([middlePoint,BASE_SHAPE_WIDTH/2.9,0]) vibroBall();
    translate([middlePoint,-BASE_SHAPE_WIDTH/2.9,0]) vibroBall();
    
    translate([frontDelta,BASE_SHAPE_WIDTH/4.9,0]) vibroBall();
    translate([frontDelta,-BASE_SHAPE_WIDTH/4.9,0]) vibroBall();
    
    translate([-rearDelta,BASE_SHAPE_WIDTH/4.9,0]) vibroBall();
    translate([-rearDelta,-BASE_SHAPE_WIDTH/4.9,0]) vibroBall();
    
}

module vibroBall() {
    translate([0,0,9.5]) cylinder(d=4.5, h=14);
    translate([0,0,9.5]) cylinder(d=7, h=1);
    translate([0,0,22.5]) cylinder(d=7, h=1);
    translate([0,0,16]) sphere(d=9);
}

module arms() {
    //rearArms
    //arm(REAR_ARM_SIZE, REAR_ARM_ANGLE, +1, -1);
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
    d1=MOTOR_WRAPPER_DELTA*2+MOTOR_D+ARM_THICKNESS*0.2-2;
    d2=MOTOR_WRAPPER_DELTA*2+MOTOR_D+ARM_THICKNESS*0.2;
    union() {
        cylinder(d1=d1, d2=d2, h=4);
        translate([0,0,3.9]) cylinder(d=d2, h=ARM_THICKNESS-3.9);
    }
}


module motorHolderWrapper() {    
    d1=MOTOR_WRAPPER_DELTA*2+MOTOR_D-2;
    d2=MOTOR_WRAPPER_DELTA*2+MOTOR_D;
    union() {
        translate([0,0,ARM_THICKNESS*0.075]) cylinder(d1=d1, d2=d2, h=4);
        translate([0,0,ARM_THICKNESS*0.075+3.9]) cylinder(d=d2, h=ARM_THICKNESS-3.9);
        translate([0,0,-5]) cylinder(d=8, h=30);
        
        translate([0,19/2,-5]) cylinder(d=4, h=30);
        translate([0,-19/2,-5]) cylinder(d=4, h=30);
    }    
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

module armMiddleFrameHolders() {
    //rearArms
    armMiddleFrameHolder(REAR_ARM_SIZE, REAR_ARM_ANGLE, +1, -1);
    armMiddleFrameHolder(REAR_ARM_SIZE, REAR_ARM_ANGLE, -1, -1);

    //frontArms
    armMiddleFrameHolder(FRONT_ARM_SIZE, FRONT_ARM_ANGLE, +1, +1);
    armMiddleFrameHolder(FRONT_ARM_SIZE, FRONT_ARM_ANGLE, -1, +1);
}

module armMiddleFrameHolder(size, angle, sideX, sideY) {
    translate([sideY*HALF_SIZE, sideX*HALF_SIZE, 0.15]) {

        rotate([0, 0, sideX*90 - sideX*sideY*angle]) {
            render() difference() {
                translate([-size+ARM_BASE_SHAPE_PADDING+4.91,0,5]) {
                    cube([10.2, ARM_THICKNESS*1.2-0.05, ARM_THICKNESS-0.05], true);
                }                
                union() {
                    translate([-size/2+ARM_BASE_SHAPE_PADDING/2-0.25,0,5]) {
                        rotate([180,0,0]) armTubeShapeWrap(size-ARM_BASE_SHAPE_PADDING, ARM_THICKNESS);
                    }
                    translate([-size+ARM_BASE_SHAPE_PADDING+5.5,0,5]) {
                        cube([3, ARM_THICKNESS*1.4, ARM_THICKNESS], true);
                    }         
                }   
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
    translate([0,0,35]) color([1,0,0,0.05]) cylinder(d=PROPELLER_D, h=5);
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

module receiver() {
    translate([55,0,22.5]) {
        roundedRect([16, 52, 35], 1);
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

