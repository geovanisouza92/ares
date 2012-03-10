
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

%token  kABSTRACT   "abstract"
%token  kAFTER      "after"
%token  kASYNC      "async"
%token  kASC        "asc"
%token  kAS         "as"
%token  kATTR       "attr"
%token  kBEFORE     "before"
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
%token  sBETWEEN"<=>"
%token  sDOT2   ".."
%token  sDOT3   "..."
%token  sAND    "&&"
%token  sOR     "||"
%token  '^'     "^"
%token  sIMPLIES"=>"
%token  sEQL    "=="
%token  sNEQ    "!="
%token  sMAT    "=~"
%token  sNMA    "!~"
%token  '<'     "<"
%token  sLEE    "<="
%token  '>'     ">"
%token  sGEE    ">="
%token  sSHL    "<<"
%token  sSHR    ">>"
%token  '+'     "+"
%token  '-'     "-"
%token  '*'     "*"
%token  '/'     "/"
%token  '%'     "%"
%token  '\\'    "\\"
%token  '!'     "!"
%token  sPOW    "**"
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

%left   '?' ':' sOR sAND ssIMPLIES sEQL sNEQ sMAT sNMA '>' '<' sLEE sGEE sSHL sSHR
%left   '+' '-' '*' '/' '%' POW sDOT2 sDOT3 kIN kIS '.' '['
%right  UNARY '=' sADE  sSUE  sMUE  sDIE  ']'

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
%type   <v_node>    ArrayAccessInfo
%type   <v_node>    SuffixExpr
%type   <v_node>    PrefixExpr
%type   <v_node>    MultExpr
%type   <v_node>    AddExpr
%type   <v_node>    ShiftExpr
%type   <v_node>    RelatExpr
%type   <v_node>    LogicExpr
%type   <v_node>    RansGEExpr
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
        | kSELF {
            $$ = new IdentifierNode("self");
        }
        ;

QualifiedId
        : Identifier {
            $$ = $1;
        }
        | QualifiedId '.' '*'
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
        | SuffixExpr '[' ArrayAccessInfo ']' {
            $$ = new BinaryExprNode(Operation::BinaryAccess, $1, $3);
        }
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
        | kNEW PrefixExpr %prec UNARY {
            $$ = new UnaryExprNode(Operation::UnaryNew, $2);
        }
        | kNEW kCLASS '(' NamedExprList ')'
        ;

CastExpr
        : PrefixExpr {
            $$ = $1;
        }
        | CastExpr kAS QualifiedId {
            $$ = new BinaryExprNode(Operation::BinaryCast, $1, $3);
        }
        | '(' QualifiedId ')' CastExpr {
            $$ = new BinaryExprNode(Operation::BinaryCast, $4, $2);
        }
        ;

PowerExpr
        : CastExpr {
            $$ = $1;
        }
        | PowerExpr sPOW CastExpr {
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
        | MultExpr '\\' PowerExpr {
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

RelatExpr
        : ShiftExpr {
            $$ = $1;
        }
        | RelatExpr '<' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryLet, $1, $3);
        }
        | RelatExpr sLEE ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryLee, $1, $3);
        }
        | RelatExpr '>' ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryGet, $1, $3);
        }
        | RelatExpr sGEE ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryGee, $1, $3);
        }
        | RelatExpr sEQL ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryEql, $1, $3);
        }
        | RelatExpr sNEQ ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryNeq, $1, $3);
        }
        | RelatExpr kIS ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryIs, $1, $3);
        }
        | RelatExpr '!' kIS ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryNis, $1, $4);
        }
        | RelatExpr kIN ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryIn, $1, $3);
        }
        | RelatExpr kHAS ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryHas, $3, $1);
        }
        | RelatExpr sMAT ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryMat, $1, $3);
        }
        | RelatExpr sNMA ShiftExpr {
            $$ = new BinaryExprNode(Operation::BinaryNma, $1, $3);
        }
        ;

