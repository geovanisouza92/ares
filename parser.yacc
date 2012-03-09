
%{
#include <vector>

using namespace std;

#include "st.h"
#include "stoql.h"
#include "driver.h"

using namespace SyntaxTree;
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
    int                             v_int;
    double                          v_flt;
    string *                        v_str;
    class SyntaxTree::SyntaxNode *  v_node;
    class SyntaxTree::VectorNode *  v_list;
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

%token  kASC        "asc"
%token  kBY         "by"
%token  kDESC       "desc"
%token  kDISTINCT   "distinct"
%token  kFALSE      "false"
%token  kFROM       "from"
%token  kGROUP      "group"
%token  kIN         "in"
%token  kIS         "is"
%token  kNIS        "!is"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kNEW        "new"
%token  kNIL        "nil"
%token  kON         "on"
%token  kORDER      "order"
%token  kRIGHT      "right"
%token  kSELECT     "select"
%token  kSKIP       "skip"
%token  kSTEP       "step"
%token  kTAKE       "take"
%token  kTRUE       "true"
%token  kWHERE      "where"

%token  '='     "="
%token  ADE     "+="
%token  SUE     "-="
%token  MUE     "*="
%token  DIE     "/="

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
%token  POW     "**"
%token  '!'     "!"
%token  UNARY

%token  '('     "("
%token  ')'     ")"
%token  '['     "["
%token  ']'     "]"
%token  '{'     "{"
%token  '}'     "}"
%token  ','     ","
%token  ';'     ";"
%token  '.'     "."

%nonassoc ID FLOAT INTEGER STRING REGEX kTRUE kFALSE

%left   '?' ':' '^' OR AND IMPLIES EQL NEQ MAT NMA '>' '<' LEE GEE SHL SHR
%left   '+' '-' '*' '/' '%' POW DOT2 DOT3 kIN kIS kNIS '.' '['
%right  UNARY '=' ADE SUE MUE DIE ']'

%type   <v_node>    Identifier
%type   <v_node>    QualifiedId
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
%type   <v_node>    RelatExpr
%type   <v_node>    LogicExpr
%type   <v_node>    RangeExpr
%type   <v_node>    TernaryExpr
%type   <v_node>    AssignExpr
%type   <v_node>    AssignValue

%type   <v_node>    Expression

%type   <v_list>    NamedExprList
%type   <v_list>    ExpressionList
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

QualifiedId
        : Identifier {
            $$ = $1;
        }
        | QualifiedId '.' Identifier {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        | QualifiedId '[' Expression ']' {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        ;

String
        : STRING {
            $$ = new StringNode(*$1);
        }
        | String STRING {
            ((StringNode *) $$)->append(*$2);
        }
        ;

Literal
        : String {
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
        | kFALSE {
            $$ = new BooleanNode(false);
        }
        | kTRUE {
            $$ = new BooleanNode(true);
        }
        | Array {
            $$ = $1;
        }
        | Hash {
            $$ = $1;
        }
        ;

Array
        : '[' ExpressionList ']' {
            $$ = new ArrayNode($2);
        }
        | '[' ']' {
            $$ = new ArrayNode();
        }
        ;

Hash
        : '{' NamedExprList '}' {
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
        : QualifiedId ':' Expression {
            $$ = new HashItemNode($1, $3);
        }
        | String ':' Expression {
            $$ = new HashItemNode($1, $3);
        }
        ;

FunctionCall
        : QualifiedId '(' ExpressionList ')' {
            $$ = new FunctionCallNode($1, $3);
        }
        | QualifiedId '(' ')' {
            $$ = new FunctionCallNode($1);
        }
        ;

Value
        : kNIL {
            $$ = new NilNode();
        }
        | QualifiedId {
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

SuffixExpr
        : Value {
            $$ = $1;
        }
        | SuffixExpr '.' QualifiedId {
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
        | kNEW PrefixExpr %prec UNARY {
            $$ = new UnaryExprNode(Operation::UnaryNew, $2);
        }
        ;

PowerExpr
        : PrefixExpr {
            $$ = $1;
        }
        | PowerExpr POW PrefixExpr {
            $$ = new BinaryExprNode(Operation::BinaryPow, $1, $3);
        }
        ;

MultExpr
        : PowerExpr {
            $$ = $1;
        }
        | MultExpr '*' PowerExpr {
            $$ = new BinaryExprNode(Operation::BinaryMul, $1, $3);
        }
        | MultExpr '/' PowerExpr {
            $$ = new BinaryExprNode(Operation::BinaryDiv, $1, $3);
        }
        | MultExpr '%' PowerExpr {
            $$ = new BinaryExprNode(Operation::BinaryMod, $1, $3);
        }
        ;

AddExpr
        : MultExpr {
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

RelatExpr
        : ShiftExpr {
            $$ = $1;
        }
        | RelatExpr '<' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryLet, $1, $3);
        }
        | RelatExpr LEE ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryLee, $1, $3);
        }
        | RelatExpr '>' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryGet, $1, $3);
        }
        | RelatExpr GEE ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryGee, $1, $3);
        }
        | RelatExpr EQL RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryEql, $1, $3);
        }
        | RelatExpr NEQ RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryNeq, $1, $3);
        }
        | RelatExpr kIS RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryIs, $1, $3);
        }
        | RelatExpr kNIS RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryNis, $1, $3);
        }
        | RelatExpr kIN RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryIn, $1, $3);
        }
        | RelatExpr MAT RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryMat, $1, $3);
        }
        | RelatExpr NMA RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryNma, $1, $3);
        }
        ;

LogicExpr
        : RelatExpr {
            $$ = $1;
        }
        | LogicExpr AND RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryAnd, $1, $3);
        }
        | LogicExpr OR RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryOr, $1, $3);
        }
        | LogicExpr '^' RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryXor, $1, $3);
        }
        | LogicExpr IMPLIES RelatExpr {
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

AssignExpr
        : QualifiedId '=' AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryAssign, $1, $3);
        }
        | QualifiedId ADE AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryAde, $1, $3);
        }
        | QualifiedId SUE AssignValue {
            $$ = new BinaryExprNode(Operation::BinarySue, $1, $3);
        }
        | QualifiedId MUE AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryMue, $1, $3);
        }
        | QualifiedId DIE AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryDie, $1, $3);
        }
        ;

AssignValue
        : Expression {
            $$ = $1;
        }
        ;

QueryExpr
        : kFROM QueryOrigin QueryBody
        ;

QueryOrigin
        : Identifier kIN Expression
        ;

QueryBody
        : QueryBodyClauses
        | SelectOrGroupClause
        ;

QueryBodyClauses
        : QueryBodyClause
        | QueryBodyClauses QueryBodyClause
        ;

QueryBodyClause
        : WhereClause
        | JoinClause
        | OrderByClause
        ;

WhereClause
        : kWHERE LogicExpr
        ;

JoinClause
        : kJOIN QueryOrigin kON LogicExpr
        ;

OrderByClause
        : kORDER kBY Orderings
        ;

Orderings
        : Ordering
        | Orderings ',' Ordering
        ;

Ordering: Expression
        | Expression kASC
        | Expression kDESC
        ;

SelectOrGroupClause
        : GroupByClause
        | SelectClause
        ;

GroupByClause
        : kGROUP kBY Expression
        ;

SelectClause
        : kSELECT ExpressionList
        ;

Expression
        : AssignExpr {
            $$ = $1;
        }
        | TernaryExpr {
            $$ = $1;
        }
        | QueryExpr
        ;

ExpressionList
        : Expression {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | ExpressionList ',' Expression {
            $$->push_back($3);
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
