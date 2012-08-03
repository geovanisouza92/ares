/* Ares Programming Language */

%{

#include <string>
#include <vector>

using namespace std;

#include "driver.h"
#include "st.h"
#include "stoql.h"
#include "stmt.h"

using namespace SyntaxTree;

%}

%require "2.3"
%start Goal
%skeleton "lalr1.cc"
%define namespace "Ares::Compiler"
%define "parser_class_name" "Parser"
%parse-param { class Driver& driver }
%lex-param { class Driver& driver }
%locations
%error-verbose
%initial-action {
    @$.begin.filename = @$.end.filename = &driver.origin;
    driver.incLines ();
}

%union {
    int                             v_int;
    double                          v_flt;
    string *                        v_str;
    SyntaxTree::SyntaxNode *        v_node;
    SyntaxTree::VectorNode *        v_list;
}

%{
#include "scanner.h"

#undef yylex
#define yylex driver.lexer->lex
%}

%token          sEOF    0   "end of file"

%token  <v_str> ID         "identifier literal"
%token  <v_flt> FLOAT      "float literal"
%token  <v_int> INTEGER    "integer literal"
%token  <v_str> CHAR       "char literal"
%token  <v_str> STRING     "string literal"
%token  <v_str> REGEX      "regex literal"

%nonassoc ID FLOAT INTEGER CHAR STRING REGEX

//%token  kARRAY      "array"
%token  kASC        "asc"
%token  kBOOL       "bool"
%token  kBREAK      "break"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCHAR       "char"
%token  kCONST      "const"
%token  kCONTINUE   "continue"
%token  kDEFAULT    "default"
%token  kDESC       "desc"
%token  kDOUBLE     "double"
%token  kDO         "do"
%token  kELSE       "else"
%token  kFALSE      "false"
%token  kFLOAT      "float"
%token  kFOREACH    "foreach"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kGROUP      "group"
%token  kHAS        "has"
%token  kIF         "if"
%token  kINT        "int"
%token  kIN         "in"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kNEW        "new"
%token  kNULL       "null"
%token  kON         "on"
%token  kORDER      "order"
%token  kREGEX      "regex"
%token  kRETURN     "return"
%token  kRIGHT      "right"
%token  kSELECT     "select"
%token  kSKIP       "skip"
%token  kSTEP       "step"
%token  kSTRING     "string"
%token  kSWITCH     "switch"
%token  kTAKE       "take"
%token  kTRUE       "true"
%token  kUNLESS     "unless"
%token  kVAR        "var"
%token  kWHERE      "where"
%token  kWHILE      "while"
%token  kYIELD      "yield"

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
%token  oADE        "+="
%token  oSUE        "-="
%token  oMUE        "*="
%token  oDIE        "/="
%token  oRAI        "..."
%token  oRAE        ".."
%token  oPOW        "**"
%token  oIDE        "==="
%token  oNID        "!=="
%token  oEQL        "=="
%token  oNEQ        "!="
%token  oLEE        "<="
%token  oGEE        ">="
%token  oMAT        "=~"
%token  oNMA        "!~"
%token  oIMP        "->"
%token  oFAR        "=>"
%token  oBET        "?="
%token  oCOA        "??"
%token  oAND        "&&"
%token  oOR         "||"
%token  oINC        "++"
%token  oDEC        "--"

%left ';' '{' '}' ',' '(' ')' ':' '=' '.' '?' '^' '<' '>' '+' '-' '*' '/'
%left '%' '!' '[' ']' '&' '|'
%left oADE oSUE oMUE oDIE oRAI oRAE oPOW oIDE oNID oEQL oNEQ oLEE oGEE
%left oMAT oNMA oIMP oFAR oBET oCOA oAND oOR oINC oDEC

%right UNARY

%%

Goal
    : /* empty */
    | StatementRepeat
    ;

StatementRepeat
    : Statement
    | StatementRepeat Statement
    ;

Statement
    : EmptyStatement
    | BlockStatement
    | ExpressionStatement
    | SelectionStatement
    | IterationStatement
    | JumpStatement
    // | AtimeStatement
    | VariableStatement ';'
    | ConstantStatement ';'
    | FunctionStatement
    ;

FunctionStatement
    : TypeName Identifier '(' ')' BlockStatement
    | TypeName Identifier '(' VariableList ')' BlockStatement
    ;

EmptyStatement
    : ';'
    ;

BlockStatement
    : '{' '}'
    | '{' StatementRepeat '}'
    ;

ControlExpression
    : kIF Expression
    | kUNLESS Expression
    ;

InvocationStatement
    : SuffixExpression '(' ')'
    | SuffixExpression '(' ExpressionList ')'
    | SuffixExpression TypeArgumentList '(' ')'
    | SuffixExpression TypeArgumentList '(' ExpressionList ')'
    ;

