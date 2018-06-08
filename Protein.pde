
class Enzyme {
  Cell cell;
  float activation = 0;
  float activationChange = 0;
  float bias = 0;
  
  ArrayList<Enzyme> domainTargets = new ArrayList<Enzyme>();
  ArrayList<Float> domainWeights = new ArrayList<Float>();
  
  Enzyme(Cell cell) {
    this.cell = cell;
  }
  
  // Overwritten by child objects
  void update() {}
  
  void addDomain(int proteinIndex, float weight) {
    domainTargets.add(cell.enzymes[proteinIndex]);
    domainWeights.add(weight);
  }

  void regulate() {
    float newActivation = bias;
    
    for (int i = 0; i < domainTargets.size(); i++) {
        newActivation += domainTargets.get(i).activation * domainWeights.get(i);
    }
    
    // Pass through sigmoid function to constrain to [0, 1]
    newActivation = 1 / (1 + exp(-newActivation));
    
    // Limit change in activation to 5% in each direction
    activationChange = constrain(newActivation - this.activation, -MAX_CHANGE_IN_ACTIVATION, MAX_CHANGE_IN_ACTIVATION);
  };
};


// Chlorophyll uses light to generate energy
class Chlorophyll extends Enzyme {
  Chlorophyll(Cell cell) { super(cell); }
  
  void update() {
    cell.dEnergy += activation * LIGHT * cell.light * (MAX_CELL_ENERGY - cell.energy) / MAX_CELL_ENERGY;    
  }
};


// NitratePore takes up Nitrates from the soil
class NitrateUptaker extends Enzyme {
  NitrateUptaker(Cell cell) { super(cell); }
  
  void update() {
    cell.dNitrates += cell.soilSurface * constrain(activation * DIFFUSION * (BASE_NITRATES - cell.nitrates), 0, 1);
  }
};


// Anabolism converts nitrates and energy into protein
class Anabolism extends Enzyme {
  Anabolism(Cell cell) { super(cell); }
  
  void update() {
    if (this.activation == 0) { return; }
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


// Pores allows metabolites to diffuse between cells
class Pore extends Enzyme {
  float[] weights;
  
  Pore(Cell cell) { super(cell); }
   
  void addBindingWeights(float[] weights) {
    float maxWeights = 0.01;
    for (int i = 0; i < weights.length; i++) {
      maxWeights += weights[i];
    }
    
    if (maxWeights > 0) {
      for (int i = 0; i < weights.length; i++) {
        weights[i] /= maxWeights;
      }
    }
    
    this.weights = weights;
  }
  
  void addBindingWeights(GeneValue weight1, GeneValue weight2, GeneValue weight3, GeneValue weight4) {
    float[] weights = { weight1.value, weight2.value, weight3.value, weight4.value };
    addBindingWeights(weights);
  }
  
  float getActivePores(float[] connectivity) {
    float activePores = 0;
    for (int i = 0; i < connectivity.length; i++) { //<>//
      activePores += weights[i] * connectivity[i];
    }
    return activePores;
  }
};


// EnergyPore allows energy to diffuse between cells
class EnergyPore extends Pore {
  EnergyPore(Cell cell) { super(cell); }
  
  void update() {
    for (Map.Entry<Cell, float[]> entry : cell.connections.entrySet()) {
      Cell cell2 = entry.getKey();
      float[] connectionActivations = entry.getValue();
      float diffusion = getActivePores(connectionActivations); //<>//
      diffusion *= activation * DIFFUSION * (cell2.energy - cell.energy);
      cell.dEnergy += diffusion;
      cell2.dEnergy -= diffusion;
    }
  }
};


// NitratePore allows nitrates to diffuse between cells
class NitratePore extends Pore {
  NitratePore(Cell cell) { super(cell); }
  
  void update() {
    for (Map.Entry<Cell, float[]> entry : cell.connections.entrySet()) {
      Cell cell2 = entry.getKey();
      float[] connectionActivations = entry.getValue();
      float diffusion = getActivePores(connectionActivations);
      diffusion *= activation * DIFFUSION * (cell2.nitrates - cell.nitrates); //<>//
      cell.dNitrates += diffusion;
      cell2.dNitrates -= diffusion;
    }
  }
};


// LightSensor has an activation proportional to the light hitting the cell
class LightSensor extends Enzyme {
  LightSensor(Cell cell) { super(cell); }
  
  void update() { activation = cell.light; }
};


// EnergySensor has an activation proportional to the energy in the cell
class EnergySensor extends Enzyme {
  EnergySensor(Cell cell) { super(cell); }
  
  void update() { activation = cell.energy / (cell.energy + 500); }
};


// EnergySensor has an activation proportional to the energy in the cell
class NitrateSensor extends Enzyme {
  NitrateSensor(Cell cell) { super(cell); }
  
  void update() { activation = cell.nitrates / 200; }
};
