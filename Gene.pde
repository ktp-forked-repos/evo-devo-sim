// Set of all the genes required to build an organism
class Genome {
  int nPores = 2;
  int nConnectionProteins = 4;
  int nRegulatoryProteins = 4;
  int nAllProteins = nConnectionProteins + nConnectionProteins + nPores + 6;
  
  // Each pore is has a weight for each connection protein
  // This is the amount of that pore associated with each connection protein
  PositiveWeightValue[] poreWeights = new PositiveWeightValue[nPores * nConnectionProteins];
  
  // These are the default activity of each enzyme in the absence of regulatory proteins
  WeightValue[] biases = new WeightValue[nConnectionProteins + nConnectionProteins + nPores + 3];
  
  // These weights are used when determining the direction of cytokinesis
  // They weight the for gravity vector and each connection vector 
  WeightValue[] directionWeights = new WeightValue[nConnectionProteins + 1];
  ArrayList<DomainGene> domainGenes = new ArrayList<DomainGene>();
  
  // Create a random genome
  Genome() {
    // Create weights for which connection proteins each pore binds to
    for (int i = 0; i < poreWeights.length; i++) {
      poreWeights[i] = new PositiveWeightValue();
    }
    
    for (int i = 0; i < biases.length; i++) {
      biases[i] = new WeightValue();
    }
    
    for (int i = 0; i < directionWeights.length; i++) {
      directionWeights[i] = new WeightValue();
    }
    
    // Create 2 - 16 random domain genes
    int n = 2 + floor(random(14));
    for (int i = 0; i < n; i++) {
      domainGenes.add(new DomainGene());
    }
  }
  
  // Copy genome from an existing genome
  Genome(Genome parent) {
    for (int i = 0; i < poreWeights.length; i++) {
      this.poreWeights[i] = new PositiveWeightValue(parent.poreWeights[i].value);
    }
    
    for (int i = 0; i < biases.length; i++) {
      this.biases[i] = new WeightValue(parent.biases[i].value);
    }
    
    for (int i = 0; i < directionWeights.length; i++) {
      this.directionWeights[i] = new WeightValue(parent.directionWeights[i].value);
    }
    
    for (int i = 0; i < parent.domainGenes.size(); i++) {
      DomainGene parentGene = parent.domainGenes.get(i);
      this.domainGenes.add(new DomainGene(
        (int)parentGene.value1.value,
        (int)parentGene.value2.value,
        parentGene.value3.value
      ));
    }
  }
  
  // Create genome from string of DNA
  Genome(String dna) {
    String[] genes = dna.split(";");
    
    // Pore weights
    String[] poreWeights = genes[0].split(",");
    for (int i = 0; i < poreWeights.length; i++) {
        this.poreWeights[i] = new PositiveWeightValue(Float.valueOf(poreWeights[i]));
    }
    
    // Enzyme biases
    String[] biases = genes[1].split(",");
    for (int i = 0; i < biases.length; i++) {
        this.biases[i] = new WeightValue(Float.valueOf(biases[i]));
    }
    
    // Weights the direction of cytokinesis based on connection proteins
    String[] directionWeights = genes[2].split(",");
    for (int i = 0; i < directionWeights.length; i++) {
        this.directionWeights[i] = new WeightValue(Float.valueOf(directionWeights[i]));
    }
    
    // Domain genes
    for (int i = 3; i < genes.length; i++) {
      String[] values = genes[i].split(",");
      domainGenes.add(new DomainGene(
        Integer.valueOf(values[0]),
        Integer.valueOf(values[1]),
        Float.valueOf(values[2])
      ));
    }
  }

  String toString() {
    String s = "";
    
    s += getWeightString(poreWeights);
    s += getWeightString(biases);
    s += getWeightString(directionWeights);
    
    for (DomainGene gene : domainGenes) {
      s += gene.toString() + ';';
    }
    
    return s;
  }
  
  String getWeightString(WeightValue[] arr) {
    String s = "";
    
    for (int i = 0; i < arr.length; i++) {
        s += arr[i];
        s += (i < arr.length - 1) ? "," : ";";
    }
    
    return s;
  }
  
