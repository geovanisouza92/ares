
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
%start Program
%skeleton "lalr1.cc"
%define namespace "Ares::Compiler"
%define "parser_class_name" "Parser"
%parse-param { class Driver& driver }
%lex-param { class Driver& driver }
%locations
%error-verbose
%initial-action {
    @$.begin.filename = @$.end.filename = &driver.origin;
    driver.incLines();
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

%token  <v_str> ID         "IdentifierLiteral"
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
%token  kDEF        "def"
%token  kDESC       "desc"
%token  kDO         "do"
%token  kELIF       "elif"
%token  kELSE       "else"
%token  kEND        "end"
%token  kENSURE     "ensure"
%token  kEVENT      "event"
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
%token  kJOIN       "join"
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

%token  '?'     "?"
%token  ':'     ":"
%token  sEQL    "=="
%token  sNEQ    "!="
%token  sIDE    "==="
%token  sNID    "!=="
%token  '<'     "<"
%token  sLEE    "<="
%token  '>'     ">"
%token  sGEE    ">="
%token  sMAT    "=~"
%token  sNMA    "!~"
%token  sRAE    ".."
%token  sRAI    "..."
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

%left   sEQL sIDE sNID sNEQ sLEE sGEE sRAE sRAI sPOW sADE sSUE sMUE sDIE
%left   kAND kOR kXOR kIMPLIES
%left   '=' '?' ':' '<' '>' '+' '-' '*' '/'
%right  UNARY kASYNC

%type   <v_node>    Statement
%type   <v_node>    ModuleDeclaration
%type   <v_node>    ClassDeclaration
%type   <v_node>    ClassMember
%type   <v_node>    VisibilityDeclaration
%type   <v_node>    AbstractClassFunctionDeclaration
%type   <v_node>    InterceptClause
%type   <v_node>    ClassFunctionDeclaration
%type   <v_node>    ReturnType
%type   <v_node>    AttributeDeclaration
%type   <v_node>    InitialValue
%type   <v_node>    AttributeGetter
%type   <v_node>    AttributeSetter
%type   <v_node>    Invariants
%type   <v_node>    Condition
%type   <v_node>    EventDeclaration
%type   <v_node>    FunctionDeclaration
%type   <v_node>    VariableDeclaration
%type   <v_node>    Variable
%type   <v_node>    ConstantDeclaration
%type   <v_node>    Constant
%type   <v_node>    ImportStatement
%type   <v_node>    IncludeStatement
%type   <v_node>    IfStatement
%type   <v_node>    ElifStatement
%type   <v_node>    UnlessStatement
%type   <v_node>    CaseStatement
%type   <v_node>    WhenClause
%type   <v_node>    ForStatement
%type   <v_node>    WhileStatement
%type   <v_node>    UntilStatement
%type   <v_node>    BreakStatement
%type   <v_node>    RaiseStatement
%type   <v_node>    RetryStatement
%type   <v_node>    ReturnStatement
%type   <v_node>    YieldStatement
%type   <v_node>    BlockStatement
%type   <v_node>    Expression
%type   <v_node>    LambdaExpression
%type   <v_node>    AssignmentExpression
%type   <v_node>    AssignmentValue
%type   <v_node>    QueryExpression
%type   <v_node>    QueryOrigin
%type   <v_node>    QueryBody
%type   <v_node>    QueryBodyMember
%type   <v_node>    JoinClause
%type   <v_node>    OrderExpression
%type   <v_node>    RangeClause
%type   <v_node>    SelectOrGroupClause
%type   <v_node>    TernaryExpression
%type   <v_node>    LogicExpression
%type   <v_node>    ComparisonExpression
%type   <v_node>    RangeExpression
%type   <v_node>    AdditionExpression
%type   <v_node>    MultiplicationExpression
%type   <v_node>    PowerExpression
%type   <v_node>    PrefixExpression
%type   <v_node>    SuffixExpression
%type   <v_node>    LiteralValue
%type   <v_node>    BooleanLiteral
%type   <v_node>    FloatLiteral
%type   <v_node>    IntegerLiteral
%type   <v_node>    RegexLiteral
%type   <v_node>    StringLiteral
%type   <v_node>    ArrayLiteral
%type   <v_node>    HashLiteral
%type   <v_node>    NamedExpression
%type   <v_node>    FunctionCall
%type   <v_node>    QualifiedId
%type   <v_node>    IdentifierLiteral

%type   <v_list>    StatementRepeat
%type   <v_list>    ClassMemberRepeat
%type   <v_list>    IdentifierList
%type   <v_list>    FormalParamList
%type   <v_list>    VariableList
%type   <v_list>    ConstantList
%type   <v_list>    ElifStatementRepeat
%type   <v_list>    WhenClauseRepeat
%type   <v_list>    RequireClause
%type   <v_list>    ConditionRepeat
%type   <v_list>    EnsureClause
%type   <v_list>    RescueClause
%type   <v_list>    QueryBodyMemberRepeat
%type   <v_list>    OrderExpressionList
%type   <v_list>    ExpressionList
%type   <v_list>    NamedExpressionList

%%

Program
        : /* empty */ {
            driver.decLines();
            driver.warning("Nothing to do here.");
        }
        | StatementRepeat {
            if (!driver.checkOnly) {
                driver.enviro->putStatements($1);
            }
        }
        ;

StatementRepeat
        : Statement {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | StatementRepeat Statement {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

Statement
        : ModuleDeclaration {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ClassDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ClassDeclaration ClassMemberRepeat kEND {
            if (!driver.checkOnly) {
                ((ClassNode *) $1)
                  ->addMembers($2);
                $$ = $1;
            }
        }
        | FunctionDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | FunctionDeclaration BlockStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | VariableDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ConstantDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | Expression ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | Expression kIF Expression ';' {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $3, $1);
            }
        }
        | Expression kUNLESS Expression ';' {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::Unless, $3, $1);
            }
        }
        | Expression kWHILE Expression ';' {
            if (!driver.checkOnly) {
                $$ = new LoopNode(LoopType::While, $3, $1);
            }
        }
        | Expression kUNTIL Expression ';' {
            if (!driver.checkOnly) {
                $$ = new LoopNode(LoopType::Until, $3, $1);
            }
        }
        | ImportStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | IncludeStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | IfStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC IfStatement {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | UnlessStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC UnlessStatement {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | CaseStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC CaseStatement {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | ForStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC ForStatement {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | WhileStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC WhileStatement {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | UntilStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC UntilStatement {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | RaiseStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RetryStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | BreakStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ReturnStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | YieldStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | BlockStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        ;

ModuleDeclaration
        : kMODULE QualifiedId kEND {
            if (!driver.checkOnly) {
                $$ = new ModuleNode($2);
            }
        }
        | kMODULE QualifiedId StatementRepeat kEND {
            if (!driver.checkOnly) {
                $$ = new ModuleNode($2);
                ((ModuleNode *) $$)
                  ->addStatements($3);
            }
        }
        ;

ClassDeclaration
        : kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($2);
            }
        }
        | kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($2);
                ((ClassNode *) $$)
                  ->setClassHeritance($4);
            }
        }
        | kASYNC kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->setClassHeritance($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kSEALED kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kSEALED kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->setClassHeritance($5)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kSEALED kASYNC kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kSEALED kASYNC kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->setClassHeritance($6)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->setClassHeritance($5)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kASYNC kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->setClassHeritance($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kSEALED kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kABSTRACT kSEALED kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->setClassHeritance($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kABSTRACT kSEALED kASYNC kCLASS IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ClassNode($5);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kSEALED kASYNC kCLASS IdentifierLiteral '>' IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ClassNode($5);
                ((ClassNode *) $$)
                  ->setClassHeritance($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        ;

ClassMemberRepeat
        : ClassMember {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ClassMemberRepeat ClassMember {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

ClassMember
        : VisibilityDeclaration {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AbstractClassFunctionDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ClassFunctionDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ClassFunctionDeclaration BlockStatement {
            if (!driver.checkOnly) {
                ((FunctionNode *) $1)
                  ->setBlock($2);
                $$ = $1;
            }
        }
        | AttributeDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | EventDeclaration ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | IncludeStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        ;

VisibilityDeclaration
        : kPRIVATE {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Private);
            }
        }
        | kPROTECTED {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Protected);
            }
        }
        | kPUBLIC {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Public);
            }
        }
        ;

AbstractClassFunctionDeclaration
        : kABSTRACT kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kASYNC kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($7)
                  ->setFunctionIntercept($8)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        ;

InterceptClause
        : kAFTER IdentifierList {
            if (!driver.checkOnly) {
                $$ = new InterceptNode(InterceptionType::After, $2);
            }
        }
        | kBEFORE IdentifierList {
            if (!driver.checkOnly) {
                $$ = new InterceptNode(InterceptionType::Before, $2);
            }
        }
        | kSIGNAL IdentifierList {
            if (!driver.checkOnly) {
                $$ = new InterceptNode(InterceptionType::Signal, $2);
            }
        }
        ;

IdentifierList
        : QualifiedId {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | IdentifierList ',' QualifiedId {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

ClassFunctionDeclaration
        : kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
            }
        }
        | kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($4);
            }
        }
        | kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($4);
            }
        }
        | kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($4)
                  ->setFunctionIntercept($5);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kASYNC kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        ;

