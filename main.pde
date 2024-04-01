import java.util.ArrayList;
ArrayList<Corpse> all_corpses = new ArrayList<>();

int SCREEN_SIZE = 1600;
void settings() {
  size(SCREEN_SIZE, SCREEN_SIZE/16*9);

  // create all corpses in the screen
}

float biasX = 0;
float biasY = 0;
float biasVelX = 0;
float biasVelY = 0;

void draw() {
  background(0);

  fill(255);
  textSize(32); // display fps in the screen
  textAlign(CENTER);
  frameRate(120);
  text(""+Math.floor(frameRate), 1024-64, 64);

  if (all_corpses.size() > 0 && center) {
    Corpse z = all_corpses.get(0);
    
    // display info
    textSize(16);
    textAlign(LEFT);
    text("Y: "+z.y, 16, 32);
    text("Vx: "+z.velX, 16, 48);
    text("Vy: "+z.velY, 16, 64);
    text("M: "+z.mass, 16, 80);
    text("D: "+z.density, 16, 96);
    text("R: "+z.radius, 16, 112);
    //

    biasX = -z.x + SCREEN_SIZE*0.5;
    biasY = -z.y + SCREEN_SIZE/16*9*0.5;
    
    biasVelX = z.velX;
    biasVelY = z.velY;
  }
  else {
    biasX = 0;
    biasY = 0;
    biasVelX = 0;
    biasVelY = 0;
  }
  
  for (int i = 0; i < all_corpses.size(); i++) { // calc all
    Corpse corpse = all_corpses.get(i);
    if (!corpse.destroyed) {

      for (int j = 0; j < all_corpses.size(); j++) { // step through all other corpses to calc forces
        if (j != i) {
          Corpse c = all_corpses.get(j);
          if (!c.destroyed) corpse.calc(c);
        }
      }
    }
  }

  for (int i = 0; i < all_corpses.size(); i++) {
    Corpse corpse = all_corpses.get(i);
    if (!corpse.destroyed) {
      corpse.step(); // step all corpses and draw it
      corpse.display(biasX, biasY);
    }
    else all_corpses.remove(i);
  }
}

boolean center = false;

void keyPressed() {
  if (key == ' ') {
    if (center) center = false;
    else center = true;
  }
}

float oldMouseX = 0;
float oldMouseY = 0;

void mousePressed() {
  oldMouseX = mouseX - biasX;
  oldMouseY = mouseY - biasY;
}

void mouseReleased() {
  float r = random(255);
  float g = random(255);
  float b = random(255);
  float brightness = (r+g+b) / 3;
  
  all_corpses.add(new Corpse(oldMouseX, oldMouseY, 10, 10, r,g,b, false, 255-brightness));
  Corpse c = all_corpses.get(all_corpses.size()-1);
  
  c.velX = (mouseX - oldMouseX - biasX)*0.05 + biasVelX;
  c.velY = (mouseY - oldMouseY - biasY)*0.05 + biasVelY;
}
