/* Programm to load face images on the screen */

int imageNumber = 0;
int countFrames;
PImage screenCaptureBlur, screenCaptureGrey, screenCaptureSharp;
PImage maskImageBlur, maskImageGrey, maskImageSharp;
/* .............................................................................................. */
void setup() {

  size(1680, 1050);
  background(0);
  countFrames = 10;

  // LOAD INITIAL IMAGES  to cover the screen -------------------------------------------------------
  for (int x=0; x <= width; x+=random(70, 150)) {
    for (int y=0; y <= height; y+=random(70, 150)) {
      PImage img; 
      imageNumber = int(random(1, 1300)); // 1300 number of final food images on the folder
      img = loadImage("data/images/food_" + imageNumber +".jpg");

      if (img != null) {
        img.resize(img.width/3, img.height/3); // book image resized to height
        image(img, x, y);
      }
    }
  }
}
/* .............................................................................................. */
void draw() {

  if (countFrames == 10) { // 2-counter - 14 frames will load an image
    for (int x=0; x <= width; x+=random(400)) {

      // LOAD IMAGES  ---------------------------------------------------------------------------
      PImage img; //load image: https://processing.org/reference/loadImage_.html
      imageNumber = int(random(1, 1300)); // 1300 number of final food images on the folder
      img = loadImage("data/images/food_" + imageNumber +".jpg");
    
      if (img != null) {
        img.resize(img.width/3, img.height/3); // book image resized to height
        image(img, x, random(height));
      }
    }
    countFrames =0; // 3-counter - back to 0 to start again
  } else {
    countFrames += 1; // 1-counter - to control the speed of the animation
  }
  // 1- CAPTURE SCREEN  --------------------------- https://processing.org/reference/PImage_mask_.html-------
  screenCaptureSharp = get(0, 0, width, height); // (blur capture) https://processing.org/reference/get_.html
  screenCaptureBlur = get(0, 0, width, height); // (sharp circle middle)    
  screenCaptureGrey = get(0, 0, width, height); // (grey circle middle)

  maskImageBlur = loadImage("data/masks/mask_transparency.png"); // 2 - APPLY MASK   
  screenCaptureBlur.mask(maskImageBlur);
  screenCaptureBlur.filter(BLUR, 6); // BLUR - https://processing.org/reference/filter_.html
  screenCaptureBlur.blend(0, 0, width, height, 0, 0, width, height, BLEND); 
  image(screenCaptureBlur, 0, 0); // 3 - DRAW MASK 1 (sharp circle middle) --- https://processing.org/reference/PImage_mask_.html

  if (countFrames == 0) {
    maskImageGrey = loadImage("data/masks/mask_grey.png");  
    screenCaptureGrey.mask(maskImageGrey);
    //blend(img, 0, 0, 33, 100, 67, 0, 33, 100, SUBTRACT);
    screenCaptureGrey.filter(THRESHOLD); 
    screenCaptureGrey.filter(GRAY); 
    image(screenCaptureGrey, 0, 0);
  }

  maskImageSharp = loadImage("data/masks/mask_sharp.png");  
  screenCaptureSharp.mask(maskImageSharp);
  screenCaptureSharp.blend(0, 0, width, height, 0, 0, width, height, DARKEST); 
  image(screenCaptureSharp, 0, 0);

  // SAVE VIDEO  -------------------------------------
  // https://processing.org/reference/saveFrame_.html
  // Saves each frame as line-000001.png, line-000002.png, etc.
  //saveFrame("exportVideo/videoFood-######.png");
}