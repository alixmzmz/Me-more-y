/* 
 Programm to render an image with a GLSL shader: #channel
 Original #channel code shader: https://github.com/genekogan/Processing-Shader-Examples 
 
 Shaders - https://processing.org/tutorials/pshader/
 A shader is basically a program that runs on the Graphics Processing Unit (GPU) of the computer, 
 and generates the visual output we see on the screen given the information that defines a 2D or 3D scene: vertices, colors, textures, lights, etc.
 
 GLSL. Is the shader language included in OpenGL, GLSL simply stands for OpenGL Shading Language. 
 Processing uses OpenGL as the basis for its P2D and P3D renderers
 
 http://thebookofshaders.com/
 */

PImage img;
PShader shade;

float angle; // for circumference
float x, y;
int numberOfTotalPoints = 2048; // bigger number: bigger resolution
float diameter;
int numberOfPointsPainted;
float alphaImg, alphaBg;
float incrementAlphaImg, incrementAlphaBg;
boolean startVideoImgFull; // save video frames when alpha image is 100% and alpha bg 0


// ........................................................
void setup() {

  size(1680, 1050, P2D);
  background(0);

  // load image
  img = loadImage("data/memory_cocido.jpg");

  startVideoImgFull = false; // video is not recording

  setupShader();

  diameter = width/16;
  numberOfPointsPainted = 0;
  alphaImg = 0; // image transparency
  alphaBg = 130; // black fill transparency to do the fade effect
  incrementAlphaImg = 0.5;
  incrementAlphaBg = 5;
}
// ........................................................
void draw() {

  background(0);
  setupShaderParameters();

  // turn on shader and display image
  shader(shade);

  // TINT - https://processing.org/reference/tint_.html  
  image(img, 0, 0, 1680, 1050);

  // FILTERS https://processing.org/reference/filter_.html
  filter(GRAY);

  // turn off shader
  resetShader();

  tint(255, alphaImg);  // Apply transparency without changing color
  image(img, 0, 0, 1680, 1050);
  alphaImg += incrementAlphaImg;

  // initial fade to black 
  alphaBg -= incrementAlphaBg;
  fill(0, alphaBg);
  noStroke();
  rect(0, 0, width, height);

  // Loop video
  if (alphaImg > 255 && alphaBg < 0) { // end of animation and reverse it
    incrementAlphaImg = -incrementAlphaImg;  // instead of adding, substract to reverse animation effect
    incrementAlphaBg = -incrementAlphaBg; // instead of adding, substract to reverse animation effect
    startVideoImgFull = true; // start recording video as image is 255/full and alphaBg = 0]
    println(frameCount); // print which frame is the fullImage
  }

  if (alphaImg < 0 && alphaBg > 130) { // begin of animation
    incrementAlphaImg = -incrementAlphaImg;  // instead of adding, substract to reverse animation effect
    incrementAlphaBg = -incrementAlphaBg; // instead of adding, substract to reverse animation effect
  }

  // SAVE VIDEO
  // https://processing.org/reference/saveFrame_.html  
  // Saves each frame as line-000001.png, line-000002.png, etc.
  //if (startVideoImgFull == true) {
  //saveFrame("exportVideo/cocido-######.png");
  //}
}

// ........................................................
void setupShader() {

  shade = loadShader("data/channels.glsl");
}

// ........................................................
void setupShaderParameters() {

  // controller: control parameters of the shader within a circular path for a smoother movement (instead of using randomness)

  // define x, y to include them on the shader path controller
  x = diameter*cos(angle)+ width/2;
  y = diameter*sin(angle) + height/2;

  // fill(255,255,0);
  // ellipse(diameter*cos(angle)+ width/2, diameter*sin(angle) + height/2, diameter/10, diameter/10);

  angle += TWO_PI/numberOfTotalPoints;
  numberOfPointsPainted++;
  if (numberOfPointsPainted >= numberOfTotalPoints) {
    numberOfPointsPainted = 0;
  }

  // channels
  shade.set("rbias", 0.0, 0.0);
  shade.set("gbias", map(y, 0, height, -0.2, 0.2), 0.0); // Green channel
  shade.set("bbias", 0.0, 0.0);
  // multiply
  //shade.set("rmult", map(x, 0, width, 0.8, 1.5), 1.0); // Red channel
  shade.set("rmult", map(x, 0, width, 0.8, 1.0), 1.0); // Red channel
  shade.set("gmult", 1.0, 1.0); //
  shade.set("bmult", 1.0, 1.0);
}

// ........................................................