# Makefile for running VCS commands based on target

# Default VCS options
VCS_OPTS = -sverilog -timescale=1ns/1ps

# Targets
baseline:
	vcs $(VCS_OPTS) -f files.list && ./simv

class_based:
	vcs $(VCS_OPTS) -f files_class.list && ./simv

# Clean target to remove generated files
clean:
	rm -rf simv simv* csrc ucli.key results/* verdiLog novas* nWaveLog
