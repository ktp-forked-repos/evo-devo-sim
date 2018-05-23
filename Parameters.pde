int CELL_R = 20;
int CELL_D = CELL_R * 2;

int GROUND = 680;
float SOIL = GROUND - CELL_R * 2.25;

float AIR_DAMPING = 0.95;
float SOIL_DAMPING = 0.5;
float GRAVITY = 0.005;

// Maximum force from cells repelling on another
float REPEL_FORCE = 20;

// Force of connections between cells pulling them together
float CONTRACT_FORCE = 0.25;

// Maximum distance a connection can stretch before breaking
float MAX_STRETCH = 1.3 * CELL_D;
float MAX_STRETCH_2 = MAX_STRETCH * MAX_STRETCH;

float DIVISION_STEP = 0.005;
