import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.InputStreamReader;

//stores our rgb values for each pixel
int[][] activeRects = new int[28][28];
float edge;
float rectWidth;
float rectHeight;
String currentPrediction = "None";
PFont f;

void setup() {
  size(1280, 720);
  noSmooth();
  fill(126);
  background(102);
  frameRate(120);
  f = createFont("Arial Bold",32,true);
  
  //initialize the activeRects array to 0's
  for(int i = 0; i < 28; i++) {
    for(int j = 0; j < 28; j++) {
      activeRects[i][j] = 255;
    }
  }
  
  //the edge is to separate the drawing space from the network prediction display
  edge = (float) width - ((float) width / 3);
  rectWidth = edge / 28;
  rectHeight = (float) height / 28;
}

void draw() {
  //make the background a dark grey
  background(50);
  //set the edges of the rectangles to grey
  stroke(100);
  for(int i = 0; i < 28; i++) {
    for(int j = 0; j < 28; j++) {
      //if the cell is active draw it as white otherwise draw as dark grey
      if(activeRects[i][j] <= 50) {
        fill(255-activeRects[i][j]);
      } else {
        fill(50);
      }
      rect(i*rectWidth,j*rectHeight,rectWidth,rectHeight-1);
    }
  }
  
  //draw our current prediction
  fill(255);
  textAlign(CENTER);
  textFont(f);
  text("Prediction: " + currentPrediction , width - (width/3)/2, height/2);
}

//if the mouse is dragged then find the rectangle index based on the mouse's position and set the array value to 0 or 50.
void mouseDragged() {
    int rectangleXIndex = (int)((float) mouseX / rectWidth);
    int rectangleYIndex = (int)((float) mouseY / rectHeight);
    //if the current position is in the bounds of our canvas set the activeRects array values with the surrounding pixels getting a smaller activation value
    if(rectangleXIndex-1 >= 0 && rectangleXIndex+1 <= 27 && rectangleYIndex-1 >= 0 && rectangleYIndex+1 <= 27) {
      activeRects[rectangleXIndex][rectangleYIndex] = 0;
      if(activeRects[rectangleXIndex-1][rectangleYIndex] > 0)
        activeRects[rectangleXIndex-1][rectangleYIndex] = 50;
      if(activeRects[rectangleXIndex+1][rectangleYIndex] > 0)
        activeRects[rectangleXIndex+1][rectangleYIndex] = 50;
      if(activeRects[rectangleXIndex][rectangleYIndex-1] > 0)
        activeRects[rectangleXIndex][rectangleYIndex-1] = 50;
      if(activeRects[rectangleXIndex][rectangleYIndex+1] > 0)
        activeRects[rectangleXIndex][rectangleYIndex+1] = 50;
    }
}

//if any key is pressed then default the activeRects array back to all zeros.
//this essentially clears the drawing screen.
void keyPressed() {
  if(key == 8) {
    //if backspace is pressed...
    currentPrediction = "None";
    for(int i = 0; i < 28; i++) {
      for(int j = 0; j < 28; j++) {
        activeRects[i][j] = 255;
      }
    }
  } else if(key == 10) {
    //if enter is pressed...
    //run savefile and call python process 
    saveFile();
    currentPrediction = result();
  }
}

void saveFile() {
  //save the current activeRects activations to a buffered image
  BufferedImage bufferedImage = new BufferedImage(28, 28, BufferedImage.TYPE_INT_RGB);
  for(int y = 0; y<28; y++){
      for(int x = 0; x<28; x++){
          int value = activeRects[x][y] << 16 | activeRects[x][y] << 8 | activeRects[x][y];
          bufferedImage.setRGB(x, y, value);
      }
  }
  File outputfile = new File("D:\\NNTesting\\inputImage.jpg");
  try {
    ImageIO.write(bufferedImage, "jpg", outputfile);
    System.out.println("File written");
  } catch (IOException e) {
    System.out.println("IO Exception Occured");
  }
}

String result() {
  //create a python process which queries against our output image and returns the prediction
  Process process = null;
  try {
    process = Runtime.getRuntime().exec("python D:\\NNTesting\\NeuralNetworkDeployment.py");
    process.waitFor();
    //System.out.println(process.exitValue());
    BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
    BufferedReader stdError = new BufferedReader(new InputStreamReader(process.getErrorStream()));
    
    String s;
    while ((s = stdInput.readLine()) != null) {
      System.out.println(s);
      return s; 
    }
    
    while ((s = stdError.readLine()) != null) {
        System.out.println(s);
    }
  } catch (Exception e) {
    System.out.println("IO Exception Occured");
    System.out.println(e);
  }
  return "Error";
}
