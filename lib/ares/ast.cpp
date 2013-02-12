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
 * ast.cpp - Abstract Syntax Tree
 *
 * Implements objects used to represent all AST nodes
 *
 */

#include "ast.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        SyntaxNode::~SyntaxNode() { }

        NodeType::Type
        SyntaxNode::getNodeType()
        {
            return nodeType;
        }

        void
        SyntaxNode::setNodeType(NodeType::Type t)
        {
            nodeType = t;
        }

        Environment::Environment(Environment * p)
            : parent(p), statements(new VectorNode()) { }

        Environment::~Environment() { }

        Environment *
        Environment::clear()
        {
            statements->clear();
            return this;
        }

        Environment *
        Environment::push(VectorNode * v)
        {
            for(VectorNode::iterator stmt = v->begin(); stmt < v->end(); stmt++)
                statements->push_back(*stmt);
            return this;
        }

        void
        Environment::print(ostream & out, unsigned d)
        {
            for(VectorNode::iterator stmt = statements->begin(); stmt < statements->end(); stmt++)
            {
                out << *stmt << endl;
                // (*stmt)->print(out, 0);
            }
        }

        NullLiteralNode::NullLiteralNode()
        {
            setNodeType(NodeType::Null);
        }

        void
        NullLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Null" << endl;
        }

        IntegerLiteralNode::IntegerLiteralNode(int v)
            : value(v)
        {
            setNodeType(NodeType::Integer);
        }

        void
        IntegerLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Integer => " << value << endl;
        }

        FloatLiteralNode::FloatLiteralNode(double v)
            : value(v)
        {
            setNodeType(NodeType::Float);
        }

        void
        FloatLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Float => " << value << endl;
        }

        CharLiteralNode::CharLiteralNode(char v)
            : value(v)
        {
            setNodeType(NodeType::Char);
        }

        void
        CharLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Char => " << value << endl;
        }

        StringLiteralNode::StringLiteralNode(string v)
            : value(v)
        {
            setNodeType(NodeType::String);
        }

        void
        StringLiteralNode::append(string v)
        {
            value += v;
        }

        void
        StringLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "String => " << value << endl;
        }

        RegexLiteralNode::RegexLiteralNode(string v)
            : value(v)
        {
            setNodeType(NodeType::Regex);
        }

        void
        RegexLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Regex => " << value << endl;
        }

        BooleanLiteralNode::BooleanLiteralNode(bool v)
            : value(v)
        {
            setNodeType(NodeType::Boolean);
        }

        void
        BooleanLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Boolean => " <<(value ? "True" : "False") << endl;
        }

        ArrayLiteralNode::ArrayLiteralNode()
            : value(new VectorNode())
        {
            setNodeType(NodeType::Array);
        }

        ArrayLiteralNode::ArrayLiteralNode(VectorNode * v)
            : value(v)
        {
            setNodeType(NodeType::Array);
        }

        void
        ArrayLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Array => [" << endl;
            for(VectorNode::iterator elem = value->begin(); elem < value->end(); elem++) {
               (*elem)->print(out, d + 1);
                if(elem != value->end() - 1) TAB(d + 2) << ", " << endl;
            }
            TAB(d) << "]" << endl;
        }

        PairNode::PairNode(SyntaxNode * k, SyntaxNode * v)
            : key(k), value(v)
        {
            setNodeType(NodeType::HashPair);
        }

        void
        PairNode::print(ostream & out, unsigned d)
        {
            key->print(out, d + 1);
            TAB(d + 1) << "^" << endl;
            value->print(out, d + 1);
        }

        HashLiteralNode::HashLiteralNode() : value(new VectorNode())
        {
            setNodeType(NodeType::Hash);
        }

        HashLiteralNode::HashLiteralNode(VectorNode * v)
            : value(v)
        {
            setNodeType(NodeType::Hash);
        }

        void
        HashLiteralNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Hash => {" << endl;
            for(VectorNode::iterator elem = value->begin(); elem < value->end(); elem++) {
               (*elem)->print(out, d + 1);
                if(elem != value->end() - 1) TAB(d + 2) << ", " << endl;
            }
            TAB(d) << "}" << endl;
        }

        PointerNode::PointerNode(SyntaxNode * value) : type(value) { }

        void
        PointerNode::print(ostream & out, unsigned d)
        {
        	TAB(d) << "Pointer => " << endl;
        	type->print(out, d + 2);
        }

        IdNode::IdNode(string v)
            : id(v)
        {
            setNodeType(NodeType::Identifier);
        }

        void
        IdNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Identifier => " << id << endl;
        }

        Type::Type(string ty) : type(ty) { }

        void
        Type::print(ostream & out, unsigned d)
        {
            TAB(d) << type << endl;
        }

        void
        UnaryExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Unary expression [ " << op << " ] =>" << endl;
            member1->print(out, d + 1);
        }

        UnaryExpressionNode::UnaryExpressionNode(Operator::Unary op, SyntaxNode * m1)
            : op(op), member1(m1)
        {
            setNodeType(NodeType::Null);
        }

        UnaryExpressionNode::UnaryExpressionNode(Operator::Unary op, VectorNode * m1)
            : op(op), vector1(m1)
        {
            setNodeType(NodeType::Null);
        }

        BinaryExpressionNode::BinaryExpressionNode(Operator::Binary op, SyntaxNode * m1, SyntaxNode * m2)
            : op(op), member1(m1), member2(m2)
        {
            setNodeType(NodeType::Null);
        }

        void
        BinaryExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Binary expression [ " << op << " ] =>" << endl;
            member1->print(out, d + 1);
            member2->print(out, d + 1);
        }

        TernaryExpressionNode::TernaryExpressionNode(Operator::Ternary op, SyntaxNode *m1, SyntaxNode *m2, SyntaxNode *m3)
            : op(op), member1(m1), member2(m2), member3(m3)
        {
            setNodeType(NodeType::Null);
        }

        void
        TernaryExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Ternary expression [ " << op << " ] =>" << endl;
            member1->print(out, d + 1);
            member2->print(out, d + 1);
            member3->print(out, d + 1);
        }

        FunctionInvocationNode::FunctionInvocationNode(SyntaxNode * n)
            : functionName(n), functionArguments(new VectorNode())
        {
            setNodeType(NodeType::Null);
        }

        FunctionInvocationNode::FunctionInvocationNode(SyntaxNode * n, VectorNode * a)
            : functionName(n), functionArguments(a)
        {
            setNodeType(NodeType::Null);
        }

        void
        FunctionInvocationNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Function call for =>" << endl;
            functionName->print(out, d + 1);
            if(functionArguments->size() > 0) {
                TAB(d + 1) << "with arguments(" << endl;
                for(VectorNode::iterator arg = functionArguments->begin(); arg < functionArguments->end(); arg++) {
                   (*arg)->print(out, d + 2);
                    if(arg != functionArguments->end() - 1) TAB(d + 2) << ", " << endl;
                }
                TAB(d) << ")" << endl;
            }
        }

        LambdaExpressionNode::LambdaExpressionNode(VectorNode * a, SyntaxNode * e)
            : lambdaArguments(a), lambdaExpression(e) { }

        void
        LambdaExpressionNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Lambda expression ";
            if(lambdaArguments->size() > 0) {
                out << "with arguments(" << endl;
                for(VectorNode::iterator arg = lambdaArguments->begin(); arg < lambdaArguments->end(); arg++) {
                   (*arg)->print(out, d + 1);
                    if(arg != lambdaArguments->end() - 1) TAB(d + 2) << ", " << endl;
                }
                TAB(d) << ") ";
            }
            out << "using expression =>" << endl;
            lambdaExpression->print(out, d + 1);
        }
    } // SyntaxTree
} // LANG_NAMESPACE
