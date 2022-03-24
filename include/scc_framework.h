#ifndef _SCC_FRAMEWORK_
#define _SCC_FRAMEWORK_

#include "util.h"
#include <exception>
#include <z3++.h>

//class myexception: public std::exception {
  //virtual const char* what() const throw()
  //{
    //return "My exception happened";
  //}
//};

class SCCFramework {
  
  z3::context ctx;
  z3::solver input_parser;

  public:
  SCCFramework ();

  void parse_file(char *);
};

#endif

