class CylinderCreator {
  private PShape firehydrant;
  
  public CylinderCreator(){
    firehydrant = loadShape("firehydrant.obj");
    firehydrant.scale(2000);
    firehydrant.rotate(PI);
    //firehydrant.setFill(color(239, 55, 36));
  }
  
  
  
  public void drawAt(float x, float z, float orientation){
    pushMatrix();
    translate(x,0,z);
    rotateY(orientation);
    
    // randomized color
    hint(ENABLE_DEPTH_TEST);
    colorMode(HSB, 100, 100, 100);
    firehydrant.setFill(color(orientation/25, 70 + abs(x+z)/25, 90, 255));
    colorMode(RGB, 255, 255, 255);
    
    shape(firehydrant);
    popMatrix();  
  }
}