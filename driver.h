/* Ares Programming Language */

#ifndef LANG_DRIVER_H
#define LANG_DRIVER_H

#include <string>
#include <vector>
#include <time.h>

using namespace std;

#define BOOST_FILESYSTEM_VERSION 3
#include <boost/filesystem.hpp>

namespace fileSystem = boost::filesystem3;

#include "st.h"
#include "console.h"
#include "scanner.h"

using namespace LANG_NAMESPACE::Enum;

namespace LANG_NAMESPACE {
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
            virtual string resumeMessages();

            virtual inline void syntaxOkFor(const string);
            virtual inline void resetLines();
            virtual inline void incLines();
            virtual inline void decLines();
            virtual void produce(FinallyAction::Action, ostream &);
        };

    } // Compiler
} // LANG_NAMESPACE

#endif
