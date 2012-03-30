/* Ares Programming Language */

#ifndef LANG_ST_H
#define LANG_ST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

using namespace std;

#include "enum.h"

using namespace LANG_NAMESPACE::Enum;

#define ENVIRONMENT
#define TAB out << string(d * 2, ' ')

namespace LANG_NAMESPACE {
    namespace SyntaxTree {

    class SyntaxNode {
    protected:
        NodeType::Type nodeType;
    public:
        virtual ~SyntaxNode();
        virtual NodeType::Type getNodeType();
        virtual void setNodeType(NodeType::Type t);
        virtual void printUsing(ostream &, unsigned) = 0;
    };

    class VectorNode : public vector<SyntaxNode*> { };

    class Environment : public SyntaxNode {
    protected:
        Environment * previous;
        VectorNode * statements;
    public:
        Environment(Environment *);
        virtual ~Environment();
        virtual Environment * clear();
//        virtual Environment * putStatement(SyntaxNode*);
        virtual Environment * putStatements(VectorNode*);
        virtual void printUsing(ostream &, unsigned );
    };

    class NilNode : public SyntaxNode {
    public:
        NilNode();
        virtual void printUsing(ostream &, unsigned);
    };

    class IdentifierNode : public SyntaxNode {
    protected:
        string value;
    public:
        IdentifierNode(string);
        virtual void printUsing(ostream &, unsigned);
    };

    class StringNode : public SyntaxNode {
    protected:
        string value;
    public:
        StringNode(string);
        virtual void append(string);
        virtual void printUsing(ostream &, unsigned);
    };

    class RegexNode : public SyntaxNode {
    protected:
        string value;
    public:
        RegexNode(string);
        virtual void printUsing(ostream &, unsigned);
    };

    class FloatNode : public SyntaxNode {
    protected:
        double value;
    public:
        FloatNode(double);
        virtual void printUsing(ostream &, unsigned);
    };

    class IntegerNode : public SyntaxNode {
    protected:
        int value;
    public:
        IntegerNode(int);
        virtual void printUsing(ostream &, unsigned);
    };

    class BooleanNode : public SyntaxNode {
    protected:
        bool value;
    public:
        BooleanNode(bool);
        virtual void printUsing(ostream &, unsigned);
    };

    class ArrayNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        ArrayNode();
        ArrayNode(VectorNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class HashPairNode : public SyntaxNode {
    protected:
        SyntaxNode * pairKey;
        SyntaxNode * pairValue;
    public:
        HashPairNode(SyntaxNode *, SyntaxNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class HashNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        HashNode();
        HashNode(VectorNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class NewNode : public SyntaxNode {
    protected:
        NewType::Type newType;
        SyntaxNode * newInstanceOf;
        VectorNode * newAnonymousClass;
    public:
        NewNode(NewType::Type, SyntaxNode *);
        NewNode(NewType::Type, VectorNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class ExpressionNode : public SyntaxNode {
    public:
        virtual void printUsing(ostream &, unsigned) = 0;
    };

    class UnaryNode : public ExpressionNode {
    protected:
        BaseOperator::Operator op;
        SyntaxNode * member1;
        VectorNode * vector1;
    public:
        UnaryNode(BaseOperator::Operator, SyntaxNode *);
        UnaryNode(BaseOperator::Operator, VectorNode *);
        virtual void printUsing(ostream &, unsigned );
    };

    class BinaryNode : public ExpressionNode {
    protected:
        BaseOperator::Operator op;
        SyntaxNode * member1;
        SyntaxNode * member2;
    public:
        BinaryNode(BaseOperator::Operator, SyntaxNode *, SyntaxNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class TernaryNode : public ExpressionNode {
    protected:
        BaseOperator::Operator op;
        SyntaxNode *member1;
        SyntaxNode *member2;
        SyntaxNode *member3;
    public:
        TernaryNode(BaseOperator::Operator, SyntaxNode *, SyntaxNode *, SyntaxNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class FunctionCallNode : public SyntaxNode {
    protected:
        SyntaxNode * functionName;
        VectorNode * functionArguments;
    public:
        FunctionCallNode(SyntaxNode *);
        FunctionCallNode(SyntaxNode *, VectorNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class AsyncNode : public SyntaxNode {
    protected:
        AsyncType::Type asyncType;
        SyntaxNode * item;
    public:
        AsyncNode(AsyncType::Type, SyntaxNode *);
        virtual void printUsing(ostream &, unsigned);
    };

    class LambdaNode : public SyntaxNode {
    protected:
        VectorNode * lambdaArguments;
        SyntaxNode * lambdaExpression;
    public:
        LambdaNode(VectorNode *, SyntaxNode *);
        virtual void printUsing(ostream &, unsigned);
    };

} // SyntaxTree
} // LANG_NAMESPACE

#endif
