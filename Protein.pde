
class Enzyme {
  Cell cell;
  float activation = 0.5;
  
  Enzyme(Cell cell) {
    this.cell = cell;
  }
  
  // Overwritten by child objects
  void update() {}
};

// Chlorophyll uses light to generate energy
class Chlorophyll extends Enzyme {
  Chlorophyll(Cell cell) {
    super(cell);
  }
  
  void update() {
    cell.energy += activation * LIGHT * cell.light;
  }
};

// NitratePore takes up Nitrates from the soil
class NitratePore extends Enzyme {
  NitratePore(Cell cell) {
    super(cell);
  }
  
  void update() {
    cell.nitrates += cell.soilSurface * constrain(activation * DIFFUSION * (BASE_NITRATES - cell.nitrates), 0, 1);
  }
};

// Anabolism converts nitrates and energy into protein
class Anabolism extends Enzyme {
  Anabolism(Cell cell) {
    super(cell);
  }
  
  void update() {
    // This is the maximum proportion of each metabolite that is available to this enzyme
    float limit = 0.1;
    float limitC = min(1, cell.energy * limit / (this.activation * 2));
    float limitN = min(1, cell.nitrates * limit / this.activation);
    
    // Maximum flux through enzyme
    float maxRate = min(limitC, limitN) * this.activation;
    cell.protein += maxRate;
    cell.nitrates -= maxRate;
    cell.energy -= maxRate * 2;
  }
};
