
#ifndef LANG_CONFIG_H
#define LANG_CONFIG_H

#define LANG_NAME               "Ares"
#define LANG_SHELL_NAME         "ash"
#define LANG_EXTENSION          "ar"
#define LANG_NAMESPACE          Ares

#define LANG_AUTHOR_NAME        "Geovani de Souza"
#define LANG_AUTHOR_EMAIL       "geovanisouza92@gmail.com"
#define LANG_HOME_PAGE          "http://github.com/geovanisouza92/ares"

#define LANG_BIRTH_YEAR         2011
#define LANG_BIRTH_MONTH        1
#define LANG_BIRTH_DAY          21

#define LANG_RELEASE_YEAR       2012
#define LANG_RELEASE_MONTH      3
#define LANG_RELEASE_DAY        22

#define LANG_VERSION_MAJOR      0
#define LANG_VERSION_MINOR      2
#define LANG_VERSION_PATCH      1
#define LANG_VERSION_COMMENT    "proto"

#if   defined(_WIN32) || defined(MSWIN) || defined(MSWINDOWS)
#define LANG_PLATFORM "MS Windows"
#elif defined(__linux__)
#define LANG_PLATFORM "Linux"
#elif defined(__GNUC__)
#define LANG_PLATFORM "Unix-compatible"
#else
#define LANG_PLATFORM "Unknown"
#endif

#endif
