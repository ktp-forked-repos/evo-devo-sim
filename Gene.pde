// Set of all the genes required to build an organism
class Genome {
  int nPores = 2;
  int nConnectionProteins = 4;
  int nRegulatoryProteins = 4;
  int nAllProteins = nConnectionProteins + nConnectionProteins + nPores + 6;
  
  PositiveWeightValue[] poreWeights = new PositiveWeightValue[nPores * nConnectionProteins];
  WeightValue[] biases = new WeightValue[nConnectionProteins + nConnectionProteins + nPores + 3];
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
    
    // Create 2 - 16 random domain genes
    int n = 2 + floor(random(14));
    for (int i = 0; i < n; i++) {
      domainGenes.add(new DomainGene());
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
    
    // Pore weights
    String[] biases = genes[1].split(",");
    for (int i = 0; i < biases.length; i++) {
        this.biases[i] = new WeightValue(Float.valueOf(biases[i]));
    }
    
    // Domain genes
    for (int i = 2; i < genes.length; i++) {
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
    
    for (int i = 0; i < poreWeights.length; i++) {
        s += poreWeights[i];
        s += (i < poreWeights.length - 1) ? "," : ";";
    }
    
    for (DomainGene gene : domainGenes) {
      s += gene.toString() + ';';
    }
    
    return s;
  }
  
  void copy() {
  }
  
  void mutate() {
    // Pore weights
    for (int i = 0; i < poreWeights.length; i++) {
      poreWeights[i].mutate();
    }
    
    for (int i = 0; i < biases.length; i++) {
      biases[i].mutate();
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
  GeneValue[] values = new GeneValue[3];
  
  // Get random gene
  DomainGene() {
    values[0] = new RegulatorIndex();
    values[1] = new RegulateeIndex();
    values[2] = new WeightValue();
  }
  
  DomainGene(int enzyme, int regulatedBy, float weight) {
    values[0] = new RegulatorIndex(enzyme);
    values[1] = new RegulateeIndex(regulatedBy);
    values[2] = new WeightValue(weight);
  }
  
  void mutate() {
    values[0].mutate();
    values[1].mutate();
    values[2].mutate();
  }
  
  String toString() {
    return values[0] + "," + values[1] + "," + values[2];
  }
}


// Generic class for the value for gene might have
class GeneValue {
  float value;
  
  GeneValue() {}
  
  GeneValue(float value) {
    this.value = value;
  }
  
  void mutate() {}
  
  String toString() { return Float.toString(value); }
}


class WeightValue extends GeneValue {
  WeightValue(float value) {
    super(value);
  }
  
  WeightValue() {
    super();
    value = random(-10, 10);
  }
  
  void mutateWeight() {
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


class PositiveWeightValue extends GeneValue {
  PositiveWeightValue(float value) {
    super(value);
  }
  
  PositiveWeightValue() {
    super();
    value = random(10);
  }
  
  void mutateWeight() {
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
class RegulatorIndex extends GeneValue {
  int maxValue = 16;
  
  RegulatorIndex(float value) {
    super(value);
  }
  
  RegulatorIndex() {
    super();
    value = floor(random(maxValue));
  }
  
  void mutateWeight() {
    if (random(1) < MUTATION_RATE) {
      value = floor(random(maxValue));
    }
  }
  
  String toString() {
    return Integer.toString((int)value);
  }
}


// Index of a protein that is regulated other genes
class RegulateeIndex extends GeneValue {
  RegulateeIndex(float value) {
    super(value);
  }
  
  RegulateeIndex() {
    super();
    value = 3 + floor(random(13));
  }
  
  void mutateWeight() {
    if (random(1) < MUTATION_RATE) {
      value = 3 + floor(random(13));
    }
  }
  
  String toString() {
    return Integer.toString((int)value);
  }
}
