/* Ares Programming Language */

#ifndef LANG_CODEGEN_H
#define LANG_CODEGEN_H

#include <stack>
#include <llvm/Module.h>
#include <llvm/Function.h>
#include <llvm/LLVMContext.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include "st.h"

using namespace std;
using namespace llvm;
using namespace LANG_NAMESPACE::SyntaxTree;

namespace LANG_NAMESPACE
{
    namespace CodeGen
    {
        class CodeGenBlock
        {
        public:
            BasicBlock * block;
            map<string, Value *> locals;
        };

        class CodeGenContext
        {
        private:
            stack<CodeGenBlock *> blocks;
            Function * mainFunction;
        public:
            Module * module;
            CodeGenContext ();
            void generateCode (SyntaxNode *);
            GenericValue runCode ();
            map<string, Value *> & getCurrentLocals ();
            BasicBlock * getCurrentBlock ();
            void pushBlock (BasicBlock *);
            void popBlock ();
        };
    } // CodeGen
} // LANG_NAMESPACE

#endif
