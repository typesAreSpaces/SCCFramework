CURRENT_DIR=$(shell pwd)
IDIR=$(CURRENT_DIR)/include
ODIR=$(CURRENT_DIR)/obj
SDIR=$(CURRENT_DIR)/src
LDIR=$(CURRENT_DIR)/lib
TEST_DIR=$(CURRENT_DIR)/tests
BIN=$(CURRENT_DIR)/bin/scc

CXX=g++
OS=$(shell uname)
ifeq ($(OS), Darwin)
	PYTHON_CMD=python
	SO_EXT=dylib
	DYLD_LIBRARY_PATH=$(LDIR)
	export DYLD_LIBRARY_PATH
	NUM_PROCS=$(shell sysctl -n hw.logicalcpu)
endif
ifeq ($(OS), Linux)
	PYTHON_CMD=python
	SO_EXT=so
	NUM_PROCS=$(shell nproc)
endif
NUM_PROCS_H=$$(($(NUM_PROCS)/2))

SRC=$(wildcard $(SDIR)/*.cpp)
DEPS=$(wildcard $(IDIR)/*.h)
OBJS=$(SRC:$(SDIR)/%.cpp=$(ODIR)/%.o)
FLAGS=-I$(SDIR) -I$(IDIR) -std=c++11 -Wall

#FILE_TEST=$(TEST_DIR)/?

all: test

# ------------------------------------------
#  Rules to build the project
$(ODIR)/%.o: $(SDIR)/%.cpp $(DEPS) 
	@mkdir -p $(CURRENT_DIR)/obj
	$(CXX) -g -c -o $@ $(FLAGS) $<

$(BIN): $(OBJS) 
	@mkdir -p $(CURRENT_DIR)/bin
	$(CXX) -g -o $@ $(OBJS) $(FLAGS) -lpthread
# ------------------------------------------

test: $(BIN)
	$(BIN)

# ------------------------------
#  Cleaning
.PHONY: clean
clean:
	rm -rf $(ODIR)/* 
	rm -rf $(BIN)
# ------------------------------
