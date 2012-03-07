
#ifndef COLOR_CONSOLE_H
#define COLOR_CONSOLE_H

/*  Coloring console syntax:

        \e[x;y;zm
        \e[am
    
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

#define COLOR_RESET     "\e[0m"

#define COLOR_BLACK     "\e[0;0;30m"
#define COLOR_BBLACK    "\e[0;1;30m"
#define COLOR_UBLACK    "\e[0;4;30m"

#define COLOR_RED       "\e[0;0;31m"
#define COLOR_BRED      "\e[0;1;31m"
#define COLOR_URED      "\e[0;4;31m"

#define COLOR_GREEN     "\e[0;0;32m"
#define COLOR_BGREEN    "\e[0;1;32m"
#define COLOR_UGREEN    "\e[0;4;32m"

#define COLOR_YELLOW    "\e[0;0;33m"
#define COLOR_BYELLOW   "\e[0;1;33m"
#define COLOR_UYELLOW   "\e[0;4;33m"

#define COLOR_BLUE      "\e[0;0;34m"
#define COLOR_BBLUE     "\e[0;1;34m"
#define COLOR_UBLUE     "\e[0;4;34m"

#define COLOR_PURPLE    "\e[0;0;35m"
#define COLOR_BPURPLE   "\e[0;1;35m"
#define COLOR_UPURPLE   "\e[0;4;35m"

#define COLOR_CYAN      "\e[0;0;36m"
#define COLOR_BCYAN     "\e[0;1;36m"
#define COLOR_UCYAN     "\e[0;4;36m"

#define COLOR_WHITE     "\e[0;0;37m"
#define COLOR_BWHITE    "\e[0;1;37m"
#define COLOR_UWHITE    "\e[0;4;37m"

#define BACK_BLACK      "\e[40m"
#define BACK_RED        "\e[41m"
#define BACK_GREEN      "\e[42m"
#define BACK_YELLOW     "\e[43m"
#define BACK_BLUE       "\e[44m"
#define BACK_PURPLE     "\e[45m"
#define BACK_CYAN       "\e[46m"
#define BACK_WHITE      "\e[47m"

#endif
