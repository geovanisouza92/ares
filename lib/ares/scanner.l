%{

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
 * scanner.l - Lexical Analyzer
 *
 * Flex script to generate the scanner.cpp file
 *
 */

#include <string>

using namespace std;

#include "scanner.h"
#include "parser.h"

using namespace LANG_NAMESPACE;
using namespace LANG_NAMESPACE::VirtualEngine;

typedef Parser::token token;
typedef Parser::token_type token_type;

#define yyterminate() return token::sEOF;

#define YY_NO_UNISTD_H
%}

%option c++ prefix="arc" batch yywrap yylineno nounput stack debug

%{
#define YY_USER_ACTION yylloc->columns(yyleng);
%}

%{
// Expressão regular para interpolação de strings
// inp (?:\".*)(#\{.*\})(?:.*\")

/** Outros caracteres que representam espaço em branco
    En Quad (U+2000)
    Em Quad (U+2001)
    En Space (U+2002)
    Em Space (U+2003)
    Three-Per-Em Space (U+2004)
    Four-Per-Em Space (U+2005)
    Six-Per-Em Space (U+2006)
    Figure Space (U+2007)
    Punctuation Space (U+2008)
    Thin Space (U+2009)
    Hair Space (U+200A)
    Mathematical Space (U+205F)
*/
%}

csl "//"[^\n\r]*
nl  (\n|\r|\n\r|\r\n)
ws  [ \t]+
flt [0-9]*"."[0-9]+([Ee][\+\-]?[0-9]+)?
int [0-9]+([Ee][\+\-]?[0-9]+)?
id  [a-zA-Z_][a-zA-Z_\-0-9]*
chr \'(\\.|[^\'])\'
str \"(\\.|[^\"])*\"
rgx \/(\\.|[^\/\ ])*\/

%x ML_COMMENT

%%

%{
    yylloc->step();
%}

"/*" {
    yylloc->step();
    yy_push_state(ML_COMMENT);
}

<ML_COMMENT>. {
    yylloc->step();
}

<ML_COMMENT>\n {
    yylloc->step();
    yylloc->lines();
    // driver.incLines();
}

<ML_COMMENT>"*/" {
    yylloc->step();
    yy_pop_state();
}

{csl} {
    yylloc->step();
    yylloc->lines();
    // driver.incLines();
}

"%="    return token::oMOE;
"^="    return token::oMDE;
"|="    return token::oORE;
"&="    return token::oANE;
"<<="   return token::oSLE;
">>="   return token::oSRE;
"+="    return token::oADE;
"-="    return token::oSUE;
"*="    return token::oMUE;
"/="    return token::oDIE;
"..."   return token::oRAI;
".."    return token::oRAE;
"**"    return token::oPOW;
">>"    return token::oSHR;
"<<"    return token::oSHL;
"=="    return token::oEQL;
"!="    return token::oNEQ;
"<="    return token::oLEE;
">="    return token::oGEE;
"=~"    return token::oMAT;
"!~"    return token::oNMA;
"=>"    return token::oFAR;
"??"    return token::oCOA;
"&&"    return token::oAND;
"||"    return token::oOR;
"++"    return token::oINC;
"--"    return token::oDEC;
"->"    return token::oIND;

"array"         return token::kARRAY;
"asc"           return token::kASC;
"async"         return token::kASYNC;
"await"         return token::kAWAIT;
"bool"          return token::kBOOL;
"break"         return token::kBREAK;
"byte"          return token::kBYTE;
"by"            return token::kBY;
"case"          return token::kCASE;
"catch"         return token::kCATCH;
"char"          return token::kCHAR;
"const"         return token::kCONST;
"continue"      return token::kCONTINUE;
"decimal"       return token::kDECIMAL;
"default"       return token::kDEFAULT;
"desc"          return token::kDESC;
"double"        return token::kDOUBLE;
"do"            return token::kDO;
"else"          return token::kELSE;
"enum"          return token::kENUM;
"extern"        return token::kEXTERN;
"false"         return token::kFALSE;
"finally"       return token::kFINALLY;
"float"         return token::kFLOAT;
"foreach"       return token::kFOREACH;
"for"           return token::kFOR;
"from"          return token::kFROM;
"hash"          return token::kHASH;
"group"         return token::kGROUP;
"if"            return token::kIF;
"into"          return token::kINTO;
"int"           return token::kINT;
"in"            return token::kIN;
"is"            return token::kIS;
"join"          return token::kJOIN;
"left"          return token::kLEFT;
"let"           return token::kLET;
"lock"          return token::kLOCK;
"long"          return token::kLONG;
"new"           return token::kNEW;
"null"          return token::kNULL;
"on"            return token::kON;
"order"         return token::kORDER;
"params"        return token::kPARAMS;
"regex"         return token::kREGEX;
"return"        return token::kRETURN;
"right"         return token::kRIGHT;
"select"        return token::kSELECT;
"short"         return token::kSHORT;
"sizeof"        return token::kSIZEOF;
"skip"          return token::kSKIP;
"static"        return token::kSTATIC;
"step"          return token::kSTEP;
"string"        return token::kSTRING;
"struct"        return token::kSTRUCT;
"switch"        return token::kSWITCH;
"take"          return token::kTAKE;
"throw"         return token::kTHROW;
"true"          return token::kTRUE;
"try"           return token::kTRY;
"typeof"        return token::kTYPEOF;
"unless"        return token::kUNLESS;
"unsigned"      return token::kUNSIGNED;
"using"         return token::kUSING;
"var"           return token::kVAR;
"void"          return token::kVOID;
"where"         return token::kWHERE;
"while"         return token::kWHILE;
"yield"         return token::kYIELD;

{flt} {
    yylval->v_flt = atof(yytext);
    return token::FLOAT;
}

{int} {
    yylval->v_int = atoi(yytext);
    return token::INTEGER;
}

{id} {
    yylval->v_str = new std::string(yytext, yyleng);
    return token::IDENTIFIER;
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

{ws} { // Whitespace
    yylloc->step();
}

{nl} {
    yylloc->step();
    yylloc->lines();
    // driver.incLines();
}

. {
    return static_cast<token_type>(*yytext);
}

%%

namespace LANG_NAMESPACE
{
    namespace VirtualEngine
    {
        Scanner::Scanner(std::istream* in, std::ostream* out)
            : arcFlexLexer(in, out) { }

        Scanner::~Scanner() { }

        void
        Scanner::set_debug(bool b) {
            yy_flex_debug = b;
        }
    } // Compiler
} // LANG_NAMESPACE

#ifdef yylex
#undef yylex
#endif

int
arcFlexLexer::yylex()
{
    std::cerr << "in arcFlexLexer::yylex() !" << std::endl;
    return 0;
}

int
arcFlexLexer::yywrap()
{
    // TODO Retornando 0 ele continua esperando mais entradas...
    // Basicamente, o lexer chama o driver esperando mais entrada,
    //   em seguida este recebe uma linha, insere na entrada e retorna 0
    return 1;
}

int
yywrap()
{
    // TODO Query source file queue and prepare-it
    return 1;
}
