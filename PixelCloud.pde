import peasy.*;
import gifAnimation.*;

// Options
float strokeWeight = 1;
float depth = 255;
String imgPath = "waveSorted.png";
int gifFramerate = 1;
int pixelSkip = 1; // 1: normal, 2: half pixels, 3: 1/3 pixels...

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
    get( 0, 0, img.width - (img.width % 2), img.height - (img.height % 2));
  } else {
    print("gif");
    gif = Gif.getPImages(this, imgPath);
    img = gif[0];
    useGif = true;
  }
  print(img.width);
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

  //println(pixelSkip);
  // Rebuild image as pointcloud
  int x = -(img.width / pixelSkip)/2;
  int y = -(img.height / pixelSkip)/2;
  int lineCount = 0;
  for (int i = 0; i < dimension; i += pixelSkip) {
    lineCount += pixelSkip;
    x += 1;

    if (lineCount >= img.width) {
      lineCount = 0;
      if (pixelSkip > 1) { // if skipping pixels
        i += (img.width * (pixelSkip - 1)) - (i % img.width); // skip vertical lines in the pixel list
        if (i >= dimension) {
          break;
        }
        y += 1;
        x = -(img.width / pixelSkip)/2;
        stroke(img.pixels[i]);
        point(x, y, (brightness(img.pixels[i])/256) * depth - depth/2);
        continue;
      } else {
        
      }

      stroke(img.pixels[i]);
      point(x, y, (brightness(img.pixels[i])/256) * depth - depth/2);
      
      y += 1;
      x = -(img.width / pixelSkip)/2;
    } else {
      stroke(img.pixels[i]);
      point(x, y, (brightness(img.pixels[i])/256) * depth - depth/2);
    }
  }
}

void keyPressed() {
  if (key == '1') {
    pixelSkip = 1;
  }
  if (key == '2') {
    pixelSkip = 2;
  }
  if (key == '3') {
    pixelSkip = 3;
  }
}

PImage getFrame() {
  if (frameCount % gifFramerate == 0) {
    return gif[gifIndex++ % (gif.length -1)];
  }
  return gif[gifIndex % (gif.length -1)];
}