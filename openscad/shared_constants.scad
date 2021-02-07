// TODO: remove any includes. this file should have no dependencies...
include <battery.scad>;
include <pcb.scad>;

DEFAULT_ROUNDING = $preview ? undef : 24;
HIDEF_ROUNDING = $preview ? undef : 120;

DEFAULT_FDM_LAYER_HEIGHT = .2;

DEFAULT_TOLERANCE = .1;

ENCLOSURE_WALL = 2.4;
ENCLOSURE_INNER_WALL = 1.2;
ENCLOSURE_FLOOR_CEILING = 1.8;
ENCLOSURE_INTERNAL_GUTTER = 2;
ENCLOSURE_SIDE_OVEREXPOSURE = 2;

ENCLOSURE_WIDTH = PCB_WIDTH
    + ENCLOSURE_INTERNAL_GUTTER * 2
    + ENCLOSURE_WALL * 2;
ENCLOSURE_LENGTH = PCB_LENGTH
    + BATTERY_LENGTH
    + ENCLOSURE_INTERNAL_GUTTER * 3
    + ENCLOSURE_WALL * 2;

// TODO: expose LIP_BOX_DEFAULT_LIP_HEIGHT
ENCLOSURE_BOTTOM_HEIGHT = ENCLOSURE_FLOOR_CEILING + 3;

PCB_X = ENCLOSURE_WALL + ENCLOSURE_INTERNAL_GUTTER;
PCB_Y = ENCLOSURE_WALL + ENCLOSURE_INTERNAL_GUTTER * 2 + BATTERY_LENGTH;
PCB_Z = ENCLOSURE_FLOOR_CEILING + PCB_BOTTOM_CLEARANCE;

ENCLOSURE_HEIGHT =
    max(
        BATTERY_HEIGHT,
        PCB_Z + PCB_HEIGHT + PTV09A_POT_BASE_HEIGHT + PTV09A_POT_ACTUATOR_HEIGHT
    )
    + ENCLOSURE_FLOOR_CEILING;

Z_PCB_TOP = PCB_Z + PCB_HEIGHT;
Z_POT = Z_PCB_TOP + PTV09A_POT_BASE_HEIGHT + PTV09A_POT_ACTUATOR_HEIGHT
    - PTV09A_POT_ACTUATOR_D_SHAFT_HEIGHT;
