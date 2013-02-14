/** Copyright (c) 2012, 2013
 *    Ares Programming Language Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. All advertising materials mentioning features or use of this software
 *     must display the following acknowledgement:
 *     This product includes software developed by Ares Programming Language
 *     Project and its contributors.
 *  4. Neither the name of the Ares Programming Language Project nor the names
 *     of its contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE ARES PROGRAMMING LANGUAGE PROJECT AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************
 * oql.cpp - Object Query Laguage
 *
 * Implements objects used to represent OQL expression
 *
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
        QueryNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Query =>" << endl;
            queryOrigin->print(out, d + 1);
            if(queryBody != NULL) {
                queryBody->print(out, d + 1);
            }
        }

        QueryOriginNode::QueryOriginNode(SyntaxNode * i, SyntaxNode * e)
            : originIdentifier(i), originExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        QueryOriginNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "From =>" << endl;
            originIdentifier->print(out, d + 1);
            TAB(d + 1) << "in" << endl;
            originExpression->print(out, d + 2);
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
        QueryBodyNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Operations =>" << endl;
            for(VectorNode::iterator b = queryBody->begin(); b < queryBody->end(); b++) {
               (*b)->print(out, d + 1);
            }
            if(queryFinally != NULL) {
                TAB(d + 1) << "Finally =>" << endl;
                queryFinally->print(out, d + 2);
            }
        }

        LetNode::LetNode(SyntaxNode * id, SyntaxNode * expr)
            : letId(id), letExpr(expr)
        {
            setNodeType(NodeType::Null);
        }

        void
        LetNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "let " << letId << " => " << endl;
            letExpr->print(out, d + 1);
        }

        WhereNode::WhereNode(SyntaxNode * e)
            : whereExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        WhereNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Where =>" << endl;
            whereExpression->print(out, d + 1);
        }

        JoinNode::JoinNode(JoinType::Type t, SyntaxNode * o, SyntaxNode * e)
            : joinDirection(t), joinOrigin(o), joinExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        JoinNode::set_new_id(SyntaxNode * new_id)
        {
            joinId = new_id;
        }

        void
        JoinNode::print(ostream & out, unsigned d)
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
            joinOrigin->print(out, d + 1);
            TAB(d + 1) << "on expression =>" << endl;
            joinExpression->print(out, d + 2);
        }

        OrderExprNode::OrderExprNode(OrderType::Type t, SyntaxNode * e)
            : orderType(t), orderExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        OrderExprNode::print(ostream & out, unsigned d)
        {
            orderExpression->print(out, d + 1);
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
        OrderByNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Ordering =>" << endl;
            for(VectorNode::iterator order = orders->begin(); order < orders->end(); order++) {
               (*order)->print(out, d + 1);
                if(order != orders->end() - 1) TAB(d + 2) << ", " << endl;
            }
        }

        GroupByNode::GroupByNode(SyntaxNode * origin, SyntaxNode * expr)
            : groupOrigin(origin), groupExpr(expr)
        {
            setNodeType(NodeType::Null);
        }

        void
        GroupByNode::set_id(SyntaxNode * id)
        {
            groupId = id;
        }

        void
        GroupByNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "group" << endl;
            groupOrigin->print(out, d + 1);
            TAB(d) << "by" << endl;
            groupExpr->print(out, d + 1);
            if (groupId != NULL)
            {
                TAB(d) << "into" << endl;
                groupId->print(out, d + 1);
            }
        }

        RangeNode::RangeNode(RangeType::Type t, SyntaxNode * r)
            : rangeType(t), rangeRange(r)
        {
            setNodeType(NodeType::Null);
        }

        void
        RangeNode::print(ostream & out, unsigned d)
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
            rangeRange->print(out, d + 1);
        }

        SelectNode::SelectNode(VectorNode * s)
            : selection(s)
        {
            setNodeType(NodeType::Null);
        }

        void
        SelectNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Select =>" << endl;
            for(VectorNode::iterator select = selection->begin(); select < selection->end(); select++) {
               (*select)->print(out, d + 1);
                if(select != selection->end() - 1) TAB(d + 2) << ", " << endl;
            }
        }
    } // SyntaxTree
} // LANG_NAMESPACE
