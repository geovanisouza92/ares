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
 * parser.y - Syntatic Analyzer
 *
 * Bison script to generate the syntax parser of virtual engine
 *
 */

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
 * parser.cpp - Syntatic Analyzer
 *
 * Implements the syntax parser of virtual engine
 *
 */

#include <string>
#include <vector>

using namespace std;

#include "driver.h"
#include "ast.h"
#include "oql.h"
#include "lambda.h"
#include "stmt.h"

using namespace SyntaxTree;

%}

%debug
%require "2.3"
%start Goal
%skeleton "lalr1.cc"
%defines "parser.h"
%define namespace "LANG_NAMESPACE::VirtualEngine"
%define "parser_class_name" "Parser"
%parse-param { class Driver& driver }
// %lex-param { class Driver& driver }
%locations
%error-verbose
%initial-action {
    @$.begin.filename = @$.end.filename = &driver.origin;
    driver.incLines ();
}

%union {
    int                         v_int;
    double                      v_flt;
    string *                    v_str;
    SyntaxTree::SyntaxNode *    v_node;
    SyntaxTree::VectorNode *    v_list;
    Operator::Binary            v_bop;
    OrderType::Type             v_oop;
}

%{
#include "scanner.h"

#undef yylex
#define yylex driver.lexer->lex
%}

%token          sEOF    0   "end of file"

%token  <v_str> IDENTIFIER  "identifier literal"
%token  <v_flt> FLOAT       "float literal"
%token  <v_int> INTEGER     "integer literal"
%token  <v_str> CHAR        "char literal"
%token  <v_str> STRING      "string literal"
%token  <v_str> REGEX       "regex literal"

%nonassoc IDENTIFIER FLOAT INTEGER CHAR STRING REGEX

%token  kARRAY      "array"
%token  kASYNC      "async"
%token  kASC        "asc"
%token  kAS         "as"
%token  kAWAIT      "await"
%token  kBOOL       "bool"
%token  kBREAK      "break"
%token  kBYTE       "byte"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCATCH      "catch"
%token  kCHAR       "char"
%token  kCONST      "const"
%token  kCONTINUE   "continue"
%token  kDECIMAL    "decimal"
%token  kDEFAULT    "default"
%token  kDESC       "desc"
%token  kDOUBLE     "double"
%token  kDO         "do"
%token  kELSE       "else"
%token  kENUM       "enum"
%token  kEXTERN     "extern"
%token  kFALSE      "false"
%token  kFINALLY    "finally"
%token  kFLOAT      "float"
%token  kFOREACH    "foreach"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kGROUP      "group"
%token  kHASH       "hash"
%token  kIF         "if"
%token  kINTO       "into"
%token  kINT        "int"
%token  kIN         "in"
%token  kIS         "is"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kLET        "let"
%token  kLOCK       "lock"
%token  kLONG       "long"
%token  kNEW        "new"
%token  kNULL       "null"
%token  kON         "on"
%token  kORDER      "order"
%token  kPARAMS     "params"
%token  kREGEX      "regex"
%token  kRETURN     "return"
%token  kRIGHT      "right"
%token  kSELECT     "select"
%token  kSHORT      "short"
%token  kSIZEOF     "sizeof"
%token  kSKIP       "skip"
%token  kSTATIC     "static"
%token  kSTEP       "step"
%token  kSTRING     "string"
%token  kSTRUCT     "struct"
%token  kSWITCH     "switch"
%token  kTAKE       "take"
%token  kTHROW      "throw"
%token  kTRUE       "true"
%token  kTRY        "try"
%token  kTYPEOF     "typeof"
%token  kUNSIGNED   "unsigned"
%token  kUNLESS     "unless"
%token  kUSING      "using"
%token  kVAR        "var"
%token  kVOID       "void"
%token  kWHERE      "where"
%token  kWHILE      "while"
%token  kYIELD      "yield"

%left kON kIN
%right kFROM kWHERE kORDER kGROUP kBY kSELECT kJOIN kLEFT kRIGHT
%right kSKIP kSTEP kTAKE

%token  ';'         ";"
%token  '{'         "{"
%token  '}'         "}"
%token  ','         ","
%token  '('         "("
%token  ')'         ")"
%token  ':'         ":"
%token  '='         "="
%token  '.'         "."
%token  '?'         "?"
%token  '^'         "^"
%token  '<'         "<"
%token  '>'         ">"
%token  '+'         "+"
%token  '-'         "-"
%token  '*'         "*"
%token  '/'         "/"
%token  '%'         "%"
%token  '!'         "!"
%token  '['         "["
%token  ']'         "]"
%token  '&'         "&"
%token  '|'         "|"
%token  '~'         "~"
%token  oADE        "+="
%token  oSUE        "-="
%token  oMUE        "*="
%token  oDIE        "/="
%token  oMOE        "%="
%token  oMDE        "^="
%token  oORE        "|="
%token  oANE        "&="
%token  oSLE        "<<="
%token  oSRE        ">>="
%token  oRAI        "..."
%token  oRAE        ".."
%token  oPOW        "**"
%token  oEQL        "=="
%token  oNEQ        "!="
%token  oLEE        "<="
%token  oGEE        ">="
%token  oMAT        "=~"
%token  oNMA        "!~"
%token  oFAR        "=>"
%token  oCOA        "??"
%token  oAND        "&&"
%token  oOR         "||"
%token  oINC        "++"
%token  oDEC        "--"
%token  oSHR        ">>"
%token  oSHL        "<<"
%token  oIND        "->"

%left ';' '{' '}' ',' '(' ')' ':' '=' '.' '?' '^' '<' '>' '+' '-' '*' '/'
%left '%' '!' '[' ']' '&' '|' '~'
%left oADE oSUE oMUE oDIE oRAI oRAE oPOW oEQL oNEQ oLEE oGEE oMAT oNMA oFAR
%left oCOA oAND oOR oINC oDEC oSHR oSHL oIND oMOE oMDE oORE oANE oSLE oSRE

