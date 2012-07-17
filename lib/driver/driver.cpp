/* Ares Programming Language */

#include <string>
#include <fstream>
#include <sstream>

using namespace std;

#include "driver.h"

namespace LANG_NAMESPACE {
    namespace Util {
        const clock_t start(clock());

        static inline string intToStr(int num) {
            stringstream str;
            str << num;
            string conv = str.str();
            for (unsigned i = conv.length() - 1; i > 1; i--)
                if ((i % 3) == 0) conv.insert(conv.length() - i, " ");
            return conv;
        }

        static inline string formatNumber(int n, int w, char c = ' ') {
            stringstream s;
            s.fill(c);
            s.width(w);
            s << n;
            return s.str();
        }

        static inline double getMili() {
          return (double) ( (clock() - start) / (CLOCKS_PER_SEC / 1000) );
        }

        static inline string statistics(unsigned total_files, unsigned total_lines, bool print_time = false) {
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
    }
    
    namespace Compiler {

        Driver::Driver() : origin(LANG_SHELL_NAME), checkOnly(false), verboseMode(VerboseMode::Normal), lines(0), totalLines(0), errors(0), warnings(0), hints(0) {
#ifdef ENVIRONMENT
            enviro = new SyntaxTree::Environment(0);
#endif
        }

        Driver::~Driver() { }

        bool Driver::parseStream(istream & in, const string & sname) {
#ifdef ENVIRONMENT
            enviro->clear();
#endif
            origin = sname;
            bool result = false;
            try { // Captura erros léxicos e sintáticos
                Scanner scanner(&in);
                this->lexer = &scanner;
                Parser parser(*this);
#ifdef LANG_DEBUG
                if (verboseMode == VerboseMode::Debug) {
                    scanner.set_debug(true);
                    parser.set_debug_level(true);
                }
#endif
                result = parser.parse() == 0;
                resetLines();
            } catch (string & m) {
                error(m);
            }
            return result;
        }

        bool Driver::parseString(const string & input, const string & sname) {
            istringstream iss(input.c_str());
            return parseStream(iss, sname);
        }

        bool Driver::parseFile(const string & filename) {
            fileSystem::path file = fileSystem::absolute(filename);
            if (fileSystem::exists(file) && file.extension() == string("." LANG_EXTENSION)) {
                if (verboseMode >= VerboseMode::High) cout << "=> Start parsing: " << filename << endl;
                ifstream in(filename.c_str());
                if (!in.good()) {
                    error("Could not open file: " + filename);
                    return false;
                }
                return parseStream(in, fileSystem::absolute(filename).filename().string());
            } else
                warning(war_tail "This isn't seems a valid " LANG_NAME " file: " + filename);
            return false;
        }

        int Driver::error(const class location & l, const string & m) {
            if (verboseMode >= VerboseMode::Low) {
                cout << "[" << l << "]: " << err_tail << m << endl;
                ++errors;
            }
// #ifdef ENVIRONMENT
//             enviro->clear();
// #endif
            return 1;
        }

        int Driver::error(const string & m) {
            if (verboseMode >= VerboseMode::Low) {
                cout << "[" << origin << "] ";
                cout << err_tail << m << endl;
                ++errors;
            }
// #ifdef ENVIRONMENT
//             enviro->clear();
// #endif
            return 1;
        }

        void Driver::warning(const class location & l, const string & m) {
            if (verboseMode >= VerboseMode::Normal) {
                cout << "[" << l << "]: " << war_tail << m << endl;
                ++warnings;
            }
        }

        void Driver::warning(const string & m) {
            if (verboseMode >= VerboseMode::Normal) {
                cout << "[" << origin << "] ";
                cout << war_tail << m << endl;
                ++warnings;
            }
        }

        void Driver::hint(const class location & l, const string & m) {
            if (verboseMode >= VerboseMode::High) {
                cout << "[" << l << "]: " << hin_tail << m << endl;
                ++hints;
            }
        }

        void Driver::hint(const string & m) {
            if (verboseMode >= VerboseMode::High) {
                cout << "[" << origin << "] ";
                cout << hin_tail << m << endl;
                ++hints;
            }
        }

        void Driver::resetMessages() {
        	errors = 0;
        	warnings = 0;
        	hints = 0;
        }

        string Driver::resumeMessages() {
            stringstream result;
            if (errors > 0 || warnings > 0 || hints > 0) {
                result << "Messages: ";
                if (verboseMode >= VerboseMode::Low && errors > 0) result << COLOR_BRED << errors << COLOR_RESET << (errors > 1 ? " errors " : " error ");
                if (verboseMode >= VerboseMode::Normal && warnings > 0) result << COLOR_BPURPLE << warnings << COLOR_RESET << (warnings > 1 ? " warnings " : " warning ");
                if (verboseMode >= VerboseMode::High && hints > 0) result << COLOR_BBLUE << hints << COLOR_RESET << (hints > 1 ? " hints " : " hint ");
                result << endl;
            }
            return result.str();
        }

        void
        Driver::syntaxOkFor(const string what) {
            cout << "=> Syntax OK for " << COLOR_BGREEN << what << COLOR_RESET << endl;
        }

        void
        Driver::resetLines() {
            totalLines += lines;
            lines = 0;
        }

        void
        Driver::incLines() {
            ++lines;
        }

        void
        Driver::decLines() {
            --lines;
        }

        void Driver::produce(FinallyAction::Action action, ostream & out) {
            switch (action) {
            case FinallyAction::None:
                break;
            case FinallyAction::PrintOnConsole:
                if (errors == 0 && verboseMode >= VerboseMode::High) {
#ifdef ENVIRONMENT
                    enviro->printUsing(out, 0);
#endif
                    syntaxOkFor(origin);
                } else {
                	resetMessages();
                }
                break;
            case FinallyAction::ExecuteOnTheFly:
                // TODO Implementar ambiente de execução
                break;
            case FinallyAction::GenerateBinaries:
                // TODO Implementar geração de código
                break;
            default:
                break;
            }
        }

    } // Compiler
} // LANG_NAMESPACE
