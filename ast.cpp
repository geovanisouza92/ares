
#include <typeinfo>
#include <ostream>

#include "ast.h"

namespace LANG_NAMESPACE {
namespace AST {

void
Environment::print_tree_using(ostream& out) {
    for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end(); stmt++)
        (*stmt)->print_using(out, 0);
}

void
IdentifierNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Identifier => " << value << endl;
}

void
FloatNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Float => " << value << endl;
}

void
IntegerNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Integer => " << value << endl;
}

void
StringNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "String" << " => " << value << endl;
}

void
RegexNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Regex => " << value << endl;
}

void
BooleanNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Boolean => " << value << endl;
}

void
ArrayNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Array => [";
    for (VectorNode::iterator item = value->begin(); item < value->end(); item++)
        (*item)->print_using(out, ++tab);
    out << endl << "]";
}

void
HashItemNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "HashPair => ";
    key->print_using(out, tab);
    value->print_using(out, ++tab);
}

void
HashNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Hash => {";
    for (VectorNode::iterator item = value->begin(); item < value->end(); item++)
        (*item)->print_using(out, ++tab);
    out << endl << "}";
}

void
FunctionCallNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Function call => ";
    name->print_using(out, ++tab);
}

void
UnaryExprNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Unary expr. => " << Operation::get_enum_name(operation) << endl;
    expr->print_using(out, tab + 1);
}

void
BinaryExprNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Binary expr. => " << Operation::get_enum_name(operation) << endl;
    lhs->print_using(out, tab + 1);
    rhs->print_using(out, tab + 1);
}

void
TernaryExprNode::print_using(ostream& out, unsigned tab) {
    out << indent(tab) << "Ternary expr. => " << Operation::get_enum_name(operation) << endl;
    opt1->print_using(out, tab + 1);
    opt2->print_using(out, tab + 1);
    opt3->print_using(out, tab + 1);
}

SyntaxNode *
Environment::get(string & k) {
    for (Environment * e = this; e != NULL; e = e->prev) {
        SyntaxNode * found = e->table->find(k)->second;
        if (found != NULL)
            return found;
    }
    return NULL;
}

} // AST
} // LANG_NAMESPACE
