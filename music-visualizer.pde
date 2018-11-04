import ddf.minim.*;
import controlP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import org.openkinect.processing.*;


Minim minim;
BeatDetect beat;
FFT fftLog;
Kinect kinect;
AudioInput input;


ControlP5 cp5;

// Setup params
color bgColor = color(0, 0, 0);
static int SCREEN_WIDTH = 512;
static int SCREEN_HEIGHT = 424;

// Modifiable parameters
float spectrumScale = 2;
float STROKE_MAX = 10;
float STROKE_MIN = 2;
float strokeMultiplier = 1;
float audioThresh = .9;
float[] circles = new float[29];
float DECAY_RATE = 2;

float hue = random(255);

float[] wave = new float[512];

int count = 0;

void setup() {
  size(512, 424, P3D);  

  frameRate(60);

  minim = new Minim(this);
  cp5 = new ControlP5(this);
  input = minim.getLineIn();

  fftLog = new FFT( input.bufferSize(), input.sampleRate());
  fftLog.logAverages( 22, 3);

  ellipseMode(RADIUS);


  beat = new BeatDetect();

  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.initVideo();
  kinect.enableColorDepth(true);
  kinect.enableMirror(true);
  colorMode(HSB);
}

void draw() {
  background(0);
  pushMatrix();


  // Push new audio samples to the FFT
  fftLog.forward(input.left);


  // Loop through frequencies and compute width for ellipse stroke widths, and amplitude for size
  for (int i = 0; i < 29; i++) {

    // What is the average height in relation to the screen height?
    float amplitude = fftLog.getAvg(i);

    // If we hit a threshhold, then set the circle radius to new value
    if (amplitude<audioThresh) {
      circles[i] = amplitude*(SCREEN_HEIGHT/2);
    } else { // Otherwise, decay slowly
      circles[i] = max(0, min(SCREEN_HEIGHT, circles[i]-DECAY_RATE));
    }

    // What is the centerpoint of the this frequency band?
    float centerFrequency = fftLog.getAverageCenterFrequency(i);

    // What is the average width of this freqency?
    float averageWidth = fftLog.getAverageBandWidth(i);

    // Get the left and right bounds of the frequency
    float lowFreq = centerFrequency - averageWidth/2;
    float highFreq = centerFrequency + averageWidth/2;

    // Convert frequency widths to actual sizes
    int xl = (int)fftLog.freqToIndex(lowFreq);
    int xr = (int)fftLog.freqToIndex(highFreq);



    pushStyle();
    // Calculate the gray value for this circle
    //    stroke(amplitude*255);
    float gue = random(255);
    stroke(gue, 255, 255, amplitude);
    strokeWeight(map(amplitude, 0, 1, STROKE_MIN, STROKE_MAX));
    //    strokeWeight((float)(xr-xl)*strokeMultiplier);

    // Draw an ellipse for this frequency
    ellipse(0, 0, circles[i], circles[i]);

    popStyle();

    println(i);
  }

  popMatrix();
  //if (count>1) {
  //  background(0);
  //  count = 0;
  //} 
  stroke(255);  
  beat.detect(input.mix);

  PImage img = kinect.getDepthImage(); 
  int pixelSkip = 3;
  for (int q = 0; q < img.width; q+=pixelSkip) {
    for (int f = 0; f< img.height; f+=pixelSkip) {
      int index = q+f * img.width;
      int col = img.pixels[index];
      fill(col);
      if (red(col) > 150) {
        fill(hue, hue, 150);
        rect(q, f, pixelSkip, pixelSkip);
        if (beat.isOnset()) {
          hue = random(255);
          fill(hue+150, hue, hue-10);
          rect(q, f, random(40), random(40));
          count++;
        }
      }
    }
  }
}
