#include "util.h"

namespace util {
  bool exists_file (const std::string & name) {
    struct stat buffer;   
    return (stat (name.c_str(), &buffer) == 0); 
  }
}
