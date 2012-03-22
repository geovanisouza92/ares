
#ifndef ARES_SCANNER_H
#define ARES_SCANNER_H

#include <iostream>

using namespace std;

#include "langconfig.h"
#include "driver.h"
#include "parser.h"

using namespace LANG_NAMESPACE;

#ifndef YY_DECL

#define YY_DECL \
    Parser::token_type \
    Scanner::lex( \
        Parser::semantic_type* yylval, \
        Parser::location_type* yylloc, \
        class Driver& driver )
#endif

#ifndef __FLEX_LEXER_H
#define yyFlexLexer arcFlexLexer
#include "FlexLexer.h"
#undef yyFlexLexer
#endif

namespace LANG_NAMESPACE {

class Scanner :
    public arcFlexLexer {
public:
    Scanner(istream* arg_yyin = 0, ostream* arg_yyout = 0);
    virtual ~Scanner();
    virtual Parser::token_type lex(Parser::semantic_type* yylval, Parser::location_type* yylloc, class Driver& driver);
    void set_debug(bool b);
};

}

#endif
