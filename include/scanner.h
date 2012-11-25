/** Ares Programming Language
 *
 * scanner.h - Lexical Scanner
 *
 * Defines scanner used to manipulate the lexical analyzer generated by Flex
 */

#ifndef LANG_SCANNER_H
#define LANG_SCANNER_H

#include <iostream>
#include "driver.h"
#include "parser.h"

using namespace std;
using namespace LANG_NAMESPACE;

#ifndef YY_DECL

#define YY_DECL \
    VirtualEngine::Parser::token_type \
    VirtualEngine::Scanner::lex ( \
            VirtualEngine::Parser::semantic_type* yylval, \
            VirtualEngine::Parser::location_type* yylloc, \
        class VirtualEngine::Driver& driver)
#endif

#ifndef __FLEX_LEXER_H
#define yyFlexLexer arcFlexLexer
#include "FlexLexer.h"
#undef yyFlexLexer
#endif

namespace LANG_NAMESPACE
{
    namespace VirtualEngine
    {
    	/**
    	 * Represents the lexical analyzer generated by Flex
    	 */
        class Scanner: public arcFlexLexer
        {
        public:
            Scanner (istream* arg_yyin = 0, ostream* arg_yyout = 0);
            virtual ~Scanner ();
            virtual Parser::token_type lex (Parser::semantic_type* yylval, Parser::location_type* yylloc, class Driver& driver);
            void set_debug (bool b);
        };
    } // Driver
} // LANG_NAMESPACE

#endif
