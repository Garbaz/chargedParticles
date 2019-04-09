class Charge extends PVector {
  float charge;
  PVector velocity;

  public Charge(float x, float y, float v_x, float v_y, float charge) {
    this.x = x;
    this.y = y;
    this.charge = charge;
    this.velocity = new PVector(v_x, v_y);
  }
  public Charge(float x, float y, float charge) {
    this(x, y, 0, 0, charge);
  }
  public Charge(PVector pos, PVector vel, float charge) {
    this(pos.x, pos.y, vel.x, vel.y, charge);
  }
  public Charge(PVector pos, float charge) {
    this(pos.x, pos.y, charge);
  }

  public void move_abs(float dx, float dy) {
    this.x += dx;
    this.y += dy;
  }

  public void drawMe() {
    fill(255, 255, 180);
    stroke(0);
    ellipse(x, y, 2*PARTICLE_DRAW_RADIUS, 2*PARTICLE_DRAW_RADIUS);
    if (charge != 0) {
      line(x-PARTICLE_DRAW_RADIUS, y, x+PARTICLE_DRAW_RADIUS, y);
    }
    if (charge > 0) {
      line(x, y-PARTICLE_DRAW_RADIUS, x, y+PARTICLE_DRAW_RADIUS);
    }
  }

  public void step(int dt) {

    this.add(PVector.mult(velocity, dt));

    final int BORDER_WIDTH = 5;
    final float BORDER_COLLISION_DAMPENING_FACTOR = 0.5;

    if (x < BORDER_WIDTH) {
      x = BORDER_WIDTH;
      velocity.x *= -BORDER_COLLISION_DAMPENING_FACTOR;
    }
    if (y < BORDER_WIDTH) {
      y = BORDER_WIDTH;
      velocity.y *= -BORDER_COLLISION_DAMPENING_FACTOR;
    }
    if (x > width-BORDER_WIDTH) {
      x = width-BORDER_WIDTH;
      velocity.x *= -BORDER_COLLISION_DAMPENING_FACTOR;
    }
    if (y > height-BORDER_WIDTH) {
      y = height-BORDER_WIDTH;
      velocity.y *= -BORDER_COLLISION_DAMPENING_FACTOR;
    }
  }
}
