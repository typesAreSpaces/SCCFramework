CURRENT_DIR=$(shell pwd)
IDIR=$(CURRENT_DIR)/include
ODIR=$(CURRENT_DIR)/obj
SDIR=$(CURRENT_DIR)/src
LDIR=$(CURRENT_DIR)/lib
TEST_DIR=$(CURRENT_DIR)/tests/smt2-files

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
OBJS=$(SRC:$(SDIR)/%.cpp=$(ODIR)/%.o) $(LDIR)/libz3.$(SO_EXT)
FLAGS=-I$(SDIR) -I$(IDIR) -std=c++11 -Wall

METHOD=0# Z3
#METHOD=1# MATHSAT
#METHOD=2# SMTINTERPOL

ALLOWED_ATTEMPS=1000000

#-- Supported Theories
#THEORY=QF_TO
#THEORY=QF_IDL
#THEORY=QF_UTVPI
THEORY=QF_LIA

#-- Sample files
#FILE_TEST=$(TEST_DIR)/relax-1.c_valid-memsafety.prp.smt2
#FILE_TEST=$(TEST_DIR)/array_tiling_poly6.c_unreach-call.prp.smt2
#FILE_TEST=$(TEST_DIR)/simple.smt2
#FILE_TEST=$(TEST_DIR)/simple2.smt2
#FILE_TEST=$(TEST_DIR)/simple3.smt2
#FILE_TEST=$(TEST_DIR)/simple4.smt2
#FILE_TEST=$(TEST_DIR)/ijcar_2018_paper_example4_n_4.smt2
#FILE_TEST=$(TEST_DIR)/length_example.smt2
#FILE_TEST=$(TEST_DIR)/maxdiff_paper_example_compact.smt2
#FILE_TEST=$(TEST_DIR)/maxdiff_paper_example_another_another.smt2
#FILE_TEST=$(TEST_DIR)/maxdiff_paper_example.smt2
#FILE_TEST=$(TEST_DIR)/jhala.smt2
FILE_TEST=$(TEST_DIR)/strcpy_example_variant_1.smt2
#FILE_TEST=$(TEST_DIR)/strcpy_example_variant_2.smt2
#FILE_TEST=$(TEST_DIR)/strcpy_example_variant_3.smt2

all: tests/one
#all: tests/all
#all: tests/print_all

# -------------------------------------------------------------------------------
#  Rules to build the project
$(LDIR)/libz3.$(SO_EXT):
	@mkdir -p $(CURRENT_DIR)/lib
	[ -z "$(ls -A ./dependencies/z3-interp-plus)" ]\
		&& git submodule update --init --remote dependencies/z3-interp-plus
	cd dependencies/z3-interp-plus;\
		$(PYTHON_CMD) scripts/mk_make.py --prefix=$(CURRENT_DIR);\
		cd build; make install -j$(NUM_PROCS_H)

renamed_AXDInterpolant:
	perl -i -pe"s|replace_once|$(CURRENT_DIR)|g" $(CURRENT_DIR)/include/AXDInterpolant.h
	touch renamed_AXDInterpolant

$(ODIR)/%.o: $(SDIR)/%.cpp $(DEPS) $(LDIR)/libz3.$(SO_EXT) renamed_AXDInterpolant
	@mkdir -p $(CURRENT_DIR)/obj
	$(CXX) -g -c -o $@ $(FLAGS) $<

bin/axd_interpolator: $(OBJS) $(LDIR)/libz3.$(SO_EXT)
	@mkdir -p $(CURRENT_DIR)/bin
	$(CXX) -g -o $@ $(OBJS) $(FLAGS) -lpthread
# -------------------------------------------------------------------------------

# -------------------------------------------------------
#  Rules to test a single or many smt2 files
tests/one: bin/axd_interpolator
	./bin/axd_interpolator \
		$(THEORY) $(FILE_TEST) $(METHOD) $(ALLOWED_ATTEMPS)
	rm -rf tests/*.o $@

tests/all: bin/axd_interpolator
	for smt_file in $(TEST_DIR)/*.smt2; do \
		./bin/axd_interpolator \
		$(THEORY) $${smt_file} $(METHOD) $(ALLOWED_ATTEMPS) ; \
		done
	rm -rf tests/*.o $@

tests/print_all: bin/axd_interpolator
	for smt_file in $(TEST_DIR)/*.smt2; do \
		if [ "${METHOD}" = "0" ]; \
		then METHOD_NAME="Z3"; \
		else \
		if [ "${METHOD}" = "1" ]; \
		then METHOD_NAME="MATHSAT"; \
		else METHOD_NAME="SMTINTERPOL"; \
		fi \
		fi; \
		./bin/axd_interpolator \
		$(THEORY) $${smt_file} $(METHOD) $(ALLOWED_ATTEMPS) \
		> $${smt_file}_${THEORY}_$${METHOD_NAME}_output.txt ; \
		done
	rm -rf tests/*.o $@
# -------------------------------------------------------

# ----------------------------
#  Check output
check: 
	@make -C ./output

mathsat_check: 
	SMT_SOLVER=MATHSAT make check

z3_check: 
	SMT_SOLVER=Z3 make check
# ----------------------------

# ------------------------------
#  Cleaning
.PHONY: clean
clean:
	perl -i -pe"s|$(CURRENT_DIR)|replace_once|g" ./include/AXDInterpolant.h
	rm -rf renamed_AXDInterpolant
	rm -rf $(ODIR)/* output/*.smt2
	rm -rf $(TEST_DIR)/*.txt
	rm -rf $(CURRENT_DIR)/bin/axd_interpolator
	cd output && make clean

.PHONY: z3_clean
z3_clean:
	cd dependencies/z3-interp-plus/build;\
		make uninstall

.PHONY: deep_clean
deep_clean: clean z3_clean
# ------------------------------
