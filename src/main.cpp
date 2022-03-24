#include "scc_cdcl.h"

int main(int argc, char * argv[]){

  z3::context ctx;

  switch(argc) {
    case 2:
      {
        CombinedCDCLSCC a;
        try {
          a.parse_file(argv[1]);
          a.algorithm();
          return 0;
        }
        catch(char * e){
          std::cerr << e << std::endl;
          return 1;
        }
      }
    default:
      std::cerr << "Not valid number of arguments" << std::endl;
      return 1;
  }
}
