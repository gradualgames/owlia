#Makefile for The Legends of Owlia

#Utility programs
NAMELIST_GENERATOR = nlgen

#CA65 programs
ASSEMBLER       = ca65
LINKER          = ld65

#directories
SRC_DIR     = src
INCLUDE_DIR = include
BIN_DIR     = bin

#Files
OUTPUT_NAME     = owlia
NES_FILE        = $(OUTPUT_NAME).nes

#Core source files
FILES           += zp \
                   ram \
                   main \
                   play_state\
                   inventory_state\
                   title_state\
                   game_over_state\
                   cut_scene_state\
                   camera \
                   entity \
                   controller \
                   geotests \
                   map \
                   patch \
                   textbox \
                   conversation_data \
                   soundengine \
                   ppu \
                   mapper \
                   sprite \
                   inventory \
                   hero \
                   familiar \
                   entities \
                   sprite_chr_data \
                   bg_chr_data \
                   nametable_data \
                   slide_data \
                   music_data \
                   sfx_data \
                   map_data \
                   areas \
                   locations \
                   sprites_and_animations_data

OBJECT_FILES    = $(addprefix $(BIN_DIR)/,$(addsuffix .o, $(FILES)))
LST_FILES       = $(addprefix $(SRC_DIR)/,$(addsuffix .lst, $(FILES)))
CONFIG_FILE     = linker.cfg
MAP_FILE        = $(OUTPUT_NAME).map
DEBUG_FILE      = $(OUTPUT_NAME).dbg

#Switches
INCLUDE_FLAGS = -I include -I include/maps -I include/entities -I include/songs -I include/sprites_and_animations

ASSEMBLER_FLAGS = -g -l $(INCLUDE_FLAGS) -o
ifdef DEMO
ADDITIONAL_ASSEMBLER_FLAGS += -DDEMO_BUILD
endif
ifdef INVINCIBLE
ADDITIONAL_ASSEMBLER_FLAGS += -DINVINCIBLE
endif
ifdef INFINITE_ITEMS
ADDITIONAL_ASSEMBLER_FLAGS += -DINFINITE_ITEMS
endif
ifdef ALL_ITEMS
ADDITIONAL_ASSEMBLER_FLAGS += -DALL_ITEMS
endif
ifdef LEVEL_SELECTOR
ADDITIONAL_ASSEMBLER_FLAGS += -DLEVEL_SELECTOR_ENABLED
endif
ifdef CPU_USAGE
ADDITIONAL_ASSEMBLER_FLAGS += -DCPU_USAGE
endif
LINKER_FLAGS    = -C $(CONFIG_FILE) -m $(MAP_FILE) --dbgfile $(DEBUG_FILE) -o
NAMELIST_GENERATOR_FLAGS = -rom $(NES_FILE) \
                           -nl ram ZEROPAGE 0000 \
                           -nl ram STACK    0100 \
                           -nl ram BSS      0200 \
                           -nl 0   ROM00    8000 \
                           -nl 1   ROM01    8000 \
                           -nl 2   ROM02    8000 \
                           -nl 3   ROM03    8000 \
                           -nl 4   ROM04    8000 \
                           -nl 5   ROM05    8000 \
                           -nl 6   ROM06    8000 \
                           -nl 7   ROM07    8000 \
                           -nl 8   ROM08    8000 \
                           -nl 9   ROM09    8000 \
                           -nl 10  ROM10    8000 \
                           -nl 11  ROM11    8000 \
                           -nl 12  ROM12    8000 \
                           -nl 13  ROM13    8000 \
                           -nl 14  ROM14    8000 \
                           -nl 15  CODE     C000 \
                           -map $(MAP_FILE) \
                           $(addprefix -lst ,$(LST_FILES))

#Rules

#Rule for making the NES rom
all: $(NES_FILE)

#Rule for ensuring bin directory is present
$(BIN_DIR):
	mkdir $(BIN_DIR)

#Rule for making the NES rom and generating debug files for FCEUXDSP
debug: $(NES_FILE)
	$(NAMELIST_GENERATOR) $(NAMELIST_GENERATOR_FLAGS)

#Rule for linking the final NES rom
$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)

#Rule for assembling all the object files from source files
$(OBJECT_FILES): $(BIN_DIR)/%.o : $(SRC_DIR)/%.asm $(BIN_DIR)
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@ $(ADDITIONAL_ASSEMBLER_FLAGS)

#Rule for cleaning the build
clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAP_FILE) $(LST_FILES) $(DEBUG_FILE) *.nl
	rm -f $(SRC_DIR)/*.bak
	rm -rf $(BIN_DIR)
