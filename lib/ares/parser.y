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

%debug
%require "2.3"
%start Goal /* CompilationUnit */
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

%token  <v_str> IDENTIFIER  "identifier literal"
%token  <v_flt> FLOAT       "float literal"
%token  <v_int> INTEGER     "integer literal"
%token  <v_str> CHAR        "char literal"
%token  <v_str> STRING      "string literal"
%token  <v_str> REGEX       "regex literal"

%nonassoc IDENTIFIER FLOAT INTEGER CHAR STRING REGEX

%token  kARRAY      "array"
%token  kASC        "asc"
%token  kASYNC      "async"
%token  kAWAIT      "await"
%token  kBOOL       "bool"
%token  kBREAK      "break"
%token  kBYTE       "byte"
%token  kBY         "by"
%token  kCASE       "case"
%token  kCATCH      "catch"
%token  kCHAR       "char"
%token  kCONST      "const"
%token  kCONTINUE   "continue"
%token  kDECIMAL    "decimal"
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
%token  kINTO       "into"
%token  kINT        "int"
%token  kIN         "in"
%token  kIS         "is"
%token  kJOIN       "join"
%token  kLEFT       "left"
%token  kLET        "let"
%token  kLOCK       "lock"
%token  kLONG       "long"
%token  kNEW        "new"
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
%token  kUINT       "uint"
%token  kULONG      "ulong"
%token  kUNLESS     "unless"
%token  kUSHORT     "ushort"
%token  kUSING      "using"
%token  kVAR        "var"
%token  kVOID       "void"
%token  kWHERE      "where"
%token  kWHILE      "while"
%token  kYIELD      "yield"

%left kON kIN
%right kFROM kWHERE kORDER kGROUP kBY kSELECT kJOIN kLEFT kRIGHT
%right kSKIP kSTEP kTAKE

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
%token  oMOE        "%="
%token  oXOE        "^="
%token  oORE        "|="
%token  oANE        "&="
%token  oSLE        "<<="
%token  oSRE        ">>="
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
%left oCOA oAND oOR oINC oDEC oSHR oSHL oIND oMOE oXOE oORE oANE oSLE oSRE

%right UNARY

%%

Goal
    : /* empty */
    | GoalOptionRepeat
    ;

GoalOptionRepeat
    : GoalOption
    | GoalOptionRepeat GoalOption
    ;

GoalOption
    : TypeDeclaration
    | UsingDirectiveRepeat
    // | Statement
    ;

Literal
    : kNULL
    | INTEGER
    | FLOAT
    | CHAR
    | STRING
    | REGEX
    | BooleanLiteral
    | ArrayLiteral
    | HashLiteral
    ;

BooleanLiteral
    : kFALSE
    | kTRUE
    ;

ArrayLiteral
    : '[' ExpressionListOpt ']'
    | '[' ExpressionListOpt ',' ']'
    ;

ExpressionListOpt
    : /* empty */
    | ExpressionList
    ;

HashLiteral
    : '{' KeyValuePairListOpt '}'
    | '{' KeyValuePairList ',' '}'
    ;

KeyValuePairListOpt
    : /* empty */
    | KeyValuePairList
    ;

KeyValuePairList
    : KeyValuePair
    | KeyValuePairList ',' KeyValuePair
    ;

KeyValuePair
    : IDENTIFIER ':' Expression
    | STRING ':' Expression
    ;

ModuleName
    : QualifiedIdentifier
    ;

TypeName
    : QualifiedIdentifier
    ;

Type
    : NonArrayType
    | ArrayType
    | kVAR
    ;

NonArrayType
    : SimpleType
    | TypeName
    ;

SimpleType
    : PrimitiveType
    | ClassType
    | PointerType
    ;

PrimitiveType
    : NumericType
    | kBOOL
    ;

NumericType
    : IntegralType
    | FloatingPointType
    | kDECIMAL
    ;

IntegralType
    : kBYTE
    | kSHORT
    | kUSHORT
    | kINT
    | kUINT
    | kLONG
    | kLONG kLONG
    | kULONG
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
    // | kOBJECT
    ;

