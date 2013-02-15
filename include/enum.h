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
 * enum.h - Enumeration for virtual platform
 *
 * Defines enumeration used on virtual platform
 *
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
                None
                , Shell
                , LineEval
                , FileParse
            };
        }

        /**
         * Defines the verbose level of output
         */
        namespace VerboseMode
        {
            enum Mode
            {
                Low
                , Normal
                , High
                , Debug
            };
        }

        /**
         * Defines the final destiny of code on platform
         */
        namespace FinallyAction
        {
            enum Action
            {
                None
                , PrintOnConsole
                , ExecuteOnTheFly
                , GenerateBinaries
            };
        }

        /**
         * Defines the type of join on OQL expression
         */
        namespace JoinType
        {
            enum Type
            {
                None
                , Left
                , Right
            };
        }

        /**
         * Defines the direction of ordering on OQL expression
         */
        namespace OrderType
        {
            enum Type
            {
                None
                , Asc
                , Desc
            };
        }

        /**
         * Defines the type of range selection on OQL expression
         */
        namespace RangeType
        {
            enum Type
            {
                Skip
                , Step
                , Take
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
                Not = 0x1
                , Compl
                , UAdd
                , USub
                , Ptr
                , Ref
                , PreInc
                , PreDec
                , PostInc
                , PostDec
                , New
                , Typeof
                , Sizeof
            };

            /**
             * Binary operators
             */
            enum Binary
            {
                Cast = 0x32
                , Mul
                , Div
                , Mod
                , Pow
                , Add
                , Sub
                , Shl
                , Shr
                , Let
                , Lee
                , Get
                , Gee
                , Eql
                , Neq
                , Mat
                , Nma
                , Rae
                , Rai
                , Is
                , As
                , Coa
                , And
                , Xor
                , Or
                , BOr
                , BAnd
                , Implies
                , Access
                , Assign
                , Ade
                , Sue
                , Mue
                , Die
                , Mde
            };

            /**
             * Ternary operators
             */
            enum Ternary
            {
                Iif = 0x64
                , Between
            };

            static std::ostream & operator<<(std::ostream & os, Any & op)
            {
                switch(op)
                {
                case Not:
                    os << "! unary";
                    break;
                case Compl:
                    os << "~";
                    break;
                case UAdd:
                    os << "+ unary";
                    break;
                case USub:
                    os << "- unary";
                    break;
                case Ptr:
                    os << "* ptr";
                    break;
                case Ref:
                    os << "& ref";
                    break;
                case PreInc:
                    os << "++ var";
                    break;
                case PreDec:
                    os << "-- var";
                    break;
                case PostInc:
                    os << "var ++";
                    break;
                case PostDec:
                    os << "var --";
                    break;
                case Cast:
                    os << "( )";
                    break;
                case Typeof:
                    os << "typeof";
                    break;
                case Sizeof:
                    os << "sizeof";
                    break;
                case Mul:
                    os << "*";
                    break;
                case Div:
                    os << "/";
                    break;
                case Mod:
                    os << "\%";
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
                case Rae:
                    os << "..";
                    break;
                case Rai:
                    os << "...";
                    break;
                case Is:
                    os << "is";
                    break;
                case As:
                    os << "as";
                    break;
                case Coa:
                    os << "??";
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
                case Mde:
                    os << "%=";
                    break;
                    break;
                case Iif:
                    os << "?:";
                    break;
                case Between:
                    os << "between";
                    break;
                default:
                    throw "Unknown operator";
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
                If
                , Unless
            };
        }

        /**
         * Defines the type of loop statement
         */
        namespace LoopType
        {
            enum Type
            {
                For
                , Foreach
                , While
                , DoWhile
            };
        }

        /**
         * Defines the type of interruption control
         */
        namespace ControlType
        {
            enum Type
            {
                Return
                , Break
                , Yield
            };
        }

        /**
         * Defines a function speficier
         */
        namespace SpecifierType
        {
            enum Type
            {
                Abstract
                , Sealed
                , Class
                , Async
            };
        }

        /**
         * Defines the type of node
         */
        namespace NodeType
        {
            enum Type
            {
                Null
                , Identifier
                , Char
                , String
                , Regex
                , Float
                , Integer
                , Boolean
                , Array
                , HashPair
                , Hash
                , Expression
                , Ty
            };
        }

    } // Enum
} // LANG_NAMESPACE

#endif
