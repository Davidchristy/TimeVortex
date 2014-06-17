/*
A simple simulation of the Time Vortex in intro scene to Doctor Who
Programmer: David Christy
date [started]: June 16
*/
import java.util.LinkedList;
import java.util.ListIterator;

//starting variables placed here for easy changing.

//the number of shapes per circle (the resolution of tube
float tubeRes = 500;

//how many cirlces back does the tube go
float depth = 1000;

/*
How "thick" each circle is
Note: The higher his number, the longer the tube is without any more 
processing power for computer, but also makes it look pixelated
*/
float heightOfCyl = 2;

//the temporary X,Y location to look in the 2D perlin noise field
float tempPerlinY;
float tempPerlinX;

//the number of degrees the tube goes around (360 makes full circle
float angle = 360 / tubeRes;

//the speed of the "wind" of the clouds in the tunnel 
float speedx = 0;

//a random seed for starting Perlin Noise
int SEED = int(random(random(1024)));

//This is the level of activity the clouds have
float zoom = 0.02; 

//a list of circles [depth] long.
java.util.LinkedList circles = new java.util.LinkedList();

class Circle {
  Point[] points = new Point[int(tubeRes) + 1];
  float x, y, 
  z = min(width/PI * 3, height/PI * 3) - (depth * heightOfCyl);

  Circle (float x, float y){
    for (int i = 0; i <= tubeRes; i++) {
      //i changes as it moves around the circle
      points[i] = new Point(cos(radians(i * angle)), //x
                            sin(radians(i * angle)));//y
    }
  }  
}

class Point {
  float x, y;
  Point (float x, float y){
  this.x = x;
  this.y = y;
 } 
}

void setup(){
  size(1000, 750, P3D);
  noStroke();
  noiseSeed(SEED);
  //setting up the the tube with new cirlces
  for(int i = 0; i < depth; i++){
    Circle temp = new Circle(width/2, height/2);
    temp.z += i * heightOfCyl;
    circles.add(temp);
  }
}
void draw(){
  background(0,0,100);
  translate(width / 2, height / 2);
  //testing vaules: may remove later. The offset the circles from middle
  float offsetY = 0;
  float offsetX = 0;
  //since I'm using linked list, it doesn't keep track of how far I am, so this is the counter
  int i = 0;
  ListIterator<Circle> listIterator = circles.listIterator();
  while (listIterator.hasNext()) {
    Circle tempCircle = listIterator.next();    
    
    beginShape(QUAD_STRIP);
    //the 0.05 is to slow things down as not to make some puke
    tempPerlinX += (noise(speedx) - .5) * 0.05;
    //this moves a tiny bit give smooth looking wind
    speedx += 0.0001;
    //adding a random small vaule to give appearance of moving down tunnel
    tempPerlinY += random(0.02);
    //draws the circle
    for (int j = 0; j <= tubeRes; j++) {
      float x = tempCircle.points[j].x * 100;
      float y = tempCircle.points[j].y * 100;
      float z = tempCircle.z;
      //magic, don't really know anymore how this works.
      float noise1 = noise(((j + tempPerlinX - tubeRes/2) * zoom), (i - tempPerlinY) * zoom);

      //Perline nosie gives 0-1 values, so timesing by 255 puts in color scale
      //firstPoint
      fill(0, 0, noise1 * 255);
      vertex(x + offsetX + noise1 * 30,
             y + offsetY - noise1 * 30,
             z);
      //SecondPoint
      vertex(x + offsetX + noise1 * 30,
             y + offsetY - noise1 * 30,
             z + heightOfCyl);
    }
    endShape();
    i++;
  }
}

