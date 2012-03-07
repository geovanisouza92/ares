
#ifndef ARC_AST_H
#define ARC_AST_H

#include <string>
#include <vector>
#include <map>
#include <ostream>

#include "version.h"

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

    namespace Operation {
        enum Operator {
            None = -1,
            UnaryNot, // not ..
            UnaryAdd, // + ..
            UnarySub, // - ..
            BinaryMul, // .. * ..
            BinaryDiv, // .. / ..
            BinaryMod, // .. mod ..
            BinaryAdd, // .. + ..
            BinarySub, // .. - ..
            BinaryLet, // .. < ..
            BinaryLee, // .. <= ..
            BinaryGet, // .. > ..
            BinaryGee, // .. >= ..
            BinaryEql, // .. == ..
            BinaryNeq, // .. != ..
            BinaryMat, // .. =~ ..
            BinaryNma, // .. !~ ..
            BinaryAnd, // .. and ..
            BinaryOr, // .. or ..
            BinaryXor, // .. xor ..
            BinaryImplies, // .. implies ..
            TernaryBetween, // .. between .. and ..
            TernaryIif // .. ? .. : ..
        };
    }

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
