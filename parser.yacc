
%{

/* Ares Programming Language */

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
            driver.dec_lines();
            driver.warning("Nothing to do here.");
        }
        | Statements {
            if (!driver.check_only) {
                driver.Env->put_stmts($1);
            }
        }
        ;

Statements
        : Statement {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | Statements Statement {
            if (!driver.check_only) {
                $$->push_back($2);
            }
        }
        ;

Statement
        : Expression ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | VariableDecl ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ConstantDecl ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | StatementBlock {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ConditionalStatement {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | CaseStatement {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ForStatement {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | LoopStatement {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        // | AsyncStatement {
        //     if (!driver.check_only) {
        //         $$ = $1;
        //     }
        // }
        | YieldStatement ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kBREAK ';' {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Break);
            }
        }
        | kCONTINUE ';' {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Continue);
            }
        }
        | RetryStatement ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | RaiseStatement ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ReturnStatement ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kINCLUDE QualifiedId ';' /* {
            // TODO Chamar comando do driver
            if (!driver.check_only) {
                $$ = $1;
            }
        } */
        | VisibilityStatement {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | AttributeDecl ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | EventDecl ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ModuleDecl {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ImportStatement ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ClassDecl ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | ClassDecl Statements kEND {
            if (!driver.check_only) {
                ((ClassDeclNode *) $1)
                  ->add_stmts($2);
                $$ = $1;
            }
        }
        | FunctionDecl ';' {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | RealFunctionDecl StatementBlock {
            if (!driver.check_only) {
                ((FunctionDeclNode *) $1)
                  ->add_stmt($2);
                $$ = $1;
            }
        }
        ;

ModuleDecl
        : kMODULE QualifiedId kEND {
            if (!driver.check_only) {
                $$ = new ModuleNode($2);
            }
        }
        | kMODULE QualifiedId Statements kEND {
            if (!driver.check_only) {
                $$ = new ModuleNode($2);
                ((ModuleNode *) $$)
                  ->add_stmts($3);
            }
        }
        ;

ImportStatement
        : kIMPORT IdentifierList {
            if (!driver.check_only) {
                $$ = new ImportStmtNode($2);
            }
        }
        | kFROM String kIMPORT IdentifierList {
            if (!driver.check_only) {
                $$ = new ImportStmtNode($4);
                ((ImportStmtNode *) $$)
                  ->set_origin($2);
            }
        }
        | kFROM QualifiedId kIMPORT IdentifierList {
            if (!driver.check_only) {
                $$ = new ImportStmtNode($4);
                ((ImportStmtNode *) $$)
                  ->set_origin($2);
            }
        }
        ;

ClassDecl
        : kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($2);
            }
        }
        | kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($2);
                ((ClassDeclNode *) $$)
                  ->set_heritance($4);
            }
        }
        | kABSTRACT kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($3);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract);
            }
        }
        | kSEALED kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($3);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Sealed);
            }
        }
        | kABSTRACT kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($3);
                ((ClassDeclNode *) $$)
                  ->set_heritance($5)
                  ->add_specifier(Specifier::Abstract);
            }
        }
        | kSEALED kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($3);
                ((ClassDeclNode *) $$)
                  ->set_heritance($5)
                  ->add_specifier(Specifier::Sealed);
            }
        }
        | kABSTRACT kSEALED kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($4);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Sealed);
            }
        }
        | kABSTRACT kSEALED kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($4);
                ((ClassDeclNode *) $$)
                  ->set_heritance($6)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Sealed);
            }
        }
        | kASYNC kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($3);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($3);
                ((ClassDeclNode *) $$)
                  ->set_heritance($5)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kSEALED kASYNC kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($4);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Sealed)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kSEALED kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($4);
                ((ClassDeclNode *) $$)
                  ->set_heritance($6)
                  ->add_specifier(Specifier::Sealed)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kASYNC kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($4);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($4);
                ((ClassDeclNode *) $$)
                  ->set_heritance($6)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kSEALED kASYNC kCLASS Identifier {
            if (!driver.check_only) {
                $$ = new ClassDeclNode($5);
                ((ClassDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Sealed)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kSEALED kASYNC kCLASS Identifier '>' QualifiedId { // IdentifierList
            if (!driver.check_only) {
                $$ = new ClassDeclNode($5);
                ((ClassDeclNode *) $$)
                  ->set_heritance($7)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Sealed)
                  ->add_specifier(Specifier::Async);
            }
        }
        ;

VisibilityStatement
        : kPRIVATE {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Private);
            }
        }
        | kPROTECTED {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Protected);
            }
        }
        | kPUBLIC {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Public);
            }
        }
        ;

