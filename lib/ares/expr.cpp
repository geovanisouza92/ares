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
 * expr.cpp - Basic expressions
 *
 * Implements objects used to represent basic expressions
 *
 */

#include "expr.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        UnaryExpressionNode::UnaryExpressionNode(Operator::Unary op, SyntaxNode * m1)
            : op(op), member1(m1)
        {
            setNodeType(NodeType::Null);
        }

        UnaryExpressionNode::UnaryExpressionNode(Operator::Unary op, VectorNode * m1)
            : op(op), vector1(m1)
        {
            setNodeType(NodeType::Null);
        }

        void
        UnaryExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Unary expression [ " << Operator::UnaryStrings[op - 0x100] << " ] =>" << endl;
            member1->print(out, d + 1);
        }

        BinaryExpressionNode::BinaryExpressionNode(Operator::Binary op, SyntaxNode * m1, SyntaxNode * m2)
            : op(op), member1(m1), member2(m2)
        {
            setNodeType(NodeType::Null);
        }

        void
        BinaryExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Binary expression [ " << Operator::BinaryStrings[op - 0x200] << " ] =>" << endl;
            member1->print(out, d + 1);
            member2->print(out, d + 1);
        }

        TernaryExpressionNode::TernaryExpressionNode(Operator::Ternary op, SyntaxNode *m1, SyntaxNode *m2, SyntaxNode *m3)
            : op(op), member1(m1), member2(m2), member3(m3)
        {
            setNodeType(NodeType::Null);
        }

        void
        TernaryExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Ternary expression [ " << Operator::TernaryStrings[op - 0x300] << " ] =>" << endl;
            member1->print(out, d + 1);
            member2->print(out, d + 1);
            member3->print(out, d + 1);
        }

        NewExpressionNode::NewExpressionNode(SyntaxNode * t)
            : type(t), init(NULL)
        {
            setNodeType(NodeType::Null);
        }

        NewExpressionNode::NewExpressionNode(SyntaxNode * t, SyntaxNode * i)
            : type(t), init(i)
        {
            setNodeType(NodeType::Null);
        }

        void
        NewExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "New expression for type " << endl;
            type->print(out, d + 1);
            if (init)
            {
                TAB(d) << "initializing with" << endl;
                init->print(out, d + 1);
            }
        }

        NewArrayExpressionNode::NewArrayExpressionNode(SyntaxNode * t)
            : type(t), dim(NULL), init(NULL)
        {
            setNodeType(NodeType::Null);
        }

        void
        NewArrayExpressionNode::setDim(SyntaxNode * d)
        {
            dim = d;
        }

        void
        NewArrayExpressionNode::setInit(SyntaxNode * i)
        {
            init = i;
        }

        void
        NewArrayExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "New array of type" << endl;
            type->print(out, d + 1);
            if (dim)
            {
                TAB(d + 1) << "with dimension" << endl;
                dim->print(out, d + 2);
            }
            if (init)
            {
                TAB(d + 1) << "with initial value" << endl;
                init->print(out, d + 2);
            }
        }

        CallExpressionNode::CallExpressionNode(SyntaxNode * n)
            : callee(n), args(NULL)
        {
            setNodeType(NodeType::Null);
        }

        CallExpressionNode::CallExpressionNode(SyntaxNode * n, VectorNode * a)
            : callee(n), args(a)
        {
            setNodeType(NodeType::Null);
        }

        void
        CallExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Function call for =>" << endl;
            callee->print(out, d + 1);
            if(args) {
                TAB(d + 1) << "with arguments (" << endl;
                for (auto arg = args->begin(); arg < args->end(); arg++) {
                    (*arg)->print(out, d + 2);
                    if(arg != args->end() - 1) TAB(d + 2) << ", " << endl;
                }
                TAB(d) << ")" << endl;
            } else
                TAB(d + 1) << "without arguments" << endl;
        }

        LambdaExpressionNode::LambdaExpressionNode(VectorNode * a, SyntaxNode * e)
            : lambdaArguments(a), lambdaExpression(e) { }

        void
        LambdaExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Lambda expression ";
            if(lambdaArguments->size() > 0) {
                out << "with arguments(" << endl;
                for (auto arg = lambdaArguments->begin(); arg < lambdaArguments->end(); arg++) {
                    (*arg)->print(out, d + 1);
                    if(arg != lambdaArguments->end() - 1) TAB(d + 2) << ", " << endl;
                }
                TAB(d) << ") ";
            }
            out << "using expression =>" << endl;
            lambdaExpression->print(out, d + 1);
        }

        ControlExpressionNode::ControlExpressionNode(ControlType::Type t)
            : controlType(t), controlExpression(NULL)
        {
            setNodeType(NodeType::Null);
        }

        ControlExpressionNode::ControlExpressionNode(ControlType::Type t, SyntaxNode * e)
            : controlType(t), controlExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        ControlExpressionNode::print(ostream & out, unsigned d)
        {
            switch(controlType) {
            case ControlType::Break:
                TAB(d) << "Break statement" << endl;
                break;
            case ControlType::Return:
                if(controlExpression) {
                    TAB(d) << "Return statement with expression =>" << endl;
                    controlExpression->print(out, d + 1);
                } else {
                    TAB(d) << "Return statement" << endl;
                }
                break;
            case ControlType::Yield:
                if(controlExpression) {
                    TAB(d) << "Yield statement with expression =>" << endl;
                    controlExpression->print(out, d + 1);
                } else {
                    TAB(d) << "Yield statement" << endl;
                }
                break;
            }
        }

        AccessExpressionNode::AccessExpressionNode(AccessType::Type ty, SyntaxNode * w, SyntaxNode * e)
            : access(ty), which(w), expr(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        AccessExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Access to member" << endl;
            which->print(out, d + 1);
            TAB(d) << "With expression" << endl;
            expr->print(out, d + 1);
        }
    } // SyntaxTree
} // LANG_NAMESPACE
