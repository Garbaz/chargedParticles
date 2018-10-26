
//Constants
final int PARTICLE_DRAW_RADIUS = 5;
final float FORCE_DRAW_SCALAR = 1000;

//Variables
ArrayList<Charge> chargedParticles = new ArrayList<Charge>();
boolean stateChanged = true;

void setup() {
  size(640, 480);
  background(200);
}

void draw() {
  if (stateChanged) {
    stateChanged = false;
    background(200);
    for (Charge c : chargedParticles) {
      c.drawMe();
      PVector force = new PVector(0, 0);
      for (Charge d : chargedParticles) {
        if (PVector.dist(c, d) > 0) {
          force.sub(PVector.mult(PVector.sub(d, c), c.charge*d.charge / pow(PVector.dist(c, d), 2)));
        }
      }
      force.mult(FORCE_DRAW_SCALAR);
      stroke(255, 0, 0, 150);
      line(c.x, c.y, c.x+force.x, c.y+force.y);
      stroke(0);
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    chargedParticles.add(new Charge(mouseX, mouseY, 1));
    stateChanged = true;
  } else if (mouseButton == RIGHT) {
    chargedParticles.add(new Charge(mouseX, mouseY, -1));
    stateChanged = true;
  }
}

void keyPressed() {
  if (key == ' ') {
    chargedParticles.clear();
    stateChanged = true;
  }
}
