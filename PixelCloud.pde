import peasy.*; 

// Options
float strokeWeight = 5;
float depth = 100;
String imgPath = "waveSorted.png";

// Internal variables
PFont f;
PeasyCam cam;
PImage img;
int dimension;
float avgHue = 0;
float avgBrightness = 0;
float avgSaturation = 0;

void setup() {
  size(1000, 800, P3D);
  perspective(PI/50.0, (float)width/height, 1, 100000);
  cam = new PeasyCam(this, img.width + 2000);
  
  img = loadImage(imgPath);
  dimension = img.width * img.height;
  img.loadPixels();
  
  // Finds the average color of the image
  for (int i = 0; i < dimension; i++) {
    avgHue += hue(img.pixels[i]);
    avgBrightness += brightness(img.pixels[i]);
    avgSaturation += saturation(img.pixels[i]);
  }
  
  avgHue /= dimension;
  avgBrightness /= dimension;
  avgSaturation /= dimension;
  avgSaturation = (avgSaturation / 256)*100;
  avgBrightness = (avgBrightness / 256)*100;
  
  colorMode(HSB);
  strokeWeight(5);
  strokeCap(ROUND);
  textMode(SHAPE);
  f = createFont("Arial",16,true);
  textFont(f,img.width/40);
  textAlign(CENTER);
}

void draw() {
  background(avgHue, avgSaturation, avgBrightness);
  
  // FPS text
  fill(255);
  text("fps: " + int(frameRate + .5), 0, -img.height/2 - 10, 0); 
  
  // Rebuild image as pointcloud
  int x = img.width/2;
  int y = -img.height/2;
  for (int i = 0; i < dimension; i++) {
    x += 1;
    if (i % img.width == 0) {
      y += 1;
      x -= img.width;
    }
    stroke(img.pixels[i]);
    point(x, y, (brightness(img.pixels[i])/256) * depth);
  }
  
  // Auto camera movement
  rotateX(sin((PI/200)*frameCount)/20);
  rotateY((PI/4000)*frameCount);
}