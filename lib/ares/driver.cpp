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
 * driver.cpp - Virtual Platform Driver
 *
 * Implements objects used to manipulate the compiler, interpreter and
 * execution enviroment of Ares Project
 *
 */

#include <string>
#include <fstream>
#include <sstream>
#include "driver.h"

using namespace std;

#define LANG_DEBUG

namespace LANG_NAMESPACE
{
    namespace VirtualEngine
    {
        Driver::Driver(std::ostream & out)
            : origin(LANG_SHELL_NAME), checkOnly(false),
            verboseMode(VerboseMode::Normal), lines(0), totalLines(0),
            errors(0), warnings(0), hints(0), output(out)
        {
            enviro = new SyntaxTree::Environment(0);
        }

        Driver::~Driver() { }

        bool
        Driver::parseStream(istream & in, const string & sname)
        {
            enviro->clear();
            origin = sname;
            bool result = false;
            try { // Captura erros léxicos e sintáticos
                Scanner scanner(&in, &this->output);
                this->lexer = &scanner;
                Parser parser(*this);
#ifdef LANG_DEBUG
                if(verboseMode == VerboseMode::Debug) {
                    scanner.set_debug(true);
                    parser.set_debug_level(true);
                }
#endif
                result = parser.parse() == 0;
                resetLines();
            } catch(string & m) {
                error(m);
            }
            return result;
        }

        bool
        Driver::parseString(const string & input, const string & sname)
        {
            istringstream iss(input.c_str());
            return parseStream(iss, sname);
        }

        bool
        Driver::parseFile(const string & filename)
        {
            fileSystem::path file = fileSystem::absolute(filename);
            if(fileSystem::exists(file) && file.extension() == string("." LANG_EXTENSION)) {
                if(verboseMode >= VerboseMode::High) output << "=> Start parsing: " << filename << endl;
                ifstream in(filename.c_str());
                if(!in.good()) {
                    error("Could not open file: " + filename);
                    return false;
                }
                return parseStream(in, fileSystem::absolute(filename).filename().string());
            } else
                warning(war_tail "This isn't seems a valid " LANG_NAME " file: " + filename);
            return false;
        }

        int
        Driver::error(const class location & l, const string & m)
        {
            if(verboseMode >= VerboseMode::Low) {
                output << "[" << l << "]: " << err_tail << m << endl;
                ++errors;
            }
            return 1;
        }

        int
        Driver::error(const string & m)
        {
            if(verboseMode >= VerboseMode::Low) {
                output << "[" << origin << "] ";
                output << err_tail << m << endl;
                ++errors;
            }
            return 1;
        }

        void
        Driver::warning(const class location & l, const string & m)
        {
            if(verboseMode >= VerboseMode::Normal) {
                output << "[" << l << "]: " << war_tail << m << endl;
                ++warnings;
            }
        }

        void
        Driver::warning(const string & m)
        {
            if(verboseMode >= VerboseMode::Normal) {
                output << "[" << origin << "] ";
                output << war_tail << m << endl;
                ++warnings;
            }
        }

        void
        Driver::hint(const class location & l, const string & m)
        {
            if(verboseMode >= VerboseMode::High) {
                output << "[" << l << "]: " << hin_tail << m << endl;
                ++hints;
            }
        }

        void
        Driver::hint(const string & m)
        {
            if(verboseMode >= VerboseMode::High) {
                output << "[" << origin << "] ";
                output << hin_tail << m << endl;
                ++hints;
            }
        }

        void
        Driver::resetMessages()
        {
            errors = 0;
            warnings = 0;
            hints = 0;
        }

        string
        Driver::resumeMessages()
        {
            stringstream result;
            if(errors > 0 || warnings > 0 || hints > 0) {
                result << "Messages: ";
                if(verboseMode >= VerboseMode::Low && errors > 0) result << COLOR_BRED << errors << COLOR_RESET <<(errors > 1 ? " errors " : " error ");
                if(verboseMode >= VerboseMode::Normal && warnings > 0) result << COLOR_BPURPLE << warnings << COLOR_RESET <<(warnings > 1 ? " warnings " : " warning ");
                if(verboseMode >= VerboseMode::High && hints > 0) result << COLOR_BBLUE << hints << COLOR_RESET <<(hints > 1 ? " hints " : " hint ");
                result << endl;
            }
            return result.str();
        }

        void
        Driver::syntaxOkFor(const string what)
        {
            output << "=> Syntax OK for " << COLOR_BGREEN << what << COLOR_RESET << endl;
        }

        void
        Driver::resetLines()
        {
            totalLines += lines;
            lines = 0;
        }

        void
        Driver::incLines(int qtde)
        {
            lines += qtde;
        }

        void
        Driver::decLines()
        {
            --lines;
        }

        void
        Driver::produce(FinallyAction::Action action, ostream & out)
        {
            switch(action) {
            case FinallyAction::None:
                break;
            case FinallyAction::PrintOnConsole:
                if(errors == 0 && verboseMode >= VerboseMode::High) {
                    enviro->toString(out, 0);
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

        std::ostream &
        operator<< (const Driver & driver, const string val)
        {
            driver.output << val;
            return driver.output;
        }

    } // Compiler
} // LANG_NAMESPACE
