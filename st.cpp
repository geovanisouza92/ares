
#include <ostream>

#include "st.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

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
        (*expr)->print_using(out, 0, true);
}

NilNode::NilNode() { }

void
NilNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Nil" << ( nl ? "\n" : "" );
}

IdentifierNode::IdentifierNode(string & v) : value(v) { }

void
IdentifierNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Identifier => " << value << ( nl ? "\n" : "" );
}

StringNode::StringNode(string & v) : value(v) { }

void
StringNode::append(string & v) {
    value += v;
}

void
StringNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "String => " << value << ( nl ? "\n" : "" );
}

RegexNode::RegexNode(string & v) : value(v) { }

void
RegexNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Regex => " << value << ( nl ? "\n" : "" );
}

FloatNode::FloatNode(double v) : value(v) { }

void
FloatNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Float => " << value << ( nl ? "\n" : "" );
}

IntegerNode::IntegerNode(int v) : value(v) { }

void
IntegerNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Integer => " << value << ( nl ? "\n" : "" );
}

BooleanNode::BooleanNode(bool v) : value(v) { }

void
BooleanNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Boolean => " << ( value ? "True" : "False" ) << ( nl ? "\n" : "" );
}

ArrayNode::ArrayNode() : value(new VectorNode()) { }

ArrayNode::ArrayNode(VectorNode * v) : value(v) { }

void
ArrayNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Array";
    out << " => [ ";
    for (VectorNode::iterator item = value->begin(); item < value->end(); item++) {
        (*item)->print_using(out, 0, false);
        out << ( (item != value->end() - 1) ? ", " : " " );
    }
    out << "]" << endl;
}

HashItemNode::HashItemNode(SyntaxNode * k, SyntaxNode * v) : key(k), value(v) { }

void
HashItemNode::print_using(ostream & out, unsigned d, bool nl) {
    key->print_using(out, 0, false);
    out << " : ";
    value->print_using(out, 0, false);
}

HashNode::HashNode() : value(new VectorNode()) { }

HashNode::HashNode(VectorNode * v) : value(v) { }

void
HashNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Hash => { ";
    for (VectorNode::iterator item = value->begin(); item < value->end(); item++) {
        (*item)->print_using(out, 0, false);
        out << ( (item != value->end() - 1) ? ", " : " " );
    }
    out << "}" << endl;
}

void
UnaryExprNode::evaluate() {
    // TODO
}

void
UnaryExprNode::print_using(ostream & out, unsigned tab, bool nl) {
    out << string(tab * 2, ' ') << "Unary expr. => [ " << Operation::get_enum_name(operation) << ( nl ? "\n" : "" );
    member1->print_using(out, tab + 1, nl);
    out << " ]" << ( nl ? "\n" : "" );
}

void
BinaryExprNode::evaluate() {
    // TODO
}

void
BinaryExprNode::print_using(ostream & out, unsigned tab, bool nl) {
    out << string(tab * 2, ' ') << "Binary expr. => [ " << Operation::get_enum_name(operation) << ( nl ? "\n" : "" );
    member1->print_using(out, tab + 1, nl);
    member2->print_using(out, tab + 1, nl);
    out << " ]" << ( nl ? "\n" : "" );
}

void
TernaryExprNode::evaluate() {
    // TODO
}

void
TernaryExprNode::print_using(ostream & out, unsigned tab, bool nl) {
    out << string(tab * 2, ' ') << "Ternary expr. => [ " << Operation::get_enum_name(operation) << ( nl ? "\n" : "" );
    member1->print_using(out, tab + 1, nl);
    member2->print_using(out, tab + 1, nl);
    member3->print_using(out, tab + 1, nl);
    out << " ]" << ( nl ? "\n" : "" );
}

FunctionCallNode::FunctionCallNode(SyntaxNode * n) : name(n), args(new VectorNode) { }

FunctionCallNode::FunctionCallNode(SyntaxNode * n, VectorNode * a) : name(n), args(a) { }

void
FunctionCallNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Function call => ";
    name->print_using(out, 0, false);
    out << ", Args: ( ";
    if (args->size() > 0) {
        for (VectorNode::iterator arg = args->begin(); arg < args->end(); arg++) {
            (*arg)->print_using(out, 0, false);
            out << ( (arg != args->end() - 1) ? ", " : " " );
        }
    }
    out << ")" << endl;
}

} // SyntaxTree
} // LANG_NAMESPACE
