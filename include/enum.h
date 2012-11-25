/** Ares Programming Language
 *
 * enum.h - Enumeration for virtual platform
 *
 * Defines enumeration used on virtual platform
 */

#ifndef LANG_ENUM_H
#define LANG_ENUM_H

#include <string>
#include "config.h"

namespace LANG_NAMESPACE
{
	namespace Enum
	{
		/**
		 * Defines the virtual platform interaction mode
		 */
		namespace InteractionMode
		{
			enum Mode {
				None,
				Shell,
				LineEval,
				FileParse
			};
		}

		/**
		 * Defines the verbose level of output
		 */
		namespace VerboseMode
		{
			enum Mode
			{
				Low,
				Normal,
				High,
				Debug
			};
		}

		/**
		 * Defines the final destiny of code on platform
		 */
		namespace FinallyAction
		{
			enum Action
			{
				None,
				PrintOnConsole,
				ExecuteOnTheFly,
				GenerateBinaries
			};
		}

		/**
		 * Defines the type of join on OQL expression
		 */
		namespace JoinType
		{
			enum Type
			{
				None,
				Left,
				Right
			};
		}

		/**
		 * Defines the direction of ordering on OQL expression
		 */
		namespace OrderType
		{
			enum Type
			{
				None,
				Asc,
				Desc
			};
		}

		/**
		 * Defines the type of range selection on OQL expression
		 */
		namespace RangeType
		{
			enum Type
			{
				Skip,
				Step,
				Take
			};
		}

		/**
		 * Defines the expression operator
		 */
		namespace Operator
		{
			enum Any {
			};

			/**
			 * Unary operators
			 */
			enum Unary
			{
				UNot = 0x1,
				UAdd,
				USub,
				UPtr, // *
				URef  // &
			};

			/**
			 * Binary operators
			 */
			enum Binary
			{
				Cast = 0x6,
				Mul,
				Div,
				Mod,
				Pow,
				Add,
				Sub,
				Shl,
				Shr,
				Let,
				Lee,
				Get,
				Gee,
				Eql,
				Neq,
				Mat,
				Nma,
				ROut,
				RIn,
				And,
				Or,
				Xor,
				Implies,
				Access,
				Assign,
				Ade,
				Sue,
				Mue,
				Die
			};

			/**
			 * Ternary operators
			 */
			enum Ternary
			{
				If = 0x28,
				Between
			};

			static std::ostream & operator<<(std::ostream & os, Any & op)
					{
				switch(op)
				{
				case UNot:
					os << "! unary";
					break;
				case UAdd:
					os << "+ unary";
					break;
				case USub:
					os << "- unary";
					break;
				case UPtr:
					os << "* ptr";
					break;
				case URef:
					os << "& ref";
					break;
				case Cast:
					os << "( )";
					break;
				case Mul:
					os << "*";
					break;
				case Div:
					os << "/";
					break;
				case Mod:
					os << "%";
					break;
				case Add:
					os << "+";
					break;
				case Sub:
					os << "-";
					break;
				case Shl:
					os << "<<";
					break;
				case Shr:
					os << ">>";
					break;
				case Let:
					os << "<";
					break;
				case Lee:
					os << "<=";
					break;
				case Get:
					os << ">";
					break;
				case Gee:
					os << ">=";
					break;
				case Eql:
					os << "==";
					break;
				case Neq:
					os << "!=";
					break;
				case Mat:
					os << "=~";
					break;
				case Nma:
					os << "!~";
					break;
				case ROut:
					os << "..";
					break;
				case RIn:
					os << "...";
					break;
				case And:
					os << "&&";
					break;
				case Or:
					os << "||";
					break;
				case Xor:
					os << "^";
					break;
				case Implies:
					os << "=>";
					break;
				case Access:
					os << ".";
					break;
				case Assign:
					os << "=";
					break;
				case Ade:
					os << "+=";
					break;
				case Sue:
					os << "-=";
					break;
				case Mue:
					os << "*=";
					break;
				case Die:
					os << "/=";
					break;
				case If:
					os << "?:";
					break;
				case Between:
					os << "between";
					break;
				}
				return os;
			}
		}

		/**
		 * Defines the type of condition statement
		 */
		namespace ConditionType
		{
			enum Type
			{
				If,
				Unless
			};
		}

		/**
		 * Defines the type of loop statement
		 */
		namespace LoopType
		{
			enum Type
			{
				For,
				Foreach,
				While,
				DoWhile
			};
		}

		/**
		 * Defines the type of interruption control
		 */
		namespace ControlType
		{
			enum Type
			{
				Return,
				Break,
				Yield
			};
		}

		/**
		 * Defines a function speficier
		 */
		namespace SpecifierType
		{
			enum Type
			{
				Abstract,
				Sealed,
				Class,
				Async
			};
		}

		/**
		 * Defines the type of node
		 */
		namespace NodeType
		{
			enum Type
			{
				Null,
				Identifier,
				Char,
				String,
				Regex,
				Float,
				Integer,
				Boolean,
				Array,
				HashPair,
				Hash,
				Expression
			};
		}

	} // Enum
} // LANG_NAMESPACE

#endif
