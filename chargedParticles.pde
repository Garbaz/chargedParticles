/*
IDEAS:
 - Conductivity (?), Materials
 - Positionally fixed charges
 - Charge emitter
 - 
 */

//Constants
final int BACKGROUND_SHADE = 220;
final int PARTICLE_DRAW_RADIUS = 5;
final float ACCELERATION_DRAW_SCALAR = 3e10;
final float DEFAULT_CHARGE = 1e-4; // Scaled for convenient simulation speed. Not based on real world physics.

//Variables
ArrayList<Charge> chargedParticles = new ArrayList<Charge>();
boolean stateChanged = true;
int prevTimeStep = 0;

boolean dynamic = false;
boolean drawAcceleration = false;

void stateChange() {
  stateChanged = true;
}

void add_charge(int x, int y, float charge) {
  chargedParticles.add(new Charge(x, y, charge));
  stateChange();
}

void add_charge(int x, int y, boolean positive) {
  if (positive) {
    add_charge(x, y, DEFAULT_CHARGE);
  } else {
    add_charge(x, y, -DEFAULT_CHARGE);
  }
}

void setup() {
  size(800, 640);
  background(BACKGROUND_SHADE);
}

void draw() {
  int currTimeStep = millis();
  int deltaTimeStep = prevTimeStep - currTimeStep;
  if (stateChanged || dynamic) {
    stateChanged = false;
    background(BACKGROUND_SHADE);
    for (Charge c : chargedParticles) {
      PVector acceleration = new PVector(0, 0);
      for (Charge d : chargedParticles) {
        if (PVector.dist(c, d) > 0) {
          acceleration.sub(PVector.mult(PVector.sub(d, c), c.charge*d.charge / pow(PVector.dist(c, d), 2)));
        }
      }
      if (drawAcceleration) {
        stroke(255, 0, 0, 100);
        drawArrow_(c, PVector.mult(acceleration, ACCELERATION_DRAW_SCALAR));
      }
      if (dynamic) {
        c.velocity.add(PVector.mult(acceleration, deltaTimeStep));
        c.step(deltaTimeStep);
      }
      c.drawMe();
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    add_charge(mouseX, mouseY, true);
  } else if (mouseButton == RIGHT) {
    add_charge(mouseX, mouseY, false);
  }
}

void keyPressed() {
  if (key == 'c') {
    chargedParticles.clear();
    stateChange();
  } else if (key == ' ') {
    dynamic = !dynamic;
  } else if (key == 'r') {
    add_charge((int)random(width), (int)random(height), random(2) < 1);
  } else if (key=='a') {
    drawAcceleration = !drawAcceleration;
    stateChange();
  }
}
