
#include "stoql.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

QueryNode::QueryNode(SyntaxNode * o, SyntaxNode * b) : origin(o), body(b) { set_type(NodeType::Array); }

void
QueryNode::print_using(ostream & out, unsigned d, bool nl) {
    origin->print_using(out, d, false);
    if (body)
        body->print_using(out, d, false);
    out << ( nl ? "\n" : "" );
}

void
QueryNode::evaluate() {
    // TODO
}

QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e) : id(i), expr(e) { set_type(NodeType::Nil); }

void
QueryOriginNode::print_using(ostream & out, unsigned d, bool nl) {
    out << "From => ";
    id->print_using(out, 0, false);
    out << " in ";
    expr->print_using(out, 0, false);
    out << ( nl ? "\n" : "" );
}

QueryBodyNode::QueryBodyNode(SyntaxNode * f) : finally(f), body(new VectorNode()) { set_type(NodeType::Nil); }

void
QueryBodyNode::set_body(VectorNode * b) {
    for (VectorNode::iterator item = b->begin(); item < b->end(); item++)
        body->push_back(*item);
}

void
QueryBodyNode::print_using(ostream & out, unsigned d, bool nl) {
    for (VectorNode::iterator b = body->begin(); b < body->end(); b++)
        (*b)->print_using(out, 0, false);
    finally->print_using(out, 0, false);
    out << ( nl ? "\n" : "" );
}

WhereNode::WhereNode(SyntaxNode * e) : expr(e) { set_type(NodeType::Nil); }

void
WhereNode::print_using(ostream & out, unsigned d, bool nl) {
    out << " Where: ";
    expr->print_using(out, 0, false);
    out << ( nl ? "\n" : "" );
}

JoinNode::JoinNode(SyntaxNode * o, SyntaxNode * e, JoinDirection::Direction d) : origin(o), expr(e), direction(d) { set_type(NodeType::Nil); }

void
JoinNode::print_using(ostream & out, unsigned d, bool nl) {
    switch (direction) {
    case JoinDirection::Left:
        out << " Left join => ";
        break;
    case JoinDirection::Right:
        out << " Right join => ";
        break;
    default:
        out << " Join => ";
        break;
    }
    out << " Origin: ";
    origin->print_using(out, 0, false);
    out << " on expression: ";
    expr->print_using(out, 0, false);
    out << ( nl ? "\n" : "" );
}

OrderingNode::OrderingNode(SyntaxNode * e, OrderDirection::Direction d) : expr(e), direction(d) { set_type(NodeType::Nil); }

void
OrderingNode::print_using(ostream & out, unsigned d, bool nl) {
    expr->print_using(out, 0, false);
    switch (direction) {
    case OrderDirection::Asc:
        out << " asc ";
        break;
    case OrderDirection::Desc:
        out << " desc ";
        break;
    default:
        break;
    }
    out << ( nl ? "\n" : "" );
}

OrderByNode::OrderByNode(VectorNode * o) : orders(o) { set_type(NodeType::Nil); }

void
OrderByNode::print_using(ostream & out, unsigned d, bool nl) {
    out << " Order by => [";
    for (VectorNode::iterator order = orders->begin(); order < orders->end(); order++) {
        (*order)->print_using(out, 0, false);
        out << ( order == orders->end() - 1 ? " " : ", ");
    }
    out << ( nl ? "]\n" : "]" );
}

GroupByNode::GroupByNode(SyntaxNode * e) : expr(e) { set_type(NodeType::Nil); }

void
GroupByNode::print_using(ostream & out, unsigned d, bool nl) {
    out << " Group by => ";
    expr->print_using(out, 0, false);
    out << ( nl ? "\n" : "" );
}

RangeNode::RangeNode() { set_type(NodeType::Nil); }

// SyntaxNode *
// RangeNode::get_skip() {
//     return skip;
// }

// SyntaxNode *
// RangeNode::get_step() {
//     return step;
// }

// SyntaxNode *
// RangeNode::get_take() {
//     return take;
// }

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
    if (skip) {
        out << " Skip => ";
        skip->print_using(out, 0, false);
        out << " ";
    }
    if (step) {
        out << " Step => ";
        step->print_using(out, 0, false);
        out << " ";
    }
    if (take) {
        out << " Take => ";
        take->print_using(out, 0, false);
        out << " ";
    }
}

SelectNode::SelectNode(VectorNode * s, SyntaxNode * r) : selection(s), range(r) { set_type(NodeType::Nil); }

void
SelectNode::print_using(ostream & out, unsigned d, bool nl) {
    out << " Select => ";
    for (VectorNode::iterator select = selection->begin(); select < selection->end(); select++)
        (*select)->print_using(out, 0, false);
    if (range)
        range->print_using(out, 0, false);
    out << ( nl ? "\n" : "" );
}

} // SyntaxTree
} // LANG_NAMESPACE