%right UNARY

%type   <v_node>    Literal
%type   <v_node>    BooleanLiteral
%type   <v_node>    ArrayLiteral
%type   <v_node>    HashLiteral
%type   <v_node>    HashPair
%type   <v_node>    Expression
%type   <v_node>    QualifiedIdentifier
%type   <v_node>    ModuleName
%type   <v_node>    TypeName
%type   <v_node>    Type
%type   <v_node>    NonArrayType
%type   <v_node>    ArrayType
%type   <v_node>    SimpleType
%type   <v_node>    PrimitiveType
%type   <v_node>    NumericType
%type   <v_node>    IntegralType
%type   <v_node>    FloatingPointType
%type   <v_node>    ClassType
%type   <v_node>    PointerType
%type   <v_node>    Argument
%type   <v_node>    PrimaryExpression
%type   <v_node>    ParenthesizedExpression
%type   <v_node>    PrimaryExpressionNoParentesis
%type   <v_node>    ArrayCreationExpression
%type   <v_node>    MemberAccess
%type   <v_node>    InvocationExpression
%type   <v_node>    ArraySlice
%type   <v_node>    ElementAccess
%type   <v_node>    NewExpression
%type   <v_node>    TypeofExpression
%type   <v_node>    SizeofExpression
%type   <v_node>    AddressofExpression
%type   <v_node>    PostIncrementExpression
%type   <v_node>    PostDecrementExpression
%type   <v_node>    PreIncrementExpression
%type   <v_node>    PreDecrementExpression
%type   <v_node>    UnaryExpressionNotPlusMinus
%type   <v_node>    PointerMemberAccess
%type   <v_node>    CastExpression
%type   <v_node>    UnaryExpression
%type   <v_node>    PowerExpression
%type   <v_node>    MultiplicativeExpression
%type   <v_node>    AdditiveExpression
%type   <v_node>    ShiftExpression
%type   <v_node>    RelationalExpression
%type   <v_node>    EqualityExpression
%type   <v_node>    AndExpression
%type   <v_node>    ExclusiveOrExpression
%type   <v_node>    InclusiveOrExpression
%type   <v_node>    ConditionalAndExpression
%type   <v_node>    ConditionalOrExpression
%type   <v_node>    RangeExpression
%type   <v_node>    ConditionalExpression
%type   <v_node>    BooleanExpression
%type   <v_node>    TimedExpression
%type   <v_node>    ObjectCreationExpression
%type   <v_node>    PostfixExpression
%type   <v_node>    NullCoalescingExpression
%type   <v_node>    AssignmentExpression

// OQL
%type   <v_node>    SelectOrGroupClause
%type   <v_node>    GroupByClause
%type   <v_node>    SelectClause
%type   <v_node>    LetClause
%type   <v_node>    RangeClause
%type   <v_node>    OrderExpression
%type   <v_node>    JoinClause
%type   <v_node>    QueryBodyMember
%type   <v_node>    QueryBody
%type   <v_node>    QueryOrigin
%type   <v_node>    QueryExpression

// Lambda
%type   <v_node>    LambdaParameter
%type   <v_node>    LambdaExpressionBody
%type   <v_node>    LambdaExpression

// Top-level goal
%type   <v_node>    GoalOption
%type   <v_node>    Statement
%type   <v_node>    TypeDeclaration
%type   <v_node>    UsingDirective

// Collections
%type   <v_list>    ArgumentList
%type   <v_list>    ExpressionList
%type   <v_list>    HashPairList
%type   <v_list>    HashPairListOpt
%type   <v_list>    LambdaParameterList
%type   <v_list>    LambdaParameterListOpt
%type   <v_list>    OrderExpressionList
%type   <v_list>    QueryBodyMemberRepeat
%type   <v_list>    GoalOptionRepeat
%type   <v_list>    StatementRepeat
%type   <v_list>    UsingDirectiveRepeat

%type   <v_bop>      AssignmentOperator
%type   <v_oop>      OrderOperatorOpt

%%

Goal
    : /* empty */
    {
        driver.enviro->push(new VectorNode());
    }
    | GoalOptionRepeat
    {
        driver.enviro->push($1);
    }
    ;

GoalOptionRepeat
    : GoalOption
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | GoalOptionRepeat GoalOption
    {
        $1->push_back($2);
        $$ = $1;
    }
    ;

GoalOption
    : TypeDeclaration
    {
        // $$ = $1;
    }
    | UsingDirectiveRepeat
    // | Statement
    ;

Literal
    : kNULL
    {
        $$ = new NullLiteralNode();
    }
    | INTEGER
    {
        $$ = new IntegerLiteralNode($1);
    }
    | FLOAT
    {
        $$ = new FloatLiteralNode($1);
    }
    | CHAR
    {
        $$ = new CharLiteralNode((*$1)[0]);
    }
    | STRING
    {
        $$ = new StringLiteralNode(*$1);
    }
    | REGEX
    {
        $$ = new RegexLiteralNode(*$1);
    }
    | BooleanLiteral
    {
        $$ = $1;
    }
    | ArrayLiteral
    {
        $$ = $1;
    }
    | HashLiteral
    {
        $$ = $1;
    }
    ;

BooleanLiteral
    : kFALSE
    {
        $$ = new BooleanLiteralNode(false);
    }
    | kTRUE
    {
        $$ = new BooleanLiteralNode(true);
    }
    ;

ArrayLiteral
    : '[' ']'
    {
        $$ = new ArrayLiteralNode();
    }
    | '[' ExpressionList ']'
    {
        $$ = new ArrayLiteralNode($2);
    }
    | '[' ExpressionList ',' ']'
    {
        $$ = new ArrayLiteralNode($2);
    }
    ;

