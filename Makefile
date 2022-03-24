CURRENT_DIR=$(shell pwd)
IDIR=$(CURRENT_DIR)/include
ODIR=$(CURRENT_DIR)/obj
SDIR=$(CURRENT_DIR)/src
LDIR=$(CURRENT_DIR)/lib
TEST_DIR=$(CURRENT_DIR)/tests
BIN=$(CURRENT_DIR)/bin/scc
Z3_DIR=$(HOME)/Documents/GithubProjects/z3/build

CXX=g++
OS=$(shell uname)
ifeq ($(OS), Darwin)
	SO_EXT=dylib
	DYLD_LIBRARY_PATH=$(LDIR)
	export DYLD_LIBRARY_PATH
endif
ifeq ($(OS), Linux)
	SO_EXT=so
endif

SRC=$(wildcard $(SDIR)/*.cpp)
DEPS=$(wildcard $(IDIR)/*.h)
OBJS=$(SRC:$(SDIR)/%.cpp=$(ODIR)/%.o) $(Z3_DIR)/libz3.$(SO_EXT)
FLAGS=-I$(SDIR) -I$(IDIR) -std=c++11 -Wall

FILE_TEST=$(TEST_DIR)/smt2files/test_1.smt2

all: test

# ----------------------------------------------------------
#  Rules to build the project
$(ODIR)/%.o: $(SDIR)/%.cpp $(DEPS) $(Z3_DIR)/libz3.$(SO_EXT)
	@mkdir -p $(CURRENT_DIR)/obj
	$(CXX) -g -c -o $@ $(FLAGS) $<

$(BIN): $(OBJS) 
	@mkdir -p $(CURRENT_DIR)/bin
	$(CXX) -g -o $@ $(OBJS) $(FLAGS) -lpthread
# ----------------------------------------------------------

test: $(BIN)
	$(BIN) $(FILE_TEST)

refresh_tags:
	compiledb make test

# ----------------
#  Cleaning
.PHONY: clean
clean:
	rm -rf $(ODIR)/*
	rm -rf $(BIN)
# ----------------
