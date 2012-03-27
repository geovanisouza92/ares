
/* Ares Programming Language */

#ifndef LANG_ST_H
#define LANG_ST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

using namespace std;

#include "enum.h"

#define ENVIRONMENT
#define TAB out << string(d * 2, ' ')

namespace LANG_NAMESPACE {
namespace SyntaxTree {

class SyntaxNode {
protected:
	NodeType::Type node_type;
public:
	virtual ~SyntaxNode() {
	}
	virtual NodeType::Type get_node_type() {
		return node_type;
	}
	virtual void set_node_type(NodeType::Type t) {
		node_type = t;
	}
	virtual void print_using(ostream &, unsigned) = 0;
};

class VectorNode: public vector<SyntaxNode *> {
};

class Environment {
protected:
	Environment * prev;
	VectorNode * stmts;
public:
	Environment(Environment *);
	virtual ~Environment();
	virtual Environment * clear();
	virtual Environment * put_stmt(SyntaxNode *);
	virtual Environment * put_stmts(VectorNode *);
	virtual void print_tree_using(ostream &);
};

class NilNode: public SyntaxNode {
public:
	NilNode();
	virtual void print_using(ostream &, unsigned);
};

class IdentifierNode: public SyntaxNode {
protected:
	string value;
public:
	IdentifierNode(string);
	virtual void print_using(ostream &, unsigned);
};

class StringNode: public SyntaxNode {
protected:
	string value;
public:
	StringNode(string);
	virtual void append(string);
	virtual void print_using(ostream &, unsigned);
};

class RegexNode: public SyntaxNode {
protected:
	string value;
public:
	RegexNode(string);
	virtual void print_using(ostream &, unsigned);
};

class FloatNode: public SyntaxNode {
protected:
	double value;
public:
	FloatNode(double);
	virtual void print_using(ostream &, unsigned);
};

class IntegerNode: public SyntaxNode {
protected:
	int value;
public:
	IntegerNode(int);
	virtual void print_using(ostream &, unsigned);
};

class BooleanNode: public SyntaxNode {
protected:
	bool value;
public:
	BooleanNode(bool);
	virtual void print_using(ostream &, unsigned);
};

class ArrayNode: public SyntaxNode {
protected:
	VectorNode * value;
public:
	ArrayNode();
	ArrayNode(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class HashPairNode: public SyntaxNode {
protected:
	SyntaxNode * key;
	SyntaxNode * value;
public:
	HashPairNode(SyntaxNode *, SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class HashNode: public SyntaxNode {
protected:
	VectorNode * value;
public:
	HashNode();
	HashNode(VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class ExpressionNode: public SyntaxNode {
public:
	// virtual ~ExpressionNode();
	virtual void print_using(ostream &, unsigned) = 0;
};

class UnaryExprNode: public ExpressionNode {
protected:
	Operation::Operator operation;
	SyntaxNode * member1;
	VectorNode * vector1;
public:
	UnaryExprNode(Operation::Operator op, SyntaxNode * m1) :
			operation(op), member1(m1) {
		set_node_type(NodeType::Nil);
	}
	UnaryExprNode(Operation::Operator op, VectorNode * m1) :
			operation(op), vector1(m1) {
		set_node_type(NodeType::Nil);
	}
	virtual void print_using(ostream &, unsigned);
};

class BinaryExprNode: public ExpressionNode {
protected:
	Operation::Operator operation;
	SyntaxNode * member1;
	SyntaxNode * member2;
public:
	BinaryExprNode(Operation::Operator op, SyntaxNode * m1, SyntaxNode * m2) :
			operation(op), member1(m1), member2(m2) {
		set_node_type(NodeType::Nil);
	}
	virtual void print_using(ostream &, unsigned);
};

class TernaryExprNode: public ExpressionNode {
protected:
	Operation::Operator operation;
	SyntaxNode * member1;
	SyntaxNode * member2;
	SyntaxNode * member3;
public:
	TernaryExprNode(Operation::Operator op, SyntaxNode * m1, SyntaxNode * m2,
			SyntaxNode * m3) :
			operation(op), member1(m1), member2(m2), member3(m3) {
		set_node_type(NodeType::Nil);
	}
	virtual void print_using(ostream &, unsigned);
};

class FunctionCallNode: public SyntaxNode {
protected:
	SyntaxNode * name;
	VectorNode * args;
public:
	FunctionCallNode(SyntaxNode *);
	FunctionCallNode(SyntaxNode *, VectorNode *);
	virtual void print_using(ostream &, unsigned);
};

class AsyncNode: public SyntaxNode {
protected:
	SyntaxNode * item;
	AsyncType::Type type;
public:
	AsyncNode(AsyncType::Type, SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

class LambdaExprNode: public SyntaxNode {
protected:
	VectorNode * args;
	SyntaxNode * expr;
public:
	LambdaExprNode(VectorNode *, SyntaxNode *);
	virtual void print_using(ostream &, unsigned);
};

} // SyntaxTree
} // LANG_NAMESPACE

#endif
