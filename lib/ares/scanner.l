%{ /* Ares Programming Language */

#include <string>

using namespace std;

#include "scanner.h"
#include "parser.h"
#include "version.h"

using namespace LANG_NAMESPACE;
using namespace LANG_NAMESPACE::Compiler;

typedef Parser::token token;
typedef Parser::token_type token_type;

#define yyterminate() return token::sEOF;

#define YY_NO_UNISTD_H
%}

%option c++ prefix="arc" batch yywrap nounput stack

%{
#define YY_USER_ACTION yylloc->columns(yyleng);
%}

%{
// Expressão regular para interpolação de strings
// inp (?:\".*)(#\{.*\})(?:.*\")
%}

id  [a-zA-Z_][a-zA-Z_\-0-9]*[?!]?
chr \'(\\.|[^\'])\'
str \"(\\.|[^\"])*\"
rgx \/(\\.|[^\/\ ])*\/
csl "//"[^\n]*\n?
cml "/*"(.|\n)*"*/"

%%

%{
    yylloc->step();
%}

"+="    return token::oADE;
"-="    return token::oSUE;
"*="    return token::oMUE;
"/="    return token::oDIE;
"..."   return token::oRAI;
".."    return token::oRAE;
"**"    return token::oPOW;
"==="   return token::oIDE;
"!=="   return token::oNID;
"=="    return token::oEQL;
"!="    return token::oNEQ;
"<="    return token::oLEE;
">="    return token::oGEE;
"=~"    return token::oMAT;
"!~"    return token::oNMA;
"->"    return token::oIMP;
"=>"    return token::oFAR;
"?="    return token::oBET;
"??"    return token::oCOA;
"&&"    return token::oAND;
"||"    return token::oOR;
"++"    return token::oINC;
"--"    return token::oDEC;

"asc"           return token::kASC;
"bool"          return token::kBOOL;
"break"         return token::kBREAK;
"by"            return token::kBY;
"case"          return token::kCASE;
"char"          return token::kCHAR;
"const"         return token::kCONST;
"continue"      return token::kCONTINUE;
"default"       return token::kDEFAULT;
"desc"          return token::kDESC;
"double"        return token::kDOUBLE;
"do"            return token::kDO;
"else"          return token::kELSE;
"false"         return token::kFALSE;
"float"         return token::kFLOAT;
"foreach"       return token::kFOREACH;
"for"           return token::kFOR;
"from"          return token::kFROM;
"group"         return token::kGROUP;
"has"           return token::kHAS;
"if"            return token::kIF;
"int"           return token::kINT;
"in"            return token::kIN;
"join"          return token::kJOIN;
"left"          return token::kLEFT;
"new"           return token::kNEW;
"null"          return token::kNULL;
"on"            return token::kON;
"order"         return token::kORDER;
"regex"         return token::kREGEX;
"return"        return token::kRETURN;
"right"         return token::kRIGHT;
"select"        return token::kSELECT;
"skip"          return token::kSKIP;
"step"          return token::kSTEP;
"string"        return token::kSTRING;
"switch"        return token::kSWITCH;
"take"          return token::kTAKE;
"true"          return token::kTRUE;
"unless"        return token::kUNLESS;
"var"           return token::kVAR;
"where"         return token::kWHERE;
"while"         return token::kWHILE;
"yield"         return token::kYIELD;

[0-9]*"."[0-9]+([Ee][\+\-]?[0-9]+)? {
    yylval->v_flt = atof(yytext);
    return token::FLOAT;
}

[0-9]+([Ee][\+\-]?[0-9]+)? {
    yylval->v_int = atoi(yytext);
    return token::INTEGER;
}

{id} {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::ID;
}

{chr} {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::CHAR;
}

{str} {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::STRING;
}

{rgx}[imx]* {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::REGEX;
}

[ \t]+ {
    // Whitespace
    yylloc->step();
}

{cml} {
    string input(yytext);
    int linhas = 0;
    for (int i = 0; i < input.length(); i++)
        if (input[i] == '\n')
            ++linhas;
    yylloc->lines();
    yylloc->step();
    driver.incLines(linhas);
}

{csl} {
    // Comments
    yylloc->lines();
    yylloc->step();
    driver.incLines();
}

[\n\r] {
    yylloc->lines(yyleng);
    yylloc->step();
    driver.incLines();
}

. {
    return static_cast<token_type>(*yytext);
}

%%

namespace LANG_NAMESPACE {
namespace Compiler {

Scanner::Scanner(std::istream* in, std::ostream* out)
    : arcFlexLexer(in, out) {
}

Scanner::~Scanner() {
}

void Scanner::set_debug(bool b) {
    yy_flex_debug = b;
}

} // Compiler
} // LANG_NAMESPACE

#ifdef yylex
#undef yylex
#endif

int arcFlexLexer::yylex() {
    std::cerr << "in arcFlexLexer::yylex() !" << std::endl;
    return 0;
}

int arcFlexLexer::yywrap() {
    // TODO Retornando 0 ele continua esperando mais entradas...
    // Basicamente, o lexer chama o driver esperando mais entrada,
    //   em seguida este recebe uma linha, insere na entrada e retorna 0
    return 1;
}

int yywrap() {
    // TODO Query source file queue and prepare-it
    return 1;
}
