/* Ares Programming Language */

#ifndef LANG_STMT_H
#define LANG_STMT_H

#include "st.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

class StatementNode: public SyntaxNode {
public:
	virtual void print_using(ostream &, unsigned) = 0;
};

class ConditionStmtNode: public StatementNode {
protected:
	Condition::Operation op;
	SyntaxNode * cond_stmt;
	SyntaxNode * then_stmt;
	VectorNode * elif_stmt;
	SyntaxNode * else_stmt;
public:
	ConditionStmtNode(Condition::Operation, SyntaxNode *, SyntaxNode *);
	virtual ConditionStmtNode * set_elif(VectorNode *);
	virtual ConditionStmtNode * set_else(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class CaseStmtNode: public StatementNode {
protected:
	SyntaxNode * case_stmt;
	VectorNode * when_stmt;
	SyntaxNode * else_stmt;
public:
	CaseStmtNode(SyntaxNode *);
	virtual CaseStmtNode * set_when(VectorNode *);
	virtual CaseStmtNode * set_else(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class WhenClauseNode: public StatementNode {
protected:
	SyntaxNode * when;
	SyntaxNode * block;
public:
	WhenClauseNode(SyntaxNode *, SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class ForStmtNode: public StatementNode {
protected:
	SyntaxNode * lhs;
	SyntaxNode * rhs;
	Loop::Operation op;
	SyntaxNode * block;
	SyntaxNode * step;
public:
	ForStmtNode(SyntaxNode *, SyntaxNode *, Loop::Operation, SyntaxNode *);
	virtual ForStmtNode * set_step(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class LoopStmtNode: public StatementNode {
protected:
	SyntaxNode * expr;
	SyntaxNode * block;
	Loop::Operation op;
public:
	LoopStmtNode(SyntaxNode *, SyntaxNode *, Loop::Operation);
	virtual void print_using(ostream &, unsigned);
};

class ControlStmtNode: public StatementNode {
protected:
	Control::Operation op;
	SyntaxNode * expr;
public:
	ControlStmtNode(Control::Operation);
	ControlStmtNode(Control::Operation, SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class BlockStmtNode: public StatementNode {
protected:
	VectorNode * require;
	VectorNode * ensure;
	VectorNode * stmts;
	VectorNode * rescue;
public:
	BlockStmtNode(VectorNode *);
	virtual BlockStmtNode * set_require(VectorNode *);
	virtual BlockStmtNode * set_ensure(VectorNode *);
	virtual BlockStmtNode * set_rescue(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class ValidationNode: public StatementNode {
protected:
	SyntaxNode * expr;
	SyntaxNode * raise;
public:
	ValidationNode(SyntaxNode *, SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class VarDeclNode: public StatementNode {
protected:
	VectorNode * vars;
public:
	VarDeclNode(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class VariableNode: public StatementNode {
protected:
	SyntaxNode * name;
	SyntaxNode * type;
	SyntaxNode * initial_value;
	SyntaxNode * invariants;
public:
	VariableNode(SyntaxNode *);
	virtual VariableNode * set_type(SyntaxNode *);
	virtual VariableNode * set_initial_value(SyntaxNode *);
	virtual VariableNode * set_invariants(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class ConstDeclNode: public StatementNode {
protected:
	VectorNode * consts;
public:
	ConstDeclNode(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class InterceptNode: public StatementNode {
protected:
	Intercept::Type type;
	VectorNode * items;
public:
	InterceptNode(Intercept::Type, VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class FunctionDeclNode: public StatementNode {
protected:
	SyntaxNode * name;
	VectorNode * params;
	SyntaxNode * return_type;
	SyntaxNode * intercept;
	vector<Specifier::Flag> specifiers;
	SyntaxNode * stmt;
public:
	FunctionDeclNode(SyntaxNode *, VectorNode *);
	virtual FunctionDeclNode * set_return(SyntaxNode *);
	virtual FunctionDeclNode * set_intercept(SyntaxNode *);
	virtual FunctionDeclNode * add_specifier(Specifier::Flag);
	virtual FunctionDeclNode * add_stmt(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class EventDeclNode: public StatementNode {
protected:
	SyntaxNode * name;
	SyntaxNode * initial_value;
	SyntaxNode * intercept;
public:
	EventDeclNode(SyntaxNode *);
	virtual EventDeclNode * set_intercept(SyntaxNode *);
	virtual EventDeclNode * set_initial_value(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class AttrDeclNode: public StatementNode {
protected:
	SyntaxNode * name;
	SyntaxNode * return_type;
	SyntaxNode * initial_value;
	SyntaxNode * getter;
	SyntaxNode * setter;
	SyntaxNode * invariants;
public:
	AttrDeclNode(SyntaxNode *);
	virtual AttrDeclNode * set_return_type(SyntaxNode *);
	virtual AttrDeclNode * set_initial_value(SyntaxNode *);
	virtual AttrDeclNode * set_getter(SyntaxNode *);
	virtual AttrDeclNode * set_setter(SyntaxNode *);
	virtual AttrDeclNode * set_invariants(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class IncludeStmtNode: public StatementNode {
protected:
	SyntaxNode * name;
public:
	IncludeStmtNode(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class ClassDeclNode: public StatementNode {
protected:
	SyntaxNode * name;
	SyntaxNode * heritance;
	vector<Specifier::Flag> specifiers;
	VectorNode * stmts;
public:
	ClassDeclNode(SyntaxNode *);
	virtual ClassDeclNode * set_heritance(SyntaxNode *);
	virtual ClassDeclNode * add_specifier(Specifier::Flag);
	virtual ClassDeclNode * add_stmts(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class ImportStmtNode: public StatementNode {
protected:
	VectorNode * members;
	SyntaxNode * origin;
public:
	ImportStmtNode(VectorNode *);
	virtual ImportStmtNode * set_origin(SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class ModuleNode: public StatementNode {
protected:
	SyntaxNode * name;
	VectorNode * stmts;
public:
	ModuleNode(SyntaxNode *);
	virtual ModuleNode * add_stmts(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

} // SyntaxTree
} // LANG_NAMESPACE

#endif
