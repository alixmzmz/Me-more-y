// Declare and construct two objects (r1, r2) from the class rectMask

RectMask[] rectMasks = new RectMask[12]; // fixed length of the array
Frame[] frames = new Frame[1];

// ARRAY LIST - RANDOM SCENES
// https://processing.org/reference/ArrayList.html
// Declaring the ArrayList
ArrayList<LineMask> lineMasks = new ArrayList<LineMask>(); // flexible length of the array

PImage img1;
int nextSceneStarts = 0;
int scene = 0;
int numberOfLineMasks = 10;
int transparency;

/* .............................................................................................. */

void setup() {
  background(0);
  size(1680, 1050);
  img1 = loadImage("animation-03-landscape-blur.png"); // adding blur with image as the computational blur slows the programm

  // SCENE 1 --------------------------------------------------------------------------------

  // RIGHT (from left to right) (float xS, float yS, float xE, float yE, float s, float rectW, float rectH, String o)
  rectMasks[0] = new RectMask(0, 0, width, 0, 5, 5, height/20, "RIGHT"); 
  rectMasks[1] = new RectMask(0, height/12, width, height/12, 3.0, 3, height/70, "RIGHT"); 
  rectMasks[2] = new RectMask(0, height/3.4, width/1.3, height/3.4, 2.0, 2, height/80, "RIGHT"); 
  rectMasks[3] = new RectMask(0, height/2.9, width/1.45, height/2.9, 6.0, 6, height/25, "RIGHT");  

  // LEFT (from right to left) (float xS, float yS, float xE, float yE, float s, float rectW, float rectH, String o)
  rectMasks[4] = new RectMask(width, height/4.4, width/3.2, height/4.4, 2.0, 2, height/100, "LEFT"); 
  rectMasks[5] = new RectMask(width, height/2.05, width/1.6, height/1.8, 3.0, 3, height/70, "LEFT"); 
  rectMasks[6] = new RectMask(width, height/1.9, width/2.2, height/1.8, 5.0, 5, height/90, "LEFT"); 
  rectMasks[7] = new RectMask(width, height/1.8, width/2.5, height/1.8, 4.0, 4, height/110, "LEFT"); 

  // UP (from bottom to top) (float xS, float yS, float xE, float yE, float s, float rectW, float rectH, String o)
  rectMasks[8] = new RectMask(width/2.05, height/2, width/2.05, height/6, 3, width/100, 3, "UP"); 
  rectMasks[9] = new RectMask(width/1.55, height/1.4, width/1.55, height/2.9, 2, width/140, 3, "UP"); 

  // DOWN (from top to bottom) (float xS, float yS, float xE, float yE, float s, float rectW, float rectH, String o)
  rectMasks[10] = new RectMask(width/1.95, height/5.6, width/1.95, height/1.6, 2, width/160, 3, "DOWN"); 
  rectMasks[11] = new RectMask(width/1.6, 0, width/1.6, height/1.2, 1.5, width/140, 3, "DOWN"); 

  frames[0] = new Frame(0, 0, 3.0, 3, height/20);

  //https://processing.org/reference/random_.html
  // Get a random element from an array
  int[] heightBlockeds = {height/12, height/120, height/20, height/320}; // Array of Heights / Declare, create, assign

  String[] orientations = {"RIGHT", "LEFT", "UP", "DOWN"}; // Array of Heights / Declare, create, assign

  for (int i = 0; i < numberOfLineMasks; i++) {
    //int randomSpeed = (int)random(1, 4);
    float randomSpeed = random(4, 8);

    int index = int(random(heightBlockeds.length));  // Same as int(random(4))
    float randomHeight = heightBlockeds[index];
    String randomOrientation = orientations[index];

    //https://processing.org/reference/switch.html
    switch(randomOrientation) {

    case "RIGHT":
      // Objects can be added to an ArrayList with add()
      // LineMask(float xS, float yS, float xE, float yE, float s, float rectW, float rectH, String o)   
      lineMasks.add(new LineMask(0, random(height), width, random(height), randomSpeed, randomSpeed, randomHeight, "RIGHT"));
      break;
    case "LEFT":
      lineMasks.add(new LineMask(width, random(height), 0, random(height), randomSpeed, randomSpeed, randomHeight, "LEFT"));
      break;
    case "UP":
      lineMasks.add(new LineMask(random(width), height, random(width), 0, randomSpeed, randomHeight, randomSpeed, "UP"));
      break;
    case "DOWN":
      lineMasks.add(new LineMask(random(width), 0, random(width), height, randomSpeed, randomHeight, randomSpeed, "DOWN"));
      break;
    }
  }
}
/* .............................................................................................. */
void draw() {

  // SCENE 0 = blur --------------------------------------------------------------------------------
  if (scene ==0) {
    blur();
    scene = 1;
  }

  //SCENE 1 = rectMask Animation --------------------------------------------------------------------------------
  if (scene ==1) {
    nextSceneStarts=0;

    for (int i = 0; i < rectMasks.length; i++) {
      rectMasks[i].draw();
      rectMasks[i].update();

      if (rectMasks[i].stop) {
        nextSceneStarts++;
      }
    }
    if (nextSceneStarts >= rectMasks.length) {
      scene = 2;
    }
  }

  //SCENE 2 = fade  --------------------------------------------------------------------------------
  if (scene ==2) { 
    fade(3);
  }
  //SCENE 3 = line Mask --------------------------------------------------------------------------------

  if (scene ==3) { 
    nextSceneStarts=0;

    for (int i = 0; i < lineMasks.size(); i++) {
      LineMask lineM = lineMasks.get(i);
      lineM.draw();
      lineM.update();
      if (lineM.stop) {
        nextSceneStarts++;
      }
    }
    if (nextSceneStarts >= lineMasks.size()) {
      blur();
      scene = 4;
    }
  }
  //SCENE 4 = fade  --------------------------------------------------------------------------------
 if (scene ==4) { 
    fade(5);
  }

  // SCENE 5 = frame Animation --------------------------------------------------------------------------------
  if (scene ==5) {
    frames[0].draw();
    frames[0].update();
    if (frames[0].stop) {
      scene = 6;
    }
  }
    //SCENE 6 = fade  --------------------------------------------------------------------------------
 if (scene ==6) { 
    fade(0);
  } 
  
  // SAVE VIDEO ------------------------------------------------------------------------------------------------------

  // https://processing.org/reference/saveFrame_.html  
  // Saves each frame as line-000001.png, line-000002.png, etc.
  //saveFrame("exportVideo/landscape-######.png");  
}

// VOID FADE IN ------------------------------------------------------------------------------------------------------
void fade(int nextScene) {
  tint(255, transparency);     
  image(img1, 0, 0, 1680, 1050);
  transparency += 2;
  if (transparency >60) {
    transparency = 0;
    scene = nextScene;
  }
  
}
// VOID BLUR ------------------------------------------------------------------------------------------------------

void blur() {

  image(img1, 0, 0, 1680, 1050);
}