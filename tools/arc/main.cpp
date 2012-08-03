/* Ares Programming Language */

#include <string>
#include <vector>
#include <boost/program_options.hpp>
#include "enum.h"
#include "util.h"
#include "driver.h"
#include "version.h"

using namespace std;
using namespace LANG_NAMESPACE;
using namespace LANG_NAMESPACE::Enum;
using namespace LANG_NAMESPACE::Util;
namespace programOptions = boost::program_options;

#ifndef STATS
#ifdef LANG_DEBUG
#define STATS(x) \
if (driver.verboseMode >= VerboseMode::Low) { \
    string errors = driver.resumeMessages (); \
    if (!errors.empty ()) \
        cout << "=> " << errors; \
    if (driver.totalLines > 0) \
        cout << statistics (filesProcessed, driver.totalLines, x); \
    if (driver.verboseMode >= VerboseMode::High) { \
        cout << "=> Elapsed miliseconds: " << getMili () << endl; \
    } \
}
#else
#define STATS(x) \
if (driver.verboseMode >= VerboseMode::Low) { \
    string errors = driver.resumeMessages (); \
    if (!errors.empty ()) \
        cout << "=> " << errors; \
    if (driver.totalLines > 0) \
        cout << statistics (filesProcessed, driver.totalLines, x); \
}
#endif
#endif

int
main (int argc, char ** argv)
{
    unsigned maxErrors = 3, filesProcessed = 0;
    InteractionMode::Mode mode = InteractionMode::None;
    vector<string> files, messages;
    string outputFilename (LANG_SHELL_NAME ".out"), line;
    Compiler::Driver driver;

    programOptions::options_description desc ("Usage: " LANG_SHELL_NAME " [Options] files\n\nOptions");
    desc.add_options ()
        ("check-only,c", "Enable check only")
        ("eval,e", programOptions::value<string> (), "Evaluate and compile <arg>")
        ("help,h", "Print this message and exit")
        ("input-file", programOptions::value<vector<string> > (), "[Optional] Use <arg> as input file(s).")
        ("verbose", programOptions::value<int> ()->default_value (0), "Set the verbose mode [0..3]")
        ("version,v", "Print version information");
    programOptions::positional_options_description positional_input;
    positional_input.add ("input-file", -1);

    programOptions::variables_map options;
    try {
        programOptions::store (programOptions::command_line_parser (argc, argv)
            .options (desc).positional (positional_input).run (), options);
        notify (options);
    } catch (programOptions::unknown_option & e) {
        cout << err_tail "Unknown option: " << e.get_option_name () << endl;
        cout << desc << endl;
        return 1;
    }

    if (options.count ("check-only")) {
        driver.checkOnly = true;
    }

    if (options.count ("eval")) {
        mode = InteractionMode::LineEval;
        line = options ["eval"].as<string> ();
        if (!line.empty ()) {
            bool parse_result = driver.parseString (line, "line eval");
            if (parse_result) {
                if (driver.errors > maxErrors) return 1;
                driver.produce ( (driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), cout);
            }
            STATS(false)
        }
    }

    if (options.count ("help")) {
        cout << desc << endl;
        return 0;
    }

    if (options.count ("input-file")) {
        vector<string> input_files = options ["input-file"].as<vector<string> > ();
        for (vector<string>::iterator file = input_files.begin (); file < input_files.end (); file++) {
            files.push_back (*file);
        }
    }

    if (options.count ("verbose")) {
        driver.verboseMode = (VerboseMode::Mode) options ["verbose"].as<int> ();
    }

    if (options.count ("version")) {
        cout << langVersionInfo () << endl;
        return 0;
    }

    if (driver.verboseMode >= VerboseMode::High) {
        cout << langVersionInfo () << endl;
        if (!messages.empty ())
            for (vector<string>::iterator message = messages.begin (); message < messages.end (); message++)
                cout << *message << endl;
    }

    // TODO Transpor código para Driver
    if (!files.empty()) {
        mode = InteractionMode::FileParse;
        for (vector<string>::iterator file = files.begin (); file < files.end (); file++) {
            bool parse_ok = driver.parseFile (*file);
            if (parse_ok) {
                filesProcessed++;
                if (driver.errors > maxErrors) return 1;
                driver.produce ( (driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), cout);
            } else
                break;
        }
        STATS(true)
    } else if (mode == InteractionMode::None) mode = InteractionMode::Shell;

    if (mode == InteractionMode::Shell) {
        string guide (">>> ");
        int blanks = 0;
        while (cout << COLOR_BGREEN<< LANG_SHELL_NAME << COLOR_RESET << guide && getline (cin, line))
            if (!line.empty ()) {
                bool parse_ok = driver.parseString (line, LANG_SHELL_NAME);
                if (parse_ok) {
                    if (driver.errors > maxErrors) break;
                    driver.produce ( (driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), cout);
                }
                blanks = 0; line.clear ();
            } else if (++blanks && blanks >= 3) break;
        STATS(false)
    }

    return 0;
}
