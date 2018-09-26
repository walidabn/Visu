import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import java.util.TreeMap;
import java.util.Map;

class BlobDetection {
  
   PImage findConnectedComponents(PImage input, boolean onlyBiggest){
     
     int[] labels = new int [input.width*input.height];
     for (int i = 0; i < labels.length; i++){
       labels[i] = Integer.MAX_VALUE;
     }
     List<TreeSet<Integer>> labelsEquivalences = new ArrayList<TreeSet<Integer>>();
     int currentLabel = -1;
     
     // First pass, labeling each pixel
     for (int i = 0; i < input.height; i++) {
       for (int j = 0; j < input.width; j++) {
         
         // if the pixel is not black
         if (brightness(input.pixels[j + i*input.width]) != 0) { 
           TreeSet<Integer> neighbors = getNeighbors(j, i, input, labels);
           if (!neighbors.isEmpty()) {
             
             int bestLabel = neighbors.first();
             // give smallest label among neighbors
             labels[j + i*input.width] = bestLabel;
             TreeSet<Integer> allNeighboringEquivalences = new TreeSet<Integer>();
             for(Integer e : neighbors){
               allNeighboringEquivalences.addAll(labelsEquivalences.get(e));
             }
             for(Integer e : neighbors){
               labelsEquivalences.set(e,allNeighboringEquivalences);
             }
             //labelsEquivalences.get(bestLabel).addAll(allNeighboringEquivalences);
               
             // remember that the two labels are neighbors
             
             
             
           }
           // no neighboring labels
           else {
             // create a new label
             
             currentLabel++;
             labelsEquivalences.add(new TreeSet<Integer>());
             labelsEquivalences.get(currentLabel).add(currentLabel);
             labels[j + i*input.width] = currentLabel;
           }
         }
       }
     }
     // counts the occurences of a label
     Map<Integer, Integer> maxOccurences = new TreeMap<Integer, Integer>();
     
     // Second pass, merging labels
     for (int i = 0; i < input.height*input.width; i++) {
       if (brightness(input.pixels[i]) != 0) {
         labels[i] = labelsEquivalences.get(labels[i]).first();
         maxOccurences.put(labels[i], maxOccurences.getOrDefault(labels[i], 0)+1);
       }
     }
     
     // get label of biggest area label
     int maxColor = 0;
     if (onlyBiggest) {
       for (Map.Entry<Integer, Integer> e :  maxOccurences.entrySet()) {
         if (e.getValue() > maxOccurences.get(maxColor))
           maxColor = e.getKey();
       }
     }
     
     PImage colored = new PImage(input.width, input.height);
     colored.loadPixels();
     
     // Third pass, coloring the image
     for(int i = 0; i < labels.length; i++){
       if (labels[i] == Integer.MAX_VALUE){
           colored.pixels[i] = 0;
       }
       else if (onlyBiggest) {
         colored.pixels[i] = labels[i] == maxColor ? color(255) : color(0);
       }
       else {
         colorMode(HSB, 255, 255, 255);
         colored.pixels[i] = color((255*labels[i])/(currentLabel +1), 255, 255);
         colorMode(RGB, 255, 255, 255);
       }
     }
     
     colored.updatePixels();
     return colored;
   }
   private TreeSet<Integer> getNeighbors(int x, int y, PImage input, int[] labels) {
     TreeSet<Integer> n = new TreeSet<Integer>();
     
     int leftboundX = max(0, x - 1);
     int rightboundX = min(input.width-1, x + 1);
     
     if(y - 1 >= 0){
        for(int i = leftboundX; i <= rightboundX; i++) {
          int index = i +(y - 1)*input.width;
          if (labels[index] != Integer.MAX_VALUE){
            n.add(labels[index]);
          }
        }
     }
     
     if(x - 1 >= 0){
       int index = x - 1 +y*input.width;
       if (labels[index] != Integer.MAX_VALUE){
            n.add(labels[index]);
          }
     }
     
     return n;
   }
}