FormalParamList
        : '(' ')' {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
            }
        }
        | '(' VariableList ')' {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

ReturnType
        : ':' QualifiedId {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

AttributeDeclaration
        : kATTR IdentifierLiteral ReturnType {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3);
            }
        }
        | kATTR IdentifierLiteral ReturnType Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInvariants($4);
            }
        }
        | kATTR IdentifierLiteral ReturnType AttributeSetter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeSetter($4);
            }
        }
        | kATTR IdentifierLiteral ReturnType AttributeSetter Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeSetter($4)
                  ->setAttributeInvariants($5);
            }
        }
        | kATTR IdentifierLiteral ReturnType AttributeGetter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4);
            }
        }
        | kATTR IdentifierLiteral ReturnType AttributeGetter Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4)
                  ->setAttributeInvariants($5);
            }
        }
        | kATTR IdentifierLiteral ReturnType AttributeGetter AttributeSetter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4)
                  ->setAttributeSetter($5);
            }
        }
        | kATTR IdentifierLiteral ReturnType AttributeGetter AttributeSetter Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4)
                  ->setAttributeSetter($5)
                  ->setAttributeInvariants($6);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeInvariants($5);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue AttributeSetter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeSetter($5);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue AttributeSetter Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeSetter($5)
                  ->setAttributeInvariants($6);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue AttributeGetter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue AttributeGetter Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5)
                  ->setAttributeInvariants($6);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue AttributeGetter AttributeSetter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5)
                  ->setAttributeSetter($6);
            }
        }
        | kATTR IdentifierLiteral ReturnType InitialValue AttributeGetter AttributeSetter Invariants {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5)
                  ->setAttributeSetter($6)
                  ->setAttributeInvariants($7);
            }
        }
        ;