// ExpressionListOpt
//     : /* empty */
//     | ExpressionList
//     ;

HashLiteral
    : '{' HashPairListOpt '}'
    {
        $$ = new HashLiteralNode($2);
    }
/*    {
        $$ = new HashLiteralNode();
    } * /
    | '{' HashPairList '}'
    {
        $$ = new HashLiteralNode($2);
    }
    | '{' HashPairList ',' '}'
    {
        $$ = new HashLiteralNode($2);
    } */
    ;

HashPairListOpt
    : /* empty */
    {
        $$ = new VectorNode();
    }
    | HashPairList
    {
        $$ = $1;
    }
    ;

HashPairList
    : HashPair
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | HashPairList ',' HashPair
    {
        $$ = $1;
        $$->push_back($3);
    }
    ;

HashPair
    : IDENTIFIER ':' Expression
    {
        $$ = new PairNode(new IdNode(*$1), $3);
    }
    | STRING ':' Expression
    {
        $$ = new PairNode(new IdNode(*$1), $3);
    }
    ;

ModuleName
    : QualifiedIdentifier
    {
        $$ = $1;
    }
    ;

TypeName
    : QualifiedIdentifier
    {
        $$ = $1;
    }
    ;

Type
    : NonArrayType
    {
        $$ = $1;
    }
    | ArrayType
    {
        $$ = $1;
    }
    | kVAR
    {
        $$ = new Type("var");
    }
    ;

NonArrayType
    : SimpleType
    {
        $$ = $1;
    }
    | TypeName
    {
        $$ = $1;
    }
    ;

SimpleType
    : PrimitiveType
    {
        $$ = $1;
    }
    | ClassType
    {
        $$ = $1;
    }
    | PointerType
    {
        $$ = $1;
    }
    ;

PrimitiveType
    : NumericType
    {
        $$ = $1;
    }
    | kBOOL
    {
        $$ = new Type("bool");
    }
    ;

NumericType
    : IntegralType
    {
        $$ = $1;
    }
    | FloatingPointType
    {
        $$ = $1;
    }
    | kDECIMAL
    {
        $$ = new Type("decimal");
    }
    ;

IntegralType
    : kBYTE
    {
        $$ = new Type("byte");
    }
    | kSHORT
    {
        $$ = new Type("short");
    }
    | kUNSIGNED kSHORT
    {
        $$ = new Type("ushort");
    }
    | kINT
    {
        $$ = new Type("int");
    }
    | kUNSIGNED kINT
    {
        $$ = new Type("uint");
    }
    | kLONG
    {
        $$ = new Type("long");
    }
    | kUNSIGNED kLONG
    {
        $$ = new Type("ulong");
    }
    | kLONG kLONG
    {
        $$ = new Type("long long");
    }
    | kCHAR
    {
        $$ = new Type("char");
    }
    ;

FloatingPointType
    : kFLOAT
    {
        $$ = new Type("float");
    }
    | kDOUBLE
    {
        $$ = new Type("double");
    }
    ;

ClassType
    : kSTRING
    {
        $$ = new Type("string");
    }
    | kREGEX
    {
        $$ = new Type("regex");
    }
    | kARRAY
    {
        $$ = new Type("array");
    }
    | kHASH
    {
        $$ = new Type("hash");
    }
    // | kOBJECT
    ;

PointerType
    : Type '*'
    {
        $$ = new PointerNode($1);
    }
    | kVOID '*'
    {
        $$ = new PointerNode(new Type("void"));
    }
    ;

ArrayType
    : ArrayType RankSpecifier
    | SimpleType RankSpecifier
    | QualifiedIdentifier RankSpecifier
    ;

RankSpecifier
    : '[' DimSeparatorsOpt ']'
    ;

DimSeparatorsOpt
    : /* empty */
    | DimSeparators
    ;

DimSeparators
    : ','
    | DimSeparators ','
    ;

ArgumentList
    : Argument
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | ArgumentList ',' Argument
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

Argument
    : Expression
    {
        $$ = $1;
    }
    ;

PrimaryExpression
    : ParenthesizedExpression
    {
        $$ = $1;
    }
    | PrimaryExpressionNoParentesis
    {
        $$ = $1;
    }
    ;

ParenthesizedExpression
    : '(' Expression ')'
    {
        $$ =  $2;
    }
    ;

PrimaryExpressionNoParentesis
    : Literal
    {
        $$ = $1;
    }
    | ArrayCreationExpression
    {
        $$ = $1;
    }
    | MemberAccess
    {
        $$ = $1;
    }
    | InvocationExpression
    {
        $$ = $1;
    }
    | ArraySlice
    {
        $$ = $1;
    }
    | ElementAccess
    {
        $$ = $1;
    }
    // | ThisAccess
    // | BaseAccess
    | NewExpression
    {
        $$ = $1;
    }
    | TypeofExpression
    {
        $$ = $1;
    }
    | SizeofExpression
    {
        $$ = $1;
    }
    ;

ArrayCreationExpression
    : kNEW NonArrayType '[' ExpressionList ']'
    | kNEW NonArrayType '[' ExpressionList ']' ArrayInitializer
    | kNEW ArrayType
    | kNEW ArrayType ArrayInitializer
    ;

// ArrayInitializerOpt
//     : /* empty */
//     | HashLiteral
//     ;

MemberAccess
    : PrimaryExpression '.' IDENTIFIER
    | PrimitiveType '.' IDENTIFIER
    | ClassType '.' IDENTIFIER
    ;

InvocationExpression
    : PrimaryExpressionNoParentesis '(' ArgumentList ')'
    | QualifiedIdentifier '(' ')'
    | QualifiedIdentifier '(' ArgumentList ')'
    ;

// ArgumentListOpt
//     : /* empty */
//     | ArgumentList
//     ;

