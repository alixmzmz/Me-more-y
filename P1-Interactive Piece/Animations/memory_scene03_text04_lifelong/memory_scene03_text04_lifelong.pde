/* Program to display a text and make it disappear (letter by letter)
 A gradient appears in the background */

// https://processing.org/reference/text_.html
// https://processing.org/reference/String.html

String originalText =  
  "The first time I was aware she did not recognise me, she was in the hospital with pneumonia. " +
  "We went to visit her. There were some family friends there; my aunt’s lifelong friends. She called them by their names; Lino and Mari Loli. " + 
  "She told me; thank you very much my dear for your visit. Like talking to a stranger. " +
  "I was in shock because she had no problem recognising family friends. Instead she could not recognise her own granddaughters. \n\n" + 
  "LIFELONG FRIENDS. FORGOTTEN GRANDDAUGHTERS.";

String textToDisplay = originalText;

int numOfFramesTextLegible; // to keep the text complete-legibble
int numOfFramesTextDisappear; // to count the cadence of frames to erase a letter
PFont font;
int transparency;

// GRADIENT
int x_axis = 1;
int y_axis = 2;
color col1, col2, textCol;
float gradientSize;

// BACKGROUND LINES from https://www.openprocessing.org/sketch/199480
float xstep = 5;
float ystep = 10;
float y = 0;
float nx = random(100);
float ny = random(100);
float nz = random(1000);

// FRAME
PImage img;
PImage imgFrameMask;

/* .............................................................................................. */
void setup() {

  size(1680, 1050);

  col1 = color(0, 64, 82); // dark blue
  col2 = color(0, 36, 46); // extra dark blue
  textCol = color(192, 254, 252); // original jade (29, 246, 241)

  gradientSize = 1; // 1 to solve the issue with map (is NaN when = 0)

  //https://processing.org/reference/frameRate_.html
  //frameRate(24);

  // LOAD FONT - https://processing.org/reference/loadFont_.html
  // The font must be located in the sketch's "data" directory to load successfully
  // http://processingjs.org/reference/createFont_/
  font = createFont("data/TypoPRO-Amble-Regular.ttf", 38);
  textFont(font);
  smooth(8);

  numOfFramesTextLegible = 0;  
  numOfFramesTextDisappear = 0;

  transparency = 0;
}
/* .............................................................................................. */
void draw() {

  background(42, 3, 39); // same as b1 colour\
  setGradient(0, 0, width, height, col1, col2, y_axis); // gradient stays when value is height

  // BACKGROUND LINES --------------------------------------------------------------
  stroke(255, 30);
  noFill();

  img = loadImage("data/images/_memory_scene03_texts_02.png");     
  imgFrameMask = loadImage("data/masks/mask_frame.png");
  img.mask(imgFrameMask);
  //img.filter(GRAY);
  image(img, 0,0);

  for (float j = 0; height+ystep > j; j+=ystep) {
    beginShape();
    vertex(0, j);
    for (float i = 0; i < width+xstep; i+=xstep) {
      nx = i/234;
      ny = j/165; 
      y = map(noise(nx, ny, nz), 0, 1, -100, 100)+j;
      curveVertex(i, y);
    }
    vertex(width, j);
    endShape();
  }
  nz+= 0.01;

  // TEXT ANIMATION STARTS ---------------------------------------------------------------------------
  numOfFramesTextLegible += 1;
  numOfFramesTextDisappear += 1;  

  // originalText starts disappearing after a few seconds to provide some time to read it before disappearing
  if (numOfFramesTextLegible > 240) { //6 seconds (30 fps x6) - time the text stays legible

    // letter disappear every 3 frames
    if (numOfFramesTextDisappear > 4) { 
      if (textToDisplay.length() > 1) { // https://processing.org/reference/String_length_.html
        int randomCharacterFromString = int(random(0, textToDisplay.length())); // 0 is the first character - 1 would be the 2nd char

        // 1ST CASE = 1st letter -------------------------------------------------------
        if (randomCharacterFromString == 0) {
          textToDisplay = textToDisplay.substring(randomCharacterFromString +1, textToDisplay.length());
        }
        // 2ND CASE = middle letter -------------------------------------------------------
        if (randomCharacterFromString > 0 && randomCharacterFromString < originalText.length()) { 
          // Returns a new string that is part of the input string
          // str.substring(beginIndex, endIndex) - substring substracts a piece of the string
          textToDisplay = textToDisplay.substring(0, randomCharacterFromString-1) //before the chosen character
            + textToDisplay.substring(randomCharacterFromString +1, textToDisplay.length()); // +1 to jump chosen character
        }
        // 3RD CASE = last letter -------------------------------------------------------
        if (randomCharacterFromString == textToDisplay.length()) {
          textToDisplay = textToDisplay.substring(0, randomCharacterFromString -1);
        }
      } else {
        textToDisplay = ""; // TEXT ANIMATION ENDS -----------------------------------------    

        // TEXT ANIMATION RESTARTS ---------------------------------------------------------
        numOfFramesTextLegible = 0;  
        textToDisplay = originalText;
        transparency = 0;
      }
      numOfFramesTextDisappear = 0; // start counting again to delete another letter
    }
  }

  fill(textCol, transparency); // fading transparency for the loop
  if (numOfFramesTextLegible < 60) {
    transparency += 10; 
    println(transparency);
  }
  // text(chars, start, stop, x, y)
  text(textToDisplay, width/7, height/5, width-width/3.5, height);  // Text wraps within text box


  // SAVE VIDEO --------------------------------------------------------------
  // https://processing.org/reference/saveFrame_.html  
  // Saves each frame as line-000001.png, line-000002.png, etc.
  //saveFrame("exportVideo/characters-######.png");
}
/* .............................................................................................. */
// GRADIENT
// https://processing.org/examples/lineargradient.html
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == y_axis) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == x_axis) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}