/***   Dimensions   ***/

int CELL_R = 20;
int CELL_D = CELL_R * 2;

int GROUND = 680;
float SOIL = GROUND - CELL_R * 2.25;

/***   Physics   ***/

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

/***   Metabolism   ***/

float REPLICATION_COST = 500;

// Maximum of 2 units of energy produced per cell in full light
float LIGHT = 2;

// How much nitrates are available in the ground
float BASE_NITRATES = 200;

// Rate at which chemicals cross pores
float DIFFUSION = 0.01;
