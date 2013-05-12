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
#include "expr.h"
#include "oql.h"
#include "lambda.h"
#include "stmt.h"
#include "cond.h"
#include "loop.h"
#include "func.h"
#include "async.h"

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
// %type   <v_node>    ModuleName
%type   <v_node>    TypeName
%type   <v_node>    Type
%type   <v_node>    NonArrayType
%type   <v_node>    ArrayType
%type   <v_node>    RankSpecifier
%type   <v_node>    SimpleType
%type   <v_node>    PrimitiveType
%type   <v_node>    NumericType
%type   <v_node>    IntegralType
%type   <v_node>    FloatingPointType
%type   <v_node>    ClassType
// %type   <v_node>    PointerType
%type   <v_node>    Argument
%type   <v_node>    PrimaryExpression
%type   <v_node>    ParenthesizedExpression
%type   <v_node>    PrimaryExpressionNoParentesis
%type   <v_node>    ArrayCreationExpression
%type   <v_node>    MemberAccess
%type   <v_node>    InvocationExpression
// %type   <v_node>    ArraySlice
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
// %type   <v_node>    PointerMemberAccess
// %type   <v_node>    CastExpression
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
%type   <v_node>    Block
%type   <v_node>    ConstantExpression
%type   <v_node>    NormalStatement
%type   <v_node>    DeclarationStatement
%type   <v_node>    VariableInitializer
%type   <v_node>    ExpressionStatement
%type   <v_node>    StatementExpression
%type   <v_node>    SelectionStatement
%type   <v_node>    IterationStatement
%type   <v_node>    JumpStatement
%type   <v_node>    CatchClause
// %type   <v_node>    Modifier
%type   <v_node>    EmptyStatement
%type   <v_node>    TryStatement
// %type   <v_node>    LockStatement
// %type   <v_node>    UsingStatement
%type   <v_node>    LocalVariableDeclaration
%type   <v_node>    LocalConstantDeclaration
// %type   <v_node>    StructMemberDeclaration
%type   <v_node>    IfStatement
%type   <v_node>    SwitchStatement
%type   <v_node>    ForStatement
%type   <v_node>    WhileStatement
%type   <v_node>    DoStatement
%type   <v_node>    ForeachStatement
%type   <v_node>    BreakStatement
%type   <v_node>    ReturnStatement
%type   <v_node>    YieldStatement
%type   <v_node>    SwitchSection
%type   <v_node>    SwitchLabel
%type   <v_node>    VariableDeclarator
%type   <v_node>    ConstantDeclarator
%type   <v_node>    ArrayInitializer
%type   <v_node>    ThrowStatement
%type   <v_node>    UnlessStatement
%type   <v_node>    ContinueStatement
%type   <v_node>    ForConditionOpt
%type   <v_node>    ForCondition
// %type   <v_node>    EnumBase
// %type   <v_node>    EnumMemberDeclaration
%type   <v_node>    FinallyClause
%type   <v_node>    MethodDeclaration
%type   <v_node>    MethodBody
%type   <v_node>    MethodHeader
// %type   <v_node>    ConstantDeclaration
%type   <v_node>    Qualifier
%type   <v_node>    QualifiedIdentifier
%type   <v_node>    ParameterInitializerOpt

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
// %type   <v_node>    UsingDirective
%type   <v_node>    FormalParameter
%type   <v_node>    FixedParameter
%type   <v_node>    ParameterArray

// Collections
%type   <v_list>    ArgumentList
%type   <v_list>    ExpressionList
%type   <v_list>    HashPairList
%type   <v_list>    LambdaParameterList
%type   <v_list>    OrderExpressionList
%type   <v_list>    QueryBodyMemberRepeat
%type   <v_list>    GoalOptionRepeat
%type   <v_list>    StatementRepeat
// %type   <v_list>    UsingDirectiveRepeat

