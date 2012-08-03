/* Ares Programming Language */

#ifndef LANG_ENUM_H
#define LANG_ENUM_H

#include <string>
#include "langconfig.h"

using namespace std;

#define ENUM_START(n,e) \
namespace n \
{ \
  enum e \
  { \
    FIRST = -0x1,
#define ENUM_MEMBER(x) \
    x,
#define ENUM_END \
    LAST \
  }; \
}

#define ENUM_NAMES_START(n) \
namespace n \
{ \
  static string EnumNames[LAST] = {
#define ENUM_MEMBER_NAME(x) \
    x,
#define ENUM_NAMES_END(e) \
  }; \
  static string getEnumName(e value) \
  { \
    return EnumNames[value]; \
  } \
}

namespace LANG_NAMESPACE
{
    namespace Enum
    {
        ENUM_START(InteractionMode,Mode)
            ENUM_MEMBER(None)
            ENUM_MEMBER(Shell)
            ENUM_MEMBER(LineEval)
            ENUM_MEMBER(FileParse)
        ENUM_END

        ENUM_START(VerboseMode,Mode)
            ENUM_MEMBER(Low)
            ENUM_MEMBER(Normal)
            ENUM_MEMBER(High)
            ENUM_MEMBER(Debug)
        ENUM_END

        ENUM_START(FinallyAction,Action)
            ENUM_MEMBER(None)
            ENUM_MEMBER(PrintOnConsole)
            ENUM_MEMBER(ExecuteOnTheFly)
            ENUM_MEMBER(GenerateBinaries)
        ENUM_END

        ENUM_START(JoinType,Type)
            ENUM_MEMBER(None)
            ENUM_MEMBER(Left)
            ENUM_MEMBER(Right)
        ENUM_END

        ENUM_START(OrderType,Type)
            ENUM_MEMBER(None)
            ENUM_MEMBER(Asc)
            ENUM_MEMBER(Desc)
        ENUM_END

        ENUM_START(RangeType,Type)
            ENUM_MEMBER(Skip)
            ENUM_MEMBER(Step)
            ENUM_MEMBER(Take)
        ENUM_END

