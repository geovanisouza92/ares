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

id  [a-zA-Z_][a-zA-Z_\-0-9]*[?!]?

%%

%{
    yylloc->step();
%}

"+="    return token::sADE;
"-="    return token::sSUE;
"*="    return token::sMUE;
"/="    return token::sDIE;
"..."   return token::sDOT3;
".."    return token::sDOT2;
"**"    return token::sPOW;
"==="   return token::sIDE;
"=="    return token::sEQL;
"!="    return token::sNEQ;
"<="    return token::sLEE;
">="    return token::sGEE;
"=~"    return token::sMAT;
"!~"    return token::sNMA;

"abstract"      return token::kABSTRACT;
"after"         return token::kAFTER;
"and"|"&&"      return token::kAND;
"asc"           return token::kASC;
"async"         return token::kASYNC;
"attr"          return token::kATTR;
"before"        return token::kBEFORE;
"begin"         return token::kBEGIN;
"between"       return token::kBETWEEN;
"break"         return token::kBREAK;
"by"            return token::kBY;
"case"          return token::kCASE;
"class"         return token::kCLASS;
"const"         return token::kCONST;
"continue"      return token::kCONTINUE;
"def"           return token::kDEF;
"desc"          return token::kDESC;
"do"            return token::kDO;
"elif"          return token::kELIF;
"else"          return token::kELSE;
"end"           return token::kEND;
"ensure"        return token::kENSURE;
"event"         return token::kEVENT;
"exit"          return token::kEXIT;
"false"         return token::kFALSE;
"for"           return token::kFOR;
"from"          return token::kFROM;
"get"           return token::kGET;
"group"         return token::kGROUP;
"has"           return token::kHAS;
"if"            return token::kIF;
"implies"       return token::kIMPLIES;
"import"        return token::kIMPORT;
"include"       return token::kINCLUDE;
"invariants"    return token::kINVARIANTS;
"in"            return token::kIN;
"is"            return token::kIS;
"join"          return token::kJOIN;
"left"          return token::kLEFT;
"module"        return token::kMODULE;
"new"           return token::kNEW;
"nil"           return token::kNIL;
"not"|"!"       return token::kNOT;
"on"            return token::kON;
"order"         return token::kORDER;
"or"|"||"       return token::kOR;
"private"       return token::kPRIVATE;
"protected"     return token::kPROTECTED;
"public"        return token::kPUBLIC;
"raise"         return token::kRAISE;
"require"       return token::kREQUIRE;
"rescue"        return token::kRESCUE;
"retry"         return token::kRETRY;
"return"        return token::kRETURN;
"right"         return token::kRIGHT;
"sealed"        return token::kSEALED;
"select"        return token::kSELECT;
"self"          return token::kSELF;
"set"           return token::kSET;
"signal"        return token::kSIGNAL;
"skip"          return token::kSKIP;
"step"          return token::kSTEP;
"take"          return token::kTAKE;
"then"          return token::kTHEN;
"true"          return token::kTRUE;
"unless"        return token::kUNLESS;
"until"         return token::kUNTIL;
"var"           return token::kVAR;
"when"          return token::kWHEN;
"where"         return token::kWHERE;
"while"         return token::kWHILE;
"xor"|"^"       return token::kXOR;

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

\~\/[^\/]*\/[imx]* {
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
    driver.inc_lines();
}

\n {
    yylloc->lines(yyleng);
    yylloc->step();
    driver.inc_lines();
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
