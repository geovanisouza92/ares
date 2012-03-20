
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
%token  kLAMBDA     "lambda"
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
%token  sCMP    "<=>"
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

%left   sAND sOR sIMPLIES sEQL sNEQ sIDE sCMP sMAT sNMA sLEE sGEE sSHL sSHR sPOW sDOT2 sDOT3 kIN kIS
%left   '?' ':' '<' '>' '^' '+' '-' '*' '/' '%' '&' '|' ',' '.' '!'
%right  UNARY sADE sSUE sMUE sDIE
%right  '=' '(' '[' '{'

%type   <v_node>    Identifier
%type   <v_node>    QualifiedId
%type   <v_node>    AccessMember
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
%type   <v_node>    PowerExpr
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
%type   <v_node>    ElifClause
%type   <v_node>    UnlessStmt
%type   <v_node>    CaseStmt
%type   <v_node>    WhenClause
%type   <v_node>    ForStmt
%type   <v_node>    LoopStmt
%type   <v_node>    AsyncStmt
%type   <v_node>    RaiseStmt
%type   <v_node>    ControlStmt
%type   <v_node>    BlockStmt
%type   <v_node>    Condition
%type   <v_node>    VisibilityStmt
%type   <v_node>    ImportStmt
%type   <v_node>    IncludeStmt
%type   <v_node>    Linkable

%type   <v_list>    RealParams
%type   <v_list>    ParamValueList
%type   <v_list>    NamedExprList
%type   <v_list>    QueryBodyClauses
%type   <v_list>    OrderingNodes
%type   <v_list>    ExpressionList
%type   <v_list>    ThenClause
%type   <v_list>    RepeatElifClause
%type   <v_list>    ElseClause
%type   <v_list>    RepeatWhenClause
%type   <v_list>    Statements
%type   <v_list>    RequireClause
%type   <v_list>    Conditions
%type   <v_list>    RescueClause
%type   <v_list>    EnsureClause
%type   <v_list>    LinkableList

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
        ;

QualifiedId
        : Identifier {
            $$ = $1;
        }
        | QualifiedId '.' Identifier {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
        | QualifiedId '.' Identifier RealParams
        | QualifiedId '.' kNEW RealParams
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
        | kNIL {
            // $$ = new IdentifierNode("nil");
        }
        ;

FunctionCall
        : Identifier RealParams {
            $$ = new FunctionCallNode($1, $2);
        }
        | kNEW RealParams
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
        | SuffixExpr AccessMember {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $2);
        }
        ;

AccessMember
        : '.' FunctionCall
        | '[' ArrayAccessInfo ']'
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
        | kNEW kCLASS '(' NamedExprList ')' %prec UNARY {
            // $$ = new UnaryExprNode(Operation::UnaryNew, StdLib::Object);
        }
        ;

