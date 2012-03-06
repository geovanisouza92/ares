
#include <typeinfo>
#include <ostream>

#include "ast.h"

namespace LANG_NAMESPACE {
namespace AST {

SyntaxNode *
Environment::get(string k) {
	for (Environment * e = this; e != NULL; e = e->prev) {
		SyntaxNode * found = e->table->find(k)->second;
		if (found != NULL)
			return found;
	}
	return NULL;
}

void
Environment::print_tree_using(ostream& out) {
	for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end(); stmt++)
		(*stmt)->print_using(out, 0);
}

void
NilNode::print_using(ostream& out, unsigned tab) {
	out << indent(tab) << typeid(this).name() << endl;
}

void
IdentifierNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> " << value << endl;
}

void
FloatNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> " << value << endl;
}

void
IntegerNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> " << value << endl;
}

void
StringNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> " << value << endl;
}

void
RegexNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> " << value << endl;
}

void
BooleanNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> " << value << endl;
}

void
ArrayNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> [";
 	for (VectorNode::iterator item = value->begin(); item < value->end(); item++)
 		(*item)->print_using(out, tab++);
 	out << "]" << endl;
}

void
HashItemNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> ";
	key->print_using(out, tab++);
	value->print_using(out, tab++);
 	out << endl;
}

void
HashNode::print_using(ostream& out, unsigned tab) {
 	out << indent(tab) << typeid(this).name() << "=> {";
 	for (VectorNode::iterator item = value->begin(); item < value->end(); item++)
 		(*item)->print_using(out, tab++);
 	out << "}" << endl;
}

} // AST
} // LANG_NAMESPACE
