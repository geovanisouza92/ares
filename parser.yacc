
%{
#include <vector>

using namespace std;

#include "driver.h"
#include "st.h"
#include "stoql.h"

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
    SyntaxTree::SyntaxNode *        v_node;
    SyntaxTree::VectorNode *        v_list;
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
// %token  kDEF        "def"
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
%token  kMETHOD     "method"
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
%token  kYIELD      "yield"

%token  '='     "="
%token  sADE    "+="
%token  sSUE    "-="
%token  sMUE    "*="
%token  sDIE    "/="

%token  sDEF    "=>"
%token  '?'     "?"
%token  ':'     ":"
%token  sEQL    "=="
%token  sIDE    "==="
%token  sNID    "!=="
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

%left   sEQL sIDE sNID sNEQ sLEE sGEE sDOT2 sDOT3 sPOW sADE sSUE sMUE sDIE sDEF
%left   kAND kOR kXOR kIMPLIES
%left   '=' '?' ':' '<' '>' '+' '-' '*' '/' '|'
%right  UNARY

%type   <v_node>    Value
%type   <v_node>    String
%type   <v_node>    Identifier
%type   <v_node>    Array
%type   <v_node>    Hash
%type   <v_node>    NamedExpression
%type   <v_node>    QualifiedId
%type   <v_node>    FunctionCall
%type   <v_node>    ParamValue
%type   <v_node>    SuffixExpr
%type   <v_node>    PrefixExpr
%type   <v_node>    PowerExpr
%type   <v_node>    MultExpr
%type   <v_node>    AddExpr
%type   <v_node>    RangeExpr
%type   <v_node>    ComparisonExpr
%type   <v_node>    LogicExpr
%type   <v_node>    TernaryExpr
%type   <v_node>    AssignValue
%type   <v_node>    AssignExpr
%type   <v_node>    LambdaExpr

%type   <v_node>    Expression

%type   <v_node>    QueryExpr
%type   <v_node>    QueryBody
%type   <v_node>    QueryOrigin
%type   <v_node>    QueryBodyClause
%type   <v_node>    WhereClause
%type   <v_node>    JoinClause
%type   <v_node>    OrderByClause
%type   <v_node>    OrderingItem
%type   <v_node>    RangeClause
%type   <v_node>    SelectsOrGroupClause
%type   <v_node>    GroupByClause
%type   <v_node>    SelectClause

%type   <v_list>    ExpressionList
%type   <v_list>    NamedExpressionList
%type   <v_list>    ParamValueList
%type   <v_list>    FormalParamList
%type   <v_list>    VariableList

%type   <v_list>    QueryBodyClauseRepeat
%type   <v_list>    OrderingItemList


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

Statements
        : Statement
        | Statements Statement
        ;

Statement
        : VariableDecl ';'
        | ConstantDecl ';'
        | StatementBlock
        | ConditionalStatement
        | CaseStatement
        | ForStatement
        | LoopStatement
        | AsyncStatement
        | RaiseStatement ';'
        | ExitStatement ';'
        | ReturnStatement ';'
        | IncludeStatement ';'
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
        | kCLASS Identifier '>' QualifiedId // IdentifierList
        | kABSTRACT kCLASS Identifier
        | kSEALED kCLASS Identifier
        | kABSTRACT kCLASS Identifier '>' QualifiedId // IdentifierList
        | kSEALED kCLASS Identifier '>' QualifiedId // IdentifierList
        | kABSTRACT kSEALED kCLASS Identifier
        | kABSTRACT kSEALED kCLASS Identifier '>' QualifiedId // IdentifierList
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
        | kATTR Identifier ReturnType InitialValue
        | kATTR Identifier ReturnType InitialValue InvariantsClause
        | kATTR Identifier ReturnType InitialValue Setter
        | kATTR Identifier ReturnType InitialValue Setter InvariantsClause
        | kATTR Identifier ReturnType InitialValue Getter
        | kATTR Identifier ReturnType InitialValue Getter InvariantsClause
        | kATTR Identifier ReturnType InitialValue Getter Setter
        | kATTR Identifier ReturnType InitialValue Getter Setter InvariantsClause
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
        : kMETHOD QualifiedId FormalParamList
        | kMETHOD QualifiedId FormalParamList ReturnType
        | kMETHOD QualifiedId FormalParamList InterceptClause
        | kMETHOD QualifiedId FormalParamList ReturnType InterceptClause
        ;

FormalParamList
        : '(' ')' {
            if (!driver.check_only) {
                $$ = new VectorNode();
            }
        }
        // | '(' sDOT3 ')'
        | '(' VariableList ')' {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        // | '(' VariableList ',' sDOT3 ')'
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
        | Identifier InitialValue
        | Identifier InitialValue InvariantsClause
        | Identifier ReturnType
        | Identifier ReturnType InvariantsClause
        | Identifier ReturnType InitialValue
        | Identifier ReturnType InitialValue InvariantsClause
        ;

InitialValue
        : '=' AssignValue
        | '=' AssignValue ControlExpr
        ;

ConstantDecl
        : kCONST ConstantList
        ;

ConstantList
        : Constant
        | ConstantList ',' Constant
        ;

Constant
        : Identifier InitialValue
        | Identifier ReturnType InitialValue
        ;

StatementBlock
        : kBEGIN kEND
        | kBEGIN Statements kEND
        | kBEGIN Statements EnsureClause kEND
        | kBEGIN Statements RescueClause kEND
        | kBEGIN Statements RescueClause EnsureClause kEND
        | RequireClause kBEGIN Statements kEND
        | RequireClause kBEGIN Statements EnsureClause kEND
        | RequireClause kBEGIN Statements RescueClause kEND
        | RequireClause kBEGIN Statements RescueClause EnsureClause kEND
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
        | kENSURE Statements
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

ConditionalStatement
        : IfClause ThenClause
        | IfClause ThenClause ElseClause
        | IfClause ThenClause ElifStatementRepeat
        | IfClause ThenClause ElifStatementRepeat ElseClause
        | UnlessClause ThenClause
        | UnlessClause ThenClause ElseClause
        | UnlessClause ThenClause ElifStatementRepeat
        | UnlessClause ThenClause ElifStatementRepeat ElseClause
        ;

IfClause
        : kIF Expression
        | kIF Expression WhereClause
        ;

UnlessClause
        : kUNLESS Expression
        | kUNLESS Expression WhereClause
        ;

ThenClause
        : kTHEN Statement
        ;

ElifStatementRepeat
        : ElifStatement
        | ElifStatementRepeat ElifStatement
        ;

ElifStatement
        : kELIF Expression kTHEN Statement
        | kELIF Expression kTHEN Statement kELSE Statement
        ;

ElseClause
        : kELSE Statement
        ;

CaseStatement
        : kCASE Expression kEND
        | kCASE Expression kELSE Statement kEND
        | kCASE Expression WhenExpressionRepeat kEND
        | kCASE Expression WhenExpressionRepeat kELSE Statement kEND
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
        | YieldStatement ';'
        | kBREAK ';'
        | kCONTINUE ';'
        ;

YieldStatement
        : kYIELD
        | kYIELD Expression
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
        : LambdaExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | AssignExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        // TODO Criar nó: $2 then $1 else nil
        | AssignExpr ControlExpr
        | TernaryExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | QueryExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        ;

LambdaExpr // TODO Escolher apenas uma maneira de escrever lambda expressions
        : kLAMBDA FormalParamList '(' Expression ')' {
            if (!driver.check_only) {
                $$ = new LambdaExprNode($2, $4);
            }
        }
        | kLAMBDA FormalParamList sDEF Expression {
            if (!driver.check_only) {
                $$ = new LambdaExprNode($2, $4);
            }
        }
        ;

AssignExpr
        : QualifiedId '=' AssignValue {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAssign, $1, $3);
            }
        }
        | QualifiedId sADE AssignValue {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAde, $1, $3);
            }
        }
        | QualifiedId sSUE AssignValue {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinarySue, $1, $3);
            }
        }
        | QualifiedId sMUE AssignValue {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryMue, $1, $3);
            }
        }
        | QualifiedId sDIE AssignValue {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryDie, $1, $3);
            }
        }
        ;

