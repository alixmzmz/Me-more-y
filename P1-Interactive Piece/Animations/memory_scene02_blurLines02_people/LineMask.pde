class LineMask { 

  float x, y;
  float xStart, yStart, xEnd, yEnd, speed, rectWidth, rectHeight; 
  String orientation;
  PImage img;
  boolean stop; // animation stops

  LineMask(float xS, float yS, float xE, float yE, float s, float rectW, float rectH, String o) {  

    stop = false;
    //round to sharp edges (full pixels)
    xStart = int(xS); 
    yStart = int(yS); 

    xEnd = int(xE);
    yEnd = int(yE);

    x = int(xS);
    y = int(yS);

    speed = s; 
    rectWidth = rectW;
    rectHeight = rectH;
    orientation = o;
    img = loadImage("animation-02-people.png");
  } 
  void update() { 

    // LEFT to RIGHT
    if (orientation == "RIGHT") {
      x += speed; 
      if (x > xEnd) { 
        //x = xStart; // line ends and starts again
        //img.filter(BLUR, 10);//painting blur over again - too slow using blur image instead
        img = loadImage("animation-02-people-blur.png");
        speed *= -1;
      }
      if (x < xStart) { // back to start point - origin 
        stop = true; //stop line animation
      }
    }

    // RIGHT to LEFT
    if (orientation == "LEFT") {
      x -= speed; 
      if (x < xEnd) { 
        img = loadImage("animation-02-people-blur.png");
        speed *= -1;
      }
      if (x > xStart) { 
        stop = true; //stop line animation
      }
    }

    if (orientation == "UP") {
      y -= speed;
      if (y < yEnd) { 
        img = loadImage("animation-02-people-blur.png");
        speed *= -1;
      }
      if (y > yStart) { 
        stop = true; //stop line animation
      }
    }

    if (orientation == "DOWN") {
      y += speed;
      if (y > yEnd) { 
        img = loadImage("animation-02-people-blur.png");
        speed *= -1;
      }
      if (y < yStart) { 
        stop = true; //stop line animation
      }
    }
  }

  void draw() {

    if (stop==false) {
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