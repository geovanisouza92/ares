
#ifndef ARC_STOQL_H
#define ARC_STOQL_H

#include "st.h"
#include "version.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

    class QueryNode : public ExpressionNode {
    protected:
        SyntaxNode * origin;
        SyntaxNode * body;
    public:
        QueryNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
        virtual void evaluate();
    };

    class QueryOriginNode : public SyntaxNode {
    protected:
        SyntaxNode * id;
        SyntaxNode * expr;
    public:
        QueryOriginNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class QueryBodyNode : public SyntaxNode {
    protected:
        SyntaxNode * finally;
        VectorNode * body;
    public:
        QueryBodyNode(SyntaxNode *);
        virtual void set_body(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class WhereNode : public SyntaxNode {
    protected:
        SyntaxNode * expr;
    public:
        WhereNode(SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

DECLARE_ENUM_START(JoinDirection,Direction)
    DECLARE_ENUM_MEMBER(None)
    DECLARE_ENUM_MEMBER(Left)
    DECLARE_ENUM_MEMBER(Right)
DECLARE_ENUM_END

    class JoinNode : public SyntaxNode {
    protected:
        JoinDirection::Direction direction;
        SyntaxNode * origin;
        SyntaxNode * expr;
    public:
        JoinNode(SyntaxNode *, SyntaxNode *, JoinDirection::Direction);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

DECLARE_ENUM_START(OrderDirection,Direction)
    DECLARE_ENUM_MEMBER(None)
    DECLARE_ENUM_MEMBER(Asc)
    DECLARE_ENUM_MEMBER(Desc)
DECLARE_ENUM_END

    class OrderingNode : public SyntaxNode {
    public:
        SyntaxNode * expr;
        OrderDirection::Direction direction;
    public:
        OrderingNode(SyntaxNode *, OrderDirection::Direction);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class OrderByNode : public SyntaxNode {
    protected:
        VectorNode * OrderingNodes;
    public:
        OrderByNode(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class GroupByNode : public SyntaxNode {
    protected:
        SyntaxNode * expr;
    public:
        GroupByNode(SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class RangeNode : public SyntaxNode {
    protected:
        SyntaxNode * skip;
        SyntaxNode * step;
        SyntaxNode * take;
    public:
        RangeNode();
        virtual RangeNode * set_skip(SyntaxNode *);
        virtual RangeNode * set_step(SyntaxNode *);
        virtual RangeNode * set_take(SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class SelectNode : public SyntaxNode {
    protected:
        VectorNode * selection;
        SyntaxNode * range;
    public:
        SelectNode(VectorNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

} // SyntaxTree
} // LANG_NAMESPACE

#endif
