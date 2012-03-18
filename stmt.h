
#ifndef ARES_STMT_H
#define ARES_STMT_H

#include "st.h"
#include "version.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

	class StatementNode : public SyntaxNode {
	public:
        virtual void print_using(ostream &, unsigned, bool) = 0;
        virtual void execute() = 0;
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
        virtual void execute();
	};

    class AsyncStmtNode : public StatementNode {
    protected:
        SyntaxNode * async_obj;
    public:
        AsyncStmtNode(SyntaxNode *);
        virtual void print_using(ostream &, unsigned, bool nl = true);
        virtual void execute();
    };

} // SyntaxTree
} // LANG_NAMESPACE

#endif