InitialValue
        : '=' AssignmentValue {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

AttributeGetter
        : kGET {
            if (!driver.checkOnly) {
                $$ = new IdentifierNode("default");
            }
        }
        | kGET QualifiedId {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

AttributeSetter
        : kSET {
            if (!driver.checkOnly) {
                $$ = new IdentifierNode("default");
            }
        }
        | kSET QualifiedId {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

Invariants
        : kINVARIANTS Condition {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

Condition
        : LogicExpression {
            if (!driver.checkOnly) {
                $$ = new ValidationNode($1, NULL);
            }
        }
        | LogicExpression RaiseStatement {
            if (!driver.checkOnly) {
                $$ = new ValidationNode($1, $2);
            }
        }
        ;

EventDeclaration
        : kEVENT IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
            }
        }
        | kEVENT IdentifierLiteral InterceptClause {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
                ((EventNode *) $$)
                  ->setEventIntercept($3);
            }
        }
        ;

FunctionDeclaration
        : kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
            }
        }
        | kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($4);
            }
        }
        | kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($4);
            }
        }
        | kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($4)
                  ->setFunctionIntercept($5);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF IdentifierLiteral FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        ;

VariableDeclaration
        : kVAR VariableList {
            if (!driver.checkOnly) {
                $$ = new VariableNode($2);
            }
        }
        ;

