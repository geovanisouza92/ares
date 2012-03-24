
#ifndef LANG_ST_H
#define LANG_ST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

using namespace std;

#include "langconfig.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

DECLARE_ENUM_START(NodeType,Type)
    DECLARE_ENUM_MEMBER(Nil)
    DECLARE_ENUM_MEMBER(Identifier)
    DECLARE_ENUM_MEMBER(String)
    DECLARE_ENUM_MEMBER(Regex)
    DECLARE_ENUM_MEMBER(Float)
    DECLARE_ENUM_MEMBER(Integer)
    DECLARE_ENUM_MEMBER(Boolean)
    DECLARE_ENUM_MEMBER(Array)
    DECLARE_ENUM_MEMBER(HashPair)
    DECLARE_ENUM_MEMBER(Hash)
    DECLARE_ENUM_MEMBER(Expression)
DECLARE_ENUM_END

    class SyntaxNode {
    protected:
        NodeType::Type type;
    public:
        virtual ~SyntaxNode() { }
        virtual NodeType::Type get_type() { return type; }
        virtual void set_type(NodeType::Type t) { type = t; }
        virtual void print_using(ostream &, unsigned) = 0;
    };

    class VectorNode : public vector<SyntaxNode *> { };

    class Environment {
    protected:
        Environment * prev;
        VectorNode * stmts;
    public:
        Environment(Environment *);
        virtual Environment * clear();
        virtual Environment * put_stmt(SyntaxNode *);
        virtual Environment * put_stmts(VectorNode *);
        virtual void print_tree_using(ostream &);
    };

    class NilNode : public SyntaxNode {
    public:
        NilNode();
        virtual void print_using(ostream &, unsigned);
    };

    class IdentifierNode : public SyntaxNode {
    protected:
        string value;
    public:
        IdentifierNode(string);
        virtual void print_using(ostream &, unsigned);
    };

    class StringNode : public SyntaxNode {
    protected:
        string value;
    public:
        StringNode(string);
        virtual void append(string);
        virtual void print_using(ostream &, unsigned);
    };

    class RegexNode : public SyntaxNode {
    protected:
        string value;
    public:
        RegexNode(string);
        virtual void print_using(ostream &, unsigned);
    };

    class FloatNode : public SyntaxNode {
    protected:
        double value;
    public:
        FloatNode(double);
        virtual void print_using(ostream &, unsigned);        
    };

    class IntegerNode : public SyntaxNode {
    protected:
        int value;
    public:
        IntegerNode(int);
        virtual void print_using(ostream &, unsigned);
    };

    class BooleanNode : public SyntaxNode {
    protected:
        bool value;
    public:
        BooleanNode(bool);
        virtual void print_using(ostream &, unsigned);
    };

    class ArrayAccessNode : public SyntaxNode {
    protected:
        SyntaxNode * single;
        SyntaxNode * start;
        SyntaxNode * end;
    public:
        ArrayAccessNode(SyntaxNode *);
        ArrayAccessNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned);
    };

    class ArrayNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        ArrayNode();
        ArrayNode(VectorNode *);
        virtual void print_using(ostream &, unsigned);
    };

    class HashPairNode : public SyntaxNode {
    protected:
        SyntaxNode * key;
        SyntaxNode * value;
    public:
        HashPairNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned);
    };

    class HashNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        HashNode();
        HashNode(VectorNode *);
        virtual void print_using(ostream &, unsigned);
    };

#include "stmtop.h"

    class ExpressionNode : public SyntaxNode {
    public:
        // virtual ~ExpressionNode();
        virtual void print_using(ostream &, unsigned) = 0;
    };

    class UnaryExprNode : public ExpressionNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * member1;
    public:
        UnaryExprNode(Operation::Operator op, SyntaxNode * m1) : operation(op), member1(m1) { set_type(NodeType::Nil); }
        virtual void print_using(ostream &, unsigned);
    };

    class BinaryExprNode : public ExpressionNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * member1;
        SyntaxNode * member2;
    public:
        BinaryExprNode(Operation::Operator op, SyntaxNode * m1, SyntaxNode * m2) : operation(op), member1(m1), member2(m2) { set_type(NodeType::Nil); }
        virtual void print_using(ostream &, unsigned);
    };

    class TernaryExprNode : public ExpressionNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * member1;
        SyntaxNode * member2;
        SyntaxNode * member3;
    public:
        TernaryExprNode(Operation::Operator op, SyntaxNode * m1, SyntaxNode * m2, SyntaxNode * m3) : operation(op), member1(m1), member2(m2), member3(m3) { set_type(NodeType::Nil); }
        virtual void print_using(ostream &, unsigned);
    };

    class FunctionCallNode : public SyntaxNode {
    protected:
        SyntaxNode * name;
        VectorNode * args;
    public:
        FunctionCallNode(SyntaxNode *);
        FunctionCallNode(SyntaxNode *, VectorNode *);
        virtual void print_using(ostream &, unsigned);
    };

} // SyntaxTree
} // LANG_NAMESPACE

#endif
