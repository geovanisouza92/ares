
/* Ares Programming Language */

#include "stoql.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

QueryNode::QueryNode(SyntaxNode * o, SyntaxNode * b) :
		origin(o), body(b) {
	set_node_type(NodeType::Array);
}

void QueryNode::print_using(ostream & out, unsigned d) {
	TAB << "Query from [ " << endl;
	origin->print_using(out, d + 1);
	TAB << " ]" << endl;
	if (body != 0) {
		TAB << "using => " << endl;
		body->print_using(out, d + 1);
	}
}

QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e) :
		id(i), expr(e) {
	set_node_type(NodeType::Nil);
}

void QueryOriginNode::print_using(ostream & out, unsigned d) {
	TAB << "From => " << endl;
	id->print_using(out, d + 1);
	TAB << "in " << endl;
	expr->print_using(out, d + 1);
}

QueryBodyNode::QueryBodyNode() :
		body(new VectorNode()) {
	set_node_type(NodeType::Nil);
}

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

void QueryBodyNode::print_using(ostream & out, unsigned d) {
	TAB << "Operations => " << endl;
	for (VectorNode::iterator b = body->begin(); b < body->end(); b++) {
		(*b)->print_using(out, d + 2);
	}
	if (finally != 0) {
		TAB << "Finally => " << endl;
		finally->print_using(out, d + 1);
	}
}

WhereNode::WhereNode(SyntaxNode * e) :
		expr(e) {
	set_node_type(NodeType::Nil);
}

void WhereNode::print_using(ostream & out, unsigned d) {
	TAB << "Where => " << endl;
	expr->print_using(out, d + 1);
}

JoinNode::JoinNode(SyntaxNode * o, SyntaxNode * e, JoinDirection::Direction d) :
		direction(d), origin(o), expr(e) {
	set_node_type(NodeType::Nil);
}

void JoinNode::print_using(ostream & out, unsigned d) {
	switch (direction) {
	case JoinDirection::Left:
		TAB << "Left join => " << endl;
		break;
	case JoinDirection::Right:
		TAB << "Right join => " << endl;
		break;
	default:
		TAB << "Join => " << endl;
		break;
	}
	TAB << "Origin => " << endl;
	origin->print_using(out, d + 1);
	TAB << "on expression => " << endl;
	expr->print_using(out, d + 1);
}

OrderingNode::OrderingNode(SyntaxNode * e, OrderDirection::Direction d) :
		expr(e), direction(d) {
	set_node_type(NodeType::Nil);
}

void OrderingNode::print_using(ostream & out, unsigned d) {
	expr->print_using(out, d + 1);
	switch (direction) {
	case OrderDirection::Asc:
		TAB << "ascending" << endl;
		break;
	case OrderDirection::Desc:
		TAB << "descending" << endl;
		break;
	default:
		break;
	}
}

OrderByNode::OrderByNode(VectorNode * o) :
		orders(o) {
	set_node_type(NodeType::Nil);
}

void OrderByNode::print_using(ostream & out, unsigned d) {
	TAB << "Ordering => " << endl;
	for (VectorNode::iterator order = orders->begin(); order < orders->end();
			order++) {
		(*order)->print_using(out, d + 1);
		TAB << ((order != orders->end() - 1) ? ", " : " ") << endl;
	}
}

GroupByNode::GroupByNode(SyntaxNode * e) :
		expr(e) {
	set_node_type(NodeType::Nil);
}

void GroupByNode::print_using(ostream & out, unsigned d) {
	TAB << "Grouping => " << endl;
	expr->print_using(out, d + 1);
}

RangeNode::RangeNode(RangeType::Type t, SyntaxNode * r) :
		type(t), range(r) {
	set_node_type(NodeType::Nil);
}

void RangeNode::print_using(ostream & out, unsigned d) {
	switch (type) {
	case RangeType::Skip:
		TAB << "Skiping => " << endl;
		break;
	case RangeType::Step:
		TAB << "Steping => " << endl;
		break;
	case RangeType::Take:
		TAB << "Taking => " << endl;
		break;
	default:
		break;
	}
	range->print_using(out, d + 1);
}

SelectNode::SelectNode(VectorNode * s) :
		selection(s) {
	set_node_type(NodeType::Nil);
}

void SelectNode::print_using(ostream & out, unsigned d) {
	TAB << "Select => " << endl;
	for (VectorNode::iterator select = selection->begin();
			select < selection->end(); select++) {
		(*select)->print_using(out, d + 1);
		TAB << ((select != selection->end() - 1) ? ", " : " ") << endl;
	}
}

} // SyntaxTree
} // LANG_NAMESPACE
