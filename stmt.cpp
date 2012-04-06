/* Ares Programming Language */

#include "stmt.h"

namespace LANG_NAMESPACE {
    namespace SyntaxTree {

        ConditionNode::ConditionNode(ConditionType::Type o, SyntaxNode * i, SyntaxNode * t) : conditionOperator(o), conditionExpression(i), conditionThen(t), conditionElifs(new VectorNode()), conditionElse(NULL) { }

        ConditionNode *
        ConditionNode::setElif(VectorNode * e) {
            for (VectorNode::iterator elif = e->begin(); elif < e->end(); elif++)
                conditionElifs->push_back(*elif);
            return this;
        }

        ConditionNode *
        ConditionNode::setElse(SyntaxNode * e) {
            delete conditionElse;
            conditionElse = e;
            return this;
        }

        void ConditionNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Condition =>" << endl;
            conditionExpression->printUsing(out, d + 2);
            TAB(d + 1) << "Then =>" << endl;
            conditionThen->printUsing(out, d + 2);
            if (conditionElifs->size() > 0) {
                for (VectorNode::iterator elif = conditionElifs->begin(); elif < conditionElifs->end(); elif++) {
                	TAB(d + 1) << "Elif =>" << endl;
                    (*elif)->printUsing(out, d + 2);
                }
            }
            if (conditionElse != NULL) {
            	TAB(d + 1) << "Else =>" << endl;
                conditionElse->printUsing(out, d + 2);
            }
        }

        CaseNode::CaseNode(SyntaxNode * c) : caseExpression(c), caseWhen(new VectorNode()), caseElse(NULL) { }

        CaseNode *
        CaseNode::setWhen(VectorNode * w) {
            if (w != NULL) for (VectorNode::iterator when = w->begin(); when < w->end(); when++)
                caseWhen->push_back(*when);
            return this;
        }

        CaseNode *
        CaseNode::setElse(VectorNode * e) {
            delete caseElse;
            caseElse = e;
            return this;
        }

