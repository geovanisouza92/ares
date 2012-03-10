
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

%token  kASYNC      "async"
%token  kASC        "asc"
%token  kAS         "as"
%token  kBY         "by"
%token  kCASE       "case"
%token  kDESC       "desc"
%token  kDO         "do"
%token  kELIF       "elif"
%token  kELSE       "else"
%token  kEND        "end"
%token  kFALSE      "false"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kGROUP      "group"
%token  kIF         "if"
%token  kIN         "in"
%token  kIS         "is"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kNEW        "new"
%token  kNIL        "nil"
%token  kON         "on"
%token  kORDER      "order"
%token  kRAISE      "raise"
%token  kRIGHT      "right"
%token  kSELECT     "select"
%token  kSKIP       "skip"
%token  kSTEP       "step"
%token  kTAKE       "take"
%token  kTHEN       "then"
%token  kTRUE       "true"
%token  kUNLESS     "unless"
%token  kUNTIL      "until"
%token  kWHEN       "when"
%token  kWHERE      "where"
%token  kWHILE      "while"

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
%left   '+' '-' '*' '/' '%' POW DOT2 DOT3 kIN kIS '.' '['
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
%type   <v_node>    CastExpr
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
%type   <v_node>    QueryExpr
%type   <v_node>    QueryOrigin
%type   <v_node>    QueryBody
%type   <v_node>    QueryBodyClause
%type   <v_node>    WhereClause
%type   <v_node>    JoinClause
%type   <v_node>    OrderByClause
%type   <v_node>    OrderingNode
%type   <v_node>    SelectOrGroupClause
%type   <v_node>    GroupByClause
%type   <v_node>    SelectClause
%type   <v_node>    SelectRangeClause
%type   <v_node>    Expression
%type   <v_node>    Statement

%type   <v_list>    NamedExprList
%type   <v_list>    QueryBodyClauses
%type   <v_list>    OrderingNodes
%type   <v_list>    ExpressionList
%type   <v_list>    Statements

%%

Program
        : /* empty */ {
            driver.warning("Nothing to do here.");
        }
        | Statements {
            driver.Env->put_cmds($1);
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
            $$ = new HashPairNode($1, $3);
        }
        | String ':' Expression {
            $$ = new HashPairNode($1, $3);
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

CastExpr
        : PrefixExpr {
            $$ = $1;
        }
        | CastExpr kAS QualifiedId {
            $$ = new BinaryExprNode(Operation::BinaryCast, $1, $3);
        }
        ;

PowerExpr
        : CastExpr {
            $$ = $1;
        }
        | PowerExpr POW CastExpr {
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
        | AsyncStmt
        ;

QueryExpr
        : kFROM QueryOrigin QueryBody {
            $$ = new QueryNode($2, $3);
        }
        | kFROM QueryOrigin {
            $$ = new QueryNode($2, NULL);
        }
        ;

QueryOrigin
        : Identifier kIN Expression {
            $$ = new QueryOriginNode($1, $3);
        }
        ;

QueryBody
        : QueryBodyClauses SelectOrGroupClause {
            $$ = new QueryBodyNode($2);
            ((QueryBodyNode *) $$)->set_body($1);
        }
        | SelectOrGroupClause {
            $$ = new QueryBodyNode($1);
        }
        ;

QueryBodyClauses
        : QueryBodyClause {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | QueryBodyClauses QueryBodyClause {
            $$->push_back($2);
        }
        ;

QueryBodyClause
        : WhereClause {
            $$ = $1;
        }
        | JoinClause {
            $$ = $1;
        }
        | OrderByClause {
            $$ = $1;
        }
        ;

WhereClause
        : kWHERE LogicExpr {
            $$ = new WhereNode($2);
        }
        ;

JoinClause
        : kJOIN QueryOrigin kON LogicExpr {
            $$ = new JoinNode($2, $4, JoinDirection::None);
        }
        | kLEFT kJOIN QueryOrigin kON LogicExpr {
            $$ = new JoinNode($3, $5, JoinDirection::Left);
        }
        | kRIGHT kJOIN QueryOrigin kON LogicExpr {
            $$ = new JoinNode($3, $5, JoinDirection::Right);
        }
        ;

OrderByClause
        : kORDER kBY OrderingNodes {
            $$ = new OrderByNode($3);
        }
        ;

OrderingNodes
        : OrderingNode {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | OrderingNodes ',' OrderingNode {
            $$->push_back($3);
        }
        ;

OrderingNode
        : Expression {
            $$ = new OrderingNode($1, OrderDirection::None);
        }
        | Expression kASC {
            $$ = new OrderingNode($1, OrderDirection::Asc);
        }
        | Expression kDESC {
            $$ = new OrderingNode($1, OrderDirection::Desc);
        }
        ;

SelectOrGroupClause
        : GroupByClause {
            $$ = $1;
        }
        | SelectClause {
            $$ = $1;
        }
        ;

GroupByClause
        : kGROUP kBY Expression {
            $$ = new GroupByNode($3);
        }
        ;

SelectClause
        : kSELECT ExpressionList {
            $$ = new SelectNode($2, NULL);
        }
        | kSELECT ExpressionList SelectRangeClause {
            $$ = new SelectNode($2, $3);
        }
        ;

SelectRangeClause
        : kSKIP Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_skip($2);
        }
        | kSKIP Expression kSTEP Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_skip($2)
              ->set_step($4);
        }
        | kSKIP Expression kTAKE Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_skip($2)
              ->set_take($4);
        }
        | kSKIP Expression kSTEP Expression kTAKE Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_skip($2)
              ->set_step($4)
              ->set_take($6);
        }
        | kSTEP Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_step($2);
        }
        | kSTEP Expression kTAKE Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_step($2)
              ->set_take($4);
        }
        | kTAKE Expression {
            $$ = new RangeNode();
            ((RangeNode *) $$)
              ->set_take($2);
        }
        ;

