class Charge extends PVector {
  float charge;

  public Charge(int x, int y, float charge) {
    this.x = x;
    this.y = y;
    this.charge = charge;
  }
  public Charge(PVector pos, float charge) {
    this.x = pos.x;
    this.y = pos.y;
    this.charge = charge;
  }

  public void drawMe() {
    ellipse(x, y, 2*PARTICLE_DRAW_RADIUS, 2*PARTICLE_DRAW_RADIUS);
    if (charge != 0) {
      line(x-PARTICLE_DRAW_RADIUS, y, x+PARTICLE_DRAW_RADIUS, y);
    }
    if (charge > 0) {
      line(x, y-PARTICLE_DRAW_RADIUS, x, y+PARTICLE_DRAW_RADIUS);
    }
  }
}
