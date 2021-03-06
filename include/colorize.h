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
 * colorize.h - Colorize the interactive shell
 *
 * Defines constants used to fill color in interactive shell
 *
 */

#ifndef LANG_COLORIZE_H
#define LANG_COLORIZE_H

/*  Coloring console syntax:

 \033[x;y;zm
 \033[am

 Where:
 x is ???
 y is attribute
 0 - Normal
 1 - Bold
 4 - Underline
 z is text color
 30 - Black
 31 - Red
 32 - Green
 33 - Yellow
 34 - Blue
 35 - Purple
 36 - Cyan
 37 - White
 a(singular) is background color
 0 - Reset
 40 - Black
 41 - Red
 42 - Green
 43 - Yellow
 44 - Blue
 45 - Purple
 46 - Cyan
 47 - White
 */

#define COLOR_RESET     "\033[0m"

#define COLOR_BLACK     "\033[0;0;30m"
#define COLOR_BBLACK    "\033[0;1;30m"
#define COLOR_UBLACK    "\033[0;4;30m"

#define COLOR_RED       "\033[0;0;31m"
#define COLOR_BRED      "\033[0;1;31m"
#define COLOR_URED      "\033[0;4;31m"

#define COLOR_GREEN     "\033[0;0;32m"
#define COLOR_BGREEN    "\033[0;1;32m"
#define COLOR_UGREEN    "\033[0;4;32m"

#define COLOR_YELLOW    "\033[0;0;33m"
#define COLOR_BYELLOW   "\033[0;1;33m"
#define COLOR_UYELLOW   "\033[0;4;33m"

#define COLOR_BLUE      "\033[0;0;34m"
#define COLOR_BBLUE     "\033[0;1;34m"
#define COLOR_UBLUE     "\033[0;4;34m"

#define COLOR_PURPLE    "\033[0;0;35m"
#define COLOR_BPURPLE   "\033[0;1;35m"
#define COLOR_UPURPLE   "\033[0;4;35m"

#define COLOR_CYAN      "\033[0;0;36m"
#define COLOR_BCYAN     "\033[0;1;36m"
#define COLOR_UCYAN     "\033[0;4;36m"

#define COLOR_WHITE     "\033[0;0;37m"
#define COLOR_BWHITE    "\033[0;1;37m"
#define COLOR_UWHITE    "\033[0;4;37m"

#define BACK_BLACK      "\033[40m"
#define BACK_RED        "\033[41m"
#define BACK_GREEN      "\033[42m"
#define BACK_YELLOW     "\033[43m"
#define BACK_BLUE       "\033[44m"
#define BACK_PURPLE     "\033[45m"
#define BACK_CYAN       "\033[46m"
#define BACK_WHITE      "\033[47m"

#endif