VariableList
        : Variable {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | VariableList ',' Variable {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

Variable
        : IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
            }
        }
        | IdentifierLiteral Invariants {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInvariants($2);
            }
        }
        | IdentifierLiteral InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInitialValue($2);
            }
        }
        | IdentifierLiteral InitialValue Invariants {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInitialValue($2)
                  ->setElementInvariants($3);
            }
        }
        | IdentifierLiteral ReturnType {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2);
            }
        }
        | IdentifierLiteral ReturnType Invariants {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInvariants($3);
            }
        }
        | IdentifierLiteral ReturnType InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInitialValue($3);
            }
        }
        | IdentifierLiteral ReturnType InitialValue Invariants {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInitialValue($3)
                  ->setElementInvariants($4);
            }
        }
        ;

ConstantDeclaration
        : kCONST ConstantList {
            if (!driver.checkOnly) {
                $$ = new ConstantNode($2);
            }
        }
        ;

ConstantList
        : Constant {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ConstantList ',' Constant {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

Constant
        : IdentifierLiteral InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInitialValue($2);
            }
        }
        | IdentifierLiteral ReturnType InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInitialValue($3);
            }
        }
        ;

ImportStatement
        : kIMPORT IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ImportNode($2);
            }
        }
        | kFROM QualifiedId kIMPORT IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ImportNode($4);
                ((ImportNode *) $$)
                  ->setImportOrigin($2);
            }
        }
        ;

IncludeStatement
        : kINCLUDE QualifiedId {
            // TODO Chamar comando do driver
            if (!driver.checkOnly) {
                $$ = new IncludeNode($2);
            }
        }
        ;

IfStatement
        : kIF Expression kTHEN Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
            }
        }
        | kIF Expression kTHEN Statement kELSE Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
                ((ConditionNode *) $$)
                  ->setElse($6);
            }
        }
        | kIF Expression kTHEN Statement ElifStatementRepeat {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
                ((ConditionNode *) $$)
                  ->setElif($5);
            }
        }
        | kIF Expression kTHEN Statement ElifStatementRepeat kELSE Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
                ((ConditionNode *) $$)
                  ->setElif($5)
                  ->setElse($7);
            }
        }
        ;

ElifStatementRepeat
        : ElifStatement {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ElifStatementRepeat ElifStatement {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

ElifStatement
        : kELIF Expression kTHEN Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
            }
        }
        ;

UnlessStatement
        : kUNLESS Expression kTHEN Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::Unless, $2, $4);
            }
        }
        | kUNLESS Expression kTHEN Statement kELSE Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::Unless, $2, $4);
                ((ConditionNode *) $$)
                  ->setElse($6);
            }
        }
        | kUNLESS Expression kTHEN Statement ElifStatementRepeat {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
                ((ConditionNode *) $$)
                  ->setElif($5);
            }
        }
        | kUNLESS Expression kTHEN Statement ElifStatementRepeat kELSE Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
                ((ConditionNode *) $$)
                  ->setElif($5)
                  ->setElse($7);
            }
        }
        ;

