
/* Ares Programming Language */

#include <ostream>

#include "st.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

Environment::Environment(Environment * p) :
		prev(p), stmts(new VectorNode()) {
}

Environment::~Environment() {
}

Environment *
Environment::clear() {
	stmts->clear();
	return this;
}

Environment *
Environment::put_stmt(SyntaxNode * v) {
	stmts->push_back(v);
	return this;
}

Environment *
Environment::put_stmts(VectorNode * v) {
	for (VectorNode::iterator stmt = v->begin(); stmt < v->end(); stmt++)
		put_stmt(*stmt);
	return this;
}

void Environment::print_tree_using(ostream & out) {
	for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end();
			stmt++)
		(*stmt)->print_using(out, 0);
}

NilNode::NilNode() {
}

void NilNode::print_using(ostream & out, unsigned d) {
	TAB << "Nil" << endl;
}

IdentifierNode::IdentifierNode(string v) :
		value(v) {
	set_node_type(NodeType::Identifier);
}

void IdentifierNode::print_using(ostream & out, unsigned d) {
	TAB << "Identifier => " << value << endl;
}

StringNode::StringNode(string v) :
		value(v) {
	set_node_type(NodeType::String);
}

void StringNode::append(string v) {
	value += v;
}

void StringNode::print_using(ostream & out, unsigned d) {
	TAB << "String => " << value << endl;
}

RegexNode::RegexNode(string v) :
		value(v) {
	set_node_type(NodeType::Regex);
}

void RegexNode::print_using(ostream & out, unsigned d) {
	TAB << "Regex => " << value << endl;
}

FloatNode::FloatNode(double v) :
		value(v) {
	set_node_type(NodeType::Float);
}

void FloatNode::print_using(ostream & out, unsigned d) {
	TAB << "Float => " << value << endl;
}

IntegerNode::IntegerNode(int v) :
		value(v) {
	set_node_type(NodeType::Integer);
}

void IntegerNode::print_using(ostream & out, unsigned d) {
	TAB << "Integer => " << value << endl;
}

BooleanNode::BooleanNode(bool v) :
		value(v) {
	set_node_type(NodeType::Boolean);
}

void BooleanNode::print_using(ostream & out, unsigned d) {
	TAB << "Boolean => " << (value ? "True" : "False") << endl;
}

ArrayNode::ArrayNode() :
		value(new VectorNode()) {
	set_node_type(NodeType::Array);
}

ArrayNode::ArrayNode(VectorNode * v) :
		value(v) {
	set_node_type(NodeType::Array);
}

void ArrayNode::print_using(ostream & out, unsigned d) {
	TAB << "Array => [ " << endl;
	for (VectorNode::iterator elem = value->begin(); elem < value->end();
			elem++) {
		(*elem)->print_using(out, d + 1);
		TAB << ((elem != value->end() - 1) ? ", " : " ") << endl;
	}
	TAB << " ]" << endl;
}

HashPairNode::HashPairNode(SyntaxNode * k, SyntaxNode * v) :
		key(k), value(v) {
	set_node_type(NodeType::HashPair);
}

void HashPairNode::print_using(ostream & out, unsigned d) {
	key->print_using(out, d + 1);
	TAB << "^" << endl;
	value->print_using(out, d + 1);
}

HashNode::HashNode() :
		value(new VectorNode()) {
	set_node_type(NodeType::Hash);
}

HashNode::HashNode(VectorNode * v) :
		value(v) {
	set_node_type(NodeType::Hash);
}

void HashNode::print_using(ostream & out, unsigned d) {
	TAB << "Hash => { " << endl;
	for (VectorNode::iterator elem = value->begin(); elem < value->end();
			elem++) {
		(*elem)->print_using(out, d + 1);
		TAB << ((elem != value->end() - 1) ? ", " : " ") << endl;
	}
	TAB << " }" << endl;
}

void UnaryExprNode::print_using(ostream & out, unsigned d) {
	TAB << "Unary expression [ " << Operation::get_enum_name(operation)
			<< " ] => " << endl;
	member1->print_using(out, d + 1);
}

void BinaryExprNode::print_using(ostream & out, unsigned d) {
	TAB << "Binary expression [ " << Operation::get_enum_name(operation)
			<< " ] => " << endl;
	member1->print_using(out, d + 1);
	member2->print_using(out, d + 1);
}

void TernaryExprNode::print_using(ostream & out, unsigned d) {
	TAB << "Ternary expression [ " << Operation::get_enum_name(operation)
			<< " ] => " << endl;
	member1->print_using(out, d + 1);
	member2->print_using(out, d + 1);
	member3->print_using(out, d + 1);
}

FunctionCallNode::FunctionCallNode(SyntaxNode * n) :
		name(n), args(new VectorNode) {
	set_node_type(NodeType::Nil);
}

FunctionCallNode::FunctionCallNode(SyntaxNode * n, VectorNode * a) :
		name(n), args(a) {
	set_node_type(NodeType::Nil);
}

void FunctionCallNode::print_using(ostream & out, unsigned d) {
	TAB << "Function call for [ " << endl;
	name->print_using(out, d + 1);
	if (args->size() > 0) {
		TAB << " ] with arguments ( " << endl;
		for (VectorNode::iterator arg = args->begin(); arg < args->end();
				arg++) {
			(*arg)->print_using(out, d + 1);
			out << ((arg != args->end() - 1) ? ", " : " ") << endl;
		}
		TAB << " )" << endl;
	} else
		TAB << " ] without arguments" << endl;
}

AsyncNode::AsyncNode(AsyncType::Type t, SyntaxNode * i) :
		item(i), type(t) {
}

void AsyncNode::print_using(ostream & out, unsigned d) {
	TAB << "Asyncronous element => " << endl;
	item->print_using(out, d + 1);
}

LambdaExprNode::LambdaExprNode(VectorNode * a, SyntaxNode * e) :
		args(a), expr(e) {
}

void LambdaExprNode::print_using(ostream & out, unsigned d) {
	TAB << "Lambda expression ";
	if (args->size() > 0) {
		out << "with arguments ( " << endl;
		for (VectorNode::iterator arg = args->begin(); arg < args->end();
				arg++) {
			(*arg)->print_using(out, d + 1);
			out << ((arg != args->end() - 1) ? ", " : " ") << endl;
		}
		TAB << " )" << endl;
	}
	out << "without arguments" << endl;
	TAB << " using expression => " << endl;
	expr->print_using(out, d + 1);
}

} // SyntaxTree
} // LANG_NAMESPACE
