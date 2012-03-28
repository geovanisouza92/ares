
%{

/* Ares Programming Language */

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

// TODO Reorder items

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
// %token  kEXIT       "exit"
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
// %token  kIS         "is"
%token  kJOIN       "join"
// %token  kLAMBDA     "lambda"
%token  kLEFT       "left"
// %token  kMETHOD     "method"
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
// %token  kSELF       "self"
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

// %token  sDEF    "=>"
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
%token  sRGO    ".."
%token  sRGI    "..."
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

%left   sEQL sIDE sNID sNEQ sLEE sGEE sRGO sRGI sPOW sADE sSUE sMUE sDIE // sDEF
%left   kAND kOR kXOR kIMPLIES
%left   '=' '?' ':' '<' '>' '+' '-' '*' '/' // '|'
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
%type   <v_node>    QueryExpr
%type   <v_node>    QueryBody
%type   <v_node>    QueryOrigin
%type   <v_node>    QueryBodyClause
%type   <v_node>    JoinClause
%type   <v_node>    OrderingItem
%type   <v_node>    RangeClause
%type   <v_node>    SelectsOrGroupClause
%type   <v_node>    Expression
%type   <v_node>    LoopStatement
%type   <v_node>    RetryStatement
%type   <v_node>    YieldStatement
// %type   <v_node>    AsyncStatement
%type   <v_node>    RaiseStatement
%type   <v_node>    ReturnStatement
%type   <v_node>    ForStatement
%type   <v_node>    CaseStatement
%type   <v_node>    WhenClause
%type   <v_node>    ConditionalStatement
%type   <v_node>    ElifStatement
%type   <v_node>    WhenRescueClause
%type   <v_node>    Condition
%type   <v_node>    StatementBlock
%type   <v_node>    Constant
%type   <v_node>    ConstantDecl
%type   <v_node>    Variable
%type   <v_node>    VariableDecl
%type   <v_node>    InitialValue
%type   <v_node>    ReturnType
%type   <v_node>    InvariantsClause
%type   <v_node>    InterceptClause
%type   <v_node>    RealFunctionDecl
%type   <v_node>    FunctionDecl
%type   <v_node>    EventDecl
%type   <v_node>    AttributeDecl
%type   <v_node>    Getter
%type   <v_node>    Setter
%type   <v_node>    VisibilityStatement
%type   <v_node>    ClassDecl
%type   <v_node>    ImportStatement
%type   <v_node>    ModuleDecl
%type   <v_node>    Statement

%type   <v_list>    ExpressionList
%type   <v_list>    NamedExpressionList
%type   <v_list>    ParamValueList
%type   <v_list>    FormalParamList
%type   <v_list>    VariableList
%type   <v_list>    QueryBodyClauseRepeat
%type   <v_list>    OrderingItemList
%type   <v_list>    WhenClauseRepeat
%type   <v_list>    ElifStatementRepeat
%type   <v_list>    WhenRescueClauseRepeat
%type   <v_list>    RequireClause
%type   <v_list>    RescueClause
%type   <v_list>    EnsureClause
%type   <v_list>    Conditions
%type   <v_list>    ConstantList
%type   <v_list>    IdentifierList
%type   <v_list>    Statements

%%

Program
        : /* empty */ {
            driver.decLines();
            driver.warning("Nothing to do here.");
        }
        | Statements {
            if (!driver.checkOnly) {
                driver.enviro->putStatements($1);
            }
        }
        ;

Statements
        : Statement {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | Statements Statement {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

Statement
        : Expression ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | VariableDecl ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ConstantDecl ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | StatementBlock {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ConditionalStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | CaseStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ForStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | LoopStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        // | AsyncStatement {
        //     if (!driver.checkOnly) {
        //         $$ = $1;
        //     }
        // }
        | YieldStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kBREAK ';' {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Break);
            }
        }
        | kCONTINUE ';' {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Continue);
            }
        }
        | RetryStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RaiseStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ReturnStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kINCLUDE QualifiedId ';' /* {
            // TODO Chamar comando do driver
            if (!driver.checkOnly) {
                $$ = $1;
            }
        } */
        | VisibilityStatement {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AttributeDecl ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | EventDecl ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ModuleDecl {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ImportStatement ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ClassDecl ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | ClassDecl Statements kEND {
            if (!driver.checkOnly) {
                ((ClassNode *) $1)
                  ->addStatements($2);
                $$ = $1;
            }
        }
        | FunctionDecl ';' {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RealFunctionDecl StatementBlock {
            if (!driver.checkOnly) {
                ((FunctionNode *) $1)
                  ->setBlock($2);
                $$ = $1;
            }
        }
        ;

ModuleDecl
        : kMODULE QualifiedId kEND {
            if (!driver.checkOnly) {
                $$ = new ModuleNode($2);
            }
        }
        | kMODULE QualifiedId Statements kEND {
            if (!driver.checkOnly) {
                $$ = new ModuleNode($2);
                ((ModuleNode *) $$)
                  ->addStatements($3);
            }
        }
        ;

ImportStatement
        : kIMPORT IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ImportNode($2);
            }
        }
        | kFROM String kIMPORT IdentifierList {
            if (!driver.checkOnly) {
                $$ = new ImportNode($4);
                ((ImportNode *) $$)
                  ->setImportOrigin($2);
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

ClassDecl
        : kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($2);
            }
        }
        | kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($2);
                ((ClassNode *) $$)
                  ->setClassHeritance($4);
            }
        }
        | kABSTRACT kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kSEALED kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kABSTRACT kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->setClassHeritance($5)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kSEALED kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->setClassHeritance($5)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kABSTRACT kSEALED kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kABSTRACT kSEALED kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->setClassHeritance($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed);
            }
        }
        | kASYNC kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($3);
                ((ClassNode *) $$)
                  ->setClassHeritance($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kSEALED kASYNC kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kSEALED kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->setClassHeritance($6)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.checkOnly) {
                $$ = new ClassNode($4);
                ((ClassNode *) $$)
                  ->setClassHeritance($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kSEALED kASYNC kCLASS Identifier {
            if (!driver.checkOnly) {
                $$ = new ClassNode($5);
                ((ClassNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Sealed)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kSEALED kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
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

VisibilityStatement
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

AttributeDecl
        : kATTR Identifier ReturnType {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3);
            }
        }
        | kATTR Identifier ReturnType InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInvariants($4);
            }
        }
        | kATTR Identifier ReturnType Setter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeSetter($4);
            }
        }
        | kATTR Identifier ReturnType Setter InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeSetter($4)
                  ->setAttributeInvariants($5);
            }
        }
        | kATTR Identifier ReturnType Getter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4);
            }
        }
        | kATTR Identifier ReturnType Getter InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4)
                  ->setAttributeInvariants($5);
            }
        }
        | kATTR Identifier ReturnType Getter Setter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4)
                  ->setAttributeSetter($5);
            }
        }
        | kATTR Identifier ReturnType Getter Setter InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeGetter($4)
                  ->setAttributeSetter($5)
                  ->setAttributeInvariants($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4);
            }
        }
        | kATTR Identifier ReturnType InitialValue InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeInvariants($5);
            }
        }
        | kATTR Identifier ReturnType InitialValue Setter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeSetter($5);
            }
        }
        | kATTR Identifier ReturnType InitialValue Setter InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeSetter($5)
                  ->setAttributeInvariants($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5)
                  ->setAttributeInvariants($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter Setter {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5)
                  ->setAttributeSetter($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter Setter InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new AttributeNode($2);
                ((AttributeNode *) $$)
                  ->setAttributeReturnType($3)
                  ->setAttributeInitialValue($4)
                  ->setAttributeGetter($5)
                  ->setAttributeSetter($6)
                  ->setAttributeInvariants($7);
            }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue InvariantsClause {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeInvariants($6)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue Setter {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeSetter($6)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue Setter InvariantsClause {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeSetter($6)
        //           ->setAttributeInvariants($7)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue Getter {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeGetter($6)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue Getter InvariantsClause {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeGetter($6)
        //           ->setAttributeInvariants($7)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue Getter Setter {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeGetter($6)
        //           ->setAttributeSetter($7)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        // }
        // | kCLASS kATTR Identifier ReturnType InitialValue Getter Setter InvariantsClause {
        //     if (!driver.checkOnly) {
        //         $$ = new AttributeNode($3);
        //         ((AttributeNode *) $$)
        //           ->setAttributeReturnType($4)
        //           ->setAttributeInitialValue($5)
        //           ->setAttributeGetter($6)
        //           ->setAttributeSetter($7)
        //           ->setAttributeInvariants($8)
        //           ->addSpecifier(SpecifierType::Class);
        //     }
        }
        ;

InvariantsClause
        : kINVARIANTS Condition {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

Getter
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

Setter
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

EventDecl
        : kEVENT Identifier {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
            }
        }
        | kEVENT Identifier '=' StatementBlock {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
                ((EventNode *) $$)
                  ->setEventInitialValue($4);
            }
        }
        | kEVENT Identifier '=' QualifiedId {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
                ((EventNode *) $$)
                  ->setEventInitialValue($4);
            }
        }
        | kEVENT Identifier InterceptClause {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
                ((EventNode *) $$)
                  ->setEventIntercept($3);
            }
        }
        | kEVENT Identifier InterceptClause '=' StatementBlock {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
                ((EventNode *) $$)
                  ->setEventIntercept($3)
                  ->setEventInitialValue($5);
            }
        }
        | kEVENT Identifier InterceptClause '=' QualifiedId {
            if (!driver.checkOnly) {
                $$ = new EventNode($2);
                ((EventNode *) $$)
                  ->setEventIntercept($3)
                  ->setEventInitialValue($5);
            }
        }
        ;

