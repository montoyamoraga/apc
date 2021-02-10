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
ENCLOSURE_GRILL_DEPTH = 4;

ENCLOSURE_FILLET = 2;
ACCESSORY_FILLET = 1;

LIP_BOX_DEFAULT_LIP_HEIGHT = 3; // TODO: expose

ENCLOSURE_WIDTH = PCB_WIDTH
    + ENCLOSURE_INTERNAL_GUTTER * 2
    + ENCLOSURE_WALL * 2;
ENCLOSURE_LENGTH = PCB_LENGTH
    + BATTERY_LENGTH
    + ENCLOSURE_INTERNAL_GUTTER * 3
    + ENCLOSURE_WALL * 2;

ENCLOSURE_BOTTOM_HEIGHT = max(
    ENCLOSURE_FLOOR_CEILING + PCB_BOTTOM_CLEARANCE + PCB_HEIGHT,
    ENCLOSURE_FLOOR_CEILING + LIP_BOX_DEFAULT_LIP_HEIGHT
);

SWITCH_CLUTCH_VERTICAL_CLEARANCE = .4;
SWITCH_CLUTCH_SLIDE_CLEARANCE = 1.2;

MISC_CLEARANCE = 1;

PCB_X = ENCLOSURE_WALL + ENCLOSURE_INTERNAL_GUTTER;
PCB_Y = ENCLOSURE_WALL + ENCLOSURE_INTERNAL_GUTTER * 2 + BATTERY_LENGTH;
PCB_Z = ENCLOSURE_BOTTOM_HEIGHT - PCB_HEIGHT + SWITCH_CLUTCH_VERTICAL_CLEARANCE;

ENCLOSURE_HEIGHT =
    max(
        BATTERY_HEIGHT,
        PCB_Z + PCB_HEIGHT + PTV09A_POT_BASE_HEIGHT + PTV09A_POT_ACTUATOR_HEIGHT
    )
    + ENCLOSURE_FLOOR_CEILING;

Z_PCB_TOP = PCB_Z + PCB_HEIGHT;
Z_POT = Z_PCB_TOP + PTV09A_POT_BASE_HEIGHT + PTV09A_POT_ACTUATOR_HEIGHT
    - PTV09A_POT_ACTUATOR_D_SHAFT_HEIGHT;

DEFAULT_RIB_LENGTH = .8;
DEFAULT_RIB_GUTTER = 1.234;
