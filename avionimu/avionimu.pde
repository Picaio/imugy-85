import processing.serial.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;


ToxiclibsSupport gfx;

Serial port;                         
char[] teapotPacket = new char[14];  
int serialCount = 0;                 
int aligned = 0;
int interval = 0;
String read;
int index1=0;
int dato1=0;
float[] axis = new float[3];

float[] q = new float[4];
Quaternion quat = new Quaternion(1, 0, 0, 0);

float[] gravity = new float[3];
float[] euler = new float[3];
float[] ypr = new float[3];
float yawOffset = 0.0f;


void setup() {
   
    size(400, 400, OPENGL);
    gfx = new ToxiclibsSupport(this);


    lights();
    smooth();
   

    println(Serial.list());

    String portName = "COM6";
    
 
    port = new Serial(this, portName, 9600);
     port.bufferUntil('$');
    

}

void draw() {
  

    background(0);
    
    pushMatrix();
    translate(width / 2, height / 2);
    print("axis:");
    print(axis[0]);
     print(":");
    print(axis[1]);
     print(":");
    println(axis[2]);
    rotateX(-radians(axis[1]));
    rotateY(-radians(axis[0])-yawOffset);
    rotateZ(radians(axis[2]));


 

    // draw main body 
    //fill(255, 0, 0, 200);
    fill(230, 230, 230, 200);
    box(10, 10, 200);
    
    // draw front-facing  
    fill(46, 53, 46, 200);
    pushMatrix();
    translate(0, 0, -120);
    rotateX(PI/2);
    drawCylinder(0, 20, 20, 8);
    popMatrix();
    
    // draw wings and tail 
    fill(0, 96, 5, 200);
    beginShape(TRIANGLES);
    vertex(-100,  2, 30); vertex(0,  2, -80); vertex(100,  2, 30);  // wing top layer
    vertex(-100, -2, 30); vertex(0, -2, -80); vertex(100, -2, 30);  // wing bottom layer
    vertex(-2, 0, 98); vertex(-2, -30, 98); vertex(-2, 0, 70);  // tail left layer
    vertex( 2, 0, 98); vertex( 2, -30, 98); vertex( 2, 0, 70);  // tail right layer
    endShape();
    beginShape(QUADS);
    vertex(-100, 2, 30); vertex(-100, -2, 30); vertex(  0, -2, -80); vertex(  0, 2, -80);
    vertex( 100, 2, 30); vertex( 100, -2, 30); vertex(  0, -2, -80); vertex(  0, 2, -80);
    vertex(-100, 2, 30); vertex(-100, -2, 30); vertex(100, -2,  30); vertex(100, 2,  30);
    vertex(-2,   0, 98); vertex(2,   0, 98); vertex(2, -30, 98); vertex(-2, -30, 98);
    vertex(-2,   0, 98); vertex(2,   0, 98); vertex(2,   0, 70); vertex(-2,   0, 70);
    vertex(-2, -30, 98); vertex(2, -30, 98); vertex(2,   0, 70); vertex(-2,   0, 70);
    endShape();
    
    popMatrix();
}
void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {
    float angle = 0;
    float angleIncrement = TWO_PI / sides;
    beginShape(QUAD_STRIP);
    for (int i = 0; i < sides + 1; ++i) {
        vertex(topRadius*cos(angle), 0, topRadius*sin(angle));
        vertex(bottomRadius*cos(angle), tall, bottomRadius*sin(angle));
        angle += angleIncrement;
    }
    endShape();
    
    // If it is not a cone, draw the circular top cap
    if (topRadius != 0) {
        angle = 0;
        beginShape(TRIANGLE_FAN);
        
        // Center point
        vertex(0, 0, 0);
        for (int i = 0; i < sides + 1; i++) {
            vertex(topRadius * cos(angle), 0, topRadius * sin(angle));
            angle += angleIncrement;
        }
        endShape();
    }
  
    // If it is not a cone, draw the circular bottom cap
    if (bottomRadius != 0) {
        angle = 0;
        beginShape(TRIANGLE_FAN);
    
        // Center point
        vertex(0, tall, 0);
        for (int i = 0; i < sides + 1; i++) {
            vertex(bottomRadius * cos(angle), tall, bottomRadius * sin(angle));
            angle += angleIncrement;
        }
        endShape();
    }
}

void serialEvent(Serial port)
{
   
  
    read = port.readStringUntil('$');
     read = read.substring(0,read.length()-1);   
   float[] nums = float(split(read, ','));
   println(read);
   axis[0]= nums[1];
   axis[1]= nums[2];
   axis[2]= nums[3];

}
void keyPressed() {
  switch (key) {
  
    case 'a': 
      yawOffset = axis[0];
  }
}
