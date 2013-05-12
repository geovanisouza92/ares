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
 * cond.cpp - Condition statements
 *
 * Implements objects used to represent condition statements
 *
 */

#include "cond.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        IfNode::IfNode(SyntaxNode * c, SyntaxNode * s)
            : cond(c), stmt(s), elseStmt(NULL)
        {
            setNodeType(NodeType::Null);
        }

        IfNode::IfNode(SyntaxNode * c, SyntaxNode * s, SyntaxNode * e)
            : cond(c), stmt(s), elseStmt(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        IfNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "If" << endl;
            cond->print(out, d + 1);
            TAB(d) << "do" << endl;
            stmt->print(out, d + 1);
            if (elseStmt)
            {
                TAB(d) << "else" << endl;
                elseStmt->print(out, d + 1);
            }
        }

        UnlessNode::UnlessNode(SyntaxNode * c, SyntaxNode * s)
            : cond(c), stmt(s), elseStmt(NULL)
        {
            setNodeType(NodeType::Null);
        }

        UnlessNode::UnlessNode(SyntaxNode * c, SyntaxNode * s, SyntaxNode * e)
            : cond(c), stmt(s), elseStmt(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        UnlessNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Unless" << endl;
            cond->print(out, d + 1);
            TAB(d) << "do" << endl;
            stmt->print(out, d + 1);
            if (elseStmt)
            {
                TAB(d) << "else" << endl;
                elseStmt->print(out, d + 1);
            }
        }

        SwitchNode::SwitchNode(SyntaxNode * c, VectorNode * s)
            : caseExpr(c), caseSections(s)
        {
            setNodeType(NodeType::Null);
        }

        void
        SwitchNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Case" << endl;
            caseExpr->print(out, d + 1);
            for (auto section = caseSections->begin(); section < caseSections->end(); section++)
                (*section)->print(out, d + 2);
        }

        SwitchSectionNode::SwitchSectionNode(VectorNode * l, VectorNode * s)
            : labels(l), stmts(s)
        {
            setNodeType(NodeType::Null);
        }

        void
        SwitchSectionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "On label" << endl;
            for (auto label = labels->begin(); label < labels->end(); label++)
                (*label)->print(out, d + 1);
            TAB(d) << "do" << endl;
            for (auto stmt = stmts->begin(); stmt < stmts->end(); stmt++)
                (*stmt)->print(out, d + 1);
        }

        SwitchLabelNode::SwitchLabelNode()
        {
            expr = NULL;
            setNodeType(NodeType::Null);
        }

        SwitchLabelNode::SwitchLabelNode(SyntaxNode * e)
            : expr(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        SwitchLabelNode::print(ostream & out, unsigned d)
        {
            if (expr)
            {
                TAB(d) << "case" << endl;
                expr->print(out, d +  1);
            }
            else
                TAB(d) << "default label" << endl;
        }
    } // SyntaxTree
} // LANG_NAMESPACE
