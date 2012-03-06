
%{
#include <string>

#include "driver.h"
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
    int             v_int;
    double          v_flt;
    std::string*    v_str;
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

%token  kAFTER      "after"
%token  kAND        "and"
%token  kASC        "asc"
%token  kASYNC      "async"
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
%token  kDIV        "div"
%token  kDO         "do"
%token  kELIF       "elif"
%token  kELSE       "else"
%token  kEND        "end"
%token  kEVENT      "event"
%token  kEXIT       "exit"
%token  kFALSE      "false"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kFULL       "full"
%token  kGET        "get"
%token  kGROUP      "group"
%token  kIF         "if"
%token  kIMPLIES    "implies"
%token  kIMPORT     "import"
%token  kINCLUDE    "include"
%token  kINLINE     "inline"
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
%token  kRESCUE     "rescue"
%token  kRIGHT      "right"
%token  kSELECT     "select"
%token  kSELF       "self"
%token  kSET        "set"
%token  kSIGNAL     "signal"
%token  kSKIP       "skip"
%token  kSTEP       "step"
%token  kTAKE       "take"
%token  kTHEN       "then"
%token  kTRUE       "true"
%token  kUNDEF      "undef"
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

%%

program : /* empty */
        | statements
        ;

/* Begin of literals */
t_id    : kSELF
        | kSELF '.' t_id
        | tID
        | tID '.' t_id
        ;

t_float : tFLOAT
        ;

t_integer
        : tINTEGER
        ;

t_string: tSTRING
        ;

t_regex : tREGEX
        ;

t_boolean
        : kFALSE
        | kTRUE
        ;

t_array : '[' ']'
        | '[' list_array_item ']'
        ;

list_array_item
        : primitive
        | list_array_item ',' primitive
        ;

t_hash  : '{' '}'
        | '{' list_hash_item '}'
        ;

list_hash_item
        : hash_item
        | list_hash_item ',' hash_item
        ;

hash_item
        : primitive ':' primitive
        ;

literal : kNIL
        | t_id
        | t_float
        | t_integer
        | t_string
        | t_regex
        | t_boolean
        | t_array
        | t_hash
        ;

primitive
        : literal
        | function_call
        | '(' expression ')'
        | '(' new_stmt ')'
        | '(' def_closure_stmt ')'
        | primitive '.' t_id
        | primitive '.' function_call
        | primitive '[' array_info ']'
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
        : primitive
        | kNOT primitive
        | '+' primitive %prec uADD
        | '-' primitive %prec uSUB
        ;

mult_expr
        : signed_expr
        | mult_expr '*' signed_expr
        | mult_expr '/' signed_expr
        | mult_expr kDIV signed_expr
        | mult_expr kMOD signed_expr
        ;

add_expr: mult_expr
        | add_expr '+' mult_expr
        | add_expr '-' mult_expr
        ;

relat_expr
        : add_expr
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
        : relat_expr
        | logic_expr kAND relat_expr
        | logic_expr kOR relat_expr
        | logic_expr kXOR relat_expr
        | logic_expr kIMPLIES relat_expr
        ;

ternary_expr
        : logic_expr
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
        | def_closure_stmt
        ;

control_clause
        : if_clause
        | unless_clause
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
/* End of special expressions */

expression
        : assign_expr
        | ternary_expr
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
        | kDO statements kEND
        | kDO statements rescue_clause kEND
        ;

rescue_clause
        : kRESCUE 
        | kRESCUE repeat_option_item
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
        | t_id initial_value
        | t_id member_type
        | t_id member_type initial_value
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
        | t_id member_type initial_value
        ;

attr_stmt
        : kATTR list_attribute
        ;

list_attribute
        : attribute
        | list_attribute ',' attribute
        ;

attribute
        : t_id
        | t_id setter
        | t_id getter
        | t_id getter setter
        | t_id initial_value
        | t_id initial_value setter
        | t_id initial_value getter
        | t_id initial_value getter setter
        | t_id member_type getter
        | t_id member_type getter setter
        | t_id member_type
        | t_id member_type setter
        | t_id member_type initial_value
        | t_id member_type initial_value setter
        | t_id member_type initial_value getter
        | t_id member_type initial_value getter setter
        ;

getter  : kGET
        | kGET t_id
        ;

setter  : kSET
        | kSET t_id
        ;

event_stmt
        : kEVENT list_event
        ;

list_event
        : event
        | list_event ',' event
        ;

event   : t_id intercept_clause
        ;

intercept_clause
        : kAFTER list_id
        | kBEFORE list_id
        | kSIGNAL list_id
        ;

undef_stmt
        : kUNDEF list_id
        ;

def_stmt: kDEF t_id
        | kDEF t_id raise_clause
        | kDEF t_id intercept_clause
        | kDEF t_id intercept_clause raise_clause
        | kDEF t_id member_type
        | kDEF t_id member_type raise_clause
        | kDEF t_id member_type intercept_clause
        | kDEF t_id member_type intercept_clause raise_clause
        | kDEF t_id '(' list_variable ')'
        | kDEF t_id '(' list_variable ')' raise_clause
        | kDEF t_id '(' list_variable ')' intercept_clause
        | kDEF t_id '(' list_variable ')' intercept_clause raise_clause
        | kDEF t_id '(' list_variable ')' member_type
        | kDEF t_id '(' list_variable ')' member_type raise_clause
        | kDEF t_id '(' list_variable ')' member_type intercept_clause
        | kDEF t_id '(' list_variable ')' member_type intercept_clause raise_clause
        ;

def_closure_stmt
        : kDEF block_stmt
        | kDEF member_type block_stmt
        | kDEF '(' list_variable ')' block_stmt
        | kDEF '(' list_variable ')' member_type block_stmt
        ;

class_stmt
        : kCLASS t_id block_stmt
        | kCLASS t_id heritance block_stmt
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
        | attr_stmt ';'
        | event_stmt ';'
        | undef_stmt ';'
        | def_stmt ';'
        | def_stmt block_stmt
        | class_stmt
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
        : statement
        | expression ';'
        | statements statement
        | statements expression ';'
        ;

%%

void Ares::Parser::error(const Parser::location_type& l, const std::string& m) {
    driver.error(l, m);
}