FunctionDecl
        : RealFunctionDecl {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Abstract);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($5, $6);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($7)
                  ->addSpecifier(SpecifierType::Abstract)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
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

RealFunctionDecl
        : kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
            }
        }
        | kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($4);
            }
        }
        | kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($4);
            }
        }
        | kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($2, $3);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($4)
                  ->setFunctionIntercept($5);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Class);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($3, $4);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($5)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionIntercept($6)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.checkOnly) {
                $$ = new FunctionNode($4, $5);
                ((FunctionNode *) $$)
                  ->setFunctionReturn($6)
                  ->addSpecifier(SpecifierType::Class)
                  ->addSpecifier(SpecifierType::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
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
        // | '(' sRGI ')'
        | '(' VariableList ')' {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        // | '(' VariableList ',' sRGI ')'
        ;

ReturnType
        : ':' QualifiedId {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
//         | ':' QualifiedId ArrayTails
        ;

// ArrayTails
//         : ArrayTail
//         | ArrayTails ArrayTail
//         ;

// ArrayTail
//         : '[' ']'
//         | '[' INTEGER ']'
//         ;

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

VariableDecl
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
        : Identifier {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
            }
        }
        | Identifier InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInvariants($2);
            }
        }
        | Identifier InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInitialValue($2);
            }
        }
        | Identifier InitialValue InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInitialValue($2)
                  ->setElementInvariants($3);
            }
        }
        | Identifier ReturnType {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2);
            }
        }
        | Identifier ReturnType InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInvariants($3);
            }
        }
        | Identifier ReturnType InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInitialValue($3);
            }
        }
        | Identifier ReturnType InitialValue InvariantsClause {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInitialValue($3)
                  ->setElementInvariants($4);
            }
        }
        ;

