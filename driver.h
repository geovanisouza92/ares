
#ifndef ARC_DRIVER_H
#define ARC_DRIVER_H

#include <string>
#include <vector>
#include <time.h>

#include "version.h"
#include "ast.h"
#include "console.h"
#include "scanner.h"

using namespace std;

namespace LANG_NAMESPACE {

    DECLARE_ENUM_START(FinallyAction,Action)
        DECLARE_ENUM_MEMBER(None)
        DECLARE_ENUM_MEMBER(PrintResults)
        DECLARE_ENUM_MEMBER(GenerateBinaries)
    DECLARE_ENUM_END

    DECLARE_ENUM_START(VerboseMode,Mode)
        DECLARE_ENUM_MEMBER(ErrorsOnly)
        DECLARE_ENUM_MEMBER(ErrorsAndWarnings)
        DECLARE_ENUM_MEMBER(ErrorsWarningsAndHints)
        DECLARE_ENUM_MEMBER(AllForDebug)
    DECLARE_ENUM_END

class Driver {
public:
    string origin;
    class Scanner * lexer;
    class AST::Environment * Env;
    VerboseMode::Mode verbose_mode;
    unsigned lines, total_lines, total_errors, total_warnings, total_hints;
public:
    Driver();
    virtual ~Driver();
    virtual bool parse_stream(istream&, const string& sname = "stream input");
    virtual bool parse_string(const string&, const string& sname = "string stream");
    virtual bool parse_file(const string&);

    virtual int error(const class location&, const string&);
    virtual int error(const string&);
    virtual void warning(const class location&, const string&);
    virtual void warning(const string&);
    virtual void hint(const class location&, const string&);
    virtual void hint(const string&);
    virtual string resume_messages();

    virtual inline void syntax_ok_for(const string what) { cout << "=> Syntax OK for " << COLOR_GREEN << what << COLOR_RESET << endl; }
    virtual inline void reset_lines() { total_lines += lines; lines = 0; }
    virtual inline void inc_lines(const unsigned count) { lines += count; }

    virtual void make_things_happen(FinallyAction::Action, ostream&);
};

}

#endif
