#include "util.h"
#include <z3++.h>

int main(int argc, char * argv[]){

  z3::context ctx;
  ctx.set(":pp-min-alias-size", 1000000);
  ctx.set(":pp-max-depth",      1000000);

  switch(argc) {
    case 2:
      {
        char * file_path = argv[1];
        if(!util::exists_file(file_path)){
          std::cerr << "File not found" << std::endl;
          return 1;
        }
        z3::solver input_parser(ctx);
        try {
          input_parser.from_file(file_path);
          std::cout << input_parser.assertions() << std::endl;
        }
        catch(char * e){
          std::cerr << e << std::endl;
        }
        return 0;
      }
    default:
      std::cerr << "Not valid number of arguments" << std::endl;
      return 1;
  }
}
