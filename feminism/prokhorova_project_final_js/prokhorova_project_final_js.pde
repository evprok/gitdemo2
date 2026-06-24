

/**
 * Additive Wave + Animated Poetry
 * Based on Daniel Shiffman's Additive Wave example.
 *
 * This sketch combines:
 * 1. A procedurally generated wave animation
 * 2. A poem that fades in line-by-line
 * 3. A rainbow-colored thank-you message
 * 4. Interactive color themes controlled by mouse clicks
 * 5. An image of the group picture
 */

/* ----------------------------------------------------
   GLOBAL VARIABLES
   ----------------------------------------------------
   Store wave parameters, animation counters,
   and theme settings used throughout the sketch.
---------------------------------------------------- */
 
int xspacing = 8;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave
int maxwaves = 5;   // total # of waves to add together
int theme = 2;

float theta = 0.0;
float fadeCounter = 0;
float[] amplitude = new float[maxwaves];   // Height of wave
float[] dx = new float[maxwaves];          // Value for incrementing X, to be calculated as a function of period and xspacing
float[] yvalues;                           // Using an array to store height values for the wave (not entirely necessary)

PImage finalImage;

void setup() {
size(1000,900);
  colorMode(RGB, 255, 255, 255, 100);
  smooth();
  w = width + 20;
  
    finalImage = loadImage("image.jpg");

  for (int i = 0; i < maxwaves; i++) {
    amplitude[i] = random(10,30);
    float period = random(100,300); // How many pixels before the wave repeats
    dx[i] = (TWO_PI / period) * xspacing;
  }

  yvalues = new float[w/xspacing];
}

/* ----------------------------------------------------
   DRAW LOOP
   ----------------------------------------------------
   Runs continuously (~60 times per second).

   - Draws the selected background theme
   - Advances the fade animation
   - Calculates wave positions
   - Renders wave and text
---------------------------------------------------- */

void draw() {
 if (theme == 1) {
background(5, 15, 40); // Midnight Blue
} else {
background(40, 10, 0); // Sunset Gold
}

  fadeCounter += 0.5;

  calcWave();
  renderWave();
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // Set all height values to zero
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = 0;
  }
 
  // Accumulate wave height values
  for (int j = 0; j < maxwaves; j++) {
    float x = theta;
    for (int i = 0; i < yvalues.length; i++) {
      // Every other wave is cosine instead of sine
      if (j % 2 == 0)  yvalues[i] += sin(x)*amplitude[j];
      else yvalues[i] += cos(x)*amplitude[j];
      x+=dx[j];
    }
  }
}

/* ----------------------------------------------------
   RENDER WAVE
   ----------------------------------------------------
   Draws the animated wave as a series of circles.

   Theme 1:
     Midnight blue background with blue wave

   Theme 2:
     Sunset background with gold wave
---------------------------------------------------- */

void renderWave() {
  
noStroke();

if (theme == 1) {
  fill(180, 220, 255, 50);   // pale blue wave
} else {
  fill(255, 180, 80, 50);    // golden wave
}

ellipseMode(CENTER);

for (int x = 0; x < yvalues.length; x++) {
  ellipse(
    x * xspacing,
    height/2 + yvalues[x],
    16,
    16
  );
}

  /* ------------------------------------------------
     POEM DATA
     ------------------------------------------------
     The poem is stored as an array of strings.
     Each array element represents one line.
  ------------------------------------------------ */

String[] poem = {
  "Now I've heard there was a secret chord,",
  "That David played and it pleased the Lord,",
  "But you don't really care for music, do ya?",
  "It goes like this, the fourth, the fifth,",
  "The minor fall, the major lift,",
  "The baffled king composing Hallelujah."
  
  
 
};

// When to switch screens

  /* ------------------------------------------------
     POEM DISPLAY
     ------------------------------------------------
     Before switchFrame is reached, the poem
     appears one line at a time.

     fadeCounter creates the staggered fade-in
     effect so lines appear sequentially.
  ------------------------------------------------ */
int switchFrame = 1400;
int imageFrame = 1800;

textAlign(CENTER);
textSize(28);

if (frameCount < switchFrame) {

  // Show poem
  for (int i = 0; i < poem.length; i++) {

    float alpha = constrain(fadeCounter - i * 80, 0, 255);

    fill(255, alpha);

    text(
      poem[i],
      width/2,
      100 + i * 60 + yvalues[(i * 10) % yvalues.length] * 0.3
    );
  }

} else if (frameCount < imageFrame){


textAlign(CENTER);
textSize(36);

String msg1 = "Merci,  Montreal!";
String msg2 = "Thank you,  DHSI-2026.";

// Rainbow colors
color[] rainbow = {
color(255, 0, 0), // red
color(255, 127, 0), // orange
color(255, 255, 0), // yellow
color(0, 255, 0), // green
color(0, 0, 255), // blue
color(75, 0, 130), // indigo
color(148, 0, 211) // violet
};

    /* --------------------------------------------
       FLOATING ANIMATION
       --------------------------------------------
       The final messages gently move up and down
       using a sine wave for a calm visual effect.
    -------------------------------------------- */
// First line
float y1 = 150 + sin(frameCount * 0.03) * 10;
float startX1 = width/2 - textWidth(msg1)/2;

for (int i = 0; i < msg1.length(); i++) {
fill(rainbow[i % rainbow.length]);
text(msg1.charAt(i),
startX1 + textWidth(msg1.substring(0,i)),
y1);
}

// Second line
float y2 = 210 + sin(frameCount * 0.03) * 10;
float startX2 = width/2 - textWidth(msg2)/2;

for (int i = 0; i < msg2.length(); i++) {
fill(rainbow[i % rainbow.length]);
text(msg2.charAt(i),
startX2 + textWidth(msg2.substring(0,i)),
y2);
}
}


else {
   background(0);

   imageMode(CENTER);

   image(
     finalImage,
     width/2,
     height/2,
     finalImage.width * 0.35,
     finalImage.height * 0.35
   );
}

}

/* --------------------------------------------
       THANK-YOU SCREEN
       --------------------------------------------
       After the poem finishes, display a
       rainbow-colored thank-you message.

       Each letter receives a different color
       from the rainbow palette.
    -------------------------------------------- */


/* ----------------------------------------------------
   MOUSE INTERACTION
   ----------------------------------------------------
   Clicking the mouse cycles between the two
   color themes.

   Theme 1 → Midnight Blue
   Theme 2 → Sunset Gold
---------------------------------------------------- */

void mousePressed() {
  theme++;

  if (theme > 2) {
    theme = 1;
  }
}
