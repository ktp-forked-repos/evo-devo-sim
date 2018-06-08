void drawInterface() {
  fill(255);
  stroke(10);
  strokeWeight(1);
  rect(-2, -2, 152, height + 4);
  
  fill(10);
  textSize(13);
  textAlign(LEFT, CENTER);
  
  int y = 12;
  y = writeData("Time: " + updateCount, y, 18);
  y = writeData("Cell count: " + creature.cells.size(), y, 18);
  
  if (targetCell != null) {
    textSize(11);
    y += 30;
    y = writeData("Cell id: " + targetCell.id, y);
    y = writeData("Position: " + targetCell.x + ", " + targetCell.y, y);
    y = writeData("Division: " + targetCell.divisionAmount, y);
    
    y += 8;
    y = writeData("Energy: " + targetCell.energy, y);
    y = writeData("Nitrates: " + targetCell.nitrates, y);
    y = writeData("Protein: " + targetCell.protein, y);
    
    y += 8;
    y = writeData("Light: " + targetCell.light, y);
    y = writeData("Soil: " + targetCell.soilSurface, y);
    
    drawEnzymeActivation(y);
  }
}

void drawEnzymeActivation(int y) {
  String[] enzymeNames = {
    "Light",
    "Energy",
    "Nitrates",
    "Chlorophyll",
    "N-uptake",
    "Anabolism",
    "Energy pore",
    "Nitrate pore",
    "Reg 1",
    "Reg 2",
    "Reg 3",
    "Reg 4",
    "Cxn 1",
    "Cxn 2",
    "Cxn 3",
    "Cxn 4"
  };
  
  y += 8;
  for (int i = 0; i < enzymeNames.length; i++) {
    y = writeData(enzymeNames[i] + ": " + targetCell.enzymes[i].activation, y);
  }
  
}

int writeData(String label, int y) {
  text(label, 10, y);
  return y + 15;
}

int writeData(String label, int y, int dy) {
  text(label, 10, y);
  return y + dy;
}
