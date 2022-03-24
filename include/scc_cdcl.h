#ifndef _SCC_CDCL_
#define _SCC_CDCL_

#include "scc_framework.h"
#include "cdcl_engine.h"

class CombinedCDCLSCC {

  
  z3::context ctx;
  z3::solver input_parser;

  CDCL         * cdcl;
  SCCFramework * scc_framework;

  public:
  CombinedCDCLSCC();

  void parse_file(char *);
  void algorithm();
};

#endif
