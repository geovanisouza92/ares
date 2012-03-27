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

void ConditionStmtNode::print_using(ostream & out, unsigned d) {
	TAB << "Condition =>" << endl;
	cond_stmt->print_using(out, d + 2);
	TAB << "Then =>" << endl;
	then_stmt->print_using(out, d + 2);
	if (elif_stmt->size() > 0) {
		for (VectorNode::iterator elif = elif_stmt->begin();
				elif < elif_stmt->end(); elif++) {
			TAB << "Elif =>" << endl;
			(*elif)->print_using(out, d + 2);
		}
	}
	if (else_stmt != 0) {
		TAB << "Else =>" << endl;
		else_stmt->print_using(out, d + 2);
	}
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
	TAB << "Case =>" << endl;
	case_stmt->print_using(out, d + 1);
	if (when_stmt->size() > 0) {
		for (VectorNode::iterator when = when_stmt->begin();
				when < when_stmt->end(); when++) {
//			TAB << "When =>" << endl;
			(*when)->print_using(out, d + 1);
		}
	}
	if (else_stmt != 0) {
		TAB << "Else =>" << endl;
		else_stmt->print_using(out, d + 1);
	}
}

WhenClauseNode::WhenClauseNode(SyntaxNode * w, SyntaxNode * b) :
		when(w), block(b) {
}

void WhenClauseNode::print_using(ostream & out, unsigned d) {
	TAB << "When =>" << endl;
	when->print_using(out, d + 1);
	TAB << "Block =>" << endl;
	block->print_using(out, d + 1);
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
	switch (op) {
	case Loop::Ascending:
		TAB << "Ascending expression from =>" << endl;
		break;
	case Loop::Descending:
		TAB << "Descending expression from =>" << endl;
		break;
	case Loop::Iteration:
		TAB << "Iteration expression from =>" << endl;
		break;
	}
	lhs->print_using(out, d + 1);
	TAB << "To =>" << endl;
	rhs->print_using(out, d + 1);
	if (step != 0) {
		TAB << "By step =>" << endl;
		step->print_using(out, d + 1);
	}
	TAB << "Block =>" << endl;
	block->print_using(out, d + 1);
}

LoopStmtNode::LoopStmtNode(SyntaxNode * e, SyntaxNode * b, Loop::Operation o) :
		expr(e), block(b), op(o) {
}

void LoopStmtNode::print_using(ostream & out, unsigned d) {
	switch (op) {
	case Loop::While:
		TAB << "While expressio =>" << endl;
		break;
	case Loop::Until:
		TAB << "Until expressio =>" << endl;
		break;
	}
	expr->print_using(out, d + 1);
	TAB << "Block =>" << endl;
	block->print_using(out, d + 1);
}

ControlStmtNode::ControlStmtNode(Control::Operation o) :
		op(o), expr(0) {
}

ControlStmtNode::ControlStmtNode(Control::Operation o, SyntaxNode * e) :
		op(o), expr(e) {
}

void ControlStmtNode::print_using(ostream & out, unsigned d) {
	switch (op) {
	case Control::Break:
		TAB << "Break statement" << endl;
		break;
	case Control::Continue:
		TAB << "Continue statement" << endl;
		break;
	case Control::Private:
		TAB << "Alter visibility of below items to PRIVATE" << endl;
		break;
	case Control::Protected:
		TAB << "Alter visibility of below items to PROTECTED" << endl;
		break;
	case Control::Public:
		TAB << "Alter visibility of below items to PUBLIC" << endl;
		break;
	case Control::Raise:
		if (expr != 0) {
			TAB << "Raise statement with expression =>" << endl;
			expr->print_using(out, d + 1);
		} else {
			TAB << "Raise statement" << endl;
		}
		break;
	case Control::Retry:
		TAB << "Retry statement" << endl;
		break;
	case Control::Return:
		if (expr != 0) {
			TAB << "Return statement with expression =>" << endl;
			expr->print_using(out, d + 1);
		} else {
			TAB << "Return statement" << endl;
		}
		break;
	case Control::Yield:
		if (expr != 0) {
			TAB << "Yield statement with expression =>" << endl;
			expr->print_using(out, d + 1);
		} else {
			TAB << "Yield statement" << endl;
		}
		break;
	}
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
	if (require != 0) {
		for (VectorNode::iterator req = require->begin(); req < require->end();
				req++) {
			TAB << "Require =>" << endl;
			(*req)->print_using(out, d + 1);
		}
	}
	for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end();
			stmt++) {
		(*stmt)->print_using(out, d + 1);
	}
	if (rescue != 0) {
		for (VectorNode::iterator res = rescue->begin(); res < rescue->end();
				res++) {
			TAB << "Rescue =>" << endl;
			(*res)->print_using(out, d + 1);
		}
	}
	if (ensure != 0) {
		for (VectorNode::iterator ens = ensure->begin(); ens < ensure->end();
				ens++) {
			TAB << "Ensure =>" << endl;
			(*ens)->print_using(out, d + 1);
		}
	}
}

