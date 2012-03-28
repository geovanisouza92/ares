/* Ares Programming Language */

#ifndef LANG_STMT_H
#define LANG_STMT_H

#include "st.h"

using namespace LANG_NAMESPACE::Enum;

namespace LANG_NAMESPACE {
    namespace SyntaxTree {

        class StatementNode: public SyntaxNode {
        public:
            virtual void printUsing(ostream &, unsigned) = 0;
        };

        class ConditionNode: public StatementNode {
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

        class CaseNode: public StatementNode {
        protected:
            SyntaxNode * caseExpression;
            VectorNode * caseWhen;
            SyntaxNode * caseElse;
        public:
            CaseNode(SyntaxNode *);
            virtual CaseNode * setWhen(VectorNode *);
            virtual CaseNode * setElse(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class WhenNode: public StatementNode {
        protected:
            SyntaxNode * whenExpression;
            SyntaxNode * whenBlock;
        public:
            WhenNode(SyntaxNode *, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ForNode: public StatementNode {
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

        class LoopNode: public StatementNode {
        protected:
            LoopType::Type loopType;
            SyntaxNode * loopExpression;
            SyntaxNode * loopBlock;
        public:
            LoopNode(LoopType::Type, SyntaxNode *, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ControlNode: public StatementNode {
        protected:
            ControlType::Type controlType;
            SyntaxNode * controlExpression;
        public:
            ControlNode(ControlType::Type);
            ControlNode(ControlType::Type, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class BlockNode: public StatementNode {
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

        class ValidationNode: public StatementNode {
        protected:
            SyntaxNode * validationExpression;
            SyntaxNode * validationRaise;
        public:
            ValidationNode(SyntaxNode *, SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class VariableNode: public StatementNode {
        protected:
            VectorNode * variables;
        public:
            VariableNode(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ElementNode: public StatementNode {
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

        class ConstantNode: public StatementNode {
        protected:
            VectorNode * constants;
            public:
            ConstantNode(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class InterceptNode: public StatementNode {
        protected:
            InterceptionType::Type interceptionType;
            VectorNode * interceptionItems;
        public:
            InterceptNode(InterceptionType::Type, VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class FunctionNode: public StatementNode {
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

        class EventNode: public StatementNode {
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

        class AttributeNode: public StatementNode {
        protected:
//            vector<SpecifierType::Type> attributeSpecifiers;
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
//            virtual AttributeNode * addSpecifier(SpecifierType::Type);
            virtual void printUsing(ostream &, unsigned);
        };

//        class IncludeNode: public StatementNode {
//        protected:
//            SyntaxNode * functionName;
//        public:
//            IncludeNode(SyntaxNode *);
//            virtual void printUsing(ostream &, unsigned);
//        };

        class ClassNode: public StatementNode {
        protected:
            vector<SpecifierType::Type> classSpecifiers;
            SyntaxNode * className;
            SyntaxNode * classHeritance;
            VectorNode * classStatements;
        public:
            ClassNode(SyntaxNode *);
            virtual ClassNode * setClassHeritance(SyntaxNode *);
            virtual ClassNode * addSpecifier(SpecifierType::Type);
            virtual ClassNode * addStatements(VectorNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ImportNode: public StatementNode {
        protected:
            VectorNode * importMembers;
            SyntaxNode * importOrigin;
        public:
            ImportNode(VectorNode *);
            virtual ImportNode * setImportOrigin(SyntaxNode *);
            virtual void printUsing(ostream &, unsigned);
        };

        class ModuleNode: public StatementNode {
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
