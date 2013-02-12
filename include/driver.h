/** Copyright (c) 2012, 2013
 *    Ares Programming Language Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. All advertising materials mentioning features or use of this software
 *     must display the following acknowledgement:
 *     This product includes software developed by Ares Programming Language
 *     Project and its contributors.
 *  4. Neither the name of the Ares Programming Language Project nor the names
 *     of its contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE ARES PROGRAMMING LANGUAGE PROJECT AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************
 * driver.h - Virtual Platform Driver
 *
 * Defines objects used to manipulate the compiler, interpreter and execution
 * environment of Ares project
 *
 */

#ifndef LANG_DRIVER_H
#define LANG_DRIVER_H

#include <string>
#define BOOST_FILESYSTEM_VERSION 3
#include <boost/filesystem.hpp>
#include "ast.h"
#include "colorize.h"
#include "scanner.h"

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
    namespace VirtualEngine
    {
    	/**
    	 * Represents the class to interact with virtual environment
    	 */
        class Driver
        {
        public:
            string origin;
            bool checkOnly, colorized;
            VerboseMode::Mode verboseMode;
            unsigned lines, totalLines;
            unsigned errors, warnings, hints;
            class Scanner * lexer;
            class SyntaxTree::Environment * enviro;
            std::ostream & output;
        public:
            Driver(std::ostream &, bool);
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
            virtual void resetMessages();
            virtual string resumeMessages();

            virtual void syntaxOkFor(const string);
            virtual void resetLines();
            virtual void incLines(int qtde = 1);
            virtual void decLines();
            virtual void produce(FinallyAction::Action, ostream &);
        public:
        };

        std::ostream & operator<< (const Driver &, const string);

    } // Compiler
} // LANG_NAMESPACE

#endif
