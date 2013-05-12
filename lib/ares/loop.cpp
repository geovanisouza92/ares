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
 * loop.cpp - Loop statements
 *
 * Implements objects used to represent loop statements
 *
 */

#include "loop.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        ForNode::ForNode(VectorNode * ini, SyntaxNode * c, VectorNode * inc, SyntaxNode * b)
            : forInit(ini), forCond(c), forInc(inc), forBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        void
        ForNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "For loop" << endl;
            if (forInit)
            {
                TAB(d + 1) << "initializing" << endl;
                for (auto ini = forInit->begin(); ini < forInit->end(); ini++)
                    (*ini)->print(out, d + 2);
            }
            if (forCond)
            {
                TAB(d + 1) << "stoping when" << endl;
                forCond->print(out, d + 2);
            }
            if (forInc)
            {
                TAB(d + 1) << "incrementing" << endl;
                for (auto inc = forInc->begin(); inc < forInc->end(); inc++)
                    (*inc)->print(out, d + 2);
            }
            TAB(d + 1) << "block" << endl;
            forBlock->print(out, d + 2);
        }

        ForeachNode::ForeachNode(SyntaxNode * t, SyntaxNode * n, SyntaxNode * s, SyntaxNode * b)
            : foreachType(t), foreachName(n), foreachSource(s), foreachBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        void
        ForeachNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Foreach loop" << endl;
            TAB(d) << "of type" << endl;
            foreachType->print(out, d + 1);
            TAB(d) << "in variable" << endl;
            foreachName->print(out, d + 1);
            TAB(d) << "from expression" << endl;
            foreachSource->print(out, d + 1);
            TAB(d) << "do block" << endl;
            foreachBlock->print(out, d + 1);
        }

        WhileNode::WhileNode(SyntaxNode * e, SyntaxNode * b)
            : whileExpr(e), whileBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        void
        WhileNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "While" << endl;
            whileExpr->print(out, d + 1);
            TAB(d) << "do block" << endl;
            whileBlock->print(out, d + 2);
        }

        DoWhileNode::DoWhileNode(SyntaxNode * b, SyntaxNode * e)
            : doBlock(b), doExpr(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        DoWhileNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Do block" << endl;
            doBlock->print(out, d + 2);
            TAB(d) << "while" << endl;
            doExpr->print(out, d + 1);
        }
    } // SyntaxTree
} // LANG_NAMESPACE
