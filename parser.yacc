
%{
#include <vector>

using namespace std;

#include "driver.h"

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
%token  kAND        "and"
%token  kASYNC      "async"
%token  kASC        "asc"
%token  kATTR       "attr"
%token  kBEFORE     "before"
%token  kBEGIN      "begin"
%token  kBETWEEN    "between"
%token  kBREAK      "break"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCLASS      "class"
%token  kCONST      "const"
%token  kCONTINUE   "continue"
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
%token  kIMPLIES    "implies"
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
%token  kNOT        "not"
%token  kON         "on"
%token  kORDER      "order"
%token  kOR         "or"
%token  kPRIVATE    "private"
%token  kPROTECTED  "protected"
%token  kPUBLIC     "public"
%token  kRAISE      "raise"
%token  kREQUIRE    "require"
%token  kRESCUE     "rescue"
%token  kRETURN     "return"
%token  kRETRY      "retry"
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
%token  kXOR        "xor"
// %token  kYIELD      "yield"

%token  '='     "="
%token  sADE    "+="
%token  sSUE    "-="
%token  sMUE    "*="
%token  sDIE    "/="

%token  '?'     "?"
%token  ':'     ":"
%token  sEQL    "=="
%token  sIDE    "==="
%token  sNEQ    "!="
%token  '<'     "<"
%token  sLEE    "<="
%token  '>'     ">"
%token  sGEE    ">="
%token  sMAT    "=~"
%token  sNMA    "!~"
%token  sDOT2   ".."
%token  sDOT3   "..."
%token  '+'     "+"
%token  '-'     "-"
%token  '*'     "*"
%token  '/'     "/"
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

%left   sEQL sIDE sNEQ sLEE sGEE sDOT2 sDOT3 sPOW sADE sSUE sMUE sDIE
%left   kAND kOR kXOR kIMPLIES
%left   '=' '?' ':' '<' '>' '+' '-' '*' '/'
%right  UNARY

%%

Program
        : /* empty */ {
            driver.dec_lines();
            driver.warning("Nothing to do here.");
        }
        | TopStatements
        ;

TopStatements
        : TopStatement
        | TopStatements TopStatement
        ;

TopStatement
        : Statement
        | ModuleDecl
        | ImportStatement ';'
        | ClassDecl ';'
        | ClassDecl StatementsForClass kEND
        | FunctionDecl ';'
        | FunctionDecl StatementBlock
        ;

// Statements
//         : Statement
//         | Statements Statement
//         ;

Statement
        : VariableDecl ';'
        | ConstantDecl ';'
        | StatementBlock
        | IfStatement
        | UnlessStatement
        | CaseStatement
        | ForStatement
        | LoopStatement
        | AsyncStatement
        | RaiseStatement ';'
        | ReturnStatement ';'
        | Expression ';'
        ;

ModuleDecl
        : kMODULE QualifiedId kEND
        | kMODULE QualifiedId TopStatements kEND
        ;

ImportStatement
        : kIMPORT IdentifierList
        | kFROM String kIMPORT IdentifierList
        | kFROM QualifiedId kIMPORT IdentifierList
        ;

IncludeStatement
        : kINCLUDE QualifiedId
        ;

ClassDecl
        : kCLASS Identifier
        | kCLASS Identifier '>' IdentifierList
        | kABSTRACT kCLASS Identifier
        | kSEALED kCLASS Identifier
        | kABSTRACT kCLASS Identifier '>' IdentifierList
        | kSEALED kCLASS Identifier '>' IdentifierList
        ;

StatementsForClass
        : StatementForClass
        | StatementsForClass StatementForClass
        ;

StatementForClass
        : TopStatement
        | VisibilityStatement
        | AttributeDecl ';'
        | EventDecl ';'
        ;

VisibilityStatement
        : kPRIVATE
        | kPROTECTED
        | kPUBLIC
        ;

AttributeDecl
        : kATTR Identifier ReturnType
        | kATTR Identifier ReturnType InvariantsClause
        | kATTR Identifier ReturnType Setter
        | kATTR Identifier ReturnType Setter InvariantsClause
        | kATTR Identifier ReturnType Getter
        | kATTR Identifier ReturnType Getter InvariantsClause
        | kATTR Identifier ReturnType Getter Setter
        | kATTR Identifier ReturnType Getter Setter InvariantsClause
        | kATTR Identifier ReturnType '=' AssignValue
        | kATTR Identifier ReturnType '=' AssignValue InvariantsClause
        | kATTR Identifier ReturnType '=' AssignValue Setter
        | kATTR Identifier ReturnType '=' AssignValue Setter InvariantsClause
        | kATTR Identifier ReturnType '=' AssignValue Getter
        | kATTR Identifier ReturnType '=' AssignValue Getter InvariantsClause
        | kATTR Identifier ReturnType '=' AssignValue Getter Setter
        | kATTR Identifier ReturnType '=' AssignValue Getter Setter InvariantsClause
        ;

InvariantsClause
        : kINVARIANTS Condition
        ;

Getter
        : kGET
        | kGET QualifiedId
        ;

Setter
        : kSET
        | kSET QualifiedId
        ;

EventDecl
        : kEVENT Identifier
        | kEVENT Identifier '=' StatementBlock
        | kEVENT Identifier '=' QualifiedId
        | kEVENT Identifier InterceptClause
        | kEVENT Identifier InterceptClause '=' StatementBlock
        | kEVENT Identifier InterceptClause '=' QualifiedId
        ;

FunctionDecl
        : kDEF QualifiedId FormalParams ReturnType
        | kDEF QualifiedId FormalParams ReturnType InterceptClause
        ;

FormalParams
        : '(' ')'
        | '(' VariableList ')'
        ;

ReturnType
        : ':' QualifiedId
        | ':' QualifiedId ArrayTails
        ;

ArrayTails
        : ArrayTail
        | ArrayTails ArrayTail
        ;

ArrayTail
        : '[' ']'
        | '[' INTEGER ']'
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

VariableDecl
        : kVAR VariableList
        ;

VariableList
        : Variable
        | VariableList ',' Variable
        ;

Variable
        : Identifier
        | Identifier InvariantsClause
        | Identifier '=' AssignValue
        | Identifier '=' AssignValue InvariantsClause
        | Identifier ReturnType
        | Identifier ReturnType InvariantsClause
        | Identifier ReturnType '=' AssignValue
        | Identifier ReturnType '=' AssignValue InvariantsClause
        ;

ConstantDecl
        : kCONST ConstantList
        ;

ConstantList
        : Constant
        | ConstantList ',' Constant
        ;

Constant
        : Identifier '=' AssignValue
        | Identifier ReturnType '=' AssignValue
        ;

StatementBlock
        : kBEGIN kEND
        | kBEGIN StatementsForBlock kEND
        | kBEGIN StatementsForBlock EnsureClause kEND
        | kBEGIN StatementsForBlock RescueClause kEND
        | kBEGIN StatementsForBlock RescueClause EnsureClause kEND
        | RequireClause kBEGIN StatementsForBlock kEND
        | RequireClause kBEGIN StatementsForBlock EnsureClause kEND
        | RequireClause kBEGIN StatementsForBlock RescueClause kEND
        | RequireClause kBEGIN StatementsForBlock RescueClause EnsureClause kEND
        ;

StatementsForBlock
        : StatementForBlock
        | StatementsForBlock StatementForBlock
        ;

StatementForBlock
        : Statement
        | IncludeStatement ';'
        | ExitStatement ';'
        ;

RequireClause
        : kREQUIRE
        | kREQUIRE Conditions
        ;

Conditions
        : Condition ';'
        | Conditions Condition ';'
        ;

Condition
        : LogicExpr
        | LogicExpr RaiseStatement
        ;

EnsureClause
        : kENSURE
        | kENSURE StatementsForBlock
        ;

RescueClause
        : kRESCUE
        | kRESCUE WhenRescueRepeat
        ;

WhenRescueRepeat
        : WhenRescue
        | WhenRescueRepeat WhenRescue
        ;

WhenRescue
        : kWHEN Expression kDO StatementsForRescue
        ;

StatementsForRescue
        : StatementForRescue
        | StatementsForRescue StatementForRescue
        ;

StatementForRescue
        : Statement
        | RetryStatement ';'
        ;

RetryStatement
        : kRETRY
        | kRETRY INTEGER
        ;

IfStatement
        : kIF Expression kTHEN Statement
        | kIF Expression kTHEN Statement ElifStatementRepeat
        | kIF Expression kTHEN Statement kELSE Statement
        ;

ElifStatementRepeat
        : ElifStatement
        | ElifStatementRepeat ElifStatement
        ;

ElifStatement
        : kELIF Expression kTHEN Statement
        | kELIF Expression kTHEN Statement kELSE Statement
        ;

UnlessStatement
        : kUNLESS Expression kTHEN Statement
        | kUNLESS Expression kTHEN Statement kELSE Statement
        ;

CaseStatement
        : kCASE Expression WhenExpressionRepeat kEND
        ;

WhenExpressionRepeat
        : WhenExpression
        | WhenExpressionRepeat WhenExpression
        ;

WhenExpression
        : kWHEN Expression kDO Statement
        ;

ForStatement
        : kFOR Expression kASC Expression kDO StatementForLoop
        | kFOR Expression kASC Expression kSTEP Expression kDO StatementForLoop
        | kFOR Expression kDESC Expression kDO StatementForLoop
        | kFOR Expression kDESC Expression kSTEP Expression kDO StatementForLoop
        | kFOR QueryOrigin kDO StatementForLoop
        // | kFOREACH QueryOrigin kDO StatementForLoop
        ;

StatementForLoop
        : Statement
        | kBREAK ';'
        | kCONTINUE ';'
        ;

LoopStatement
        : kWHILE Expression kDO StatementForLoop
        | kUNTIL Expression kDO StatementForLoop
        ;

AsyncStatement
        : kASYNC Statement
        ;

RaiseStatement
        : kRAISE
        | kRAISE String
        | kRAISE FunctionCall
        ;

ExitStatement
        : kEXIT
        | kEXIT Expression
        ;

ReturnStatement
        : kRETURN
        | kRETURN Expression
        ;

Expression
        : LambdaExpr
        | AssignExpr
        | TernaryExpr
        | QueryExpr
        ;

LambdaExpr
        : kLAMBDA FormalParams Expression
        ;

AssignExpr
        : QualifiedId '=' AssignValue
        | QualifiedId sADE AssignValue
        | QualifiedId sSUE AssignValue
        | QualifiedId sMUE AssignValue
        | QualifiedId sDIE AssignValue
        ;

AssignValue
        : Expression
        | kASYNC Expression
        ;

TernaryExpr
        : RangeExpr
        | RangeExpr '?' Expression ':' Expression
        | RangeExpr kBETWEEN RelationalExpr kAND RelationalExpr
        ;

RangeExpr
        : LogicExpr
        | RangeExpr sDOT2 LogicExpr
        | RangeExpr sDOT3 LogicExpr
        ;

LogicExpr
        : RelationalExpr
        | LogicExpr kAND RelationalExpr
        | LogicExpr kOR RelationalExpr
        | LogicExpr kXOR RelationalExpr
        | LogicExpr kIMPLIES RelationalExpr
        ;

RelationalExpr
        : AddExpr
        | AddExpr '<' AddExpr
        | AddExpr sLEE AddExpr
        | AddExpr '>' AddExpr
        | AddExpr sGEE AddExpr
        | AddExpr sEQL AddExpr
        | AddExpr sNEQ AddExpr
        | AddExpr sIDE AddExpr
        | AddExpr sMAT AddExpr
        | AddExpr sNMA AddExpr
        | AddExpr kIN AddExpr
        | AddExpr kIS AddExpr
        | AddExpr kHAS AddExpr
        ;

AddExpr
        : MultExpr
        | AddExpr '+' MultExpr
        | AddExpr '-' MultExpr
        ;

MultExpr
        : PowerExpr
        | MultExpr '*' PowerExpr
        | MultExpr '/' PowerExpr
        | MultExpr '%' PowerExpr
        ;

PowerExpr
        : PrefixExpr
        | PowerExpr sPOW PrefixExpr
        ;

PrefixExpr
        : SuffixExpr
        | kNOT PrefixExpr %prec UNARY
        | '+' PrefixExpr %prec UNARY
        | '-' PrefixExpr %prec UNARY
        | '(' QualifiedId ')' PrefixExpr %prec UNARY
        | kNEW FunctionCall %prec UNARY
        ;

SuffixExpr
        : Value
        | SuffixExpr '.' FunctionCall
        | SuffixExpr '.' QualifiedId
        | SuffixExpr '[' Expression ']'
        | SuffixExpr '[' Expression ':' ']'
        | SuffixExpr '[' Expression ':' Expression ']'
        | SuffixExpr '[' ':' Expression ']'
        ;

Value
        : kNIL
        | kSELF
        | FLOAT
        | INTEGER
        | REGEX
        | kFALSE
        | kTRUE
        | String
        | Array
        | Map
        | QualifiedId
        | FunctionCall
        | '(' Expression ')'
        ;

String
        : STRING
        | String STRING
        ;

Array
        : '[' ExpressionList ']'
        // | '[' NamedExpressionList ']'
        | '[' ']'
        ;

ExpressionList
        : Expression
        | ExpressionList ',' Expression
        ;

Map
        : '{' NamedExpressionList '}'
        | '{' '}'
        ;

NamedExpressionList
        : NamedExpression
        | NamedExpressionList ',' NamedExpression
        ;

NamedExpression
        : Identifier ':' Expression
        | String ':' Expression
        ;

QualifiedId
        : Identifier
        | QualifiedId '.' Identifier
        ;

Identifier
        : ID
        ;

FunctionCall
        : QualifiedId '(' ')'
        | QualifiedId '(' ParamValueList ')'
        ;

ParamValueList
        : ParamValue
        | ParamValueList ',' ParamValue
        ;

ParamValue
        : Expression
        | StatementBlock
        ;

QueryExpr
        : kFROM QueryOrigin QueryBody
        | kFROM QueryOrigin
        ;

QueryOrigin
        : Identifier kIN Expression
        ;

QueryBody
        : QueryBodyClauses SelectsORGroupClause
        | QueryBodyClauses
        | SelectsORGroupClause
        ;

QueryBodyClauses
        : QueryBodyClause
        | QueryBodyClauses QueryBodyClause
        ;

QueryBodyClause
        : WhereClause
        | JoinClause
        | OrderByClause
        | RangeClause
        ;

WhereClause
        : kWHERE LogicExpr
        ;

JoinClause
        : kJOIN QueryOrigin kON LogicExpr
        | kLEFT kJOIN QueryOrigin kON LogicExpr
        | kRIGHT kJOIN QueryOrigin kON LogicExpr
        ;

OrderByClause
        : kORDER kBY OrderingItems
        ;

OrderingItems
        : OrderingItem
        | OrderingItems ',' OrderingItem
        ;

OrderingItem
        : Expression
        | Expression kASC
        | Expression kDESC
        ;

RangeClause
        : kSKIP Expression
        | kSTEP Expression
        | kTAKE Expression
        ;

SelectsORGroupClause
        : GroupByClause
        | SelectClause
        ;

GroupByClause
        : kGROUP kBY Expression
        ;

SelectClause
        : kSELECT ExpressionList
        ;

%%

namespace LANG_NAMESPACE {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // LANG_NAMESPACE

