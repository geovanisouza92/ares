
#include "stoql.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

QueryNode::QueryNode(SyntaxNode * o, SyntaxNode * b) : origin(o), body(b) { set_type(NodeType::Array); }

void
QueryNode::print_using(ostream & out, unsigned d) {
    // origin->print_using(out, d, false);
    // if (body)
    //     body->print_using(out, d, false);
    // out << ( nl ? "\n" : "" );
}

QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e) : id(i), expr(e) { set_type(NodeType::Nil); }

void
QueryOriginNode::print_using(ostream & out, unsigned d) {
    // out << "From => ";
    // id->print_using(out, 0, false);
    // out << " in ";
    // expr->print_using(out, 0, false);
    // out << ( nl ? "\n" : "" );
}

QueryBodyNode::QueryBodyNode() : body(new VectorNode()) { set_type(NodeType::Nil); }

QueryBodyNode *
QueryBodyNode::set_body(VectorNode * b) {
    for (VectorNode::iterator item = b->begin(); item < b->end(); item++)
        body->push_back(*item);
    return this;
}

QueryBodyNode *
QueryBodyNode::set_finally(SyntaxNode * f) {
    finally = f;
    return this;
}

void
QueryBodyNode::print_using(ostream & out, unsigned d) {
    // for (VectorNode::iterator b = body->begin(); b < body->end(); b++)
    //     (*b)->print_using(out, 0, false);
    // finally->print_using(out, 0, false);
    // out << ( nl ? "\n" : "" );
}

WhereNode::WhereNode(SyntaxNode * e) : expr(e) { set_type(NodeType::Nil); }

void
WhereNode::print_using(ostream & out, unsigned d) {
    // out << " Where: ";
    // expr->print_using(out, 0, false);
    // out << ( nl ? "\n" : "" );
}

JoinNode::JoinNode(SyntaxNode * o, SyntaxNode * e, JoinDirection::Direction d) : origin(o), expr(e), direction(d) { set_type(NodeType::Nil); }

void
JoinNode::print_using(ostream & out, unsigned d) {
    // switch (direction) {
    // case JoinDirection::Left:
    //     out << " Left join => ";
    //     break;
    // case JoinDirection::Right:
    //     out << " Right join => ";
    //     break;
    // default:
    //     out << " Join => ";
    //     break;
    // }
    // out << " Origin: ";
    // origin->print_using(out, 0, false);
    // out << " on expression: ";
    // expr->print_using(out, 0, false);
    // out << ( nl ? "\n" : "" );
}

OrderingNode::OrderingNode(SyntaxNode * e, OrderDirection::Direction d) : expr(e), direction(d) { set_type(NodeType::Nil); }

void
OrderingNode::print_using(ostream & out, unsigned d) {
    // expr->print_using(out, 0, false);
    // switch (direction) {
    // case OrderDirection::Asc:
    //     out << " asc ";
    //     break;
    // case OrderDirection::Desc:
    //     out << " desc ";
    //     break;
    // default:
    //     break;
    // }
    // out << ( nl ? "\n" : "" );
}

OrderByNode::OrderByNode(VectorNode * o) : orders(o) { set_type(NodeType::Nil); }

void
OrderByNode::print_using(ostream & out, unsigned d) {
    // out << " Order by => [";
    // for (VectorNode::iterator order = orders->begin(); order < orders->end(); order++) {
    //     (*order)->print_using(out, 0, false);
    //     out << ( order == orders->end() - 1 ? " " : ", ");
    // }
    // out << ( nl ? "]\n" : "]" );
}

GroupByNode::GroupByNode(SyntaxNode * e) : expr(e) { set_type(NodeType::Nil); }

void
GroupByNode::print_using(ostream & out, unsigned d) {
    // out << " Group by => ";
    // expr->print_using(out, 0, false);
    // out << ( nl ? "\n" : "" );
}

RangeNode::RangeNode(RangeType::Type t, SyntaxNode * r) : rtype(t), range(r) { set_type(NodeType::Nil); }

void
RangeNode::print_using(ostream & out, unsigned d) {
    // switch(rtype) {
    // case RangeType::Skip:
    //     out << " Skip => ";
    //     break;
    // case RangeType::Step:
    //     out << " Step => ";
    //     break;
    // case RangeType::Take:
    //     out << " Take => ";
    //     break;
    // default:
    //     break;
    // }
    // range->print_using(out, 0, false);
    // out << " ";
}

SelectNode::SelectNode(VectorNode * s) : selection(s) { set_type(NodeType::Nil); }

void
SelectNode::print_using(ostream & out, unsigned d) {
    // out << " Select => ";
    // for (VectorNode::iterator select = selection->begin(); select < selection->end(); select++)
    //     (*select)->print_using(out, 0, false);
    // out << ( nl ? "\n" : "" );
}

} // SyntaxTree
} // LANG_NAMESPACE