LogicExpr
        : RelatExpr {
            $$ = $1;
        }
        | LogicExpr sAND RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryAnd, $1, $3);
        }
        | LogicExpr sOR RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryOr, $1, $3);
        }
        | LogicExpr '^' RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryXor, $1, $3);
        }
        | LogicExpr sIMPLIES RelatExpr {
            $$ = new BinaryExprNode(Operation::BinaryImplies, $1, $3);
        }
        ;

RansGEExpr
        : LogicExpr {
            $$ = $1;
        }
        | RansGEExpr sDOT2 LogicExpr {
            $$ = new BinaryExprNode(Operation::BinaryDot2, $1, $3);
        }
        | RansGEExpr sDOT3 LogicExpr {
            $$ = new BinaryExprNode(Operation::BinaryDot3, $1, $3);
        }
        ;

TernaryExpr
        : RansGEExpr {
            $$ = $1;
        }
        | RansGEExpr '?' Expression ':' Expression {
            $$ = new TernaryExprNode(Operation::TernaryIf, $1, $3, $5);
        }
        | RansGEExpr sBETWEEN RelatExpr sAND RelatExpr {
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
        : IfClause ThenClause kEND
        | IfClause ThenClause RepeatElifClause kEND
        | IfClause ThenClause ElseClause kEND
        | IfClause ThenClause RepeatElifClause ElseClause kEND
        ;

IfClause
        : kIF Expression
        | kIF Expression WhereClause
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
        | kELIF Expression WhereClause ThenClause
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

FsORStmt
        : kFOR Expression kASC Expression BlockStmt
        | kFOR Expression kDESC Expression BlockStmt
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
        : kASYNC Expression
        // | kASYNC Statement
        ;

RaiseStmt
        : kRAISE
        | kRAISE String
        | kRAISE kNEW PrefixExpr
        ;

ControlStmt
        : kBREAK
        | kEXIT
        | kEXIT Expression
        | kYIELD
        | kYIELD Expression
        ;

BlockStmt
        : kDO kEND
        | kDO Statements kEND
        | kDO Statements RescueClause kEND
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

IncludeStmt
        : kINCLUDE ListLinkable
        ;

ImportStmt
        : kIMPORT ListLinkable
        | kFROM QualifiedId kIMPORT ListLinkable
        ;

ListLinkable
        : Linkable
        | ListLinkable ',' Linkable
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
        | Identifier InitialValue
        | Identifier MemberType
        | Identifier MemberType InitialValue
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
        : Identifier InterceptClause InitialValue
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
        | Identifier MemberType Getter
        | Identifier MemberType Getter Setter
        ;

Getter
        : kGET
        | kGET QualifiedId
        ;

Setter
        : kSET
        | kSET QualifiedId
        ;

FunctionStmt
        : kDEF Identifier
        | kDEF Identifier FormalParams
        | kDEF Identifier InterceptClause
        | kDEF Identifier FormalParams InterceptClause
        | kDEF Identifier MemberType
        | kDEF Identifier FormalParams MemberType
        | kDEF Identifier MemberType InterceptClause
        | kDEF Identifier FormalParams MemberType InterceptClause
        ;

FormalParams
        : '(' ListVariable ')'
        ;

ClassStmt
        : kCLASS Identifier
        | kCLASS Identifier Heritance
        | ClassModifier kCLASS Identifier
        | ClassModifier kCLASS Identifier Heritance
        ;

ClassModifier
        : kABSTRACT
        | kSEALED
        ;

Heritance
        : '>' IdentifierList
        ;

ModuleStmt
        : kMODULE QualifiedId BlockStmt
        ;

TypeStmt
        : VisibilityStmt
        | IncludeStmt ';'
        | ImportStmt ';'
        | VarStmt ';'
        | ConstStmt ';'
        | EventStmt ';'
        | AttrStmt ';'
        | FunctionStmt ';'
        | FunctionStmt BlockStmt
        | ClassStmt ';'
        | ClassStmt BlockStmt
        | ModuleStmt
        ;

Statement
        : IfStmt
        | UnlessStmt
        | CaseStmt
        | FsORStmt
        | LoopStmt
        | BlockStmt
        | AsyncStmt ';'
        | RaiseStmt ';'
        | ControlStmt ';'
        | Expression ';'
        | TypeStmt
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