CaseStatement
        : kCASE Expression kEND {
            if (!driver.checkOnly) {
                $$ = new CaseNode($2);
            }
        }
        | kCASE Expression kELSE StatementRepeat kEND {
            if (!driver.checkOnly) {
                $$ = new CaseNode($2);
                ((CaseNode *) $$)
                  ->setElse($4);
            }
        }
        | kCASE Expression WhenClauseRepeat kEND {
            if (!driver.checkOnly) {
                $$ = new CaseNode($2);
                ((CaseNode *) $$)
                  ->setWhen($3);
            }
        }
        | kCASE Expression WhenClauseRepeat kELSE StatementRepeat kEND {
            if (!driver.checkOnly) {
                $$ = new CaseNode($2);
                ((CaseNode *) $$)
                  ->setWhen($3)
                  ->setElse($5);
            }
        }
        ;

WhenClauseRepeat
        : WhenClause {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | WhenClauseRepeat WhenClause {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

WhenClause
        : kWHEN Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new WhenNode($2, $4);
            }
        }
        ;

ForStatement
        : kFOR Expression kASC Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::ForAscending, $2, $4, $6);
            }
        }
        | kFOR Expression kASC Expression kSTEP Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::ForAscending, $2, $4, $8);
                ((ForNode *) $$)
                  ->setStep($6);
            }
        }
        | kFOR Expression kDESC Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::ForDescending, $2, $4, $6);
            }
        }
        | kFOR Expression kDESC Expression kSTEP Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::ForDescending, $2, $4, $8);
                ((ForNode *) $$)
                  ->setStep($6);
            }
        }
        | kFOR IdentifierLiteral kIN Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::ForIteration, $2, $4, $6);
            }
        }
        ;

WhileStatement
        : kWHILE Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new LoopNode(LoopType::While, $2, $4);
            }
        }
        ;

UntilStatement
        : kUNTIL Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new LoopNode(LoopType::Until, $2, $4);
            }
        }
        ;

BreakStatement
        : kBREAK {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Break);
            }
        }
        ;

RaiseStatement
        : kRAISE {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Raise);
            }
        }
        | kRAISE StringLiteral {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Raise, $2);
            }
        }
        | kRAISE FunctionCall {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Raise, $2);
            }
        }
        ;

RetryStatement
        : kRETRY {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Retry);
            }
        }
        ;

ReturnStatement
        : kRETURN {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Return);
            }
        }
        | kRETURN Expression {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Return, $2);
            }
        }
        ;

YieldStatement
        : kYIELD {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Yield);
            }
        }
        | kYIELD Expression {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Yield, $2);
            }
        }
        ;

BlockStatement
        : kBEGIN kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode(new VectorNode());
            }
        }
        | kBEGIN StatementRepeat kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
            }
        }
        | kBEGIN StatementRepeat EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
                ((BlockNode *) $$)
                  ->setBlockEnsure($3);
            }
        }
        | kBEGIN StatementRepeat RescueClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
                ((BlockNode *) $$)
                  ->setBlockRescue($3);
            }
        }
        | kBEGIN StatementRepeat RescueClause EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
                ((BlockNode *) $$)
                  ->setBlockRescue($3)
                  ->setBlockEnsure($4);
            }
        }
        | RequireClause kBEGIN StatementRepeat kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1);
            }
        }
        | RequireClause kBEGIN StatementRepeat EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1)
                  ->setBlockEnsure($4);
            }
        }
        | RequireClause kBEGIN StatementRepeat RescueClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1)
                  ->setBlockRescue($4);
            }
        }
        | RequireClause kBEGIN StatementRepeat RescueClause EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1)
                  ->setBlockRescue($4)
                  ->setBlockEnsure($5);
            }
        }
        ;

