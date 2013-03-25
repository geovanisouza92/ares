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
 * ast.h - Abstract Syntax Tree
 *
 * Defines objects used to represent all AST nodes
 *
 */

#ifndef LANG_AST_H
#define LANG_AST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>
#include "enum.h"

using namespace std;
using namespace LANG_NAMESPACE::Enum;

#define TAB(x) out << string((x) * 2, ' ')

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
    	/**
    	 * Represents a base-of-all node in AST
    	 */
        class SyntaxNode
        {
        protected:
            NodeType::Type nodeType;
        public:
            virtual ~SyntaxNode();
            virtual NodeType::Type getNodeType();
            virtual void setNodeType(NodeType::Type t);
            virtual void print(ostream &, unsigned) = 0;
            // virtual Value * genCode() = 0;
        };

        /**
         * Represents a empty node that not to be included in code
         */
        class Empty : public SyntaxNode
        {
        public:
            Empty();
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a node collection
         */
        class VectorNode : public SyntaxNode, public vector<SyntaxNode *>
        {
        public:
            virtual void print(ostream &, unsigned);
        };

        class EmptyVector : public Empty, public VectorNode { };

        /**
         * Represents the environment to manage the AST
         */
        class Environment : public SyntaxNode
        {
        protected:
            Environment * parent;
            VectorNode * statements;
        public:
            Environment(Environment *);
            virtual ~Environment();
            virtual Environment * clear();
            virtual Environment * push(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a null literal
         */
        class NullLiteralNode : public SyntaxNode
        {
        public:
            NullLiteralNode();
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a integer literal number
         */
        class IntegerLiteralNode : public SyntaxNode
        {
        protected:
            int value;
        public:
            IntegerLiteralNode(int);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a floating-point literal number
         */
        class FloatLiteralNode : public SyntaxNode
        {
        protected:
            double value;
        public:
            FloatLiteralNode(double);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a character literal
         */
        class CharLiteralNode : public SyntaxNode
        {
        protected:
            char value;
        public:
            CharLiteralNode(char);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a string literal
         */
        class StringLiteralNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            StringLiteralNode(string);
            virtual void append(string);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a regular expression literal
         */
        class RegexLiteralNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            RegexLiteralNode(string);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a boolean literal
         */
        class BooleanLiteralNode : public SyntaxNode
        {
        protected:
            bool value;
        public:
            BooleanLiteralNode(bool);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents an array (heterogeneous collection) literal
         */
        class ArrayLiteralNode : public SyntaxNode
        {
        protected:
            VectorNode * value;
        public:
            ArrayLiteralNode();
            ArrayLiteralNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a key-value pair literal
         */
        class PairNode : public SyntaxNode
        {
        protected:
            SyntaxNode * key;
            SyntaxNode * value;
        public:
            PairNode(SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a hash (heterogeneous key-value pairs collection) literal
         */
        class HashLiteralNode : public SyntaxNode
        {
        protected:
            VectorNode * value;
        public:
            HashLiteralNode();
            HashLiteralNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents an identifier literal
         */
        class IdNode : public SyntaxNode
        {
        protected:
            string id;
        public:
            IdNode(string);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a pointer-type literal
         */
        class PointerTypeNode : public SyntaxNode
        {
        protected:
            SyntaxNode * type;
        public:
            PointerTypeNode(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * The type name
         */
        class ArrayTypeNode;
        class Type : public SyntaxNode
        {
        protected:
            string type;
            Type();
        public:
            Type(string);
            virtual void print(ostream &, unsigned);
            friend class ArrayTypeNode;
        };

        /**
         * Represents an array type
         */
        class ArrayTypeNode : public Type
        {
        protected:
            unsigned dimension;
        public:
            ArrayTypeNode(SyntaxNode *, unsigned);
            virtual void print(ostream &, unsigned);
        };

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
         * Represents a function invocation expression
         */
        class FunctionInvocationNode : public SyntaxNode
        {
        protected:
            SyntaxNode * functionName;
            VectorNode * functionArguments;
        public:
            FunctionInvocationNode(SyntaxNode *);
            FunctionInvocationNode(SyntaxNode *, VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a lambda-calculus expression
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
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
