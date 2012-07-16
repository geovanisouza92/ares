/* Ares Programming Language */

#ifndef LANG_ENUM_H
#define LANG_ENUM_H

#include "langconfig.hpp"

#define DECLARE_ENUM_START(n,e) \
namespace n { \
  enum e { \
    FIRST = -1,
#define DECLARE_ENUM_MEMBER(x) \
    x,
#define DECLARE_ENUM_END \
    LAST \
  }; \
}

#define DECLARE_ENUM_NAMES_START(n) \
namespace n { \
  static string EnumNames[LAST] = {
#define DECLARE_ENUM_MEMBER_NAME(x) \
    x,
#define DECLARE_ENUM_NAMES_END(e) \
  }; \
  static string getEnumName(e value) { \
    return EnumNames[value]; \
  } \
}

namespace LANG_NAMESPACE {
    namespace Enum {

        DECLARE_ENUM_START(InteractionMode,Mode)
            DECLARE_ENUM_MEMBER(None)
            DECLARE_ENUM_MEMBER(Shell)
            DECLARE_ENUM_MEMBER(LineEval)
            DECLARE_ENUM_MEMBER(FileParse)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(VerboseMode,Mode)
            DECLARE_ENUM_MEMBER(Low)
            DECLARE_ENUM_MEMBER(Normal)
            DECLARE_ENUM_MEMBER(High)
            DECLARE_ENUM_MEMBER(Debug)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(FinallyAction,Action)
            DECLARE_ENUM_MEMBER(None)
            DECLARE_ENUM_MEMBER(PrintOnConsole)
            DECLARE_ENUM_MEMBER(ExecuteOnTheFly)
            DECLARE_ENUM_MEMBER(GenerateBinaries)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(JoinType,Type)
            DECLARE_ENUM_MEMBER(None)
            DECLARE_ENUM_MEMBER(Left)
            DECLARE_ENUM_MEMBER(Right)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(OrderType,Type)
            DECLARE_ENUM_MEMBER(None)
            DECLARE_ENUM_MEMBER(Asc)
            DECLARE_ENUM_MEMBER(Desc)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(RangeType,Type)
            DECLARE_ENUM_MEMBER(Skip)
            DECLARE_ENUM_MEMBER(Step)
            DECLARE_ENUM_MEMBER(Take)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(BaseOperator,Operator)
            DECLARE_ENUM_MEMBER(UnaryNot)
            DECLARE_ENUM_MEMBER(UnaryAdd)
            DECLARE_ENUM_MEMBER(UnarySub)
            DECLARE_ENUM_MEMBER(BinaryCast)
            DECLARE_ENUM_MEMBER(BinaryMul)
            DECLARE_ENUM_MEMBER(BinaryDiv)
            DECLARE_ENUM_MEMBER(BinaryMod)
            DECLARE_ENUM_MEMBER(BinaryPow)
            DECLARE_ENUM_MEMBER(BinaryAdd)
            DECLARE_ENUM_MEMBER(BinarySub)
            DECLARE_ENUM_MEMBER(BinaryShl)
            DECLARE_ENUM_MEMBER(BinaryShr)
            DECLARE_ENUM_MEMBER(BinaryLet)
            DECLARE_ENUM_MEMBER(BinaryLee)
            DECLARE_ENUM_MEMBER(BinaryGet)
            DECLARE_ENUM_MEMBER(BinaryGee)
            DECLARE_ENUM_MEMBER(BinaryEql)
            DECLARE_ENUM_MEMBER(BinaryNeq)
            DECLARE_ENUM_MEMBER(BinaryIde)
            DECLARE_ENUM_MEMBER(BinaryNid)
            DECLARE_ENUM_MEMBER(BinaryCmp)
            DECLARE_ENUM_MEMBER(BinaryMat)
            DECLARE_ENUM_MEMBER(BinaryNma)
            DECLARE_ENUM_MEMBER(BinaryIn)
            DECLARE_ENUM_MEMBER(BinaryHas)
            DECLARE_ENUM_MEMBER(BinaryRangeOut)
            DECLARE_ENUM_MEMBER(BinaryRangeIn)
            DECLARE_ENUM_MEMBER(BinaryAnd)
            DECLARE_ENUM_MEMBER(BinaryOr)
            DECLARE_ENUM_MEMBER(BinaryXor)
            DECLARE_ENUM_MEMBER(BinaryImplies)
            DECLARE_ENUM_MEMBER(BinaryAccess)
            DECLARE_ENUM_MEMBER(BinaryAssignment)
            DECLARE_ENUM_MEMBER(BinaryAde)
            DECLARE_ENUM_MEMBER(BinarySue)
            DECLARE_ENUM_MEMBER(BinaryMue)
            DECLARE_ENUM_MEMBER(BinaryDie)
            DECLARE_ENUM_MEMBER(TernaryIf)
            DECLARE_ENUM_MEMBER(TernaryBetween)
        DECLARE_ENUM_END
        DECLARE_ENUM_NAMES_START(BaseOperator)
            DECLARE_ENUM_MEMBER_NAME("UnaryNot")
            DECLARE_ENUM_MEMBER_NAME("UnaryAdd")
            DECLARE_ENUM_MEMBER_NAME("UnarySub")
            DECLARE_ENUM_MEMBER_NAME("BinaryCast")
            DECLARE_ENUM_MEMBER_NAME("BinaryMul")
            DECLARE_ENUM_MEMBER_NAME("BinaryDiv")
            DECLARE_ENUM_MEMBER_NAME("BinaryMod")
            DECLARE_ENUM_MEMBER_NAME("BinaryPow")
            DECLARE_ENUM_MEMBER_NAME("BinaryAdd")
            DECLARE_ENUM_MEMBER_NAME("BinarySub")
            DECLARE_ENUM_MEMBER_NAME("BinaryShl")
            DECLARE_ENUM_MEMBER_NAME("BinaryShr")
            DECLARE_ENUM_MEMBER_NAME("BinaryLet")
            DECLARE_ENUM_MEMBER_NAME("BinaryLee")
            DECLARE_ENUM_MEMBER_NAME("BinaryGet")
            DECLARE_ENUM_MEMBER_NAME("BinaryGee")
            DECLARE_ENUM_MEMBER_NAME("BinaryEql")
            DECLARE_ENUM_MEMBER_NAME("BinaryNeq")
            DECLARE_ENUM_MEMBER_NAME("BinaryIde")
            DECLARE_ENUM_MEMBER_NAME("BinaryNid")
            DECLARE_ENUM_MEMBER_NAME("BinaryCmp")
            DECLARE_ENUM_MEMBER_NAME("BinaryMat")
            DECLARE_ENUM_MEMBER_NAME("BinaryNma")
            DECLARE_ENUM_MEMBER_NAME("BinaryIn")
            DECLARE_ENUM_MEMBER_NAME("BinaryHas")
            DECLARE_ENUM_MEMBER_NAME("BinaryRangeOut")
            DECLARE_ENUM_MEMBER_NAME("BinaryRangeIn")
            DECLARE_ENUM_MEMBER_NAME("BinaryAnd")
            DECLARE_ENUM_MEMBER_NAME("BinaryOr")
            DECLARE_ENUM_MEMBER_NAME("BinaryXor")
            DECLARE_ENUM_MEMBER_NAME("BinaryImplies")
            DECLARE_ENUM_MEMBER_NAME("BinaryAccess")
            DECLARE_ENUM_MEMBER_NAME("BinaryAssignment")
            DECLARE_ENUM_MEMBER_NAME("BinaryAde")
            DECLARE_ENUM_MEMBER_NAME("BinarySue")
            DECLARE_ENUM_MEMBER_NAME("BinaryMue")
            DECLARE_ENUM_MEMBER_NAME("BinaryDie")
            DECLARE_ENUM_MEMBER_NAME("TernaryIf")
            DECLARE_ENUM_MEMBER_NAME("TernaryBetween")
        DECLARE_ENUM_NAMES_END(Operator)

