/* Ares Programming Language */

#ifndef LANG_CONFIG_H
#define LANG_CONFIG_H

#include <string>

//#define LANG_DEBUG

#define LANG_NAME               "Ares"
#define LANG_SHELL_NAME         "ash"
#define LANG_EXTENSION          "ar"
#define LANG_NAMESPACE          Ares

#define LANG_AUTHOR_NAME        "Geovani de Souza"
#define LANG_AUTHOR_EMAIL       "geovanisouza92@gmail.com"
#define LANG_HOME_PAGE          "http://github.com/geovanisouza92/ares"

#define LANG_BIRTH_YEAR         2011
#define LANG_BIRTH_MONTH        1
#define LANG_BIRTH_DAY          21

#define LANG_RELEASE_YEAR       2012
#define LANG_RELEASE_MONTH      5
#define LANG_RELEASE_DAY        12

#define LANG_VERSION_MAJOR      0
#define LANG_VERSION_MINOR      2
#define LANG_VERSION_PATCH      8

#define LANG_VERSION_COMMENT    "proto"

#ifndef LANG_PLATFORM

#if (defined(linux) || defined(__linux) || defined(__linux__) || defined(__GNU__) || defined(__GLIBC__)) && !defined(_CRAYC)
#define LANG_PLATFORM "Linux"

#elif defined(macintosh) || defined(__APPLE__) || defined(__APPLE_CC__)
#define LANG_PLATFORM "OS X"

#elif defined(_WIN32) || defined(__WIN32__) || defined(WIN32)
#define LANG_PLATFORM "Win32"

/* Not implemented yet.

#elif defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__DragonFly__)
#define LANG_PLATFORM "BSD"

#elif defined(sun) || defined(__sun)
#define LANG_PLATFORM "Solaris"

#elif defined(__sgi)
#define LANG_PLATFORM "Irix"

#elif defined(__hpux)
#define LANG_PLATFORM "HP-UX"

#elif defined(__CYGWIN__)
#define LANG_PLATFORM "Cygwin"

#elif defined(__BEOS__)
#define LANG_PLATFORM "BeOS"

#elif defined(__IBMCPP__) || defined(_AIX)
#define LANG_PLATFORM "IBM-AIX"

#elif defined(__amigaos__)
#define LANG_PLATFORM "Amiga OS"

#elif defined(__QNXNTO__)
#define LANG_PLATFORM "QNX"

#elif defined(__VXWORKS__)
#define LANG_PLATFORM "VxWorks"

#elif defined(__SYMBIAN32__)
#define LANG_PLATFORM "Symbian"

#elif defined(_CRAYC)
#define LANG_PLATFORM "Cray"

#elif defined(__VMS)
#define LANG_PLATFORM "VMS"
*/

#elif defined(unix) || defined(__unix) || defined(_XOPEN_SOURCE) || defined(_POSIX_SOURCE)
#define LANG_PLATFORM "Unix-compatible"

#else
#define LANG_PLATFORM "Unknown"
  #error "Plataform unknown"
#endif
#endif

#define DECLARE_ENUM_START(n,e) \
namespace n { \
  enum e { \
    FIRST = -1,
#define DECLARE_ENUM_MEMBER(x) \
    x,
#define DECLARE_ENUM_END \
    LAST \
  }; \
}

#define DECLARE_ENUM_NAMES_START(n) \
namespace n { \
  static string EnumNames[LAST] = {
#define DECLARE_ENUM_MEMBER_NAME(x) \
    x,
#define DECLARE_ENUM_NAMES_END(e) \
  }; \
  static string getEnumName(e value) { \
    return EnumNames[value]; \
  } \
}

#endif