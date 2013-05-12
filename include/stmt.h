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
 * stmt.h - Statements
 *
 * Defines objects used to represent statements
 *
 */

#ifndef LANG_STMT_H
#define LANG_STMT_H

#include "ast.h"

using namespace LANG_NAMESPACE::Enum;

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        /**
         * Represents a try block statement
         */
        class TryStatementNode : public SyntaxNode
        {
        protected:
            SyntaxNode * tryBlock;
            VectorNode * tryCatch;
            SyntaxNode * tryFinally;
        public:
            TryStatementNode(SyntaxNode *);
            virtual void setCatch(VectorNode *);
            virtual void setFinally(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a catch block of try statement
         */
        class CatchStatementNode : public SyntaxNode
        {
        protected:
            SyntaxNode * catchingType;
            SyntaxNode * catchingId;
            SyntaxNode * catchingBlock;
        public:
            CatchStatementNode(SyntaxNode *);
            CatchStatementNode(SyntaxNode *, SyntaxNode *);
            CatchStatementNode(SyntaxNode *, SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a block os statements
         */
        class BlockNode : public SyntaxNode
        {
        protected:
            VectorNode * blockStatements;
        public:
            BlockNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a memory allocation element
         */
        class ElementNode : public SyntaxNode
        {
        protected:
            ElementType::Type type;
            SyntaxNode * name;
            SyntaxNode * init;
        public:
            ElementNode(ElementType::Type, SyntaxNode *, SyntaxNode * i = NULL);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a variable
         */
        class VariableDeclStatementNode : public SyntaxNode
        {
        protected:
            SyntaxNode * ty;
            VectorNode * variables;
        public:
            VariableDeclStatementNode(SyntaxNode *, VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a constant
         */
        class ConstantDeclStatementNode : public SyntaxNode
        {
        protected:
            SyntaxNode * ty;
            VectorNode * consts;
        public:
            ConstantDeclStatementNode(SyntaxNode *, VectorNode *);
            virtual void print(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
