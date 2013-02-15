/** Copyright (c) 2012, 2013
 *    Ares Programming Language Project.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. All advertising materials mentioning features or use of this software
 *     must display the following acknowledgement:
 *     This product includes software developed by Ares Programming Language
 *     Project and its contributors.
 *  4. Neither the name of the Ares Programming Language Project nor the names
 *     of its contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE ARES PROGRAMMING LANGUAGE PROJECT AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *****************************************************************************
 * stmt.cpp - Statements
 *
 * Implements objects used to represent statements
 *
 */

#include "stmt.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        ConditionNode::ConditionNode(ConditionType::Type o, SyntaxNode * i, SyntaxNode * t)
            : conditionOperator(o), conditionExpression(i), conditionThen(t),
            conditionElifs(new VectorNode()), conditionElse(NULL)
        {
            setNodeType(NodeType::Null);
        }

        ConditionNode *
        ConditionNode::setElif(VectorNode * e)
        {
            for(VectorNode::iterator elif = e->begin(); elif < e->end(); elif++)
                conditionElifs->push_back(*elif);
            return this;
        }

        ConditionNode *
        ConditionNode::setElse(SyntaxNode * e)
        {
            conditionElse = e;
            return this;
        }

        void
        ConditionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Condition =>" << endl;
            conditionExpression->print(out, d + 2);
            TAB(d + 1) << "Then =>" << endl;
            conditionThen->print(out, d + 2);
            if(conditionElifs->size() > 0) {
                for(VectorNode::iterator elif = conditionElifs->begin(); elif < conditionElifs->end(); elif++) {
                    TAB(d + 1) << "Elif =>" << endl;
                   (*elif)->print(out, d + 2);
                }
            }
            if(conditionElse != NULL) {
                TAB(d + 1) << "Else =>" << endl;
                conditionElse->print(out, d + 2);
            }
        }

        CaseNode::CaseNode(SyntaxNode * c)
            : caseExpression(c), caseWhen(new VectorNode()), caseElse(NULL)
        {
            setNodeType(NodeType::Null);
        }

        CaseNode *
        CaseNode::setWhen(VectorNode * w)
        {
            if(w != NULL)
                for(VectorNode::iterator when = w->begin(); when < w->end(); when++)
                    caseWhen->push_back(*when);
            return this;
        }

        CaseNode *
        CaseNode::setElse(VectorNode * e)
        {
            caseElse = e;
            return this;
        }

        void
        CaseNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Case =>" << endl;
            caseExpression->print(out, d + 1);
            if(caseWhen->size() > 0) {
                for(VectorNode::iterator when = caseWhen->begin(); when < caseWhen->end(); when++)
                   (*when)->print(out, d + 2);
            }
            if(caseElse != NULL) {
                TAB(d + 1) << "Else =>" << endl;
                for(VectorNode::iterator Else = caseElse->begin(); Else < caseElse->end(); Else++)
                   (*Else)->print(out, d + 2);
            }
        }

        WhenNode::WhenNode(SyntaxNode * e, SyntaxNode * b)
            : whenExpression(e), whenBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        void
        WhenNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "When =>" << endl;
            whenExpression->print(out, d + 1);
            TAB(d + 1) << "Block =>" << endl;
            whenBlock->print(out, d + 2);
        }

        ForNode::ForNode(LoopType::Type t, SyntaxNode * l, SyntaxNode * r, SyntaxNode * b)
            : forType(t), forLhs(l), forRhs(r), forBlock(b), forStep(NULL)
        {
            setNodeType(NodeType::Null);
        }

        ForNode *
        ForNode::setStep(SyntaxNode * s)
        {
            forStep = s;
            return this;
        }

        void
        ForNode::print(ostream & out, unsigned d)
        {
            switch(forType) {
            case LoopType::For:
                TAB(d) << "For =>" << endl;
                break;
            case LoopType::Foreach:
                TAB(d) << "Foreach =>" << endl;
                break;
            }
            forLhs->print(out, d + 1);
            TAB(d + 1) << "To =>" << endl;
            forRhs->print(out, d + 1);
            if(forStep != NULL) {
                TAB(d + 1) << "By step =>" << endl;
                forStep->print(out, d + 2);
            }
            TAB(d + 1) << "Block =>" << endl;
            forBlock->print(out, d + 2);
        }

        LoopNode::LoopNode(LoopType::Type t, SyntaxNode * e, SyntaxNode * b)
            : loopType(t), loopExpression(e), loopBlock(b)
        {
            setNodeType(NodeType::Null);
        }

        void
        LoopNode::print(ostream & out, unsigned d)
        {
            switch(loopType) {
            case LoopType::While:
                TAB(d) << "While expression =>" << endl;
                break;
            case LoopType::DoWhile:
                TAB(d) << "Until expression =>" << endl;
                break;
            }
            loopExpression->print(out, d + 1);
            TAB(d + 1) << "Block =>" << endl;
            loopBlock->print(out, d + 2);
        }

        ControlNode::ControlNode(ControlType::Type t)
            : controlType(t), controlExpression(NULL)
        {
            setNodeType(NodeType::Null);
        }

        ControlNode::ControlNode(ControlType::Type t, SyntaxNode * e)
            : controlType(t), controlExpression(e)
        {
            setNodeType(NodeType::Null);
        }

        void
        ControlNode::print(ostream & out, unsigned d)
        {
            switch(controlType) {
            case ControlType::Break:
                TAB(d) << "Break statement" << endl;
                break;
            case ControlType::Return:
                if(controlExpression != NULL) {
                    TAB(d) << "Return statement with expression =>" << endl;
                    controlExpression->print(out, d + 1);
                } else {
                    TAB(d) << "Return statement" << endl;
                }
                break;
            case ControlType::Yield:
                if(controlExpression != NULL) {
                    TAB(d) << "Yield statement with expression =>" << endl;
                    controlExpression->print(out, d + 1);
                } else {
                    TAB(d) << "Yield statement" << endl;
                }
                break;
            }
        }

        BlockNode::BlockNode(VectorNode * s)
            : blockRequire(new VectorNode()), blockEnsure(new VectorNode()),
            blockStatements(s), blockRescue(new VectorNode())
        {
            setNodeType(NodeType::Null);
        }

        BlockNode *
        BlockNode::setBlockRequire(VectorNode * r)
        {
            for(VectorNode::iterator req = r->begin(); req < r->end(); req++)
                blockRequire->push_back(*req);
            return this;
        }

        BlockNode *
        BlockNode::setBlockEnsure(VectorNode * e)
        {
            for(VectorNode::iterator ens = e->begin(); ens < e->end(); ens++)
                blockEnsure->push_back(*ens);
            return this;
        }

        BlockNode *
        BlockNode::setBlockRescue(VectorNode * r)
        {
            for(VectorNode::iterator res = r->begin(); res < r->end(); res++)
                blockRescue->push_back(*res);
            return this;
        }

        void
        BlockNode::print(ostream & out, unsigned d)
        {
            if(blockRequire != NULL) {
                for(VectorNode::iterator req = blockRequire->begin(); req < blockRequire->end(); req++) {
                    TAB(d) << "Require =>" << endl;
                   (*req)->print(out, d + 1);
                }
            }
            for(VectorNode::iterator stmt = blockStatements->begin(); stmt < blockStatements->end(); stmt++) {
               (*stmt)->print(out, d + 1);
            }
            if(blockRescue != NULL) {
                for(VectorNode::iterator res = blockRescue->begin(); res < blockRescue->end(); res++) {
                    TAB(d) << "Rescue =>" << endl;
                   (*res)->print(out, d + 1);
                }
            }
            if(blockEnsure != NULL) {
                for(VectorNode::iterator ens = blockEnsure->begin(); ens < blockEnsure->end(); ens++) {
                    TAB(d) << "Ensure =>" << endl;
                   (*ens)->print(out, d + 1);
                }
            }
        }

        // ValidationNode::ValidationNode(SyntaxNode * e, SyntaxNode * r)
        //     : validationExpression(e), validationRaise(r)
        // {
        //     setNodeType(NodeType::Null);
        // }

        // void
        // ValidationNode::print(ostream & out, unsigned d)
        // {
        //     TAB(d) << "Validation require =>" << endl;
        //     validationExpression->print(out, d + 1);
        //     if(validationRaise != NULL) {
        //         TAB(d + 1) << "Raising the exception" << endl;
        //         validationRaise->print(out, d + 2);
        //     }
        // }

        VariableNode::VariableNode(VectorNode * v)
            : variables(v)
        {
            setNodeType(NodeType::Null);
        }

        void
        VariableNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Declare variables =>" << endl;
            for(VectorNode::iterator var = variables->begin(); var < variables->end(); var++)
               (*var)->print(out, d + 1);
        }

        // RescueNode::RescueNode(SyntaxNode * s)
        //     : rescueStatement(s)
        // {
        //     setNodeType(NodeType::Null);
        // }

        // RescueNode *
        // RescueNode::setException(SyntaxNode * e)
        // {
        //     rescueException = e;
        //     return this;
        // }

        // void
        // RescueNode::print(ostream & out, unsigned d)
        // {
        //     TAB(d) << "On exception =>";
        //     if(rescueException)
        //         rescueException->print(out, d + 1);
        //     rescueStatement->print(out, d + 2);
        // }

        ElementNode::ElementNode(SyntaxNode * n)
            : elementName(n), elementType(NULL), elementInitialValue(NULL),
            elementInvariants(NULL)
        {
            setNodeType(NodeType::Null);
        }

        ElementNode *
        ElementNode::setElementType(SyntaxNode * t)
        {
            elementType = t;
            return this;
        }

        ElementNode *
        ElementNode::setElementInitialValue(SyntaxNode * v)
        {
            elementInitialValue = v;
            return this;
        }

        ElementNode *
        ElementNode::setElementInvariants(SyntaxNode * i)
        {
            elementInvariants = i;
            return this;
        }

        void
        ElementNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Element named =>" << endl;
            elementName->print(out, d + 1);
            if(elementType != NULL) {
                TAB(d + 1) << "Of type" << endl;
                elementType->print(out, d + 2);
            }
            if(elementInitialValue != NULL) {
                TAB(d + 1) << "With initial value =>" << endl;
                elementInitialValue->print(out, d + 2);
            }
            if(elementInvariants != NULL) {
                TAB(d + 1) << "With invariants condition =>" << endl;
                elementInvariants->print(out, d + 2);
            }
        }

        ConstantNode::ConstantNode(VectorNode * v)
            : constants(v)
        {
            setNodeType(NodeType::Null);
        }

        void
        ConstantNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Declare constants =>" << endl;
            for(VectorNode::iterator cons = constants->begin(); cons < constants->end(); cons++)
               (*cons)->print(out, d + 1);
        }

        Parameter::Parameter(SyntaxNode * type, SyntaxNode * name)
            : paramType(type), paramName(name)
        {
            setNodeType(NodeType::Null);
        }

        void
        Parameter::print(ostream & out, unsigned d)
        {
            TAB(d) << "parameter" << endl;
            paramName->print(out, d + 1);
            TAB(d) << "of type" << endl;
            paramType->print(out, d + 1);
        }

        FunctionNode::FunctionNode(SyntaxNode * n, VectorNode * p)
            : functionName(n), functionParams(p), functionReturnType(NULL),
            functionIntercept(NULL), functionBlock(NULL)
        {
            setNodeType(NodeType::Null);
        }

        FunctionNode *
        FunctionNode::setFunctionReturn(SyntaxNode * r)
        {
            functionReturnType = r;
            return this;
        }

        FunctionNode *
        FunctionNode::setFunctionIntercept(SyntaxNode * i)
        {
            functionIntercept = i;
            return this;
        }

        FunctionNode *
        FunctionNode::addSpecifier(SpecifierType::Type f)
        {
            functionSpecifiers.push_back(f);
            return this;
        }

        FunctionNode *
        FunctionNode::setBlock(SyntaxNode * s)
        {
            functionBlock = s;
            return this;
        }

        void
        FunctionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Function named =>" << endl;
            functionName->print(out, d + 1);
            if(functionSpecifiers.size() > 0) {
                for(vector<SpecifierType::Type>::iterator spec = functionSpecifiers.begin(); spec < functionSpecifiers.end(); spec++)
                    TAB(d + 1) << "With specifier =>" << *spec << endl;
            }
            if(functionParams->size() > 0) {
                TAB(d) << "With parameters =>" << endl;
                for(VectorNode::iterator param = functionParams->begin(); param < functionParams-> end(); param++) {
                   (*param)->print(out, d + 1);
                }
            } else
                TAB(d) << "Without parameters" << endl;
            if(functionReturnType != NULL) {
                TAB(d) << "With return type =>" << endl;
                functionReturnType->print(out, d + 1);
            }
            if(functionIntercept != NULL) functionIntercept->print(out, d + 1);
            if(functionBlock != NULL) {
                TAB(d) << "Block =>" << endl;
                functionBlock->print(out, d + 1);
            }
        }
    } // SyntaxTree
} // LANG_NAMESPACE