%type   <v_list>    VariableDeclaratorList
%type   <v_list>    ConstantDeclaratorList
%type   <v_list>    SwitchBlock
%type   <v_list>    SwitchSectionRepeat
%type   <v_list>    SwitchLabelRepeat
%type   <v_list>    StatementExpressionList
// %type   <v_list>    ModifierRepeat
%type   <v_list>    VariableInitializerList
// %type   <v_list>    StructMemberDeclarationRepeat
%type   <v_list>    CatchClauseRepeat
// %type   <v_list>    EnumMemberDeclarationList
%type   <v_list>    FormalParameterList
%type   <v_list>    HashPairListOpt
%type   <v_list>    LambdaParameterListOpt
// %type   <v_list>    DimSeparators
// %type   <v_list>    DimSeparatorsOpt
%type   <v_list>    FormalParameterListOpt
%type   <v_list>    StatementRepeatOpt
// %type   <v_list>    StructMemberDeclarationRepeatOpt
%type   <v_list>    VariableInitializerListOpt
// %type   <v_list>    EnumBaseOpt
// %type   <v_list>    EnumMemberDeclarationListOpt
%type   <v_list>    ForInitializerOpt
%type   <v_list>    ForInitializer
%type   <v_list>    ForIncrementOpt
%type   <v_list>    ForIncrement

%type   <v_bop>      AssignmentOperator
%type   <v_oop>      OrderOperatorOpt

%%

Goal
    : /* empty */
    {
        driver.enviro->push_back(new VectorNode());
    }
    | GoalOptionRepeat
    {
        driver.enviro->push_back($1);
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
        $$ = $1;
    }
    // | UsingDirectiveRepeat
    // {
    //     $$ = $1;
    // }
    // | Statement
    // {
    //     $$ = $1;
    // }
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
    /*
    {
        $$ = new HashLiteralNode();
    }
    | '{' HashPairList '}'
    {
        $$ = new HashLiteralNode($2);
    }
    | '{' HashPairList ',' '}'
    {
        $$ = new HashLiteralNode($2);
    }
    */
    ;

HashPairListOpt
    : /* empty */ ':'
    {
        $$ = new EmptyVector();
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
        $$ = new PairNode(new IdNode($1), $3);
    }
    | STRING ':' Expression
    {
        $$ = new PairNode(new IdNode($1), $3);
    }
    ;

// ModuleName
//     : QualifiedIdentifier
//     {
//         $$ = $1;
//     }
//     ;

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
    // | PointerType
    // {
    //     $$ = $1;
    // }
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

// PointerType
//     : Type '*'
//     {
//         $$ = new PointerTypeNode($1);
//     }
//     | kVOID '*'
//     {
//         $$ = new PointerTypeNode(new Type("void"));
//     }
//     ;

ArrayType
    : ArrayType RankSpecifier
    {
        $$ = new ArrayTypeNode($1, 1);
    }
    | SimpleType RankSpecifier
    {
        $$ = new ArrayTypeNode($1, 1);
    }
    | QualifiedIdentifier RankSpecifier
    {
        $$ = new ArrayTypeNode($1, 1);
    }
    ;

RankSpecifier
    : '[' ']'
    {
        $$ = new RankSpecifierNode();
    }
    /*
    | '[' DimSeparatorsOpt ']'
    {
        $$ = $2;
    }
    */
    ;

/*
DimSeparatorsOpt
    : /* empty * /
    {
        $$ = new EmptyVector();
    }
    | DimSeparators
    {
        $$ = $1;
    }
    ;

DimSeparators
    : ','
    {
        $$ = new VectorNode();
        $$->push_back(new Empty());
    }
    | DimSeparators ','
    {
        $1->push_back(new Empty());
        $$ = $1;
    }
    ;
*/

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
    // | ArraySlice
    // {
    //     $$ = $1;
    // }
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
    {
        $$ = new NewArrayExpressionNode($2);
        ((NewArrayExpressionNode *)$$)->setDim($4);
    }
    | kNEW NonArrayType '[' ExpressionList ']' ArrayInitializer
    {
        $$ = new NewArrayExpressionNode($2);
        ((NewArrayExpressionNode *)$$)->setDim($4);
        ((NewArrayExpressionNode *)$$)->setInit($6);
    }
    | kNEW ArrayType
    {
        $$ = new NewArrayExpressionNode($2);
    }
    | kNEW ArrayType ArrayInitializer
    {
        $$ = new NewArrayExpressionNode($2);
        ((NewArrayExpressionNode *)$$)->setInit($3);
    }
    ;

