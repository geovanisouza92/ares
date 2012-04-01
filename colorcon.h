/* Ares Programming Language */

#ifndef LANG_COLORCON_H
#define LANG_COLORCON_H

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
 a (singular) is background color
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

#ifndef LANG_DEBUG

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

#else

#define COLOR_RESET     ""

#define COLOR_BLACK     ""
#define COLOR_BBLACK    ""
#define COLOR_UBLACK    ""

#define COLOR_RED       ""
#define COLOR_BRED      ""
#define COLOR_URED      ""

#define COLOR_GREEN     ""
#define COLOR_BGREEN    ""
#define COLOR_UGREEN    ""

#define COLOR_YELLOW    ""
#define COLOR_BYELLOW   ""
#define COLOR_UYELLOW   ""

#define COLOR_BLUE      ""
#define COLOR_BBLUE     ""
#define COLOR_UBLUE     ""

#define COLOR_PURPLE    ""
#define COLOR_BPURPLE   ""
#define COLOR_UPURPLE   ""

#define COLOR_CYAN      ""
#define COLOR_BCYAN     ""
#define COLOR_UCYAN     ""

#define COLOR_WHITE     ""
#define COLOR_BWHITE    ""
#define COLOR_UWHITE    ""

#define BACK_BLACK      ""
#define BACK_RED        ""
#define BACK_GREEN      ""
#define BACK_YELLOW     ""
#define BACK_BLUE       ""
#define BACK_PURPLE     ""
#define BACK_CYAN       ""
#define BACK_WHITE      ""

#endif

#endif