        void CaseNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Case =>" << endl;
            caseExpression->printUsing(out, d + 1);
            if (caseWhen->size() > 0) {
            	for (VectorNode::iterator when = caseWhen->begin(); when < caseWhen->end(); when++) {
                    (*when)->printUsing(out, d + 2);
                }
            }
            if (caseElse != NULL) {
                TAB(d + 1) << "Else =>" << endl;
                for (VectorNode::iterator Else = caseElse->begin(); Else < caseElse->end(); Else++) {
                    (*Else)->printUsing(out, d + 2);
                }
            }
        }

        WhenNode::WhenNode(SyntaxNode * e, SyntaxNode * b) : whenExpression(e), whenBlock(b) { }

        void WhenNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "When =>" << endl;
            whenExpression->printUsing(out, d + 1);
            TAB(d + 1) << "Block =>" << endl;
            whenBlock->printUsing(out, d + 2);
        }

        ForNode::ForNode(LoopType::Type t, SyntaxNode * l, SyntaxNode * r, SyntaxNode * b) : forType(t), forLhs(l), forRhs(r), forBlock(b), forStep(NULL) { }

        ForNode *
        ForNode::setStep(SyntaxNode * s) {
            delete forStep;
            forStep = s;
            return this;
        }

        void ForNode::printUsing(ostream & out, unsigned d) {
            switch (forType) {
            case LoopType::ForAscending:
                TAB(d) << "Ascending expression from =>" << endl;
                break;
            case LoopType::ForDescending:
                TAB(d) << "Descending expression from =>" << endl;
                break;
            case LoopType::ForIteration:
                TAB(d) << "Iteration expression from =>" << endl;
                break;
            }
            forLhs->printUsing(out, d + 1);
            TAB(d) << "To =>" << endl;
            forRhs->printUsing(out, d + 1);
            if (forStep != NULL) {
                TAB(d) << "By step =>" << endl;
                forStep->printUsing(out, d + 1);
            }
            TAB(d + 1) << "Block =>" << endl;
            forBlock->printUsing(out, d + 2);
        }

        LoopNode::LoopNode(LoopType::Type t, SyntaxNode * e, SyntaxNode * b) : loopType(t) ,loopExpression(e), loopBlock(b){ }

        void LoopNode::printUsing(ostream & out, unsigned d) {
            switch (loopType) {
            case LoopType::While:
                TAB(d) << "While expression =>" << endl;
                break;
            case LoopType::Until:
                TAB(d) << "Until expression =>" << endl;
                break;
            }
            loopExpression->printUsing(out, d + 1);
            TAB(d + 1) << "Block =>" << endl;
            loopBlock->printUsing(out, d + 2);
        }

        ControlNode::ControlNode(ControlType::Type t) : controlType(t), controlExpression(NULL) { }

        ControlNode::ControlNode(ControlType::Type t, SyntaxNode * e) : controlType(t), controlExpression(e) { }

        void ControlNode::printUsing(ostream & out, unsigned d) {
            switch (controlType) {
            case ControlType::Break:
                TAB(d) << "Break statement" << endl;
                break;
            case ControlType::Private:
                TAB(d) << "Alter visibility of items below to PRIVATE" << endl;
                break;
            case ControlType::Protected:
                TAB(d) << "Alter visibility of items below to PROTECTED" << endl;
                break;
            case ControlType::Public:
                TAB(d) << "Alter visibility of items below to PUBLIC" << endl;
                break;
            case ControlType::Raise:
                if (controlExpression != NULL) {
                    TAB(d) << "Raise statement with expression =>" << endl;
                    controlExpression->printUsing(out, d + 1);
                } else {
                    TAB(d) << "Raise statement" << endl;
                }
                break;
            case ControlType::Retry:
                TAB(d) << "Retry statement" << endl;
                break;
            case ControlType::Return:
                if (controlExpression != NULL) {
                    TAB(d) << "Return statement with expression =>" << endl;
                    controlExpression->printUsing(out, d + 1);
                } else {
                    TAB(d) << "Return statement" << endl;
                }
                break;
            case ControlType::Yield:
                if (controlExpression != NULL) {
                    TAB(d) << "Yield statement with expression =>" << endl;
                    controlExpression->printUsing(out, d + 1);
                } else {
                    TAB(d) << "Yield statement" << endl;
                }
                break;
            }
        }

        BlockNode::BlockNode(VectorNode * s) : blockRequire(new VectorNode()), blockEnsure(new VectorNode()), blockStatements(s), blockRescue(new VectorNode()) { }

        BlockNode *
        BlockNode::setBlockRequire(VectorNode * r) {
            for (VectorNode::iterator req = r->begin(); req < r->end(); req++)
                blockRequire->push_back(*req);
            return this;
        }

        BlockNode *
        BlockNode::setBlockEnsure(VectorNode * e) {
            for (VectorNode::iterator ens = e->begin(); ens < e->end(); ens++)
                blockEnsure->push_back(*ens);
            return this;
        }

        BlockNode *
        BlockNode::setBlockRescue(VectorNode * r) {
            for (VectorNode::iterator res = r->begin(); res < r->end(); res++)
                blockRescue->push_back(*res);
            return this;
        }

        void BlockNode::printUsing(ostream & out, unsigned d) {
            if (blockRequire != NULL) {
                for (VectorNode::iterator req = blockRequire->begin(); req < blockRequire->end(); req++) {
                    TAB(d) << "Require =>" << endl;
                    (*req)->printUsing(out, d + 1);
                }
            }
            for (VectorNode::iterator stmt = blockStatements->begin(); stmt < blockStatements->end(); stmt++) {
                (*stmt)->printUsing(out, d + 1);
            }
            if (blockRescue != NULL) {
                for (VectorNode::iterator res = blockRescue->begin(); res < blockRescue->end(); res++) {
                    TAB(d) << "Rescue =>" << endl;
                    (*res)->printUsing(out, d + 1);
                }
            }
            if (blockEnsure != NULL) {
                for (VectorNode::iterator ens = blockEnsure->begin(); ens < blockEnsure->end(); ens++) {
                    TAB(d) << "Ensure =>" << endl;
                    (*ens)->printUsing(out, d + 1);
                }
            }
        }

        ValidationNode::ValidationNode(SyntaxNode * e, SyntaxNode * r) : validationExpression(e), validationRaise(r) { }

        void ValidationNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Validation require =>" << endl;
            validationExpression->printUsing(out, d + 1);
            if (validationRaise != NULL) {
                TAB(d + 1) << "Raising the exception" << endl;
                validationRaise->printUsing(out, d + 2);
            }
        }

        VariableNode::VariableNode(VectorNode * v) : variables(v) { }

        void VariableNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Declare variables =>" << endl;
            for (VectorNode::iterator var = variables->begin(); var < variables->end(); var++)
                (*var)->printUsing(out, d + 1);
        }

        ElementNode::ElementNode(SyntaxNode * n) : elementName(n), elementType(NULL), elementInitialValue(NULL), elementInvariants(NULL) { }

        ElementNode *
        ElementNode::setElementType(SyntaxNode * t) {
            elementType = t;
            return this;
        }

        ElementNode *
        ElementNode::setElementInitialValue(SyntaxNode * v) {
            elementInitialValue = v;
            return this;
        }

        ElementNode *
        ElementNode::setElementInvariants(SyntaxNode * i) {
            elementInvariants = i;
            return this;
        }

        void ElementNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Element named =>" << endl;
            elementName->printUsing(out, d + 1);
            if (elementType != NULL) {
                TAB(d + 1) << "Of type" << endl;
                elementType->printUsing(out, d + 2);
            }
            if (elementInitialValue != NULL) {
                TAB(d + 1) << "With initial value =>" << endl;
                elementInitialValue->printUsing(out, d + 2);
            }
            if (elementInvariants != NULL) {
                TAB(d + 1) << "With invariants condition =>" << endl;
                elementInvariants->printUsing(out, d + 2);
            }
        }

        ConstantNode::ConstantNode(VectorNode * v) : constants(v) { }

        void ConstantNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Declare constants =>" << endl;
            for (VectorNode::iterator cons = constants->begin(); cons < constants->end(); cons++)
                (*cons)->printUsing(out, d + 1);
        }

        InterceptNode::InterceptNode(InterceptionType::Type t, VectorNode * i) : interceptionType(t), interceptionItems(i) { }

        void InterceptNode::printUsing(ostream & out, unsigned d) {
            switch (interceptionType) {
            case InterceptionType::After:
                TAB(d) << "Intercept after =>" << endl;
                break;
            case InterceptionType::Before:
                TAB(d) << "Intercept before =>" << endl;
                break;
            case InterceptionType::Signal:
                TAB(d) << "Intercept signals =>" << endl;
                break;
            }
            for (VectorNode::iterator item = interceptionItems->begin(); item < interceptionItems->end(); item++) {
                (*item)->printUsing(out, d + 1);
            }
        }

        FunctionNode::FunctionNode(SyntaxNode * n, VectorNode * p) : functionName(n), functionParams(p), functionReturnType(NULL), functionIntercept(NULL), functionBlock(NULL) { }

        FunctionNode *
        FunctionNode::setFunctionReturn(SyntaxNode * r) {
            delete functionReturnType;
            functionReturnType = r;
            return this;
        }

        FunctionNode *
        FunctionNode::setFunctionIntercept(SyntaxNode * i) {
            delete functionIntercept;
            functionIntercept = i;
            return this;
        }

        FunctionNode *
        FunctionNode::addSpecifier(SpecifierType::Type f) {
            functionSpecifiers.push_back(f);
            return this;
        }

        FunctionNode *
        FunctionNode::setBlock(SyntaxNode * s) {
            delete functionBlock;
            functionBlock = s;
            return this;
        }

        void FunctionNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Function named =>" << endl;
            functionName->printUsing(out, d + 1);
            if (functionSpecifiers.size() > 0) {
                for (vector<SpecifierType::Type>::iterator spec = functionSpecifiers.begin(); spec < functionSpecifiers.end(); spec++)
                    TAB(d) << "With specifier =>" << SpecifierType::getEnumName(*spec) << endl;
            }
            if (functionParams->size() > 0) {
                TAB(d) << "With parameters =>" << endl;
                for (VectorNode::iterator param = functionParams->begin(); param < functionParams->end(); param++) {
                    (*param)->printUsing(out, d + 1);
                }
            } else
                TAB(d) << "Without parameters" << endl;
            if (functionReturnType != NULL) {
                TAB(d) << "With return type =>" << endl;
                functionReturnType->printUsing(out, d + 1);
            }
            if (functionIntercept != NULL) functionIntercept->printUsing(out, d + 1);
            if (functionBlock != NULL) {
                TAB(d) << "Block =>" << endl;
                functionBlock->printUsing(out, d + 1);
            }
        }

        EventNode::EventNode(SyntaxNode * n) : eventName(n), eventIntercept(NULL), eventInitialValue(NULL) { }

        EventNode *
        EventNode::setEventIntercept(SyntaxNode * i) {
            delete eventIntercept;
            eventIntercept = i;
            return this;
        }

        EventNode *
        EventNode::setEventInitialValue(SyntaxNode * v) {
            delete eventInitialValue;
            eventInitialValue = v;
            return this;
        }

        void EventNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Event named =>" << endl;
            eventName->printUsing(out, d + 1);
            if (eventIntercept != NULL) eventIntercept->printUsing(out, d + 1);
            if (eventInitialValue != NULL) {
                TAB(d + 1) << "With initial value =>" << endl;
                eventInitialValue->printUsing(out, d + 2);
            }
        }

        AttributeNode::AttributeNode(SyntaxNode * n) : attributeName(n), attributeReturnType(NULL), attributeInitialValue(NULL), attributeGetter(NULL), attributeSetter(NULL), attributeInvariants(NULL) { }

        AttributeNode *
        AttributeNode::setAttributeReturnType(SyntaxNode * r) {
            delete attributeReturnType;
            attributeReturnType = r;
            return this;
        }

        AttributeNode *
        AttributeNode::setAttributeInitialValue(SyntaxNode * i) {
            delete attributeInitialValue;
            attributeInitialValue = i;
            return this;
        }

        AttributeNode *
        AttributeNode::setAttributeGetter(SyntaxNode * g) {
            delete attributeGetter;
            attributeGetter = g;
            return this;
        }

        AttributeNode *
        AttributeNode::setAttributeSetter(SyntaxNode * s) {
            delete attributeSetter;
            attributeSetter = s;
            return this;
        }

        AttributeNode *
        AttributeNode::setAttributeInvariants(SyntaxNode * i) {
            delete attributeInvariants;
            attributeInvariants = i;
            return this;
        }

        void AttributeNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Attribute named =>" << endl;
            attributeName->printUsing(out, d + 1);
            if (attributeReturnType != NULL) {
                TAB(d + 1) << "Of type =>" << endl;
                attributeReturnType->printUsing(out, d + 2);
            }
            if (attributeInitialValue != NULL) {
                TAB(d + 1) << "With initial value =>" << endl;
                attributeInitialValue->printUsing(out, d + 2);
            }
            if (attributeInvariants != NULL) {
                TAB(d + 1) << "With invariants condition =>" << endl;
                attributeInvariants->printUsing(out, d + 2);
            }
            if (attributeGetter != NULL) {
                TAB(d + 1) << "Getting with =>" << endl;
                attributeGetter->printUsing(out, d + 2);
            }
            if (attributeSetter != NULL) {
                TAB(d + 1) << "Setting with =>" << endl;
                attributeSetter->printUsing(out, d + 2);
            }
        }

        IncludeNode::IncludeNode(SyntaxNode * i) : includeItem(i) { }

        void IncludeNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Including =>" << endl;
            includeItem->printUsing(out, d + 1);
        }

        ClassNode::ClassNode(SyntaxNode * n) : className(n), classHeritance(new VectorNode()), classMembers(new VectorNode()) { }

        ClassNode *
        ClassNode::addSpecifier(SpecifierType::Type f) {
            classSpecifiers.push_back(f);
            return this;
        }

        ClassNode *
        ClassNode::setClassHeritance(VectorNode * h) {
            delete classHeritance;
            classHeritance = h;
            return this;
        }

        ClassNode *
        ClassNode::addMembers(VectorNode * s) {
            for (VectorNode::iterator stmt = s->begin(); stmt < s->end(); stmt++)
                classMembers->push_back(*stmt);
            return this;
        }

        void ClassNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Class named =>" << endl;
            className->printUsing(out, d + 1);
            if (classSpecifiers.size() > 0) {
                for (vector<SpecifierType::Type>::iterator spec = classSpecifiers.begin(); spec < classSpecifiers.end(); spec++)
                    TAB(d + 1) << "With specifier =>" << SpecifierType::getEnumName(*spec) << endl;
            }
            if (classHeritance != NULL) {
                TAB(d + 1) << "Heritance of =>" << endl;
                for (VectorNode::iterator heritance = classHeritance->begin(); heritance < classHeritance->end(); heritance++) {
					(*heritance)->printUsing(out, d + 2);
				}
            }
            if (classMembers->size() > 0) {
                TAB(d + 1) << "Members =>" << endl;
                for (VectorNode::iterator member = classMembers->begin(); member < classMembers->end(); member++) {
                    (*member)->printUsing(out, d + 2);
                }
            }
        }

        ImportNode::ImportNode(VectorNode * m) : importMembers(m), importOrigin(NULL) { }

        ImportNode *
        ImportNode::setImportOrigin(SyntaxNode * o) {
            delete importOrigin;
            importOrigin = o;
            return this;
        }

        void ImportNode::printUsing(ostream & out, unsigned d) {
            if (importOrigin != NULL) {
                TAB(d) << "From =>" << endl;
                importOrigin->printUsing(out, d + 1);
            }
            for (VectorNode::iterator member = importMembers->begin(); member < importMembers->end(); member++) {
                TAB(d + 1) << "Import =>" << endl;
                (*member)->printUsing(out, d + 2);
            }
        }

        ModuleNode::ModuleNode(SyntaxNode * n) : moduleName(n), moduleStatements(new VectorNode()) { }

        ModuleNode *
        ModuleNode::addStatements(VectorNode * s) {
            for (VectorNode::iterator stmt = s->begin(); stmt < s->end(); stmt++)
                moduleStatements->push_back(*stmt);
            return this;
        }

        void ModuleNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Module named =>" << endl;
            moduleName->printUsing(out, d + 1);
            if (moduleStatements->size() > 0) {
                TAB(d + 1) << "Members =>" << endl;
                for (VectorNode::iterator stmt = moduleStatements->begin(); stmt < moduleStatements->end(); stmt++) {
                    (*stmt)->printUsing(out, d + 2);
                }
            }
        }

    } // SyntaxTree
} // LANG_NAMESPACE
