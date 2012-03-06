
%{
#include <vector>

using namespace std;

#include "ast.h"
#include "driver.h"

using namespace AST;
%}

%debug

%require "2.3"
%start program
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
    int                         v_int;
    double                      v_flt;
    string *                    v_str;
    class AST::SyntaxNode *     v_node;
    class AST::VectorNode *     v_list;
}

%{
#include "scanner.h"

#undef yylex
#define yylex driver.lexer->lex
%}

%token          sEOF    0   "end of file"

%token  <v_str> tID         "identifier"
%token  <v_flt> tFLOAT      "float"
%token  <v_int> tINTEGER    "integer"
%token  <v_str> tSTRING     "string"
%token  <v_str> tREGEX      "regex"

%token  kABSTRACT   "abstract"
%token  kAND        "and"
%token  kASC        "asc"
%token  kASYNC      "async"
%token  kBETWEEN    "between"
%token  kBREAK      "break"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCLASS      "class"
%token  kCONST      "const"
%token  kDEF        "def"
%token  kDESC       "desc"
%token  kDIV        "div"
%token  kDO         "do"
%token  kELIF       "elif"
%token  kELSE       "else"
%token  kEND        "end"
%token  kENSURE     "ensure"
%token  kEXIT       "exit"
%token  kFALSE      "false"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kFULL       "full"
%token  kGROUP      "group"
%token  kIF         "if"
%token  kIMPLIES    "implies"
%token  kIMPORT     "import"
%token  kINCLUDE    "include"
%token  kINLINE     "inline"
%token  kINVARIANTS "invariants"
%token  kIN         "in"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kMODULE     "module"
%token  kMOD        "mod"
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
%token  kRIGHT      "right"
%token  kSEALED     "sealed"
%token  kSELECT     "select"
%token  kSELF       "self"
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

%token  ';' ':' ',' '.' '[' ']' '{' '}' '(' ')' '+' '-' '*' '/' '<' '>' '?'

%token  sLEE        "<="
%token  sGEE        ">="
%token  sEQL        "=="
%token  sNEQ        "!="
%token  sIDE        "==="
%token  sMAT        "=~"
%token  sNMA        "!~"
%token  sADE        "+="
%token  sSUE        "-="
%token  sMUE        "*="
%token  sDIE        "/="

%nonassoc tID tFLOAT tINTEGER tSTRING tREGEX

%left kAND kOR kXOR kIMPLIES kBY kDIV kMOD kBETWEEN
%right kFULL kLEFT kRIGHT kNOT

%left '+' '-' '*' '/' '?' ':' '.' ','
%right '=' sADE sSUE sMUE sDIE uADD uSUB

%type   <v_node>    t_id
%type   <v_node>    t_float
%type   <v_node>    t_integer
%type   <v_node>    t_string
%type   <v_node>    t_regex
%type   <v_node>    t_boolean
%type   <v_node>    t_array
%type   <v_node>    t_hash
%type   <v_node>    hash_item
%type   <v_node>    literal
%type   <v_node>    primitive

%type   <v_list>    list_array_item
%type   <v_list>    list_hash_item

%type   <v_node>    program
%type   <v_node>    statement
%type   <v_node>    signed_expr
%type   <v_node>    mult_expr
%type   <v_node>    add_expr
%type   <v_node>    relat_expr
%type   <v_node>    logic_expr
%type   <v_node>    ternary_expr
%type   <v_node>    expression

%type   <v_list>    statements

%destructor { delete $$; } list_array_item
%destructor { delete $$; } list_hash_item
%destructor { delete $$; } statements

%%

program : /* empty */
        | statements {
            driver.Env->add_stmts($1);
        }
        ;

/* Begin of literals */
t_id    : kSELF {
            $$ = new IdentifierNode("self");
        }
        | kSELF '.' t_id
        | tID {
            $$ = new IdentifierNode(*$1);
        }
        | tID '.' t_id
        ;

t_float : tFLOAT {
            $$ = new FloatNode($1);
        }
        ;

t_integer
        : tINTEGER {
            $$ = new IntegerNode($1);
        }
        ;

t_string: tSTRING {
            $$ = new StringNode(*$1);
        }
        ;

t_regex : tREGEX {
            $$ = new RegexNode(*$1);
        }
        ;

t_boolean
        : kFALSE {
            $$ = new BooleanNode(false);
        }
        | kTRUE {
            $$ = new BooleanNode(true);
        }
        ;

