class Frame { 

  float x, y;
  float speed, rectWidth, rectHeight;
  int state;
  PImage img;
  int transparency;
  boolean stop;

  Frame(float xpos, float ypos, float s, float rectW, float rectH) {

    x = xpos;
    y = ypos;
    speed = s; 
    rectWidth = rectW;
    rectHeight = rectH;   
    state = 0;
    stop = false;
    img = loadImage("animation-06-dark.png");
  }
  /* .............................................................................................. */
  void update() { 

    if (state == 0) { // left to right
      x += speed;
      if (x > width) {
        state = 1;
        y = rectHeight;
        invertWidthHeight();
      }
    } else if (state == 1) { // up to down
      y += speed;
      x = width - rectWidth;
      if (y > height - rectHeight) { 
        state = 2;
        invertWidthHeight();
      }
    } else if (state == 2) { // right to left
      x -= speed;
      y = height - rectHeight;
      if (x < 0) {
        state = 3;
        invertWidthHeight();
      }
    } else if (state == 3) { // down to up
      y -= speed;
      if (y < rectHeight) {
        state = 4;
        x = 0;
        y = 0;
      }
    } else if (state == 4) { 
      stop = true;
    }
  }
  // swap frame-rect dimensions (invert width and height)
  /* .............................................................................................. */

  void invertWidthHeight() {
    float newWidth, newHeight;
    newWidth = rectHeight;
    newHeight = rectWidth;
    rectWidth = newWidth;
    rectHeight = newHeight;
  }
  /* .............................................................................................. */
  void draw() {
    if (state < 4) {
      // painting with Pixel https://www.youtube.com/watch?v=NbX3RnlAyGU
      color pixelColor;
      float pixelX, pixelY;

      //fill(255);
      noStroke();
      for (pixelX = x; pixelX < x + rectWidth; pixelX++) {
        for (pixelY = y; pixelY < y + rectHeight; pixelY++) {
          pixelColor = img.get(int(pixelX), int(pixelY));
          fill(pixelColor);
          rect(pixelX, pixelY, 1, 1);
        }
      }
    }
  }
}