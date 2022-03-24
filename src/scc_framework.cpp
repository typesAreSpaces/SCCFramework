#include "scc_framework.h"

SCCFramework::SCCFramework(const z3::expr_vector & input):
  conjs(input),
  ctx()
{
}