PointerType
    : Type '*'
    | kVOID '*'
    ;

ArrayType
    : ArrayType RankSpecifier
    | SimpleType RankSpecifier
    | QualifiedIdentifier RankSpecifier
    ;

RankSpecifier
    : '[' DimSeparatorsOpt ']'
    ;

DimSeparatorsOpt
    : /* empty */
    | DimSeparators
    ;

DimSeparators
    : ','
    | DimSeparators ','
    ;

ArgumentList
    : Argument
    | ArgumentList ',' Argument
    ;

Argument
    : Expression
    ;

PrimaryExpression
    : ParenthesizedExpression
    | PrimaryExpressionNoParentesis
    ;

ParenthesizedExpression
    : '(' Expression ')'
    ;

PrimaryExpressionNoParentesis
    : Literal
    | ArrayCreationExpression
    | MemberAccess
    | InvocationExpression
    | ArraySlice
    | ElementAccess
    // | ThisAccess
    // | BaseAccess
    | NewExpression
    | TypeofExpression
    | SizeofExpression
    ;

ArrayCreationExpression
    : kNEW NonArrayType '[' ExpressionList ']' ArrayInitializerOpt
    | kNEW ArrayType ArrayInitializerOpt
    ;

ArrayInitializerOpt
    : /* empty */
    | HashLiteral
    ;

MemberAccess
    : PrimaryExpression '.' IDENTIFIER
    | PrimitiveType '.' IDENTIFIER
    | ClassType '.' IDENTIFIER
    ;

InvocationExpression
    : PrimaryExpressionNoParentesis '(' ArgumentList ')'
    | QualifiedIdentifier '(' ArgumentListOpt ')'
    ;

ArgumentListOpt
    : /* empty */
    | ArgumentList
    ;

ArraySlice
    : PrimaryExpression '[' Expression ':' ']'
    | PrimaryExpression '[' ':' Expression ']'
    | PrimaryExpression '[' Expression ':' Expression ']'
    | QualifiedIdentifier '[' Expression ':' ']'
    | QualifiedIdentifier '[' ':' Expression ']'
    | QualifiedIdentifier '[' Expression ':' Expression ']'
    ;

ElementAccess
    : PrimaryExpression '[' ExpressionList ']'
    | QualifiedIdentifier '[' ExpressionList ']'
    ;

ExpressionList
    : Expression
    | ExpressionList ',' Expression
    ;

// ThisAccess
//     : kTHIS
//     ;

// BaseAccess
//     : kBASE '.' IDENTIFIER
//     | kBASE '[' ExpressionList ']'
//     ;

PostIncrementExpression
    : PostfixExpression oINC
    ;

PostDecrementExpression
    : PostfixExpression oDEC
    ;

NewExpression
    : ObjectCreationExpression
    ;

ObjectCreationExpression
    : kNEW Type '(' ArgumentListOpt ')'
    ;

TypeofExpression
    : kTYPEOF '(' Type ')'
    | kTYPEOF '(' kVOID ')'
    ;

SizeofExpression
    : kSIZEOF '(' Type ')'
    // | kSIZEOF '(' Expression ')'
    ;

PointerMemberAccess
    : PostfixExpression oIND IDENTIFIER
    ;

AddressofExpression
    : '&' UnaryExpression %prec UNARY
    ;

PostfixExpression
    : PrimaryExpression
    | QualifiedIdentifier
    | PostIncrementExpression
    | PostDecrementExpression
    | PointerMemberAccess
    ;

UnaryExpressionNotPlusMinus
    : PostfixExpression
    | '!' UnaryExpression %prec UNARY
    | '~' UnaryExpression %prec UNARY
    | CastExpression
    ;

PreIncrementExpression
    : oINC UnaryExpression %prec UNARY
    ;

PreDecrementExpression
    : oDEC UnaryExpression %prec UNARY
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