        DECLARE_ENUM_START(NewType,Type)
            DECLARE_ENUM_MEMBER(InstanceOf)
            DECLARE_ENUM_MEMBER(AnonymousClass)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(ConditionType,Type)
            DECLARE_ENUM_MEMBER(If)
            DECLARE_ENUM_MEMBER(Unless)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(LoopType,Type)
            DECLARE_ENUM_MEMBER(ForAscending)
            DECLARE_ENUM_MEMBER(ForDescending)
            DECLARE_ENUM_MEMBER(ForIteration)
            DECLARE_ENUM_MEMBER(While)
            DECLARE_ENUM_MEMBER(Until)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(ControlType,Type)
            DECLARE_ENUM_MEMBER(Return)
            DECLARE_ENUM_MEMBER(Raise)
            DECLARE_ENUM_MEMBER(Break)
            DECLARE_ENUM_MEMBER(Yield)
            DECLARE_ENUM_MEMBER(Retry)
            DECLARE_ENUM_MEMBER(Private)
            DECLARE_ENUM_MEMBER(Protected)
            DECLARE_ENUM_MEMBER(Public)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(InterceptionType,Type)
            DECLARE_ENUM_MEMBER(After)
            DECLARE_ENUM_MEMBER(Before)
            DECLARE_ENUM_MEMBER(Signal)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(SpecifierType,Type)
            DECLARE_ENUM_MEMBER(Abstract)
            DECLARE_ENUM_MEMBER(Sealed)
            DECLARE_ENUM_MEMBER(Class)
            DECLARE_ENUM_MEMBER(Async)
        DECLARE_ENUM_END
        DECLARE_ENUM_NAMES_START(SpecifierType)
            DECLARE_ENUM_MEMBER_NAME("Abstract")
            DECLARE_ENUM_MEMBER_NAME("Sealed")
            DECLARE_ENUM_MEMBER_NAME("Class")
            DECLARE_ENUM_MEMBER_NAME("Async")
        DECLARE_ENUM_NAMES_END(Type)

        DECLARE_ENUM_START(InlineType,Type)
            DECLARE_ENUM_MEMBER(Import)
            DECLARE_ENUM_MEMBER(Include)
        DECLARE_ENUM_END

        DECLARE_ENUM_START(NodeType,Type)
            DECLARE_ENUM_MEMBER(Nil)
            DECLARE_ENUM_MEMBER(Identifier)
            DECLARE_ENUM_MEMBER(String)
            DECLARE_ENUM_MEMBER(Regex)
            DECLARE_ENUM_MEMBER(Float)
            DECLARE_ENUM_MEMBER(Integer)
            DECLARE_ENUM_MEMBER(Boolean)
            DECLARE_ENUM_MEMBER(Array)
            DECLARE_ENUM_MEMBER(HashPair)
            DECLARE_ENUM_MEMBER(Hash)
            DECLARE_ENUM_MEMBER(Expression)
        DECLARE_ENUM_END

    } // Enum
} // LANG_NAMESPACE

#endif