RequireClause
        : kREQUIRE {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
            }
        }
        | kREQUIRE ConditionRepeat {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

ConditionRepeat
        : Condition ';' {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ConditionRepeat Condition ';' {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

EnsureClause
        : kENSURE {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
            }
        }
        | kENSURE StatementRepeat {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

RescueClause
        : kRESCUE {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
            }
        }
        | kRESCUE WhenClauseRepeat {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

Expression
        : LambdaExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AssignmentExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | QueryExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | TernaryExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC LambdaExpression {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | kASYNC QueryExpression {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        | kASYNC TernaryExpression {
            if (!driver.checkOnly) {
                $$ = new AsyncNode($2);
            }
        }
        ;

LambdaExpression
        : kDEF FormalParamList '(' Expression ')' {
            if (!driver.checkOnly) {
                $$ = new LambdaNode($2, $4);
            }
        }
        ;

AssignmentExpression
        : QualifiedId '=' AssignmentValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAssignment, $1, $3);
            }
        }
        | QualifiedId sADE AssignmentValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAde, $1, $3);
            }
        }
        | QualifiedId sSUE AssignmentValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinarySue, $1, $3);
            }
        }
        | QualifiedId sMUE AssignmentValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMue, $1, $3);
            }
        }
        | QualifiedId sDIE AssignmentValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryDie, $1, $3);
            }
        }
        ;

AssignmentValue
        : Expression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        ;

QueryExpression
        : kFROM QueryOrigin {
            if (!driver.checkOnly) {
                $$ = new QueryNode($2, new SelectNode(new VectorNode()));
            }
        }
        | kFROM QueryOrigin QueryBody {
            if (!driver.checkOnly) {
                $$ = new QueryNode($2, $3);
            }
        }
        ;

QueryOrigin
        : IdentifierLiteral kIN Expression {
            if (!driver.checkOnly) {
                $$ = new QueryOriginNode($1, $3);
            }
        }
        ;

QueryBody
        : QueryBodyMemberRepeat SelectOrGroupClause {
            if (!driver.checkOnly) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_body($1)
                  ->set_finally($2);
            }
        }
        | QueryBodyMemberRepeat {
            if (!driver.checkOnly) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_body($1);
            }
        }
        | SelectOrGroupClause {
            if (!driver.checkOnly) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_finally($1);
            }
        }
        ;

QueryBodyMemberRepeat
        : QueryBodyMember {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | QueryBodyMemberRepeat QueryBodyMember {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

QueryBodyMember
        : kWHERE LogicExpression {
            if (!driver.checkOnly) {
                $$ = new WhereNode($2);
            }
        }
        | JoinClause {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kORDER kBY OrderExpressionList {
            if (!driver.checkOnly) {
                $$ = new OrderByNode($3);
            }
        }
        | RangeClause {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        ;

JoinClause
        : kJOIN QueryOrigin kON LogicExpression {
            if (!driver.checkOnly) {
                $$ = new JoinNode(JoinType::None, $2, $4);
            }
        }
        | kLEFT kJOIN QueryOrigin kON LogicExpression {
            if (!driver.checkOnly) {
                $$ = new JoinNode(JoinType::Left, $3, $5);
            }
        }
        | kRIGHT kJOIN QueryOrigin kON LogicExpression {
            if (!driver.checkOnly) {
                $$ = new JoinNode(JoinType::Right, $3, $5);
            }
        }
        ;

OrderExpressionList
        : OrderExpression {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | OrderExpressionList ',' OrderExpression {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

OrderExpression
        : Expression {
            if (!driver.checkOnly) {
                $$ = new OrderingNode(OrderType::None, $1);
            }
        }
        | Expression kASC {
            if (!driver.checkOnly) {
                $$ = new OrderingNode(OrderType::Asc, $1);
            }
        }
        | Expression kDESC {
            if (!driver.checkOnly) {
                $$ = new OrderingNode(OrderType::Desc, $1);
            }
        }
        ;

RangeClause
        : kSKIP Expression {
            if (!driver.checkOnly) {
                $$ = new RangeNode(RangeType::Skip, $2);
            }
        }
        | kSTEP Expression {
            if (!driver.checkOnly) {
                $$ = new RangeNode(RangeType::Step, $2);
            }
        }
        | kTAKE Expression {
            if (!driver.checkOnly) {
                $$ = new RangeNode(RangeType::Take, $2);
            }
        }
        ;

SelectOrGroupClause
        : kGROUP kBY Expression {
            if (!driver.checkOnly) {
                $$ = new GroupByNode($3);
            }
        }
        | kSELECT ExpressionList {
            if (!driver.checkOnly) {
                $$ = new SelectNode($2);
            }
        }
        ;

TernaryExpression
        : LogicExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | LogicExpression '?' Expression ':' Expression {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernaryIf, $1, $3, $5);
            }
        }
        | LogicExpression kBETWEEN ComparisonExpression kAND ComparisonExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : $1 GEE $3 AND $1 LEE $1
                $$ = new TernaryNode(BaseOperator::TernaryBetween, $1, $3, $5);
            }
        }
        ;

LogicExpression
        : ComparisonExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | LogicExpression kAND ComparisonExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAnd, $1, $3);
            }
        }
        | LogicExpression kOR ComparisonExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryOr, $1, $3);
            }
        }
        | LogicExpression kXOR ComparisonExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryXor, $1, $3);
            }
        }
        | LogicExpression kIMPLIES ComparisonExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT $1 OR $3
                $$ = new BinaryNode(BaseOperator::BinaryImplies, $1, $3);
            }
        }
        ;

