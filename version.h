
/* Ares Programming Language */

#ifndef LANG_VERSION_H
#define LANG_VERSION_H

#include <sstream>

using namespace std;

#include "langconfig.h"

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
