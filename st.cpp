
#include <ostream>

#include "st.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

Environment::Environment(Environment * p) : prev(p), stmts(new VectorNode()) { }

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

void
Environment::print_tree_using(ostream & out) {
    // for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end(); stmt++)
    //     (*stmt)->print_using(out, 0, true);
}

NilNode::NilNode() { }

void
NilNode::print_using(ostream & out, unsigned d) {
    // TODO
}

IdentifierNode::IdentifierNode(string v) : value(v) { set_type(NodeType::Identifier); }

void
IdentifierNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Identifier => " << value << endl;
}

StringNode::StringNode(string v) : value(v) { set_type(NodeType::String); }

void
StringNode::append(string v) {
    value += v;
}

void
StringNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "String => " << value << endl;
}

RegexNode::RegexNode(string v) : value(v) { set_type(NodeType::Regex); }

void
RegexNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Regex => " << value << endl;
}

FloatNode::FloatNode(double v) : value(v) { set_type(NodeType::Float); }

void
FloatNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Float => " << value << endl;
}

IntegerNode::IntegerNode(int v) : value(v) { set_type(NodeType::Integer); }

void
IntegerNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Integer => " << value << endl;
}

BooleanNode::BooleanNode(bool v) : value(v) { set_type(NodeType::Boolean); }

void
BooleanNode::print_using(ostream & out, unsigned d) {
    out << string(d * 2, ' ') << "Boolean => " << ( value ? "True" : "False" ) << endl;
}

ArrayNode::ArrayNode() : value(new VectorNode()) { set_type(NodeType::Array); }

ArrayNode::ArrayNode(VectorNode * v) : value(v) { set_type(NodeType::Array); }

void
ArrayNode::print_using(ostream & out, unsigned d) {
    // out << string(d * 2, ' ') << "Array";
    // out << " => [ ";
    // for (VectorNode::iterator item = value->begin(); item < value->end(); item++) {
    //     (*item)->print_using(out, 0, false);
    //     out << ( (item != value->end() - 1) ? ", " : " " );
    // }
    // out << "]" << endl;
}

HashPairNode::HashPairNode(SyntaxNode * k, SyntaxNode * v) : key(k), value(v) { set_type(NodeType::HashPair); }

void
HashPairNode::print_using(ostream & out, unsigned d) {
    // key->print_using(out, 0, false);
    // out << " : ";
    // value->print_using(out, 0, false);
}

HashNode::HashNode() : value(new VectorNode()) { set_type(NodeType::Hash); }

HashNode::HashNode(VectorNode * v) : value(v) { set_type(NodeType::Hash); }

void
HashNode::print_using(ostream & out, unsigned d) {
    // out << string(d * 2, ' ') << "Hash => { ";
    // for (VectorNode::iterator item = value->begin(); item < value->end(); item++) {
    //     (*item)->print_using(out, 0, false);
    //     out << ( (item != value->end() - 1) ? ", " : " " );
    // }
    // out << "}" << endl;
}

void
UnaryExprNode::print_using(ostream & out, unsigned d) {
    // out << string(tab * 2, ' ') << "Unary expr. => [ " << Operation::get_enum_name(operation) << endl;
    // member1->print_using(out, tab + 1, nl);
    // out << " ]" << endl;
}

void
BinaryExprNode::print_using(ostream & out, unsigned d) {
    // out << string(tab * 2, ' ') << "Binary expr. => [ " << Operation::get_enum_name(operation) << endl;
    // member1->print_using(out, tab + 1, nl);
    // member2->print_using(out, tab + 1, nl);
    // out << " ]" << endl;
}

void
TernaryExprNode::print_using(ostream & out, unsigned d) {
    // out << string(tab * 2, ' ') << "Ternary expr. => [ " << Operation::get_enum_name(operation) << endl;
    // member1->print_using(out, tab + 1, nl);
    // member2->print_using(out, tab + 1, nl);
    // member3->print_using(out, tab + 1, nl);
    // out << " ]" << endl;
}

FunctionCallNode::FunctionCallNode(SyntaxNode * n) : name(n), args(new VectorNode) { set_type(NodeType::Nil); }

FunctionCallNode::FunctionCallNode(SyntaxNode * n, VectorNode * a) : name(n), args(a) { set_type(NodeType::Nil); }

void
FunctionCallNode::print_using(ostream & out, unsigned d) {
    // out << string(d * 2, ' ') << "Function call => ";
    // name->print_using(out, 0, false);
    // out << ", Args: ( ";
    // if (args->size() > 0) {
    //     for (VectorNode::iterator arg = args->begin(); arg < args->end(); arg++) {
    //         (*arg)->print_using(out, 0, false);
    //         out << ( (arg != args->end() - 1) ? ", " : " " );
    //     }
    // }
    // out << ")" << endl;
}

AsyncNode::AsyncNode(SyntaxNode * i) : item(i) { }

void
AsyncNode::print_using(ostream & out, unsigned d) {
    // TODO
}

LambdaExprNode::LambdaExprNode(VectorNode * a, SyntaxNode * e) : args(a), expr(e) { }

void
LambdaExprNode::print_using(ostream & out, unsigned d) {
    // TODO
}

} // SyntaxTree
} // LANG_NAMESPACE