ArraySlice
    : PrimaryExpression '[' Expression ':' ']'
    | PrimaryExpression '[' ':' Expression ']'
    | PrimaryExpression '[' Expression ':' Expression ']'
    | QualifiedIdentifier '[' Expression ':' ']'
    | QualifiedIdentifier '[' ':' Expression ']'
    | QualifiedIdentifier '[' Expression ':' Expression ']'
    ;

ElementAccess
    : PrimaryExpression '[' ExpressionList ']'
    | QualifiedIdentifier '[' ExpressionList ']'
    ;

ExpressionList
    : Expression
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }

    | ExpressionList ',' Expression
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

// ThisAccess
//     : kTHIS
//     ;

// BaseAccess
//     : kBASE '.' IDENTIFIER
//     | kBASE '[' ExpressionList ']'
//     ;

PostIncrementExpression
    : PostfixExpression oINC
    {
        $$ = new UnaryExpressionNode(Operator::PostInc, $1);
    }
    ;

PostDecrementExpression
    : PostfixExpression oDEC
    {
        $$ = new UnaryExpressionNode(Operator::PostDec, $1);
    }
    ;

NewExpression
    : ObjectCreationExpression
    {
        $$ = $1;
    }
    ;

ObjectCreationExpression
    : kNEW Type '(' ')'
    {
        // $$ = new NewNode($2);
    }
    | kNEW Type '(' ArgumentList ')'
    {
        // $$ = new NewNode($2, $4);
    }
    ;

TypeofExpression
    : kTYPEOF '(' Type ')'
    {
        $$ = new UnaryExpressionNode(Operator::Typeof, $3);
    }
    | kTYPEOF '(' kVOID ')'
    {
        $$ = new UnaryExpressionNode(Operator::Typeof, new Type("void"));
    }
    ;

SizeofExpression
    : kSIZEOF '(' Type ')'
    {
        $$ = new UnaryExpressionNode(Operator::Sizeof, $3);
    }
    // | kSIZEOF '(' Expression ')'
    ;

PointerMemberAccess
    : PostfixExpression oIND IDENTIFIER
    ;

AddressofExpression
    : '&' UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::Ref, $2);
    }
    ;

PostfixExpression
    : PrimaryExpression
    {
        $$ = $1;
    }
    | QualifiedIdentifier
    {
        $$ = $1;
    }
    | PostIncrementExpression
    {
        $$ = $1;
    }
    | PostDecrementExpression
    {
        $$ = $1;
    }
    | PointerMemberAccess
    {
        $$ = $1;
    }
    ;

UnaryExpressionNotPlusMinus
    : PostfixExpression
    {
        $$ = $1;
    }
    | '!' UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::Not, $2);
    }
    | '~' UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::Compl, $2);
    }
    | CastExpression
    {
        $$ = $1;
    }
    ;

PreIncrementExpression
    : oINC UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::PreInc, $2);
    }
    ;

PreDecrementExpression
    : oDEC UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::PreDec, $2);
    }
    ;

UnaryExpression
    : UnaryExpressionNotPlusMinus
    {
        $$ = $1;
    }
    | '+' UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::UAdd, $2);
    }
    | '-' UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::USub, $2);
    }
    | '*' UnaryExpression %prec UNARY
    {
        $$ = new UnaryExpressionNode(Operator::Ptr, $2);
    }
    | PreIncrementExpression
    {
        $$ = $1;
    }
    | PreDecrementExpression
    {
        $$ = $1;
    }
    | AddressofExpression
    {
        $$ = $1;
    }
    ;

CastExpression
    : /* '(' Type ')' UnaryExpressionNotPlusMinus
    | */ '(' Expression ')' UnaryExpressionNotPlusMinus
    | '(' MultiplicativeExpression '*' ')' UnaryExpressionNotPlusMinus
    | '(' QualifiedIdentifier RankSpecifier ')' UnaryExpressionNotPlusMinus
    | '(' QualifiedIdentifier RankSpecifier TypeQuals ')' UnaryExpressionNotPlusMinus
    | '(' PrimitiveType ')' UnaryExpressionNotPlusMinus
    | '(' PrimitiveType TypeQuals ')' UnaryExpressionNotPlusMinus
    | '(' ClassType ')' UnaryExpressionNotPlusMinus
    | '(' ClassType TypeQuals ')' UnaryExpressionNotPlusMinus
    | '(' kVOID ')' UnaryExpressionNotPlusMinus //*/
    | '(' kVOID TypeQuals ')' UnaryExpressionNotPlusMinus //*/
    ;

// TypeQualsOpt
//     : /* empty */
//     | TypeQuals
//     ;

TypeQuals
    : TypeQual
    | TypeQuals TypeQual
    ;

TypeQual
    : RankSpecifier
    | '*'
    ;

PowerExpression
    : UnaryExpression
    {
        $$ = $1;
    }
    | PowerExpression oPOW UnaryExpression
    {
        $$ = new BinaryExpressionNode(Operator::Pow, $1, $3);
    }
    ;

MultiplicativeExpression
    : PowerExpression
    {
        $$ = $1;
    }
    | MultiplicativeExpression '*' PowerExpression
    {
        $$ = new BinaryExpressionNode(Operator::Mul, $1, $3);
    }
    | MultiplicativeExpression '/' PowerExpression
    {
        $$ = new BinaryExpressionNode(Operator::Div, $1, $3);
    }
    | MultiplicativeExpression '%' PowerExpression
    {
        $$ = new BinaryExpressionNode(Operator::Mod, $1, $3);
    }
    ;

AdditiveExpression
    : MultiplicativeExpression
    {
        $$ = $1;
    }
    | AdditiveExpression '+' MultiplicativeExpression
    {
        $$ = new BinaryExpressionNode(Operator::Add, $1, $3);
    }
    | AdditiveExpression '-' MultiplicativeExpression
    {
        $$ = new BinaryExpressionNode(Operator::Sub, $1, $3);
    }
    ;

