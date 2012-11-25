/** Ares Programming Language
 *
 * version.h - Virtual Platform Version
 *
 * Defines functions to generate virtual platform version information
 */

#ifndef LANG_VERSION_H
#define LANG_VERSION_H

#include <string>
#include "config.h"

using namespace std;

namespace LANG_NAMESPACE
{
    string langVersionInfo();
    string langVersion();
    string langRelease();
    string langCopy();
} // LANG_NAMESPACE

#endif
