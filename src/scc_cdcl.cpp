#include "scc_cdcl.h"

CombinedCDCLSCC::CombinedCDCLSCC():
  ctx(), input_parser(ctx)
{
}

void CombinedCDCLSCC::parse_file(char * file_path){
  if(!util::exists_file(file_path)){
    std::cerr << "File not found" << std::endl;
  }

  try {
    input_parser.from_file(file_path);
  }
  catch(char * e){
    throw e;
  }
}

//TODO: Keep working here 
void CombinedCDCLSCC::algorithm(){
  // ----------------------------------------
  //Testing CDCL
  cdcl = new CDCL(input_parser.assertions());
  cdcl->simple_cdcl();
  delete cdcl;
  // ----------------------------------------
}
