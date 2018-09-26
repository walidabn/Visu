// Week 11 for camera
import processing.video.*;
import gab.opencv.*;
OpenCV opencv;

Capture cam;
PImage img;
BlobDetection b;
QuadGraph q;
TwoDThreeD t;

void settings() {
  size(800, 600);
}
 
void setup() {
  //frameRate(25);
  opencv = new OpenCV(this, 100, 100);
  
  // Setup camera for week 11
  /*
  This is commented for milestone 2. 
  Will be used for final submission.
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  cam = new Capture(this, 640, 480);
  cam.start();
   */
   
  img = loadImage("board1.jpg");
  b = new BlobDetection();
  q = new QuadGraph();
  t = new TwoDThreeD(img.width, img.height, 0);//(int)frameRate);
}

void draw() {
  background(0);
  
  /*
  This is commented for milestone 2. 
  Will be used for final submission.
  
  if (cam.available() == true) {
    cam.read();
  }
  
  img = cam.get();
  */
  image(img, 0, 0);
  
  img.loadPixels();
  PImage blob = thresholdHSB(img, 50, 140, 100, 255, 20, 200);
  blob = b.findConnectedComponents(blob, true);
  
  PImage edges = gauss(blob);
  edges = scharr(edges);
  PImage edges2 = threshold(edges, 80);
  
  List<PVector> lines = hough(edges2, 6);
  drawLinesOnImage(lines, edges2);
  
  List<PVector> corners = q.findBestQuad(lines, img.width, img.height, 
    (int)(img.width*img.height*0.8), (int)(img.width*img.height*0.1), false);
  drawCornersOnImage(corners);
  
  for (PVector corner : corners) {
    corner.z = 1;
  }
  PVector rotation = t.get3DRotations(corners);
  println(Math.toDegrees(rotation.x));
  println(Math.toDegrees(rotation.y));
  println(Math.toDegrees(rotation.z));
}

PImage gauss(PImage img) {
  float[][] kernel = { { 9, 12, 9 },
                       {12, 15, 12  },
                       { 9, 12, 9 }};
  return convolute(img, kernel, 99);
}


PImage thresholdHSB(PImage img, int minH, int maxH,
  int minS, int maxS, int minB, int maxB) {
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = hue(img.pixels[i]) >= minH &&
                       hue(img.pixels[i]) <= maxH &&
                       saturation(img.pixels[i]) >= minS &&
                       saturation(img.pixels[i]) <= maxS &&
                       brightness(img.pixels[i]) >= minB &&
                       brightness(img.pixels[i]) <= maxB
                        ? color(255) : color(0);
  }
  return result;
}

PImage threshold(PImage img, int threshold){
  // create a new, initially transparent, ’result’ image
  PImage result = createImage(img.width, img.height, RGB);
  for(int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = brightness(img.pixels[i]) > threshold ? color(255) : color(0);
    
  }
  return result;
}

PImage convolute(PImage img, float[][] kernel, float normFactor) {
  
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  for(int i = 1; i < img.height-1; i++){
    for(int j = 1; j < img.width-1; j++){
      result.pixels[i*img.width + j] = color((int)(kernelApplier(j,i, kernel, img)/normFactor));
    }
  }
  return result;
}

public int kernelApplier(int x, int y, float[][] kernel, PImage img){
  float sum = 0f;
  for( int i = 0; i < kernel.length; i++){
    for(int j = 0; j < kernel[i].length; j++){
      sum += brightness(colorGetter(img, x+j-kernel.length/2,y+i-kernel[i].length/2))*kernel[i][j];
    }
  }
  return (int) sum;
}

public int colorGetter(PImage img, int x, int y){
  int xBis = max(0, min(x, img.width-1));
  int yBis = max(0, min(y, img.height-1));
  return img.pixels[yBis*img.width + xBis];
}


PImage scharr(PImage img) {
  float[][] vKernel = {{  3, 0, -3  },
                       { 10, 0, -10 },
                       {  3, 0, -3  } };
                       
  float[][] hKernel = {{  3, 10, 3 },
                       {  0, 0, 0 },
                       { -3, -10, -3 } };
  
  PImage result = createImage(img.width, img.height, ALPHA);
  
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  
  
  float max=0;
  float[] buffer = new float[img.width * img.height];
  
  //fill buffer
  for(int i = 0; i < img.height; i++){
    for(int j = 0; j < img.width; j++){
      int sum_h = kernelApplier(j,i, hKernel, img);
      int sum_v = kernelApplier(j,i, vKernel, img);

      buffer[i*img.width + j] = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
      if (buffer[i*img.width + j] > max){
        max = buffer[i*img.width + j];
      }
    }
  }
 
  for (int y = 2; y < img.height - 2; y++) {
  // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) {
     // Skip left and right
      int val = (int)((buffer[y * img.width + x] / max)*255);
      result.pixels[y * img.width + x] = color(val);
    }
  }
  return result;
}

boolean imagesEqual(PImage img1, PImage img2) {
  if(img1.width != img2.width || img1.height != img2.height)
    return false;
    
  for(int i = 0; i < img1.width*img1.height ; i++)
    //assuming that all the three channels have the same value
    if(red(img1.pixels[i]) != red(img2.pixels[i])){
      return false;
    }
      
  return true; 
}