Expression
        : AssignExpr {
            $$ = $1;
        }
        | TernaryExpr {
            $$ = $1;
        }
        | QueryExpr {
            $$ = $1;
        }
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

IfStmt
        : IfClause ThenClause kEND
        | IfClause ThenClause RepeatElifClause kEND
        | IfClause ThenClause ElseClause kEND
        | IfClause ThenClause RepeatElifClause ElseClause kEND
        ;

IfClause
        : kIF Expression
        ;

ThenClause
        : kTHEN
        | kTHEN Statements
        ;

RepeatElifClause
        : ElifClause
        | RepeatElifClause ElifClause
        ;

ElifClause
        : kELIF Expression ThenClause
        ;

ElseClause
        : kELSE
        | kELSE Statements
        ;

UnlessStmt
        : UnlessClause ThenClause kEND
        | UnlessClause ThenClause ElseClause kEND
        ;

UnlessClause
        : kUNLESS Expression
        ;

CaseStmt
        : CaseExpr kEND
        | CaseExpr RepeatWhenClause kEND
        ;

CaseExpr
        : kCASE Expression
        ;

RepeatWhenClause
        : WhenClause
        | RepeatWhenClause WhenClause
        ;

WhenClause
        : kWHEN Expression BlockStmt
        ;

ForStmt
        : kFOR Expression kASC Expression BlockStmt
        | kFOR Expression kDESC Expression BlockStmt
        | kFOR Identifier kIN Expression BlockStmt
        ;

LoopStmt
        : kWHILE Expression BlockStmt
        | kUNTIL Expression BlockStmt
        ;

AsyncStmt
        : kASYNC Statement
        ;

RaiseStmt
        : kRAISE
        | kRAISE String
        | kRAISE kNEW PrefixExpr
        ;

BlockStmt
        : kDO Statements kEND
        ;

Statement
        : IfStmt
        | UnlessStmt
        | CaseStmt
        | ForStmt
        | LoopStmt
        | BlockStmt
        | AsyncStmt
        | RaiseStmt
        | Expression ';'
        ;

Statements
        : Statement
        | Statements Statement
        ;

%%

namespace LANG_NAMESPACE {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // LANG_NAMESPACE
