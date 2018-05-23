import java.util.*;
import java.util.Comparator;

Organism creature;

void setup() {
  size(700, 700);
  randomSeed(0);
    
  creature = new Organism();
  creature.addCell(width / 2, GROUND);
  creature.addCell(width / 2 + CELL_R, GROUND - CELL_R);
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

  for (int i = 0; i < 10; i++) {
    creature.update();
  }
  
  creature.draw();
  creature.drawConnections();
}

void mousePressed() {
    for (Cell cell : creature.cells) {
      if (cell.mouseOver()) {
        cell.startDivision();
        break;
      }
    }
};
