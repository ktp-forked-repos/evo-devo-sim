/***   Dimensions   ***/

int CELL_R = 20;
int CELL_D = CELL_R * 2;

int GROUND = 520;  // Height - 20
float SOIL = GROUND - CELL_R * 2.25;

/***   Physics   ***/

float AIR_DAMPING = 0.95;
float SOIL_DAMPING = 0.5;
float GRAVITY = 0.005;

// Maximum force from cells repelling on another
float REPEL_FORCE = 20;

// Force of connections between cells pulling them together
float CONTRACT_FORCE = 0.25;

// Force pushing dividing cells apart
float DIVISION_FORCE = 0.5;

// Maximum distance a connection can stretch before breaking
float MAX_STRETCH = 1.3 * CELL_D;
float MAX_STRETCH_2 = MAX_STRETCH * MAX_STRETCH;

float DIVISION_STEP = 0.0025;

/***   Metabolism   ***/

float REPLICATION_COST = 500;

// How much energy each active unit of protein requires
float ENZYME_COST = 0.001;

float MAX_CHANGE_IN_ACTIVATION = 0.01;

// Maximum of 2 units of energy produced per cell in full light
float LIGHT = 2;

// Maximum energy that a cell can contain
float MAX_CELL_ENERGY = 10000;

// How much nitrates are available in the ground
float BASE_NITRATES = 200;

// Rate at which chemicals cross pores
float DIFFUSION = 0.005;
