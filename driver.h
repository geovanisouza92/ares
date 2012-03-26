/* Ares Programming Language */

#ifndef LANG_DRIVER_H
#define LANG_DRIVER_H

#include <string>
#include <vector>
#include <time.h>

using namespace std;

#define BOOST_FILESYSTEM_VERSION 3
#include <boost/filesystem.hpp>

namespace fs = boost::filesystem3;

#include "st.h"
#include "console.h"
#include "scanner.h"

#define ENVIRO

namespace LANG_NAMESPACE {

class Driver {
public:
	string origin;
	bool check_only;
	VerboseMode::Mode verbose_mode;
	unsigned lines, total_lines;
	unsigned errors, warnings, hints;
	class Scanner * lexer;
#ifdef ENVIRO
	class SyntaxTree::Environment * Env;
#endif
public:
	Driver();
	virtual ~Driver();
	virtual bool parse_stream(istream&, const string& sname = "stream input");
	virtual bool parse_string(const string&, const string& sname =
			"string stream");
	virtual bool parse_file(const string&);

	virtual int error(const class location&, const string&);
	virtual int error(const string&);
	virtual void warning(const class location&, const string&);
	virtual void warning(const string&);
	virtual void hint(const class location&, const string&);
	virtual void hint(const string&);
	virtual string resume_messages();

	virtual inline void syntax_ok_for(const string what) {
		cout << "=> Syntax OK for " << COLOR_BGREEN << what
				<< COLOR_RESET << endl;
	}
	virtual inline void reset_lines() {
		total_lines += lines;
		lines = 0;
	}
	virtual inline void inc_lines() {
		++lines;
	}
	virtual inline void dec_lines() {
		--lines;
	}

	virtual void make_things_happen(FinallyAction::Action, ostream&);
};

}

#endif
