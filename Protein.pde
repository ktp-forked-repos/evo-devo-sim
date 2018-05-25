
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
    cell.dEnergy += activation * LIGHT * cell.light * (MAX_CELL_ENERGY - cell.energy) / MAX_CELL_ENERGY;
  }
};

// NitratePore takes up Nitrates from the soil
class NitrateUptaker extends Enzyme {
  NitrateUptaker(Cell cell) {
    super(cell);
  }
  
  void update() {
    cell.dNitrates += cell.soilSurface * constrain(activation * DIFFUSION * (BASE_NITRATES - cell.nitrates), 0, 1);
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
    cell.dProtein += maxRate;
    cell.dNitrates -= maxRate;
    cell.dEnergy -= maxRate * 2;
  }
};

// EnergyPore allows energy to diffuse between cells
class EnergyPore extends Enzyme {
  EnergyPore(Cell cell) {
    super(cell);
  }
  
  void update() {
    for (Cell cell2 : cell.connections) {
      float diffusion = activation * DIFFUSION * (cell2.energy - cell.energy);
      cell.dEnergy += diffusion;
      cell2.dEnergy -= diffusion;
    }
  }
};

// NitratePore allows nitrates to diffuse between cells
class NitratePore extends Enzyme {
  NitratePore(Cell cell) {
    super(cell);
  }
  
  void update() {
    for (Cell cell2 : cell.connections) {
      float diffusion = activation * DIFFUSION * (cell2.nitrates - cell.nitrates);
      cell.dNitrates += diffusion;
      cell2.dNitrates -= diffusion;
    }
  }
};
