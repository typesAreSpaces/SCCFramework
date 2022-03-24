#include <iostream>
#include <sys/stat.h>
#include <z3++.h>

inline bool exists_file (const std::string &);

int main(int argc, char * argv[]){

  z3::context ctx;
  ctx.set(":pp-min-alias-size", 1000000);
  ctx.set(":pp-max-depth",      1000000);

  switch(argc) {
    case 2:
      {
        char * file_path = argv[1];
        if(!exists_file(file_path)){
          std::cerr << "File not found" << std::endl;
          return 1;
        }
        z3::solver input_parser(ctx);
        input_parser.from_file(file_path);
        std::cout << input_parser.assertions() << std::endl;
        return 0;
      }
    default:
      std::cerr << "Not valid number of arguments" << std::endl;
      return 1;
  }
}

inline bool exists_file (const std::string & name) {
  struct stat buffer;   
  return (stat (name.c_str(), &buffer) == 0); 
}