CastExpression
    : /* '(' Type ')' UnaryExpressionNotPlusMinus
    | */ '(' Expression ')' UnaryExpressionNotPlusMinus
    | '(' MultiplicativeExpression '*' ')' UnaryExpressionNotPlusMinus
    | '(' QualifiedIdentifier RankSpecifier TypeQualsOpt ')' UnaryExpressionNotPlusMinus
    | '(' PrimitiveType TypeQualsOpt ')' UnaryExpressionNotPlusMinus
    | '(' ClassType TypeQualsOpt ')' UnaryExpressionNotPlusMinus
    | '(' kVOID TypeQualsOpt ')' UnaryExpressionNotPlusMinus //*/
    ;

TypeQualsOpt
    : /* empty */
    | TypeQuals
    ;

TypeQuals
    : TypeQual
    | TypeQuals TypeQual
    ;

TypeQual
    : RankSpecifier
    | '*'
    ;

PowerExpression
    : UnaryExpression
    | PowerExpression oPOW UnaryExpression
    ;

MultiplicativeExpression
    : PowerExpression
    | MultiplicativeExpression '*' PowerExpression
    | MultiplicativeExpression '/' PowerExpression
    | MultiplicativeExpression '%' PowerExpression
    ;

AdditiveExpression
    : MultiplicativeExpression
    | AdditiveExpression '+' MultiplicativeExpression
    | AdditiveExpression '-' MultiplicativeExpression
    ;

ShiftExpression
    : AdditiveExpression
    | ShiftExpression oSHL AdditiveExpression
    | ShiftExpression oSHR AdditiveExpression
    ;

RelationalExpression
    : ShiftExpression
    | RelationalExpression '<' ShiftExpression
    | RelationalExpression '>' ShiftExpression
    | RelationalExpression oLEE ShiftExpression
    | RelationalExpression oGEE ShiftExpression
    | RelationalExpression oMAT ShiftExpression
    | RelationalExpression oNMA ShiftExpression
    | RelationalExpression kIS Type
    // | RelationalExpression kAS Type
    ;

EqualityExpression
    : RelationalExpression
    | EqualityExpression oEQL RelationalExpression
    | EqualityExpression oNEQ RelationalExpression
    ;

AndExpression
    : EqualityExpression
    | AndExpression '&' EqualityExpression
    ;

ExclusiveOrExpression
    : AndExpression
    | ExclusiveOrExpression '^' AndExpression
    ;

InclusiveOrExpression
    : ExclusiveOrExpression
    | InclusiveOrExpression '|' ExclusiveOrExpression
    ;

ConditionalAndExpression
    : InclusiveOrExpression
    | ConditionalAndExpression oAND InclusiveOrExpression
    ;

ConditionalOrExpression
    : ConditionalAndExpression
    | ConditionalOrExpression oOR ConditionalAndExpression
    ;

RangeExpression
    : ConditionalOrExpression
    | RangeExpression oRAE ConditionalOrExpression
    | RangeExpression oRAI ConditionalOrExpression
    ;

NullCoalescingExpression
    : RangeExpression
    | NullCoalescingExpression oCOA RangeExpression
    ;

ConditionalExpression
    : NullCoalescingExpression
    | ConditionalExpression '?' Expression ':' Expression
    ;

AssignmentExpression
    : UnaryExpression AssignmentOperator Expression
    ;

AssignmentOperator
    : '='
    | oADE /* += */
    | oSUE /* -= */
    | oMUE /* *= */
    | oDIE /* /= */
    | oXOE /* %= */
    | oMOE /* ^= */
    | oANE /* &= */
    | oORE /* |= */
    | oSLE /* <<= */
    | oSRE /* >>= */
    ;

SelectOrGroupClause
    : GroupByClause
    | SelectClause
    ;

GroupByClause
    : kGROUP IDENTIFIER kBY Expression
    | kGROUP IDENTIFIER kBY Expression kINTO IDENTIFIER
    ;

SelectClause
    : kSELECT ExpressionList
    ;

LetClause
    : kLET IDENTIFIER '=' Expression
    ;

RangeClause
    : kSKIP Expression
    | kSTEP Expression
    | kTAKE Expression
    ;