SelectionStatement
    : IfStatement
    | UnlessStatement
    | SwitchStatement
    ;

IfStatement
    : kIF '(' Expression ')' Statement
    | kIF '(' Expression ')' Statement kELSE Statement
    ;

UnlessStatement
    : kUNLESS '(' Expression ')' Statement
    | kUNLESS '(' Expression ')' Statement kELSE Statement
    ;

SwitchStatement
    : kSWITCH '(' Expression ')' '{' SwitchSectionRepeat '}'
    ;

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
    | DoWhileStatement
    | ForStatement
    | ForeachStatement
    ;

WhileStatement
    : kWHILE '(' Expression ')' Statement
    ;

DoWhileStatement
    : kDO StatementRepeat kWHILE '(' Expression ')'
    ;

ForStatement
    : kFOR '(' ';' ';' ')' Statement
    | kFOR '(' ';' ';' ForIncrement ')' Statement
    | kFOR '(' ';' ForCondition ';' ')' Statement
    | kFOR '(' ';' ForCondition ';' ForIncrement ')' Statement
    | kFOR '(' ForInitialization ';' ';' ')' Statement
    | kFOR '(' ForInitialization ';' ';' ForIncrement ')' Statement
    | kFOR '(' ForInitialization ';' ForCondition ';' ')' Statement
    | kFOR '(' ForInitialization ';' ForCondition ';' ForIncrement ')' Statement
    ;

ForInitialization
    : VariableStatement
    | ExpressionList
    ;

ForCondition
    : BooleanExpression
    ;

ForIncrement
    : ExpressionList
    ;

ForeachStatement
    : kFOREACH '(' ForInitialization kIN Expression ')' Statement
    ;

JumpStatement
    : BreakStatement
    | ContinueStatement
    | ReturnStatement
    | YieldStatement
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
    : kYIELD ';'
    | kYIELD Expression ';'
    ;

VariableStatement
    : TypeName VariableList
    ;

TypeName
    : kVAR
    | kBOOL
    | kINT
    | kFLOAT
    | kDOUBLE
    | kCHAR
    | kSTRING
    | kREGEX
    // | kARRAY
    // | kHASH
    | SuffixExpression
    | SuffixExpression '<' TypeArgumentList '>'
    ;

TypeArgumentList
    : TypeArgument
    | TypeArgumentList ',' TypeArgument
    ;

TypeArgument
    : Identifier
    ;

VariableList
    : Variable
    | VariableList ',' Variable
    ;

Variable
    : Identifier
    | Identifier AssignmentTail
    ;

ConstantStatement
    : kCONST TypeName ConstantList;
    ;

ConstantList
    : Constant
    | ConstantList ',' Constant
    ;

Constant
    : Identifier '=' AssignmentTail
    ;

ExpressionStatement
    : PrimaryExpression ';'
    | PrimaryExpression ControlExpression ';'
    ;

PrimaryExpression
    : AssignmentExpression
    | InvocationStatement
    ;

Expression
    : AssignmentExpression
    | TernaryExpression
    | LambdaExpression
    | QueryExpression
    ;

ExpressionList
    : Expression
    | ExpressionList ',' Expression
    ;

LambdaExpression
    : '(' VariableList ')' oFAR Expression
    | '(' VariableList ')' oFAR BlockStatement
    ;

AssignmentExpression
    : PrefixExpression AssignmentTail
    ;

AssignmentTail
    : '=' Expression
    | oADE Expression
    | oSUE Expression
    | oMUE Expression
    | oDIE Expression
    ;

QueryExpression
    : kFROM QueryOrigin
    | kFROM QueryOrigin QueryBody
    ;

QueryOrigin
    : Identifier kIN Expression
    ;

QueryBody
    : QueryBodyMemberRepeat SelectOrGroupClause
    | QueryBodyMemberRepeat
    | SelectOrGroupClause
    ;

QueryBodyMemberRepeat
    : QueryBodyMember 
    | QueryBodyMemberRepeat QueryBodyMember
    ;

QueryBodyMember
    : kWHERE BooleanExpression
    | JoinClause
    | kORDER kBY OrderExpression
    | RangeClause
    ;

JoinClause
    : kJOIN QueryOrigin kON BooleanExpression
    | kLEFT kJOIN QueryOrigin kON BooleanExpression
    | kRIGHT kJOIN QueryOrigin kON BooleanExpression
    ;

OrderExpression
    : Expression
    | Expression kASC
    | Expression kDESC
    ;

RangeClause
    : kSKIP Expression
    | kSTEP Expression
    | kTAKE Expression
    ;

SelectOrGroupClause
    : kGROUP kBY Expression
    | kSELECT ExpressionList
    ;

TernaryExpression
    : BooleanExpression
    | BooleanExpression '?' Expression ':' Expression
    | BooleanExpression oBET ComparisonExpression oAND ComparisonExpression
    ;