// ArrayInitializerOpt
//     : /* empty */
//     | HashLiteral
//     ;

MemberAccess
    : PrimaryExpression '.' IDENTIFIER
    {
        $$ = new AccessExpressionNode(AccessType::MemberAccess, $1, new IdNode($3));
    }
    | PrimitiveType '.' IDENTIFIER
    {
        $$ = new AccessExpressionNode(AccessType::StaticAccess, $1, new IdNode($3));
    }
    | ClassType '.' IDENTIFIER
    {
        $$ = new AccessExpressionNode(AccessType::StaticAccess, $1, new IdNode($3));
    }
    ;

InvocationExpression
    : PrimaryExpressionNoParentesis '(' ArgumentList ')'
    {
        $$ = new CallExpressionNode($1, $3);
    }
    | QualifiedIdentifier '(' ')'
    {
        $$ = new CallExpressionNode($1, NULL);
    }
    | QualifiedIdentifier '(' ArgumentList ')'
    {
        $$ = new CallExpressionNode($1, $3);
    }
    ;

// ArgumentListOpt
//     : /* empty */
//     | ArgumentList
//     ;

// ArraySlice
//     : PrimaryExpression '[' Expression ':' ']'
//     | PrimaryExpression '[' ':' Expression ']'
//     | PrimaryExpression '[' Expression ':' Expression ']'
//     | QualifiedIdentifier '[' Expression ':' ']'
//     | QualifiedIdentifier '[' ':' Expression ']'
//     | QualifiedIdentifier '[' Expression ':' Expression ']'
//     ;