OrderExpression
    : Expression OrderOperatorOpt
    ;

OrderOperatorOpt
    : /* empty */
    | kASC
    | kDESC
    ;

JoinClause
    : kJOIN QueryOrigin kON BooleanExpression
    | kLEFT kJOIN QueryOrigin kON BooleanExpression
    | kRIGHT kJOIN QueryOrigin kON BooleanExpression
    | kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    | kLEFT kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    | kRIGHT kJOIN QueryOrigin kON BooleanExpression kINTO IDENTIFIER
    ;

QueryBodyMemberRepeat
    : QueryBodyMember 
    | QueryBodyMemberRepeat QueryBodyMember
    ;

QueryBodyMember
    : kWHERE BooleanExpression
    | kORDER kBY OrderExpression
    | JoinClause
    | RangeClause
    | LetClause
    ;

QueryBody
    : QueryBodyMemberRepeat SelectOrGroupClause
    | QueryBodyMemberRepeat
    | SelectOrGroupClause
    ;

QueryOrigin
    : IDENTIFIER kIN Expression
    ;

QueryExpression
    : kFROM QueryOrigin
    | kFROM QueryOrigin QueryBody
    ;

LambdaParameterList
    : LambdaParameter
    | LambdaParameterList ',' LambdaParameter
    ;

LambdaParameter
    : Type IDENTIFIER
    | IDENTIFIER
    ;

LambdaParameterListOpt
    : /* empty */
    | LambdaParameterList
    ;

LambdaExpressionBody
    : Expression
    | Block
    ;

LambdaExpression
    : IDENTIFIER oFAR LambdaExpressionBody
    | '(' LambdaParameterListOpt ')' oFAR LambdaExpressionBody
    ;

TimedExpression
    : kASYNC Expression
    | kAWAIT Expression
    ;

Expression
    : ConditionalExpression
    | AssignmentExpression
    | QueryExpression
    | LambdaExpression
    | TimedExpression
    ;

ConstantExpression
    : Expression
    ;

BooleanExpression
    : Expression
    ;

Statement
    : DeclarationStatement
    | EmbeddedStatement
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
    ;

Block
    : '{' StatementRepeatOpt '}'
    ;

StatementRepeatOpt
    : /* empty */
    | StatementRepeat
    ;

StatementRepeat
    : Statement
    | StatementRepeat Statement
    ;

EmptyStatement
    : ';'
    ;

DeclarationStatement
    : LocalVariableDeclaration ';'
    | LocalConstantDeclaration ';'
    ;

LocalVariableDeclaration
    : Type VariableDeclaratorList
    ;

VariableDeclaratorList
    : VariableDeclarator
    | VariableDeclaratorList ',' VariableDeclarator
    ;

VariableDeclarator
    : IDENTIFIER
    | IDENTIFIER '=' VariableInitializer
    ;

VariableInitializer
    : Expression
    | ArrayInitializer
    ;

LocalConstantDeclaration
    : kCONST Type ConstantDeclaratorList
    ;

ConstantDeclaratorList
    : ConstantDeclarator
    | ConstantDeclaratorList ',' ConstantDeclarator
    ;

ConstantDeclarator
    : IDENTIFIER '=' ConstantExpression
    ;

ExpressionStatement
    : StatementExpression ';'
    ;

StatementExpression
    : InvocationExpression
    | ObjectCreationExpression
    | AssignmentExpression
    | PostIncrementExpression
    | PostDecrementExpression
    | PreIncrementExpression
    | PreDecrementExpression
    // | Expression
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
    : '{' SwitchSectionRepeatOpt '}'
    ;

SwitchSectionRepeatOpt
    : /* empty */
    | SwitchSectionRepeat
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
    : kWHILE '(' BooleanExpression ')' EmbeddedStatement
    ;

DoStatement
    : kDO EmbeddedStatement kWHILE '(' BooleanExpression ')' ';'
    ;

