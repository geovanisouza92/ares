
#ifndef ARES_STMT_H
#define ARES_STMT_H

#include "st.h"
#include "langconfig.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

    class StatementNode : public SyntaxNode {
    public:
        virtual void print_using(ostream &, unsigned, bool) = 0;
    };

    class IfStmtNode : public StatementNode {
    protected:
        SyntaxNode * if_stmt;
        VectorNode * then_stmt;
        VectorNode * elif_stmt;
        VectorNode * else_stmt;
    public:
        IfStmtNode(SyntaxNode *, VectorNode *);
        virtual IfStmtNode * set_elif(VectorNode *);
        virtual IfStmtNode * set_else(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class UnlessStmtNode : public StatementNode {
    protected:
        SyntaxNode * if_stmt;
        VectorNode * then_stmt;
        VectorNode * else_stmt;
    public:
        UnlessStmtNode(SyntaxNode *, VectorNode *);
        virtual UnlessStmtNode * set_else(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class CaseStmtNode : public StatementNode {
    protected:
        SyntaxNode * case_stmt;
        VectorNode * when_stmt;
        VectorNode * else_stmt;
    public:
        CaseStmtNode(SyntaxNode *);
        virtual CaseStmtNode * set_when(VectorNode *);
        virtual CaseStmtNode * set_else(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class WhenClauseNode : public StatementNode {
    protected:
        SyntaxNode * when;
        SyntaxNode * block;
    public:
        WhenClauseNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

DECLARE_ENUM_START(Loop,Operation)
    DECLARE_ENUM_MEMBER(Ascending)
    DECLARE_ENUM_MEMBER(Descending)
    DECLARE_ENUM_MEMBER(Iteration)
    DECLARE_ENUM_MEMBER(While)
    DECLARE_ENUM_MEMBER(Until)
DECLARE_ENUM_END

    class ForStmtNode : public StatementNode {
    protected:
        SyntaxNode * lhs;
        SyntaxNode * rhs;
        Loop::Operation op;
        SyntaxNode * block;
        SyntaxNode * step;
    public:
        ForStmtNode(SyntaxNode *, SyntaxNode *, Loop::Operation, SyntaxNode *);
        virtual ForStmtNode * set_step(SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class LoopStmtNode : public StatementNode {
    protected:
        SyntaxNode * expr;
        SyntaxNode * block;
        Loop::Operation op;
    public:
        LoopStmtNode(SyntaxNode *, SyntaxNode *, Loop::Operation);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

DECLARE_ENUM_START(AsyncType,Type)
    DECLARE_ENUM_MEMBER(Expression)
    DECLARE_ENUM_MEMBER(Statement)
DECLARE_ENUM_END

    class AsyncStmtNode : public StatementNode {
    protected:
        SyntaxNode * async_obj;
        AsyncType::Type type;
    public:
        AsyncStmtNode(SyntaxNode *, AsyncType::Type);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class RaiseStmtNode : public StatementNode {
    protected:
        SyntaxNode * expr;
    public:
        RaiseStmtNode(SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

DECLARE_ENUM_START(Control,Operation)
    DECLARE_ENUM_MEMBER(Break)
    DECLARE_ENUM_MEMBER(Exit)
    DECLARE_ENUM_MEMBER(Yield)
    DECLARE_ENUM_MEMBER(Private)
    DECLARE_ENUM_MEMBER(Protected)
    DECLARE_ENUM_MEMBER(Public)
DECLARE_ENUM_END

    class ControlStmtNode : public StatementNode {
    protected:
        Control::Operation op;
        SyntaxNode * expr;
    public:
        ControlStmtNode(Control::Operation, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class BlockStmtNode : public StatementNode {
    protected:
        VectorNode * require;
        VectorNode * ensure;
        VectorNode * stmts;
        VectorNode * rescue;
    public:
        BlockStmtNode( VectorNode *);
        virtual BlockStmtNode * set_require(VectorNode *);
        virtual BlockStmtNode * set_ensure(VectorNode *);
        virtual BlockStmtNode * set_rescue(VectorNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

    class ConditionNode : public StatementNode {
    protected:
        SyntaxNode * expr;
        SyntaxNode * raise;
    public:
        ConditionNode(SyntaxNode *, SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

DECLARE_ENUM_START(Inline,Operation)
    DECLARE_ENUM_MEMBER(Import)
    DECLARE_ENUM_MEMBER(Include)
DECLARE_ENUM_END

    class InlineNode : public StatementNode {
    protected:
        Inline::Operation op;
        VectorNode * items;
        SyntaxNode * ctx;
    public:
        InlineNode(Inline::Operation, VectorNode *, SyntaxNode * c = NULL);
        virtual void print_using(ostream &, unsigned, bool nl = true);
    };

} // SyntaxTree
} // LANG_NAMESPACE

#endif