InitialValue
        : '=' AssignValue {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
//         | '=' AssignValue ControlTypeExpr {
//             if (!driver.checkOnly) {
//                 $$ = new ConditionNode(
//             }
//         }
        ;

// ControlTypeExpr
//        : kIF Expression
//         | kUNLESS Expression
//         // | kFOR QueryOrigin kWHERE Expression
//         ;

ConstantDecl
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
        : Identifier InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementInitialValue($2);
            }
        }
        | Identifier ReturnType InitialValue {
            if (!driver.checkOnly) {
                $$ = new ElementNode($1);
                ((ElementNode *) $$)
                  ->setElementType($2)
                  ->setElementInitialValue($3);
            }
        }
        ;

StatementBlock
        : kBEGIN kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode(new VectorNode());
            }
        }
        | kBEGIN Statements kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
            }
        }
        | kBEGIN Statements EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
                ((BlockNode *) $$)
                  ->setBlockEnsure($3);
            }
        }
        | kBEGIN Statements RescueClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
                ((BlockNode *) $$)
                  ->setBlockRescue($3);
            }
        }
        | kBEGIN Statements RescueClause EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($2);
                ((BlockNode *) $$)
                  ->setBlockRescue($3)
                  ->setBlockEnsure($4);
            }
        }
        | RequireClause kBEGIN Statements kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1);
            }
        }
        | RequireClause kBEGIN Statements EnsureClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1)
                  ->setBlockEnsure($4);
            }
        }
        | RequireClause kBEGIN Statements RescueClause kEND {
            if (!driver.checkOnly) {
                $$ = new BlockNode($3);
                ((BlockNode *) $$)
                  ->setBlockRequire($1)
                  ->setBlockRescue($4);
            }
        }
        | RequireClause kBEGIN Statements RescueClause EnsureClause kEND {
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
        | kREQUIRE Conditions {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

Conditions
        : Condition ';' {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | Conditions Condition ';' {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

Condition
        : LogicExpr {
            if (!driver.checkOnly) {
                $$ = new ValidationNode($1, new ControlNode(ControlType::Continue));
            }
        }
        | LogicExpr RaiseStatement {
            if (!driver.checkOnly) {
                $$ = new ValidationNode($1, $2);
            }
        }
        ;

EnsureClause
        : kENSURE {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
            }
        }
        | kENSURE Statements {
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
        | kRESCUE WhenRescueClauseRepeat {
            if (!driver.checkOnly) {
                $$ = $2;
            }
        }
        ;

WhenRescueClauseRepeat
        : WhenRescueClause {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | WhenRescueClauseRepeat WhenRescueClause {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

WhenRescueClause
        : kWHEN Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new WhenNode($2, $4);
            }
        }
        ;

RetryStatement
        : kRETRY {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Retry);
            }
        }
//         | kRETRY QualifiedId {
//             if (!driver.checkOnly) {
//                 $$ = new ControlNode(ControlType::Retry, $2);
//             }
//         }
//         | kRETRY INTEGER {
//             if (!driver.checkOnly) {
//                 $$ = new ControlNode(ControlType::Retry, new IntegerNode($2));
//             }
//         }
        ;

ConditionalStatement
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
        | kUNLESS Expression kTHEN Statement {
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
        | kELIF Expression kTHEN Statement kELSE Statement {
            if (!driver.checkOnly) {
                $$ = new ConditionNode(ConditionType::If, $2, $4);
                ((ConditionNode *) $$)
                  ->setElse($6);
            }
        }
        ;

CaseStatement
        : kCASE Expression kEND {
            if (!driver.checkOnly) {
                $$ = new CaseNode($2);
            }
        }
        | kCASE Expression kELSE Statement kEND {
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
        | kCASE Expression WhenClauseRepeat kELSE Statement kEND {
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
                $$ = new ForNode(LoopType::Ascending, $2, $4, $6);
            }
        }
        | kFOR Expression kASC Expression kSTEP Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::Ascending, $2, $4, $8);
                ((ForNode *) $$)
                  ->setStep($6);
            }
        }
        | kFOR Expression kDESC Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::Descending, $2, $4, $6);
            }
        }
        | kFOR Expression kDESC Expression kSTEP Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::Descending, $2, $4, $8);
                ((ForNode *) $$)
                  ->setStep($6);
            }
        }
        | kFOR QueryOrigin kDO Statement {
            if (!driver.checkOnly) {
                $$ = new ForNode(LoopType::Iteration, $2, new IdentifierNode("self"), $4);
            }
        }
        // | kFOREACH QueryOrigin kDO Statement
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