ForStatement
    : kFOR '(' ForInitializerOpt ';' ForConditionOpt ';' ForIteratorOpt ')' EmbeddedStatement
    ;

ForInitializerOpt
    : /* empty */
    | ForInitializer
    ;

ForConditionOpt
    : /* empty */
    | ForCondition
    ;

ForIteratorOpt
    : /* empty */
    | ForIterator
    ;

ForInitializer
    : LocalVariableDeclaration
    | StatementExpressionList
    ;

ForCondition
    : BooleanExpression
    ;

ForIterator
    : StatementExpressionList
    ;

StatementExpressionList
    : StatementExpression
    | StatementExpressionList ',' StatementExpression
    ;

ForeachStatement
    : kFOREACH '(' Type IDENTIFIER kIN Expression ')' EmbeddedStatement
    ;

JumpStatement
    : BreakStatement
    | ContinueStatement
    | ReturnStatement
    | YieldStatement
    | ThrowStatement
    ;

BreakStatement
    : kBREAK ';'
    ;

ContinueStatement
    : kCONTINUE ';'
    ;

ReturnStatement
    : kRETURN ExpressionOpt ';'
    ;

YieldStatement
    : kYIELD /* kBREAK */ ';'
    | kYIELD /* kRETURN */ Expression ';'
    ;

ExpressionOpt
    : /* empty */
    | Expression
    ;

ThrowStatement
    : kTHROW ExpressionOpt ';'
    ;

TryStatement
    : kTRY Block CatchClauseRepeat
    | kTRY Block FinallyClause
    | kTRY Block CatchClauseRepeat FinallyClause
    ;

CatchClauseRepeat
    : CatchClause
    | CatchClauseRepeat CatchClause
    ;

CatchClause
    : kCATCH '(' ClassType IdentifierOpt ')' Block
    | kCATCH '(' TypeName IdentifierOpt ')' Block
    | kCATCH Block
    ;

IdentifierOpt
    : /* empty */
    | IDENTIFIER
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
    : LocalVariableDeclaration
    | Expression
    ;

// CompilationUnit
//     : /* UsingDirectiveRepeatOpt AttributesOpt
//     | */ UsingDirectiveRepeatOpt NamespaceMemberDeclarationRepeatOpt
//     ;

// UsingDirectiveRepeatOpt
//     : /* empty */
//     | UsingDirectiveRepeat
//     ;

// AttributesOpt
//     : /* empty */
//     | Attributes
//     ;

// NamespaceMemberDeclarationRepeatOpt
//     : /* empty */
//     | NamespaceMemberDeclarationRepeat
//     ;

// NamespaceDeclaration
//     : AttributesOpt kNAMESPACE QualifiedIdentifier NamespaceBody CommaOpt
//     ;

CommaOpt
    : /* empty */
    | ';'
    ;

QualifiedIdentifier
    : IDENTIFIER
    | Qualifier IDENTIFIER
    ;

Qualifier
    : IDENTIFIER '.'
    | Qualifier IDENTIFIER '.'
    ;

// NamespaceBody
//     : '{' UsingDirectiveRepeatOpt NamespaceMemberDeclarationRepeatOpt '}'
//     ;

// UsingDirectiveRepeatOpt
//     : /* empty */
//     | UsingDirectiveRepeat
//     ;

UsingDirectiveRepeat
    : UsingDirective
    | UsingDirectiveRepeat UsingDirective
    ;

UsingDirective
    : UsingAliasDirective
    | UsingNamespaceDirective
    ;

UsingAliasDirective
    : kUSING IDENTIFIER '=' QualifiedIdentifier ';'
    ;

UsingNamespaceDirective
    : kUSING ModuleName ';'
    ;

// NamespaceMemberDeclarationRepeat
//     : NamespaceDeclaration
//     | TypeDeclaration
//     ;

TypeDeclaration
    : MethodDeclaration
    | StructDeclaration
    | EnumDeclaration
    // | DelegateDeclaration
    // | InterfaceDeclaration 
    // | ClassDeclaration
    ;

ModifierRepeatOpt
    : /* empty */
    | ModifierRepeat
    ;

