
#ifndef ARES_CONSOLE_H
#define ARES_CONSOLE_H

#include <string>
#include <iostream>
#include <sstream>
#include <time.h>

using namespace std;

#include "colorcon.h"
#include "version.h"

#define DEBUG

#define err_tail COLOR_BRED "error" COLOR_RESET ": "
#define war_tail COLOR_BPURPLE "warning" COLOR_RESET ": "
#define hin_tail COLOR_BBLUE "hint" COLOR_RESET ": "

#ifdef DEBUG
#define DEBUG_OUT(x) uout << x << endl;
#define DEBUG_ERROR(x) uerr << x << endl;
#define DEBUG_WARNING(x) uwar << x << endl;
#define DEBUG_HINT(x) uhin << x << endl;
#else
#define DEBUG_OUT(x)
#define DEBUG_ERROR(x)
#define DEBUG_WARNING(x)
#define DEBUG_HINT(x)
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
  static string EnumNames[LAST + 1] = {
#define DECLARE_ENUM_MEMBER_NAME(x) \
    x,
#define DECLARE_ENUM_NAMES_END(e) \
    "LAST" \
  }; \
  static string get_enum_name(e value) { \
    return EnumNames[value]; \
  } \
}

namespace LANG_NAMESPACE {
namespace Util {

const clock_t start(clock());

static inline string
format_number(int num) {
    stringstream str; str << num;
    string conv = str.str();
    for (unsigned i = conv.length() - 1; i > 1; i--)
        if ((i % 3) == 0)
            conv.insert(conv.length() - i, " ");
    return conv;
}

static inline string
format_number_fixed(int n, int w, char c = ' ') {
    stringstream s;
    s.fill(c); s.width(w); s << n;
    return s.str();
}

static inline string
resume_statistics(unsigned total_files, unsigned total_lines) {
    clock_t stop = clock();
    double elapsed = (double) ( ( (stop - start) / (CLOCKS_PER_SEC / 1000)) ) / 1000;
    stringstream s;
    s << "=> Statistics: "
      << COLOR_BCYAN
      << format_number(total_files)
      << COLOR_RESET
      << (total_files <= 1 ? " file processed: " : " files processed: ")
      << COLOR_BBLUE
      << format_number(total_lines)
      << COLOR_RESET
      << (total_lines > 1 ? " lines in " : " line in ")
      << COLOR_BYELLOW
      << elapsed
      << COLOR_RESET
      << (elapsed <= 1 ? " second" : " seconds");
    if (total_lines > 0) {
        s << ( elapsed <= 1 ? " / " : " / =~ " )
          << COLOR_BGREEN
          << format_number((elapsed >= 1 ? (int) ( total_lines / elapsed ) : total_lines))
          << COLOR_RESET
          << (total_lines > 1 ? " lines per second." : " line per second.");
    } else s << '.';
    s << endl;
    return s.str();
}

} // Util
} // LANG_NAMESPACE

#endif