ShiftExpression
    : AdditiveExpression
    {
        $$ = $1;
    }
    | ShiftExpression oSHL AdditiveExpression
    {
        $$ = new BinaryExpressionNode(Operator::Shl, $1, $3);
    }
    | ShiftExpression oSHR AdditiveExpression
    {
        $$ = new BinaryExpressionNode(Operator::Shr, $1, $3);
    }
    ;

RelationalExpression
    : ShiftExpression
    {
        $$ = $1;
    }
    | RelationalExpression '<' ShiftExpression
    {
        $$ = new BinaryExpressionNode(Operator::Let, $1, $3);
    }
    | RelationalExpression '>' ShiftExpression
    {
        $$ = new BinaryExpressionNode(Operator::Get, $1, $3);
    }
    | RelationalExpression oLEE ShiftExpression
    {
        $$ = new BinaryExpressionNode(Operator::Lee, $1, $3);
    }
    | RelationalExpression oGEE ShiftExpression
    {
        $$ = new BinaryExpressionNode(Operator::Gee, $1, $3);
    }
    | RelationalExpression oMAT ShiftExpression
    {
        $$ = new BinaryExpressionNode(Operator::Mat, $1, $3);
    }
    | RelationalExpression oNMA ShiftExpression
    {
        $$ = new BinaryExpressionNode(Operator::Nma, $1, $3);
    }
    | RelationalExpression kIS Type
    {
        $$ = new BinaryExpressionNode(Operator::Is, $1, $3);
    }
    | RelationalExpression kAS Type
    {
        $$ = new BinaryExpressionNode(Operator::As, $1, $3);
    }
    ;

EqualityExpression
    : RelationalExpression
    {
        $$ = $1;
    }
    | EqualityExpression oEQL RelationalExpression
    {
        $$ = new BinaryExpressionNode(Operator::Eql, $1, $3);
    }
    | EqualityExpression oNEQ RelationalExpression
    {
        $$ = new BinaryExpressionNode(Operator::Neq, $1, $3);
    }
    ;

AndExpression
    : EqualityExpression
    {
        $$ = $1;
    }
    | AndExpression '&' EqualityExpression
    {
        $$ = new BinaryExpressionNode(Operator::And, $1, $3);
    }
    ;

ExclusiveOrExpression
    : AndExpression
    {
        $$ = $1;
    }
    | ExclusiveOrExpression '^' AndExpression
    {
        $$ = new BinaryExpressionNode(Operator::Xor, $1, $3);
    }
    ;

InclusiveOrExpression
    : ExclusiveOrExpression
    {
        $$ = $1;
    }
    | InclusiveOrExpression '|' ExclusiveOrExpression
    {
        $$ = new BinaryExpressionNode(Operator::Or, $1, $3);
    }
    ;

ConditionalAndExpression
    : InclusiveOrExpression
    {
        $$ = $1;
    }
    | ConditionalAndExpression oAND InclusiveOrExpression
    {
        $$ = new BinaryExpressionNode(Operator::BAnd, $1, $3);
    }
    ;

ConditionalOrExpression
    : ConditionalAndExpression
    {
        $$ = $1;
    }
    | ConditionalOrExpression oOR ConditionalAndExpression
    {
        $$ = new BinaryExpressionNode(Operator::BOr, $1, $3);
    }
    ;

RangeExpression
    : ConditionalOrExpression
    {
        $$ = $1;
    }
    | RangeExpression oRAE ConditionalOrExpression
    {
        $$ = new BinaryExpressionNode(Operator::Rae, $1, $3);
    }
    | RangeExpression oRAI ConditionalOrExpression
    {
        $$ = new BinaryExpressionNode(Operator::Rai, $1, $3);
    }
    ;

NullCoalescingExpression
    : RangeExpression
    {
        $$ = $1;
    }
    | NullCoalescingExpression oCOA RangeExpression
    {
        $$ = new BinaryExpressionNode(Operator::Coa, $1, $3);
    }
    ;

ConditionalExpression
    : NullCoalescingExpression
    {
        $$ = $1;
    }
    | ConditionalExpression '?' Expression ':' Expression
    {
        $$ = new TernaryExpressionNode(Operator::Iif, $1, $3, $5);
    }
    ;

AssignmentExpression
    : UnaryExpression AssignmentOperator Expression
    {
        $$ = new BinaryExpressionNode($2, $1, $3);
    }
    ;

AssignmentOperator
    : '='
    {
        $$ = Operator::Assign;
    }
    | oADE /* += */
    {
        $$ = Operator::Ade;
    }
    | oSUE /* -= */
    {
        $$ = Operator::Sue;
    }
    | oMUE /* *= */
    {
        $$ = Operator::Mue;
    }
    | oDIE /* /= */
    {
        $$ = Operator::Die;
    }
    | oMDE /* %= */
    {
        $$ = Operator::Mde;
    }
    // | oMOE /* ^= */
    // | oANE /* &= */
    // | oORE /* |= */
    // | oSLE /* <<= */
    // | oSRE /* >>= */
    ;

SelectOrGroupClause
    : GroupByClause
    {
        $$ = $1;
    }
    | SelectClause
    {
        $$ = $1;
    }
    ;

GroupByClause
    : kGROUP IDENTIFIER kBY Expression
    {
        $$ = new GroupByNode(new IdNode(*$2), $4);
    }
    | kGROUP IDENTIFIER kBY Expression kINTO IDENTIFIER
    {
        auto group = new GroupByNode(new IdNode(*$2), $4);
        group->set_id(new IdNode(*$6));
        $$ = group;
    }
    ;

SelectClause
    : kSELECT ExpressionList
    {
        $$ = new SelectNode($2);
    }
    ;