  Genome copy() {
    return new Genome(this.toString());
  }
  
  Genome getMutatedCopy() {
    Genome copiedGenome = new Genome(this);
    copiedGenome.mutate();
    return copiedGenome;
  }
  
  void mutate() {
    // Pore weights
    for (int i = 0; i < poreWeights.length; i++) { //<>//
      poreWeights[i].mutate();
    }
    
    for (int i = 0; i < biases.length; i++) {
      biases[i].mutate();
    }
    
    for (int i = 0; i < directionWeights.length; i++) {
      directionWeights[i].mutate();
    }
    
    // Domain genes
    for (DomainGene gene : domainGenes) {
      gene.mutate();
    }
    
    if (random(1) < GENE_DUPLICATION_RATE) {
      if (random(1) < 0.5) {
        // Delete a gene
        if (domainGenes.size() > 0) {
          int index = floor(random(domainGenes.size()));
          domainGenes.remove(index);
        }
      } else {
        // Add a new random domain
        domainGenes.add(new DomainGene());
      }
    }
  }
}


// Gene that determines that a given enzyme is regulated by the activation of a second enzyme with the given weight
class DomainGene {
  RegulatorIndex value1;
  RegulateeIndex value2;
  WeightValue value3;
  
  // Get random gene
  DomainGene() {
    value1 = new RegulatorIndex();
    value2 = new RegulateeIndex();
    value3 = new WeightValue();
  }
  
  DomainGene(int enzyme, int regulatedBy, float weight) {
    value1 = new RegulatorIndex(enzyme);
    value2 = new RegulateeIndex(regulatedBy);
    value3 = new WeightValue(weight);
  }
  
  void mutate() {
    value1.mutate();
    value2.mutate();
    value3.mutate();
  }
  
  String toString() {
    return value1 + "," + value2 + "," + value3;
  }
}

class WeightValue {
  float value;
  
  WeightValue(float value) {
    this.value = value;
  }
  
  WeightValue() {
    value = random(-10, 10);
  }
  
 String toString() { return Float.toString(value); }
  
  void mutate() {
    if (random(1) < MUTATION_RATE) {
      if (value == 0) {
        value = random(-10, 10);
      } else {
        float r = random(1);
        if (r > 0.5) {
          value *= random(0.9, 1.1);
        } else if (r > 0.25) {
          value *= random(0.8, 1.2);
        } else if (r > 0.125) {
          value *= random(0.6, 1.4);
        } else if (r > 0.0625) {
          value *= random(0.2, 1.8);
        } else {
          value *= -1;
        }
      }
    }
  }
}

class PositiveWeightValue extends WeightValue {
  float value;
  
  PositiveWeightValue(float value) {
    this.value = value;
  }
  
  PositiveWeightValue() {
    value = random(10);
  }
  
  void mutate() {
    if (random(1) < MUTATION_RATE) {
      if (value == 0) {
        value = random(10);
      } else {
        float r = random(1);
        if (r > 0.5) {
          value *= random(0.9, 1.1);
        } else if (r > 0.25) {
          value *= random(0.8, 1.2);
        } else if (r > 0.125) {
          value *= random(0.6, 1.4);
        } else if (r > 0.0625) {
          value *= random(0.2, 1.8);
        }
      }
    }
  }
}


// Index of a protein that can regulate other genes
class RegulatorIndex {
  float value;
  int maxValue = 16;
  
  RegulatorIndex(float value) {
    this.value = value;
  }
  
  RegulatorIndex() {
    value = floor(random(maxValue));
  }
  
  void mutate() {
    if (random(1) < MUTATION_RATE) {
      value = floor(random(maxValue));
    }
  }
  
  String toString() {
    return Integer.toString((int)value);
  }
}


// Index of a protein that is regulated other genes
class RegulateeIndex {
 float value;
 
  RegulateeIndex(float value) {
    this.value = value;
  }
  
  RegulateeIndex() {
    value = 3 + floor(random(13));
  }
  
  void mutate() {
    if (random(1) < MUTATION_RATE) {
      value = 3 + floor(random(13));
    }
  }
  
  String toString() {
    return Integer.toString((int)value);
  }
}