ComparisonExpression
        : RangeExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RangeExpression '<' RangeExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryGet, $1, $3);
            }
        }
        | RangeExpression sLEE RangeExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : LET OR EQL
                $$ = new BinaryNode(BaseOperator::BinaryLee, $1, $3);
            }
        }
        | RangeExpression '>' RangeExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT LET
                $$ = new BinaryNode(BaseOperator::BinaryGet, $1, $3);
            }
        }
        | RangeExpression sGEE RangeExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó para NOT LET OR EQL
                $$ = new BinaryNode(BaseOperator::BinaryGee, $1, $3);
            }
        }
        | RangeExpression sEQL RangeExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryEql, $1, $3);
            }
        }
        | RangeExpression sNEQ RangeExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT EQL
                $$ = new BinaryNode(BaseOperator::BinaryNeq, $1, $3);
            }
        }
        | RangeExpression sIDE RangeExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : EQL AND IS
                $$ = new BinaryNode(BaseOperator::BinaryIde, $1, $3);
            }
        }
        | RangeExpression sNID RangeExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryNid, $1, $3);
            }
        }
        | RangeExpression sMAT RangeExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMat, $1, $3);
            }
        }
        | RangeExpression sNMA RangeExpression {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT MAT
                $$ = new BinaryNode(BaseOperator::BinaryNma, $1, $3);
            }
        }
        | RangeExpression kHAS RangeExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryIn, $3, $1);
            }
        }
        | RangeExpression kIN RangeExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryIn, $1, $3);
            }
        }
        ;

RangeExpression
        : AdditionExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AdditionExpression sRAE AdditionExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryRangeOut, $1, $3);
            }
        }
        | AdditionExpression sRAI AdditionExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryRangeIn, $1, $3);
            }
        }
        ;

AdditionExpression
        : MultiplicationExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AdditionExpression '+' MultiplicationExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAdd, $1, $3);
            }
        }
        | AdditionExpression '-' MultiplicationExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinarySub, $1, $3);
            }
        }
        ;

MultiplicationExpression
        : PowerExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | MultiplicationExpression '*' PowerExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMul, $1, $3);
            }
        }
        | MultiplicationExpression '/' PowerExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryDiv, $1, $3);
            }
        }
        | MultiplicationExpression '%' PowerExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMod, $1, $3);
            }
        }
        ;

PowerExpression
        : PrefixExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | PowerExpression sPOW PrefixExpression {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryPow, $1, $3);
            }
        }
        ;

PrefixExpression
        : SuffixExpression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kNOT PrefixExpression %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnaryNot, $2);
            }
        }
        | '+' PrefixExpression %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnaryAdd, $2);
            }
        }
        | '-' PrefixExpression %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnarySub, $2);
            }
        }
        | '(' QualifiedId ')' PrefixExpression %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryCast, $4, $2);
            }
        }
        | kNEW FunctionCall %prec UNARY {
            if (!driver.checkOnly) {
                // $$ = new UnaryNode(BaseOperator::UnaryNew, $2);
                $$ = new NewNode(NewType::InstanceOf, $2);
            }
        }
        | kNEW kCLASS '(' NamedExpressionList ')' %prec UNARY {
            if (!driver.checkOnly) {
                // $$ = new UnaryNode(BaseOperator::UnaryNewClass, $4);
                $$ = new NewNode(NewType::AnonymousClass, $4);
            }
        }
        ;