LoopStatement
        : kWHILE Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new LoopNode(LoopType::While, $2, $4);
            }
        }
        | kUNTIL Expression kDO Statement {
            if (!driver.checkOnly) {
                $$ = new LoopNode(LoopType::Until, $2, $4);
            }
        }
        ;

// AsyncStatement
//         : kASYNC Statement {
//             if (!driver.checkOnly) {
//                 $$ = new AsyncNode(AsyncType::Statement, $2);
//             }
//         }
//         ;

RaiseStatement
        : kRAISE {
            if (!driver.checkOnly) {
                $$ = new ControlNode(ControlType::Raise);
            }
        }
        | kRAISE String {
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

Expression
        : LambdaExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AssignExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
//         | AssignExpr ControlTypeExpr // TODO Criar nó: $2 then $1 else nil
        | TernaryExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | QueryExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        ;

LambdaExpr
        : kDEF FormalParamList '(' Expression ')' {
            if (!driver.checkOnly) {
                $$ = new LambdaNode($2, $4);
            }
        }
//         | kDEF FormalParamList sDEF Expression {
//             if (!driver.checkOnly) {
//                 $$ = new LambdaNode($2, $4);
//             }
//         }
        ;

AssignExpr
        : QualifiedId '=' AssignValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAssign, $1, $3);
            }
        }
        | QualifiedId sADE AssignValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAde, $1, $3);
            }
        }
        | QualifiedId sSUE AssignValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinarySue, $1, $3);
            }
        }
        | QualifiedId sMUE AssignValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMue, $1, $3);
            }
        }
        | QualifiedId sDIE AssignValue {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryDie, $1, $3);
            }
        }
        ;