ModifierRepeat
    : Modifier
    | ModifierRepeat Modifier
    ;

Modifier
    : kEXTERN
    | kSTATIC
    | kASYNC
    // | kABSTRACT
    // | kINTERNAL
    // | kNEW
    // | kOVERRIDE
    // | kPRIVATE
    // | kPROTECTED
    // | kPUBLIC
    // | kREADONLY
    // | kSEALED
    // | kUNSAFE
    // | kVIRTUAL
    // | kVOLATILE
    ;

StructDeclaration
    : /* AttributesOpt */ ModifierRepeatOpt kSTRUCT IDENTIFIER /* StructInterfacesOpt */ StructBody CommaOpt
    ;

// StructInterfacesOpt
//     : /* empty */
//     | StructInterfaces
//     ;

// StructInterfaces
//     : ':' InterfaceTypeList
//     ;

StructBody
    : '{' StructMemberDeclarationRepeatOpt '}'
    ;

StructMemberDeclarationRepeatOpt
    : /* empty */
    | StructMemberDeclarationRepeat
    ;

StructMemberDeclarationRepeat
    : StructMemberDeclaration
    | StructMemberDeclarationRepeat StructMemberDeclaration
    ;

StructMemberDeclaration
    : ConstantDeclaration
    // | FieldDeclaration
    // | MethodDeclaration
    // | PropertyDeclaration
    // | EventDeclaration
    // | IndexerDeclaration
    // | OperatorDeclaration
    // | ConstructorDeclaration
    | TypeDeclaration
    ;

ConstantDeclaration
    : /* AttributesOpt */ ModifierRepeatOpt kCONST Type ConstantDeclaratorList ';'
    ;

ArrayInitializer
    : '{' VariableInitializerListOpt '}'
    | '{' VariableInitializerListOpt ',' '}'
    ;

VariableInitializerListOpt
    : /* empty */
    | VariableInitializerList
    ;

VariableInitializerList
    : VariableInitializer
    | VariableInitializerList ',' VariableInitializer
    ;

EnumDeclaration
    : /* AttributesOpt */ ModifierRepeatOpt kENUM IDENTIFIER EnumBaseOpt EnumBody CommaOpt
    ;

EnumBaseOpt
    : /* empty */
    | EnumBase
    ;

EnumBase
    : ':' IntegralType /* Type */
    ;

EnumBody
    : '{' EnumMemberDeclarationListOpt '}'
    | '{' EnumMemberDeclarationListOpt ',' '}'
    ;

EnumMemberDeclarationListOpt
    : /* empty */
    | EnumMemberDeclarationList
    ;

EnumMemberDeclarationList
    : EnumMemberDeclaration
    | EnumMemberDeclarationList ',' EnumMemberDeclaration
    ;

EnumMemberDeclaration
    : /* AttributesOpt */ IDENTIFIER
    | /* AttributesOpt */ IDENTIFIER '=' ConstantExpression
    ;

MethodDeclaration
    : MethodHeader MethodBody
    ;

MethodHeader
    : /* AttributesOpt */ ModifierRepeatOpt kVOID QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ ModifierRepeatOpt Type QualifiedIdentifier '(' FormalParameterListOpt ')'
    | /* AttributesOpt */ ModifierRepeatOpt /* Type == int */ QualifiedIdentifier '(' FormalParameterListOpt ')'
    ;

FormalParameterListOpt
    : /* empty */
    | FormalParameterList
    ;

MethodBody
    : Block
    | ';'
    ;

FormalParameterList
    : FormalParameter
    | FormalParameterList ',' FormalParameter
    ;

FormalParameter
    : FixedParameter
    | ParameterArray
    ;

FixedParameter
    : /* AttributesOpt /* ParameterModifierOpt */ Type IDENTIFIER ParameterInitializerOpt
    ;

ParameterInitializerOpt
    : /* empty */
    | '=' ConstantExpression
    ;

ParameterArray
    : /* AttributesOpt */ kPARAMS ArrayType IDENTIFIER
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
