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
 * func.cpp - Statements
 *
 * Implements objects used to represent functions
 *
 */

#include "func.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        ParameterNode::ParameterNode(SyntaxNode * t, SyntaxNode * n, SyntaxNode * d)
            : paramType(t), paramName(n), paramDefault(d)
        {
            setNodeType(NodeType::Null);
        }

        void
        ParameterNode::print(ostream & out, unsigned d)
        {
            TAB(d) << "parameter" << endl;
            paramName->print(out, d + 1);
            TAB(d) << "of type" << endl;
            paramType->print(out, d + 1);
            if (paramDefault)
            {
                TAB(d) << "default value" << endl;
                paramDefault->print(out, d + 1);
            }
        }

        FunctionNode::FunctionNode(SyntaxNode * n, VectorNode * p)
            : functionName(n), functionParams(p), functionReturnType(NULL),
              functionBlock(NULL)//, functionIntercept(NULL)
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
        FunctionNode::setBlock(SyntaxNode * s)
        {
            functionBlock = s;
            return this;
        }

        void
        FunctionNode::print(ostream & out, unsigned d)
        {
            if(functionParams->size() > 0) {
                TAB(d + 1) << "Method with parameters" << endl;
                for (auto param = functionParams->begin(); param < functionParams-> end(); param++) {
                    (*param)->print(out, d + 2);
                }
            } else
                TAB(d) << "Method without parameters" << endl;
            if(functionReturnType) {
                TAB(d + 1) << "returns" << endl;
                functionReturnType->print(out, d + 2);
            }
            TAB(d + 1) << "name" << endl;
            functionName->print(out, d + 2);
            if(functionBlock) {
                TAB(d) << "block" << endl;
                functionBlock->print(out, d + 1);
            }
        }
    } // SyntaxTree
} // LANG_NAMESPACE
