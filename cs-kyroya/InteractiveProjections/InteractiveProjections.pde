float depth = 2000;
float oldMouseY = height/2;
float rx = 0;
float ry = 0;

void settings() {
  size (500, 500, P3D);
}
void setup() {
  noStroke();
}

void draw() {
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  background(200);
    
  
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox cuboid = new My3DBox(origin, 100, 100, 100);

  cuboid = transformBox(cuboid, rotateYMatrix(ry));
  cuboid = transformBox(cuboid, rotateXMatrix(rx));
  float[][] transform2 = translationMatrix(200, 200, 0);
  cuboid = transformBox(cuboid, transform2);
  
  projectBox(eye, cuboid).render();
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      ry -= 50;
    }
    else if (keyCode == LEFT) {
      ry += 50;
    }
    else if (keyCode == UP) {
      rx -= 50;
    }
    else if (keyCode == DOWN) {
      rx += 50;
    }
  }
}

void mouseDragged() 
{
  if(mouseY > oldMouseY){
    depth = depth + 15;
  }
  else if(mouseY < oldMouseY){
    depth = depth - 15;
  }
  oldMouseY = mouseY;
  
}



My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float factor = -eye.z/(p.z - eye.z);
  return new My2DPoint((p.x - eye.x)*factor, (p.y - eye.y)*factor);
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  
  My2DPoint[] projections = new My2DPoint[box.p.length];
  for(int i = 0; i < box.p.length; ++i) {
    projections[i] = projectPoint(eye, box.p[i]);
  }
  return new My2DBox(projections);
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}

float[][]  rotateXMatrix(float angle) {
  return(
    new float[][] {
      {1, 0 , 0 , 0},
      {0, cos(angle), sin(angle) , 0},
      {0, -sin(angle) , cos(angle) , 0},
      {0, 0 , 0 , 1}});
}

float[][]  rotateYMatrix(float angle) {
  return(
    new float[][] {
      {cos(angle), 0 , -sin(angle) , 0},
      {0,           1,     0 ,       0},
      {sin(angle), 0 , cos(angle) , 0},
      {0, 0 , 0 , 1}});
}

float[][]  rotateZMatrix(float angle) {
  return(
    new float[][] {
      {cos(angle), sin(angle) , 0 , 0},
      {-sin(angle), cos(angle), 0 , 0},
      {0, 0 , 1 , 0},
      {0, 0 , 0 , 1}});
}

float[][]  scaleMatrix(float x, float y, float z) {
  return(
    new float[][] {
      {x, 0 , 0 , 0},
      {0, y,  0 , 0},
      {0, 0 , z , 0},
      {0, 0 , 0 , 1}});
}

float[][]  translationMatrix(float x, float y, float z) {
  return(
    new float[][] {
      {1, 0 , 0 , x},
      {0, 1 , 0 , y},
      {0, 0 , 1 , z},
      {0, 0 , 0 , 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  
  float[] c = new float[4];
  for (int i = 0; i < 4; ++i) {
    for (int j = 0; j < 4; ++j) {
      c[i] += b[j]*a[i][j];
    }
  }
  return c;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] projections = new My3DPoint[8];
  
  for(int i = 0; i < box.p.length; ++i) {
    float[] vector = homogeneous3DPoint(box.p[i]);
    vector = matrixProduct(transformMatrix, vector);
    projections[i] = euclidian3DPoint(vector);
  }
  return new My3DBox(projections);
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}