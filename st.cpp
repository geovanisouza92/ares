/* Ares Programming Language */

#include <string>
#include <ostream>

#include "st.h"

namespace LANG_NAMESPACE {
    namespace SyntaxTree {

        SyntaxNode::~SyntaxNode() { }

        NodeType::Type
        SyntaxNode::getNodeType() {
            return nodeType;
        }

        void
        SyntaxNode::setNodeType(NodeType::Type t) {
            nodeType = t;
        }

        Environment::Environment(Environment * p) : previous(p), statements(new VectorNode()) { }

        Environment::~Environment() {
        }

        Environment *
        Environment::clear() {
            statements->clear();
            return this;
        }

        Environment *
        Environment::putStatements(VectorNode * v) {
            for (VectorNode::iterator stmt = v->begin(); stmt < v->end(); stmt++)
                statements->push_back(*stmt);
            return this;
        }

        void Environment::printUsing(ostream & out, unsigned d) {
            for (VectorNode::iterator stmt = statements->begin(); stmt < statements->end(); stmt++)
                (*stmt)->printUsing(out, 0);
        }

        NilNode::NilNode() {
        	setNodeType(NodeType::Nil);
        }

        void NilNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Nil" << endl;
        }

        IdentifierNode::IdentifierNode(string v) : value(v) {
            setNodeType(NodeType::Identifier);
        }

