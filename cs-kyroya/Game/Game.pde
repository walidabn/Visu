ImageProcessing imgproc;
GameState gameState;
Drawer2D drawer2D;
Drawer3D drawer3D;
Mover mover;
float scale = 1f;
final float RECTANGLE_WIDTH = 500f;
final float RECTANGLE_HEIGHT = 20f;
final float SPHERE_RADIUS = 10f;
final float CYLINDER_RADIUS = 23f;
final float CYLINDER_HEIGHT = 40f;
PImage background;

// Color palette
/*
 blue rgb(2, 168, 244)
 light_blue rgb(79, 195, 247)
 lighter_blue rgb(179, 229, 252)
 lightest_blue (206, 250, 253)
 dark_blue rgb(2, 136, 209)
 darker_blue rgb(1, 87, 156)
*/

void settings(){
  // use always one of the two sizes
  //fullScreen(P3D); 
  size(1600, 900, P3D);
}
void setup(){
  background = loadImage("background.jpg");
  background(255, 255, 255);
  noStroke();
  gameState = new GameState(RECTANGLE_WIDTH, RECTANGLE_HEIGHT, CYLINDER_RADIUS, CYLINDER_HEIGHT, SPHERE_RADIUS);
  drawer2D = new Drawer2D(gameState);
  drawer3D = new Drawer3D(gameState);
  mover = new Mover(gameState);
  
  // run imageprocessing
  imgproc = new ImageProcessing();
  String[] args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
  
  print("Success !\n");
}
void draw(){
  PVector rot = imgproc.getRotation();
  gameState.setRotationX(rot.x);
  gameState.setRotationZ(rot.y);
  if(!gameState.getShiftmode()) {
    mover.update();
  }
  
  drawer3D.draw(background);
  drawer2D.draw();
}

void keyPressed() {
  // enter shift mode
  if (keyCode == SHIFT) {
    gameState.changeShiftmode(true);
  }
}

void keyReleased() {
  // leave shift mode
  if (keyCode == SHIFT) {
    gameState.changeShiftmode(false);
  }
}

void mouseClicked() {
  if (gameState.getShiftmode()) {
    int x = mouseX - width/2;
    int y = mouseY - height/2;
    
    if (abs(x) < gameState.getRectangleWidth()/2.0 && abs(y) < gameState.getRectangleWidth()/2.0) {
      // coodinate y represents firehydrant's direction not position
      gameState.addCylinder(new PVector(x, random(PI*100), y));
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scale += (e/100f);
  scale = min(max(0.2, scale), 1.5);
}

void mouseDragged(){
  // avoid confusion when dragging scrollbar => we deactivate plate rotation on mouse drag
  if(mouseY < drawer2D.LOWER_BOUND_SQUARE){
    float rotationX = gameState.getRotationX(), rotationZ = gameState.getRotationZ();
    rotationZ += (mouseX - pmouseX)*0.001*scale;
    rotationX += -(mouseY - pmouseY)*0.001*scale;
  
    gameState.setRotationX(rotationX);
    gameState.setRotationZ(rotationZ);
  }
}