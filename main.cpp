
#include <string>
#include <vector>

#include "../boost_1_48_0/boost/program_options.hpp"
#define BOOST_FILESYSTEM_VERSION 3
#include "../boost_1_48_0/boost/filesystem.hpp"

#include "console.h"
#include "driver.h"
#include "version.h"

using namespace std;
using namespace LANG_NAMESPACE;

namespace po = boost::program_options;
namespace fs = boost::filesystem3;

DECLARE_ENUM_START(InteractionMode,Mode)
    DECLARE_ENUM_MEMBER(None)
    DECLARE_ENUM_MEMBER(Shell)
    DECLARE_ENUM_MEMBER(LineEval)
    DECLARE_ENUM_MEMBER(FileParse)
DECLARE_ENUM_END

#define TRAIT_END \
    if (line.length() > 3) { \
        if (line.substr(line.length() - 3, 3) == "end") {\
            \
        } else if (line[line.length() - 1] != ';') line += ';'; \
    } else if (line[line.length() - 1] != ';') line += ';';

int main(int argc, char** argv) {
    
    bool printed = false;
    int max_errors = 0;
    InteractionMode::Mode mode = InteractionMode::None;
    vector<string> files, messages;
    string output_filename(LANG_SHELL_NAME ".out"), line;

    Driver driver;

    po::options_description desc("Usage: " LANG_SHELL_NAME " [Options] files\n\nOptions");
    desc.add_options()
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
                if (driver.total_errors > max_errors) {
                    return 1;
                }
                // TODO Generate binary and link
            }
            if (driver.verbose_mode >= VerboseMode::ErrorsAndWarnings) {
                string errors = driver.resume_messages();
                if (!errors.empty()) {
                    cout << "=> " << errors;
                } else {
                    cout << resume_statistics(1, driver.total_lines);
                }
            }
        }
    }

    if (options.count("help")) {
        cout << desc << endl;
        return 0;
    }

    if (options.count("input-file")) {
        vector<string> input_files = options["input-file"].as< vector<string> >();
        for (vector<string>::iterator file = input_files.begin(); file < input_files.end(); file++) {
            if (fs::absolute(*file).extension() == string(".ar"))
                files.push_back(fs::absolute(*file).string());
            else
                messages.push_back(war_tail "This isn't seems a valid " LANG_NAME " file: " + *file);
        }
    }

    if (options.count("verbose")) {
        driver.verbose_mode = (VerboseMode::Mode) options["verbose"].as<int>();
    }

    if (options.count("version")) {
        cout << lang_version_info() << endl;
        printed = true;
    }

    if (!printed) {
        cout << lang_version_info() << endl;
        printed = true;
    }

    if (driver.verbose_mode >= VerboseMode::ErrorsWarningsAndHints && !messages.empty())
        for (vector<string>::iterator message = messages.begin(); message < messages.end(); message++)
            cout << *message << endl;

    // TODO Transpor código para Driver
    int files_processed = 0;
    if (!files.empty()) {
        mode = InteractionMode::FileParse;
        for (vector<string>::iterator file = files.begin(); file < files.end(); file++) {
            if (driver.verbose_mode >= VerboseMode::ErrorsAndWarnings)
                cout << "=> Start parsing: " << *file << endl;
            bool parse_ok = driver.parse_file(*file);
            if (parse_ok) {
                files_processed++;
                if (driver.total_errors > max_errors) return 1;
            } else break;
        }
        if (driver.verbose_mode >= VerboseMode::ErrorsAndWarnings) {
            string errors = driver.resume_messages();
            if (!errors.empty()) {
                cout << "=> " << errors;
            } else {
                cout << resume_statistics(files_processed, driver.total_lines);
            }
        }
    } else if (mode == InteractionMode::None) mode = InteractionMode::Shell;

    if (mode == InteractionMode::Shell) {
        string guide(">>> ");
        int blanks = 0; cout << endl;
        while (cout << COLOR_BGREEN << LANG_SHELL_NAME << COLOR_RESET << guide && getline(cin, line))
            if (!line.empty()) {
                TRAIT_END
                bool parse_ok = driver.parse_string(line, LANG_SHELL_NAME);
                if (parse_ok)
                    if (driver.total_errors > max_errors)
                        return 1;
                    else if (driver.verbose_mode >= VerboseMode::ErrorsAndWarnings)
                        driver.syntax_ok_for("'" + line + "'");
                blanks = 0; line.clear(); guide = ">>> ";
            } else if (++blanks && blanks >= 3) return 0;
    }

    return 0;
}