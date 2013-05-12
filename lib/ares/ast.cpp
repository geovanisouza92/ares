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

        Empty::Empty()
        {
            setNodeType(NodeType::Empty);
        }

        void
        Empty::print(ostream & out, unsigned d)
        {
            TAB(d) << "𝛆" << endl;
        }

        void
        VectorNode::print(ostream & out, unsigned d)
        {
            throw "Impossible print a vector";
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
        Environment::push_back(VectorNode * v)
        {
            for (auto stmt = v->begin(); stmt < v->end(); stmt++)
                statements->push_back(*stmt);
            return this;
        }

        void
        Environment::print(ostream & out, unsigned d)
        {
            for (auto stmt = statements->begin(); stmt < statements->end(); stmt++)
                (*stmt)->print(out, 0);
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
            for (auto elem = value->begin(); elem < value->end(); elem++) {
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
            for (auto elem = value->begin(); elem < value->end(); elem++) {
                (*elem)->print(out, d + 1);
                if(elem != value->end() - 1) TAB(d + 2) << ", " << endl;
            }
            TAB(d) << "}" << endl;
        }

        IdNode::IdNode(string * i)
        {
            setNodeType(NodeType::Identifier);
            id = new vector<string *>();
            AddId(i);
        }

        void
        IdNode::AddId(string * i)
        {
            id->push_back(i);
        }

        void
        IdNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Identifier => ";
            for (auto i = 0; i < id->size(); i++)
            {
                out << *(id->at(i));
                if (i < id->size() - 1)
                    out << ".";
            }
            out << endl;
        }

        // PointerTypeNode::PointerTypeNode(SyntaxNode * value) : type(value) { }

        // void
        // PointerTypeNode::print(ostream & out, unsigned d)
        // {
        //     TAB(d) << "Pointer => " << endl;
        //     type->print(out, d + 2);
        // }

        Type::Type() : type("var")
        {
            setNodeType(NodeType::Null);
        }

        Type::Type(string ty) : type(ty)
        {
            setNodeType(NodeType::Null);
        }

        void
        Type::print(ostream & out, unsigned d)
        {
            TAB(d) << type << endl;
        }

        ArrayTypeNode::ArrayTypeNode(SyntaxNode * ty, unsigned dim)
        {
            type = ((Type *)ty)->type;
            dimension = dim;
        }

        void
        ArrayTypeNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "Array type of " << type << " with dimension " << dimension << endl;
        }

        RankSpecifierNode::RankSpecifierNode()
        {
            setNodeType(NodeType::Null);
        }

        void
        RankSpecifierNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "[]";
        }
    } // SyntaxTree
} // LANG_NAMESPACE
