#include "cdcl_engine.h"

CDCL::CDCL(const z3::expr_vector & input):
  clauses(input),
  ctx(), prop_solver(ctx), abstract_lits(ctx), 
  abs({})
{
  //abstract_lits.resize(0);
  prop_solver.add(abstract_clauses());

  D(
      std::cout << abstract_lits << std::endl;
      for(auto const & [prop, lit] : abs){
      std::cout << "prop: " << prop << " |-> lit: " << lit << " actual lit: " << abstract_lits[lit] << std::endl;
      }
   );
}

z3::expr_vector CDCL::abstract_clauses(){
  z3::expr_vector ans(ctx);
  for (const auto & clause : this->clauses)
    ans.push_back(abstract_clause(clause));
  return ans;
}

//ASSUMPTION: the input formula
//only contains disjunctions of equations
//or disequations
z3::expr CDCL::abstract_clause(const z3::expr & clause){
  switch(func_kind(clause)){ 
    case Z3_OP_OR:
      {
        uint num_args = clause.num_args();
        z3::expr_vector a_lits(ctx);
        for(uint i = 0; i < num_args; i++){
          a_lits.push_back(abstract_lit(clause.arg(i)));
        }
        return z3::mk_or(a_lits);
      } 
    default:
      return abstract_lit(clause);
  }
}

z3::expr CDCL::abstract_lit(const z3::expr & lit){
  switch(func_kind(lit)){
    case Z3_OP_EQ:
      return abstract_atom(lit);
    case Z3_OP_DISTINCT:
      return !abstract_atom(lhs(lit) == rhs(lit));
    default:
      throw("This literal is not supported.");
  }
}

z3::expr CDCL::abstract_atom(const z3::expr & equation){
  uint eq_hash = equation.hash();

  D(std::cout << equation << " " << equation.hash() << std::endl;);

  if(key_exits(abs, eq_hash)){
    return abstract_lits[abs[eq_hash]];
  }
  uint curr_index = abstract_lits.size();
  auto p = ctx.bool_const(("prop_" + std::to_string(curr_index)).c_str());
  abstract_lits.push_back(p);
  abs[eq_hash] = curr_index;
  return p;
}

void CDCL::simple_cdcl(){
  if(z3::sat == prop_solver.check()){
    const auto & m = prop_solver.get_model();
    std::cout << m << std::endl;
  }
}
