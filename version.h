
#ifndef LANG_VERSION_H
#define LANG_VERSION_H

#define LANG_NAME               "Ares"
#define LANG_SHELL_NAME         "arc"
#define LANG_NAMESPACE          Ares

#define LANG_AUTHOR_NAME        "Geovani de Souza"
#define LANG_AUTHOR_EMAIL       "geovanisouza92@gmail.com"
#define LANG_HOME_PAGE          "http://github.com/geovanisouza92/"

#define LANG_BIRTH_YEAR         2011
#define LANG_BIRTH_MONTH        1
#define LANG_BIRTH_DAY          22

#define LANG_RELEASE_YEAR       2012
#define LANG_RELEASE_MONTH      3
#define LANG_RELEASE_DAY        6

#define LANG_VERSION_MAJOR      0
#define LANG_VERSION_MINOR      2
#define LANG_VERSION_PATCH      0
#define LANG_VERSION_COMMENT    "proto"

#if   defined(_WIN32) || defined(MSWIN) || defined(MSWINDOWS)
#define LANG_PLATFORM "MS Windows"
#elif defined(__linux__)
#define LANG_PLATFORM "Linux"
#elif defined(__GNUC__)
#define LANG_PLATFORM "Unix-compatible"
#else
#define LANG_PLATFORM "Unknown"
#endif

#include <sstream>

using namespace std;

inline string lang_version();
inline string lang_release();
inline string lang_copy();

inline string lang_version_info() {
    stringstream s;
    s << LANG_NAME
      << " "
      << lang_version()
      << " "
      << lang_release()
      << " "
      << '['
      << LANG_PLATFORM
      << ']'
      << endl
      << lang_copy()
      << endl
      << "More info in "
      << LANG_HOME_PAGE;
    return s.str();
}

inline string lang_version() {
    stringstream s;
    s << LANG_VERSION_MAJOR
      << "."
      << LANG_VERSION_MINOR
      << "."
      << LANG_VERSION_PATCH
      << LANG_VERSION_COMMENT;
    return s.str();
}

inline string lang_release() {
    stringstream s;
    s << "(Release "
      << LANG_RELEASE_YEAR
      << "-"
      << LANG_RELEASE_MONTH
      << "-"
      << LANG_RELEASE_DAY
      << ")";
    return s.str();
}

inline string lang_copy() {
    stringstream s;
    s << "Copyleft "
      << LANG_BIRTH_YEAR
      << "-"
      << LANG_RELEASE_YEAR
      << " "
      << LANG_AUTHOR_NAME
      << " ("
      << LANG_AUTHOR_EMAIL
      << ")";
    return s.str();
}

#endif