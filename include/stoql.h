/* Ares Programming Language */

#ifndef LANG_STOQL_H
#define LANG_STOQL_H

#include "st.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        class QueryNode: public SyntaxNode
        {
        protected:
            SyntaxNode * queryOrigin;
            SyntaxNode * queryBody;
        public:
            QueryNode (SyntaxNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class QueryOriginNode: public SyntaxNode
        {
        protected:
            SyntaxNode * originIdentifier;
            SyntaxNode * originExpression;
        public:
            QueryOriginNode (SyntaxNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class QueryBodyNode: public SyntaxNode
        {
        protected:
            VectorNode * queryBody;
            SyntaxNode * queryFinally;
        public:
            QueryBodyNode ();
            virtual QueryBodyNode * set_body (VectorNode *);
            virtual QueryBodyNode * set_finally (SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class WhereNode: public SyntaxNode
        {
        protected:
            SyntaxNode * whereExpression;
        public:
            WhereNode (SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class JoinNode: public SyntaxNode
        {
        protected:
            JoinType::Type joinDirection;
            SyntaxNode * joinOrigin;
            SyntaxNode * joinExpression;
        public:
            JoinNode (JoinType::Type, SyntaxNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class OrderingNode: public SyntaxNode
        {
        public:
            OrderType::Type orderType;
            SyntaxNode * orderExpression;
        public:
            OrderingNode (OrderType::Type, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class OrderByNode: public SyntaxNode
        {
        protected:
            VectorNode * orders;
        public:
            OrderByNode (VectorNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class GroupByNode: public SyntaxNode
        {
        protected:
            SyntaxNode * groupExpression;
        public:
            GroupByNode (SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class RangeNode: public SyntaxNode
        {
        protected:
            RangeType::Type rangeType;
            SyntaxNode * rangeRange;
        public:
            RangeNode (RangeType::Type, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class SelectNode: public SyntaxNode
        {
        protected:
            VectorNode * selection;
        public:
            SelectNode (VectorNode *);
            virtual void printUsing (ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