        void IdentifierNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Identifier => " << value << endl;
        }

        StringNode::StringNode(string v) :
                value(v) {
            setNodeType(NodeType::String);
        }

        void StringNode::append(string v) {
            value += v;
        }

        void StringNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "String => " << value << endl;
        }

        RegexNode::RegexNode(string v) : value(v) {
            setNodeType(NodeType::Regex);
        }

        void RegexNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Regex => " << value << endl;
        }

        FloatNode::FloatNode(double v) : value(v) {
            setNodeType(NodeType::Float);
        }

        void FloatNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Float => " << value << endl;
        }

        IntegerNode::IntegerNode(int v) : value(v) {
            setNodeType(NodeType::Integer);
        }

        void IntegerNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Integer => " << value << endl;
        }

        BooleanNode::BooleanNode(bool v) : value(v) {
            setNodeType(NodeType::Boolean);
        }

        void BooleanNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Boolean => " << (value ? "True" : "False") << endl;
        }

        ArrayNode::ArrayNode() : value(new VectorNode()) {
            setNodeType(NodeType::Array);
        }

        ArrayNode::ArrayNode(VectorNode * v) : value(v) {
            setNodeType(NodeType::Array);
        }

        void ArrayNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Array => [" << endl;
            for (VectorNode::iterator elem = value->begin(); elem < value->end(); elem++) {
                (*elem)->printUsing(out, d + 1);
                TAB(d + 1) << ((elem != value->end() - 1) ? ", " : " ") << endl;
            }
            TAB(d) << "]" << endl;
        }

        HashPairNode::HashPairNode(SyntaxNode * k, SyntaxNode * v) : pairKey(k), pairValue(v) {
            setNodeType(NodeType::HashPair);
        }

        void HashPairNode::printUsing(ostream & out, unsigned d) {
            pairKey->printUsing(out, d + 1);
            TAB(d + 1) << "^" << endl;
            pairValue->printUsing(out, d + 1);
        }

        HashNode::HashNode() : value(new VectorNode()) {
            setNodeType(NodeType::Hash);
        }

        HashNode::HashNode(VectorNode * v) : value(v) {
            setNodeType(NodeType::Hash);
        }

        void HashNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Hash => {" << endl;
            for (VectorNode::iterator elem = value->begin(); elem < value->end(); elem++) {
                (*elem)->printUsing(out, d + 1);
                TAB(d + 1) << ((elem != value->end() - 1) ? ", " : " ") << endl;
            }
            TAB(d) << "}" << endl;
        }

        NewNode::NewNode(NewType::Type t, SyntaxNode * i) : newType(t), newInstanceOf(i) { }

        NewNode::NewNode(NewType::Type t, VectorNode * n) : newType(t), newAnonymousClass(n) { }

        void
        NewNode::printUsing(ostream & out, unsigned d) {
            switch(newType) {
            case NewType::InstanceOf:
                TAB(d) << "New instance of =>" << endl;
                newInstanceOf->printUsing(out, d + 1);
                break;
            case NewType::AnonymousClass:
                TAB(d) << "New anonymous class with attributes =>" << endl;
                for (VectorNode::iterator pair = newAnonymousClass->begin(); pair < newAnonymousClass->end(); pair++) {
                    (*pair)->printUsing(out, d + 1);
                }
                break;
            }
        }

        void UnaryNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Unary expression [ " << BaseOperator::getEnumName(op) << " ] =>" << endl;
            member1->printUsing(out, d + 1);
        }

        UnaryNode::UnaryNode(BaseOperator::Operator op, SyntaxNode * m1) : op(op), member1(m1) {
            setNodeType(NodeType::Nil);
        }

        UnaryNode::UnaryNode(BaseOperator::Operator op, VectorNode * m1) : op(op), vector1(m1) {
            setNodeType(NodeType::Nil);
        }

        BinaryNode::BinaryNode(BaseOperator::Operator op, SyntaxNode * m1, SyntaxNode * m2) : op(op), member1(m1), member2(m2) {
            setNodeType(NodeType::Nil);
        }

        void BinaryNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Binary expression [ " << BaseOperator::getEnumName(op) << " ] =>" << endl;
            member1->printUsing(out, d + 1);
            member2->printUsing(out, d + 1);
        }

        TernaryNode::TernaryNode(BaseOperator::Operator op, SyntaxNode *m1, SyntaxNode *m2, SyntaxNode *m3) : op(op), member1(m1), member2(m2), member3(m3) {
            setNodeType(NodeType::Nil);
        }

        void TernaryNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Ternary expression [ " << BaseOperator::getEnumName(op) << " ] =>" << endl;
            member1->printUsing(out, d + 1);
            member2->printUsing(out, d + 1);
            member3->printUsing(out, d + 1);
        }

        FunctionCallNode::FunctionCallNode(SyntaxNode * n) : functionName(n), functionArguments(new VectorNode()) {
            setNodeType(NodeType::Nil);
        }

        FunctionCallNode::FunctionCallNode(SyntaxNode * n, VectorNode * a) : functionName(n), functionArguments(a) {
            setNodeType(NodeType::Nil);
        }

        void FunctionCallNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Function call for [" << endl;
            functionName->printUsing(out, d + 1);
            if (functionArguments->size() > 0) {
                TAB(d) << "] with arguments (" << endl;
                for (VectorNode::iterator arg = functionArguments->begin(); arg < functionArguments->end(); arg++) {
                    (*arg)->printUsing(out, d + 1);
                    TAB(d + 1) << ((arg != functionArguments->end() - 1) ? ", " : " ") << endl;
                }
                TAB(d) << ")" << endl;
            } else
                TAB(d) << "] without arguments" << endl;
        }

        LambdaNode::LambdaNode(VectorNode * a, SyntaxNode * e) : lambdaArguments(a), lambdaExpression(e) { }

        void LambdaNode::printUsing(ostream & out, unsigned d) {
            TAB(d) << "Lambda expression ";
            if (lambdaArguments->size() > 0) {
                out << "with arguments (" << endl;
                for (VectorNode::iterator arg = lambdaArguments->begin(); arg < lambdaArguments->end(); arg++) {
                    (*arg)->printUsing(out, d + 1);
                    TAB(d + 1) << ((arg != lambdaArguments->end() - 1) ? ", " : " ") << endl;
                }
                TAB(d) << ") " << endl;
            } else
                out << "without arguments ";
            out << "using expression =>" << endl;
            lambdaExpression->printUsing(out, d + 1);
        }

        AsyncNode::AsyncNode(SyntaxNode * i) : asyncItem(i) { }

        void
        AsyncNode::printUsing(ostream & out, unsigned d) {
        	TAB(d) << "Async =>" << endl;
        	asyncItem->printUsing(out, d + 1);
        }

    } // SyntaxTree
} // LANG_NAMESPACE
