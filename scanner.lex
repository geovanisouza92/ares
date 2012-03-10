%{

using namespace std;

#include "scanner.h"
#include "parser.h"
#include "version.h"

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

id  [a-zA-Z_][a-zA-Z_0-9]*[?]?

%%

%{
    yylloc->step();
%}

".."        return token::DOT2;
"..."       return token::DOT3;
"+="        return token::ADE;
"-="        return token::SUE;
"*="        return token::MUE;
"/="        return token::DIE;
"**"        return token::POW;
"||"        return token::OR;
"&&"        return token::AND;
"=="        return token::EQL;
"!="        return token::NEQ;
"<="        return token::LEE;
">="        return token::GEE;
">>"        return token::SHL;
"<<"        return token::SHR;
"=~"        return token::MAT;
"!~"        return token::NMA;

"async"     return token::kASYNC;
"asc"       return token::kASC;
"as"        return token::kAS;
"by"        return token::kBY;
"case"      return token::kCASE;
"desc"      return token::kDESC;
"do"        return token::kDO;
"elif"      return token::kELIF;
"else"      return token::kELSE;
"end"       return token::kEND;
"false"     return token::kFALSE;
"for"       return token::kFOR;
"from"      return token::kFROM;
"group"     return token::kGROUP;
"if"        return token::kIF;
"in"        return token::kIN;
"is"        return token::kIS;
"join"      return token::kJOIN;
"left"      return token::kLEFT;
"new"       return token::kNEW;
"nil"       return token::kNIL;
"on"        return token::kON;
"order"     return token::kORDER;
"raise"     return token::kRAISE;
"right"     return token::kRIGHT;
"select"    return token::kSELECT;
"skip"      return token::kSKIP;
"step"      return token::kSTEP;
"take"      return token::kTAKE;
"then"      return token::kTHEN;
"true"      return token::kTRUE;
"unless"    return token::kUNLESS;
"until"     return token::kUNTIL;
"when"      return token::kWHEN;
"where"     return token::kWHERE;
"while"     return token::kUNTIL;

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

\/[^\/]*\/ {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::REGEX;
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
