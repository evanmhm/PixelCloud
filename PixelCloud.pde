import peasy.*;
import gifAnimation.*;

// Options
float strokeWeight = 1;
float depth = 255;
String imgPath = "sunset.png";
int gifFramerate = 1;

// Internal variables
PFont f;
PeasyCam cam;
PImage img;
PImage[] gif;
int dimension;
boolean useGif = false;
int gifIndex = 0;
float avgHue = 0;
float avgBrightness = 0;
float avgSaturation = 0;

void setup() {
  size(1000, 800, P3D);
  perspective(PI/50.0, (float)width/height, 1, 100000);

  if (!split(imgPath, ".")[1].equals("gif")) {
    print ("not gif");
    img = loadImage(imgPath);
  } else {
    print("gif");
    gif = Gif.getPImages(this, imgPath);
    img = gif[0];
    useGif = true;
  }

  cam = new PeasyCam(this, img.width + 2000);

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
  f = createFont("Arial", 16, true);
  textFont(f, img.width/40);
  textAlign(CENTER);
}

void draw() {
  background(avgHue, avgSaturation, avgBrightness);
  if (useGif) {
    img = getFrame();
  }

  // Auto camera movement
  //rotateX(sin((PI/200)*frameCount)/20);
  //rotateY((PI/4000)*frameCount);

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
}

PImage getFrame() {
  if (frameCount % gifFramerate == 0) {
    return gif[gifIndex++ % (gif.length -1)];
  }
  return gif[gifIndex % (gif.length -1)];
}