AssignValue
        : Expression {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kASYNC Expression {
            if (!driver.check_only) {
                $$ = new AsyncNode($2);
            }
        }
        | StatementBlock /* {
            if (!driver.check_only) {
                $$ = $1;
            }
        } */
        | kASYNC StatementBlock /* {
            if (!driver.check_only) {
                $$ = new AsyncNode($2);
            }
        } */
        ;

ControlExpr
        : kIF Expression
        | kUNLESS Expression
        // | kFOR QueryOrigin kWHERE Expression
        ;

TernaryExpr
        : LogicExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | TernaryExpr '?' Expression ':' Expression {
            if (!driver.check_only) {
                $$ = new TernaryExprNode(Operation::TernaryIf, $1, $3, $5);
            }
        }
        | TernaryExpr kBETWEEN ComparisonExpr kAND ComparisonExpr {
            if (!driver.check_only) {
                // TODO Criar nó : $1 GEE $3 AND $1 LEE $1
                $$ = new TernaryExprNode(Operation::TernaryBetween, $1, $3, $5);
            }
        }
        ;

LogicExpr
        : ComparisonExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | LogicExpr kAND ComparisonExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAnd, $1, $3);
            }
        }
        | LogicExpr kOR ComparisonExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryOr, $1, $3);
            }
        }
        | LogicExpr kXOR ComparisonExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryXor, $1, $3);
            }
        }
        | LogicExpr kIMPLIES ComparisonExpr {
            if (!driver.check_only) {
                // TODO Criar nó : NOT $1 OR $3
                $$ = new BinaryExprNode(Operation::BinaryImplies, $1, $3);
            }
        }
        ;

