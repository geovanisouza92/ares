
#ifndef ARES_ST_H
#define ARES_ST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

using namespace std;

#include "langconfig.h"
#include "console.h"

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
        virtual void print_using(ostream &, unsigned, bool nl = true) = 0;
    };

    class VectorNode : public vector<SyntaxNode *> { };

    class Environment {
    protected:
        Environment * prev;
        VectorNode * cmds;
    public:
        Environment(Environment *);
        virtual Environment * clear();
        virtual Environment * put_cmd(SyntaxNode *);
        virtual Environment * put_cmds(VectorNode *);
        virtual void print_tree_using(ostream &);
    };

    class IdentifierNode : public SyntaxNode {
    protected:
        string value;
    public:
        IdentifierNode(string);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class StringNode : public SyntaxNode {
    protected:
        string value;
    public:
        StringNode(string);
        virtual void append(string);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class RegexNode : public SyntaxNode {
    protected:
        string value;
    public:
        RegexNode(string);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class FloatNode : public SyntaxNode {
    protected:
        double value;
    public:
        FloatNode(double);
        virtual void print_using(ostream &, unsigned, bool);        
    };

    class IntegerNode : public SyntaxNode {
    protected:
        int value;
    public:
        IntegerNode(int);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class BooleanNode : public SyntaxNode {
    protected:
        bool value;
    public:
        BooleanNode(bool);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class ArrayAccessNode : public SyntaxNode {
    protected:
        SyntaxNode * single;
        SyntaxNode * start;
        SyntaxNode * end;
    public:
        ArrayAccessNode(SyntaxNode *);
        ArrayAccessNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class ArrayNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        ArrayNode();
        ArrayNode(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class HashPairNode : public SyntaxNode {
    protected:
        SyntaxNode * key;
        SyntaxNode * value;
    public:
        HashPairNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool);
    };

    class HashNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        HashNode();
        HashNode(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool);
    };

DECLARE_ENUM_START(Operation,Operator)
    DECLARE_ENUM_MEMBER(UnaryNew)
    DECLARE_ENUM_MEMBER(UnaryNot)
    DECLARE_ENUM_MEMBER(UnaryAdd)
    DECLARE_ENUM_MEMBER(UnarySub)
    DECLARE_ENUM_MEMBER(BinaryCast)
    DECLARE_ENUM_MEMBER(BinaryMul)
    DECLARE_ENUM_MEMBER(BinaryDiv)
    DECLARE_ENUM_MEMBER(BinaryMod)
    DECLARE_ENUM_MEMBER(BinaryPow)
    DECLARE_ENUM_MEMBER(BinaryAdd)
    DECLARE_ENUM_MEMBER(BinarySub)
    DECLARE_ENUM_MEMBER(BinaryShl)
    DECLARE_ENUM_MEMBER(BinaryShr)
    DECLARE_ENUM_MEMBER(BinaryBAnd)
    DECLARE_ENUM_MEMBER(BinaryBOr)
    DECLARE_ENUM_MEMBER(BinaryBXor)
    DECLARE_ENUM_MEMBER(BinaryLet)
    DECLARE_ENUM_MEMBER(BinaryLee)
    DECLARE_ENUM_MEMBER(BinaryGet)
    DECLARE_ENUM_MEMBER(BinaryGee)
    DECLARE_ENUM_MEMBER(BinaryEql)
    DECLARE_ENUM_MEMBER(BinaryNeq)
    DECLARE_ENUM_MEMBER(BinaryIde)
    DECLARE_ENUM_MEMBER(BinaryCmp)
    DECLARE_ENUM_MEMBER(BinaryMat)
    DECLARE_ENUM_MEMBER(BinaryNma)
    DECLARE_ENUM_MEMBER(BinaryIs)
    DECLARE_ENUM_MEMBER(BinaryIn)
    DECLARE_ENUM_MEMBER(BinaryHas)
    DECLARE_ENUM_MEMBER(BinaryDot2)
    DECLARE_ENUM_MEMBER(BinaryDot3)
    DECLARE_ENUM_MEMBER(BinaryLAnd)
    DECLARE_ENUM_MEMBER(BinaryLOr)
    DECLARE_ENUM_MEMBER(BinaryLImplies)
    DECLARE_ENUM_MEMBER(BinaryAccess)
    DECLARE_ENUM_MEMBER(BinaryAssign)
    DECLARE_ENUM_MEMBER(BinaryAde)
    DECLARE_ENUM_MEMBER(BinarySue)
    DECLARE_ENUM_MEMBER(BinaryMue)
    DECLARE_ENUM_MEMBER(BinaryDie)
    DECLARE_ENUM_MEMBER(TernaryIf)
    DECLARE_ENUM_MEMBER(TernaryBetween)
DECLARE_ENUM_END
DECLARE_ENUM_NAMES_START(Operation)
    DECLARE_ENUM_MEMBER_NAME("UnaryNew")
    DECLARE_ENUM_MEMBER_NAME("UnaryNot")
    DECLARE_ENUM_MEMBER_NAME("UnaryAdd")
    DECLARE_ENUM_MEMBER_NAME("UnarySub")
    DECLARE_ENUM_MEMBER_NAME("BinaryCast")
    DECLARE_ENUM_MEMBER_NAME("BinaryMul")
    DECLARE_ENUM_MEMBER_NAME("BinaryDiv")
    DECLARE_ENUM_MEMBER_NAME("BinaryMod")
    DECLARE_ENUM_MEMBER_NAME("BinaryPow")
    DECLARE_ENUM_MEMBER_NAME("BinaryAdd")
    DECLARE_ENUM_MEMBER_NAME("BinarySub")
    DECLARE_ENUM_MEMBER_NAME("BinaryShl")
    DECLARE_ENUM_MEMBER_NAME("BinaryShr")
    DECLARE_ENUM_MEMBER_NAME("BinaryBAnd")
    DECLARE_ENUM_MEMBER_NAME("BinaryBOr")
    DECLARE_ENUM_MEMBER_NAME("BinaryBXor")
    DECLARE_ENUM_MEMBER_NAME("BinaryLet")
    DECLARE_ENUM_MEMBER_NAME("BinaryLee")
    DECLARE_ENUM_MEMBER_NAME("BinaryGet")
    DECLARE_ENUM_MEMBER_NAME("BinaryGee")
    DECLARE_ENUM_MEMBER_NAME("BinaryEql")
    DECLARE_ENUM_MEMBER_NAME("BinaryNeq")
    DECLARE_ENUM_MEMBER_NAME("BinaryIde")
    DECLARE_ENUM_MEMBER_NAME("BinaryCmp")
    DECLARE_ENUM_MEMBER_NAME("BinaryMat")
    DECLARE_ENUM_MEMBER_NAME("BinaryNma")
    DECLARE_ENUM_MEMBER_NAME("BinaryIs")
    DECLARE_ENUM_MEMBER_NAME("BinaryIn")
    DECLARE_ENUM_MEMBER_NAME("BinaryHas")
    DECLARE_ENUM_MEMBER_NAME("BinaryDot2")
    DECLARE_ENUM_MEMBER_NAME("BinaryDot3")
    DECLARE_ENUM_MEMBER_NAME("BinaryLAnd")
    DECLARE_ENUM_MEMBER_NAME("BinaryLOr")
    DECLARE_ENUM_MEMBER_NAME("BinaryLImplies")
    DECLARE_ENUM_MEMBER_NAME("BinaryAccess")
    DECLARE_ENUM_MEMBER_NAME("BinaryAssign")
    DECLARE_ENUM_MEMBER_NAME("BinaryAde")
    DECLARE_ENUM_MEMBER_NAME("BinarySue")
    DECLARE_ENUM_MEMBER_NAME("BinaryMue")
    DECLARE_ENUM_MEMBER_NAME("BinaryDie")
    DECLARE_ENUM_MEMBER_NAME("TernaryIf")
    DECLARE_ENUM_MEMBER_NAME("TernaryBetween")
DECLARE_ENUM_NAMES_END(Operator)

    class ExpressionNode : public SyntaxNode {
    public:
        // virtual ~ExpressionNode();
        virtual void print_using(ostream &, unsigned, bool) = 0;
    };

    class UnaryExprNode : public ExpressionNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * member1;
    public:
        UnaryExprNode(Operation::Operator op, SyntaxNode * m1) : operation(op), member1(m1) { set_type(NodeType::Nil); }
        virtual void print_using(ostream &, unsigned, bool);
    };

    class BinaryExprNode : public ExpressionNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * member1;
        SyntaxNode * member2;
    public:
        BinaryExprNode(Operation::Operator op, SyntaxNode * m1, SyntaxNode * m2) : operation(op), member1(m1), member2(m2) { set_type(NodeType::Nil); }
        virtual void print_using(ostream &, unsigned, bool);
    };

    class TernaryExprNode : public ExpressionNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * member1;
        SyntaxNode * member2;
        SyntaxNode * member3;
    public:
        TernaryExprNode(Operation::Operator op, SyntaxNode * m1, SyntaxNode * m2, SyntaxNode * m3) : operation(op), member1(m1), member2(m2), member3(m3) { set_type(NodeType::Nil); }
        virtual void print_using(ostream &, unsigned, bool);
    };

    class FunctionCallNode : public SyntaxNode {
    protected:
        SyntaxNode * name;
        VectorNode * args;
    public:
        FunctionCallNode(SyntaxNode *);
        FunctionCallNode(SyntaxNode *, VectorNode *);
        virtual void print_using(ostream &, unsigned, bool);
    };

} // SyntaxTree
} // LANG_NAMESPACE

#endif