PowerExpr
        : PrefixExpr {
            $$ = $1;
        }
        | PowerExpr sPOW PrefixExpr {
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
        | RelatExpr sCMP BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryCmp, $1, $3);
        }
        | RelatExpr sMAT BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryMat, $1, $3);
        }
        | RelatExpr sNMA BitwiseExpr {
            $$ = new BinaryExprNode(Operation::BinaryNma, $1, $3);
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
        | kASYNC Expression {
            $$ = new AsyncStmtNode($2, AsyncType::Expression);
        }
        ;

LambdaExpr
        : kLAMBDA Expression
        | kLAMBDA ':' QualifiedId Expression
        | kLAMBDA FormalParams Expression
        | kLAMBDA FormalParams ':' QualifiedId Expression
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
        | LambdaExpr
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
        : kIF Expression ThenClause kEND {
            $$ = new IfStmtNode($2, $3);
        }
        | kIF Expression ThenClause ElseClause kEND {
            $$ = new IfStmtNode($2, $3);
            ((IfStmtNode *) $$)
              ->set_else($4);
        }
        | kIF Expression ThenClause RepeatElifClause kEND {
            $$ = new IfStmtNode($2, $3);
            ((IfStmtNode *) $$)
              ->set_elif($4);
        }
        | kIF Expression ThenClause RepeatElifClause ElseClause kEND {
            $$ = new IfStmtNode($2, $3);
            ((IfStmtNode *) $$)
              ->set_elif($4)
              ->set_else($5);
        }
        ;

ThenClause
        : kTHEN {
            $$ = new VectorNode();
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
            $$ = new VectorNode();
        }
        | kELSE Statements {
            $$ = $2;
        }
        ;

UnlessStmt
        : kUNLESS Expression ThenClause kEND {
            $$ = new UnlessStmtNode($2, $3);
        }
        | kUNLESS Expression ThenClause ElseClause kEND {
            $$ = new UnlessStmtNode($2, $3);
            ((UnlessStmtNode *) $$)
              ->set_else($4);
        }
        ;

CaseStmt
        : kCASE Expression kEND {
            $$ = new CaseStmtNode($2);
        }
        | kCASE Expression ElseClause kEND {
            $$ = new CaseStmtNode($2);
            ((CaseStmtNode *) $$)
              ->set_else($3);
        }
        | kCASE Expression RepeatWhenClause kEND {
            $$ = new CaseStmtNode($2);
            ((CaseStmtNode *) $$)
              ->set_when($3);
        }
        | kCASE Expression RepeatWhenClause ElseClause kEND {
            $$ = new CaseStmtNode($2);
            ((CaseStmtNode *) $$)
              ->set_when($3)
              ->set_else($4);
        }
        ;

RepeatWhenClause
        : WhenClause {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | RepeatWhenClause WhenClause {
            $$->push_back($2);
        }
        ;

WhenClause
        : kWHEN Expression BlockStmt {
            $$ = new WhenClauseNode($2, $3);
        }
        ;

ForStmt
        : kFOR   Expression kASC Expression BlockStmt {
            $$ = new ForStmtNode($2, $4, Loop::Ascending, $5);
        }
        | kFOR Expression kASC Expression kSTEP Expression BlockStmt {
            $$ = new ForStmtNode($2, $4, Loop::Ascending, $7);
            ((ForStmtNode *) $$)
              ->set_step($6);
        }
        | kFOR Expression kDESC Expression BlockStmt {
            $$ = new ForStmtNode($2, $4, Loop::Descending, $5);
        }
        | kFOR Expression kDESC Expression kSTEP Expression BlockStmt {
            $$ = new ForStmtNode($2, $4, Loop::Descending, $7);
            ((ForStmtNode *) $$)
              ->set_step($6);
        }
        | kFOR Identifier kIN Expression BlockStmt {
            $$ = new ForStmtNode($2, $4, Loop::Iteration, $5);
        }
        ;

LoopStmt
        : kWHILE Expression BlockStmt {
            $$ = new LoopStmtNode($2, $3, Loop::While);
        }
        | kUNTIL Expression BlockStmt {
            $$ = new LoopStmtNode($2, $3, Loop::Until);
        }
        ;

AsyncStmt
        : kASYNC Statement {
            $$ = new AsyncStmtNode($2, AsyncType::Statement);
        }
        ;

RaiseStmt
        : kRAISE {
            $$ = new RaiseStmtNode(NULL);
        }
        | kRAISE String {
            $$ = new RaiseStmtNode($2);
        }
        | kRAISE kNEW PrefixExpr {
            $$ = new RaiseStmtNode(new UnaryExprNode(Operation::UnaryNew, $3));
        }
        ;

ControlStmt
        : kBREAK {
            $$ = new ControlStmtNode(Control::Break, NULL);
        }
        | kEXIT {
            $$ = new ControlStmtNode(Control::Exit, NULL);
        }
        | kEXIT AssignValue {
            $$ = new ControlStmtNode(Control::Exit, $2);
        }
        | kYIELD {
            $$ = new ControlStmtNode(Control::Yield, NULL);
        }
        | kYIELD AssignValue {
            $$ = new ControlStmtNode(Control::Yield, $2);
        }
        ;

BlockStmt
        : kDO kEND {
            $$ = new BlockStmtNode(new VectorNode());
        }
        | kDO Statements kEND {
            $$ = new BlockStmtNode($2);
        }
        | kDO Statements RescueClause kEND {
            $$ = new BlockStmtNode($2);
            ((BlockStmtNode *) $$)
              ->set_rescue($3);
        }
        | RequireClause kDO Statements kEND {
            $$ = new BlockStmtNode($3);
            ((BlockStmtNode *) $$)
              ->set_require($1);
        }
        | RequireClause kDO Statements RescueClause kEND {
            $$ = new BlockStmtNode($3);
            ((BlockStmtNode *) $$)
              ->set_require($1)
              ->set_rescue($4);
        }
        | kDO Statements EnsureClause kEND {
            $$ = new BlockStmtNode($2);
            ((BlockStmtNode *) $$)
              ->set_ensure($3);
        }
        | kDO Statements RescueClause EnsureClause kEND {
            $$ = new BlockStmtNode($2);
            ((BlockStmtNode *) $$)
              ->set_rescue($3)
              ->set_ensure($4);
        }
        | RequireClause kDO Statements EnsureClause kEND {
            $$ = new BlockStmtNode($3);
            ((BlockStmtNode *) $$)
              ->set_require($1)
              ->set_ensure($4);
        }
        | RequireClause kDO Statements RescueClause EnsureClause kEND {
            $$ = new BlockStmtNode($3);
            ((BlockStmtNode *) $$)
              ->set_require($1)
              ->set_rescue($4)
              ->set_ensure($5);
        }
        ;

RequireClause
        : kREQUIRE Conditions {
            $$ = $2;
        }
        ;

Conditions
        : Condition {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | Conditions Condition {
            $$->push_back($2);
        }
        ;

Condition
        : LogicExpr ';' {
            $$ = new ConditionNode($1, new RaiseStmtNode(NULL));
        }
        | LogicExpr ':' String ';' {
            $$ = new ConditionNode($1, new RaiseStmtNode($3));
        }
        ;

EnsureClause
        : kENSURE Statements {
            $$ = $2;
        }
        ;

RescueClause
        : kRESCUE RepeatWhenClause {
            $$ = $2;
        }
        | kRESCUE {
            $$ = NULL;
        }
        ;

VisibilityStmt
        : kPRIVATE {
            $$ = new ControlStmtNode(Control::Private, NULL);
        }
        | kPROTECTED {
            $$ = new ControlStmtNode(Control::Protected, NULL);
        }
        | kPUBLIC {
            $$ = new ControlStmtNode(Control::Public, NULL);
        }
        ;

ImportStmt
        : kIMPORT LinkableList {
            $$ = new InlineNode(Inline::Import, $2);
        }
        | kFROM QualifiedId kIMPORT LinkableList {
            $$ = new InlineNode(Inline::Import, $4, $2);
        }
        ;

IncludeStmt
        : kINCLUDE LinkableList {
            $$ = new InlineNode(Inline::Include, $2);
        }
        ;

LinkableList
        : Linkable {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | LinkableList ',' Linkable {
            $$->push_back($3);
        }
        ;

Linkable
        : QualifiedId {
            $$ = $1;
        }
        | String {
            $$ = $1;
        }
        ;

VarStmt
        : kVAR Identifier
        | kVAR Identifier InvariantsClause
        | kVAR Identifier Setter
        | kVAR Identifier Setter InvariantsClause
        | kVAR Identifier Getter
        | kVAR Identifier Getter InvariantsClause
        | kVAR Identifier Getter Setter
        | kVAR Identifier Getter Setter InvariantsClause
        | kVAR Identifier '=' AssignValue
        | kVAR Identifier '=' AssignValue InvariantsClause
        | kVAR Identifier '=' AssignValue Setter
        | kVAR Identifier '=' AssignValue Setter InvariantsClause
        | kVAR Identifier '=' AssignValue Getter
        | kVAR Identifier '=' AssignValue Getter InvariantsClause
        | kVAR Identifier '=' AssignValue Getter Setter
        | kVAR Identifier '=' AssignValue Getter Setter InvariantsClause
        | kVAR Identifier ':' QualifiedId
        | kVAR Identifier ':' QualifiedId InvariantsClause
        | kVAR Identifier ':' QualifiedId Setter
        | kVAR Identifier ':' QualifiedId Setter InvariantsClause
        | kVAR Identifier ':' QualifiedId Getter
        | kVAR Identifier ':' QualifiedId Getter InvariantsClause
        | kVAR Identifier ':' QualifiedId Getter Setter
        | kVAR Identifier ':' QualifiedId Getter Setter InvariantsClause
        | kVAR Identifier ':' QualifiedId '=' AssignValue
        | kVAR Identifier ':' QualifiedId '=' AssignValue InvariantsClause
        | kVAR Identifier ':' QualifiedId '=' AssignValue Setter
        | kVAR Identifier ':' QualifiedId '=' AssignValue Setter InvariantsClause
        | kVAR Identifier ':' QualifiedId '=' AssignValue Getter
        | kVAR Identifier ':' QualifiedId '=' AssignValue Getter InvariantsClause
        | kVAR Identifier ':' QualifiedId '=' AssignValue Getter Setter
        | kVAR Identifier ':' QualifiedId '=' AssignValue Getter Setter InvariantsClause
        ;

Getter
        : kGET
        | kGET Identifier
        | kGET LambdaExpr
        ;

Setter
        : kSET
        | kSET Identifier
        | kSET LambdaExpr
        ;

InvariantsClause
        : kINVARIANTS LogicExpr
        | kINVARIANTS LogicExpr ':' String
        ;

ConstStmt
        : kCONST Identifier '=' AssignValue
        | kCONST Identifier ':' QualifiedId '=' AssignValue
        ;

EventStmt
        : kEVENT Identifier
        | kEVENT Identifier '=' AssignValue
        | kEVENT Identifier InterceptClause
        | kEVENT Identifier InterceptClause '=' AssignValue
        | kEVENT Identifier ':' QualifiedId
        | kEVENT Identifier ':' QualifiedId '=' AssignValue
        | kEVENT Identifier ':' QualifiedId InterceptClause
        | kEVENT Identifier ':' QualifiedId InterceptClause '=' AssignValue
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

FunctionStmt
        : kDEF Identifier
        | kDEF Identifier InterceptClause
        | kDEF Identifier ':' QualifiedId
        | kDEF Identifier ':' QualifiedId InterceptClause
        | kDEF Identifier FormalParams
        | kDEF Identifier FormalParams InterceptClause
        | kDEF Identifier FormalParams ':' QualifiedId
        | kDEF Identifier FormalParams ':' QualifiedId InterceptClause
        ;

FormalParams
        : '(' ')'
        | '(' FormalParamList ')'
        ;

FormalParamList
        : FormalParam
        | FormalParamList ',' FormalParam
        ;

FormalParam
        : Identifier ':' QualifiedId
        | Identifier ':' QualifiedId InvariantsClause
        | Identifier ':' QualifiedId '=' AssignValue
        | Identifier ':' QualifiedId '=' AssignValue InvariantsClause
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
