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
 * codegen.h - LLVM-IR code generation
 *
 * Defines objects used to generate LLVM-IR code
 *
 */

#ifndef LANG_CODEGEN_H
#define LANG_CODEGEN_H

#include <stack>
#include <llvm/Module.h>
#include <llvm/Function.h>
#include <llvm/LLVMContext.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include "ast.h"

using namespace std;
using namespace llvm;
using namespace LANG_NAMESPACE::SyntaxTree;

namespace LANG_NAMESPACE
{
    namespace CodeGen
    {
    	/**
    	 * Represents a block of expression-content pairs
    	 */
        class CodeGenBlock
        {
        public:
            BasicBlock * block;
            map<string, Value *> locals;
        };

        /**
         * Represents a code generation context
         */
        class CodeGenContext
        {
        private:
            stack<CodeGenBlock *> blocks;
            Function * mainFunction;
        public:
            Module * module;
            CodeGenContext();
            void generateCode(SyntaxNode *);
            GenericValue runCode();
            map<string, Value *> & getCurrentLocals();
            BasicBlock * getCurrentBlock();
            void pushBlock(BasicBlock *);
            void popBlock();
        };
    } // CodeGen
} // LANG_NAMESPACE

#endif
