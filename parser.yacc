
%{
#include <vector>

using namespace std;

#include "st.h"
#include "stoql.h"
#include "stmt.h"
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
    driver.inc_lines();
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

%token  kABSTRACT   "abstract"
%token  kAFTER      "after"
%token  kASYNC      "async"
%token  kASC        "asc"
%token  kAS         "as"
%token  kATTR       "attr"
%token  kBEFORE     "before"
%token  kBETWEEN    "between"
%token  kBREAK      "break"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCLASS      "class"
%token  kCONST      "const"
%token  kDEF        "def"
%token  kDESC       "desc"
%token  kDO         "do"
%token  kELIF       "elif"
%token  kELSE       "else"
%token  kEND        "end"
%token  kENSURE     "ensure"
%token  kEVENT      "event"
%token  kEXIT       "exit"
%token  kFALSE      "false"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kGET        "get"
%token  kGROUP      "group"
%token  kHAS        "has"
%token  kIF         "if"
%token  kIMPORT     "import"
%token  kINCLUDE    "include"
%token  kINVARIANTS "invariants"
%token  kIN         "in"
%token  kIS         "is"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kMODULE     "module"
%token  kNEW        "new"
%token  kNIL        "nil"
%token  kON         "on"
%token  kORDER      "order"
%token  kPRIVATE    "private"
%token  kPROTECTED  "protected"
%token  kPUBLIC     "public"
%token  kRAISE      "raise"
%token  kREQUIRE    "require"
%token  kRESCUE     "rescue"
%token  kRIGHT      "right"
%token  kSEALED     "sealed"
%token  kSELECT     "select"
%token  kSELF       "self"
%token  kSET        "set"
%token  kSIGNAL     "signal"
%token  kSKIP       "skip"
%token  kSTEP       "step"
%token  kTAKE       "take"
%token  kTHEN       "then"
%token  kTRUE       "true"
%token  kUNLESS     "unless"
%token  kUNTIL      "until"
%token  kVAR        "var"
%token  kWHEN       "when"
%token  kWHERE      "where"
%token  kWHILE      "while"
%token  kYIELD      "yield"

%token  '='     "="
%token  sADE    "+="
%token  sSUE    "-="
%token  sMUE    "*="
%token  sDIE    "/="

%token  '?'     "?"
%token  ':'     ":"
%token  sAND    "&&"
%token  sOR     "||"
%token  sIMPLIES "=>"
%token  sEQL    "=="
%token  sIDE    "==="
%token  sNEQ    "!="
%token  sMAT    "=~"
%token  sNMA    "!~"
%token  '<'     "<"
%token  sLEE    "<="
%token  '>'     ">"
%token  sGEE    ">="
%token  sDOT2   ".."
%token  sDOT3   "..."
%token  '&'     "&"
%token  '|'     "|"
%token  '^'     "^"
%token  sSHL    "<<"
%token  sSHR    ">>"
%token  '+'     "+"
%token  '-'     "-"
%token  '*'     "*"
%token  '/'     "/"
%token  sPOW    "**"
%token  '!'     "!"
%token  sSCP    "::"
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

%left   sOR sAND sIMPLIES sEQL sNEQ sMAT sNMA sLEE sGEE sSHL sSHR sPOW sDOT2 sDOT3 sSCP sIDE kIN kIS
%left   '?' ':' '<' '>' '^' '+' '-' '*' '/' '%' '\\' '&' '|' '[' ']' '{' '}' '(' ')' ',' '.' '!'
%right  UNARY sADE sSUE sMUE sDIE
%right  '='

%type   <v_node>    Identifier
%type   <v_node>    QualifiedId
%type   <v_node>    ArrayAccessInfo
%type   <v_node>    String
%type   <v_node>    Literal
%type   <v_node>    Array
%type   <v_node>    Hash
%type   <v_node>    Value
%type   <v_node>    FunctionCall
%type   <v_node>    NamedExpr
%type   <v_node>    SuffixExpr
%type   <v_node>    PrefixExpr
%type   <v_node>    MultExpr
%type   <v_node>    AddExpr
%type   <v_node>    ShiftExpr
%type   <v_node>    BitwiseExpr
%type   <v_node>    RelatExpr
%type   <v_node>    RangeExpr
%type   <v_node>    LogicExpr
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
%type   <v_node>    RangeClause
%type   <v_node>    SelectsORGroupClause
%type   <v_node>    GroupByClause
%type   <v_node>    SelectClause
%type   <v_node>    Expression
%type   <v_node>    Statement
%type   <v_node>    IfStmt
%type   <v_node>    IfClause
%type   <v_node>    ElifClause
%type   <v_node>    AsyncStmt
%type   <v_node>    BlockStmt

%type   <v_list>    RealParams
%type   <v_list>    ParamValueList
%type   <v_list>    NamedExprList
%type   <v_list>    QueryBodyClauses
%type   <v_list>    OrderingNodes
%type   <v_list>    ExpressionList
%type   <v_list>    ThenClause
%type   <v_list>    RepeatElifClause
%type   <v_list>    ElseClause
%type   <v_list>    Statements

%%

Program
        : /* empty */ {
            driver.dec_lines();
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
        | kSELF {
            $$ = new IdentifierNode("self");
        }
        | kNIL {
            $$ = new IdentifierNode("nil");
        }
        ;

QualifiedId
        : Identifier {
            $$ = $1;
        }
        | QualifiedId '.' Identifier {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        | QualifiedId sSCP Identifier {
            $$ = new BinaryExprNode(Operation::BinaryScope, $1, $3);
        }
        | QualifiedId '.' FunctionCall
        | QualifiedId sSCP FunctionCall
        | QualifiedId '[' ArrayAccessInfo ']'
        ;

ArrayAccessInfo
        : Expression {
            $$ = new ArrayAccessNode($1);
        }
        | Expression ':' {
            $$ = new ArrayAccessNode($1, NULL);
        }
        | Expression ':' Expression {
            $$ = new ArrayAccessNode($1, $3);
        }
        | ':' Expression {
            $$ = new ArrayAccessNode(NULL, $2);
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
        : Identifier ':' Expression {
            $$ = new HashPairNode($1, $3);
        }
        | String ':' Expression {
            $$ = new HashPairNode($1, $3);
        }
        ;

Literal
        : REGEX {
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
        | String {
            $$ = $1;
        }
        | Array {
            $$ = $1;
        }
        | Hash {
            $$ = $1;
        }
        ;

Value
        : Literal {
            $$ = $1;
        }
        | QualifiedId {
            $$ = $1;
        }
        | FunctionCall {
            $$ = $1;
        }
        | '(' Expression ')' {
            $$ = $2;
        }
        ;

FunctionCall
        : Identifier RealParams {
            $$ = new FunctionCallNode($1, $2);
        }
        | kNEW RealParams // {
            // throw NotImplementedError();
            // $$ = new UnaryExprNode(Operation::UnaryNew, StbLib::Object);
        // }
        ;

RealParams
        : '(' ')' {
            $$ = new VectorNode();
        }
        | '(' ParamValueList ')' {
            $$ = $2;
        }
        ;

ParamValueList
        : AssignValue {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | ParamValueList ',' AssignValue {
            $$->push_back($3);
        }
        ;

SuffixExpr
        : Value {
            $$ = $1;
        }
        | SuffixExpr '.' Identifier
        | SuffixExpr '.' FunctionCall {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        // | SuffixExpr '[' ArrayAccessInfo ']' {
        //     $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        // }
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
        | '(' QualifiedId ')' PrefixExpr %prec UNARY {
            $$ = new BinaryExprNode(Operation::BinaryCast, $4, $2);
        }
        | kNEW PrefixExpr %prec UNARY {
            $$ = new UnaryExprNode(Operation::UnaryNew, $2);
        }
        | kNEW kCLASS '(' NamedExprList ')' // {
            // throw NotImplementedError();
            // $$ = new UnaryExprNode(Operation::UnaryNew, StdLib::Object);
        // }
        ;

MultExpr
        : PrefixExpr {
            $$ = $1;
        }
        | MultExpr sPOW PrefixExpr {
            $$ = new BinaryExprNode(Operation::BinaryPow, $1, $3);
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
        | MultExpr '\\' PrefixExpr {
            $$ = new BinaryExprNode(Operation::BinaryDiv, $1, $3);
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
        | ShiftExpr sSHL AddExpr {
            $$ = new BinaryExprNode(Operation::BinaryShl, $1, $3);
        }
        | ShiftExpr sSHR AddExpr {
            $$ = new BinaryExprNode(Operation::BinaryShr, $1, $3);
        }
        ;

BitwiseExpr
        : ShiftExpr {
            $$ = $1;
        }
        | BitwiseExpr '&' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryBAnd, $1, $3);
        }
        | BitwiseExpr '|' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryBOr, $1, $3);
        }
        | BitwiseExpr '^' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryBXor, $1, $3);
        }
        ;

RelatExpr
        : BitwiseExpr {
            $$ = $1;
        }
        | RelatExpr '<' BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryLet, $1, $3);
        }
        | RelatExpr sLEE BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryLee, $1, $3);
        }
        | RelatExpr '>' BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryGet, $1, $3);
        }
        | RelatExpr sGEE BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryGee, $1, $3);
        }
        | RelatExpr sEQL BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryEql, $1, $3);
        }
        | RelatExpr sNEQ BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryNeq, $1, $3);
        }
        | RelatExpr sIDE BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryIde, $1, $3);
        }
        | RelatExpr kIS BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryIs, $1, $3);
        }
        | RelatExpr kIN BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryIn, $1, $3);
        }
        | RelatExpr kHAS BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryHas, $3, $1);
        }
        | RelatExpr sMAT BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryMat, $1, $3);
        }
        | RelatExpr sNMA BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryNma, $1, $3);
        }
        ;