t_array : '[' ']' {
            $$ = new ArrayNode();
        }
        | '[' list_array_item ']' {
            $$ = new ArrayNode($2);
        }
        ;

list_array_item
        : primitive {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | list_array_item ',' primitive {
            $$->push_back($3);
        }
        ;

t_hash  : '{' '}' {
            $$ = new HashNode();
        }
        | '{' list_hash_item '}' {
            $$ = new HashNode($2);
        }
        ;

list_hash_item
        : hash_item {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | list_hash_item ',' hash_item {
            $$->push_back($3);
        }
        ;

hash_item
        : primitive ':' primitive {
            $$ = new HashItemNode($1, $3);
        }
        ;

literal : kNIL {
            $$ = new NilNode();
        }
        | t_id {
            $$ = $1;
        }
        | t_float {
            $$ = $1;
        }
        | t_integer {
            $$ = $1;
        }
        | t_string {
            $$ = $1;
        }
        | t_regex {
            $$ = $1;
        }
        | t_boolean {
            $$ = $1;
        }
        | t_array {
            $$ = $1;
        }
        | t_hash {
            $$ = $1;
        }
        ;

primitive
        : literal {
            $$ = $1;
        }
        | function_call
        | '(' expression ')' {
            $$ = $2;
        }
        | '(' new_stmt ')'
        | primitive '.' t_id
        | primitive '.' function_call
        | primitive '[' array_info ']'
        ;

function_call
        : t_id '(' ')'
        | t_id '(' list_param_value ')'
        ;

list_param_value
        : param_value
        | list_param_value ',' param_value
        ;

param_value
        : expression
        | new_stmt
        | block_stmt
        | def_stmt
        ;

array_info
        : array_index
        | array_index ':'
        | array_index ':' array_index
        | ':' array_index
        ;

array_index
        : t_id
        | t_integer
        | t_string
        | function_call
        ;
/* End of literals */

/* Begin of common expressions */
signed_expr
        : primitive {
            $$ = $1;
        }
        | kNOT primitive
        | '+' primitive %prec uADD
        | '-' primitive %prec uSUB
        ;

mult_expr
        : signed_expr {
            $$ = $1;
        }
        | mult_expr '*' signed_expr
        | mult_expr '/' signed_expr
        | mult_expr kDIV signed_expr
        | mult_expr kMOD signed_expr
        ;

add_expr: mult_expr {
            $$ = $1;
        }
        | add_expr '+' mult_expr
        | add_expr '-' mult_expr
        ;

relat_expr
        : add_expr {
            $$ = $1;
        }
        | relat_expr '<' add_expr
        | relat_expr sLEE add_expr
        | relat_expr '>' add_expr
        | relat_expr sGEE add_expr
        | relat_expr sEQL add_expr
        | relat_expr sNEQ add_expr
        | relat_expr sIDE add_expr
        | relat_expr sMAT add_expr
        | relat_expr sNMA add_expr
        ;

logic_expr
        : relat_expr {
            $$ = $1;
        }
        | logic_expr kAND relat_expr
        | logic_expr kOR relat_expr
        | logic_expr kXOR relat_expr
        | logic_expr kIMPLIES relat_expr
        ;

ternary_expr
        : logic_expr {
            $$ = $1;
        }
        | expression kBETWEEN relat_expr kAND relat_expr
        | expression '?' assign_value ':' assign_value
        ;
/* End of common expressions */

/* Begin of Object Query Language expressions */
query_expr
        : from_clause
        | from_clause select_clause
        | from_clause order_clause
        | from_clause order_clause select_clause
        | from_clause group_clause
        | from_clause group_clause select_clause
        | from_clause group_clause order_clause
        | from_clause group_clause order_clause select_clause
        | from_clause where_clause
        | from_clause where_clause select_clause
        | from_clause where_clause order_clause
        | from_clause where_clause order_clause select_clause
        | from_clause where_clause group_clause
        | from_clause where_clause group_clause select_clause
        | from_clause where_clause group_clause order_clause
        | from_clause where_clause group_clause order_clause select_clause
        | from_clause repeat_join_clause
        | from_clause repeat_join_clause select_clause
        | from_clause repeat_join_clause order_clause
        | from_clause repeat_join_clause order_clause select_clause
        | from_clause repeat_join_clause group_clause
        | from_clause repeat_join_clause group_clause select_clause
        | from_clause repeat_join_clause group_clause order_clause
        | from_clause repeat_join_clause group_clause order_clause select_clause
        | from_clause repeat_join_clause where_clause
        | from_clause repeat_join_clause where_clause select_clause
        | from_clause repeat_join_clause where_clause order_clause
        | from_clause repeat_join_clause where_clause order_clause select_clause
        | from_clause repeat_join_clause where_clause group_clause
        | from_clause repeat_join_clause where_clause group_clause select_clause
        | from_clause repeat_join_clause where_clause group_clause order_clause
        | from_clause repeat_join_clause where_clause group_clause order_clause select_clause
        ;

from_clause
        : kFROM list_from_item
        ;

list_from_item
        : from_item
        | list_from_item ',' from_item
        ;

from_item
        : primitive
        | primitive from_origin
        ;

from_origin
        : kIN primitive
        ;

repeat_join_clause
        : join_clause
        | repeat_join_clause join_clause
        ;

join_clause
        : kJOIN from_item kON logic_expr
        | kFULL kJOIN from_item kON logic_expr
        | kLEFT kJOIN from_item kON logic_expr
        | kRIGHT kJOIN from_item kON logic_expr
        ;

where_clause
        : kWHERE logic_expr
        ;

group_clause
        : kGROUP kBY list_id
        ;

list_id : t_id
        | list_id ',' t_id
        ;

order_clause
        : kORDER kBY list_id
        ;

select_clause
        : kSELECT list_id
        | kSELECT take_clause list_id
        | kSELECT step_clause list_id
        | kSELECT step_clause take_clause list_id
        | kSELECT skip_clause list_id
        | kSELECT skip_clause take_clause list_id
        | kSELECT skip_clause step_clause list_id
        | kSELECT skip_clause step_clause take_clause list_id
        | kSELECT ord_op list_id
        | kSELECT ord_op take_clause list_id
        | kSELECT ord_op step_clause list_id
        | kSELECT ord_op step_clause take_clause list_id
        | kSELECT ord_op skip_clause list_id
        | kSELECT ord_op skip_clause take_clause list_id
        | kSELECT ord_op skip_clause step_clause list_id
        | kSELECT ord_op skip_clause step_clause take_clause list_id
        ;

ord_op  : kASC
        | kDESC
        ;

skip_clause
        : kSKIP primitive
        ;

step_clause
        : kSTEP primitive
        ;

take_clause
        : kTAKE primitive
        ;
/* End of Object Query Language expressions */

/* Begin of special expressions */
assign_expr
        : t_id '=' assign_value
        | t_id sADE assign_value
        | t_id sSUE assign_value
        | t_id sMUE assign_value
        | t_id sDIE assign_value
        ;

assign_value
        : expression
        | expression control_clause
        | new_stmt
        | async_stmt
        | block_stmt
        ;

control_clause
        : if_clause
        | unless_clause
        ;
/* End of special expressions */

expression
        : assign_expr
        | ternary_expr {
            $$ = $1;
        }
        | query_expr
        ;

// expressions
//         : expression ';'
//         | expressions expression ';'
//         ;

/* Begin of statements */
if_stmt : if_clause then_clause kEND
        | if_clause then_clause else_clause kEND
        | if_clause then_clause repeat_elif_clause kEND
        | if_clause then_clause repeat_elif_clause else_clause kEND
        ;

if_clause
        : kIF expression
        | kIF expression where_clause
        ;

then_clause
        : kTHEN 
        | kTHEN statements
        ;

repeat_elif_clause
        : elif_clause
        | repeat_elif_clause elif_clause
        ;

elif_clause
        : kELIF expression then_clause
        | kELIF expression where_clause then_clause
        ;

else_clause
        : kELSE 
        | kELSE statements
        ;

unless_stmt
        : unless_clause then_clause kEND
        | unless_clause then_clause else_clause kEND
        ;

unless_clause
        : kUNLESS expression
        | kUNLESS expression where_clause
        ;

case_stmt
        : kCASE expression kEND
        | kCASE expression repeat_option_item kEND
        | kCASE expression repeat_option_item else_clause kEND
        | kCASE expression where_clause kEND
        | kCASE expression where_clause repeat_option_item kEND
        | kCASE expression where_clause repeat_option_item else_clause kEND
        ;

repeat_option_item
        : option_item
        | repeat_option_item option_item
        ;

option_item
        : kWHEN expression block_stmt
        ;

for_stmt: for_expr kASC expression block_stmt
        | for_expr kASC expression step_clause block_stmt
        | for_expr kDESC expression block_stmt
        | for_expr kDESC expression step_clause block_stmt
        | for_expr kIN expression block_stmt
        ;

for_expr: kFOR expression
        | kFOR var_stmt
        ;

loop_stmt
        : kWHILE expression block_stmt
        | kUNTIL expression block_stmt
        ;

async_stmt
        : kASYNC statement
        | kASYNC expression
        ;

new_stmt: kNEW function_call
        | kNEW kCLASS kFROM expression
        ;

raise_clause
        : kRAISE
        | kRAISE t_string
        | kRAISE new_stmt
        ;

control_stmt
        : kBREAK
        | kEXIT
        | kEXIT expression
        ;

block_stmt
        : kDO kEND
        | kDO ensure_clause kEND
        | kDO rescue_clause kEND
        | kDO rescue_clause ensure_clause kEND
        | kDO statements kEND
        | kDO statements ensure_clause kEND
        | kDO statements rescue_clause kEND
        | kDO statements rescue_clause ensure_clause kEND
        | kDO require_clause kEND
        | kDO require_clause ensure_clause kEND
        | kDO require_clause rescue_clause kEND
        | kDO require_clause rescue_clause ensure_clause kEND
        | kDO require_clause statements kEND
        | kDO require_clause statements ensure_clause kEND
        | kDO require_clause statements rescue_clause kEND
        | kDO require_clause statements rescue_clause ensure_clause kEND
        ;

require_clause
        : kREQUIRE kEND
        | kREQUIRE statements kEND
        ;

rescue_clause
        : kRESCUE 
        | kRESCUE repeat_option_item
        ;

ensure_clause
        : kENSURE kEND
        | kENSURE statements kEND
        ;
/* End of statements */

/* Begin of type declaration */
visibility_stmt
        : kPRIVATE
        | kPROTECTED
        | kPUBLIC
        ;

include_stmt
        : kINCLUDE list_linkable
        ;

import_stmt
        : kIMPORT list_linkable
        ;

list_linkable
        : linkable
        | list_linkable ',' linkable
        ;

linkable: t_id
        | t_string
        ;

var_stmt: kVAR list_variable
        ;

list_variable
        : variable
        | list_variable ',' variable
        ;

variable: t_id
        | t_id invariants_clause
        | t_id initial_value
        | t_id initial_value invariants_clause
        | t_id member_type
        | t_id member_type invariants_clause
        | t_id member_type initial_value
        | t_id member_type initial_value invariants_clause
        ;

invariants_clause
        : kINVARIANTS logic_expr
        ;

member_type
        : ':' primitive
        ;

initial_value
        : '=' assign_value
        ;

const_stmt
        : kCONST list_constant
        ;

list_constant
        : constant
        | list_constant ',' constant
        ;

constant: t_id initial_value
        | t_id initial_value invariants_clause
        | t_id member_type initial_value
        | t_id member_type initial_value invariants_clause
        ;

def_stmt: kDEF t_id
        | kDEF t_id raise_clause
        | kDEF t_id member_type
        | kDEF t_id member_type raise_clause
        | kDEF t_id '(' list_variable ')'
        | kDEF t_id '(' list_variable ')' raise_clause
        | kDEF t_id '(' list_variable ')' member_type
        | kDEF t_id '(' list_variable ')' member_type raise_clause
        ;

class_stmt
        : kCLASS t_id
        | kCLASS t_id heritance
        | kABSTRACT kCLASS t_id
        | kABSTRACT kCLASS t_id heritance
        | kSEALED kCLASS t_id
        | kSEALED kCLASS t_id heritance
        ;

heritance
        : '>' list_id
        ;

module_stmt
        : kMODULE t_id block_stmt
        ;

type_decl_stmt
        : visibility_stmt
        | include_stmt ';'
        | import_stmt ';'
        | var_stmt ';'
        | const_stmt ';'
        | def_stmt ';'
        | def_stmt block_stmt
        | class_stmt ';'
        | class_stmt block_stmt
        | module_stmt
        ;
/* End of type declaration */

delegate_stmt
        : kINLINE t_id t_string
        ;

statement
        : if_stmt
        | unless_stmt
        | case_stmt
        | for_stmt
        | loop_stmt
        | async_stmt ';'
        | new_stmt ';'
        | raise_clause ';'
        | control_stmt ';'
        | block_stmt
        | type_decl_stmt
        | delegate_stmt ';'
        ;

statements
        : statement {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | expression ';' {
            $$ = new VectorNode();
            $$->push_back($1);
        }
        | statements statement {
            $$->push_back($2);
        }
        | statements expression ';' {
            $$->push_back($2);
        }
        ;

%%

void Ares::Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}