        ENUM_START(BasicOperator,Operator)
            ENUM_MEMBER(UnaryNot)
            ENUM_MEMBER(UnaryAdd)
            ENUM_MEMBER(UnarySub)
            ENUM_MEMBER(BinaryCast)
            ENUM_MEMBER(BinaryMul)
            ENUM_MEMBER(BinaryDiv)
            ENUM_MEMBER(BinaryMod)
            ENUM_MEMBER(BinaryPow)
            ENUM_MEMBER(BinaryAdd)
            ENUM_MEMBER(BinarySub)
            ENUM_MEMBER(BinaryShl)
            ENUM_MEMBER(BinaryShr)
            ENUM_MEMBER(BinaryLet)
            ENUM_MEMBER(BinaryLee)
            ENUM_MEMBER(BinaryGet)
            ENUM_MEMBER(BinaryGee)
            ENUM_MEMBER(BinaryEql)
            ENUM_MEMBER(BinaryNeq)
            ENUM_MEMBER(BinaryIde)
            ENUM_MEMBER(BinaryNid)
            ENUM_MEMBER(BinaryCmp)
            ENUM_MEMBER(BinaryMat)
            ENUM_MEMBER(BinaryNma)
            ENUM_MEMBER(BinaryIn)
            ENUM_MEMBER(BinaryHas)
            ENUM_MEMBER(BinaryRangeOut)
            ENUM_MEMBER(BinaryRangeIn)
            ENUM_MEMBER(BinaryAnd)
            ENUM_MEMBER(BinaryOr)
            ENUM_MEMBER(BinaryXor)
            ENUM_MEMBER(BinaryImplies)
            ENUM_MEMBER(BinaryAccess)
            ENUM_MEMBER(BinaryAssignment)
            ENUM_MEMBER(BinaryAde)
            ENUM_MEMBER(BinarySue)
            ENUM_MEMBER(BinaryMue)
            ENUM_MEMBER(BinaryDie)
            ENUM_MEMBER(TernaryIf)
            ENUM_MEMBER(TernaryBetween)
        ENUM_END
        ENUM_NAMES_START(BasicOperator)
            ENUM_MEMBER_NAME("UnaryNot")
            ENUM_MEMBER_NAME("UnaryAdd")
            ENUM_MEMBER_NAME("UnarySub")
            ENUM_MEMBER_NAME("BinaryCast")
            ENUM_MEMBER_NAME("BinaryMul")
            ENUM_MEMBER_NAME("BinaryDiv")
            ENUM_MEMBER_NAME("BinaryMod")
            ENUM_MEMBER_NAME("BinaryPow")
            ENUM_MEMBER_NAME("BinaryAdd")
            ENUM_MEMBER_NAME("BinarySub")
            ENUM_MEMBER_NAME("BinaryShl")
            ENUM_MEMBER_NAME("BinaryShr")
            ENUM_MEMBER_NAME("BinaryLet")
            ENUM_MEMBER_NAME("BinaryLee")
            ENUM_MEMBER_NAME("BinaryGet")
            ENUM_MEMBER_NAME("BinaryGee")
            ENUM_MEMBER_NAME("BinaryEql")
            ENUM_MEMBER_NAME("BinaryNeq")
            ENUM_MEMBER_NAME("BinaryIde")
            ENUM_MEMBER_NAME("BinaryNid")
            ENUM_MEMBER_NAME("BinaryCmp")
            ENUM_MEMBER_NAME("BinaryMat")
            ENUM_MEMBER_NAME("BinaryNma")
            ENUM_MEMBER_NAME("BinaryIn")
            ENUM_MEMBER_NAME("BinaryHas")
            ENUM_MEMBER_NAME("BinaryRangeOut")
            ENUM_MEMBER_NAME("BinaryRangeIn")
            ENUM_MEMBER_NAME("BinaryAnd")
            ENUM_MEMBER_NAME("BinaryOr")
            ENUM_MEMBER_NAME("BinaryXor")
            ENUM_MEMBER_NAME("BinaryImplies")
            ENUM_MEMBER_NAME("BinaryAccess")
            ENUM_MEMBER_NAME("BinaryAssignment")
            ENUM_MEMBER_NAME("BinaryAde")
            ENUM_MEMBER_NAME("BinarySue")
            ENUM_MEMBER_NAME("BinaryMue")
            ENUM_MEMBER_NAME("BinaryDie")
            ENUM_MEMBER_NAME("TernaryIf")
            ENUM_MEMBER_NAME("TernaryBetween")
        ENUM_NAMES_END(Operator)

        ENUM_START(ConditionType,Type)
            ENUM_MEMBER(If)
            ENUM_MEMBER(Unless)
        ENUM_END

        ENUM_START(LoopType,Type)
            ENUM_MEMBER(For)
            ENUM_MEMBER(Foreach)
            ENUM_MEMBER(While)
            ENUM_MEMBER(DoWhile)
        ENUM_END

        ENUM_START(ControlType,Type)
            ENUM_MEMBER(Return)
            ENUM_MEMBER(Break)
            ENUM_MEMBER(Yield)
        ENUM_END

        ENUM_START(SpecifierType,Type)
            ENUM_MEMBER(Abstract)
            ENUM_MEMBER(Sealed)
            ENUM_MEMBER(Class)
            ENUM_MEMBER(Async)
        ENUM_END
        ENUM_NAMES_START(SpecifierType)
            ENUM_MEMBER_NAME("Abstract")
            ENUM_MEMBER_NAME("Sealed")
            ENUM_MEMBER_NAME("Class")
            ENUM_MEMBER_NAME("Async")
        ENUM_NAMES_END(Type)

        ENUM_START(NodeType,Type)
            ENUM_MEMBER(Null)
            ENUM_MEMBER(Identifier)
            ENUM_MEMBER(Char)
            ENUM_MEMBER(String)
            ENUM_MEMBER(Regex)
            ENUM_MEMBER(Float)
            ENUM_MEMBER(Integer)
            ENUM_MEMBER(Boolean)
            ENUM_MEMBER(Array)
            ENUM_MEMBER(HashPair)
            ENUM_MEMBER(Hash)
            ENUM_MEMBER(Expression)
        ENUM_END
    } // Enum
} // LANG_NAMESPACE

#endif
