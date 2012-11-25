/** Ares Programming Language
 *
 * oql.h - Object Query Laguage
 *
 * Declares objects used to represent OQL expression
 */

#ifndef LANG_STOQL_H
#define LANG_STOQL_H

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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