AssignValue
        : Expression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC Expression {
            if (!driver.checkOnly) {
                $$ = new AsyncNode(AsyncType::Expression, $2);
            }
        }
        | StatementBlock {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kASYNC StatementBlock {
            if (!driver.checkOnly) {
                $$ = new AsyncNode(AsyncType::Statement, $2);
            }
        }
        ;

TernaryExpr
        : LogicExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | TernaryExpr '?' Expression ':' Expression {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernaryIf, $1, $3, $5);
            }
        }
        // TODO Se houver double comparison, isso fica inútil
        | TernaryExpr kBETWEEN ComparisonExpr kAND ComparisonExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : $1 GEE $3 AND $1 LEE $1
                $$ = new TernaryNode(BaseOperator::TernaryBetween, $1, $3, $5);
            }
        }
        ;

LogicExpr
        : ComparisonExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | LogicExpr kAND ComparisonExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAnd, $1, $3);
            }
        }
        | LogicExpr kOR ComparisonExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryOr, $1, $3);
            }
        }
        | LogicExpr kXOR ComparisonExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryXor, $1, $3);
            }
        }
        | LogicExpr kIMPLIES ComparisonExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT $1 OR $3
                $$ = new BinaryNode(BaseOperator::BinaryImplies, $1, $3);
            }
        }
        ;

// TODO simultaneous comparison

ComparisonExpr
        : RangeExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RangeExpr '<' RangeExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryGet, $1, $3);
            }
        }
        | RangeExpr sLEE RangeExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : LET OR EQL
                $$ = new BinaryNode(BaseOperator::BinaryLee, $1, $3);
            }
        }
        | RangeExpr '>' RangeExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT LET
                $$ = new BinaryNode(BaseOperator::BinaryGet, $1, $3);
            }
        }
        | RangeExpr sGEE RangeExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó para NOT LET OR EQL
                $$ = new BinaryNode(BaseOperator::BinaryGee, $1, $3);
            }
        }
        | RangeExpr sEQL RangeExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryEql, $1, $3);
            }
        }
        | RangeExpr sNEQ RangeExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT EQL
                $$ = new BinaryNode(BaseOperator::BinaryNeq, $1, $3);
            }
        }
        | RangeExpr sIDE RangeExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : EQL AND IS
                $$ = new BinaryNode(BaseOperator::BinaryIde, $1, $3);
            }
        }
        | RangeExpr sNID RangeExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryNid, $1, $3);
            }
        }
        | RangeExpr sMAT RangeExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMat, $1, $3);
            }
        }
        | RangeExpr sNMA RangeExpr {
            if (!driver.checkOnly) {
                // TODO Criar nó : NOT MAT
                $$ = new BinaryNode(BaseOperator::BinaryNma, $1, $3);
            }
        }
        | RangeExpr kHAS RangeExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryIn, $3, $1);
            }
        }
        | RangeExpr kIN RangeExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryIn, $1, $3);
            }
        }
        ;

