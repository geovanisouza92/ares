
#ifndef ARC_AST_H
#define ARC_AST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

#include "version.h"
#include "console.h"

using namespace std;

namespace LANG_NAMESPACE {
namespace AST {

    class SyntaxNode {
    public:
        virtual ~SyntaxNode() { }
        virtual void print_using(ostream&, unsigned) = 0;
        static inline string indent(unsigned count) { return string(count * 2, ' '); }
        // virtual llvm::Value * genCode() = 0;
    };

    class VectorNode : public vector<SyntaxNode *> { };

    class IdentifierNode : public SyntaxNode {
    protected:
        string value;
        VectorNode * accessing;
    public:
        IdentifierNode(const string & v) : value(v) { accessing = new VectorNode(); }
        virtual SyntaxNode * add_access(SyntaxNode * m) { accessing->push_back(m); return this; }
        // virtual string flatten() = 0;
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class FloatNode : public SyntaxNode {
    protected:
        double value;
    public:
        FloatNode(const double v) : value(v) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class IntegerNode : public SyntaxNode {
    protected:
        int value;
    public:
        IntegerNode(const int v) : value(v) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class StringNode : public SyntaxNode {
    protected:
        string value;
    public:
        StringNode(const string & v) : value(v) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class RegexNode : public SyntaxNode {
    protected:
        string value;
    public:
        RegexNode(const string & v) : value(v) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class BooleanNode : public SyntaxNode {
    protected:
        bool value;
    public:
        BooleanNode(const bool v) : value(v) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class ArrayNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        ArrayNode() { }
        ArrayNode(VectorNode * v) : value(v) { }
        SyntaxNode * add(SyntaxNode * v) { value->push_back(v); return this; }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class HashItemNode : public SyntaxNode {
    protected:
        SyntaxNode * key;
        SyntaxNode * value;
    public:
        HashItemNode() { }
        HashItemNode(SyntaxNode * k, SyntaxNode * v) : key(k), value(v) { }
        virtual SyntaxNode * get_key() { return key; }
        virtual SyntaxNode * get_value() { return value; }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class HashNode : public SyntaxNode {
    protected:
        VectorNode * value;
    public:
        HashNode() { }
        HashNode(VectorNode * v) : value(v) { }
        SyntaxNode * add(HashItemNode * v) { value->push_back(v); return this; }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class FunctionCallNode : public SyntaxNode {
    protected:
        IdentifierNode * name;
        VectorNode * real_args;
    public:
        FunctionCallNode(IdentifierNode * n) : name(n) { }
        virtual SyntaxNode * add_args(VectorNode * ra) { real_args = ra; return this; }
    public:
        virtual void print_using(ostream&, unsigned);
    };

DECLARE_ENUM_START(Operation,Operator)
    DECLARE_ENUM_MEMBER(UnaryNot)
    DECLARE_ENUM_MEMBER(UnaryAdd)
    DECLARE_ENUM_MEMBER(UnarySub)
    DECLARE_ENUM_MEMBER(BinaryMul)
    DECLARE_ENUM_MEMBER(BinaryDiv)
    DECLARE_ENUM_MEMBER(BinaryMod)
    DECLARE_ENUM_MEMBER(BinaryAdd)
    DECLARE_ENUM_MEMBER(BinarySub)
    DECLARE_ENUM_MEMBER(BinaryLet)
    DECLARE_ENUM_MEMBER(BinaryLee)
    DECLARE_ENUM_MEMBER(BinaryGet)
    DECLARE_ENUM_MEMBER(BinaryGee)
    DECLARE_ENUM_MEMBER(BinaryEql)
    DECLARE_ENUM_MEMBER(BinaryNeq)
    DECLARE_ENUM_MEMBER(BinaryMat)
    DECLARE_ENUM_MEMBER(BinaryNma)
    DECLARE_ENUM_MEMBER(BinaryAnd)
    DECLARE_ENUM_MEMBER(BinaryOr)
    DECLARE_ENUM_MEMBER(BinaryXor)
    DECLARE_ENUM_MEMBER(BinaryImplies)
    DECLARE_ENUM_MEMBER(TernaryBetween)
    DECLARE_ENUM_MEMBER(TernaryIif)
DECLARE_ENUM_END
DECLARE_ENUM_NAMES_START(Operation)
    DECLARE_ENUM_MEMBER_NAME("UnaryNot")
    DECLARE_ENUM_MEMBER_NAME("UnaryAdd")
    DECLARE_ENUM_MEMBER_NAME("UnarySub")
    DECLARE_ENUM_MEMBER_NAME("BinaryMul")
    DECLARE_ENUM_MEMBER_NAME("BinaryDiv")
    DECLARE_ENUM_MEMBER_NAME("BinaryMod")
    DECLARE_ENUM_MEMBER_NAME("BinaryAdd")
    DECLARE_ENUM_MEMBER_NAME("BinarySub")
    DECLARE_ENUM_MEMBER_NAME("BinaryLet")
    DECLARE_ENUM_MEMBER_NAME("BinaryLee")
    DECLARE_ENUM_MEMBER_NAME("BinaryGet")
    DECLARE_ENUM_MEMBER_NAME("BinaryGee")
    DECLARE_ENUM_MEMBER_NAME("BinaryEql")
    DECLARE_ENUM_MEMBER_NAME("BinaryNeq")
    DECLARE_ENUM_MEMBER_NAME("BinaryMat")
    DECLARE_ENUM_MEMBER_NAME("BinaryNma")
    DECLARE_ENUM_MEMBER_NAME("BinaryAnd")
    DECLARE_ENUM_MEMBER_NAME("BinaryOr")
    DECLARE_ENUM_MEMBER_NAME("BinaryXor")
    DECLARE_ENUM_MEMBER_NAME("BinaryImplies")
    DECLARE_ENUM_MEMBER_NAME("TernaryBetween")
    DECLARE_ENUM_MEMBER_NAME("TernaryIif")
DECLARE_ENUM_NAMES_END(Operator)

    class UnaryExprNode : public SyntaxNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * expr;
    public:
        UnaryExprNode(Operation::Operator op, SyntaxNode * e) : operation(op), expr(e) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class BinaryExprNode : public SyntaxNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * lhs;
        SyntaxNode * rhs;
    public:
        BinaryExprNode(Operation::Operator op, SyntaxNode * l, SyntaxNode * r) : operation(op), lhs(l), rhs(r) {}
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class TernaryExprNode : public SyntaxNode {
    protected:
        Operation::Operator operation;
        SyntaxNode * alt1;
        SyntaxNode * alt2;
        SyntaxNode * alt3;
    public:
        TernaryExprNode(Operation::Operator op, SyntaxNode * a1, SyntaxNode * a2, SyntaxNode * a3) : operation(op), alt1(a1), alt2(a2), alt3(a3) { }
    public:
        virtual void print_using(ostream&, unsigned);
    };

    class Environment {
    protected:
        map<string, SyntaxNode *> * table;
        VectorNode * stmts;
        Environment * prev;
    public:
        Environment(Environment * p) : prev(p) { table = new map<string, SyntaxNode *>(); stmts = new VectorNode(); }
        virtual void add_stmts(VectorNode * s) { stmts = s; }
        virtual SyntaxNode * get(string & k);
        virtual Environment * put(string & k, SyntaxNode * v) { table->insert(pair<string, SyntaxNode *>(k, v)); return this; }
    public:
        virtual void print_tree_using(ostream&);
    };

} // AST
} // LANG_NAMESPACE

#endif
