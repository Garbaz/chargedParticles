/*
IDEAS:
 - Conductivity (?), Materials
 - Positionally fixed charges
 - Charge emitter
 - 
*/

//Constants
final int BACKGROUND_SHADE = 0xCC;
final float ACCELERATION_DRAW_SCALAR = 3e5;
final int PARTICLE_DRAW_RADIUS = 5;
final int FIELD_DRAW_RASTER = 32;

final float DEFAULT_CHARGE = 1e-1; // Scaled for convenient simulation speed. Not based on real world physics.


//Variables
ArrayList<Charge> chargedParticles = new ArrayList<Charge>();
boolean stateChanged = true;
int prevTime = 0;

boolean dynamic = false;
boolean drawAcceleration = false;
boolean drawField = false;

float total_dynamic_time = 0;

PVector[][] fieldVectors;

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

  fieldVectors = new PVector[width/FIELD_DRAW_RASTER][height/FIELD_DRAW_RASTER];
}

void draw() {
  int dt = millis() - prevTime;
  prevTime += dt;
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
        c.velocity.add(PVector.mult(acceleration, dt));
        c.step(dt);
      }
      c.drawMe();
    }
    if (drawField) {
      float strongestLocalField = 0;

      for (int i = 0; i < width/FIELD_DRAW_RASTER; i++) {
        for (int j = 0; j < height/FIELD_DRAW_RASTER; j++) {
          fieldVectors[i][j] = new PVector();
          for (Charge c : chargedParticles) {
            PVector cf = new PVector(float(FIELD_DRAW_RASTER)/2 + i*FIELD_DRAW_RASTER, float(FIELD_DRAW_RASTER)/2 + j*FIELD_DRAW_RASTER);
            cf.sub(c);
            float mag = cf.mag();
            cf.mult(c.charge/(mag*mag));
            fieldVectors[i][j].add(cf);
          }
          if (strongestLocalField < fieldVectors[i][j].mag()) strongestLocalField = fieldVectors[i][j].mag();
        }
      }
      colorMode(HSB, 1.0);
      for (int i = 0; i < width/FIELD_DRAW_RASTER; i++) {
        for (int j = 0; j < height/FIELD_DRAW_RASTER; j++) {
          stroke(0.66*(1.0-sqrt(fieldVectors[i][j].mag()/strongestLocalField)), 1.0, 0.8);
          fieldVectors[i][j].setMag(FIELD_DRAW_RASTER/2);
          drawArrow_(float(FIELD_DRAW_RASTER)/2 + i*FIELD_DRAW_RASTER, float(FIELD_DRAW_RASTER)/2 + j*FIELD_DRAW_RASTER, fieldVectors[i][j].x, fieldVectors[i][j].y);
        }
      }
      colorMode(RGB, 255);
    }

    if (dynamic) total_dynamic_time += dt/1000.0;

    fill(0);
    textAlign(RIGHT, BOTTOM);
    text("FPS: " + int(frameRate), width-2, height);
    textAlign(LEFT, BOTTOM);
    text("TIME: " + int(10*total_dynamic_time)/10.0 + " s", 0, height);
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
  } else if (key=='f') {
    drawField = !drawField;
    stateChange();
  }
}
