/* Ares Programming Language */

#ifndef LANG_CODEGEN_H
#define LANG_CODEGEN_H

//#include <map>
#include <stack>

using namespace std;

#define __STDC_CONSTANT_MACROS
#define __STDC_LIMIT_MACROS
#include <llvm/Module.h>
#include <llvm/Function.h>
//#include <llvm/Type.h>
//#include <llvm/DerivedTypes.h>
#include <llvm/LLVMContext.h>
#include <llvm/ExecutionEngine/GenericValue.h>

using namespace llvm;

#include "st.hpp"

using namespace LANG_NAMESPACE::SyntaxTree;

namespace LANG_NAMESPACE {
	namespace CodeGen {

		class CodeGenBlock {
		public:
			BasicBlock * block;
			map<string, Value *> locals;
		};

		class CodeGenContext {
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

	}
}

#endif
