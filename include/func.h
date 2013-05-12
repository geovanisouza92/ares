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
 * func.h - Statements
 *
 * Defines objects used to represent functions
 *
 */

#ifndef LANG_FUNC_H
#define LANG_FUNC_H

#include "stmt.h"

namespace LANG_NAMESPACE
{
    namespace SyntaxTree
    {
        /**
         * Represents a parameter for lambda and functions
         */
        class ParameterNode : public SyntaxNode
        {
        protected:
            bool paramArray = false;
            SyntaxNode * paramType;
            SyntaxNode * paramName;
            SyntaxNode * paramDefault;
        public:
            ParameterNode(SyntaxNode *, SyntaxNode *, SyntaxNode * d = NULL);
            virtual void setParamArray() { paramArray = true; }
            virtual void print(ostream &, unsigned);
        };

        /**
         * Represents a function
         */
        class FunctionNode : public SyntaxNode
        {
        protected:
            SyntaxNode * functionName;
            VectorNode * functionParams;
            SyntaxNode * functionReturnType;
            SyntaxNode * functionBlock;
        public:
            FunctionNode(SyntaxNode *, VectorNode *);
            virtual FunctionNode * setFunctionReturn(SyntaxNode *);
            virtual FunctionNode * setBlock(SyntaxNode *);
            virtual void print(ostream &, unsigned);
        };
    } // SyntaxTree
} // LANG_NAMESPACE

#endif
