#include "scc_framework.h"

SCCFramework::SCCFramework ():
  ctx(), input_parser(ctx)
{
  //ctx.set(":pp-min-alias-size", 1000000);
  //ctx.set(":pp-max-depth",      1000000);
}

void SCCFramework::parse_file(char * file_path){
  if(!util::exists_file(file_path)){
    std::cerr << "File not found" << std::endl;
  }

  try {
    input_parser.from_file(file_path);
    //TODO: Keep working here 
    std::cout << input_parser.assertions() << std::endl;
  }
  catch(char * e){
    throw e;
  }
}

void SCCFramework::algorithm(){
}
