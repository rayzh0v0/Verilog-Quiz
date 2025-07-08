include ../config.mk

# Target executable
TARGET = top_tb.out

# Verilog source files
SRC = top.v top_tb.sv

# Waveform output file
VCD = top.vcd

# Compiler and simulator
COMPILER = iverilog
VVP = vvp

# Enable SystemVerilog features and debug
IVERILOG_FLAGS = -g2012 -Wall

all: compile run

compile:
	$(COMPILER) $(IVERILOG_FLAGS) -o $(TARGET) $(SRC)

# Run the simulation
run:
	$(VVP) $(TARGET)

# Run simulation and generate waveform
wave: compile
	$(WAVE_VIWER) $(VCD) &

# Clean up generated files
clean:
	rm -f $(TARGET) $(VCD) *.vcd *.lxt *.log

# Help message
help:
	@echo "Available targets:"
	@echo "  all       - Compile and run simulation (default)"
	@echo "  compile   - Compile the Verilog design"
	@echo "  run       - Run the simulation"
	@echo "  wave      - View waveform in GTKWave"
	@echo "  clean     - Remove generated files"
	@echo "  help      - Display this help message"

.PHONY: all compile run wave clean help