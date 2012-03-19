
#include "stmt.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

IfStmtNode::IfStmtNode(SyntaxNode * i, VectorNode * t) : if_stmt(i), then_stmt(t), elif_stmt(new VectorNode()), else_stmt(new VectorNode()) { }

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

UnlessStmtNode::UnlessStmtNode(SyntaxNode * i, VectorNode * t) : if_stmt(i), then_stmt(t), else_stmt(new VectorNode()) { }

UnlessStmtNode *
UnlessStmtNode::set_else(VectorNode * e) {
    for (VectorNode::iterator Else = e->begin(); Else < e->end(); Else++)
        else_stmt->push_back(*Else);
    return this;
}

void
UnlessStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

CaseStmtNode::CaseStmtNode(SyntaxNode * c) : case_stmt(c), when_stmt(new VectorNode()), else_stmt(new VectorNode()) { }

CaseStmtNode *
CaseStmtNode::set_when(VectorNode * w) {
    if (w != NULL)
        for (VectorNode::iterator when = w->begin(); when < w->end(); when++)
            when_stmt->push_back(*when);
    return this;
}

CaseStmtNode *
CaseStmtNode::set_else(VectorNode * e) {
    if (e != NULL)
        for (VectorNode::iterator Else = e->begin(); Else < e->end(); Else++)
            else_stmt->push_back(*Else);
    return this;
}

void
CaseStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

WhenClauseNode::WhenClauseNode(SyntaxNode * w, SyntaxNode * b) : when(w), block(b) { }

void
WhenClauseNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

ForStmtNode::ForStmtNode(SyntaxNode * l, SyntaxNode * r, Loop::Operation o, SyntaxNode * b) : lhs(l), rhs(r), op(o), block(b) { }

ForStmtNode *
ForStmtNode::set_step(SyntaxNode * s) {
    step = s;
    return this;
}

void
ForStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

LoopStmtNode::LoopStmtNode(SyntaxNode * e, SyntaxNode * b, Loop::Operation o) : expr(e), block(b), op(o) { }

void
LoopStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

AsyncStmtNode::AsyncStmtNode(SyntaxNode * o, AsyncType::Type t) : async_obj(o), type(t) { }

void
AsyncStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

RaiseStmtNode::RaiseStmtNode(SyntaxNode * e) : expr(e) { }

void
RaiseStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

ControlStmtNode::ControlStmtNode(Control::Operation o, SyntaxNode * e) : op(o), expr(e) { }

void
ControlStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

BlockStmtNode::BlockStmtNode(VectorNode * s) : require(new VectorNode()), stmts(new VectorNode()), ensure(new VectorNode()), rescue(new VectorNode()) {
    if (s != NULL)
        for (VectorNode::iterator stmt = s->begin(); stmt < s->end(); stmt++)
            stmts->push_back(*stmt);
}

BlockStmtNode *
BlockStmtNode::set_require(VectorNode * r) {
    for (VectorNode::iterator req = r->begin(); req < r->end(); req++)
        require->push_back(*req);
    return this;
}

BlockStmtNode *
BlockStmtNode::set_ensure(VectorNode * e) {
    for (VectorNode::iterator ens = e->begin(); ens < e->end(); ens++)
        ensure->push_back(*ens);
    return this;
}

BlockStmtNode *
BlockStmtNode::set_rescue(VectorNode * r) {
    for (VectorNode::iterator res = r->begin(); res < r->end(); res++)
        rescue->push_back(*res);
    return this;
}

void
BlockStmtNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

ConditionNode::ConditionNode(SyntaxNode * e, SyntaxNode * r) : expr(e), raise(r) { }

void
ConditionNode::print_using(ostream & out, unsigned, bool nl) {
    // TODO
}

InlineNode::InlineNode(Inline::Operation o, VectorNode * i, SyntaxNode * c) : op(o), items(i), ctx(c) { }

void
InlineNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

} // SyntaxTree
} // LANG_NAMESPACE