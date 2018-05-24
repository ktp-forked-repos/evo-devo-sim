// Sort cells so the highest is first
static final Comparator<Cell> SORT_BY_Y = new Comparator<Cell>() {
  @ Override int compare(Cell cell1, Cell cell2) {
    return Float.compare(cell1.y, cell2.y);
  }
};

class Organism {
  ArrayList<Cell> cells = new ArrayList<Cell>();
  ArrayList<Cell> newCells = new ArrayList<Cell>();
  int currentCellId = 0;

  // Create a new cell at position (x, y) and return it
  void addCell(float x, float y) {
    Cell cell = new Cell(this, x, y, currentCellId++);
    cells.add(cell);
  }
  
  // Adds cell to newCells array to avoid issues when iterating through the cells array
  Cell addDaughterCell(float x, float y) {
    Cell cell = new Cell(this, x, y, currentCellId++);
    newCells.add(cell);
    return cell;
  }

  void update() {
    // Sort from highest to lowest cell
    Collections.sort(cells, SORT_BY_Y);
    
    findLightOnCells();
    
    for (Cell cell : cells) {
      cell.update();
    }
    
    // Add new cells
    if (newCells.size() > 0) {
      cells.addAll(newCells);
      newCells.clear();
    }
    
    findCellConnections();
    
    for (Cell cell : cells) {
      cell.move();
    }
    
  }

  // Calculate light hitting each cell assume it comes directly down from above
  // and cells shade any cells beneath themselves.
  void findLightOnCells() {
    // Array of shaded regions
    ArrayList<PVector> shade = new ArrayList<PVector>();
    int n = cells.size();
    int i, j;
    float x1, x2;
    Cell cell = cells.get(0);
    
    // Add top cell, which has 100% light
    // Use PVector where x is x1, and y is x2
    shade.add(new PVector(cell.x - cell.r, cell.x + cell.r));
    cell.light = 1;
    
    for (i = 1; i < n; i++) {
      cell = cells.get(i);
      x1 = cell.x - cell.r;
      x2 = cell.x + cell.r;
        
      for (j = 0; j < shade.size(); j++) {
        if (x1 > shade.get(j).y) {
          if (j == shade.size() - 1) {
            // That was the last block, so we can add a new block at the end
            shade.add(new PVector(x1, x2));
            cell.light = 1;
            break;
          }
          // Cell starts after this block ends, so try next block
          continue;
        }
        
        if (x2 < shade.get(j).x) {
            // Cell ends before this block starts, so we can add it now, in the middle
            shade.add(j, new PVector(x1, x2));
            cell.light = 1;
        } else {
          // Cell's end overlaps with this block
          if (x1 > shade.get(j).x) {
            if (x2 < shade.get(j).y) {
                // New block completely inside this block
                cell.light = 0;
            } else {
              // Cell partly shaded
              float light = 1 - (shade.get(j).y - x1) / (cell.r * 2);
              
              // Cell starts inside this block and extends it right
              shade.get(j).y = x2;
              
              // Check whether cell also overlaps with the next block
              if (j < shade.size() - 1 && x2 > shade.get(j + 1).x) {
                // Cell shaded on its right too
                light -= (x2 - shade.get(j + 1).x) / (cell.r * 2);
                  
                // Join blocks
                shade.get(j).y = shade.get(j + 1).y;
                shade.remove(j + 1);
              }
              cell.light = light;
            }
          } else {
            // Right of cell is shaded
            cell.light = 1 - (x2 - shade.get(j).x) / (2 * cell.r);
  
            // Extend block left
            shade.get(j).x = x1;
          }
        }
        break;
      }
    }
  }

  void findCellConnections() {
    int i, j;
    int n = cells.size();
    int r2 = CELL_D * CELL_D;
    Cell cell1, cell2;
    float x1, y1, dx, dy, d, force;

    for (i = 0; i < n - 1; i++) {
      cell1 = cells.get(i);
      x1 = cell1.x;
      y1 = cell1.y;

      for (j = i + 1; j < n; j++) {
        cell2 = cells.get(j);
        
        // Ignore daughter cell
        if (cell1.daughter == cell2 || cell2.daughter == cell1) {
          continue;
        }
        
        dx = cell2.x - x1;
        dy = cell2.y - y1;
        d = dx * dx + dy * dy;

        if (d < r2) {
          // Cells overlap, so repel each other
          d = sqrt(d);
          force = REPEL_FORCE * sq((CELL_D - d) / CELL_D);
          dx /= d;
          dy /= d;

          cell1.dx -= force * dx;
          cell1.dy -= force * dy;
          cell2.dx += force * dx;
          cell2.dy += force * dy;
          
          // Overlapping cells form a connection
          cell1.connections.add(cell2);
          cell2.connections.add(cell1);
        } else if (cell1.connections.contains(cell2)) {
          if (d > MAX_STRETCH_2) {
            // Connection breaks
            cell1.connections.remove(cell2);
            cell2.connections.remove(cell1);
          } else {
            // Connection contracts
            d = sqrt(d);
            force = CONTRACT_FORCE * (d - CELL_D) / (MAX_STRETCH - CELL_D);
            dx /= d;
            dy /= d;
  
            cell1.dx += force * dx;
            cell1.dy += force * dy;
            cell2.dx -= force * dx;
            cell2.dy -= force * dy;
          }
        }
      }
    }
  }

  void draw() {
    for (Cell cell : cells) {
      cell.draw();
    }
  }
  
  void drawJoinedCells() {
    
  }
  
  void drawConnections() { 
    stroke(70, 100, 190, 200);
    strokeWeight(3);
    
    float r1 = CELL_R - 5;
    float r2 = CELL_R + 5;
    
    for (Cell cell1 : cells) {
      for (Cell cell2 : cell1.connections) {
        if (cell1.id < cell2.id) {
          float dx = cell2.x - cell1.x;
          float dy = cell2.y - cell1.y;
          float d = sqrt(dx * dx + dy * dy);
          dx /= d;
          dy /= d;
          line(cell1.x + r1 * dx, cell1.y + r1 * dy, cell1.x + r2 * dx, cell1.y + r2 * dy);
        }
      }
    }
  }

}
