#ifndef _UTIL_
#define _UTIL_

#include <iostream>
#include <sys/stat.h>

//#define DEBUG

#ifdef DEBUG 
#define D(x) x
#else 
#define D(x)
#endif

#define key_exits(map, key) (map.find(key) != map.end())

typedef unsigned int uint;

namespace util {
  bool exists_file (const std::string &);
}

#endif
