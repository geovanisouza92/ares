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
 * codegen.cpp - LLVM-IR code generation
 *
 * Implements objects used to generate LLVM-IR code
 *
 */

#include "codegen.h"

namespace LANG_NAMESPACE
{
    namespace CodeGen
    {
        CodeGenContext::CodeGenContext()
        {
            module = new Module("main", getGlobalContext());
            blocks = new stack<CodeGenBlock *>();
        }

        void
        CodeGenContext::generateCode(SyntaxNode * root)
        {
            // TODO Implementar
        }

        GenericValue
        CodeGenContext::runCode()
        {
            // TODO Implementar
            return GenericValue();
        }

        map<string, Value *> &
        CodeGenContext::getCurrentLocals()
        {
            return blocks->top()->locals;
        }

        BasicBlock *
        CodeGenContext::getCurrentBlock()
        {
            return blocks->top()->block;
        }

        void
        CodeGenContext::pushBlock(BasicBlock * b)
        {
            blocks->push(new CodeGenBlock());
            blocks->top()->block = b;
        }

        void
        CodeGenContext::popBlock()
        {
            CodeGenBlock * top = blocks->top();
            blocks->pop();
            delete top;
        }

        /*
         * Compile the AST into a module

        void CodeGenContext::generateCode(NBlock& root)
        {
            std::cout << "Generating code...\n";

            // Create the top level interpreter function to call as entry
            vector<const Type*> argTypes;
            FunctionType *ftype = FunctionType::get(Type::getVoidTy(getGlobalContext()), argTypes, false);
            mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", module);
            BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", mainFunction, 0);

            // Push a new variable/block context
            pushBlock(bblock);
            root.codeGen(*this); // emit bytecode for the toplevel block
            ReturnInst::Create(getGlobalContext(), bblock);
            popBlock();

            // Print the bytecode in a human-readable format to see if our program compiled properly
            std::cout << "Code is generated.\n";
            PassManager pm;
            pm.add(createPrintModulePass(&outs()));
            pm.run(*module);
        }

        // Executes the AST by running the main function
        GenericValue CodeGenContext::runCode() {
            std::cout << "Running code...\n";
            ExistingModuleProvider *mp = new ExistingModuleProvider(module);
            ExecutionEngine *ee = ExecutionEngine::create(mp, false);
            vector<GenericValue> noargs;
            GenericValue v = ee->runFunction(mainFunction, noargs);
            std::cout << "Code was run.\n";
            return v;
        }

        // Returns an LLVM type based on the identifier
        static const Type *typeOf(const NIdentifier& type)
        {
            if(type.name.compare("int") == 0) {
                return Type::getInt64Ty(getGlobalContext());
            }
            else if(type.name.compare("double") == 0) {
                return Type::getDoubleTy(getGlobalContext());
            }
            return Type::getVoidTy(getGlobalContext());
        }

        // -- Code Generation --

        Value* NInteger::codeGen(CodeGenContext& context)
        {
            std::cout << "Creating integer: " << value << endl;
            return ConstantInt::get(Type::getInt64Ty(getGlobalContext()), value, true);
        }

        Value* NDouble::codeGen(CodeGenContext& context)
        {
            std::cout << "Creating double: " << value << endl;
            return ConstantFP::get(Type::getDoubleTy(getGlobalContext()), value);
        }

        Value* NIdentifier::codeGen(CodeGenContext& context)
        {
            std::cout << "Creating identifier reference: " << name << endl;
            if(context.locals().find(name) == context.locals().end()) {
                std::cerr << "undeclared variable " << name << endl;
                return NULL;
            }
            return new LoadInst(context.locals()[name], "", false, context.currentBlock());
        }

        Value* NMethodCall::codeGen(CodeGenContext& context)
        {
            Function *function = context.module->getFunction(id.name.c_str());
            if(function == NULL) {
                std::cerr << "no such function " << id.name << endl;
            }
            std::vector<Value*> args;
            ExpressionList::const_iterator it;
            for(it = arguments.begin(); it != arguments.end(); it++) {
                args.push_back((**it).codeGen(context));
            }
            CallInst *call = CallInst::Create(function, args.begin(), args.end(), "", context.currentBlock());
            std::cout << "Creating method call: " << id.name << endl;
            return call;
        }

        Value* NBinaryOperator::codeGen(CodeGenContext& context)
        {
            std::cout << "Creating binary operation " << op << endl;
            Instruction::BinaryOps instr;
            switch(op) {
                case TPLUS:     instr = Instruction::Add; goto math;
                case TMINUS:    instr = Instruction::Sub; goto math;
                case TMUL:      instr = Instruction::Mul; goto math;
                case TDIV:      instr = Instruction::SDiv; goto math;

                // TODO comparison
            }

            return NULL;
        math:
            return BinaryOperator::Create(instr, lhs.codeGen(context),
                rhs.codeGen(context), "", context.currentBlock());
        }

        Value* NAssignment::codeGen(CodeGenContext& context)
        {
            std::cout << "Creating assignment for " << lhs.name << endl;
            if(context.locals().find(lhs.name) == context.locals().end()) {
                std::cerr << "undeclared variable " << lhs.name << endl;
                return NULL;
            }
            return new StoreInst(rhs.codeGen(context), context.locals()[lhs.name], false, context.currentBlock());
        }

        Value* NBlock::codeGen(CodeGenContext& context)
        {
            StatementList::const_iterator it;
            Value *last = NULL;
            for(it = statements.begin(); it != statements.end(); it++) {
                std::cout << "Generating code for " << typeid(**it).name() << endl;
                last =(**it).codeGen(context);
            }
            std::cout << "Creating block" << endl;
            return last;
        }

        Value* NExpressionStatement::codeGen(CodeGenContext& context)
        {
            std::cout << "Generating code for " << typeid(expression).name() << endl;
            return expression.codeGen(context);
        }

        Value* NVariableDeclaration::codeGen(CodeGenContext& context)
        {
            std::cout << "Creating variable declaration " << type.name << " " << id.name << endl;
            AllocaInst *alloc = new AllocaInst(typeOf(type), id.name.c_str(), context.currentBlock());
            context.locals()[id.name] = alloc;
            if(assignmentExpr != NULL) {
                NAssignment assn(id, *assignmentExpr);
                assn.codeGen(context);
            }
            return alloc;
        }

        Value* NFunctionDeclaration::codeGen(CodeGenContext& context)
        {
            vector<const Type*> argTypes;
            VariableList::const_iterator it;
            for(it = arguments.begin(); it != arguments.end(); it++) {
                argTypes.push_back(typeOf((**it).type));
            }
            FunctionType *ftype = FunctionType::get(typeOf(type), argTypes, false);
            Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, id.name.c_str(), context.module);
            BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", function, 0);

            context.pushBlock(bblock);

            for(it = arguments.begin(); it != arguments.end(); it++) {
               (**it).codeGen(context);
            }

            block.codeGen(context);
            ReturnInst::Create(getGlobalContext(), bblock);

            context.popBlock();
            std::cout << "Creating function: " << id.name << endl;
            return function;
        }

        */
    } // CodeGen
} // LANG_NAMESPACE
