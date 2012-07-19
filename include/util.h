
#ifndef LANG_UTIL_H
#define LANG_UTIL_H

#include <time.h>
#include <string>

#include "langconfig.h"
#include "colorcon.h"

using namespace std;

namespace LANG_NAMESPACE {
    namespace Util {
        const clock_t start(clock());
        static string intToStr(int);
        static string formatNumber(int, int, char);
        static double getMili();
        static string statistics(unsigned, unsigned, bool);
        static string trimString(string, char);
    }
}

#endif
