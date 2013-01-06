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
 * util.cpp - Utilities
 *
 * Implements utility functions used by virtual platform
 *
 */

#include <string>
#include <sstream>
#include "util.h"
#include "version.h"

string
LANG_NAMESPACE::Util::trimString(string str, char c)
{
    string::size_type posb, pose;
    posb = str.find_first_not_of(c);
    if(posb != string::npos) str = str.substr(posb, str.length());
    pose = str.find_last_not_of(c);
    if(pose != string::npos) str = str.substr(0, pose + 1);
    if(posb == pose) str.clear();
    return str;
}

string
LANG_NAMESPACE::Util::intToStr(int num)
{
    stringstream str;
    str << num;
    string conv = str.str();
    for(unsigned i = conv.length() - 1; i > 1; i--)
        if((i % 3) == 0) conv.insert(conv.length() - i, " ");
    return conv;
}

string
LANG_NAMESPACE::Util::formatNumber(int n, int w, char c = ' ')
{
    stringstream s;
    s.fill(c);
    s.width(w);
    s << n;
    return s.str();
}

double
LANG_NAMESPACE::Util::getMili()
{
  return(double)((clock() - start) /(CLOCKS_PER_SEC / 1000) );
}

string
LANG_NAMESPACE::Util::statistics(unsigned total_files, unsigned total_lines, bool print_time = false)
{
    double elapsed = getMili() / 1000;
    stringstream s;
    s << "=> Statistics: "
      << COLOR_BCYAN
      << intToStr(total_files)
      << COLOR_RESET
      <<(total_files <= 1 ? " file processed: " : " files processed: ")
      << COLOR_BBLUE
      << intToStr(total_lines)
      << COLOR_RESET
      <<(total_lines > 1 ? " lines in " : " line in ")
      << COLOR_BYELLOW
      << elapsed
      << COLOR_RESET
      <<(elapsed <= 1 ? " second" : " seconds");
    if(print_time) {
        s <<(elapsed <= 1 ? " / " : " / =~ ")
          << COLOR_BGREEN
          << intToStr((elapsed >= 1 ?(int)(total_lines / elapsed) : total_lines) )
          << COLOR_RESET
          <<(total_lines > 1 ? " lines per second." : " line per second.");
    } else
        s << '.';
    s << endl;
    return s.str();
}

string
LANG_NAMESPACE::langVersionInfo()
{
    stringstream s;
    s << LANG_NAME
      << " "
      << langVersion()
      << " "
      << langRelease()
      << " "
      << '['
      << LANG_HOST_PLATFORM
      << ']'
      << endl
      << langCopy()
      << endl
      << "More info in "
      << LANG_HOME_PAGE;
    return s.str();
}

string
LANG_NAMESPACE::langVersion()
{
    stringstream s;
    s << LANG_VERSION_MAJOR
      << "."
      << LANG_VERSION_MINOR
      << "."
      << LANG_VERSION_PATCH
      << LANG_VERSION_COMMENT;
    return s.str();
}

string
LANG_NAMESPACE::langRelease()
{
    stringstream s;
    s << "(Release "
      << LANG_RELEASE_YEAR
      << "-"
      << LANG_RELEASE_MONTH
      << "-"
      << LANG_RELEASE_DAY
      << ")";
    return s.str();
}

string
LANG_NAMESPACE::langCopy()
{
    stringstream s;
    s << "Copyleft "
      << LANG_BIRTH_YEAR
      << "-"
      << LANG_RELEASE_YEAR
      << " "
      << LANG_AUTHOR_NAME
      << " ("
      << LANG_AUTHOR_EMAIL
      << ")";
    return s.str();
}
