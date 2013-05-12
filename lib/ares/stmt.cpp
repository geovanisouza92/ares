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
 * stmt.cpp - Statements
 *
 * Implements objects used to represent statements
 *
 */

#include "stmt.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        TryStatementNode::TryStatementNode(SyntaxNode * b)
            : tryBlock(b), tryCatch(NULL), tryFinally(NULL)
        {
            setNodeType(NodeType::Null);
        }

        void
        TryStatementNode::setCatch(VectorNode * c)
        {
            tryCatch = c;
        }

        void
        TryStatementNode::setFinally(SyntaxNode * f)
        {
            tryFinally = f;
        }

        void
        TryStatementNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Try" << endl;
            tryBlock->print(out, d + 1);
            if (tryCatch)
            {
                TAB(d) << "catching errors on" << endl;
                for (auto c = tryCatch->begin(); c < tryCatch->end(); c++)
                    (*c)->print(out, d + 1);
            }
            if (tryFinally)
            {
                TAB(d) << "finally" << endl;
                tryFinally->print(out, d + 1);
            }
        }

        CatchStatementNode::CatchStatementNode(SyntaxNode * b)
            : catchingBlock(b), catchingType(NULL), catchingId(NULL)
        {
            setNodeType(NodeType::Null);
        }

        CatchStatementNode::CatchStatementNode(SyntaxNode * t, SyntaxNode * b)
            : catchingType(t), catchingId(NULL), catchingBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        CatchStatementNode::CatchStatementNode(SyntaxNode * t, SyntaxNode * i, SyntaxNode * b)
            : catchingType(t), catchingId(i), catchingBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        void
        CatchStatementNode::print(ostream & out, unsigned d)
        {
            if (catchingType)
            {
                TAB(d) << "Catch errors of type" << endl;
                catchingType->print(out, d + 1);
                if (catchingId)
                {
                    TAB(d) << "using identifier" << endl;
                    catchingId->print(out, d + 1);
                }
                TAB(d) << "in block" << endl;
                catchingBlock->print(out, d + 1);
            } else {
                TAB(d) << "Catch all errors in block" << endl;
                catchingBlock->print(out, d + 1);
            }
        }

        BlockNode::BlockNode(VectorNode * s)
            : blockStatements(s)
        {
            setNodeType(NodeType::Null);
        }

        void
        BlockNode::print(ostream & out, unsigned d)
        {
            for (auto stmt = blockStatements->begin(); stmt < blockStatements->end(); stmt++) {
                (*stmt)->print(out, d + 1);
            }
        }

        ElementNode::ElementNode(ElementType::Type t, SyntaxNode * n, SyntaxNode * i)
            : type(t), name(n), init(i)
        {
            setNodeType(NodeType::Null);
        }

        void
        ElementNode::print(ostream & out, unsigned d)
        {
            TAB(d) << ElementType::TypeStrings[nodeType] << " => " << endl;
            name->print(out, d + 1);
            if (init)
            {
                TAB(d) << "value" << endl;
                init->print(out, d + 1);
            }
        }

        VariableDeclStatementNode::VariableDeclStatementNode(SyntaxNode * t, VectorNode * v)
            : ty(t), variables(v)
        {
            setNodeType(NodeType::Null);
        }

        void
        VariableDeclStatementNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Variables" << endl;
            for (auto var = variables->begin(); var < variables->end(); var++)
                (*var)->print(out, d + 1);
        }

        ConstantDeclStatementNode::ConstantDeclStatementNode(SyntaxNode * t, VectorNode * v)
            : ty(t), consts(v)
        {
            setNodeType(NodeType::Null);
        }

        void
        ConstantDeclStatementNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Constants" << endl;
            ty->print(out, d + 1);
            for (auto cons = consts->begin(); cons < consts->end(); cons++)
                (*cons)->print(out, d + 1);
        }
    } // SyntaxTree
} // LANG_NAMESPACE
