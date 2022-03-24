#ifndef _CDCL_ENGINE_
#define _CDCL_ENGINE_

#include "util.h"
#include <z3++.h>
#include <map>

#define lhs(x)       x.arg(0)
#define rhs(x)       x.arg(1)
#define func_name(x) x.decl().name().str()
#define _get_sort(x) x.decl().range()
#define sort_name(x) x.decl().range().name().str()
#define func_kind(x) x.decl().decl_kind()

class CDCL {

  const z3::expr_vector & clauses;

  z3::context ctx;
  z3::solver prop_solver;
  z3::expr_vector abstract_lits;

  std::map<uint, uint> abs;

  z3::expr mk_lit(const z3::model &, const z3::expr &);
  z3::expr_vector abstract_clauses();
  z3::expr abstract_clause(const z3::expr &);
  z3::expr abstract_lit(const z3::expr &);
  z3::expr abstract_atom(const z3::expr &);

  public:
  CDCL(const z3::expr_vector &);
  void simple_cdcl();
};

#endif
