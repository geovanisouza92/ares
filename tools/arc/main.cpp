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
 * main.cpp - Utilities
 *
 * Implements the main entry point of program, treating the program flags and
 * source code.
 *
 */

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
namespace po = boost::program_options;

#ifndef STATS
#define STATS(print_exec_time) \
if (driver.verboseMode >= VerboseMode::Low) { \
    string errors = driver.resumeMessages(); \
    if (!errors.empty()) \
        output << "=> " << errors; \
    if (driver.totalLines > 0) \
        output << statistics(filesProcessed, driver.totalLines, colorized, print_exec_time); \
    if (driver.verboseMode >= VerboseMode::High) { \
        output << "=> Elapsed miliseconds: " << getMili() << endl; \
    } \
}
#endif

int
main(int argc, char ** argv)
{
    unsigned filesProcessed = 0;
    InteractionMode::Mode mode = InteractionMode::None;
    vector<string> files, messages;
    string outputFilename(LANG_SHELL_NAME ".out"), line;
    std::ostream & output = std::cout;
    bool echo = true, colorized = LANG_COLORIZED;

    po::options_description desc("Usage: " LANG_SHELL_NAME " [Options] files\n\nOptions");
    desc.add_options()
        ("check-only,c", "Enable check only")
        ("colorized,l", po::value<bool>()->default_value(true), "Set colorized output to console")
        ("echo,z", po::value<bool>()->default_value(true), "Set echo for console")
        ("eval,e", po::value<string>(), "Read-eval-print <arg>")
        ("help,h", "Print this message")
        ("input-file,i", po::value<vector<string> >(), "[Optional] Use <arg> as input file(s).")
        // ("output-file,o", po::value<vector<string> >(), "[Optional] Set <arg> as output file(s).")
        ("verbose,x", po::value<int>()->default_value(0), "Set the verbose mode [0..3]")
        ("version,v", "Print version information")
        ;
    po::positional_options_description positional_input;
    positional_input.add("input-file", -1);

    po::variables_map options;
    try {
        po::store(po::command_line_parser(argc, argv)
            .options(desc).positional(positional_input).run(), options);
        po::notify(options);
    } catch(po::unknown_option & e) {
        output << "Unknown option: " << e.get_option_name() << endl;
        output << desc << endl;
        return 1;
    }

    if (LANG_COLORIZED && options.count("colorized"))
        colorized = options ["colorized"].as<bool>();

    VirtualEngine::Driver driver(output, colorized);

    if (options.count("check-only")) {
        driver.checkOnly = true;
    }

    if (options.count("eval")) {
        mode = InteractionMode::LineEval;
        line = options ["eval"].as<string>();
        if (!line.empty()) {
            bool parse_result = driver.parseString(line, "line eval");
            if (parse_result) {
                // if (driver.errors) return 1;
                driver.produce((driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), output);
            }
            STATS(false)
        }
    }

    if (options.count("help")) {
        output << desc << endl;
        return 0;
    }

    if (options.count("input-file")) {
        vector<string> input_files = options ["input-file"].as<vector<string> >();
        for (auto file = input_files.begin(); file < input_files.end(); file++) {
            files.push_back(*file);
        }
    }

    if (options.count("verbose")) {
        driver.verboseMode =(VerboseMode::Mode) options ["verbose"].as<int>();
    }

    if (options.count("version")) {
        output << langVersionInfo() << endl;
        return 0;
    }

    if (options.count("echo"))
        echo = options ["echo"].as<bool>();

    if (driver.verboseMode >= VerboseMode::High) {
        output << langVersionInfo() << endl;
        if (!messages.empty())
            for (auto message = messages.begin(); message < messages.end(); message++)
                output << *message << endl;
    }

    // TODO Transpor código para Driver
    if (!files.empty()) {
        mode = InteractionMode::FileParse;
        for (auto file = files.begin(); file < files.end(); file++) {
            bool parse_ok = driver.parseFile(*file);
            if (parse_ok) {
                filesProcessed++;
                // if (driver.errors) return -1;
                driver.produce((driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), output);
            } else
                break;
        }
        STATS(true)
    } else if (mode == InteractionMode::None) mode = InteractionMode::Shell;

    if (mode == InteractionMode::Shell) {

        vector<string> args;

        po::options_description shell("Interactive shell");
        shell.add_options()
            ("\\q", "Quit")
            ("\\h", "Print this help message")
            ("\\c", "Clear the buffer")
            ("\\l", "List the buffer")
            ("\\i", po::value<string>(), "Process file")
            ("/", "Execute the command buffer")
            ;
        po::positional_options_description shell_input;
        shell_input.add("\\i", -1);
        po::variables_map commands;

        string guide(">>> "), prompt = "", buffer = "";
        if (echo)
            if (colorized)
                prompt = COLOR_BGREEN LANG_SHELL_NAME COLOR_RESET + guide;
            else
                prompt = LANG_SHELL_NAME + guide;
        while(output << prompt && getline(cin, line))
            if (!line.empty()) {

                try
                {
                    args = Util::splitString(string("--") + line);
                    po::store(po::command_line_parser(args).options(shell)
                        .positional(shell_input).run(), commands);
                    po::notify(commands);

                    if (commands.count("\\q"))
                        break;

                    if (commands.count("\\h"))
                        output << shell << endl;

                    if (commands.count("\\l"))
                        output << buffer << endl;

                    if (commands.count("\\c"))
                        buffer.clear();

                    if (commands.count("\\i"))
                    {
                        string file = commands["\\i"].as<string>();
                        bool parse_ok = driver.parseFile(file);
                        // if (driver.errors) return 1;
                        driver.produce((driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), output);
                    }

                    if (commands.count("/"))
                    {
                        bool parse_ok = driver.parseString(buffer, LANG_SHELL_NAME);
                        if (parse_ok) {
                            // if (driver.errors) break;
                            driver.produce((driver.checkOnly ? FinallyAction::None : FinallyAction::PrintOnConsole), output);
                        }
                    }

                }
                catch (po::ambiguous_option & e1)
                {
                    output << "Ambiguous option" << endl;
                }
                catch (po::unknown_option & e2)
                {
                    buffer.append(line + "\n");
                    line.clear();
                }
            }
        STATS(false)
    }

    return 0;
}
