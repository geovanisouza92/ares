/* Ares Programming Language */

#include "stoql.h"

namespace LANG_NAMESPACE {
    namespace SyntaxTree {

        QueryNode::QueryNode(SyntaxNode * o, SyntaxNode * b) :
                queryOrigin(o), queryBody(b) {
            setNodeType(NodeType::Array);
        }

        void QueryNode::printUsing(ostream & out, unsigned d) {
            TAB << "Query from [" << endl;
            queryOrigin->printUsing(out, d + 1);
            TAB << "]" << endl;
            if (queryBody != NULL) {
                TAB << "Producing => " << endl;
                queryBody->printUsing(out, d + 1);
            }
        }

        QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e) :
                originIdentifier(i), originExpression(e) {
            setNodeType(NodeType::Nil);
        }

        void QueryOriginNode::printUsing(ostream & out, unsigned d) {
            TAB << "From =>" << endl;
            originIdentifier->printUsing(out, d + 1);
            TAB << "in" << endl;
            originExpression->printUsing(out, d + 1);
        }

        QueryBodyNode::QueryBodyNode() :
                queryBody(new VectorNode()), queryFinally(new SelectNode(new VectorNode())) {
            setNodeType(NodeType::Nil);
        }

        QueryBodyNode *
        QueryBodyNode::set_body(VectorNode * b) {
            for (VectorNode::iterator item = b->begin(); item < b->end(); item++)
                queryBody->push_back(*item);
            return this;
        }

        QueryBodyNode *
        QueryBodyNode::set_finally(SyntaxNode * f) {
            delete queryFinally;
            queryFinally = f;
            return this;
        }

        void QueryBodyNode::printUsing(ostream & out, unsigned d) {
            TAB << "Operations =>" << endl;
            for (VectorNode::iterator b = queryBody->begin(); b < queryBody->end(); b++) {
                (*b)->printUsing(out, d + 2);
            }
            if (queryFinally != NULL) {
                TAB << "Finally =>" << endl;
                queryFinally->printUsing(out, d + 1);
            }
        }

        WhereNode::WhereNode(SyntaxNode * e) :
                whereExpression(e) {
            setNodeType(NodeType::Nil);
        }

        void WhereNode::printUsing(ostream & out, unsigned d) {
            TAB << "Where =>" << endl;
            whereExpression->printUsing(out, d + 1);
        }

        JoinNode::JoinNode(JoinType::Type t, SyntaxNode * o, SyntaxNode * e) : joinDirection(t), joinOrigin(o), joinExpression(e) {
            setNodeType(NodeType::Nil);
        }

        void JoinNode::printUsing(ostream & out, unsigned d) {
            switch (joinDirection) {
            case JoinType::Left:
                TAB << "Left join =>" << endl;
                break;
            case JoinType::Right:
                TAB << "Right join =>" << endl;
                break;
            default:
                TAB << "Join =>" << endl;
                break;
            }
            TAB << "Origin =>" << endl;
            joinOrigin->printUsing(out, d + 1);
            TAB << "on expression =>" << endl;
            joinExpression->printUsing(out, d + 1);
        }

        OrderingNode::OrderingNode(OrderType::Type t, SyntaxNode * e) : orderType(t), orderExpression(e) {
            setNodeType(NodeType::Nil);
        }

        void OrderingNode::printUsing(ostream & out, unsigned d) {
            orderExpression->printUsing(out, d + 1);
            switch (orderType) {
            case OrderType::Asc:
                TAB << "ascending" << endl;
                break;
            case OrderType::Desc:
                TAB << "descending" << endl;
                break;
            default:
                break;
            }
        }

        OrderByNode::OrderByNode(VectorNode * o) : orders(o) {
            setNodeType(NodeType::Nil);
        }

        void OrderByNode::printUsing(ostream & out, unsigned d) {
            TAB << "Ordering =>" << endl;
            for (VectorNode::iterator order = orders->begin(); order < orders->end(); order++) {
                (*order)->printUsing(out, d + 1);
                TAB << ((order != orders->end() - 1) ? ", " : " ") << endl;
            }
        }

        GroupByNode::GroupByNode(SyntaxNode * e) : groupExpression(e) {
            setNodeType(NodeType::Nil);
        }

        void GroupByNode::printUsing(ostream & out, unsigned d) {
            TAB << "Grouping =>" << endl;
            groupExpression->printUsing(out, d + 1);
        }

        RangeNode::RangeNode(RangeType::Type t, SyntaxNode * r) :
                rangeType(t), rangeRange(r) {
            setNodeType(NodeType::Nil);
        }

        void RangeNode::printUsing(ostream & out, unsigned d) {
            switch (rangeType) {
            case RangeType::Skip:
                TAB << "Skiping =>" << endl;
                break;
            case RangeType::Step:
                TAB << "Steping =>" << endl;
                break;
            case RangeType::Take:
                TAB << "Taking =>" << endl;
                break;
            default:
                break;
            }
            rangeRange->printUsing(out, d + 1);
        }

        SelectNode::SelectNode(VectorNode * s) : selection(s) {
            setNodeType(NodeType::Nil);
        }

        void SelectNode::printUsing(ostream & out, unsigned d) {
            TAB << "Select =>" << endl;
            for (VectorNode::iterator select = selection->begin(); select < selection->end(); select++) {
                (*select)->printUsing(out, d + 1);
                TAB << ((select != selection->end() - 1) ? ", " : " ") << endl;
            }
        }

    } // SyntaxTree
} // LANG_NAMESPACE