// TODO simultaneous comparison

ComparisonExpr
        : RangeExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | RangeExpr '<' RangeExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryGet, $1, $3);
            }
        }
        | RangeExpr sLEE RangeExpr {
            if (!driver.check_only) {
                // TODO Criar nó : LET OR EQL
                $$ = new BinaryExprNode(Operation::BinaryLee, $1, $3);
            }
        }
        | RangeExpr '>' RangeExpr {
            if (!driver.check_only) {
                // TODO Criar nó : NOT LET
                $$ = new BinaryExprNode(Operation::BinaryGet, $1, $3);
            }
        }
        | RangeExpr sGEE RangeExpr {
            if (!driver.check_only) {
                // TODO Criar nó para NOT LET OR EQL
                $$ = new BinaryExprNode(Operation::BinaryGee, $1, $3);
            }
        }
        | RangeExpr sEQL RangeExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryEql, $1, $3);
            }
        }
        | RangeExpr sNEQ RangeExpr {
            if (!driver.check_only) {
                // TODO Criar nó : NOT EQL
                $$ = new BinaryExprNode(Operation::BinaryNeq, $1, $3);
            }
        }
        | RangeExpr sIDE RangeExpr {
            if (!driver.check_only) {
                // TODO Criar nó : EQL AND IS
                $$ = new BinaryExprNode(Operation::BinaryIde, $1, $3);
            }
        }
        | RangeExpr sNID RangeExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryNid, $1, $3);
            }
        }
        | RangeExpr sMAT RangeExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryMat, $1, $3);
            }
        }
        | RangeExpr sNMA RangeExpr {
            if (!driver.check_only) {
                // TODO Criar nó : NOT MAT
                $$ = new BinaryExprNode(Operation::BinaryNma, $1, $3);
            }
        }
        | RangeExpr kHAS RangeExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryIn, $3, $1);
            }
        }
        | RangeExpr kIN RangeExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryIn, $1, $3);
            }
        }
        ;

RangeExpr
        : AddExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | RangeExpr sDOT2 AddExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryRangeOut, $1, $3);
            }
        }
        | RangeExpr sDOT3 AddExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryRangeIn, $1, $3);
            }
        }
        ;

AddExpr
        : MultExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | AddExpr '+' MultExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAdd, $1, $3);
            }
        }
        | AddExpr '-' MultExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinarySub, $1, $3);
            }
        }
        ;

MultExpr
        : PowerExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | MultExpr '*' PowerExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryMul, $1, $3);
            }
        }
        | MultExpr '/' PowerExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryDiv, $1, $3);
            }
        }
        | MultExpr '%' PowerExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryMod, $1, $3);
            }
        }
        // | MultExpr QualifiedId
        ;

