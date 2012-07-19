/* Ares Programming Language */

#ifndef LANG_VERSION_H
#define LANG_VERSION_H

#include <string>

using namespace std;

#include "langconfig.h"

namespace LANG_NAMESPACE {
	static string langVersionInfo();
	static string langVersion();
	static string langRelease();
	static string langCopy();
}

#endif