AttributeDecl
        : kATTR Identifier ReturnType {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3);
            }
        }
        | kATTR Identifier ReturnType InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_invariants($4);
            }
        }
        | kATTR Identifier ReturnType Setter {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_setter($4);
            }
        }
        | kATTR Identifier ReturnType Setter InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_setter($4)
                  ->set_invariants($5);
            }
        }
        | kATTR Identifier ReturnType Getter {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_getter($4);
            }
        }
        | kATTR Identifier ReturnType Getter InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_getter($4)
                  ->set_invariants($5);
            }
        }
        | kATTR Identifier ReturnType Getter Setter {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_getter($4)
                  ->set_setter($5);
            }
        }
        | kATTR Identifier ReturnType Getter Setter InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_getter($4)
                  ->set_setter($5)
                  ->set_invariants($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4);
            }
        }
        | kATTR Identifier ReturnType InitialValue InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_invariants($5);
            }
        }
        | kATTR Identifier ReturnType InitialValue Setter {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_setter($5);
            }
        }
        | kATTR Identifier ReturnType InitialValue Setter InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_setter($5)
                  ->set_invariants($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_getter($5);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_getter($5)
                  ->set_invariants($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter Setter {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_getter($5)
                  ->set_setter($6);
            }
        }
        | kATTR Identifier ReturnType InitialValue Getter Setter InvariantsClause {
            if (!driver.check_only) {
                $$ = new AttrDeclNode($2);
                ((AttrDeclNode *) $$)
                  ->set_return_type($3)
                  ->set_initial_value($4)
                  ->set_getter($5)
                  ->set_setter($6)
                  ->set_invariants($7);
            }
        }
        ;

InvariantsClause
        : kINVARIANTS Condition {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

Getter
        : kGET {
            if (!driver.check_only) {
                $$ = new IdentifierNode("default");
            }
        }
        | kGET QualifiedId {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

Setter
        : kSET {
            if (!driver.check_only) {
                $$ = new IdentifierNode("default");
            }
        }
        | kSET QualifiedId {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

EventDecl
        : kEVENT Identifier {
            if (!driver.check_only) {
                $$ = new EventDeclNode($2);
            }
        }
        | kEVENT Identifier '=' StatementBlock {
            if (!driver.check_only) {
                $$ = new EventDeclNode($2);
                ((EventDeclNode *) $$)
                  ->set_initial_value($4);
            }
        }
        | kEVENT Identifier '=' QualifiedId {
            if (!driver.check_only) {
                $$ = new EventDeclNode($2);
                ((EventDeclNode *) $$)
                  ->set_initial_value($4);
            }
        }
        | kEVENT Identifier InterceptClause {
            if (!driver.check_only) {
                $$ = new EventDeclNode($2);
                ((EventDeclNode *) $$)
                  ->set_intercept($3);
            }
        }
        | kEVENT Identifier InterceptClause '=' StatementBlock {
            if (!driver.check_only) {
                $$ = new EventDeclNode($2);
                ((EventDeclNode *) $$)
                  ->set_intercept($3)
                  ->set_initial_value($5);
            }
        }
        | kEVENT Identifier InterceptClause '=' QualifiedId {
            if (!driver.check_only) {
                $$ = new EventDeclNode($2);
                ((EventDeclNode *) $$)
                  ->set_intercept($3)
                  ->set_initial_value($5);
            }
        }
        ;

FunctionDecl
        : RealFunctionDecl {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract);
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($5)
                  ->add_specifier(Specifier::Abstract);
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_return($5)
                  ->add_specifier(Specifier::Abstract);
            }
        }
        | kABSTRACT kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_return($5)
                  ->set_intercept($6)
                  ->add_specifier(Specifier::Abstract);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($6)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_return($6)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kABSTRACT kCLASS kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_return($6)
                  ->set_intercept($7)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($6)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_return($6)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_return($6)
                  ->set_intercept($7)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($5, $6);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($5, $6);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($7)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($5, $6);
                ((FunctionDeclNode *) $$)
                  ->set_return($7)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kABSTRACT kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($5, $6);
                ((FunctionDeclNode *) $$)
                  ->set_return($7)
                  ->set_intercept($8)
                  ->add_specifier(Specifier::Abstract)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        ;

RealFunctionDecl
        : kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($2, $3);
            }
        }
        | kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($2, $3);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($4);
            }
        }
        | kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($2, $3);
                ((FunctionDeclNode *) $$)
                  ->set_return($4);
            }
        }
        | kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($2, $3);
                ((FunctionDeclNode *) $$)
                  ->set_return($4)
                  ->set_intercept($5);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($5)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_return($5)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kCLASS kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_return($5)
                  ->set_intercept($6)
                  ->add_specifier(Specifier::Class);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($5)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_return($5)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($3, $4);
                ((FunctionDeclNode *) $$)
                  ->set_return($5)
                  ->set_intercept($6)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_intercept($6)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_return($6)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        | kCLASS kASYNC kDEF QualifiedId FormalParamList ReturnType InterceptClause {
            if (!driver.check_only) {
                $$ = new FunctionDeclNode($4, $5);
                ((FunctionDeclNode *) $$)
                  ->set_return($6)
                  ->set_intercept($7)
                  ->add_specifier(Specifier::Class)
                  ->add_specifier(Specifier::Async);
            }
        }
        ;

