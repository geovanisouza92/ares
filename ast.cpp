
#include <typeinfo>
#include <ostream>

#include "ast.h"

namespace LANG_NAMESPACE {
namespace AST {

Environment::Environment(Environment * p) : prev(p), exprs(new VectorNode()) { }

Environment *
Environment::clear() {
    exprs->clear();
    return this;
}

Environment *
Environment::put_expr(SyntaxNode * v) {
    exprs->push_back(v);
    return this;
}

Environment *
Environment::put_exprs(VectorNode * v) {
    for (VectorNode::iterator expr = v->begin(); expr < v->end(); expr++)
        exprs->push_back(*expr);
    return this;
}

void
Environment::print_tree_using(ostream & out) {
    for (VectorNode::iterator expr = exprs->begin(); expr < exprs->end(); expr++)
        (*expr)->print_using(out, 0);
}

NilNode::NilNode() { }

void
NilNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Nil" << endl;
}

IdentifierNode::IdentifierNode(string & v) : value(v) { }

void
IdentifierNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Identifier => " << value << endl;
}

StringNode::StringNode(string & v) : value(v) { }

void
StringNode::append(string & v) {
    value += v;
}

void
StringNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "String => " << value << endl;
}

RegexNode::RegexNode(string & v) : value(v) { }

void
RegexNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Regex => " << value << endl;
}

FloatNode::FloatNode(double v) : value(v) { }

void
FloatNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Float => " << value << endl;
}

IntegerNode::IntegerNode(int v) : value(v) { }

void
IntegerNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Integer => " << value << endl;
}

BooleanNode::BooleanNode(bool v) : value(v) { }

void
BooleanNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Boolean => " << ( value ? "True" : "False" ) << endl;
}

ArrayNode::ArrayNode() : value(new VectorNode()) { }

ArrayNode::ArrayNode(VectorNode * v) : value(v) { }

void
ArrayNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Array => [" << endl;
    for (VectorNode::iterator item = value->begin(); item < value->end(); item++) {
        (*item)->print_using(out, d + 1);
        if (item != value->end() - 1) out << string((d + 1) * 2, ' ') << "," << endl;
    }
    out << string(d * 2, ' ') << "]" << endl;
}

HashItemNode::HashItemNode(SyntaxNode * k, SyntaxNode * v) : key(k), value(v) { }

void
HashItemNode::print_using(ostream & out, unsigned d) {
    key->print_using(out, d + 1);
    value->print_using(out, d + 1);
}

HashNode::HashNode() : value(new VectorNode()) { }

HashNode::HashNode(VectorNode * v) : value(v) { }

void
HashNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Hash => {" << endl;
    for (VectorNode::iterator item = value->begin(); item < value->end(); item++) {
        (*item)->print_using(out, d + 1);
        if (item != value->end() - 1) out << string((d + 1) * 2, ' ') << "," << endl;
    }
    out << string(d * 2, ' ') << "}" << endl;
}

void
UnaryExprNode::evaluate() {
    // TODO
}

void
UnaryExprNode::print_using(ostream & out, unsigned tab) {
    out << string(tab * 2, ' ') << "Unary expr. => " << Operation::get_enum_name(operation) << endl;
    member1->print_using(out, tab + 1);
}

void
BinaryExprNode::evaluate() {
    // TODO
}

void
BinaryExprNode::print_using(ostream & out, unsigned tab) {
    out << string(tab * 2, ' ') << "Binary expr. => " << Operation::get_enum_name(operation) << endl;
    member1->print_using(out, tab + 1);
    member2->print_using(out, tab + 1);
}

void
TernaryExprNode::evaluate() {
    // TODO
}

void
TernaryExprNode::print_using(ostream & out, unsigned tab) {
    out << string(tab * 2, ' ') << "Ternary expr. => " << Operation::get_enum_name(operation) << endl;
    member1->print_using(out, tab + 1);
    member2->print_using(out, tab + 1);
    member3->print_using(out, tab + 1);
}

FunctionCallNode::FunctionCallNode(SyntaxNode * n) : name(n), args(new VectorNode) { }

FunctionCallNode::FunctionCallNode(SyntaxNode * n, VectorNode * a) : name(n), args(a) { }

void
FunctionCallNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Function call => ";
    name->print_using(out, 0);
    for (VectorNode::iterator arg = args->begin(); arg < args->end(); arg++)
        (*arg)->print_using(out, d + 1);
}

} // AST
} // LANG_NAMESPACE