RangeExpr
        : AddExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | RangeExpr sRGO AddExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryRangeOut, $1, $3);
            }
        }
        | RangeExpr sRGI AddExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryRangeIn, $1, $3);
            }
        }
        ;

AddExpr
        : MultExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | AddExpr '+' MultExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAdd, $1, $3);
            }
        }
        | AddExpr '-' MultExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinarySub, $1, $3);
            }
        }
        ;

MultExpr
        : PowerExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | MultExpr '*' PowerExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMul, $1, $3);
            }
        }
        | MultExpr '/' PowerExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryDiv, $1, $3);
            }
        }
        | MultExpr '%' PowerExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryMod, $1, $3);
            }
        }
        // | MultExpr QualifiedId
        ;

PowerExpr
        : PrefixExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | PowerExpr sPOW PrefixExpr {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryPow, $1, $3);
            }
        }
        ;

PrefixExpr
        : SuffixExpr {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kNOT PrefixExpr %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnaryNot, $2);
            }
        }
        | '+' PrefixExpr %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnaryAdd, $2);
            }
        }
        | '-' PrefixExpr %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnarySub, $2);
            }
        }
        | '(' QualifiedId ')' PrefixExpr %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryCast, $4, $2);
            }
        }
        | kNEW FunctionCall %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnaryNew, $2);
            }
        }
        | kNEW kCLASS '(' NamedExpressionList ')' %prec UNARY {
            if (!driver.checkOnly) {
                $$ = new UnaryNode(BaseOperator::UnaryNewClass, $4);
            }
        }
        ;

SuffixExpr
        : Value {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | SuffixExpr '.' FunctionCall {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpr '.' QualifiedId {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpr '[' Expression ']' {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        | SuffixExpr '[' Expression ':' ']' {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernarySlice, $$, $3, NULL);
            }
        }
        | SuffixExpr '[' Expression ':' Expression ']' {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernarySlice, $$, $3, $5);
            }
        }
        | SuffixExpr '[' ':' Expression ']' {
            if (!driver.checkOnly) {
                $$ = new TernaryNode(BaseOperator::TernarySlice, $$, NULL, $4);
            }
        }
        ;

Value
        : kNIL {
            if (!driver.checkOnly) {
                $$ = new NilNode();
            }
        }
