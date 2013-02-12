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
 * oql.h - Object Query Laguage
 *
 * Declares objects used to represent OQL expression
 *
 */

#ifndef LANG_OQL_H
#define LANG_OQL_H

#include "ast.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
    	/**
    	 * Represents a generic OQL expression node
    	 */
        class QueryNode: public SyntaxNode
        {
        protected:
            SyntaxNode * queryOrigin;
            SyntaxNode * queryBody;
        public:
            QueryNode(SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents the origin source part of OQL expression
         */
        class QueryOriginNode: public SyntaxNode
        {
        protected:
            SyntaxNode * originIdentifier;
            SyntaxNode * originExpression;
        public:
            QueryOriginNode(SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents the body of OQL expression
         */
        class QueryBodyNode: public SyntaxNode
        {
        protected:
            VectorNode * queryBody;
            SyntaxNode * queryFinally;
        public:
            QueryBodyNode();
            virtual QueryBodyNode * set_body(VectorNode *);
            virtual QueryBodyNode * set_finally(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents the where condition clause of OQL expression
         */
        class WhereNode: public SyntaxNode
        {
        protected:
            SyntaxNode * whereExpression;
        public:
            WhereNode(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a join clause of OQL expression
         */
        class JoinNode: public SyntaxNode
        {
        protected:
            JoinType::Type joinDirection;
            SyntaxNode * joinOrigin;
            SyntaxNode * joinExpression;
        public:
            JoinNode(JoinType::Type, SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents the ordering clause of OQL expression
         */
        class OrderingNode: public SyntaxNode
        {
        public:
            OrderType::Type orderType;
            SyntaxNode * orderExpression;
        public:
            OrderingNode(OrderType::Type, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a order condition of OQL expression
         */
        class OrderByNode: public SyntaxNode
        {
        protected:
            VectorNode * orders;
        public:
            OrderByNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a group clause of OQL expression
         */
        class GroupByNode: public SyntaxNode
        {
        protected:
            SyntaxNode * groupExpression;
        public:
            GroupByNode(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a range selection of select OQL expression
         */
        class RangeNode: public SyntaxNode
        {
        protected:
            RangeType::Type rangeType;
            SyntaxNode * rangeRange;
        public:
            RangeNode(RangeType::Type, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a select clause of OQL expression
         */
        class SelectNode: public SyntaxNode
        {
        protected:
            VectorNode * selection;
        public:
            SelectNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
