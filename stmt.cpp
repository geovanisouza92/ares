
#include "stmt.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

IfStmtNode::IfStmtNode(SyntaxNode * i, VectorNode * t) : if_stmt(i), then_stmt(t) { }

IfStmtNode *
IfStmtNode::set_elif(VectorNode * e) {
    for (VectorNode::iterator elif = e->begin(); elif < e->end(); elif++)
        elif_stmt->push_back(*elif);
    return this;
}

IfStmtNode *
IfStmtNode::set_else(VectorNode * e) {
    for (VectorNode::iterator Else = e->begin(); Else < e->end(); Else++)
        else_stmt->push_back(*Else);
    return this;
}

void
IfStmtNode::print_using(ostream & out, unsigned b, bool) {
    // TODO
}

void
IfStmtNode::execute() {
    // TODO
}

AsyncStmtNode::AsyncStmtNode(SyntaxNode * o) : async_obj(o) { }

void
AsyncStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

void
AsyncStmtNode::execute() {
    // TODO
}

} // SyntaxTree
} // LANG_NAMESPACE