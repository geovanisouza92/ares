/** Ares Programming Language
 *
 * oql.cpp - Object Query Laguage
 *
 * Implements objects used to represent OQL expression
 */

#include "oql.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        QueryNode::QueryNode(SyntaxNode * o, SyntaxNode * b)
            : queryOrigin(o), queryBody(b)
        {
            setNodeType(NodeType::Array);
        }

        void
        QueryNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "Query =>" << endl;
            queryOrigin->toString(out, d + 1);
            if(queryBody != NULL) {
                queryBody->toString(out, d + 1);
            }
        }

        QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e)
            : originIdentifier(i), originExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        QueryOriginNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "From =>" << endl;
            originIdentifier->toString(out, d + 1);
            TAB(d + 1) << "in" << endl;
            originExpression->toString(out, d + 2);
        }

        QueryBodyNode::QueryBodyNode()
            : queryBody(new VectorNode()), queryFinally(NULL)
        {
            setNodeType(NodeType::Null);
        }

        QueryBodyNode *
        QueryBodyNode::set_body(VectorNode * b)
        {
            for(VectorNode::iterator item = b->begin(); item < b->end(); item++)
                queryBody->push_back(*item);
            return this;
        }

        QueryBodyNode *
        QueryBodyNode::set_finally(SyntaxNode * f)
        {
            queryFinally = f;
            return this;
        }

        void
        QueryBodyNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "Operations =>" << endl;
            for(VectorNode::iterator b = queryBody->begin(); b < queryBody->end(); b++) {
               (*b)->toString(out, d + 1);
            }
            if(queryFinally != NULL) {
                TAB(d + 1) << "Finally =>" << endl;
                queryFinally->toString(out, d + 2);
            }
        }

        WhereNode::WhereNode(SyntaxNode * e)
            : whereExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        WhereNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "Where =>" << endl;
            whereExpression->toString(out, d + 1);
        }

        JoinNode::JoinNode(JoinType::Type t, SyntaxNode * o, SyntaxNode * e)
            : joinDirection(t), joinOrigin(o), joinExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        JoinNode::toString(ostream & out, unsigned d)
        {
            switch(joinDirection) {
            case JoinType::Left:
                TAB(d) << "Left join =>" << endl;
                break;
            case JoinType::Right:
                TAB(d) << "Right join =>" << endl;
                break;
            default:
                TAB(d) << "Join =>" << endl;
                break;
            }
            TAB(d) << "Origin =>" << endl;
            joinOrigin->toString(out, d + 1);
            TAB(d + 1) << "on expression =>" << endl;
            joinExpression->toString(out, d + 2);
        }

        OrderingNode::OrderingNode(OrderType::Type t, SyntaxNode * e)
            : orderType(t), orderExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        OrderingNode::toString(ostream & out, unsigned d)
        {
            orderExpression->toString(out, d + 1);
            switch(orderType) {
            case OrderType::Asc:
                TAB(d) << "ascending" << endl;
                break;
            case OrderType::Desc:
                TAB(d) << "descending" << endl;
                break;
            default:
                break;
            }
        }

        OrderByNode::OrderByNode(VectorNode * o)
            : orders(o)
        {
            setNodeType(NodeType::Null);
        }

        void
        OrderByNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "Ordering =>" << endl;
            for(VectorNode::iterator order = orders->begin(); order < orders->end(); order++) {
               (*order)->toString(out, d + 1);
                if(order != orders->end() - 1) TAB(d + 2) << ", " << endl;
            }
        }

        GroupByNode::GroupByNode(SyntaxNode * e)
            : groupExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        GroupByNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "Grouping =>" << endl;
            groupExpression->toString(out, d + 1);
        }

        RangeNode::RangeNode(RangeType::Type t, SyntaxNode * r)
            : rangeType(t), rangeRange(r)
        {
            setNodeType(NodeType::Null);
        }

        void
        RangeNode::toString(ostream & out, unsigned d)
        {
            switch(rangeType) {
            case RangeType::Skip:
                TAB(d) << "Skiping =>" << endl;
                break;
            case RangeType::Step:
                TAB(d) << "Steping =>" << endl;
                break;
            case RangeType::Take:
                TAB(d) << "Taking =>" << endl;
                break;
            default:
                break;
            }
            rangeRange->toString(out, d + 1);
        }

        SelectNode::SelectNode(VectorNode * s)
            : selection(s)
        {
            setNodeType(NodeType::Null);
        }

        void
        SelectNode::toString(ostream & out, unsigned d)
        {
            TAB(d) << "Select =>" << endl;
            for(VectorNode::iterator select = selection->begin(); select < selection->end(); select++) {
               (*select)->toString(out, d + 1);
                if(select != selection->end() - 1) TAB(d + 2) << ", " << endl;
            }
        }
    } // SyntaxTree
} // LANG_NAMESPACE
