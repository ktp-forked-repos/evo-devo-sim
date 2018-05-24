class Cell {
  Organism organism;
  float x;
  float y;
  int id;

  float dx = 0;
  float dy = 0;
  float r = CELL_R;
 
  // Map of what cells are connected to this one 
  HashSet<Cell> connections = new HashSet<Cell>();
  
  // What proportion of division the cell has undertaken
  float divisionAmount = 0;
  Cell daughter;
  
  // What proportion of the cell is in light or in the soil
  float soilSurface = 0;
  float light = 1;
  
  // Metabolites
  float energy = 0;
  float nitrates = 0;
  float protein = 0;
  
  ArrayList<Enzyme> enzymes = new ArrayList<Enzyme>();

  Cell(Organism organism, float x, float y, int id) {
    this.organism = organism;
    this.x = x;
    this.y = y;
    this.id = id;
    
    // Add proteins
    enzymes.add(new Chlorophyll(this));
    enzymes.add(new NitratePore(this));
    enzymes.add(new Anabolism(this));
  }

  void draw() {
    strokeWeight(2);
    stroke(80, 255 * light, 255 * soilSurface);
    fill(80, 255 * light, 255 * soilSurface, 240);
    ellipse(x, y, r * 2, r * 2);
    
    textAlign(CENTER, CENTER);
    fill(10);
    //text(id, x, y);
    //text(soilSurface, x, y);
    //text(energy, x, y);
    //text(nitrates, x, y);
    text(protein, x, y);
  }

  void update() {
    determineSoilCoverage();
    metabolise();
      
    if (divisionAmount > 0) {
      divide();
    } else if (protein >= REPLICATION_COST) {
      startDivision();
    }
  }

  void metabolise() {
    for (Enzyme enzyme : enzymes) {
      enzyme.update();
    }
  }

  // Calculate the proportion of the cell's surface in contact with the soil
  void determineSoilCoverage() {
    float distanceBelowSoilTop = y - SOIL;
    
    if (distanceBelowSoilTop < -r) {
      soilSurface = 0;
    } else if (distanceBelowSoilTop > r) {
      soilSurface = 1;
    } else {
       soilSurface = (PI - 2 * asin(distanceBelowSoilTop / -r)) / TWO_PI;
    }
  }

  void move() {
    dx *= lerp(AIR_DAMPING, SOIL_DAMPING, soilSurface);
    dy *= lerp(AIR_DAMPING, SOIL_DAMPING, soilSurface);

    this.dy += GRAVITY;

    // Update positions
    x += dx + random(-0.1, 0.1);
    y += dy + random(-0.1, 0.1);

    // Hit the ground
    if (GRAVITY != 0 && y > GROUND - r) {
      y = GROUND - r;
    }
  }
  
  void startDivision() {
    protein -= REPLICATION_COST;
    divisionAmount = DIVISION_STEP; //<>//

    // Cytokinesis direction
    float ckx = random(-0.5, 0.5);
    float cky = random(-0.5, 0.5);
    
    // Normalise
    float d = sqrt(ckx * ckx + cky * cky);
    ckx /= d; 
    cky /= d;
    
    // Create a daughter cell
    daughter = organism.addDaughterCell(x + ckx, y + cky);
    
    // Connect mother and daughter
    this.connections.add(daughter);
    daughter.connections.add(this);
  }

  void divide() {
    // Proportion of division that has happened
    divisionAmount += DIVISION_STEP;
    
    // Move cells apart
    float targetDist = divisionAmount * (r + daughter.r);
    float dx = x - daughter.x;
    float dy = y - daughter.y;
    float currentDist = sqrt(dx * dx + dy * dy);
    float d = (targetDist - currentDist) * 0.5;
    dx /= currentDist;
    dy /= currentDist;

    // Move cells apart
    x += dx * d;
    y += dy * d;
    daughter.x -= dx * d;
    daughter.y -= dy * d;
    
    if (divisionAmount >= 1) {
        endDivision();
    }
  }
  
  void endDivision() {
    divisionAmount = 0;
    daughter = null;
  }
  
  boolean mouseOver() {
    if (dist(x, y, mouseX, mouseY) <= r) {
      return true;
    } else {
      return false;
    }
  }
}