//         | kSELF {
//             if (!driver.checkOnly) {
//                 $$ = new IdentifierNode("self");
//             }
//         }
        | kFALSE {
            if (!driver.checkOnly) {
                $$ = new BooleanNode(false);
            }
        }
        | kTRUE {
            if (!driver.checkOnly) {
                $$ = new BooleanNode(true);
            }
        }
        | FLOAT {
            if (!driver.checkOnly) {
                $$ = new FloatNode($1);
            }
        }
        | INTEGER {
            if (!driver.checkOnly) {
                $$ = new IntegerNode($1);
            }
        }
        | REGEX {
            if (!driver.checkOnly) {
                $$ = new RegexNode(*$1);
            }
        }
        | String {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | Array {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | Hash  {
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

String
        : STRING {
            if (!driver.checkOnly) {
                $$ = new StringNode(*$1);
            }
        }
        | String STRING {
            if (!driver.checkOnly) {
                ((StringNode *) $$)
                  ->append(*$2);
            }
        }
        ;

Array
        : '[' ExpressionList ']' {
            if (!driver.checkOnly) {
                $$ = new ArrayNode($2);
            }
        }
        // | '[' NamedExpressionList ']' // Alternativa para criação de arranjos associativos
        | '[' ']' {
            if (!driver.checkOnly) {
                $$ = new ArrayNode();
            }
        }
        // | '[' Expression '|' QueryOrigin sDEF LogicExpr ']'
        // | '[' Expression '|' QueryOrigin kWHERE LogicExpr ']'
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

Hash
        : '{' NamedExpressionList '}' {
            if (!driver.checkOnly) {
                $$ = new HashNode($2);
            }
        }
        | '{' '}' {
            if (!driver.checkOnly) {
                $$ = new HashNode();
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
        : Identifier ':' Expression {
            if (!driver.checkOnly) {
                $$ = new HashPairNode($1, $3);
            }
        }
        | String ':' Expression {
            if (!driver.checkOnly) {
                $$ = new HashPairNode($1, $3);
            }
        }
        ;

QualifiedId
        : Identifier {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | QualifiedId '.' Identifier {
            if (!driver.checkOnly) {
                $$ = new BinaryNode(BaseOperator::BinaryAccess, $$, $3);
            }
        }
        ;

Identifier
        : ID {
            if (!driver.checkOnly) {
                $$ = new IdentifierNode(*$1);
            }
        }
        ;

FunctionCall
        : QualifiedId '(' ')' {
            if (!driver.checkOnly) {
                $$ = new FunctionCallNode($1, new VectorNode());
            }
        }
        | QualifiedId '(' ParamValueList ')' {
            if (!driver.checkOnly) {
                $$ = new FunctionCallNode($1, $3);
            }
        }
        ;

ParamValueList
        : ParamValue {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ParamValueList ',' ParamValue {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

ParamValue
        : Expression {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | StatementBlock {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        ;

QueryExpr
        : kFROM QueryOrigin QueryBody {
            if (!driver.checkOnly) {
                $$ = new QueryNode($2, $3);
            }
        }
        | kFROM QueryOrigin {
            if (!driver.checkOnly) {
                $$ = new QueryNode($2, new SelectNode(new VectorNode()));
            }
        }
        ;

QueryOrigin
        : Identifier kIN Expression {
            if (!driver.checkOnly) {
                $$ = new QueryOriginNode($1, $3);
            }
        }
        ;

QueryBody
        : QueryBodyClauseRepeat SelectsOrGroupClause {
            if (!driver.checkOnly) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_body($1)
                  ->set_finally($2);
            }
        }
        | QueryBodyClauseRepeat {
            if (!driver.checkOnly) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_body($1);
            }
        }
        | SelectsOrGroupClause {
            if (!driver.checkOnly) {
                $$ = new QueryBodyNode();
                ((QueryBodyNode *) $$)
                  ->set_finally($1);
            }
        }
        ;

QueryBodyClauseRepeat
        : QueryBodyClause {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | QueryBodyClauseRepeat QueryBodyClause {
            if (!driver.checkOnly) {
                $$->push_back($2);
            }
        }
        ;

QueryBodyClause
        : kWHERE LogicExpr {
            if (!driver.checkOnly) {
                $$ = new WhereNode($2);
            }
        }
        | JoinClause {
            if (!driver.checkOnly) {
                $$ = $1;
            }
        }
        | kORDER kBY OrderingItemList {
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
        : kJOIN QueryOrigin kON LogicExpr {
            if (!driver.checkOnly) {
                $$ = new JoinNode(JoinType::None, $2, $4);
            }
        }
        | kLEFT kJOIN QueryOrigin kON LogicExpr {
            if (!driver.checkOnly) {
                $$ = new JoinNode(JoinType::Left, $3, $5);
            }
        }
        | kRIGHT kJOIN QueryOrigin kON LogicExpr {
            if (!driver.checkOnly) {
                $$ = new JoinNode(JoinType::Right, $3, $5);
            }
        }
        ;

OrderingItemList
        : OrderingItem {
            if (!driver.checkOnly) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | OrderingItemList ',' OrderingItem {
            if (!driver.checkOnly) {
                $$->push_back($3);
            }
        }
        ;

OrderingItem
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

SelectsOrGroupClause
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

%%

namespace LANG_NAMESPACE {
namespace Compiler {

void Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}

} // Compiler
} // LANG_NAMESPACE