ValidationNode::ValidationNode(SyntaxNode * e, SyntaxNode * r) :
		expr(e), raise(r) {
}

void ValidationNode::print_using(ostream & out, unsigned d) {
	TAB << "Validation require =>" << endl;
	expr->print_using(out, d + 1);
	if (raise != 0) {
		TAB << "Raising the exception" << endl;
		raise->print_using(out, d + 1);
	}
}

VarDeclNode::VarDeclNode(VectorNode * v) :
		vars(v) {
}

void VarDeclNode::print_using(ostream & out, unsigned d) {
	TAB << "Declare variables =>" << endl;
	for (VectorNode::iterator var = vars->begin(); var < vars->end(); var++)
		(*var)->print_using(out, d + 1);
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
	TAB << "Element named =>" << endl;
	name->print_using(out, d + 1);
	if (type != 0) {
		TAB << "Of type" << endl;
		type->print_using(out, d + 1);
	}
	if (initial_value != 0) {
		TAB << "With initial value =>" << endl;
		initial_value->print_using(out, d + 1);
	}
	if (invariants != 0) {
		TAB << "With invariants condition =>" << endl;
		invariants->print_using(out, d + 1);
	}
}

ConstDeclNode::ConstDeclNode(VectorNode * v) :
		consts(v) {
}

void ConstDeclNode::print_using(ostream & out, unsigned d) {
	TAB << "Declare constants =>" << endl;
	for (VectorNode::iterator cons = consts->begin(); cons < consts->end();
			cons++)
		(*cons)->print_using(out, d + 1);
}

InterceptNode::InterceptNode(Intercept::Type t, VectorNode * i) :
		type(t), items(i) {
}

void InterceptNode::print_using(ostream & out, unsigned d) {
	switch (type) {
	case Intercept::After:
		TAB << "Intercept after =>" << endl;
		break;
	case Intercept::Before:
		TAB << "Intercept before =>" << endl;
		break;
	case Intercept::Signal:
		TAB << "Intercept signals =>" << endl;
		break;
	}
	for (VectorNode::iterator item = items->begin(); item < items->end();
			item++) {
		(*item)->print_using(out, d + 1);
	}
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
	TAB << "Function named =>" << endl;
	name->print_using(out, d + 1);
	if (specifiers.size() > 0) {
		for (vector<Specifier::Flag>::iterator spec = specifiers.begin();
				spec < specifiers.end(); spec++)
			TAB << "With specifier => " << Specifier::get_enum_name(*spec)
					<< endl;
	}
	if (params->size() > 0) {
		TAB << "With parameters =>" << endl;
		for (VectorNode::iterator param = params->begin();
				param < params->end(); param++) {
			(*param)->print_using(out, d + 1);
		}
	} else
		TAB << "Without parameters" << endl;
	if (return_type != 0) {
		TAB << "With return type =>" << endl;
		return_type->print_using(out, d + 1);
	}
	if (intercept != 0)
		intercept->print_using(out, d + 1);
	if (stmt != 0) {
		TAB << "Block =>" << endl;
		stmt->print_using(out, d + 1);
	}
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
	TAB << "Event named =>" << endl;
	name->print_using(out, d + 1);
	if (intercept != 0)
		intercept->print_using(out, d + 1);
	if (initial_value != 0) {
		TAB << "With initial value =>" << endl;
		initial_value->print_using(out, d + 1);
	}
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
	TAB << "Attribute named =>" << endl;
	name->print_using(out, d + 1);
	if (return_type != 0) {
		TAB << "Of type =>" << endl;
		return_type->print_using(out, d + 1);
	}
	if (initial_value != 0) {
		TAB << "With initial value =>" << endl;
		initial_value->print_using(out, d + 1);
	}
	if (invariants != 0) {
		TAB << "With invariants condition =>" << endl;
		invariants->print_using(out, d + 1);
	}
	if (getter != 0) {
		TAB << "Getting with =>" << endl;
		getter->print_using(out, d + 1);
	}
	if (setter != 0) {
		TAB << "Getting with =>" << endl;
		setter->print_using(out, d + 1);
	}
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
	TAB << "Class named =>" << endl;
	name->print_using(out, d + 1);
	if (heritance != 0) {
		TAB << "Heritance of =>" << endl;
		heritance->print_using(out, d + 1);
	}
	if (specifiers.size() > 0) {
		for (vector<Specifier::Flag>::iterator spec = specifiers.begin();
				spec < specifiers.end(); spec++)
			TAB << "With specifier => " << Specifier::get_enum_name(*spec)
					<< endl;
	}
	if (stmts->size() > 0) {
		for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end();
				stmt++) {
			(*stmt)->print_using(out, d + 1);
		}
	}
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
	TAB << "Module named =>" << endl;
	name->print_using(out, d + 1);
	if (stmts->size() > 0) {
		for (VectorNode::iterator stmt = stmts->begin(); stmt < stmts->end();
				stmt++) {
			(*stmt)->print_using(out, d + 1);
		}
	}
}

} // SyntaxTree
} // LANG_NAMESPACE
