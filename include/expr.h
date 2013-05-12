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
 * expr.h - Basic expressions
 *
 * Defines objects used to represent basic expressions
 *
 */

#ifndef LANG_EXPR_H
#define LANG_EXPR_H

#include "ast.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        /**
         * Represents an unary expression (only one operator)
         */
        class UnaryExpressionNode : public SyntaxNode
        {
        protected:
            Operator::Unary op;
            SyntaxNode * member1;
            VectorNode * vector1;
        public:
            UnaryExpressionNode(Operator::Unary, SyntaxNode *);
            UnaryExpressionNode(Operator::Unary, VectorNode *);
            virtual void print(ostream &, unsigned );
        };

        /**
         * Represents a binary expression (two operators)
         */
        class BinaryExpressionNode : public SyntaxNode
        {
        protected:
            Operator::Binary op;
            SyntaxNode * member1;
            SyntaxNode * member2;
        public:
            BinaryExpressionNode(Operator::Binary, SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a ternary expression (three operators)
         */
        class TernaryExpressionNode : public SyntaxNode
        {
        protected:
            Operator::Ternary op;
            SyntaxNode * member1;
            SyntaxNode * member2;
            SyntaxNode * member3;
        public:
            TernaryExpressionNode(Operator::Ternary, SyntaxNode *, SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a new expression
         */
        class NewExpressionNode : public SyntaxNode
        {
        protected:
            SyntaxNode * type;
            SyntaxNode * init;
        public:
            NewExpressionNode(SyntaxNode *);
            NewExpressionNode(SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a new array expression
         */
        class NewArrayExpressionNode : public SyntaxNode
        {
        protected:
            SyntaxNode * type;
            SyntaxNode * dim;
            SyntaxNode * init;
        public:
            NewArrayExpressionNode(SyntaxNode *);
            virtual void setDim(SyntaxNode *);
            virtual void setInit(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a function invocation expression
         */
        class CallExpressionNode : public SyntaxNode
        {
        protected:
            SyntaxNode * callee;
            VectorNode * args;
        public:
            CallExpressionNode(SyntaxNode *);
            CallExpressionNode(SyntaxNode *, VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a lambda expression
         */
        class LambdaExpressionNode : public SyntaxNode
        {
        protected:
            VectorNode * lambdaArguments;
            SyntaxNode * lambdaExpression;
        public:
            LambdaExpressionNode(VectorNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a control/interruption of execution
         */
        class ControlExpressionNode : public SyntaxNode
        {
        protected:
            ControlType::Type controlType;
            SyntaxNode * controlExpression;
        public:
            ControlExpressionNode(ControlType::Type);
            ControlExpressionNode(ControlType::Type, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a access expression
         */
        class AccessExpressionNode : public SyntaxNode
        {
        protected:
            AccessType::Type access;
            SyntaxNode * which;
            SyntaxNode * expr;
        public:
            AccessExpressionNode(AccessType::Type, SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
