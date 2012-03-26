/* Ares Programming Language */

#include "stmt.h"

namespace LANG_NAMESPACE {
namespace SyntaxTree {

ConditionStmtNode::ConditionStmtNode(Condition::Operation o, SyntaxNode * i,
		SyntaxNode * t) :
		op(o), cond_stmt(i), then_stmt(t), elif_stmt(0), else_stmt(0) {
}

ConditionStmtNode *
ConditionStmtNode::set_elif(VectorNode * e) {
	for (VectorNode::iterator elif = e->begin(); elif < e->end(); elif++)
		elif_stmt->push_back(*elif);
	return this;
}

ConditionStmtNode *
ConditionStmtNode::set_else(SyntaxNode * e) {
	else_stmt = e;
	return this;
}

void ConditionStmtNode::print_using(ostream & out, unsigned b) {
	// TODO
}

CaseStmtNode::CaseStmtNode(SyntaxNode * c) :
		case_stmt(c), when_stmt(new VectorNode()), else_stmt(0) {
}

CaseStmtNode *
CaseStmtNode::set_when(VectorNode * w) {
	if (w != 0)
		for (VectorNode::iterator when = w->begin(); when < w->end(); when++)
			when_stmt->push_back(*when);
	return this;
}

CaseStmtNode *
CaseStmtNode::set_else(SyntaxNode * e) {
	else_stmt = e;
	return this;
}

void CaseStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

WhenClauseNode::WhenClauseNode(SyntaxNode * w, SyntaxNode * b) :
		when(w), block(b) {
}

void WhenClauseNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ForStmtNode::ForStmtNode(SyntaxNode * l, SyntaxNode * r, Loop::Operation o,
		SyntaxNode * b) :
		lhs(l), rhs(r), op(o), block(b) {
}

ForStmtNode *
ForStmtNode::set_step(SyntaxNode * s) {
	step = s;
	return this;
}

void ForStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

LoopStmtNode::LoopStmtNode(SyntaxNode * e, SyntaxNode * b, Loop::Operation o) :
		expr(e), block(b), op(o) {
}

void LoopStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ControlStmtNode::ControlStmtNode(Control::Operation o) :
		op(o), expr(0) {
}

ControlStmtNode::ControlStmtNode(Control::Operation o, SyntaxNode * e) :
		op(o), expr(e) {
}

void ControlStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

BlockStmtNode::BlockStmtNode(VectorNode * s) :
		require(new VectorNode()), ensure(new VectorNode()), stmts(
				new VectorNode()), rescue(new VectorNode()) {
	if (s != 0)
		for (VectorNode::iterator stmt = s->begin(); stmt < s->end(); stmt++)
			stmts->push_back(*stmt);
}

BlockStmtNode *
BlockStmtNode::set_require(VectorNode * r) {
	for (VectorNode::iterator req = r->begin(); req < r->end(); req++)
		require->push_back(*req);
	return this;
}

BlockStmtNode *
BlockStmtNode::set_ensure(VectorNode * e) {
	for (VectorNode::iterator ens = e->begin(); ens < e->end(); ens++)
		ensure->push_back(*ens);
	return this;
}

BlockStmtNode *
BlockStmtNode::set_rescue(VectorNode * r) {
	for (VectorNode::iterator res = r->begin(); res < r->end(); res++)
		rescue->push_back(*res);
	return this;
}

void BlockStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ValidationNode::ValidationNode(SyntaxNode * e, SyntaxNode * r) :
		expr(e), raise(r) {
}

void ValidationNode::print_using(ostream & out, unsigned d) {
	// TODO
}

VarDeclNode::VarDeclNode(VectorNode * v) :
		vars(v) {
}

void VarDeclNode::print_using(ostream & out, unsigned d) {
	// TODO
}

VariableNode::VariableNode(SyntaxNode * n) :
		name(n) {
}

VariableNode *
VariableNode::set_type(SyntaxNode * t) {
	type = t;
	return this;
}

VariableNode *
VariableNode::set_initial_value(SyntaxNode * v) {
	initial_value = v;
	return this;
}

VariableNode *
VariableNode::set_invariants(SyntaxNode * i) {
	invariants = i;
	return this;
}

void VariableNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ConstDeclNode::ConstDeclNode(VectorNode * v) :
		consts(v) {
}

void ConstDeclNode::print_using(ostream & out, unsigned d) {
	// TODO
}

InterceptNode::InterceptNode(Intercept::Type t, VectorNode * i) :
		type(t), items(i) {
}

void InterceptNode::print_using(ostream & out, unsigned d) {
	// TODO
}

FunctionDeclNode::FunctionDeclNode(SyntaxNode * n, VectorNode * p) :
		name(n), params(p) {
}

FunctionDeclNode *
FunctionDeclNode::set_return(SyntaxNode * r) {
	return_type = r;
	return this;
}

FunctionDeclNode *
FunctionDeclNode::set_intercept(SyntaxNode * i) {
	intercept = i;
	return this;
}

FunctionDeclNode *
FunctionDeclNode::add_specifier(Specifier::Flag f) {
	specifiers.push_back(f);
	return this;
}

FunctionDeclNode *
FunctionDeclNode::add_stmt(SyntaxNode * s) {
	stmt = s;
	return this;
}

void FunctionDeclNode::print_using(ostream & out, unsigned d) {
	// TODO
}

EventDeclNode::EventDeclNode(SyntaxNode * n) :
		name(n) {
}

EventDeclNode *
EventDeclNode::set_intercept(SyntaxNode * i) {
	intercept = i;
	return this;
}

EventDeclNode *
EventDeclNode::set_initial_value(SyntaxNode * v) {
	initial_value = v;
	return this;
}

void EventDeclNode::print_using(ostream & out, unsigned d) {
	// TODO
}

AttrDeclNode::AttrDeclNode(SyntaxNode * n) :
		name(n) {
}

AttrDeclNode *
AttrDeclNode::set_return_type(SyntaxNode * r) {
	return_type = r;
	return this;
}

AttrDeclNode *
AttrDeclNode::set_initial_value(SyntaxNode * i) {
	initial_value = i;
	return this;
}

AttrDeclNode *
AttrDeclNode::set_getter(SyntaxNode * g) {
	getter = g;
	return this;
}

AttrDeclNode *
AttrDeclNode::set_setter(SyntaxNode * s) {
	setter = s;
	return this;
}

AttrDeclNode *
AttrDeclNode::set_invariants(SyntaxNode * i) {
	invariants = i;
	return this;
}

void AttrDeclNode::print_using(ostream & out, unsigned d) {
	// TODO
}

IncludeStmtNode::IncludeStmtNode(SyntaxNode * n) :
		name(n) {
}

void IncludeStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ClassDeclNode::ClassDeclNode(SyntaxNode * n) :
		name(n), stmts(new VectorNode()) {
}

ClassDeclNode *
ClassDeclNode::set_heritance(SyntaxNode * h) {
	heritance = h;
	return this;
}

ClassDeclNode *
ClassDeclNode::add_specifier(Specifier::Flag f) {
	specifiers.push_back(f);
	return this;
}

ClassDeclNode *
ClassDeclNode::add_stmts(VectorNode * s) {
	for (VectorNode::iterator stmt = s->begin(); stmt < s->end(); stmt++)
		stmts->push_back(*stmt);
	return this;
}

void ClassDeclNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ImportStmtNode::ImportStmtNode(VectorNode * m) :
		members(m) {
}

ImportStmtNode *
ImportStmtNode::set_origin(SyntaxNode * o) {
	origin = o;
	return this;
}

void ImportStmtNode::print_using(ostream & out, unsigned d) {
	// TODO
}

ModuleNode::ModuleNode(SyntaxNode * n) :
		name(n), stmts(new VectorNode()) {
}

ModuleNode *
ModuleNode::add_stmts(VectorNode * s) {
	for (VectorNode::iterator stmt = s->begin(); stmt < s->end(); stmt++)
		stmts->push_back(*stmt);
	return this;
}

void ModuleNode::print_using(ostream & out, unsigned d) {
	// TODO
}

} // SyntaxTree
} // LANG_NAMESPACE
