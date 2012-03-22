
#include <fstream>
#include <sstream>

using namespace std;

#define BOOST_FILESYSTEM_VERSION 3
#include "../boost_1_48_0/boost/filesystem.hpp"

namespace fs = boost::filesystem3;

#include "driver.h"
#include "console.h"

namespace LANG_NAMESPACE {

Driver::Driver()
    : origin(LANG_SHELL_NAME),
      verbose_mode(VerboseMode::ErrorsAndWarnings),
      lines(0),
      total_lines(0),
      errors(0),
      warnings(0),
      hints(0) {
    // Env = new SyntaxTree::Environment(NULL);
}

Driver::~Driver(){
}

bool
Driver::parse_stream(istream& in, const string& sname) {
    // Env->clear();
    origin = sname;
    // total_errors = total_warnings = total_hints = 0;
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
    fs::path file = fs::absolute(filename);
    if (fs::exists(file) && file.extension() == string("." LANG_EXTENSION)) {
        if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints)
            cout << "=> Start parsing: " << filename << endl;
        ifstream in(filename.c_str());
        if (!in.good()) {
            error("Could not open file: " + filename);
            return false;
        }
        return parse_stream(in, fs::absolute(filename).filename().string());
    } else
        warning(war_tail "This isn't seems a valid " LANG_NAME " file: " + filename);
    return false;
}

int
Driver::error(const class location& l, const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsOnly) {
        cout << "[" << l << "]: " << err_tail << m << endl;
        errors++;
    }
    return 1;
}

int
Driver::error(const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsOnly) {
        cout << "[" << origin << "] ";
        cout << err_tail << m << endl;
        errors++;
    }
    return 1;
}

void
Driver::warning(const class location& l, const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsAndWarnings) {
        cout << "[" << l << "]: " << war_tail << m << endl;
        warnings++;
    }
}

void
Driver::warning(const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsAndWarnings) {
        cout << "[" << origin << "] ";
        cout << war_tail << m << endl;
        warnings++;
    }
}

void
Driver::hint(const class location& l, const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints) {
        cout << "[" << l << "]: " << hin_tail << m << endl;
        hints++;
    }
}

void
Driver::hint(const string& m) {
    if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints) {
        cout << "[" << origin << "] ";
        cout << hin_tail << m << endl;
        hints++;
    }
}

string
Driver::resume_messages() {
    stringstream result;
    if (errors > 0 || warnings > 0 || hints > 0) {
        result << "Messages: ";
        if (verbose_mode >= VerboseMode::ErrorsOnly && errors > 0)
            result << COLOR_BRED << errors << COLOR_RESET << ( errors > 1 ? " errors " : " error " );
        if (verbose_mode >= VerboseMode::ErrorsAndWarnings && warnings > 0)
            result << COLOR_BPURPLE << warnings << COLOR_RESET << ( warnings > 1 ? " warnings " : " warning " );
        if (verbose_mode >= VerboseMode::ErrorsWarningsAndHints && hints > 0)
            result << COLOR_BBLUE << hints << COLOR_RESET << ( hints > 1 ? " hints " : " hint " );
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
        if (errors == 0 && verbose_mode >= VerboseMode::ErrorsWarningsAndHints) {
            syntax_ok_for(origin);
            // Env->print_tree_using(out);
        }
        break;
    case FinallyAction::Execute:
        // TODO Implementar ambiente de execução
        break;
    case FinallyAction::GenerateBinaries:
        // TODO Implementar geração de código
        break;
    default:
        break;
    }
}

}
