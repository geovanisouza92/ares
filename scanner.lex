%{
#include "scanner.h"
#include "parser.h"
#include "version.h"

using namespace std;
using namespace LANG_NAMESPACE;

typedef Parser::token token;
typedef Parser::token_type token_type;

#define yyterminate() return token::sEOF;

#define YY_NO_UNISTD_H
%}

%option debug
%option c++ prefix="arc" batch yywrap nounput stack

%{
#define YY_USER_ACTION yylloc->columns(yyleng);
%}

id  [a-zA-Z_][a-zA-Z_\-0-9]*

%%

%{
    yylloc->step();
%}

".."        return token::DOT2;
"..."       return token::DOT3;
"**"        return token::POW;
"||"        return token::OR;
"&&"        return token::AND;
"=="        return token::EQL;
"!="        return token::NEQ;
"is"        return token::IS;
"!is"       return token::NIS;
"<="        return token::LEE;
">="        return token::GEE;
">>"        return token::SHL;
"<<"        return token::SHR;

"false"     return token::FALSE;
"true"      return token::TRUE;

[0-9]*"."[0-9]+([Ee][\+\-]?[0-9]+)? {
    yylval->v_flt = atof(yytext);
    return token::FLOAT;
}

[0-9]+ {
    yylval->v_int = atoi(yytext);
    return token::INTEGER;
}

{id} {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::ID;
}

\"[^\"]*\" {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::STRING;
}

[ \t\r]+ {
    // Whitespace
    yylloc->step();
}

"#"[^\n]*\n? {
    // Comments
    yylloc->lines();
    yylloc->step();
    driver.inc_lines(1);
}

\n {
    yylloc->lines(yyleng);
    yylloc->step();
    driver.inc_lines(1);
    //return token::sEOL;
}

. {
    return static_cast<token_type>(*yytext);
}

%%

namespace LANG_NAMESPACE {

Scanner::Scanner(std::istream* in, std::ostream* out)
    : arcFlexLexer(in, out) {
}

Scanner::~Scanner() {
}

void Scanner::set_debug(bool b) {
    yy_flex_debug = b;
}

}

#ifdef yylex
#undef yylex
#endif

int arcFlexLexer::yylex() {
    std::cerr << "in arcFlexLexer::yylex() !" << std::endl;
    return 0;
}

int arcFlexLexer::yywrap() {
    return 1;
}

int yywrap() {
    // TODO Query source file queue and prepare-it
    return 1;
}
