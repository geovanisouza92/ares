/* Ares Programming Language */

#ifndef LANG_ST_H
#define LANG_ST_H

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
        class SyntaxNode
        {
        protected:
            NodeType::Type nodeType;
        public:
            virtual ~SyntaxNode ();
            virtual NodeType::Type getNodeType ();
            virtual void setNodeType (NodeType::Type t);
            virtual void printUsing (ostream &, unsigned) = 0;
        };

        class VectorNode : public vector<SyntaxNode *> { };

        class Environment : public SyntaxNode
        {
        protected:
            Environment * parent;
            VectorNode * statements;
        public:
            Environment (Environment *);
            virtual ~Environment ();
            virtual Environment * clear ();
            virtual Environment * putStatements (VectorNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class NullNode : public SyntaxNode
        {
        public:
            NullNode ();
            virtual void printUsing (ostream &, unsigned);
        };

        class IdentifierNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            IdentifierNode (string);
            virtual void printUsing (ostream &, unsigned);
        };

        class CharNode : public SyntaxNode
        {
        protected:
            char value;
        public:
            CharNode (char);
            virtual void printUsing (ostream &, unsigned);
        };

        class StringNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            StringNode (string);
            virtual void append (string);
            virtual void printUsing (ostream &, unsigned);
        };

        class RegexNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            RegexNode (string);
            virtual void printUsing (ostream &, unsigned);
        };

        class FloatNode : public SyntaxNode
        {
        protected:
            double value;
        public:
            FloatNode (double);
            virtual void printUsing (ostream &, unsigned);
        };

        class IntegerNode : public SyntaxNode
        {
        protected:
            int value;
        public:
            IntegerNode (int);
            virtual void printUsing (ostream &, unsigned);
        };

        class BooleanNode : public SyntaxNode
        {
        protected:
            bool value;
        public:
            BooleanNode (bool);
            virtual void printUsing (ostream &, unsigned);
        };

        class ArrayNode : public SyntaxNode
        {
        protected:
            VectorNode * value;
        public:
            ArrayNode ();
            ArrayNode (VectorNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class KeyValuePairNode : public SyntaxNode
        {
        protected:
            SyntaxNode * key;
            SyntaxNode * value;
        public:
            KeyValuePairNode (SyntaxNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class HashNode : public SyntaxNode
        {
        protected:
            VectorNode * value;
        public:
            HashNode ();
            HashNode (VectorNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class UnaryExpressionNode : public SyntaxNode
        {
        protected:
            BasicOperator::Operator op;
            SyntaxNode * member1;
            VectorNode * vector1;
        public:
            UnaryExpressionNode (BasicOperator::Operator, SyntaxNode *);
            UnaryExpressionNode (BasicOperator::Operator, VectorNode *);
            virtual void printUsing (ostream &, unsigned );
        };

        class BinaryExpressionNode : public SyntaxNode
        {
        protected:
            BasicOperator::Operator op;
            SyntaxNode * member1;
            SyntaxNode * member2;
        public:
            BinaryExpressionNode (BasicOperator::Operator, SyntaxNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class TernaryExpressionNode : public SyntaxNode
        {
        protected:
            BasicOperator::Operator op;
            SyntaxNode * member1;
            SyntaxNode * member2;
            SyntaxNode * member3;
        public:
            TernaryExpressionNode (BasicOperator::Operator, SyntaxNode *, SyntaxNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class FunctionInvocationNode : public SyntaxNode
        {
        protected:
            SyntaxNode * functionName;
            VectorNode * functionArguments;
        public:
            FunctionInvocationNode (SyntaxNode *);
            FunctionInvocationNode (SyntaxNode *, VectorNode *);
            virtual void printUsing (ostream &, unsigned);
        };

        class LambdaExpressionNode : public SyntaxNode
        {
        protected:
            VectorNode * lambdaArguments;
            SyntaxNode * lambdaExpression;
        public:
            LambdaExpressionNode (VectorNode *, SyntaxNode *);
            virtual void printUsing (ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