FormalParamList
        : '(' ')' {
            if (!driver.check_only) {
                $$ = new VectorNode();
            }
        }
        // | '(' sRGI ')'
        | '(' VariableList ')' {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        // | '(' VariableList ',' sRGI ')'
        ;

ReturnType
        : ':' QualifiedId {
            if (!driver.check_only) {
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
            if (!driver.check_only) {
                $$ = new InterceptNode(Intercept::After, $2);
            }
        }
        | kBEFORE IdentifierList {
            if (!driver.check_only) {
                $$ = new InterceptNode(Intercept::Before, $2);
            }
        }
        | kSIGNAL IdentifierList {
            if (!driver.check_only) {
                $$ = new InterceptNode(Intercept::Signal, $2);
            }
        }
        ;

IdentifierList
        : QualifiedId {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | IdentifierList ',' QualifiedId {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

VariableDecl
        : kVAR VariableList {
            if (!driver.check_only) {
                $$ = new VarDeclNode($2);
            }
        }
        ;

VariableList
        : Variable {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | VariableList ',' Variable {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

Variable
        : Identifier {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
            }
        }
        | Identifier InvariantsClause {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_invariants($2);
            }
        }
        | Identifier InitialValue {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_initial_value($2);
            }
        }
        | Identifier InitialValue InvariantsClause {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_initial_value($2)
                  ->set_invariants($3);
            }
        }
        | Identifier ReturnType {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_type($2);
            }
        }
        | Identifier ReturnType InvariantsClause {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_type($2)
                  ->set_invariants($3);
            }
        }
        | Identifier ReturnType InitialValue {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_type($2)
                  ->set_initial_value($3);
            }
        }
        | Identifier ReturnType InitialValue InvariantsClause {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_type($2)
                  ->set_initial_value($3)
                  ->set_invariants($4);
            }
        }
        ;

