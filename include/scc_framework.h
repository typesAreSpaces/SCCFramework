#ifndef _SCC_FRAMEWORK_
#define _SCC_FRAMEWORK_

#include "union_find.h"
#include <z3++.h>

class SCCFramework {
  
  const z3::expr_vector & conjs;
  z3::context ctx;

  void flattenize();
  void canonize();
  void algorithm();
  void normal_form();

  public:
  SCCFramework (const z3::expr_vector &);
};

#endif