ElementAccess
    : PrimaryExpression '[' ExpressionList ']'
    {
        $$ = new AccessExpressionNode(AccessType::ArrayAccess, $1, $3);
    }
    | QualifiedIdentifier '[' ExpressionList ']'
    {
        $$ = new AccessExpressionNode(AccessType::ArrayAccess, $1, $3);
    }
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
        $$ = new NewExpressionNode($2);
    }
    | kNEW Type '(' ArgumentList ')'
    {
        $$ = new NewExpressionNode($2, $4);
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

// PointerMemberAccess
//     : PostfixExpression oIND IDENTIFIER
//     ;

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
    // | PointerMemberAccess
    // {
    //     $$ = $1;
    // }
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
    // | CastExpression
    // {
    //     $$ = $1;
    // }
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

// CastExpression
//     : /* '(' Type ')' UnaryExpressionNotPlusMinus
//     | */ '(' Expression ')' UnaryExpressionNotPlusMinus
//     | '(' MultiplicativeExpression '*' ')' UnaryExpressionNotPlusMinus
//     | '(' QualifiedIdentifier RankSpecifier ')' UnaryExpressionNotPlusMinus
//     | '(' QualifiedIdentifier RankSpecifier TypeQuals ')' UnaryExpressionNotPlusMinus
//     | '(' PrimitiveType ')' UnaryExpressionNotPlusMinus
//     | '(' PrimitiveType TypeQuals ')' UnaryExpressionNotPlusMinus
//     | '(' ClassType ')' UnaryExpressionNotPlusMinus
//     | '(' ClassType TypeQuals ')' UnaryExpressionNotPlusMinus
//     | '(' kVOID ')' UnaryExpressionNotPlusMinus //*/
//     | '(' kVOID TypeQuals ')' UnaryExpressionNotPlusMinus //*/
//     ;

// TypeQualsOpt
//     : /* empty */
//     | TypeQuals
//     ;

// TypeQuals
//     : TypeQual
//     | TypeQuals TypeQual
//     ;

// TypeQual
//     : RankSpecifier
//     | '*'
//     ;

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
        $$ = new GroupByNode(new IdNode($2), $4);
    }
    | kGROUP IDENTIFIER kBY Expression kINTO IDENTIFIER
    {
        auto group = new GroupByNode(new IdNode($2), $4);
        group->set_id(new IdNode($6));
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
        $$ = new LetNode(new IdNode($2), $4);
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
        join->set_new_id(new IdNode($6));
        $$ = join;
    }
    | kLEFT kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    {
        auto join = new JoinNode(JoinType::Left, $3, $5);
        join->set_new_id(new IdNode($7));
        $$ = join;
    }
    | kRIGHT kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    {
        auto join = new JoinNode(JoinType::Right, $3, $5);
        join->set_new_id(new IdNode($7));
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
        $$ = new QueryOriginNode(new IdNode($1), $3);
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
        $$ = new ParameterNode($1, new IdNode($2));
    }
    | IDENTIFIER
    {
        // $$ = new LambdaParameter($1, new Type("var"));
        $$ = new ParameterNode(new Type("var"), new IdNode($1));
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
        $$ = new EmptyVector();
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
    {
        $$ = $1;
    }
    ;

LambdaExpression
    : IDENTIFIER oFAR LambdaExpressionBody
    {
        auto _id = new IdNode($1);
        auto _params = new VectorNode();
        _params->push_back(_id);
        $$ = new LambdaNode(_params, $3);
    }
    // | '(' ')' oFAR LambdaExpressionBody
    // {
    //     $$ = new LambdaNode(new VectorNode(), $4);
    // }
    | '(' LambdaParameterListOpt ')' oFAR LambdaExpressionBody
    {
        $$ = new LambdaNode($2, $5);
    }
    ;

TimedExpression
    : kASYNC Expression
    {
        $$ = new AsyncStatementNode($2);
    }
    | kAWAIT Expression
    {
        $$ = new AwaitStatementNode($2);
    }
    ;

Expression
    : ConditionalExpression
    {
        $$ = $1;
    }
    | AssignmentExpression
    {
        $$ = $1;
    }
    | QueryExpression
    {
        $$ = $1;
    }
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
    {
        $$ = $1;
    }
    ;

BooleanExpression
    : Expression
    {
        $$ = $1;
    }
    ;

Statement
    : DeclarationStatement
    {
        $$ = $1;
    }
    | NormalStatement
    {
        $$ = $1;
    }
    ;

NormalStatement
    : Block
    {
        $$ = $1;
    }
    | EmptyStatement
    {
        $$ = $1;
    }
    | ExpressionStatement
    {
        $$ = $1;
    }
    | SelectionStatement
    {
        $$ = $1;
    }
    | IterationStatement
    {
        $$ = $1;
    }
    | JumpStatement
    {
        $$ = $1;
    }
    | TryStatement
    {
        $$ = $1;
    }
    // | LockStatement
    // {
    //     $$ = $1;
    // }
    // | UsingStatement
    // {
    //     $$ = $1;
    // }
    ;

Block
    : '{' StatementRepeatOpt '}'
    {
        $$ = new BlockNode($2);
    }
    ;

StatementRepeatOpt
    : /* empty */
    {
        $$ = new EmptyVector();
    }
    | StatementRepeat
    {
        $$ = $1;
    }
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
    {
        $$ = new Empty();
    }
    ;

DeclarationStatement
    : LocalVariableDeclaration ';'
    {
        $$ = $1;
    }
    | LocalConstantDeclaration ';'
    {
        $$ = $1;
    }
    ;

LocalVariableDeclaration
    : Type VariableDeclaratorList
    {
        $$ = new VariableDeclStatementNode($1, $2);
    }
    ;

VariableDeclaratorList
    : VariableDeclarator
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | VariableDeclaratorList ',' VariableDeclarator
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

VariableDeclarator
    : IDENTIFIER
    {
        $$ = new ElementNode(ElementType::Var, new IdNode($1));
    }
    | IDENTIFIER '=' VariableInitializer
    {
        $$ = new ElementNode(ElementType::Var, new IdNode($1), $3);
    }
    ;

VariableInitializer
    : Expression
    {
        $$ = $1;
    }
    | ArrayInitializer
    {
        $$ = $1;
    }
    ;

LocalConstantDeclaration
    : kCONST Type ConstantDeclaratorList
    {
        $$ = new ConstantDeclStatementNode($2, $3);
    }
    ;

ConstantDeclaratorList
    : ConstantDeclarator
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | ConstantDeclaratorList ',' ConstantDeclarator
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

ConstantDeclarator
    : IDENTIFIER '=' ConstantExpression
    {
        $$ = new ElementNode(ElementType::Const, new IdNode($1), $3);
    }
    ;

ExpressionStatement
    : StatementExpression ';'
    {
        $$ = $1;
    }
    ;

StatementExpression
    : InvocationExpression
    {
        $$ = $1;
    }
    | ObjectCreationExpression
    {
        $$ = $1;
    }
    | AssignmentExpression
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
    | PreIncrementExpression
    {
        $$ = $1;
    }
    | PreDecrementExpression
    {
        $$ = $1;
    }
    // | Expression
    ;

SelectionStatement
    : IfStatement
    {
        $$ = $1;
    }
    | UnlessStatement
    {
        $$ = $1;
    }
    | SwitchStatement
    {
        $$ = $1;
    }
    ;

IfStatement
    : kIF '(' Expression ')' NormalStatement
    {
        $$ = new IfNode($3, $5);
    }
    | kIF '(' Expression ')' NormalStatement kELSE NormalStatement
    {
        $$ = new IfNode($3, $5, $7);
    }
    ;

UnlessStatement
    : kUNLESS '(' Expression ')' NormalStatement
    {
        $$ = new UnlessNode($3, $5);
    }
    | kUNLESS '(' Expression ')' NormalStatement kELSE NormalStatement
    {
        $$ = new UnlessNode($3, $5, $7);
    }
    ;

SwitchStatement
    : kSWITCH '(' Expression ')' SwitchBlock
    {
        $$ = new SwitchNode($3, $5);
    }
    ;

SwitchBlock
    : '{' SwitchSectionRepeat '}'
    {
        $$ = $2;
    }
    ;

// SwitchSectionRepeatOpt
//     : /* empty */
//     | SwitchSectionRepeat
//     ;

SwitchSectionRepeat
    : SwitchSection
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | SwitchSectionRepeat SwitchSection
    {
        $1->push_back($2);
        $$ = $1;
    }
    ;

SwitchSection
    : SwitchLabelRepeat StatementRepeat
    {
        $$ = new SwitchSectionNode($1, $2);
    }
    ;

SwitchLabelRepeat
    : SwitchLabel
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | SwitchLabelRepeat SwitchLabel
    {
        $1->push_back($2);
        $$ = $1;
    }
    ;

SwitchLabel
    : kCASE Expression ':'
    {
        $$ = new SwitchLabelNode($2);
    }
    | kDEFAULT ':'
    {
        $$ = new SwitchLabelNode();
    }
    ;

IterationStatement
    : WhileStatement
    {
        $$ = $1;
    }
    | DoStatement
    {
        $$ = $1;
    }
    | ForStatement
    {
        $$ = $1;
    }
    | ForeachStatement
    {
        $$ = $1;
    }
    ;

WhileStatement
    : kWHILE '(' BooleanExpression ')' NormalStatement
    {
        $$ = new WhileNode($3, $5);
    }
    ;

DoStatement
    : kDO NormalStatement kWHILE '(' BooleanExpression ')' ';'
    {
        $$ = new DoWhileNode($2, $5);
    }
    ;

ForStatement
    : kFOR '(' ForInitializerOpt ';' ForConditionOpt ';' ForIncrementOpt ')' NormalStatement
    {
        $$ = new ForNode($3, $5, $7, $9);
    }
    ;

ForInitializerOpt
    : /* empty */
    {
        $$ = new EmptyVector();
    }
    | ForInitializer
    {
        $$ = $1;
    }
    ;

ForConditionOpt
    : /* empty */
    {
        $$ = new Empty();
    }
    | ForCondition
    {
        $$ = $1;
    }
    ;

ForIncrementOpt
    : /* empty */
    {
        $$ = new EmptyVector();
    }
    | ForIncrement
    {
        $$ = $1;
    }
    ;

ForInitializer
    : LocalVariableDeclaration
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | StatementExpressionList
    {
        $$ = $1;
    }
    ;

ForCondition
    : BooleanExpression
    {
        $$ = $1;
    }
    ;

ForIncrement
    : StatementExpressionList
    {
        $$ = $1;
    }
    ;

StatementExpressionList
    : StatementExpression
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | StatementExpressionList ',' StatementExpression
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

ForeachStatement
    : kFOREACH '(' Type IDENTIFIER kIN Expression ')' NormalStatement
    {
        $$ = new ForeachNode($3, new IdNode($4), $6, $8);
    }
    ;

JumpStatement
    : BreakStatement
    {
        $$ = $1;
    }
    | ContinueStatement
    {
        $$ = $1;
    }
    | ReturnStatement
    {
        $$ = $1;
    }
    | YieldStatement
    {
        $$ = $1;
    }
    | ThrowStatement
    {
        $$ = $1;
    }
    ;

BreakStatement
    : kBREAK ';'
    {
        $$ = new ControlExpressionNode(ControlType::Break);
    }
    ;

ContinueStatement
    : kCONTINUE ';'
    {
        $$ = new ControlExpressionNode(ControlType::Continue);
    }
    ;

ReturnStatement
    : kRETURN ';'
    {
        $$ = new ControlExpressionNode(ControlType::Return);
    }
    | kRETURN Expression ';'
    {
        $$ = new ControlExpressionNode(ControlType::Return, $2);
    }
    ;

YieldStatement
    : kYIELD /* kBREAK */ ';'
    {
        $$ = new ControlExpressionNode(ControlType::Yield);
    }
    | kYIELD /* kRETURN */ Expression ';'
    {
        $$ = new ControlExpressionNode(ControlType::Yield, $2);
    }
    ;

// ExpressionOpt
//     : /* empty */
//     | Expression
//     ;

ThrowStatement
    : kTHROW ';'
    {
        $$ = new ControlExpressionNode(ControlType::Throw);
    }
    | kTHROW Expression ';'
    {
        $$ = new ControlExpressionNode(ControlType::Throw, $2);
    }
    ;

TryStatement
    : kTRY Block CatchClauseRepeat
    {
        $$ = new TryStatementNode($2);
        ((TryStatementNode *)$$)->setCatch($3);
    }
    | kTRY Block FinallyClause
    {
        $$ = new TryStatementNode($2);
        ((TryStatementNode *)$$)->setFinally($2);
    }
    | kTRY Block CatchClauseRepeat FinallyClause
    {
        $$ = new TryStatementNode($2);
        ((TryStatementNode *)$$)->setCatch($3);
        ((TryStatementNode *)$$)->setFinally($4);
    }
    ;

CatchClauseRepeat
    : CatchClause
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | CatchClauseRepeat CatchClause
    {
        $1->push_back($2);
        $$ = $1;
    }
    ;

CatchClause
    : /* kCATCH '(' ClassType ')' Block
    | kCATCH '(' ClassType IDENTIFIER ')' Block
    | kCATCH '(' TypeName ')' Block
    | kCATCH '(' TypeName IDENTIFIER ')' Block */
      kCATCH '(' Type ')' Block
    {
        $$ = new CatchStatementNode($3, $5);
    }
    | kCATCH '(' Type IDENTIFIER ')' Block
    {
        $$ = new CatchStatementNode($3, new IdNode($4), $6);
    }
    | kCATCH Block
    {
        $$ = new CatchStatementNode($2);
    }
    ;

// IdentifierOpt
//     : /* empty */
//     | IDENTIFIER
//     ;

FinallyClause
    : kFINALLY Block
    {
        $$ = $2;
    }
    ;

// LockStatement
//     : kLOCK '(' Expression ')' NormalStatement
//     ;

// UsingStatement
//     : kUSING '(' ResourceAquisition ')' NormalStatement
//     ;

// ResourceAquisition
//     : LocalVariableDeclaration
//     | Expression
//     ;

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
    {
        $$ = new IdNode($1);
    }
    | Qualifier IDENTIFIER
    {
        ((IdNode *)$1)->AddId($2);
        $$ = $1;
    }
    ;

Qualifier
    : IDENTIFIER '.'
    {
        $$ = new IdNode($1);
    }
    | Qualifier IDENTIFIER '.'
    {
        ((IdNode *)$1)->AddId($2);
        $$ = $1;
    }
    ;

// NamespaceBody
//     : '{' UsingDirectiveRepeatOpt NamespaceMemberDeclarationRepeatOpt '}'
//     ;

// UsingDirectiveRepeatOpt
//     : /* empty */
//     | UsingDirectiveRepeat
//     ;

// UsingDirectiveRepeat
//     : UsingDirective
//     | UsingDirectiveRepeat UsingDirective
//     ;

// UsingDirective
//     : UsingAliasDirective
//     | UsingNamespaceDirective
//     ;

// UsingAliasDirective
//     : kUSING IDENTIFIER '=' QualifiedIdentifier ';'
//     ;

// UsingNamespaceDirective
//     : kUSING ModuleName ';'
//     ;

// NamespaceMemberDeclarationRepeat
//     : NamespaceDeclaration
//     | TypeDeclaration
//     ;

TypeDeclaration
    : MethodDeclaration
    {
        $$ = $1;
    }
    // | StructDeclaration
    // | EnumDeclaration
    // | DelegateDeclaration
    // | InterfaceDeclaration
    // | ClassDeclaration
    ;

// ModifierRepeatOpt
//     : /* empty * /
//     | ModifierRepeat
//     ;

// ModifierRepeat
//     : Modifier
//     {
//         $$ = new VectorNode();
//         $$->push_back($1);
//     }
//     | ModifierRepeat Modifier
//     {
//         $1->push_back($2);
//         $$ = $1;
//     }
//     ;

// Modifier
//     : kEXTERN
//     | kSTATIC
//     | kASYNC
//     // | kABSTRACT
//     // | kINTERNAL
//     // | kNEW
//     // | kOVERRIDE
//     // | kPRIVATE
//     // | kPROTECTED
//     // | kPUBLIC
//     // | kREADONLY
//     // | kSEALED
//     // | kUNSAFE
//     // | kVIRTUAL
//     // | kVOLATILE
//     ;

// StructDeclaration
//     : /* AttributesOpt */ kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody
//     | /* AttributesOpt */ kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody ';'
//     | /* AttributesOpt */ ModifierRepeat kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody
//     | /* AttributesOpt */ ModifierRepeat kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody ';'
//     ;

// StructInterfacesOpt
//     : /* empty */
//     | StructInterfaces
//     ;

// StructInterfaces
//     : ':' InterfaceTypeList
//     ;

// StructBody
//     : '{' StructMemberDeclarationRepeatOpt '}'
//     ;

// StructMemberDeclarationRepeatOpt
//     : /* empty */
//     {
//         $$ = new Empty();
//     }
//     | StructMemberDeclarationRepeat
//     {
//         $$ = $1;
//     }
//     ;

// StructMemberDeclarationRepeat
//     : StructMemberDeclaration
//     {
//         $$ = new VectorNode();
//         $$->push_back($1);
//     }
//     | StructMemberDeclarationRepeat StructMemberDeclaration
//     {
//         $1->push_back($2);
//         $$ = $1;
//     }
//     ;

// StructMemberDeclaration
//     : ConstantDeclaration
//     // | FieldDeclaration
//     // | MethodDeclaration
//     // | PropertyDeclaration
//     // | EventDeclaration
//     // | IndexerDeclaration
//     // | OperatorDeclaration
//     // | ConstructorDeclaration
//     | TypeDeclaration
//     ;

// ConstantDeclaration
//     : /* AttributesOpt */ kCONST Type ConstantDeclaratorList ';'
//     {
//         $$ = new ConstantNode($2, $3);
//     }
//     // | /* AttributesOpt */ ModifierRepeat kCONST Type ConstantDeclaratorList ';'
//     ;

ArrayInitializer
    : '{' VariableInitializerListOpt '}'
    {
        $$ = $2;
    }
    | '{' VariableInitializerListOpt ',' '}'
    {
        $$ = $2;
    }
    ;

VariableInitializerListOpt
    : /* empty */
    {
        $$ = new EmptyVector();
    }
    | VariableInitializerList
    {
        $$ = $1;
    }
    ;

VariableInitializerList
    : VariableInitializer
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | VariableInitializerList ',' VariableInitializer
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

// EnumDeclaration
//     : /* AttributesOpt */ kENUM IDENTIFIER EnumBaseOpt EnumBody
//     // | /* AttributesOpt */ ModifierRepeat kENUM IDENTIFIER EnumBaseOpt EnumBody
//     | /* AttributesOpt */ kENUM IDENTIFIER EnumBaseOpt EnumBody ';'
//     // | /* AttributesOpt */ ModifierRepeat kENUM IDENTIFIER EnumBaseOpt EnumBody ';'
//     ;

// EnumBaseOpt
//     : /* empty */
//     {
//         $$ = new Empty();
//     }
//     | EnumBase
//     {
//         $$ = $1;
//     }
//     ;

// EnumBase
//     : ':' IntegralType /* Type */
//     {
//         $$ = $2;
//     }
//     ;

// EnumBody
//     : '{' EnumMemberDeclarationListOpt '}'
//     {
//         $$ = $2;
//     }
//     | '{' EnumMemberDeclarationListOpt ',' '}'
//     {
//         $$ = $2;
//     }
//     ;

// EnumMemberDeclarationListOpt
//     : /* empty */
//     {
//         $$ = new Empty();
//     }
//     | EnumMemberDeclarationList
//     {
//         $$ = $1;
//     }
//     ;

// EnumMemberDeclarationList
//     : EnumMemberDeclaration
//     {
//         $$ = new VectorNode();
//         $$->push_back($1);
//     }
//     | EnumMemberDeclarationList ',' EnumMemberDeclaration
//     {
//         $1->push_back($3);
//         $$ = $1;
//     }
//     ;

// EnumMemberDeclaration
//     : /* AttributesOpt */ IDENTIFIER
//     | /* AttributesOpt */ IDENTIFIER '=' ConstantExpression
//     ;

MethodDeclaration
    : MethodHeader MethodBody
    {
        ((FunctionNode *)$1)->setBlock($2);
        $$ = $1;
    }
    ;

MethodHeader
    : /* AttributesOpt */ kVOID QualifiedIdentifier '(' FormalParameterListOpt ')'
    {
        $$ = new FunctionNode($2, $4);
        ((FunctionNode *)$$)->setFunctionReturn(new Type("void"));
    }
    // | /* AttributesOpt */ ModifierRepeat kVOID QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ Type QualifiedIdentifier '(' FormalParameterListOpt ')'
    {
        $$ = new FunctionNode($2, $4);
        ((FunctionNode *)$$)->setFunctionReturn($1);
    }
    // | /* AttributesOpt */ ModifierRepeat Type QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ /* Type == int */ QualifiedIdentifier '(' FormalParameterListOpt ')'
    {
        $$ = new FunctionNode($1, $3);
        ((FunctionNode *)$$)->setFunctionReturn(new Type("int"));
    }
    // | /* AttributesOpt */ ModifierRepeat /* Type == int */ QualifiedIdentifier '(' FormalParameterListOpt ')'
    ;

FormalParameterListOpt
    : /* empty */
    {
        $$ = new EmptyVector();
    }
    | FormalParameterList
    {
        $$ = $1;
    }
    ;

MethodBody
    : Block
    {
        $$ = $1;
    }
    | ';'
    {
        $$ = new BlockNode(new VectorNode());
    }
    ;

FormalParameterList
    : FormalParameter
    {
        $$ = new VectorNode();
        $$->push_back($1);
    }
    | FormalParameterList ',' FormalParameter
    {
        $1->push_back($3);
        $$ = $1;
    }
    ;

FormalParameter
    : FixedParameter
    {
        $$ = $1;
    }
    | ParameterArray
    {
        $$ = $1;
    }
    ;

FixedParameter
    : /* AttributesOpt /* ParameterModifierOpt */ Type IDENTIFIER ParameterInitializerOpt
    {
        $$ = new ParameterNode($1, new IdNode($2), $3);
    }
    ;

ParameterInitializerOpt
    : /* empty */
    {
        $$ = new Empty();
    }
    | '=' ConstantExpression
    {
        $$ = $2;
    }
    ;

ParameterArray
    : /* AttributesOpt */ kPARAMS ArrayType IDENTIFIER
    {
        $$ = new ParameterNode($2, new IdNode($3));
        ((ParameterNode *)$$)->setParamArray();
    }
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