LogicExpr
        : RelatExpr {
            $$ = $1;
        }
        | LogicExpr sAND RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryLAnd, $1, $3);
        }
        | LogicExpr sOR RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryLOr, $1, $3);
        }
        | LogicExpr sIMPLIES RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryLImplies, $1, $3);
        }
        ;

RangeExpr
        : LogicExpr {
            $$ = $1;
        }
        | RangeExpr sDOT2 LogicExpr {
            $$ = new BinaryExprNode(Operation::BinaryDot2, $1, $3);
        }
        | RangeExpr sDOT3 LogicExpr {
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
        | RangeExpr kBETWEEN RelatExpr sAND RelatExpr {
            $$ = new TernaryExprNode(Operation::TernaryBetween, $1, $3, $5);
        }
        ;

AssignExpr
        : QualifiedId '=' AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryAssign, $1, $3);
        }
        | QualifiedId sADE  AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryAde, $1, $3);
        }
        | QualifiedId sSUE  AssignValue {
            $$ = new BinaryExprNode(Operation::BinarySue, $1, $3);
        }
        | QualifiedId sMUE  AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryMue, $1, $3);
        }
        | QualifiedId sDIE  AssignValue {
            $$ = new BinaryExprNode(Operation::BinaryDie, $1, $3);
        }
        ;