PowerExpr
        : PrefixExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | PowerExpr sPOW PrefixExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryPow, $1, $3);
            }
        }
        ;

PrefixExpr
        : SuffixExpr {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kNOT PrefixExpr %prec UNARY {
            if (!driver.check_only) {
                $$ = new UnaryExprNode(Operation::UnaryNot, $2);
            }
        }
        | '+' PrefixExpr %prec UNARY {
            if (!driver.check_only) {
                $$ = new UnaryExprNode(Operation::UnaryAdd, $2);
            }
        }
        | '-' PrefixExpr %prec UNARY {
            if (!driver.check_only) {
                $$ = new UnaryExprNode(Operation::UnarySub, $2);
            }
        }
        | '(' QualifiedId ')' PrefixExpr %prec UNARY {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryCast, $4, $2);
            }
        }
        | kNEW FunctionCall %prec UNARY {
            if (!driver.check_only) {
                $$ = new UnaryExprNode(Operation::UnaryNew, $2);
            }
        }
        | kNEW kCLASS '(' NamedExpressionList ')' %prec UNARY {
            if (!driver.check_only) {
                $$ = new UnaryExprNode(Operation::UnaryNewClass, $4);
            }
        }
        ;

SuffixExpr
        : Value {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | SuffixExpr '.' FunctionCall {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpr '.' QualifiedId {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpr '[' Expression ']' {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpr '[' Expression ':' ']' {
            if (!driver.check_only) {
                $$ = new TernaryExprNode(Operation::TernarySlice, $$, $3, NULL);
            }
        }
        | SuffixExpr '[' Expression ':' Expression ']' {
            if (!driver.check_only) {
                $$ = new TernaryExprNode(Operation::TernarySlice, $$, $3, $5);
            }
        }
        | SuffixExpr '[' ':' Expression ']' {
            if (!driver.check_only) {
                $$ = new TernaryExprNode(Operation::TernarySlice, $$, NULL, $4);
            }
        }
        ;

Value
        : kNIL {
            if (!driver.check_only) {
                $$ = new NilNode();
            }
        }
        | kSELF {
            if (!driver.check_only) {
                $$ = new IdentifierNode("self");
            }
        }
        | kFALSE {
            if (!driver.check_only) {
                $$ = new BooleanNode(false);
            }
        }
        | kTRUE {
            if (!driver.check_only) {
                $$ = new BooleanNode(true);
            }
        }
        | FLOAT {
            if (!driver.check_only) {
                $$ = new FloatNode($1);
            }
        }
        | INTEGER {
            if (!driver.check_only) {
                $$ = new IntegerNode($1);
            }
        }
        | REGEX {
            if (!driver.check_only) {
                $$ = new RegexNode(*$1);
            }
        }
        | String {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | Array {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | Hash  {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | QualifiedId {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | FunctionCall {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | '(' Expression ')' {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

String
        : STRING {
            if (!driver.check_only) {
                $$ = new StringNode(*$1);
            }
        }
        | String STRING {
            if (!driver.check_only) {
                ((StringNode *) $$)
                  ->append(*$2);
            }
        }
        ;

Array
        : '[' ExpressionList ']' {
            if (!driver.check_only) {
                $$ = new ArrayNode($2);
            }
        }
        // | '[' NamedExpressionList ']'
        | '[' ']' {
            if (!driver.check_only) {
                $$ = new ArrayNode();
            }
        }
        /*
            for $4 do
                if $6 then
                    yield $2;
        */
        /*
            from $4 where $6 select $2;
        */
        | '[' Expression '|' QueryOrigin sDEF LogicExpr ']'
        ;

ExpressionList
        : Expression {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ExpressionList ',' Expression {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

Hash
        : '{' NamedExpressionList '}' {
            if (!driver.check_only) {
                $$ = new HashNode($2);
            }
        }
        | '{' '}' {
            if (!driver.check_only) {
                $$ = new HashNode();
            }
        }
        ;

NamedExpressionList
        : NamedExpression {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | NamedExpressionList ',' NamedExpression {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

NamedExpression
        : Identifier ':' Expression {
            if (!driver.check_only) {
                $$ = new HashPairNode($1, $3);
            }
        }
        | String ':' Expression {
            if (!driver.check_only) {
                $$ = new HashPairNode($1, $3);
            }
        }
        ;

QualifiedId
        : Identifier {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | QualifiedId '.' Identifier {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryAccess, $$, $3);
            }
        }
        ;

Identifier
        : ID {
            if (!driver.check_only) {
                $$ = new IdentifierNode(*$1);
            }
        }
        ;

FunctionCall
        : QualifiedId '(' ')' {
            if (!driver.check_only) {
                $$ = new FunctionCallNode($1, new VectorNode());
            }
        }
        | QualifiedId '(' ParamValueList ')' {
            if (!driver.check_only) {
                $$ = new FunctionCallNode($1, $3);
            }
        }
        ;

ParamValueList
        : ParamValue {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ParamValueList ',' ParamValue {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

ParamValue
        : Expression {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | StatementBlock
        ;

QueryExpr
        : kFROM QueryOrigin QueryBody {
            if (!driver.check_only) {
                $$ = new QueryNode($2, $3);
            }
        }
        | kFROM QueryOrigin {
            if (!driver.check_only) {
                $$ = new QueryNode($2, NULL);
            }
        }
        ;

QueryOrigin
        : Identifier kIN Expression {
            if (!driver.check_only) {
                $$ = new QueryOriginNode($1, $3);
            }
        }
        ;

QueryBody
        : QueryBodyClauseRepeat SelectsOrGroupClause {
            if (!driver.check_only) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_body($1)
                  ->set_finally($2);
            }
        }
        | QueryBodyClauseRepeat {
            if (!driver.check_only) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_body($1);
            }
        }
        | SelectsOrGroupClause {
            if (!driver.check_only) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_finally($1);
            }
        }
        ;

QueryBodyClauseRepeat
        : QueryBodyClause {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | QueryBodyClauseRepeat QueryBodyClause {
            if (!driver.check_only) {
                $$->push_back($2);
            }
        }
        ;

QueryBodyClause
        : WhereClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | JoinClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | OrderByClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | RangeClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        ;

WhereClause
        : kWHERE LogicExpr {
            if (!driver.check_only) {
                $$ = new WhereNode($2);
            }
        }
        ;

JoinClause
        : kJOIN QueryOrigin kON LogicExpr {
            if (!driver.check_only) {
                $$ = new JoinNode($2, $4, JoinDirection::None);
            }
        }
        | kLEFT kJOIN QueryOrigin kON LogicExpr {
            if (!driver.check_only) {
                $$ = new JoinNode($3, $5, JoinDirection::Left);
            }
        }
        | kRIGHT kJOIN QueryOrigin kON LogicExpr {
            if (!driver.check_only) {
                $$ = new JoinNode($3, $5, JoinDirection::Right);
            }
        }
        ;

OrderByClause
        : kORDER kBY OrderingItemList {
            if (!driver.check_only) {
                $$ = new OrderByNode($3);
            }
        }
        ;

OrderingItemList
        : OrderingItem {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | OrderingItemList ',' OrderingItem {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

OrderingItem
        : Expression {
            if (!driver.check_only) {
                $$ = new OrderingNode($1, OrderDirection::None);
            }
        }
        | Expression kASC {
            if (!driver.check_only) {
                $$ = new OrderingNode($1, OrderDirection::Asc);
            }
        }
        | Expression kDESC {
            if (!driver.check_only) {
                $$ = new OrderingNode($1, OrderDirection::Desc);
            }
        }
        ;

RangeClause
        : kSKIP Expression {
            if (!driver.check_only) {
                $$ = new RangeNode(RangeType::Skip, $2);
            }
        }
        | kSTEP Expression {
            if (!driver.check_only) {
                $$ = new RangeNode(RangeType::Step, $2);
            }
        }
        | kTAKE Expression {
            if (!driver.check_only) {
                $$ = new RangeNode(RangeType::Take, $2);
            }
        }
        ;

SelectsOrGroupClause
        : GroupByClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | SelectClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        ;

GroupByClause
        : kGROUP kBY Expression {
            if (!driver.check_only) {
                $$ = new GroupByNode($3);
            }
        }
        ;

SelectClause
        : kSELECT ExpressionList {
            if (!driver.check_only) {
                $$ = new SelectNode($2);
            }
        }
        ;

%%

namespace LANG_NAMESPACE {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // LANG_NAMESPACE

