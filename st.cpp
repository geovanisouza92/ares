
#include <ostream>

#include "st.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

Environment::Environment(Environment * p) : prev(p), cmds(new VectorNode()) { }

Environment *
Environment::clear() {
    cmds->clear();
    return this;
}

Environment *
Environment::put_cmd(SyntaxNode * v) {
    cmds->push_back(v);
    return this;
}

Environment *
Environment::put_cmds(VectorNode * v) {
    for (VectorNode::iterator cmd = v->begin(); cmd < v->end(); cmd++)
        put_cmd(*cmd);
    return this;
}

void
Environment::print_tree_using(ostream & out) {
    for (VectorNode::iterator cmd = cmds->begin(); cmd < cmds->end(); cmd++)
        (*cmd)->print_using(out, 0, true);
}

NilNode::NilNode() { set_type(NodeType::Nil); }

void
NilNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Nil" << ( nl ? "\n" : "" );
}

IdentifierNode::IdentifierNode(string & v) : value(v) { set_type(NodeType::Identifier); }

void
IdentifierNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Identifier => " << value << ( nl ? "\n" : "" );
}

StringNode::StringNode(string & v) : value(v) { set_type(NodeType::String); }

void
StringNode::append(string & v) {
    value += v;
}

void
StringNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "String => " << value << ( nl ? "\n" : "" );
}

RegexNode::RegexNode(string & v) : value(v) { set_type(NodeType::Regex); }

void
RegexNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Regex => " << value << ( nl ? "\n" : "" );
}

FloatNode::FloatNode(double v) : value(v) { set_type(NodeType::Float); }

void
FloatNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Float => " << value << ( nl ? "\n" : "" );
}

IntegerNode::IntegerNode(int v) : value(v) { set_type(NodeType::Integer); }

void
IntegerNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Integer => " << value << ( nl ? "\n" : "" );
}

BooleanNode::BooleanNode(bool v) : value(v) { set_type(NodeType::Boolean); }

void
BooleanNode::print_using(ostream & out, unsigned d, bool nl) {
    out << string(d * 2, ' ') << "Boolean => " << ( value ? "True" : "False" ) << ( nl ? "\n" : "" );
}

ArrayNode::ArrayNode() : value(new VectorNode()) { set_type(NodeType::Array); }

ArrayNode::ArrayNode(VectorNode * v) : value(v) { set_type(NodeType::Array); }

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

HashPairNode::HashPairNode(SyntaxNode * k, SyntaxNode * v) : key(k), value(v) { set_type(NodeType::HashPair); }

void
HashPairNode::print_using(ostream & out, unsigned d, bool nl) {
    key->print_using(out, 0, false);
    out << " : ";
    value->print_using(out, 0, false);
}

HashNode::HashNode() : value(new VectorNode()) { set_type(NodeType::Hash); }

HashNode::HashNode(VectorNode * v) : value(v) { set_type(NodeType::Hash); }

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

FunctionCallNode::FunctionCallNode(SyntaxNode * n) : name(n), args(new VectorNode) { set_type(NodeType::Nil); }

FunctionCallNode::FunctionCallNode(SyntaxNode * n, VectorNode * a) : name(n), args(a) { set_type(NodeType::Nil); }

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