LetClause
    : kLET IDENTIFIER '=' Expression
    {
        $$ = new LetNode(new IdNode(*$2), $4);
    }
    ;

RangeClause
    : kSKIP Expression
    {
        $$ = new RangeNode(RangeType::Skip, $2);
    }
    | kSTEP Expression
    {
        $$ = new RangeNode(RangeType::Step, $2);
    }
    | kTAKE Expression
    {
        $$ = new RangeNode(RangeType::Take, $2);
    }
    ;

OrderExpressionList
    : OrderExpression
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | OrderExpressionList ',' OrderExpression
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

OrderExpression
    : Expression OrderOperatorOpt
    {
        $$ = new OrderExprNode($2, $1);
    }
    ;

OrderOperatorOpt
    : /* empty */
    {
        $$ = OrderType::None;
    }
    | kASC
    {
        $$ = OrderType::Asc;
    }
    | kDESC
    {
        $$ = OrderType::Desc;
    }
    ;

JoinClause
    : kJOIN QueryOrigin kON BooleanExpression
    {
        $$ = new JoinNode(JoinType::None, $2, $4);
    }
    | kLEFT kJOIN QueryOrigin kON BooleanExpression
    {
        $$ = new JoinNode(JoinType::Left, $3, $5);
    }
    | kRIGHT kJOIN QueryOrigin kON BooleanExpression
    {
        $$ = new JoinNode(JoinType::Right, $3, $5);
    }
    | kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    {
        auto join = new JoinNode(JoinType::None, $2, $4);
        join->set_new_id(new IdNode(*$6));
        $$ = join;
    }
    | kLEFT kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    {
        auto join = new JoinNode(JoinType::Left, $3, $5);
        join->set_new_id(new IdNode(*$7));
        $$ = join;
    }
    | kRIGHT kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    {
        auto join = new JoinNode(JoinType::Right, $3, $5);
        join->set_new_id(new IdNode(*$7));
        $$ = join;
    }
    ;

QueryBodyMemberRepeat
    : QueryBodyMember
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | QueryBodyMemberRepeat QueryBodyMember
    {
        $1->push_back($2);
        $$ = $1;
    }
    ;

QueryBodyMember
    : kWHERE BooleanExpression
    {
        $$ = new WhereNode($2);
    }
    | kORDER kBY OrderExpressionList
    {
        $$ = new OrderByNode($3);
    }
    | JoinClause
    {
        $$ = $1;
    }
    | RangeClause
    {
        $$ = $1;
    }
    | LetClause
    {
        $$ = $1;
    }
    ;

QueryBody
    : QueryBodyMemberRepeat SelectOrGroupClause
    {
        auto query = new QueryBodyNode();
        query->set_body($1);
        query->set_finally($2);
        $$ = query;
    }
    | QueryBodyMemberRepeat
    {
        auto query = new QueryBodyNode();
        query->set_body($1);
        $$ = query;
    }
    | SelectOrGroupClause
    {
        auto query = new QueryBodyNode();
        query->set_finally($1);
        $$ = query;
    }
    ;

QueryOrigin
    : IDENTIFIER kIN Expression
    {
        $$ = new QueryOriginNode(new IdNode(*$1), $3);
    }
    ;

QueryExpression
    : kFROM QueryOrigin
    {
        $$ = new QueryNode($2, new QueryBodyNode());
    }
    | kFROM QueryOrigin QueryBody
    {
        $$ = new QueryNode($2, $3);
    }
    ;

LambdaParameter
    : Type IDENTIFIER
    {
        // $$ = new LambdaParameter($2, $1);
    }
    | IDENTIFIER
    {
        // $$ = new LambdaParameter($1, new Type("var"));
    }
    ;

LambdaParameterList
    : LambdaParameter
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | LambdaParameterList ',' LambdaParameter
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

LambdaParameterListOpt
    : /* empty */
    {
        $$ = new VectorNode();
    }
    | LambdaParameterList
    {
        $$ = $1;
    }
    ;

LambdaExpressionBody
    : Expression
    {
        $$ = $1;
    }
    | Block
    ;

LambdaExpression
    : IDENTIFIER oFAR LambdaExpressionBody
    {
        auto _id = new IdNode(*$1);
        auto _params = new VectorNode();
        _params->push_back(_id);
        // $$ = new LambdaNode($3, _params);
    }
    | '(' ')' oFAR LambdaExpressionBody
    {
        // $$ = new LambdaNode($4);
    }
    | '(' LambdaParameterListOpt ')' oFAR LambdaExpressionBody
    {
        // $$ = new LambdaNode($2, $5);
    }
    ;

TimedExpression
    : kASYNC Expression
    {
        // $$ = new AsyncExpression($2);
    }
    | kAWAIT Expression
    {
        // $$ = new AwaitExpression($2);
    }
    ;

Expression
    : ConditionalExpression
    {
        $$ = $1;
    }
    | AssignmentExpression
    | QueryExpression
    | LambdaExpression
    {
        $$ = $1;
    }
    | TimedExpression
    {
        $$ = $1;
    }
    ;

ConstantExpression
    : Expression
    ;

BooleanExpression
    : Expression
    ;

Statement
    : DeclarationStatement
    | NormalStatement
    ;

NormalStatement
    : Block
    | EmptyStatement
    | ExpressionStatement
    | SelectionStatement
    | IterationStatement
    | JumpStatement
    | TryStatement
    | LockStatement
    | UsingStatement
    ;

Block
    : '{' StatementRepeatOpt '}'
    ;

StatementRepeatOpt
    : /* empty */
    | StatementRepeat
    ;

StatementRepeat
    : Statement
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | StatementRepeat Statement
    {
        $1->push_back($2);
        $$ = $1;
    }
    ;

EmptyStatement
    : ';'
    ;

DeclarationStatement
    : LocalVariableDeclaration ';'
    | LocalConstantDeclaration ';'
    ;

