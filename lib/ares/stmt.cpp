/* Ares Programming Language */

#include "stmt.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        AsyncStatementNode::AsyncStatementNode (SyntaxNode * i)
            : asyncItem (i) { }

        void
        AsyncStatementNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Async =>" << endl;
            asyncItem->printUsing (out, d + 1);
        }

        ConditionNode::ConditionNode (ConditionType::Type o, SyntaxNode * i, SyntaxNode * t)
            : conditionOperator (o), conditionExpression (i), conditionThen (t),
            conditionElifs (new VectorNode ()), conditionElse (NULL) { }

        ConditionNode *
        ConditionNode::setElif (VectorNode * e)
        {
            for (VectorNode::iterator elif = e->begin (); elif < e->end (); elif++)
                conditionElifs->push_back (*elif);
            return this;
        }

        ConditionNode *
        ConditionNode::setElse (SyntaxNode * e)
        {
            conditionElse = e;
            return this;
        }

        void
        ConditionNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Condition =>" << endl;
            conditionExpression->printUsing (out, d + 2);
            TAB(d + 1) << "Then =>" << endl;
            conditionThen->printUsing (out, d + 2);
            if (conditionElifs->size () > 0) {
                for (VectorNode::iterator elif = conditionElifs->begin (); elif < conditionElifs->end (); elif++) {
                    TAB(d + 1) << "Elif =>" << endl;
                    (*elif)->printUsing (out, d + 2);
                }
            }
            if (conditionElse != NULL) {
                TAB(d + 1) << "Else =>" << endl;
                conditionElse->printUsing (out, d + 2);
            }
        }

        CaseNode::CaseNode (SyntaxNode * c)
            : caseExpression (c), caseWhen (new VectorNode ()), caseElse (NULL) { }

        CaseNode *
        CaseNode::setWhen (VectorNode * w)
        {
            if (w != NULL)
                for (VectorNode::iterator when = w->begin (); when < w->end (); when++)
                    caseWhen->push_back (*when);
            return this;
        }

        CaseNode *
        CaseNode::setElse (VectorNode * e)
        {
            caseElse = e;
            return this;
        }

        void
        CaseNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Case =>" << endl;
            caseExpression->printUsing (out, d + 1);
            if (caseWhen->size() > 0) {
                for (VectorNode::iterator when = caseWhen->begin (); when < caseWhen->end (); when++)
                    (*when)->printUsing (out, d + 2);
            }
            if (caseElse != NULL) {
                TAB(d + 1) << "Else =>" << endl;
                for (VectorNode::iterator Else = caseElse->begin (); Else < caseElse->end (); Else++)
                    (*Else)->printUsing (out, d + 2);
            }
        }

        WhenNode::WhenNode (SyntaxNode * e, SyntaxNode * b)
            : whenExpression (e), whenBlock (b) { }

        void
        WhenNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "When =>" << endl;
            whenExpression->printUsing (out, d + 1);
            TAB(d + 1) << "Block =>" << endl;
            whenBlock->printUsing (out, d + 2);
        }

        ForNode::ForNode (LoopType::Type t, SyntaxNode * l, SyntaxNode * r, SyntaxNode * b)
            : forType (t), forLhs (l), forRhs (r), forBlock (b), forStep (NULL) { }

        ForNode *
        ForNode::setStep (SyntaxNode * s)
        {
            forStep = s;
            return this;
        }

        void
        ForNode::printUsing (ostream & out, unsigned d)
        {
            switch (forType) {
            case LoopType::For:
                TAB(d) << "For =>" << endl;
                break;
            case LoopType::Foreach:
                TAB(d) << "Foreach =>" << endl;
                break;
            }
            forLhs->printUsing (out, d + 1);
            TAB(d + 1) << "To =>" << endl;
            forRhs->printUsing (out, d + 1);
            if (forStep != NULL) {
                TAB(d + 1) << "By step =>" << endl;
                forStep->printUsing (out, d + 2);
            }
            TAB(d + 1) << "Block =>" << endl;
            forBlock->printUsing (out, d + 2);
        }

        LoopNode::LoopNode (LoopType::Type t, SyntaxNode * e, SyntaxNode * b)
            : loopType (t), loopExpression (e), loopBlock (b) { }

        void
        LoopNode::printUsing (ostream & out, unsigned d)
        {
            switch (loopType) {
            case LoopType::While:
                TAB(d) << "While expression =>" << endl;
                break;
            case LoopType::DoWhile:
                TAB(d) << "Until expression =>" << endl;
                break;
            }
            loopExpression->printUsing (out, d + 1);
            TAB(d + 1) << "Block =>" << endl;
            loopBlock->printUsing (out, d + 2);
        }

        ControlNode::ControlNode (ControlType::Type t)
            : controlType (t), controlExpression (NULL) { }

        ControlNode::ControlNode (ControlType::Type t, SyntaxNode * e)
            : controlType (t), controlExpression (e) { }

        void
        ControlNode::printUsing (ostream & out, unsigned d)
        {
            switch (controlType) {
            case ControlType::Break:
                TAB(d) << "Break statement" << endl;
                break;
            case ControlType::Return:
                if (controlExpression != NULL) {
                    TAB(d) << "Return statement with expression =>" << endl;
                    controlExpression->printUsing (out, d + 1);
                } else {
                    TAB(d) << "Return statement" << endl;
                }
                break;
            case ControlType::Yield:
                if (controlExpression != NULL) {
                    TAB(d) << "Yield statement with expression =>" << endl;
                    controlExpression->printUsing (out, d + 1);
                } else {
                    TAB(d) << "Yield statement" << endl;
                }
                break;
            }
        }

        BlockNode::BlockNode (VectorNode * s)
            : blockRequire (new VectorNode ()), blockEnsure (new VectorNode ()),
            blockStatements (s), blockRescue (new VectorNode ()) { }

        BlockNode *
        BlockNode::setBlockRequire (VectorNode * r)
        {
            for (VectorNode::iterator req = r->begin (); req < r->end (); req++)
                blockRequire->push_back (*req);
            return this;
        }

        BlockNode *
        BlockNode::setBlockEnsure (VectorNode * e)
        {
            for (VectorNode::iterator ens = e->begin (); ens < e->end (); ens++)
                blockEnsure->push_back (*ens);
            return this;
        }

        BlockNode *
        BlockNode::setBlockRescue (VectorNode * r)
        {
            for (VectorNode::iterator res = r->begin (); res < r->end (); res++)
                blockRescue->push_back (*res);
            return this;
        }

        void
        BlockNode::printUsing (ostream & out, unsigned d)
        {
            if (blockRequire != NULL) {
                for (VectorNode::iterator req = blockRequire->begin (); req < blockRequire->end (); req++) {
                    TAB(d) << "Require =>" << endl;
                    (*req)->printUsing (out, d + 1);
                }
            }
            for (VectorNode::iterator stmt = blockStatements->begin (); stmt < blockStatements->end (); stmt++) {
                (*stmt)->printUsing (out, d + 1);
            }
            if (blockRescue != NULL) {
                for (VectorNode::iterator res = blockRescue->begin (); res < blockRescue->end (); res++) {
                    TAB(d) << "Rescue =>" << endl;
                    (*res)->printUsing (out, d + 1);
                }
            }
            if (blockEnsure != NULL) {
                for (VectorNode::iterator ens = blockEnsure->begin (); ens < blockEnsure->end (); ens++) {
                    TAB(d) << "Ensure =>" << endl;
                    (*ens)->printUsing (out, d + 1);
                }
            }
        }

        ValidationNode::ValidationNode (SyntaxNode * e, SyntaxNode * r)
            : validationExpression (e), validationRaise (r) { }

        void
        ValidationNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Validation require =>" << endl;
            validationExpression->printUsing (out, d + 1);
            if (validationRaise != NULL) {
                TAB(d + 1) << "Raising the exception" << endl;
                validationRaise->printUsing (out, d + 2);
            }
        }

        VariableNode::VariableNode (VectorNode * v)
            : variables (v) { }

        void
        VariableNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Declare variables =>" << endl;
            for (VectorNode::iterator var = variables->begin (); var < variables->end (); var++)
                (*var)->printUsing (out, d + 1);
        }

        RescueNode::RescueNode (SyntaxNode * s)
            : rescueStatement (s) { }

        RescueNode *
        RescueNode::setException (SyntaxNode * e)
        {
            rescueException = e;
            return this;
        }

        void
        RescueNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "On exception =>";
            if (rescueException)
                rescueException->printUsing (out, d + 1);
            rescueStatement->printUsing (out, d + 2);
        }

        ElementNode::ElementNode (SyntaxNode * n)
            : elementName (n), elementType (NULL), elementInitialValue (NULL),
            elementInvariants (NULL) { }

        ElementNode *
        ElementNode::setElementType (SyntaxNode * t)
        {
            elementType = t;
            return this;
        }

        ElementNode *
        ElementNode::setElementInitialValue (SyntaxNode * v)
        {
            elementInitialValue = v;
            return this;
        }

        ElementNode *
        ElementNode::setElementInvariants (SyntaxNode * i)
        {
            elementInvariants = i;
            return this;
        }

        void
        ElementNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Element named =>" << endl;
            elementName->printUsing (out, d + 1);
            if (elementType != NULL) {
                TAB(d + 1) << "Of type" << endl;
                elementType->printUsing (out, d + 2);
            }
            if (elementInitialValue != NULL) {
                TAB(d + 1) << "With initial value =>" << endl;
                elementInitialValue->printUsing (out, d + 2);
            }
            if (elementInvariants != NULL) {
                TAB(d + 1) << "With invariants condition =>" << endl;
                elementInvariants->printUsing (out, d + 2);
            }
        }

        ConstantNode::ConstantNode (VectorNode * v)
            : constants (v) { }

        void
        ConstantNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Declare constants =>" << endl;
            for (VectorNode::iterator cons = constants->begin (); cons < constants->end (); cons++)
                (*cons)->printUsing (out, d + 1);
        }

        FunctionNode::FunctionNode (SyntaxNode * n, VectorNode * p)
            : functionName (n), functionParams (p), functionReturnType (NULL),
            functionIntercept (NULL), functionBlock (NULL) { }

        FunctionNode *
        FunctionNode::setFunctionReturn (SyntaxNode * r)
        {
            functionReturnType = r;
            return this;
        }

        FunctionNode *
        FunctionNode::setFunctionIntercept (SyntaxNode * i)
        {
            functionIntercept = i;
            return this;
        }

        FunctionNode *
        FunctionNode::addSpecifier (SpecifierType::Type f)
        {
            functionSpecifiers.push_back (f);
            return this;
        }

        FunctionNode *
        FunctionNode::setBlock (SyntaxNode * s)
        {
            functionBlock = s;
            return this;
        }

        void
        FunctionNode::printUsing (ostream & out, unsigned d)
        {
            TAB(d) << "Function named =>" << endl;
            functionName->printUsing (out, d + 1);
            if (functionSpecifiers.size () > 0) {
                for (vector<SpecifierType::Type>::iterator spec = functionSpecifiers.begin (); spec < functionSpecifiers.end (); spec++)
                    TAB(d + 1) << "With specifier =>" << SpecifierType::getEnumName (*spec) << endl;
            }
            if (functionParams->size() > 0) {
                TAB(d) << "With parameters =>" << endl;
                for (VectorNode::iterator param = functionParams->begin (); param < functionParams-> end(); param++) {
                    (*param)->printUsing (out, d + 1);
                }
            } else
                TAB(d) << "Without parameters" << endl;
            if (functionReturnType != NULL) {
                TAB(d) << "With return type =>" << endl;
                functionReturnType->printUsing (out, d + 1);
            }
            if (functionIntercept != NULL) functionIntercept->printUsing (out, d + 1);
            if (functionBlock != NULL) {
                TAB(d) << "Block =>" << endl;
                functionBlock->printUsing (out, d + 1);
            }
        }
    } // SyntaxTree
} // LANG_NAMESPACE