InitialValue
        : '=' AssignValue {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
//         | '=' AssignValue ControlExpr {
//             if (!driver.check_only) {
//                 $$ = new ConditionStmtNode(
//             }
//         }
        ;

// ControlExpr
//        : kIF Expression
//         | kUNLESS Expression
//         // | kFOR QueryOrigin kWHERE Expression
//         ;

ConstantDecl
        : kCONST ConstantList {
            if (!driver.check_only) {
                $$ = new ConstDeclNode($2);
            }
        }
        ;

ConstantList
        : Constant {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ConstantList ',' Constant {
            if (!driver.check_only) {
                $$->push_back($3);
            }
        }
        ;

Constant
        : Identifier InitialValue {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_initial_value($2);
            }
        }
        | Identifier ReturnType InitialValue {
            if (!driver.check_only) {
                $$ = new VariableNode($1);
                ((VariableNode *) $$)
                  ->set_type($2)
                  ->set_initial_value($3);
            }
        }
        ;

StatementBlock
        : kBEGIN kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode(0);
            }
        }
        | kBEGIN Statements kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($2);
            }
        }
        | kBEGIN Statements EnsureClause kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($2);
                ((BlockStmtNode *) $$)
                  ->set_ensure($3);
            }
        }
        | kBEGIN Statements RescueClause kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($2);
                ((BlockStmtNode *) $$)
                  ->set_rescue($3);
            }
        }
        | kBEGIN Statements RescueClause EnsureClause kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($2);
                ((BlockStmtNode *) $$)
                  ->set_rescue($3)
                  ->set_ensure($4);
            }
        }
        | RequireClause kBEGIN Statements kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($3);
                ((BlockStmtNode *) $$)
                  ->set_require($1);
            }
        }
        | RequireClause kBEGIN Statements EnsureClause kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($3);
                ((BlockStmtNode *) $$)
                  ->set_require($1)
                  ->set_ensure($4);
            }
        }
        | RequireClause kBEGIN Statements RescueClause kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($3);
                ((BlockStmtNode *) $$)
                  ->set_require($1)
                  ->set_rescue($4);
            }
        }
        | RequireClause kBEGIN Statements RescueClause EnsureClause kEND {
            if (!driver.check_only) {
                $$ = new BlockStmtNode($3);
                ((BlockStmtNode *) $$)
                  ->set_require($1)
                  ->set_rescue($4)
                  ->set_ensure($5);
            }
        }
        ;

RequireClause
        : kREQUIRE {
            if (!driver.check_only) {
                $$ = 0;
            }
        }
        | kREQUIRE Conditions {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

Conditions
        : Condition ';' {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | Conditions Condition ';' {
            if (!driver.check_only) {
                $$->push_back($2);
            }
        }
        ;

Condition
        : LogicExpr {
            if (!driver.check_only) {
                $$ = new ValidationNode($1, 0);
            }
        }
        | LogicExpr RaiseStatement {
            if (!driver.check_only) {
                $$ = new ValidationNode($1, $2);
            }
        }
        ;

EnsureClause
        : kENSURE {
            if (!driver.check_only) {
                $$ = 0;
            }
        }
        | kENSURE Statements {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

RescueClause
        : kRESCUE {
            if (!driver.check_only) {
                $$ = new VectorNode();
            }
        }
        | kRESCUE WhenRescueClauseRepeat {
            if (!driver.check_only) {
                $$ = $2;
            }
        }
        ;

WhenRescueClauseRepeat
        : WhenRescueClause {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | WhenRescueClauseRepeat WhenRescueClause {
            if (!driver.check_only) {
                $$->push_back($2);
            }
        }
        ;

WhenRescueClause
        : kWHEN Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new WhenClauseNode($2, $4);
            }
        }
        ;

RetryStatement
        : kRETRY {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Retry);
            }
        }
