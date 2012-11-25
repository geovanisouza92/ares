/** Ares Programming Language
 *
 * util.h - Utilities
 *
 * Defines utility functions used by virtual platform
 */

#ifndef LANG_UTIL_H
#define LANG_UTIL_H

#include <time.h>
#include <string>
#include "config.h"
#include "colorize.h"

using namespace std;

namespace LANG_NAMESPACE
{
    namespace Util
    {
        const clock_t start(clock());
        string intToStr(int);
        string formatNumber(int, int, char);
        double getMili();
        string statistics(unsigned, unsigned, bool);
        string trimString(string, char);
    } // Util
} // LANG_NAMESPACE

#endif
