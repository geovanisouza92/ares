/* Ares Programming Language */

#ifndef LANG_STMT_H
#define LANG_STMT_H

#include "st.hpp"

using namespace LANG_NAMESPACE::Enum;

namespace LANG_NAMESPACE {
    namespace SyntaxTree {

    	// TODO Dividir em IfNode e UnlessNode
        class ConditionNode: public SyntaxNode {
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
            virtual void printUsing(ostream &, unsigned);
        };

        class CaseNode: public SyntaxNode {
        protected:
            SyntaxNode * caseExpression;
            VectorNode * caseWhen;
            VectorNode * caseElse;
        public:
            CaseNode(SyntaxNode *);
            virtual CaseNode * setWhen(VectorNode *);
            virtual CaseNode * setElse(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class WhenNode: public SyntaxNode {
        protected:
            SyntaxNode * whenExpression;
            SyntaxNode * whenBlock;
        public:
            WhenNode(SyntaxNode *, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ForNode: public SyntaxNode {
        protected:
            LoopType::Type forType;
            SyntaxNode * forLhs;
            SyntaxNode * forRhs;
            SyntaxNode * forBlock;
            SyntaxNode * forStep;
        public:
            ForNode(LoopType::Type, SyntaxNode *, SyntaxNode *, SyntaxNode *);
            virtual ForNode * setStep(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        // TODO Dividir em WhileNode e UntilNode
        class LoopNode: public SyntaxNode {
        protected:
            LoopType::Type loopType;
            SyntaxNode * loopExpression;
            SyntaxNode * loopBlock;
        public:
            LoopNode(LoopType::Type, SyntaxNode *, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ControlNode: public SyntaxNode {
        protected:
            ControlType::Type controlType;
            SyntaxNode * controlExpression;
        public:
            ControlNode(ControlType::Type);
            ControlNode(ControlType::Type, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class BlockNode: public SyntaxNode {
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
            virtual void printUsing(ostream &, unsigned);
        };

        class ValidationNode: public SyntaxNode {
        protected:
            SyntaxNode * validationExpression;
            SyntaxNode * validationRaise;
        public:
            ValidationNode(SyntaxNode *, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class RescueNode : public SyntaxNode {
        protected:
        	SyntaxNode * rescueStatement;
        	SyntaxNode * rescueException;
        public:
        	RescueNode(SyntaxNode *);
        	virtual RescueNode * setException(SyntaxNode *);
        	virtual void printUsing(ostream &, unsigned);
        };

        class VariableNode: public SyntaxNode {
        protected:
            VectorNode * variables;
        public:
            VariableNode(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ElementNode: public SyntaxNode {
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
            virtual void printUsing(ostream &, unsigned);
        };

        class ConstantNode: public SyntaxNode {
        protected:
            VectorNode * constants;
            public:
            ConstantNode(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class InterceptNode: public SyntaxNode {
        protected:
            InterceptionType::Type interceptionType;
            VectorNode * interceptionItems;
        public:
            InterceptNode(InterceptionType::Type, VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class FunctionNode: public SyntaxNode {
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
            virtual void printUsing(ostream &, unsigned);
        };

        class EventNode: public SyntaxNode {
        protected:
            SyntaxNode * eventName;
            SyntaxNode * eventIntercept;
            SyntaxNode * eventInitialValue;
        public:
            EventNode(SyntaxNode *);
            virtual EventNode * setEventIntercept(SyntaxNode *);
            virtual EventNode * setEventInitialValue(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class AttributeNode: public SyntaxNode {
        protected:
            SyntaxNode * attributeName;
            SyntaxNode * attributeReturnType;
            SyntaxNode * attributeInitialValue;
            SyntaxNode * attributeGetter;
            SyntaxNode * attributeSetter;
            SyntaxNode * attributeInvariants;
        public:
            AttributeNode(SyntaxNode *);
            virtual AttributeNode * setAttributeReturnType(SyntaxNode *);
            virtual AttributeNode * setAttributeInitialValue(SyntaxNode *);
            virtual AttributeNode * setAttributeGetter(SyntaxNode *);
            virtual AttributeNode * setAttributeSetter(SyntaxNode *);
            virtual AttributeNode * setAttributeInvariants(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class IncludeNode: public SyntaxNode {
        protected:
            SyntaxNode * includeItem;
        public:
            IncludeNode(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ClassNode: public SyntaxNode {
        protected:
            vector<SpecifierType::Type> classSpecifiers;
            SyntaxNode * className;
            VectorNode * classHeritance;
            VectorNode * classMembers;
        public:
            ClassNode(SyntaxNode *);
            virtual ClassNode * addSpecifier(SpecifierType::Type);
            virtual ClassNode * setClassHeritance(VectorNode *);
            virtual ClassNode * addMembers(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ImportNode: public SyntaxNode {
        protected:
            VectorNode * importMembers;
            SyntaxNode * importOrigin;
        public:
            ImportNode(VectorNode *);
            virtual ImportNode * setImportOrigin(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ModuleNode: public SyntaxNode {
        protected:
            SyntaxNode * moduleName;
            VectorNode * moduleStatements;
        public:
            ModuleNode(SyntaxNode *);
            virtual ModuleNode * addStatements(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

    } // SyntaxTree
} // LANG_NAMESPACE

#endif
