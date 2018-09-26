import java.util.List;
import java.util.Collections;
import java.util.LinkedList;
/*
 * This classe's instance is used to store all the informations relative to the game itself that would be required to draw the game or compute it's advancement, 
 * it is used to communicate easily between the drawing parts and physics part of the game.
 */
class GameState{
  private PVector ballPosition;
  private PVector ballVelocity;
  private final float ballRadius;
  
  // These fields are final because they are not supposed to be changed during the game
  private final float rectangleWidth;
  private final float rectangleHeight;
  private final float cylinderRadius;
  private final float cylinderHeight;
  
  private float rotationX = 0f;
  private float rotationZ = 0f;
  
  private boolean shiftmode = false;
  
  private List<PVector> cylinderPositions;
  private ScoreHandler scoreHandler;
  
  public GameState(float rectangleWidth,float rectangleHeight, float cylinderRadius, float cylinderHeight, float ballRadius){
    this.rectangleWidth = rectangleWidth;
    this.rectangleHeight = rectangleHeight;
    this.cylinderRadius = cylinderRadius;
    this.cylinderHeight = cylinderHeight;
    this.ballRadius = ballRadius;  
    
    ballVelocity = new PVector(0,0,0);
    ballPosition = new PVector(0,0,0);
    scoreHandler = new ScoreHandler();
    cylinderPositions = new LinkedList<PVector>();
  }
  public GameState(float rectangleWidth,float rectangleHeight, float cylinderRadius, float cylinderHeight, float ballRadius, List<PVector> cylinderPositions){
    this(rectangleWidth,rectangleHeight, cylinderRadius, cylinderHeight, ballRadius);
    this.cylinderPositions = new ArrayList<PVector>(cylinderPositions);
  }
  
    public void deleteCylinder(PVector cyl){
      println(cylinderPositions);
      println(cyl + "cyl");
      cylinderPositions.remove(cyl);
      println(cylinderPositions);
  }
  
  // Set of methods made to interact with the positions of the cylinders
  public List<PVector> getCylinderPositions(){
    return Collections.unmodifiableList(new ArrayList<PVector>(cylinderPositions));
  }
  public void addCylinder(PVector position){cylinderPositions.add(position);}
  
  // Set of methods to impact the position of the ball
  public void setBallPosition(PVector position){this.ballPosition = new PVector(position.x, position.y, position.z);}
  public void addVelocity(PVector velocity){
    ballPosition.add(velocity);
  }
  
  // "Setter" methods
  public void changeShiftmode(boolean newmode){this.shiftmode = newmode;}
  public void setRotationX(float newrotX){
    this.rotationX = max(min(newrotX, PI/3f), -PI/3f);
  }
  public void setRotationZ(float newrotZ){
    this.rotationZ = max(min(newrotZ, PI/3f), -PI/3f);
  }
  
  // Methods related to dealing with velocity
  public void setBallVelocity(PVector newVelocity){
    ballVelocity = new PVector(newVelocity.x, newVelocity.y, newVelocity.z);
  }
  public void addForce(PVector force){ballVelocity.add(force);}
  public void subForce(PVector force){ballVelocity.sub(force);}
  
  // The get methods for the drawers and mover
  public PVector getBallPosition()      { return ballPosition; }
  
  public PVector getBallVelocity()      { return ballVelocity; }
  
  public float   getRectangleWidth()    { return rectangleWidth; }
  
  public float   getRectangleHeight()   { return rectangleHeight; }
  
  public float   getCylinderRadius()    { return cylinderRadius; }
  
  public float   getCylinderHeight()    { return cylinderHeight; }
  
  public boolean getShiftmode()         { return shiftmode; }
  
  public float   getRotationX()         { return rotationX; }
  
  public float   getRotationZ()         { return rotationZ; }
  
  public float   getBallRadius()        { return ballRadius; }
  
  public ScoreHandler getScoreHandler() { return scoreHandler; }
}