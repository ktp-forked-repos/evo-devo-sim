/**********************************************
 *   TODO
 * Pan and zoom
 * Display with Voronoi
 * Enzyme activation cost energy
 * Interface to show cell properties on mouse over
 * Options to colour by various properties
 * Make amount of metabolite available to proteins a function of protein amount
 * Sensor domains
 * Different connection proteins
 * Transporters
 * Regulators
 * Genes
 * Evolution
***********************************************/

import java.util.*;
import java.util.Comparator;

Organism creature;
boolean running = false;
int updateCount = 0;

void setup() {
  size(960, 540);
  randomSeed(0);

  creature = new Organism();
  creature.addCell((width + 150) / 2, SOIL);
}

void draw() {
  // Sky
  background(160, 200, 255);

  // Ground
  noStroke();
  fill(160, 100, 60);
  rect(0, SOIL, width, height - SOIL);
  fill(100, 80, 60);
  rect(0, GROUND, width, height - GROUND);

  if (running) {
    creature.updateMilliseconds(60);
    //creature.updateN(10);
  }
  
  creature.draw();
  creature.drawConnections();
  
  drawInterface();
}

void drawInterface() {
  fill(255);
  stroke(10);
  strokeWeight(1);
  rect(-2, -2, 152, height + 4);
  
  fill(10);
  textSize(13);
  textAlign(LEFT, CENTER);
  text("Time: " + updateCount, 10, 12);
  text("Cell count: " + creature.cells.size(), 10, 30);
}

// Clicking on a cell triggers it to divide
void mousePressed() {
  for (Cell cell : creature.cells) {
    if (cell.mouseOver()) {
      cell.startDivision();
      break;
    }
  }
}

void keyPressed() {
  if (keyCode == 32) {
    running = !running;
  }
}
