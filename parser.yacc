
%{
#include <vector>

using namespace std;

#include "ast.h"
#include "driver.h"

using namespace AST;
%}

%debug

%require "2.3"
%start Program
%skeleton "lalr1.cc"
%define namespace "Ares"
%define "parser_class_name" "Parser"
%parse-param { class Driver& driver }
%lex-param { class Driver& driver }
%locations
%error-verbose
%initial-action {
    @$.begin.filename = @$.end.filename = &driver.origin;
    driver.inc_lines(1);
}

%union {
    int                         v_int;
    double                      v_flt;
    string *                    v_str;
    class AST::SyntaxNode *     v_node;
    class AST::VectorNode *     v_list;
}

%{
#include "scanner.h"

#undef yylex
#define yylex driver.lexer->lex
%}

%token          sEOF    0   "end of file"

%token  <v_str> ID         "identifier"
%token  <v_flt> FLOAT      "float"
%token  <v_int> INTEGER    "integer"
%token  <v_str> STRING     "string"
%token  <v_str> REGEX      "regex"

%token  FALSE   "false"
%token  TRUE    "true"

%token  '?'     "?"
%token  ':'     ":"
%token  DOT2    ".."
%token  DOT3    "..."
%token  IMPLIES "=>"
%token  OR      "||"
%token  AND     "&&"
%token  '^'     "^"
%token  EQL     "=="
%token  NEQ     "!="
%token  MAT     "=~"
%token  NMA     "!~"
%token  IS      "is"
%token  NIS     "!is"
%token  '<'     "<"
%token  LEE     "<="
%token  '>'     ">"
%token  GEE     ">="
%token  SHL     "<<"
%token  SHR     ">>"
%token  '+'     "+"
%token  '-'     "-"
%token  '*'     "*"
%token  '/'     "/"
%token  '%'     "%"
%token  '!'     "!"
%token  UNARY
%token  POW     "**"

%token  '('     "("
%token  ')'     ")"
%token  '['     "["
%token  ']'     "]"
%token  '{'     "{"
%token  '}'     "}"
%token  ','     ","
%token  ';'     ";"
%token  '.'     "."

%left   '?' ':'
%left   DOT2 DOT3
%left   '^' OR AND IMPLIES
%left   EQL NEQ MAT NMA IS NIS
%left   '>' '<' LEE GEE
%left   SHL SHR
%left   '+' '-'
%left   '*' '/' '%'
%right  UNARY
%left   POW

%type   <v_node>    Identifier
%type   <v_node>    String
%type   <v_node>    Literal
%type   <v_node>    Array
%type   <v_node>    Hash
%type   <v_node>    Value
%type   <v_node>    FunctionCall
%type   <v_node>    NamedExpr
%type   <v_node>    PowerExpr
%type   <v_node>    SuffixExpr
%type   <v_node>    PrefixExpr
%type   <v_node>    MultExpr
%type   <v_node>    AddExpr
%type   <v_node>    ShiftExpr
%type   <v_node>    LowCompExpr
%type   <v_node>    HighCompExpr
%type   <v_node>    LogicExpr
%type   <v_node>    RangeExpr
%type   <v_node>    TernaryExpr
%type   <v_node>    Expression

%type   <v_list>    ExprList
%type   <v_list>    NamedExprList
%type   <v_list>    Expressions

%%

Program : /* empty */ {
            driver.warning("Nothing to do here.");
        }
        | Expressions {
            driver.Env->put_exprs($1);
        }
        ;

Identifier
        : ID {
            $$ = new IdentifierNode(*$1);
        }
        ;

String  : STRING {
            $$ = new StringNode(*$1);
        }
        | String STRING {
            ((StringNode *) $$)->append(*$2);
        }
        ;

Literal : String {
            $$ = $1;
        }
        | REGEX {
            $$ = new RegexNode(*$1);
        }
        | FLOAT {
            $$ = new FloatNode($1);
        }
        | INTEGER {
            $$ = new IntegerNode($1);
        }
        | TRUE {
            $$ = new BooleanNode(true);
        }
        | FALSE {
            $$ = new BooleanNode(false);
        }
        | Array {
            $$ = $1;
        }
        | Hash {
            $$ = $1;
        }
        ;

Array   : '[' ExprList ']' {
            $$ = new ArrayNode($2);
        }
        | '[' ']' {
            $$ = new ArrayNode();
        }
        ;