LocalVariableDeclaration
    : Type VariableDeclaratorList
    ;

VariableDeclaratorList
    : VariableDeclarator
    | VariableDeclaratorList ',' VariableDeclarator
    ;

VariableDeclarator
    : IDENTIFIER
    | IDENTIFIER '=' VariableInitializer
    ;

VariableInitializer
    : Expression
    | ArrayInitializer
    ;

LocalConstantDeclaration
    : kCONST Type ConstantDeclaratorList
    ;

ConstantDeclaratorList
    : ConstantDeclarator
    | ConstantDeclaratorList ',' ConstantDeclarator
    ;

ConstantDeclarator
    : IDENTIFIER '=' ConstantExpression
    ;

ExpressionStatement
    : StatementExpression ';'
    ;

StatementExpression
    : InvocationExpression
    | ObjectCreationExpression
    | AssignmentExpression
    | PostIncrementExpression
    | PostDecrementExpression
    | PreIncrementExpression
    | PreDecrementExpression
    // | Expression
    ;

SelectionStatement
    : IfStatement
    | UnlessStatement
    | SwitchStatement
    ;

IfStatement
    : kIF '(' Expression ')' NormalStatement
    | kIF '(' Expression ')' NormalStatement kELSE NormalStatement
    ;

UnlessStatement
    : kUNLESS '(' Expression ')' NormalStatement
    | kUNLESS '(' Expression ')' NormalStatement kELSE NormalStatement

SwitchStatement
    : kSWITCH '(' Expression ')' SwitchBlock
    ;

SwitchBlock
    : '{' SwitchSectionRepeat '}'
    ;

// SwitchSectionRepeatOpt
//     : /* empty */
//     | SwitchSectionRepeat
//     ;

SwitchSectionRepeat
    : SwitchSection
    | SwitchSectionRepeat SwitchSection
    ;

SwitchSection
    : SwitchLabelRepeat StatementRepeat
    ;

SwitchLabelRepeat
    : SwitchLabel
    | SwitchLabelRepeat SwitchLabel
    ;

SwitchLabel
    : kCASE Expression ':'
    | kDEFAULT ':'
    ;

IterationStatement
    : WhileStatement
    | DoStatement
    | ForStatement
    | ForeachStatement
    ;

WhileStatement
    : kWHILE '(' BooleanExpression ')' NormalStatement
    ;

DoStatement
    : kDO NormalStatement kWHILE '(' BooleanExpression ')' ';'
    ;

ForStatement
    : kFOR '(' ForInitializerOpt ';' ForConditionOpt ';' ForIteratorOpt ')' NormalStatement
    ;

ForInitializerOpt
    : /* empty */
    | ForInitializer
    ;

ForConditionOpt
    : /* empty */
    | ForCondition
    ;

ForIteratorOpt
    : /* empty */
    | ForIterator
    ;

ForInitializer
    : LocalVariableDeclaration
    | StatementExpressionList
    ;

ForCondition
    : BooleanExpression
    ;

ForIterator
    : StatementExpressionList
    ;

StatementExpressionList
    : StatementExpression
    | StatementExpressionList ',' StatementExpression
    ;

ForeachStatement
    : kFOREACH '(' Type IDENTIFIER kIN Expression ')' NormalStatement
    ;

JumpStatement
    : BreakStatement
    | ContinueStatement
    | ReturnStatement
    | YieldStatement
    | ThrowStatement
    ;

BreakStatement
    : kBREAK ';'
    ;

ContinueStatement
    : kCONTINUE ';'
    ;

ReturnStatement
    : kRETURN ';'
    | kRETURN Expression ';'
    ;

YieldStatement
    : kYIELD /* kBREAK */ ';'
    | kYIELD /* kRETURN */ Expression ';'
    ;

// ExpressionOpt
//     : /* empty */
//     | Expression
//     ;

ThrowStatement
    : kTHROW ';'
    | kTHROW Expression ';'
    ;

TryStatement
    : kTRY Block CatchClauseRepeat
    | kTRY Block FinallyClause
    | kTRY Block CatchClauseRepeat FinallyClause
    ;

CatchClauseRepeat
    : CatchClause
    | CatchClauseRepeat CatchClause
    ;

CatchClause
    : kCATCH '(' ClassType ')' Block
    | kCATCH '(' ClassType IDENTIFIER ')' Block
    | kCATCH '(' TypeName ')' Block
    | kCATCH '(' TypeName IDENTIFIER ')' Block
    | kCATCH Block
    ;

// IdentifierOpt
//     : /* empty */
//     | IDENTIFIER
//     ;

FinallyClause
    : kFINALLY Block
    ;

LockStatement
    : kLOCK '(' Expression ')' NormalStatement
    ;

UsingStatement
    : kUSING '(' ResourceAquisition ')' NormalStatement
    ;

ResourceAquisition
    : LocalVariableDeclaration
    | Expression
    ;

// CompilationUnit
//     : /* UsingDirectiveRepeatOpt AttributesOpt
//     | */ UsingDirectiveRepeatOpt NamespaceMemberDeclarationRepeatOpt
//     ;

// UsingDirectiveRepeatOpt
//     : /* empty */
//     | UsingDirectiveRepeat
//     ;

// AttributesOpt
//     : /* empty */
//     | Attributes
//     ;

// NamespaceMemberDeclarationRepeatOpt
//     : /* empty */
//     | NamespaceMemberDeclarationRepeat
//     ;

// NamespaceDeclaration
//     : AttributesOpt kNAMESPACE QualifiedIdentifier NamespaceBody CommaOpt
//     ;

// CommaOpt
//     : /* empty */
//     | ';'
//     ;

QualifiedIdentifier
    : IDENTIFIER
    | Qualifier IDENTIFIER
    ;

