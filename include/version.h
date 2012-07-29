/* Ares Programming Language */

#ifndef LANG_VERSION_H
#define LANG_VERSION_H

#include <string>

using namespace std;

#include "langconfig.h"

namespace LANG_NAMESPACE {
	string langVersionInfo();
	string langVersion();
	string langRelease();
	string langCopy();
}

#endif
