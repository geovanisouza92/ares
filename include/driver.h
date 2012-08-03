/* Ares Programming Language */

#ifndef LANG_DRIVER_H
#define LANG_DRIVER_H

#include <string>
#define BOOST_FILESYSTEM_VERSION 3
#include <boost/filesystem.hpp>
#include "st.h"
#include "scanner.h"
#include "colorcon.h"

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

using namespace std;
using namespace LANG_NAMESPACE::Enum;
namespace fileSystem = boost::filesystem3;

namespace LANG_NAMESPACE
{
    namespace Compiler
    {
        class Driver
        {
        public:
            string origin;
            bool checkOnly;
            VerboseMode::Mode verboseMode;
            unsigned lines, totalLines;
            unsigned errors, warnings, hints;
            class Scanner * lexer;
            class SyntaxTree::Environment * enviro;
        public:
            Driver ();
            virtual ~Driver ();
            virtual bool parseStream (istream&, const string& sname = "stream input");
            virtual bool parseString (const string&, const string& sname = "string stream");
            virtual bool parseFile (const string&);

            virtual int error (const class location&, const string&);
            virtual int error (const string&);
            virtual void warning (const class location&, const string&);
            virtual void warning (const string&);
            virtual void hint (const class location&, const string&);
            virtual void hint (const string&);
            virtual void resetMessages ();
            virtual string resumeMessages ();

            virtual void syntaxOkFor (const string);
            virtual void resetLines ();
            virtual void incLines (int qtde = 1);
            virtual void decLines ();
            virtual void produce (FinallyAction::Action, ostream &);
        };
    } // Compiler
} // LANG_NAMESPACE

#endif
