
#include <string>
#include <vector>

using namespace std;

#include "../boost_1_48_0/boost/program_options.hpp"

namespace po = boost::program_options;

#include "console.h"
#include "driver.h"
#include "version.h"

using namespace LANG_NAMESPACE;

DECLARE_ENUM_START(InteractionMode,Mode)
    DECLARE_ENUM_MEMBER(None)
    DECLARE_ENUM_MEMBER(Shell)
    DECLARE_ENUM_MEMBER(LineEval)
    DECLARE_ENUM_MEMBER(FileParse)
DECLARE_ENUM_END

static inline string
trim(string str, char c) {
    string::size_type posb, pose;
    posb = str.find_first_not_of(c);
    if (posb != string::npos)
        str = str.substr(posb, str.length());
    pose = str.find_last_not_of(c);
    if (pose != string::npos)
        str = str.substr(0, pose + 1);
    if (posb == pose)
        str.clear();
    return str;
}

// #define CSTYLE

#ifdef CSTYLE
#define TRAIT_END \
line = trim(line, ' '); \
line = trim(line, '\t'); \
line = trim(line, '\n'); \
if (line[line.length() - 1] != ';' && line[line.length() - 1] != '}') line += ';';
#else
#define TRAIT_END \
line = trim(line, ' '); \
line = trim(line, '\t'); \
line = trim(line, '\n'); \
if (!line.empty()) \
    if (line.length() > 3) \
        if (line[line.length() - 1] != ';' && line.substr(line.length() - 3, 3) != "end") line += ';'; \
    else if (line[line.length() - 1] != ';') line += ';';
#endif

#define STATS \
if (driver.verbose_mode >= VerboseMode::ErrorsOnly) { \
    string errors = driver.resume_messages(); \
    if (!errors.empty()) { \
        cout << "=> " << errors; \
    } \
    cout << Util::resume_statistics(files_processed, driver.total_lines); \
}

int main(int argc, char** argv) {
    
    bool printed = false, check_only = false;
    int max_errors = 3, files_processed = 0;
    InteractionMode::Mode mode = InteractionMode::None;
    vector<string> files, messages;
    string output_filename(LANG_SHELL_NAME ".out"), line;

    Driver driver;

    po::options_description desc("Usage: " LANG_SHELL_NAME " [Options] files\n\nOptions");
    desc.add_options()
        ("check-only,c", "Enable check only")
        ("eval,e", po::value<string>(), "Evaluate and compile <arg>")
        ("help,h", "Print this message and exit")
        ("input-file", po::value< vector<string> >(), "[Optional] Use <arg> as input file(s).")
        ("verbose", po::value<int>()->default_value(0), "Set the verbose mode [0..3]")
        ("version,v", "Print version information")
    ;
    po::positional_options_description positional_input;
    positional_input
        .add("input-file", -1)
    ;

    po::variables_map options;
    try {
        po::store(
            po::command_line_parser(argc, argv)
            .options(desc)
            .positional(positional_input)
            .run(),
            options
        );
        notify(options);
    } catch (po::unknown_option e) {
        cout << err_tail "Unknown option: " << e.get_option_name() << endl;
        cout << desc << endl;
        return 1;
    }

    if (options.count("check-only")) {
        check_only = true;
    }

    if (options.count("eval")) {
        mode = InteractionMode::LineEval;
        if (!printed) {
            cout << lang_version_info() << endl;
            printed = true;
        }
        line = options["eval"].as<string>();
        if (!line.empty()) {
            TRAIT_END
            bool parse_result = driver.parse_string(line, "line eval");
            if (parse_result) {
                if (driver.errors > max_errors) return 1;
                driver.make_things_happen((check_only ? FinallyAction::None : FinallyAction::PrintResults), cout);
            }
            STATS
        }
    }

    if (options.count("help")) {
        cout << desc << endl;
        return 0;
    }

    if (options.count("input-file")) {
        vector<string> input_files = options["input-file"].as< vector<string> >();
        for (vector<string>::iterator file = input_files.begin(); file < input_files.end(); file++) {
            files.push_back(*file);
        }
    }

    if (options.count("verbose")) {
        driver.verbose_mode = (VerboseMode::Mode) options["verbose"].as<int>();
    }

    if (options.count("version")) {
        cout << lang_version_info() << endl;
        return 0;
        // printed = true;
    }

    if (!printed) {
        cout << lang_version_info() << endl;
        printed = true;
    }

    if (driver.verbose_mode >= VerboseMode::ErrorsWarningsAndHints && !messages.empty())
        for (vector<string>::iterator message = messages.begin(); message < messages.end(); message++)
            cout << *message << endl;

    // TODO Transpor código para Driver
    if (!files.empty()) {
        mode = InteractionMode::FileParse;
        for (vector<string>::iterator file = files.begin(); file < files.end(); file++) {
            bool parse_ok = driver.parse_file(*file);
            if (parse_ok) {
                files_processed++;
                if (driver.errors > max_errors) return 1;
                driver.make_things_happen((check_only ? FinallyAction::None : FinallyAction::PrintResults), cout);
            } else break;
        }
        STATS
    } else if (mode == InteractionMode::None) mode = InteractionMode::Shell;

    if (mode == InteractionMode::Shell) {
        string guide(">>> ");
        int blanks = 0; cout << endl;
        while (cout << COLOR_BGREEN << LANG_SHELL_NAME << COLOR_RESET << ':' << guide && getline(cin, line))
            if (!line.empty()) {
                TRAIT_END
                bool parse_ok = driver.parse_string(line, LANG_SHELL_NAME);
                if (parse_ok) {
                    if (driver.errors > max_errors) return 1;
                    driver.make_things_happen((check_only ? FinallyAction::None : FinallyAction::PrintResults), cout);
                }
                blanks = 0; line.clear();
            } else if (++blanks && blanks >= 3) return 0;
    }

    return 0;
}
