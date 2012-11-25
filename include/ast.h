/** Ares Programming Language
 *
 * ast.h - Abstract Syntax Tree
 *
 * Defines objects used to represent all AST nodes
 */

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
            virtual void toString(ostream &, unsigned) = 0;
            // virtual Value * genCode() = 0;
        };

        /**
         * Represents a node collection
         */
        class VectorNode : public vector<SyntaxNode *> { };

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
            virtual Environment * putStatements(VectorNode *);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a null literal
         */
        class NullNode : public SyntaxNode
        {
        public:
            NullNode();
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a integer literal number
         */
        class IntegerNode : public SyntaxNode
        {
        protected:
            int value;
        public:
            IntegerNode(int);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a floating-point literal number
         */
        class FloatNode : public SyntaxNode
        {
        protected:
            double value;
        public:
            FloatNode(double);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a character literal
         */
        class CharNode : public SyntaxNode
        {
        protected:
            char value;
        public:
            CharNode(char);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a string literal
         */
        class StringNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            StringNode(string);
            virtual void append(string);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a regular expression literal
         */
        class RegexNode : public SyntaxNode
        {
        protected:
            string value;
        public:
            RegexNode(string);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a boolean literal
         */
        class BooleanNode : public SyntaxNode
        {
        protected:
            bool value;
        public:
            BooleanNode(bool);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents an array (heterogeneous collection) literal
         */
        class ArrayNode : public SyntaxNode
        {
        protected:
            VectorNode * value;
        public:
            ArrayNode();
            ArrayNode(VectorNode *);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a key-value pair literal
         */
        class KeyValuePairNode : public SyntaxNode
        {
        protected:
            SyntaxNode * key;
            SyntaxNode * value;
        public:
            KeyValuePairNode(SyntaxNode *, SyntaxNode *);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a hash (heterogeneous key-value pairs collection) literal
         */
        class HashNode : public SyntaxNode
        {
        protected:
            VectorNode * value;
        public:
            HashNode();
            HashNode(VectorNode *);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents a pointer-type literal
         */
        class PointerNode : public SyntaxNode
        {
        protected:
            SyntaxNode * type;
        public:
            PointerNode(SyntaxNode *);
            virtual void toString(ostream &, unsigned);
        };

        /**
         * Represents an identifier literal
         */
        class IdentifierNode : public SyntaxNode
        {
        protected:
            string id;
        public:
            IdentifierNode(string);
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned );
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
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
            virtual void toString(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
