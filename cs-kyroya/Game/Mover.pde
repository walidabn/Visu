/*
 * This class handles the entire physic part of the game and computes all the results into gameState when using it's update method.
 */
class Mover {
  public static final float gravityConstant = 0.2f;
  
  // Where all the information of the game is located
  private GameState gameState;
  public Mover(GameState gameState){
    this.gameState = gameState;
  }
  
  /*
   * This method is the main one of this class, it uses the gameState to modify it and compute the next state of the game, 
   * it handles gravity on the ball, collision with the limits on the plate, collision with the cylinders...
   */
  public void update() {
    PVector gravityForce = new PVector();
    
    gravityForce.x = sin(gameState.getRotationZ()) * gravityConstant;
    gravityForce.z = -sin(gameState.getRotationX()) * gravityConstant;
    float normalForce = 1;
    float mu = 0.02;
    float frictionMagnitude = normalForce * mu;
    PVector friction = gameState.getBallVelocity().copy();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    
    gameState.addForce(friction);
    gameState.addForce(gravityForce);
    gameState.addVelocity(gameState.getBallVelocity());
    
    bounce();
    checkCylinderCollision();
    gameState.getScoreHandler().timeStep();
  }
  //Handles the bouncing with the limits of the plate
  private void bounce(){
    PVector position = gameState.getBallPosition();
    float rectangleWidth = gameState.getRectangleWidth();
    PVector velocity = gameState.getBallVelocity();
    if(position.x >= rectangleWidth/2 || position.x <= -rectangleWidth/2){
      position.x = Math.min(rectangleWidth/2, Math.max(position.x, -rectangleWidth/2));
      velocity.x = -velocity.x;
      gameState.getScoreHandler().losePoints(velocity.mag());
    }
    if(position.z >= rectangleWidth/2|| position.z <= -rectangleWidth/2){
      velocity.z = -velocity.z;
      position.z = Math.min(rectangleWidth/2, Math.max(position.z, -rectangleWidth/2));
      gameState.getScoreHandler().losePoints(velocity.mag());
    }
    gameState.setBallVelocity(velocity);
    gameState.setBallPosition(position);
  }
  // Handles the bouncing with the cylinders on the plate
  private void checkCylinderCollision(){ 
    for(PVector cylinderPos : gameState.getCylinderPositions()){
      PVector distVect = gameState.getBallPosition().copy();
      // get rid of coodinate y which represents firehydrant's direction not position
      PVector newcylinderPos =  new PVector(cylinderPos.x, 0, cylinderPos.z);
      distVect.sub(newcylinderPos);
      float distance = distVect.mag();
      float minCenterDist = gameState.getCylinderRadius() + gameState.getBallRadius();
      if(distance <= minCenterDist){
        gameState.deleteCylinder(cylinderPos);
        //distvect is now the normal vector
        distVect.normalize();
        //position is set so that ball is not inside cylinder
        gameState.setBallPosition(newcylinderPos.copy().add(distVect.copy().mult(minCenterDist)));
        //formula to calculate new velocity
        distVect.mult(gameState.getBallVelocity().dot(distVect));
        distVect.mult(2);
        gameState.subForce(distVect);
        
        gameState.getScoreHandler().gainPoints(gameState.getBallVelocity().mag());
      }
    }
  }
}