ExprList
        : Expression {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | ExprList ',' Expression {
            $$->push_back($3);
        }
        ;

Hash    : '{' NamedExprList '}' {
            $$ = new HashNode($2);
        }
        | '{' '}' {
            $$ = new HashNode();
        }
        ;

NamedExprList
        : NamedExpr {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | NamedExprList ',' NamedExpr {
            $$->push_back($3);
        }
        ;

NamedExpr
        : Identifier ':' Expression {
            $$ = new HashItemNode($1, $3);
        }
        | String ':' Expression {
            $$ = new HashItemNode($1, $3);
        }
        ;

FunctionCall
        : Identifier '(' ExprList ')' {
            $$ = new FunctionCallNode($1, $3);
        }
        | Identifier '(' ')' {
            $$ = new FunctionCallNode($1);
        }
        ;

Value   : Identifier {
            $$ = $1;
        }
        | Literal {
            $$ = $1;
        }
        | FunctionCall {
            $$ = $1;
        }
        | '(' Expression ')' {
            $$ = $2;
        }
        ;

PowerExpr
        : Value {
            $$ = $1;
        }
        | PowerExpr POW Value {
            $$ = new BinaryExprNode(Operation::BinaryPow, $1, $3);
        }
        ;

SuffixExpr
        : PowerExpr {
            $$ = $1;
        }
        | SuffixExpr '.' Identifier {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        | SuffixExpr '.' FunctionCall {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        | SuffixExpr '[' Expression ']' {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        ;

PrefixExpr
        : SuffixExpr {
            $$ = $1;
        }
        | '!' PrefixExpr %prec UNARY {
            $$ = new UnaryExprNode(Operation::UnaryNot, $2);
        }
        | '+' PrefixExpr %prec UNARY {
            $$ = new UnaryExprNode(Operation::UnaryAdd, $2);
        }
        | '-' PrefixExpr %prec UNARY {
            $$ = new UnaryExprNode(Operation::UnarySub, $2);
        }
        ;

MultExpr: PrefixExpr {
            $$ = $1;
        }
        | MultExpr '*' PrefixExpr {
            $$ = new BinaryExprNode(Operation::BinaryMul, $1, $3);
        }
        | MultExpr '/' PrefixExpr {
            $$ = new BinaryExprNode(Operation::BinaryDiv, $1, $3);
        }
        | MultExpr '%' PrefixExpr {
            $$ = new BinaryExprNode(Operation::BinaryMod, $1, $3);
        }
        ;

AddExpr : MultExpr {
            $$ = $1;
        }
        | AddExpr '+' MultExpr {
            $$ = new BinaryExprNode(Operation::BinaryAdd, $1, $3);
        }
        | AddExpr '-' MultExpr {
            $$ = new BinaryExprNode(Operation::BinarySub, $1, $3);
        }
        ;

ShiftExpr
        : AddExpr {
            $$ = $1;
        }
        | ShiftExpr SHL AddExpr {
            $$ = new BinaryExprNode(Operation::BinaryShl, $1, $3);
        }
        | ShiftExpr SHR AddExpr {
            $$ = new BinaryExprNode(Operation::BinaryShr, $1, $3);
        }
        ;

LowCompExpr
        : ShiftExpr {
            $$ = $1;
        }
        | LowCompExpr '<' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryLet, $1, $3);
        }
        | LowCompExpr LEE ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryLee, $1, $3);
        }
        | LowCompExpr '>' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryGet, $1, $3);
        }
        | LowCompExpr GEE ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryGee, $1, $3);
        }
        ;

HighCompExpr
        : LowCompExpr {
            $$ = $1;
        }
        | HighCompExpr EQL LowCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryEql, $1, $3);
        }
        | HighCompExpr NEQ LowCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryNeq, $1, $3);
        }
        | HighCompExpr IS LowCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryIs, $1, $3);
        }
        | HighCompExpr NIS LowCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryNis, $1, $3);
        }
        | HighCompExpr MAT LowCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryMat, $1, $3);
        }
        | HighCompExpr NMA LowCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryNma, $1, $3);
        }
        ;

LogicExpr
        : HighCompExpr {
            $$ = $1;
        }
        | LogicExpr AND HighCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryAnd, $1, $3);
        }
        | LogicExpr OR HighCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryOr, $1, $3);
        }
        | LogicExpr '^' HighCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryXor, $1, $3);
        }
        | LogicExpr IMPLIES HighCompExpr {
            $$ = new BinaryExprNode(Operation::BinaryImplies, $1, $3);
        }
        ;

RangeExpr
        : LogicExpr {
            $$ = $1;
        }
        | RangeExpr DOT2 LogicExpr {
            $$ = new BinaryExprNode(Operation::BinaryDot2, $1, $3);
        }
        | RangeExpr DOT3 LogicExpr {
            $$ = new BinaryExprNode(Operation::BinaryDot3, $1, $3);
        }
        ;

TernaryExpr
        : RangeExpr {
            $$ = $1;
        }
        | RangeExpr '?' Expression ':' Expression {
            $$ = new TernaryExprNode(Operation::TernaryIf, $1, $3, $5);
        }
        ;

// Assignment

Expression
        : TernaryExpr {
            $$ = $1;
        }
        ;

Expressions
        : Expression {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | Expressions ';' Expression {
            $$->push_back($3);
        }
        ;

%%

namespace LANG_NAMESPACE {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // LANG_NAMESPACE
