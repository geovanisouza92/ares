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
%start Goal
%skeleton "lalr1.cc"
%define namespace "Ares::Compiler"
%define "parser_class_name" "Parser"
%parse-param { class Driver& driver }
%lex-param { class Driver& driver }
%locations
%error-verbose
%initial-action {
    @$.begin.filename = @$.end.filename = &driver.origin;
    driver.incLines ();
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

%token  <v_str> ID          "identifier literal"
%token  <v_flt> FLOAT       "float literal"
%token  <v_int> INTEGER     "integer literal"
%token  <v_str> CHAR        "char literal"
%token  <v_str> STRING      "string literal"
%token  <v_str> REGEX       "regex literal"

%nonassoc ID FLOAT INTEGER CHAR STRING REGEX

%token  kARRAY      "array"
%token  kASC        "asc"
%token  kBOOL       "bool"
%token  kBREAK      "break"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCATCH      "catch"
%token  kCHAR       "char"
%token  kCONST      "const"
%token  kCONTINUE   "continue"
%token  kDEFAULT    "default"
%token  kDESC       "desc"
%token  kDOUBLE     "double"
%token  kDO         "do"
%token  kELSE       "else"
%token  kENUM       "enum"
%token  kEXTERN     "extern"
%token  kFALSE      "false"
%token  kFINALLY    "finally"
%token  kFLOAT      "float"
%token  kFOREACH    "foreach"
%token  kFOR        "for"
%token  kFROM       "from"
%token  kGROUP      "group"
%token  kHASH       "hash"
%token  kIF         "if"
%token  kINT        "int"
%token  kIN         "in"
%token  kIS         "is"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kLOCK       "lock"
%token  kLONG       "long"
%token  kNULL       "null"
%token  kON         "on"
%token  kORDER      "order"
%token  kPARAMS     "params"
%token  kREGEX      "regex"
%token  kRETURN     "return"
%token  kRIGHT      "right"
%token  kSELECT     "select"
%token  kSHORT      "short"
%token  kSIZEOF     "sizeof"
%token  kSKIP       "skip"
%token  kSTATIC     "static"
%token  kSTEP       "step"
%token  kSTRING     "string"
%token  kSTRUCT     "struct"
%token  kSWITCH     "switch"
%token  kTAKE       "take"
%token  kTHROW      "throw"
%token  kTRUE       "true"
%token  kTRY        "try"
%token  kTYPEOF     "typeof"
%token  kUNLESS     "unless"
%token  kUSING      "using"
%token  kVAR        "var"
%token  kVOID       "void"
%token  kWHERE      "where"
%token  kWHILE      "while"
%token  kYIELD      "yield"

%token  ';'         ";"
%token  '{'         "{"
%token  '}'         "}"
%token  ','         ","
%token  '('         "("
%token  ')'         ")"
%token  ':'         ":"
%token  '='         "="
%token  '.'         "."
%token  '?'         "?"
%token  '^'         "^"
%token  '<'         "<"
%token  '>'         ">"
%token  '+'         "+"
%token  '-'         "-"
%token  '*'         "*"
%token  '/'         "/"
%token  '%'         "%"
%token  '!'         "!"
%token  '['         "["
%token  ']'         "]"
%token  '&'         "&"
%token  '|'         "|"
%token  '~'         "~"
%token  oADE        "+="
%token  oSUE        "-="
%token  oMUE        "*="
%token  oDIE        "/="
%token  oRAI        "..."
%token  oRAE        ".."
%token  oPOW        "**"
%token  oEQL        "=="
%token  oNEQ        "!="
%token  oLEE        "<="
%token  oGEE        ">="
%token  oMAT        "=~"
%token  oNMA        "!~"
%token  oFAR        "=>"
%token  oCOA        "??"
%token  oAND        "&&"
%token  oOR         "||"
%token  oINC        "++"
%token  oDEC        "--"
%token  oSHR        ">>"
%token  oSHL        "<<"
%token  oIND        "->"

%left ';' '{' '}' ',' '(' ')' ':' '=' '.' '?' '^' '<' '>' '+' '-' '*' '/'
%left '%' '!' '[' ']' '&' '|' '~'
%left oADE oSUE oMUE oDIE oRAI oRAE oPOW oEQL oNEQ oLEE oGEE oMAT oNMA oFAR
%left oCOA oAND oOR oINC oDEC oSHR oSHL oIND

%right UNARY

%%

Goal
    : /* empty */
    | GoalRepeat
    ;

GoalRepeat
    : SingleGoal
    | GoalRepeat SingleGoal
    ;

SingleGoal
    : UsingDirectiveRepeat
    | ExternalStatement
    | ExternalDeclaration
    ;

UsingDirectiveRepeat
    : UsingDirective
    | UsingDirectiveRepeat UsingDirective
    ;

UsingDirective
    : UsingAliasDirective
    | UsingModuleDirective
    ;

UsingAliasDirective
    : kUSING Identifier '=' QualifiedIdentifier ';'
    ;

// ModuleNameOrTypeDeclaration
//     : ModuleName
//     | TypeDeclaration
//     ;

UsingModuleDirective
    : kUSING QualifiedIdentifier ';'
    ;

ExternalStatement
    : Statement
    ;

ExternalDeclaration
    : TypeDeclaration
    ;

TypeDeclaration
    : StructDeclaration
    | EnumDeclaration
    | MethodDeclaration
    // | ClassDeclaration
    // | InterfaceDeclaration
    // | DelegateDeclaration
    ;

TypeModifierRepeat
    : TypeModifier
    | TypeModifierRepeat TypeModifier
    ;

TypeModifier
    : kSTATIC
    | kEXTERN
    // | kPRIVATE
    // | kPROTECTED
    // | kPUBLIC
    ;

StructDeclaration
    : kSTRUCT Identifier StructBody
    | TypeModifierRepeat kSTRUCT Identifier StructBody
    ;

StructBody
    : '{' StructMemberDeclarationRepeat '}'
    ;

StructMemberDeclarationRepeat
    : StructMemberDeclaration
    | StructMemberDeclarationRepeat StructMemberDeclaration
    ;

StructMemberDeclaration
    : VariableDeclaration ';'
    | ConstantDeclaration ';'
    ;

EnumDeclaration
    : kENUM Identifier EnumBody
    | TypeModifierRepeat kENUM Identifier EnumBody
    ;

EnumBody
    : '{' '}'
    | '{' EnumMemberDeclarationList '}'
    | '{' EnumMemberDeclarationList ',' '}'
    ;

EnumMemberDeclarationList
    : EnumMemberDeclaration
    | EnumMemberDeclarationList ',' EnumMemberDeclaration
    ;

EnumMemberDeclaration
    : Identifier
    | Identifier '=' Expression
    ;

MethodDeclaration
    : MethodHeader MethodBody
    ;

MethodHeader
    : ReturnType Identifier '(' ')'
    | ReturnType Identifier '(' FormalParameterList ')'
    | TypeModifierRepeat ReturnType Identifier '(' ')'
    | TypeModifierRepeat ReturnType Identifier '(' FormalParameterList ')'
    ;

ReturnType
    : Type
    | kVOID
    ;

MethodBody
    : Block
    | ';'
    ;

FormalParameterList
    : FixedParameterList
    | FixedParameterList ',' ParameterArray
    | FixedParameterList ',' InitializedParameterList
    | FixedParameterList ',' InitializedParameterList ',' ParameterArray
    | ParameterArray
    ;

FixedParameterList
    : FixedParameter
    | FixedParameterList ',' FixedParameter
    ;

FixedParameter
    : Type Identifier
    ;

InitializedParameterList
    : InitializedParameter
    | InitializedParameterList ',' InitializedParameter
    ;

InitializedParameter
    : Type Identifier '=' Expression
    ;

ParameterArray
    : kPARAMS ArrayType Identifier
    ;

Type
    : NonArrayType
    | ArrayType
    | kVAR
    ;

NonArrayType
    : TypeName
    | SimpleType
    ;

TypeName
    : QualifiedIdentifier
    ;

SimpleType
    : PrimitiveType
    | ClassType
    | PointerType
    | NullableType
    ;

PrimitiveType
    : NumericType
    | kBOOL
    ;

NumericType
    : IntegralType
    | FloatingPointType
    ;

IntegralType
    : kSHORT
    | kINT
    | kLONG
    | kLONG kLONG
    | kCHAR
    ;

FloatingPointType
    : kFLOAT
    | kDOUBLE
    ;

ClassType
    : kSTRING
    | kREGEX
    | kARRAY
    | kHASH
    ;

PointerType
    : Type '*'
    | kVOID '*'
    | PointerType '*'
    ;

NullableType
    : SimpleType '?'
    ;

ArrayType
    : Type ArraySpecifierRepeat
    ;

ArraySpecifierRepeat
    : ArraySpecifier
    | ArraySpecifierRepeat ArraySpecifier
    ;

ArraySpecifier
    : '[' ']'
    | '[' DimSeparators ']'
    ;

DimSeparators
    : ','
    | DimSeparators ','
    ;

Statement
    : DeclarationStatement
    | EmbeddedStatement
    // | LabeledStatement
    ;

DeclarationStatement
    : VariableDeclaration ';'
    | ConstantDeclaration ';'
    ;

VariableDeclaration
    : Type VariableDeclaratorList
    ;

VariableDeclaratorList
    : VariableDeclarator
    | VariableDeclaratorList ',' VariableDeclarator
    ;

VariableDeclarator
    : Identifier
    | Identifier '=' Expression
    ;

ConstantDeclaration
    : kCONST Type ConstantDeclaratorList
    ;

ConstantDeclaratorList
    : ConstantDeclarator
    | ConstantDeclaratorList ',' ConstantDeclarator
    ;

ConstantDeclarator
    : Identifier '=' Expression
    ;

EmbeddedStatement
    : Block
    | EmptyStatement
    | ExpressionStatement
    | SelectionStatement
    | IterationStatement
    | JumpStatement
    | TryStatement
    | LockStatement
    | UsingStatement
    | YieldStatement
    ;

Block
    : '{' '}'
    | '{' StatementRepeat '}'
    ;

StatementRepeat
    : Statement
    | StatementRepeat Statement
    ;

EmptyStatement
    : ';'
    ;

ExpressionStatement
    : StatementExpression ';'
    ;

StatementExpression
    : InvocationExpression
    // | ObjectCreationExpression
    | AssignmentExpression
    | PostIncrementExpression
    | PostDecrementExpression
    | PreIncrementExpression
    | PreDecrementExpression
    ;

SelectionStatement
    : IfStatement
    | UnlessStatement
    | SwitchStatement
    ;

IfStatement
    : kIF '(' Expression ')' EmbeddedStatement
    | kIF '(' Expression ')' EmbeddedStatement kELSE EmbeddedStatement
    ;

UnlessStatement
    : kUNLESS '(' Expression ')' EmbeddedStatement
    | kUNLESS '(' Expression ')' EmbeddedStatement kELSE EmbeddedStatement

SwitchStatement
    : kSWITCH '(' Expression ')' SwitchBlock
    ;

SwitchBlock
    : '{' '}'
    | '{' SwitchSectionRepeat '}'
    ;

SwitchSectionRepeat
    : SwitchSection
    | SwitchSectionRepeat SwitchSection
    ;

SwitchSection
    : SwitchLabelRepeat StatementRepeat
    ;

SwitchLabelRepeat
    : SwitchLabel
    | SwitchLabelRepeat SwitchLabel
    ;

SwitchLabel
    : kCASE Expression ':'
    | kDEFAULT ':'
    ;

IterationStatement
    : WhileStatement
    | DoStatement
    | ForStatement
    | ForeachStatement
    ;

WhileStatement
    : kWHILE '(' Expression ')' EmbeddedStatement
    ;

DoStatement
    : kDO EmbeddedStatement kWHILE '(' Expression ')' ';'
    ;

ForStatement
    : kFOR '(' ';' ';' ')' EmbeddedStatement
    | kFOR '(' ForInitialization ';' ';' ')' EmbeddedStatement
    | kFOR '(' ';' ForCondition ';' ')' EmbeddedStatement
    | kFOR '(' ';' ';' ForIncrement ')' EmbeddedStatement
    | kFOR '(' ForInitialization ';' ForCondition ';' ')' EmbeddedStatement
    | kFOR '(' ForInitialization ';' ';' ForIncrement ')' EmbeddedStatement
    | kFOR '(' ';' ForCondition ';' ForIncrement ')' EmbeddedStatement
    | kFOR '(' ForInitialization ';' ForCondition ';' ForIncrement ')' EmbeddedStatement
    ;

ForInitialization
    : VariableDeclaration
    | StatementExpressionList
    ;

StatementExpressionList
    : StatementExpression
    | StatementExpressionList ',' StatementExpression
    ;

ForCondition
    : Expression
    ;

ForIncrement
    : StatementExpressionList
    ;

ForeachStatement
    : kFOREACH '(' Type Identifier kIN Expression ')' EmbeddedStatement
    ;

JumpStatement
    : BreakStatement
    | ContinueStatement
    // | GotoStatement
    | ReturnStatement
    | ThrowStatement
    ;

BreakStatement
    : kBREAK ';'
    ;

ContinueStatement
    : kCONTINUE ';'
    ;

// GotoStatement
//     : kGOTO Identifier ';'
//     | kGOTO kCASE Expression ';'
//     | kGOTO kDEFAULT Expression ';'
//     ;

ReturnStatement
    : kRETURN ';'
    | kRETURN Expression ';'
    ;

ThrowStatement
    : kTHROW ';'
    | kTHROW Expression ';'
    ;

TryStatement
    : kTRY Block CatchClauses
    | kTRY Block FinallyClause
    | kTRY Block CatchClauses FinallyClause
    ;

CatchClauses
    : SpecificCatchClauseRepeat
    | SpecificCatchClauseRepeat GeneralCatchClause
    ;

SpecificCatchClauseRepeat
    : SpecificCatchClause
    | SpecificCatchClauseRepeat SpecificCatchClause
    ;

SpecificCatchClause
    : kCATCH '(' Type ')' Block
    | kCATCH '(' Type Identifier ')' Block
    ;

GeneralCatchClause
    : kCATCH Block
    ;

FinallyClause
    : kFINALLY Block
    ;

LockStatement
    : kLOCK '(' Expression ')' EmbeddedStatement
    ;

UsingStatement
    : kUSING '(' ResourceAquisition ')' EmbeddedStatement
    ;

ResourceAquisition
    : VariableDeclaration
    | Expression
    ;

YieldStatement
    : kYIELD ';'
    | kYIELD Expression ';'
    ;

Expression
    : AssignmentExpression
    | LambdaExpression
    | QueryExpression
    | ConditionalExpression
    ;

ExpressionList
    : Expression
    | ExpressionList ',' Expression
    ;

AssignmentExpression
    : UnaryExpression '=' Expression
    | UnaryExpression oADE Expression
    | UnaryExpression oSUE Expression
    | UnaryExpression oMUE Expression
    | UnaryExpression oDIE Expression
    ;

LambdaExpression
    : AnonymousFunctionSignature oFAR AnonymousFunctionBody
    ;

AnonymousFunctionSignature
    : ImplicitAnonymousParameter
    | '(' ImplicitAnonymousParameterList ')'
    | '(' ExplicitAnonymousParameterList ')'
    | '(' ')'
    ;

ImplicitAnonymousParameterList
    : ImplicitAnonymousParameter
    | ImplicitAnonymousParameterList ',' ImplicitAnonymousParameter
    ;

ImplicitAnonymousParameter
    : Identifier
    ;

ExplicitAnonymousParameterList
    : ExplicitAnonymousParameter
    | ExplicitAnonymousParameterList ',' ExplicitAnonymousParameter
    ;

ExplicitAnonymousParameter
    : Type Identifier
    ;

AnonymousFunctionBody
    : Expression
    | Block
    ;

QueryExpression
    : kFROM QueryOrigin
    | kFROM QueryOrigin QueryBody
    ;

QueryOrigin
    : Identifier kIN Expression
    ;

QueryBody
    : QueryBodyMemberRepeat SelectOrGroupClause
    | QueryBodyMemberRepeat
    | SelectOrGroupClause
    ;

QueryBodyMemberRepeat
    : QueryBodyMember 
    | QueryBodyMemberRepeat QueryBodyMember
    ;

QueryBodyMember
    : kWHERE ConditionalExpression %prec UNARY
    | kORDER kBY OrderExpression
    | JoinClause
    | RangeClause
    ;

JoinClause
    : kJOIN QueryOrigin kON ConditionalExpression %prec UNARY
    | kLEFT kJOIN QueryOrigin kON ConditionalExpression %prec UNARY
    | kRIGHT kJOIN QueryOrigin kON ConditionalExpression %prec UNARY
    ;

OrderExpression
    : Expression
    | Expression kASC
    | Expression kDESC
    ;

RangeClause
    : kSKIP Expression %prec UNARY
    | kSTEP Expression %prec UNARY
    | kTAKE Expression %prec UNARY
    ;

SelectOrGroupClause
    : kGROUP kBY Expression %prec UNARY
    | kSELECT ExpressionList
    ;

ConditionalExpression
    : NullCoalescingExpression
    | NullCoalescingExpression '?' Expression ':' Expression
    // | NullCoalescingExpression kBETWENN Expression kAND Expression
    ;

NullCoalescingExpression
    : RangeExpression
    | NullCoalescingExpression oCOA RangeExpression
    ;

RangeExpression
    : ConditionalOrExpression
    | RangeExpression oRAE ConditionalOrExpression
    | RangeExpression oRAI ConditionalOrExpression
    ;

ConditionalOrExpression
    : ConditionalAndExpression
    | ConditionalOrExpression oOR ConditionalAndExpression
    ;

ConditionalAndExpression
    : InclusiveOrExpression
    | ConditionalAndExpression oAND InclusiveOrExpression
    ;

InclusiveOrExpression
    : ExclusiveOrExpression
    | InclusiveOrExpression '|' ExclusiveOrExpression
    ;

ExclusiveOrExpression
    : AndExpression
    | ExclusiveOrExpression '^' AndExpression
    ;

AndExpression
    : ComparisonExpression
    | AndExpression '&' ComparisonExpression
    ;

ComparisonExpression
    : RelationalExpression
    | ComparisonExpression oEQL ShiftExpression
    | ComparisonExpression oNEQ ShiftExpression
    | ComparisonExpression oMAT ShiftExpression
    | ComparisonExpression oNMA ShiftExpression
    ;

RelationalExpression
    : ShiftExpression
    | RelationalExpression '<' ShiftExpression
    | RelationalExpression '>' ShiftExpression
    | RelationalExpression oLEE ShiftExpression
    | RelationalExpression oGEE ShiftExpression
    | RelationalExpression kIS Type
    // | RelationalExpression kAS Type
    ;

ShiftExpression
    : AdditiveExpression
    | ShiftExpression oSHR AdditiveExpression
    | ShiftExpression oSHL AdditiveExpression
    ;

AdditiveExpression
    : MultiplicativeExpression
    | AdditiveExpression '+' MultiplicativeExpression
    | AdditiveExpression '-' MultiplicativeExpression
    ;

MultiplicativeExpression
    : PowerExpression
    | MultiplicativeExpression '*' PowerExpression
    | MultiplicativeExpression '/' PowerExpression
    | MultiplicativeExpression '%' PowerExpression
    ;

PowerExpression
    : UnaryExpression
    | PowerExpression oPOW UnaryExpression
    ;

UnaryExpression
    : UnaryExpressionNotPlusMinus
    | '+' UnaryExpression %prec UNARY
    | '-' UnaryExpression %prec UNARY
    | '*' UnaryExpression %prec UNARY
    | PreIncrementExpression
    | PreDecrementExpression
    | AddressofExpression
    ;

UnaryExpressionNotPlusMinus
    : PostfixExpression
    | '!' UnaryExpression %prec UNARY
    | '~' UnaryExpression %prec UNARY
    | CastExpression
    ;

PostfixExpression
    : PrimaryExpression
    | QualifiedIdentifier
    | PostIncrementExpression
    | PostDecrementExpression
    | PointerMemberAccessExpression
    ;

PostDecrementExpression
    : PostfixExpression oDEC
    ;

PostIncrementExpression
    : PostfixExpression oINC
    ;

PointerMemberAccessExpression
    : PostfixExpression oIND Identifier
    ;

CastExpression
    : '(' Type ')' UnaryExpression %prec UNARY
    ;

PreIncrementExpression
    : oINC PostfixExpression %prec UNARY
    ;

PreDecrementExpression
    : oDEC PostfixExpression %prec UNARY
    ;

AddressofExpression
    : '&' UnaryExpression %prec UNARY
    ;

PrimaryExpression
    : ParenthesizedExpression
    | PrimaryExpressionNoParentesis
    ;

ParenthesizedExpression
    : '(' Expression ')'
    ;

PrimaryExpressionNoParentesis
    : LiteralValue
    | MemberAccessExpression
    // | ThisAccessExpression
    // | BaseAccessExpression
    | ElementAccessExpression
    | InvocationExpression
    // | NewExpression
    | TypeofExpression
    | SizeofExpression
    ;

// NewExpression
//     : ArrayCreationExpression
//     | ObjectCreationExpression
//     ;

// ArrayCreationExpression
//     : kNEW Type ArrayInitializer
//     | kNEW Type '[' ExpressionList ']'
//     | kNEW Type '[' ExpressionList ']' ArrayInitializer
//     ;

// ArrayInitializer
//     :
//     ;

// ObjectCreationExpression
//     :
//     ;

MemberAccessExpression
    : PrimaryExpression '.' Identifier
    | PrimitiveType '.' Identifier
    | ClassType '.' Identifier
    ;

ElementAccessExpression
    : PrimaryExpression '[' Expression ']'
    | QualifiedIdentifier '[' Expression ']'
    ;

InvocationExpression
    : QualifiedIdentifier '(' ')'
    | QualifiedIdentifier '(' ArgumentExpressionList ')'
    | PrimaryExpressionNoParentesis '(' ')'
    | PrimaryExpressionNoParentesis '(' ArgumentExpressionList ')'
    ;

QualifiedIdentifier
    : Identifier
    | Qualifier Identifier
    ;

Qualifier
    : Identifier '.'
    | Qualifier Identifier '.'
    ;

ArgumentExpressionList
    : Expression
    | ArgumentExpressionList ',' Expression
    ;

TypeofExpression
    : kTYPEOF '(' Type ')'
    ;

SizeofExpression
    : kSIZEOF '(' Type ')'
    ;

LiteralValue
    : kNULL
    | HashLiteral
    | ArrayLiteral
    | IntegerLiteral
    | FloatLiteral
    | StringLiteral
    | RegexLiteral
    | CharLiteral
    | BooleanLiteral
    ;

HashLiteral
    : '{' ':' '}'
    | '{' KeyValuePairList '}'
    ;

KeyValuePairList
    : KeyValuePair
    | KeyValuePairList ',' KeyValuePair
    ;

KeyValuePair
    : Identifier ':' Expression
    | StringLiteral ':' Expression
    ;

ArrayLiteral
    : '[' ']'
    | '[' ExpressionList ']'
    ;

IntegerLiteral
    : INTEGER
    ;

FloatLiteral
    : FLOAT
    ;

StringLiteral
    : STRING
    | StringLiteral STRING
    ;

RegexLiteral
    : REGEX
    ;

CharLiteral
    : CHAR
    ;

BooleanLiteral
    : kFALSE
    | kTRUE
    ;

Identifier
    : ID
    ;

%%

namespace LANG_NAMESPACE
{
    namespace Compiler
    {
        void
        Parser::error (const Parser::location_type& l, const std::string& m)
        {
            driver.error (l, m);
        }
    } // Compiler
} // LANG_NAMESPACE