AssignValue
        : Expression {
            $$ = $1;
        }
        | BlockStmt {
            $$ = $1;
        }
        | kASYNC Expression {
            $$ = new AsyncStmtNode($2);
        }
        | kASYNC BlockStmt {
            $$ = new AsyncStmtNode($2);
        }
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
        : QueryBodyClauses SelectsORGroupClause {
            $$ = new QueryBodyNode();
            ((QueryBodyNode *) $$)
                ->set_body($1)
                ->set_finally($2);
        }
        | QueryBodyClauses {
            $$ = new QueryBodyNode();
            ((QueryBodyNode *) $$)
                ->set_body($1);
        }
        | SelectsORGroupClause {
            $$ = new QueryBodyNode();
            ((QueryBodyNode *) $$)
                ->set_finally($1);
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
        | RangeClause {
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

RangeClause
        : kSKIP Expression {
            $$ = new RangeNode(RangeType::Skip, $2);
        }
        | kSTEP Expression {
            $$ = new RangeNode(RangeType::Step, $2);
        }
        | kTAKE Expression {
            $$ = new RangeNode(RangeType::Take, $2);
        }
        ;

SelectsORGroupClause
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
            $$ = new SelectNode($2);
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
        : IfClause ThenClause kEND {
            $$ = new IfStmtNode($1, $2);
        }
        | IfClause ThenClause ElseClause kEND {
            $$ = new IfStmtNode($1, $2);
            ((IfStmtNode *) $$)
              ->set_else($3);
        }
        | IfClause ThenClause RepeatElifClause kEND {
            $$ = new IfStmtNode($1, $2);
            ((IfStmtNode *) $$)
              ->set_elif($3);
        }
        | IfClause ThenClause RepeatElifClause ElseClause kEND {
            $$ = new IfStmtNode($1, $2);
            ((IfStmtNode *) $$)
              ->set_elif($3)
              ->set_else($4);
        }
        ;

IfClause
        : kIF Expression {
            $$ = $2;
        }
        ;

ThenClause
        : kTHEN {
            $$ = NULL;
        }
        | kTHEN Statements {
            $$ = $2;
        }
        ;

RepeatElifClause
        : ElifClause {
            $$ = new VectorNode();
        }
        | RepeatElifClause ElifClause {
            $$->push_back($2);
        }
        ;

ElifClause
        : kELIF Expression ThenClause {
            $$ = new IfStmtNode($2, $3);
        }
        ;

ElseClause
        : kELSE {
            $$ = NULL;
        }
        | kELSE Statements {
            $$ = $2;
        }
        ;

UnlessStmt
        : UnlessClause ThenClause kEND
        | UnlessClause ThenClause ElseClause kEND
        ;

UnlessClause
        : kUNLESS Expression
        | kUNLESS Expression WhereClause
        ;

CaseStmt
        : CaseExpr kEND
        | CaseExpr ElseClause kEND
        | CaseExpr RepeatWhenClause kEND
        | CaseExpr RepeatWhenClause ElseClause kEND
        ;

CaseExpr
        : kCASE Expression
        | kCASE Expression WhereClause
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
        | kFOR Expression kASC Expression kSTEP Expression BlockStmt
        | kFOR Expression kDESC Expression BlockStmt
        | kFOR Expression kDESC Expression kSTEP Expression BlockStmt
        | kFOR VarStmt kIN Expression BlockStmt
        | kFOR Identifier kIN Expression BlockStmt
        ;

LoopStmt
        : kWHILE Expression BlockStmt
        | kWHILE Expression WhereClause BlockStmt
        | kUNTIL Expression BlockStmt
        | kUNTIL Expression WhereClause BlockStmt
        ;

AsyncStmt
        : kASYNC Statement
        ;

RaiseStmt
        : kRAISE
        | kRAISE String
        | kRAISE kNEW PrefixExpr
        ;

ControlStmt
        : kBREAK
        | kEXIT
        | kEXIT AssignValue
        | kYIELD
        | kYIELD AssignValue
        ;

BlockStmt
        : kDO kEND
        | kDO Statements kEND
        | kDO Statements RescueClause kEND
        | RequireClause kDO Statements kEND
        | RequireClause kDO Statements RescueClause kEND
        | kDO Statements EnsureClause kEND
        | kDO Statements RescueClause EnsureClause kEND
        | RequireClause kDO Statements EnsureClause kEND
        | RequireClause kDO Statements RescueClause EnsureClause kEND
        ;

RequireClause
        : kREQUIRE Conditions
        ;

Conditions
        : Condition
        | Conditions Condition
        ;

Condition
        : LogicExpr ';'
        | LogicExpr ':' String ';'
        ;

EnsureClause
        : kENSURE Statements
        ;

RescueClause
        : kRESCUE RepeatWhenClause
        | kRESCUE
        ;

VisibilityStmt
        : kPRIVATE
        | kPROTECTED
        | kPUBLIC
        ;

ImportStmt
        : kIMPORT LinkableList
        | kFROM Identifier kIMPORT LinkableList
        ;

IncludeStmt
        : kINCLUDE LinkableList
        ;

LinkableList
        : Linkable
        | LinkableList ',' Linkable
        ;

Linkable
        : QualifiedId
        | String
        ;

VarStmt
        : kVAR ListVariable
        ;

ListVariable
        : Variable
        | ListVariable ',' Variable
        ;

Variable
        : Identifier
        | Identifier InvariantsClause
        | Identifier InitialValue
        | Identifier InitialValue InvariantsClause
        | Identifier MemberType
        | Identifier MemberType InvariantsClause
        | Identifier MemberType InitialValue
        | Identifier MemberType InitialValue InvariantsClause
        ;

MemberType
        : ':' QualifiedId
        | ':' QualifiedId TypeArrayTail
        ;

TypeArrayTail
        : ArrayTail
        | TypeArrayTail ArrayTail
        ;

ArrayTail
        : '[' ']'
        | '[' INTEGER ']'
        ;

InitialValue
        : '=' AssignValue
        ;

InvariantsClause
        : kINVARIANTS LogicExpr
        | kINVARIANTS LogicExpr ':' String
        ;

ConstStmt
        : kCONST ListConstant
        ;

ListConstant
        : Constant
        | ListConstant ',' Constant
        ;

Constant
        : Identifier InitialValue
        | Identifier MemberType InitialValue
        ;

EventStmt
        : kEVENT EventList
        ;

EventList
        : Event
        | EventList ',' Event
        ;

Event
        : Identifier
        | Identifier InitialValue
        | Identifier InterceptClause
        | Identifier InterceptClause InitialValue
        | Identifier MemberType
        | Identifier MemberType InitialValue
        | Identifier MemberType InterceptClause
        | Identifier MemberType InterceptClause InitialValue
        ;

InterceptClause
        : kAFTER IdentifierList
        | kBEFORE IdentifierList
        | kSIGNAL IdentifierList
        ;

IdentifierList
        : QualifiedId
        | IdentifierList ',' QualifiedId
        ;

AttrStmt
        : kATTR AttributeList
        ;

AttributeList
        : Attribute
        | AttributeList ',' Attribute
        ;

Attribute
        : Identifier MemberType
        | Identifier MemberType InvariantsClause
        | Identifier MemberType Getter
        | Identifier MemberType Getter InvariantsClause
        | Identifier MemberType Getter Setter
        | Identifier MemberType Getter Setter InvariantsClause
        ;

Getter
        : kGET
        | kGET Identifier
        ;

Setter
        : kSET
        | kSET Identifier
        ;

FunctionStmt
        : kDEF Identifier
        | kDEF Identifier InterceptClause
        | kDEF Identifier MemberType
        | kDEF Identifier MemberType InterceptClause
        | kDEF Identifier FormalParams
        | kDEF Identifier FormalParams InterceptClause
        | kDEF Identifier FormalParams MemberType
        | kDEF Identifier FormalParams MemberType InterceptClause
        ;

FormalParams
        : '(' ')'
        | '(' ListVariable ')'
        ;

ClassStmt
        : kCLASS Identifier
        | kABSTRACT kCLASS Identifier
        | kSEALED kCLASS Identifier
        | kABSTRACT kSEALED kCLASS Identifier
        | kCLASS Identifier Heritance
        | kABSTRACT kCLASS Identifier Heritance
        | kSEALED kCLASS Identifier Heritance
        | kABSTRACT kSEALED kCLASS Identifier Heritance
        ;

Heritance
        : '>' IdentifierList
        ;

ModuleStmt
        : kMODULE QualifiedId BlockStmt
        ;

TypeStmt
        : VisibilityStmt
        | ImportStmt ';'
        | IncludeStmt ';'
        | VarStmt ';'
        | ConstStmt ';'
        | EventStmt ';'
        | AttrStmt ';'
        | FunctionStmt ';'
        | FunctionStmt BlockStmt
        | ClassStmt BlockStmt
        | ModuleStmt
        ;

AnnotationStmt
        : '@' Identifier
        | '@' Identifier RealParams
        ;

Statement
        : IfStmt {
            $$ = $1;
        }
        | UnlessStmt
        | CaseStmt
        | ForStmt
        | LoopStmt
        | BlockStmt
        | AsyncStmt
        | RaiseStmt ';'
        | ControlStmt ';'
        | Expression ';'
        | AnnotationStmt
        | TypeStmt
        ;

Statements
        : Statement {
            $$ = new VectorNode();
        }
        | Statements Statement {
            $$->push_back($2);
        }
        ;

%%

namespace LANG_NAMESPACE {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // LANG_NAMESPACE
