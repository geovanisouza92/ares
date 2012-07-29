
#include <string>
#include <sstream>

#include "util.h"
#include "version.h"

string LANG_NAMESPACE::Util::trimString(string str, char c) {
    string::size_type posb, pose;
    posb = str.find_first_not_of(c);
    if (posb != string::npos) str = str.substr(posb, str.length());
    pose = str.find_last_not_of(c);
    if (pose != string::npos) str = str.substr(0, pose + 1);
    if (posb == pose) str.clear();
    return str;
}

string LANG_NAMESPACE::Util::intToStr(int num) {
    stringstream str;
    str << num;
    string conv = str.str();
    for (unsigned i = conv.length() - 1; i > 1; i--)
        if ((i % 3) == 0) conv.insert(conv.length() - i, " ");
    return conv;
}

string LANG_NAMESPACE::Util::formatNumber(int n, int w, char c = ' ') {
    stringstream s;
    s.fill(c);
    s.width(w);
    s << n;
    return s.str();
}

double LANG_NAMESPACE::Util::getMili() {
  return (double) ( (clock() - start) / (CLOCKS_PER_SEC / 1000) );
}

string LANG_NAMESPACE::Util::statistics(unsigned total_files,
    unsigned total_lines, bool print_time = false) {
    double elapsed = getMili() / 1000;
    stringstream s;
    s << "=> Statistics: "
      << COLOR_BCYAN
      << intToStr(total_files)
      << COLOR_RESET
      << (total_files <= 1 ? " file processed: " : " files processed: ")
      << COLOR_BBLUE
      << intToStr(total_lines)
      << COLOR_RESET
      << (total_lines > 1 ? " lines in " : " line in ")
      << COLOR_BYELLOW
      << elapsed
      << COLOR_RESET
      << (elapsed <= 1 ? " second" : " seconds");
    if (print_time) {
        s << (elapsed <= 1 ? " / " : " / =~ ")
          << COLOR_BGREEN
          << intToStr((elapsed >= 1 ? (int) (total_lines / elapsed) : total_lines))
          << COLOR_RESET
          << (total_lines > 1 ? " lines per second." : " line per second.");
    } else
        s << '.';
    s << endl;
    return s.str();
}

string LANG_NAMESPACE::langVersionInfo() {
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

string LANG_NAMESPACE::langVersion() {
    stringstream s;
    s << LANG_VERSION_MAJOR
      << "."
      << LANG_VERSION_MINOR
      << "."
      << LANG_VERSION_PATCH
      << LANG_VERSION_COMMENT;
    return s.str();
}

string LANG_NAMESPACE::langRelease() {
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

string LANG_NAMESPACE::langCopy() {
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
