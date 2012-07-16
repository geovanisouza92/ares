/* Ares Programming Language */

#ifndef LANG_VERSION_H
#define LANG_VERSION_H

#include <string>
#include <sstream>

using namespace std;

#include "langconfig.h"

namespace LANG_NAMESPACE {

    inline string langVersion();
    inline string langRelease();
    inline string langCopy();

    inline string langVersionInfo() {
        stringstream s;
        s << LANG_NAME
          << " "
          << langVersion()
          << " "
          << langRelease()
          << " "
          << '['
          << LANG_PLATFORM
          << ']'
          << endl
          << langCopy()
          << endl
          << "More info in "
          << LANG_HOME_PAGE;
        return s.str();
    }

    inline string langVersion() {
        stringstream s;
        s << LANG_VERSION_MAJOR
          << "."
          << LANG_VERSION_MINOR
          << "."
          << LANG_VERSION_PATCH
          << LANG_VERSION_COMMENT;
        return s.str();
    }

    inline string langRelease() {
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

    inline string langCopy() {
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

} // LANG_NAMESPACE

#endif
