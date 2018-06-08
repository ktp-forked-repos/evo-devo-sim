/**********************************************
 *   TODO
 * Direction of cytokinesis based on connection proteins
 * Genes for weighting cytokinesis
 * Activation of daughter proteins equal to parent proteins
 * Evolution
 * Pan and zoom
 * Display with Voronoi
 * Options to colour by various properties
 * Create testing setup
 * Make amount of metabolite available to proteins a function of protein amount
 * Transporters
 * Connection proteins activate other proteins based on connectivity 
 * Allow number of regulators and connectors to mutate
***********************************************/

import java.util.*;
import java.util.Comparator;

Organism creature;
Cell targetCell;
boolean running = true;
int updateCount = 0;

void setup() {
  size(960, 540);
  randomSeed(0);

  //String dna = "1,0,0,0,1,1,0,0;9,0,20;3,9,10;3,10,-12;6,8,10;7,8,10;8,8,10;12,8,10;";
  String dna = "1,0,0,0,1,1,0,0;0,0,0,0,0,0,0,0,0,0,0,0,0;9,0,20;3,9,10;3,10,-12;4,8,10;5,8,10;6,8,10;7,8,10;8,8,10;12,8,10;";
  creature = new Organism(dna);
  
  Cell seed = creature.addCell((width + 150) / 2, SOIL + CELL_R);
  
  // Seeds start with an initial amount of energy to avoid immediate starvation
  seed.energy = 200;
  
  // Regulatory protein 1 starts with activation of 1 to kick start things
  seed.enzymes[8].activation = 1;
  
  // Create second cell to test properties
  //Cell seed2 = creature.addCell((width + 150) / 2 + CELL_R * 2, SOIL + CELL_R);
  //seed2.energy = 200;
  //seed2.nitrates = 200;
  //seed.enzymes[8].activation = 1;
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

  creature.draw();
  creature.drawConnections(); //<>//
  drawInterface();
  
  if (running) {
    creature.updateMilliseconds(60);
    //creature.updateN(10);
    //creature.update();
    
    //int m = millis();
    //creature.updateN(15000);
    //println(millis() - m);
    //running = false;
  }
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

// Mouseover to get cell information
void mouseMoved() {
  targetCell = null;
  for (Cell cell : creature.cells) {
    if (cell.mouseOver()) {
      targetCell = cell;
      break;
    }
  }
}

void keyPressed() {
  if (keyCode == 32) {
    running = !running;
  }
}
