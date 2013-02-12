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
 * stmt.h - Statements
 *
 * Defines objects used to represent statements
 *
 */

#ifndef LANG_STMT_H
#define LANG_STMT_H

#include "ast.h"

using namespace LANG_NAMESPACE::Enum;

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
    	/**
    	 * Represents an asynchronous statement
    	 */
        class AsyncStatementNode : public SyntaxNode
        {
        protected:
            SyntaxNode * asyncItem;
        public:
            AsyncStatementNode(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        // TODO Dividir em IfNode e UnlessNode
        /**
         * Represents a condition expression
         */
        class ConditionNode: public SyntaxNode
        {
        protected:
            ConditionType::Type conditionOperator;
            SyntaxNode * conditionExpression;
            SyntaxNode * conditionThen;
            VectorNode * conditionElifs;
            SyntaxNode * conditionElse;
        public:
            ConditionNode(ConditionType::Type, SyntaxNode *, SyntaxNode *);
            virtual ConditionNode * setElif(VectorNode *);
            virtual ConditionNode * setElse(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a case expression and body of switch
         */
        class CaseNode: public SyntaxNode
        {
        protected:
            SyntaxNode * caseExpression;
            VectorNode * caseWhen;
            VectorNode * caseElse;
        public:
            CaseNode(SyntaxNode *);
            virtual CaseNode * setWhen(VectorNode *);
            virtual CaseNode * setElse(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * TODO Nem sei se isso permanece... :/
         */
        class WhenNode: public SyntaxNode
        {
        protected:
            SyntaxNode * whenExpression;
            SyntaxNode * whenBlock;
        public:
            WhenNode(SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a for loop
         */
        class ForNode: public SyntaxNode
        {
        protected:
            LoopType::Type forType;
            SyntaxNode * forLhs;
            SyntaxNode * forRhs;
            SyntaxNode * forBlock;
            SyntaxNode * forStep;
        public:
            ForNode(LoopType::Type, SyntaxNode *, SyntaxNode *, SyntaxNode *);
            virtual ForNode * setStep(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        // TODO Dividir em WhileNode e UntilNode
        /**
         * Represents a while/do-while loop
         */
        class LoopNode: public SyntaxNode
        {
        protected:
            LoopType::Type loopType;
            SyntaxNode * loopExpression;
            SyntaxNode * loopBlock;
        public:
            LoopNode(LoopType::Type, SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a control/interruption of execution
         */
        class ControlNode: public SyntaxNode
        {
        protected:
            ControlType::Type controlType;
            SyntaxNode * controlExpression;
        public:
            ControlNode(ControlType::Type);
            ControlNode(ControlType::Type, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a block os statements
         */
        class BlockNode: public SyntaxNode
        {
        protected:
            VectorNode * blockRequire;
            VectorNode * blockEnsure;
            VectorNode * blockStatements;
            VectorNode * blockRescue;
        public:
            BlockNode(VectorNode *);
            virtual BlockNode * setBlockRequire(VectorNode *);
            virtual BlockNode * setBlockEnsure(VectorNode *);
            virtual BlockNode * setBlockRescue(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * TODO Nem sei pra que serve isso... (:
         */
        class ValidationNode: public SyntaxNode
        {
        protected:
            SyntaxNode * validationExpression;
            SyntaxNode * validationRaise;
        public:
            ValidationNode(SyntaxNode *, SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * TODO Jamaz funcionará
         */
        class RescueNode : public SyntaxNode
        {
        protected:
            SyntaxNode * rescueStatement;
            SyntaxNode * rescueException;
        public:
            RescueNode(SyntaxNode *);
            virtual RescueNode * setException(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a variable
         */
        class VariableNode: public SyntaxNode
        {
        protected:
            VectorNode * variables;
        public:
            VariableNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * TODO Prq Deus quis assim...
         */
        class ElementNode: public SyntaxNode
        {
        protected:
            SyntaxNode * elementName;
            SyntaxNode * elementType;
            SyntaxNode * elementInitialValue;
            SyntaxNode * elementInvariants;
        public:
            ElementNode(SyntaxNode *);
            virtual ElementNode * setElementType(SyntaxNode *);
            virtual ElementNode * setElementInitialValue(SyntaxNode *);
            virtual ElementNode * setElementInvariants(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a constant
         */
        class ConstantNode: public SyntaxNode
        {
        protected:
            VectorNode * constants;
        public:
            ConstantNode(VectorNode *);
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a function
         */
        class FunctionNode: public SyntaxNode
        {
        protected:
            vector<SpecifierType::Type> functionSpecifiers;
            SyntaxNode * functionName;
            VectorNode * functionParams;
            SyntaxNode * functionReturnType;
            SyntaxNode * functionIntercept;
            SyntaxNode * functionBlock;
        public:
            FunctionNode(SyntaxNode *, VectorNode *);
            virtual FunctionNode * setFunctionReturn(SyntaxNode *);
            virtual FunctionNode * setFunctionIntercept(SyntaxNode *);
            virtual FunctionNode * addSpecifier(SpecifierType::Type);
            virtual FunctionNode * setBlock(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