SuffixExpression
        : LiteralValue {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | SuffixExpression '.' FunctionCall {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpression '.' QualifiedId {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpression '[' Expression ']' {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpression '[' Expression ':' ']' {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernarySlice, $$, $3, NULL);
            }
        }
        | SuffixExpression '[' Expression ':' Expression ']' {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernarySlice, $$, $3, $5);
            }
        }
        | SuffixExpression '[' ':' Expression ']' {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernarySlice, $$, NULL, $4);
            }
        }
        ;

LiteralValue
        : kNIL {
            if (!driver.checkOnly) {
                $$ = new NilNode();
            }
        }
        | BooleanLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | FloatLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | IntegerLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RegexLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | StringLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ArrayLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | HashLiteral  {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | QualifiedId {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | FunctionCall {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | '(' Expression ')' {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

BooleanLiteral
        : kFALSE {
            if (!driver.checkOnly) {
                $$ = new BooleanNode(false);
            }
        }
        | kTRUE {
            if (!driver.checkOnly) {
                $$ = new BooleanNode(true);
            }
        }
        ;

FloatLiteral
        : FLOAT {
            if (!driver.checkOnly) {
                $$ = new FloatNode($1);
            }
        }
        ;

IntegerLiteral
        : INTEGER {
            if (!driver.checkOnly) {
                $$ = new IntegerNode($1);
            }
        }
        ;

RegexLiteral
        : REGEX {
            if (!driver.checkOnly) {
                $$ = new RegexNode(*$1);
            }
        }
        ;

StringLiteral
        : STRING {
            if (!driver.checkOnly) {
                $$ = new StringNode(*$1);
            }
        }
        | StringLiteral STRING {
            if (!driver.checkOnly) {
                ((StringNode *) $$)
                  ->append(*$2);
            }
        }
        ;

ArrayLiteral
        : '[' ']' {
            if (!driver.checkOnly) {
                $$ = new ArrayNode();
            }
        }
        | '[' ExpressionList ']' {
            if (!driver.checkOnly) {
                $$ = new ArrayNode($2);
            }
        }
        ;

ExpressionList
        : Expression {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ExpressionList ',' Expression {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

HashLiteral
        : '{' '}' {
            if (!driver.checkOnly) {
                $$ = new HashNode();
            }
        }
        | '{' NamedExpressionList '}' {
            if (!driver.checkOnly) {
                $$ = new HashNode($2);
            }
        }
        ;

NamedExpressionList
        : NamedExpression {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | NamedExpressionList ',' NamedExpression {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

NamedExpression
        : IdentifierLiteral ':' Expression {
            if (!driver.checkOnly) {
                $$ = new HashPairNode($1, $3);
            }
        }
        | StringLiteral ':' Expression {
            if (!driver.checkOnly) {
                $$ = new HashPairNode($1, $3);
            }
        }
        ;

FunctionCall
        : QualifiedId '(' ')' {
            if (!driver.checkOnly) {
                $$ = new FunctionCallNode($1, new VectorNode());
            }
        }
        | QualifiedId '(' ExpressionList ')' {
            if (!driver.checkOnly) {
                $$ = new FunctionCallNode($1, $3);
            }
        }
        ;

QualifiedId
        : IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | QualifiedId '.' IdentifierLiteral {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        ;

IdentifierLiteral
        : ID {
            if (!driver.checkOnly) {
                $$ = new IdentifierNode(*$1);
            }
        }
        ;

%%

namespace LANG_NAMESPACE {
namespace Compiler {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // Compiler
} // LANG_NAMESPACE
