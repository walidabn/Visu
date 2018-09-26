import java.util.List;
import static java.util.Collections.unmodifiableList;

class ScoreHandler {
  
  private ArrayList<Float> scoreHistory;
  private float currentScore;
  private float lastScore;
  private float miniTimeStep;
  private float maxScore;
  
  public ScoreHandler(){
    this.scoreHistory = new ArrayList<Float>();
    this.currentScore = 0;
    this.lastScore = 0;
    this.maxScore = 0;
    this.miniTimeStep = 0;
  }
  
  public List<Float> getScoreHistory(){
    return unmodifiableList(scoreHistory);
  }
  
  
  public float getLastScore(){
    return lastScore;
  }
  
  
  public float getCurrentScore(){
    return currentScore;
  }
  
   public float getMaxScore(){
    return maxScore;
  }
  
  public void timeStep(){
    miniTimeStep++;
    miniTimeStep = miniTimeStep % (int)frameRate;
    if (miniTimeStep == 0) {
      scoreHistory.add(currentScore);
      
      if (currentScore > maxScore)
        maxScore = currentScore;
    }
  }
  
  
  public void gainPoints(float velocity){
    currentScore += velocity;
    lastScore = velocity;
  }
  public void losePoints(float velocity){
    currentScore = Math.max(0, currentScore - velocity);
    lastScore = -velocity;
  }
  

  
  
}