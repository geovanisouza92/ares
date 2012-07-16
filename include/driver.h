/* Ares Programming Language */

#ifndef LANG_DRIVER_H
#define LANG_DRIVER_H

#include <string>
#include <vector>
#include <time.h>
#include <sstream>

using namespace std;

#define BOOST_FILESYSTEM_VERSION 3
#include <boost/filesystem.hpp>

namespace fileSystem = boost::filesystem3;

#include "st.hpp"
#include "scanner.hpp"
#include "colorcon.hpp"

#define err_tail COLOR_BRED "error" COLOR_RESET ": "
#define war_tail COLOR_BPURPLE "warning" COLOR_RESET ": "
#define hin_tail COLOR_BBLUE "hint" COLOR_RESET ": "

#ifdef LANG_DEBUG
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

using namespace LANG_NAMESPACE::Enum;

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

        class Driver {
        public:
            string origin;
            bool checkOnly;
            VerboseMode::Mode verboseMode;
            unsigned lines, totalLines;
            unsigned errors, warnings, hints;
            class Scanner * lexer;
#ifdef ENVIRONMENT
            class SyntaxTree::Environment * enviro;
#endif
        public:
            Driver();
            virtual ~Driver();
            virtual bool parseStream(istream&, const string& sname = "stream input");
            virtual bool parseString(const string&, const string& sname = "string stream");
            virtual bool parseFile(const string&);

            virtual int error(const class location&, const string&);
            virtual int error(const string&);
            virtual void warning(const class location&, const string&);
            virtual void warning(const string&);
            virtual void hint(const class location&, const string&);
            virtual void hint(const string&);
            virtual inline void resetMessages();
            virtual inline string resumeMessages();

            virtual inline void syntaxOkFor(const string);
            virtual inline void resetLines();
            virtual inline void incLines();
            virtual inline void decLines();
            virtual void produce(FinallyAction::Action, ostream &);
        };

    } // Compiler
} // LANG_NAMESPACE

#endif
