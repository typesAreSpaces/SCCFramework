#include <iostream>
#include <z3++.h>

int main(){
  z3::context ctx;
  z3::solver s(ctx);

  //auto x = ctx.int_val(0);
  auto x = ctx.int_const("x");
  
  s.add(x == 1);

  switch(s.check()){
    case z3::sat:
      std::cout << "sat" << std::endl;
      break;
    case z3::unsat:
      std::cout << "unsat" << std::endl;
      break;
    case z3::unknown:
      std::cout << "unknown" << std::endl;
      break;
  }

  return 0;
}
