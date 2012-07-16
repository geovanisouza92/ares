/* Ares Programming Language */

#ifndef LANG_SCANNER_H
#define LANG_SCANNER_H

#include <iostream>

using namespace std;

#include "driver.hpp"
#include "parser.hpp"

using namespace LANG_NAMESPACE;

#ifndef YY_DECL

#define YY_DECL \
    Compiler::Parser::token_type \
    Compiler::Scanner::lex( \
            Compiler::Parser::semantic_type* yylval, \
            Compiler::Parser::location_type* yylloc, \
        class Compiler::Driver& driver )
#endif

#ifndef __FLEX_LEXER_H
#define yyFlexLexer arcFlexLexer
#include "FlexLexer.h"
#undef yyFlexLexer
#endif

namespace LANG_NAMESPACE {
    namespace Compiler {

        class Scanner: public arcFlexLexer {
        public:
            Scanner(istream* arg_yyin = 0, ostream* arg_yyout = 0);
            virtual ~Scanner();
            virtual Parser::token_type lex(Parser::semantic_type* yylval, Parser::location_type* yylloc, class Driver& driver);
            void set_debug(bool b);
        };

    } // Driver
} // LANG_NAMESPACE

#endif
