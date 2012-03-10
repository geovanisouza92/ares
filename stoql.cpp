
#include "stoql.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

QueryNode::QueryNode(SyntaxNode * o, SyntaxNode * b) : origin(o), body(b) { set_type(NodeType::Array); }

void
QueryNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

void
QueryNode::evaluate() {
    // TODO
}

QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e) : id(i), expr(e) { set_type(NodeType::Nil); }

void
QueryOriginNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

QueryBodyNode::QueryBodyNode(SyntaxNode * f) : finally(f), body(new VectorNode()) { set_type(NodeType::Nil); }

void
QueryBodyNode::set_body(VectorNode * b) {
    for (VectorNode::iterator item = b->begin(); item < b->end(); item++)
        body->push_back(*item);
}

void
QueryBodyNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

WhereNode::WhereNode(SyntaxNode * e) : expr(e) { set_type(NodeType::Nil); }

void
WhereNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

JoinNode::JoinNode(SyntaxNode * o, SyntaxNode * e, JoinDirection::Direction d) : origin(o), expr(e), direction(d) { set_type(NodeType::Nil); }

void
JoinNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

OrderingNode::OrderingNode(SyntaxNode * e, OrderDirection::Direction d) : expr(e), direction(d) { set_type(NodeType::Nil); }

void
OrderingNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

OrderByNode::OrderByNode(VectorNode * o) : OrderingNodes(o) { set_type(NodeType::Nil); }

void
OrderByNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

GroupByNode::GroupByNode(SyntaxNode * e) : expr(e) { set_type(NodeType::Nil); }

void
GroupByNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

RangeNode::RangeNode() { set_type(NodeType::Nil); }

RangeNode *
RangeNode::set_skip(SyntaxNode * sk) {
    skip = sk;
    return this;
}

RangeNode *
RangeNode::set_step(SyntaxNode * st) {
    step = st;
    return this;
}

RangeNode *
RangeNode::set_take(SyntaxNode * ta) {
    take = ta;
    return this;
}

void
RangeNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

SelectNode::SelectNode(VectorNode * s, SyntaxNode * r) : selection(s), range(r) { set_type(NodeType::Nil); }

void
SelectNode::print_using(ostream & out, unsigned d, bool nl) {
    // TODO
}

} // SyntaxTree
} // LANG_NAMESPACE
