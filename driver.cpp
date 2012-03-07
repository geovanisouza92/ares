
#include <fstream>
#include <sstream>

#define BOOST_FILESYSTEM_VERSION 3
#include "../boost_1_48_0/boost/filesystem.hpp"

#include "driver.h"
#include "console.h"

using namespace std;

namespace fs = boost::filesystem3;

namespace LANG_NAMESPACE {

Driver::Driver()
    : origin(LANG_SHELL_NAME),
      verbose_mode(VerboseMode::ErrorsAndWarnings),
      lines(0),
      total_lines(0),
      total_errors(0),
      total_warnings(0),
      total_hints(0) {
    Env = new AST::Environment(NULL);
}

Driver::~Driver(){
}

bool
Driver::parse_stream(istream& in, const string& sname) {
    Env->clear();
    origin = sname;
    total_errors = total_warnings = total_hints = 0;
    bool result = false;
    try {
        Scanner scanner(&in);
#ifdef DEBUG
        if (verbose_mode == VerboseMode::AllForDebug)
            scanner.set_debug(true);
#endif
        this->lexer = &scanner;
        Parser parser(*this);
#ifdef DEBUG
        if (verbose_mode == VerboseMode::AllForDebug)
            parser.set_debug_level(true);
#endif
        result = parser.parse() == 0;
        reset_lines();
    } catch (string m) {
        error(m);
    }
    return result;
}

bool
Driver::parse_string(const string& input, const string& sname) {
    istringstream iss(input.c_str());
    return parse_stream(iss, sname);
}

bool
Driver::parse_file(const string& filename) {
    ifstream in(filename.c_str());
    if (!in.good()) {
        error("Could not open file: " + filename);
        return false;
    }
    return parse_stream(in, fs::absolute(filename).filename().string());
}

int
Driver::error(const class location& l, const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsOnly) {
        cout << "[" << l << "]: " << err_tail << m << endl;
        total_errors++;
    }
    return 1;
}

int
Driver::error(const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsOnly) {
        cout << "[" << origin << "] ";
        cout << err_tail << m << endl;
        total_errors++;
    }
    return 1;
}

void
Driver::warning(const class location& l, const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsAndWarnings) {
        cout << "[" << l << "]: " << war_tail << m << endl;
        total_warnings++;
    }
}

void
Driver::warning(const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsAndWarnings) {
        cout << "[" << origin << "] ";
        cout << war_tail << m << endl;
        total_warnings++;
    }
}

void
Driver::hint(const class location& l, const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints) {
        cout << "[" << l << "]: " << hin_tail << m << endl;
        total_hints++;
    }
}

void
Driver::hint(const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints) {
        cout << "[" << origin << "] ";
        cout << hin_tail << m << endl;
        total_hints++;
    }
}

string
Driver::resume_messages() {
    stringstream result;
    if (total_errors > 0 || total_warnings > 0 || total_hints > 0) {
        result << "Messages: ";
        if (verbose_mode >= VerboseMode::ErrorsOnly && total_errors > 0)
            result << COLOR_BRED << total_errors << COLOR_RESET << ( total_errors > 1 ? " errors " : " error " );
        if (verbose_mode >= VerboseMode::ErrorsAndWarnings && total_warnings > 0)
            result << COLOR_BPURPLE << total_warnings << COLOR_RESET << ( total_warnings > 1 ? " warnings " : " warning " );
        if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints && total_hints > 0)
            result << COLOR_BBLUE << total_hints << COLOR_RESET << ( total_hints > 1 ? " hints " : " hint " );
        result << endl;
    }
    return result.str();
}

void
Driver::make_things_happen(FinallyAction::Action action, ostream& out) {
    switch(action) {
    case FinallyAction::None:
        break;
    case FinallyAction::PrintResults:
        syntax_ok_for(origin);
        if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints)
            Env->print_tree_using(out);
        break;
    case FinallyAction::GenerateBinaries:
        // TODO Implementar geração de código
        break;
    default:
        break;
    }
}

}
