
#ifndef ARC_AST_H
#define ARC_AST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

#include "version.h"

using namespace std;

namespace LANG_NAMESPACE {
namespace AST {

	class SyntaxNode {
	public:
		virtual ~SyntaxNode() { }
		virtual void print_using(ostream&, unsigned) = 0;
		static inline string indent(unsigned count) { return string(count * 2, ' '); }
		// virtual llvm::Value * genCode() = 0;
	};

	class VectorNode : public vector<SyntaxNode *> { };

	class Environment {
	protected:
		map<string, SyntaxNode *> * table;
		VectorNode * stmts;
		Environment * prev;
	public:
		Environment(Environment * p) : prev(p) { table = new map<string, SyntaxNode *>(); stmts = new VectorNode(); }
		virtual void add_stmts(VectorNode * s) { stmts = s; }
		virtual SyntaxNode * get(string k);
		virtual Environment * put(string k, SyntaxNode * v) { table->insert(pair<string, SyntaxNode *>(k, v)); return this; }
		virtual void print_tree_using(ostream&);
	};

	class NilNode : public SyntaxNode {
	public:
		virtual void print_using(ostream&, unsigned);
	};

	class IdentifierNode : public SyntaxNode {
	protected:
		string value;
	public:
		IdentifierNode(const string & v) : value(v) { }
		virtual void print_using(ostream&, unsigned);
	};

	class FloatNode : public SyntaxNode {
	protected:
		double value;
	public:
		FloatNode(const double v) : value(v) { }
		virtual void print_using(ostream&, unsigned);
	};

	class IntegerNode : public SyntaxNode {
	protected:
		int value;
	public:
		IntegerNode(const int v) : value(v) { }
		virtual void print_using(ostream&, unsigned);
	};

	class StringNode : public SyntaxNode {
	protected:
		string value;
	public:
		StringNode(const string & v) : value(v) { }
		virtual void print_using(ostream&, unsigned);
	};

	class RegexNode : public SyntaxNode {
	protected:
		string value;
	public:
		RegexNode(const string & v) : value(v) { }
		virtual void print_using(ostream&, unsigned);
	};

	class BooleanNode : public SyntaxNode {
	protected:
		bool value;
	public:
		BooleanNode(const bool v) : value(v) { }
		virtual void print_using(ostream&, unsigned);
	};

	class ArrayNode : public SyntaxNode {
	protected:
		VectorNode * value;
	public:
		ArrayNode() { }
		ArrayNode(VectorNode * v) : value(v) { }
		SyntaxNode * add(SyntaxNode * v) { value->push_back(v); return this; }
		virtual void print_using(ostream&, unsigned);
	};

	class HashItemNode : public SyntaxNode {
	protected:
		SyntaxNode * key;
		SyntaxNode * value;
	public:
		HashItemNode() { }
		HashItemNode(SyntaxNode * k, SyntaxNode * v) : key(k), value(v) { }
		virtual SyntaxNode * get_key() { return key; }
		virtual SyntaxNode * get_value() { return value; }
		virtual void print_using(ostream&, unsigned);
	};

	class HashNode : public SyntaxNode {
	protected:
		VectorNode * value;
	public:
		HashNode() { }
		HashNode(VectorNode * v) : value(v) { }
		SyntaxNode * add(HashItemNode * v) { value->push_back(v); return this; }
		virtual void print_using(ostream&, unsigned);
	};

} // AST
} // LANG_NAMESPACE

#endif