//         | kRETRY QualifiedId {
//             if (!driver.check_only) {
//                 $$ = new ControlStmtNode(Control::Retry, $2);
//             }
//         }
//         | kRETRY INTEGER {
//             if (!driver.check_only) {
//                 $$ = new ControlStmtNode(Control::Retry, new IntegerNode($2));
//             }
//         }
        ;

ConditionalStatement
        : kIF Expression kTHEN Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
            }
        }
        | kIF Expression kTHEN Statement kELSE Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_else($6);
            }
        }
        | kIF Expression kTHEN Statement ElifStatementRepeat {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_elif($5);
            }
        }
        | kIF Expression kTHEN Statement ElifStatementRepeat kELSE Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_elif($5)
                  ->set_else($7);
            }
        }
        | kUNLESS Expression kTHEN Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::Unless, $2, $4);
            }
        }
        | kUNLESS Expression kTHEN Statement kELSE Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::Unless, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_else($6);
            }
        }
        | kUNLESS Expression kTHEN Statement ElifStatementRepeat {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_elif($5);
            }
        }
        | kUNLESS Expression kTHEN Statement ElifStatementRepeat kELSE Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_elif($5)
                  ->set_else($7);
            }
        }
        ;

ElifStatementRepeat
        : ElifStatement {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | ElifStatementRepeat ElifStatement {
            if (!driver.check_only) {
                $$->push_back($2);
            }
        }
        ;

ElifStatement
        : kELIF Expression kTHEN Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
            }
        }
        | kELIF Expression kTHEN Statement kELSE Statement {
            if (!driver.check_only) {
                $$ = new ConditionStmtNode(Condition::If, $2, $4);
                ((ConditionStmtNode *) $$)
                  ->set_else($6);
            }
        }
        ;

CaseStatement
        : kCASE Expression kEND {
            if (!driver.check_only) {
                $$ = new CaseStmtNode($2);
            }
        }
        | kCASE Expression kELSE Statement kEND {
            if (!driver.check_only) {
                $$ = new CaseStmtNode($2);
                ((CaseStmtNode *) $$)
                  ->set_else($4);
            }
        }
        | kCASE Expression WhenClauseRepeat kEND {
            if (!driver.check_only) {
                $$ = new CaseStmtNode($2);
                ((CaseStmtNode *) $$)
                  ->set_when($3);
            }
        }
        | kCASE Expression WhenClauseRepeat kELSE Statement kEND {
            if (!driver.check_only) {
                $$ = new CaseStmtNode($2);
                ((CaseStmtNode *) $$)
                  ->set_when($3)
                  ->set_else($5);
            }
        }
        ;

WhenClauseRepeat
        : WhenClause {
            if (!driver.check_only) {
                $$ = new VectorNode();
                $$->push_back($1);
            }
        }
        | WhenClauseRepeat WhenClause {
            if (!driver.check_only) {
                $$->push_back($2);
            }
        }
        ;

WhenClause
        : kWHEN Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new WhenClauseNode($2, $4);
            }
        }
        ;

ForStatement
        : kFOR Expression kASC Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new ForStmtNode($2, $4, Loop::Ascending, $6);
            }
        }
        | kFOR Expression kASC Expression kSTEP Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new ForStmtNode($2, $4, Loop::Ascending, $8);
                ((ForStmtNode *) $$)
                  ->set_step($6);
            }
        }
        | kFOR Expression kDESC Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new ForStmtNode($2, $4, Loop::Descending, $6);
            }
        }
        | kFOR Expression kDESC Expression kSTEP Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new ForStmtNode($2, $4, Loop::Descending, $8);
                ((ForStmtNode *) $$)
                  ->set_step($6);
            }
        }
        | kFOR QueryOrigin kDO Statement {
            if (!driver.check_only) {
                $$ = new ForStmtNode($2, 0, Loop::Iteration, $4);
            }
        }
        // | kFOREACH QueryOrigin kDO Statement
        ;

YieldStatement
        : kYIELD {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Yield);
            }
        }
        | kYIELD Expression {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Yield, $2);
            }
        }
        ;

