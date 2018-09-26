static float discretizationStepsPhi = 0.06f;
static float discretizationStepsR = 2.5f;
static float inverseR = 1.f / discretizationStepsR;
static int phiDim = (int) (Math.PI/discretizationStepsPhi + 1);


// pre-compute the sin and cos values
// tabTrigo[0] is tabSin, tabTrigo[1] is tabCos
static float[][] tabTrigo = calculateTab();


List<PVector> hough(PImage edgeImg, int nLines) {
  int minVotes = 80;   
  int rDim = (int) ((sqrt(edgeImg.width*edgeImg.width + edgeImg.height*edgeImg.height)*2)*inverseR +1);
  
  int[] accumulator = new int[phiDim * rDim];
  
  for (int y = 0; y < edgeImg.height ; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      if (brightness(edgeImg.pixels[y*edgeImg.width + x]) != 0) {
        
        // for all possible lines
        for (int phi = 0; phi < phiDim; phi++) {
          float realR = x*tabTrigo[1][phi] + y*tabTrigo[0][phi];
          int r = (int)realR + rDim/2;
          accumulator[phi*rDim + r] += 1;
        } 
      }
    }
  }
  List<Integer> bestCandidates = new ArrayList<Integer>();
  for (int i = 0; i < accumulator.length; i++){
    if (accumulator[i] > minVotes && 
          maxInRange(accumulator, i, 1, edgeImg.width) == accumulator[i]){
      bestCandidates.add(i);
    }
  }
  
  HoughComparator hg = new HoughComparator(accumulator);
  java.util.Collections.sort(bestCandidates, hg);
  bestCandidates = bestCandidates.subList(0, min(bestCandidates.size(), nLines));
  
  ArrayList<PVector> lines = new ArrayList<PVector>();
  for (Integer idx : bestCandidates) {    
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim));
      int accR = idx - (accPhi) * (rDim);
      float r = (accR - (rDim) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      lines.add(new PVector(r,phi));
  }
  return lines;
}

void drawCornersOnImage(List<PVector> lines) {
  for (PVector line : lines) {
    float x = line.x;
    float y = line.y;
  
    // Finally, plot the corners
    stroke(204,102,0);
    ellipse(x, y, 20, 20);
  }
}

void drawLinesOnImage(List<PVector> lines, PImage edgeImg) {
  for (PVector line : lines) {
    float r = line.x;
    float phi = line.y;
    
    // Cartesian equation of a line: y = ax + b
    // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
    // => y = 0 : x = r / cos(phi)
    // => x = 0 : y = r / sin(phi)
    // compute the intersection of this line with the 4 borders of
    // the image
    
    int x0 = 0;
    int y0 = (int)(r / sin(phi));
    int x1 = (int)(r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));

    
    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0)
        line(x0, y0, x1, y1);
      else if (y2 > 0)
        line(x0, y0, x2, y2);
      else
        line(x0, y0, x3, y3);
    }
    else {
      if (x1 > 0) {
        if (y2 > 0)
          line(x1, y1, x2, y2);
        else
          line(x1, y1, x3, y3);
      }
      else 
        line(x2, y2, x3, y3);
     }
  }
}

int maxInRange(int[] accumulator, int i, int range, int imgWidth){
  int currentMax = 0;
  for(int j = max(0, i-range); j < min(accumulator.length -1, i+range); j++){
    currentMax = max(currentMax, accumulator[j]);
  }
  return currentMax;
}

static float[][] calculateTab() {
  float[][] tab = new float[2][phiDim];
  float ang = 0;
  for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
    // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
    tab[0][accPhi] = (float) (Math.sin(ang) * inverseR);
    tab[1][accPhi] = (float) (Math.cos(ang) * inverseR);
  }
  return tab;
}