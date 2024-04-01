import java.util.ArrayList;
ArrayList<Corpse> all_corpses = new ArrayList<>();
ArrayList<Cell> all_cells = new ArrayList<>();

int CELLSIZE = 25;
int SCREEN_SIZE = 1600;

int WIDTH = SCREEN_SIZE;
int HEIGHT = SCREEN_SIZE/16*9;

void settings() {
  size(WIDTH, HEIGHT);

  for (int i = 0; i < WIDTH/CELLSIZE; i++) {
    for (int j = 0; j < HEIGHT/CELLSIZE; j++) {
      all_cells.add(new Cell(i, j));
    }
  }

  // create all corpses in the screen
}

float biasX = 0;
float biasY = 0;
float biasVelX = 0;
float biasVelY = 0;

float mostDensityCell = 1;
boolean field = false;

void draw() {
  background(0);

  fill(255);
  textSize(32); // display fps in the screen
  textAlign(CENTER);
  frameRate(60);

  for (int i = 0; i < all_corpses.size(); i++) { // calc all
    Corpse corpse = all_corpses.get(i);
    if (!corpse.destroyed) {

      for (int j = 0; j < all_corpses.size(); j++) { // step through all other corpses to calc forces
        if (j != i) {
          Corpse c = all_corpses.get(j);
          if (!c.destroyed) {
            corpse.calc(c);
          }
        }
      }
    }
  }

  for (int i = 0; i < WIDTH/CELLSIZE; i++) {
    for (int j = 0; j < HEIGHT/CELLSIZE; j++) {
      Cell c = all_cells.get(i+j*WIDTH/CELLSIZE);

      for (int k = 0; k < all_corpses.size(); k++) {
        Corpse corpse = all_corpses.get(k);

        double distX = (corpse.x - i*CELLSIZE);
        double distY = (corpse.y - j*CELLSIZE);

        double distance = Math.sqrt(distX*distX + distY*distY);
        double force = (2*corpse.mass*5) / (distance*distance);
        force = force * 6.674 * 0.05;

        double forceX = distX*force / distance;
        double forceY = distY*force / distance;
        c.forceX += forceX;
        c.forceY += forceY;
      }
    }
  }


  stroke(255);
  strokeWeight(1);
  if (field) {
    for (int i = 0; i < WIDTH/CELLSIZE; i++) {
      for (int j = 0; j < HEIGHT/CELLSIZE; j++) {
        Cell c = all_cells.get(i+j*WIDTH/CELLSIZE);

        float maxForce = CELLSIZE*2;

        float dX = abs(c.forceX) > maxForce*0.5 ? maxForce*0.5 * (c.forceX < 0 ? -1 : 1) : c.forceX;
        float dY = abs(c.forceY) > maxForce*0.5 ? maxForce*0.5 * (c.forceY < 0 ? -1 : 1) : c.forceY;

        line(i*CELLSIZE, j*CELLSIZE, i*CELLSIZE+dX, j*CELLSIZE+dY);
        c.forceX = 0;
        c.forceY = 0;
      }
    }
  }

  for (int i = 0; i < all_corpses.size(); i++) {
    Corpse corpse = all_corpses.get(i);
    if (!corpse.destroyed) {
      corpse.step(); // step all corpses and draw it
      corpse.display(biasX, biasY);
    } else all_corpses.remove(i);
  }

  stroke(255);
  fill(255);
  text(""+Math.floor(frameRate), WIDTH*0.5, 64);

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
  } else {
    biasX = 0;
    biasY = 0;
    biasVelX = 0;
    biasVelY = 0;
  }
  
  //
  //saveFrame("images/ola-########.png");
}

boolean center = false;

void keyPressed() {
  if (key == ' ') {
    if (center) center = false;
    else center = true;
  } else if (key == 'f') {
    if (field) field = false;
    else field = true;
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

  all_corpses.add(new Corpse(oldMouseX, oldMouseY, 15, 20, r, g, b, false, 255-brightness));
  Corpse c = all_corpses.get(all_corpses.size()-1);

  c.velX = (mouseX - oldMouseX - biasX)*0.05 + biasVelX;
  c.velY = (mouseY - oldMouseY - biasY)*0.05 + biasVelY;
}
