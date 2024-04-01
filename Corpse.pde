class Corpse {
  float density;
  float mass;
  float radius;
  float x;
  float y;
  float velX;
  float velY;
  color c;
  boolean locked;
  boolean destroyed;
  float bright;
  float r;
  float g;
  float b;
  

  Corpse (float x_, float y_, float density_, float radius_, float r_, float g_, float b_, boolean locked_, float bright_) {
    r = r_;
    g = g_;
    b = b_;
    
    locked = locked_;
    bright = bright_;

    radius = radius_;
    density = density_;
    mass = radius*radius*PI*density; // define the mass of the corpse

    x = x_;
    y = y_;
    velX = 0;
    velY = 0;
  }

  void step() {
    if (destroyed) return;
    if (locked)return;
    
    x += velX;
    y += velY;
  }

  void display(float xBias, float yBias) {
    stroke(bright);
    strokeWeight(radius*0.07);
    fill(color(r,g,b));

    circle(x+xBias, y+yBias, radius*2);
  }

  void calc(Corpse corpse) {
    if(destroyed || corpse.destroyed) return;
    
    // calc all forces and distances
    double distX = (corpse.x - x);
    double distY = (corpse.y - y);

    double distance = Math.sqrt(distX*distX + distY*distY);
    double force = (mass*corpse.mass) / (distance*distance);
    force = force * 6.674 * 0.05;

    double forceX = distX*force / distance;
    double forceY = distY*force / distance;

    // check collision
    if (distance <= (corpse.radius + radius)) {
      float massRelation = 1 / (corpse.mass + mass);
      velX = (corpse.velX*corpse.mass + velX*mass) * massRelation;
      velY = (corpse.velY*corpse.mass + velY*mass) * massRelation;
      
      mass = mass + corpse.mass;
      density = (corpse.density*corpse.mass + density*mass) * massRelation;
      
      r = (r + corpse.r) * 0.5;
      g = (g + corpse.g) * 0.5;
      b = (b + corpse.b) * 0.5;
      
      double t = Math.sqrt(mass / (density * PI));
      radius = (int) t;
           
      corpse.destroyed = true;
  } else {
      velX += forceX / mass;
      velY += forceY / mass;
    }
  }
}