Qualifier
    : IDENTIFIER '.'
    | Qualifier IDENTIFIER '.'
    ;

// NamespaceBody
//     : '{' UsingDirectiveRepeatOpt NamespaceMemberDeclarationRepeatOpt '}'
//     ;

// UsingDirectiveRepeatOpt
//     : /* empty */
//     | UsingDirectiveRepeat
//     ;

UsingDirectiveRepeat
    : UsingDirective
    | UsingDirectiveRepeat UsingDirective
    ;

UsingDirective
    : UsingAliasDirective
    | UsingNamespaceDirective
    ;

UsingAliasDirective
    : kUSING IDENTIFIER '=' QualifiedIdentifier ';'
    ;

UsingNamespaceDirective
    : kUSING ModuleName ';'
    ;

// NamespaceMemberDeclarationRepeat
//     : NamespaceDeclaration
//     | TypeDeclaration
//     ;

TypeDeclaration
    : MethodDeclaration
    | StructDeclaration
    | EnumDeclaration
    // | DelegateDeclaration
    // | InterfaceDeclaration
    // | ClassDeclaration
    ;

// ModifierRepeatOpt
//     : /* empty * /
//     | ModifierRepeat
//     ;

ModifierRepeat
    : Modifier
    | ModifierRepeat Modifier
    ;

Modifier
    : kEXTERN
    | kSTATIC
    | kASYNC
    // | kABSTRACT
    // | kINTERNAL
    // | kNEW
    // | kOVERRIDE
    // | kPRIVATE
    // | kPROTECTED
    // | kPUBLIC
    // | kREADONLY
    // | kSEALED
    // | kUNSAFE
    // | kVIRTUAL
    // | kVOLATILE
    ;

StructDeclaration
    : /* AttributesOpt */ kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody
    | /* AttributesOpt */ kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody ';'
    | /* AttributesOpt */ ModifierRepeat kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody
    | /* AttributesOpt */ ModifierRepeat kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody ';'
    ;

// StructInterfacesOpt
//     : /* empty */
//     | StructInterfaces
//     ;

// StructInterfaces
//     : ':' InterfaceTypeList
//     ;

StructBody
    : '{' StructMemberDeclarationRepeatOpt '}'
    ;

StructMemberDeclarationRepeatOpt
    : /* empty */
    | StructMemberDeclarationRepeat
    ;

StructMemberDeclarationRepeat
    : StructMemberDeclaration
    | StructMemberDeclarationRepeat StructMemberDeclaration
    ;

StructMemberDeclaration
    : ConstantDeclaration
    // | FieldDeclaration
    // | MethodDeclaration
    // | PropertyDeclaration
    // | EventDeclaration
    // | IndexerDeclaration
    // | OperatorDeclaration
    // | ConstructorDeclaration
    | TypeDeclaration
    ;

ConstantDeclaration
    : /* AttributesOpt */ kCONST Type ConstantDeclaratorList ';'
    | /* AttributesOpt */ ModifierRepeat kCONST Type ConstantDeclaratorList ';'
    ;

ArrayInitializer
    : '{' VariableInitializerListOpt '}'
    | '{' VariableInitializerListOpt ',' '}'
    ;

VariableInitializerListOpt
    : /* empty */
    | VariableInitializerList
    ;

VariableInitializerList
    : VariableInitializer
    | VariableInitializerList ',' VariableInitializer
    ;

EnumDeclaration
    : /* AttributesOpt */ kENUM IDENTIFIER EnumBaseOpt EnumBody
    | /* AttributesOpt */ ModifierRepeat kENUM IDENTIFIER EnumBaseOpt EnumBody
    | /* AttributesOpt */ kENUM IDENTIFIER EnumBaseOpt EnumBody ';'
    | /* AttributesOpt */ ModifierRepeat kENUM IDENTIFIER EnumBaseOpt EnumBody ';'
    ;

EnumBaseOpt
    : /* empty */
    | EnumBase
    ;

EnumBase
    : ':' IntegralType /* Type */
    ;

EnumBody
    : '{' EnumMemberDeclarationListOpt '}'
    | '{' EnumMemberDeclarationListOpt ',' '}'
    ;

EnumMemberDeclarationListOpt
    : /* empty */
    | EnumMemberDeclarationList
    ;

EnumMemberDeclarationList
    : EnumMemberDeclaration
    | EnumMemberDeclarationList ',' EnumMemberDeclaration
    ;

EnumMemberDeclaration
    : /* AttributesOpt */ IDENTIFIER
    | /* AttributesOpt */ IDENTIFIER '=' ConstantExpression
    ;

MethodDeclaration
    : MethodHeader MethodBody
    ;

MethodHeader
    : /* AttributesOpt */ kVOID QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ ModifierRepeat kVOID QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ Type QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ ModifierRepeat Type QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ /* Type == int */ QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ ModifierRepeat /* Type == int */ QualifiedIdentifier '(' FormalParameterListOpt ')'
    ;

FormalParameterListOpt
    : /* empty */
    | FormalParameterList
    ;

MethodBody
    : Block
    | ';'
    ;

FormalParameterList
    : FormalParameter
    | FormalParameterList ',' FormalParameter
    ;

FormalParameter
    : FixedParameter
    | ParameterArray
    ;

FixedParameter
    : /* AttributesOpt /* ParameterModifierOpt */ Type IDENTIFIER ParameterInitializerOpt
    ;

ParameterInitializerOpt
    : /* empty */
    | '=' ConstantExpression
    ;

ParameterArray
    : /* AttributesOpt */ kPARAMS ArrayType IDENTIFIER
    ;

%%

namespace LANG_NAMESPACE
{
    namespace VirtualEngine
    {
        void
        Parser::error (const Parser::location_type& l, const std::string& m)
        {
            driver.error (l, m);
        }
    } // VirtualEngine
} // LANG_NAMESPACE