LoopStatement
        : kWHILE Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new LoopStmtNode($2, $4, Loop::While);
            }
        }
        | kUNTIL Expression kDO Statement {
            if (!driver.check_only) {
                $$ = new LoopStmtNode($2, $4, Loop::Until);
            }
        }
        ;

// AsyncStatement
//         : kASYNC Statement {
//             if (!driver.check_only) {
//                 $$ = new AsyncNode(AsyncType::Statement, $2);
//             }
//         }
//         ;

RaiseStatement
        : kRAISE {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Raise);
            }
        }
        | kRAISE String {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Raise, $2);
            }
        }
        | kRAISE FunctionCall {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Raise, $2);
            }
        }
        ;

ReturnStatement
        : kRETURN {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Return);
            }
        }
        | kRETURN Expression {
            if (!driver.check_only) {
                $$ = new ControlStmtNode(Control::Return, $2);
            }
        }
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
//         | AssignExpr ControlExpr // TODO Criar nó: $2 then $1 else nil
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

LambdaExpr
        : kDEF FormalParamList '(' Expression ')' {
            if (!driver.check_only) {
                $$ = new LambdaExprNode($2, $4);
            }
        }
//         | kDEF FormalParamList sDEF Expression {
//             if (!driver.check_only) {
//                 $$ = new LambdaExprNode($2, $4);
//             }
//         }
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
                $$ = new AsyncNode(AsyncType::Expression, $2);
            }
        }
        | StatementBlock {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kASYNC StatementBlock {
            if (!driver.check_only) {
                $$ = new AsyncNode(AsyncType::Statement, $2);
            }
        }
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
        // TODO Se houver double comparison, isso fica inútil
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
        | RangeExpr sRGO AddExpr {
            if (!driver.check_only) {
                $$ = new BinaryExprNode(Operation::BinaryRangeOut, $1, $3);
            }
        }
        | RangeExpr sRGI AddExpr {
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
                $$ = new TernaryExprNode(Operation::TernarySlice, $$, $3, 0);
            }
        }
        | SuffixExpr '[' Expression ':' Expression ']' {
            if (!driver.check_only) {
                $$ = new TernaryExprNode(Operation::TernarySlice, $$, $3, $5);
            }
        }
        | SuffixExpr '[' ':' Expression ']' {
            if (!driver.check_only) {
                $$ = new TernaryExprNode(Operation::TernarySlice, $$, 0, $4);
            }
        }
        ;

Value
        : kNIL {
            if (!driver.check_only) {
                $$ = new NilNode();
            }
        }
//         | kSELF {
//             if (!driver.check_only) {
//                 $$ = new IdentifierNode("self");
//             }
//         }
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
        // | '[' NamedExpressionList ']' // Alternativa para criação de arranjos associativos
        | '[' ']' {
            if (!driver.check_only) {
                $$ = new ArrayNode();
            }
        }
        // | '[' Expression '|' QueryOrigin sDEF LogicExpr ']'
        // | '[' Expression '|' QueryOrigin kWHERE LogicExpr ']'
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
        | StatementBlock {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        ;

QueryExpr
        : kFROM QueryOrigin QueryBody {
            if (!driver.check_only) {
                $$ = new QueryNode($2, $3);
            }
        }
        | kFROM QueryOrigin {
            if (!driver.check_only) {
                $$ = new QueryNode($2, 0);
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
        : kWHERE LogicExpr {
            if (!driver.check_only) {
                $$ = new WhereNode($2);
            }
        }
        | JoinClause {
            if (!driver.check_only) {
                $$ = $1;
            }
        }
        | kORDER kBY OrderingItemList {
            if (!driver.check_only) {
                $$ = new OrderByNode($3);
            }
        }
        | RangeClause {
            if (!driver.check_only) {
                $$ = $1;
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
        : kGROUP kBY Expression {
            if (!driver.check_only) {
                $$ = new GroupByNode($3);
            }
        }
        | kSELECT ExpressionList {
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