BooleanExpression
    : LogicOrExpression
    | LogicOrExpression oCOA LogicOrExpression
    | LogicOrExpression oIMP LogicOrExpression
    ;

LogicOrExpression
    : LogicAndExpression
    | LogicAndExpression oOR LogicAndExpression
    ;

LogicAndExpression
    : BitwiseOrExpression
    | BitwiseOrExpression oAND BitwiseOrExpression
    ;

BitwiseOrExpression
    : BitwiseXorExpression
    | BitwiseXorExpression '|' BitwiseXorExpression
    ;

BitwiseXorExpression
    : BitwiseAndExpression
    | BitwiseAndExpression '^' BitwiseAndExpression
    ;

BitwiseAndExpression
    : ComparisonExpression
    | ComparisonExpression '&' ComparisonExpression
    ;

ComparisonExpression
    : RangeExpression
    | RangeExpression '<' RangeExpression
    | RangeExpression oLEE RangeExpression
    | RangeExpression '>' RangeExpression
    | RangeExpression oGEE RangeExpression
    | RangeExpression oEQL RangeExpression
    | RangeExpression oNEQ RangeExpression
    | RangeExpression oIDE RangeExpression
    | RangeExpression oNID RangeExpression
    | RangeExpression oMAT RangeExpression
    | RangeExpression oNMA RangeExpression
    | RangeExpression kHAS RangeExpression
    | RangeExpression kIN RangeExpression
    ;

RangeExpression
    : AdditionExpression
    | AdditionExpression oRAE AdditionExpression
    | AdditionExpression oRAI AdditionExpression
    ;

AdditionExpression
    : MultiplicationExpression
    | AdditionExpression '+' MultiplicationExpression
    | AdditionExpression '-' MultiplicationExpression
    ;

MultiplicationExpression
    : PowerExpression
    | MultiplicationExpression '*' PowerExpression
    | MultiplicationExpression '/' PowerExpression
    | MultiplicationExpression '%' PowerExpression
    ;

PowerExpression
    : PostfixExpression
    | PowerExpression oPOW PostfixExpression
    ;

PostfixExpression
    : PrefixExpression
    | PostfixExpression oINC
    | PostfixExpression oDEC
    ;

PrefixExpression
    : ObjectSlice
    | '!' PrefixExpression %prec UNARY
    | '+' PrefixExpression %prec UNARY
    | '-' PrefixExpression %prec UNARY
    | oINC PrefixExpression %prec UNARY
    | oDEC PrefixExpression %prec UNARY
    | '(' TypeName ')' PrefixExpression %prec UNARY
    | NewExpression
    ;

NewExpression
    : kNEW TypeName '(' ')'
    | kNEW TypeName '(' ')' InitializerList
    | kNEW TypeName '(' ExpressionList ')'
    | kNEW TypeName '(' ExpressionList ')' InitializerList
    ;

InitializerList
    : '{' '}'
    | '{' MemberInitializerList '}'
    ;

MemberInitializerList
    : Identifier '=' Expression
    ;

ObjectSlice
    : SuffixExpression '[' Expression ':' ']'
    | SuffixExpression '[' ':' Expression ']'
    | SuffixExpression '[' Expression ':' Expression ']'
    ;

SuffixExpression
    : LiteralValue
    | SuffixExpression '.' Identifier
    | SuffixExpression '[' ExpressionList ']'
    ;

LiteralValue
    : kNULL
    | ArrayLiteral
    | HashLiteral
    | BooleanLiteral
    | CharLiteral
    | StringLiteral
    | RegexLiteral
    | FloatLiteral
    | IntegerLiteral
    // | Identifier
    | InvocationStatement
    | '(' Expression ')'
    ;

HashLiteral
    : '{' ',' '}' /* Remover essa vírgula */
    | '{' KeyValuePairList '}'
    ;

KeyValuePairList
    : KeyValuePair
    | KeyValuePairList ',' KeyValuePair
    ;

KeyValuePair
    : Identifier ':' Expression
    | StringLiteral ':' Expression
    ;

ArrayLiteral
    : '[' ']'
    | '[' ExpressionList ']'
    ;

BooleanLiteral
    : kFALSE
    | kTRUE
    ;

CharLiteral
    : CHAR
    ;

StringLiteral
    : STRING
    | StringLiteral STRING
    ;

RegexLiteral
    : REGEX
    ;

FloatLiteral
    : FLOAT
    ;

IntegerLiteral
    : INTEGER
    ;

Identifier
    : ID
    ;

%%

namespace LANG_NAMESPACE
{
    namespace Compiler
    {
        void
        Parser::error (const Parser::location_type& l, const std::string& m)
        {
            driver.error (l, m);
        }
    } // Compiler
} // LANG_NAMESPACE
