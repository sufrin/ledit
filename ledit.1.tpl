.TH LEDIT 1 "Wed Jan 23, 2008" "INRIA"
.SH NAME
ledit \- line editor, version LEDIT_VERSION

.SH SYNOPSIS
.B ledit
[-h \fIfile\fP]
[-x]
[-t]
[-l \fIlength\fP]
[-a|-u]
[-m]
[-dk]
[\fIcmd opts\fP]

.SH DESCRIPTION
The command \fIledit\fP allows to edit lines one by one when running an
interactive command. When typing a line, some keys with control or meta
are interpreted: it is possible to insert characters in the middle of
the line, go to the beginning or the end of the line, get a previous line,
search for a line with a pattern, etc.

.SH OPTIONS
The options are:
.TP
.B -h \fIfile\fP
Save the lines typed (history) in \fIfile\fP. The default is to have them
only in memory (so, they are lost at the end of the program).
.TP
.B -x
Extend the history file (given in option "-h") if it already exists. The
default is to truncate the history file.
.TP
.B -t
Display the sequences generated by the keys (for debugging).
.TP
.B -v
Print ledit version and exit.
.TP
.B -l \fIlength\fP
Tells that \fIlength\fP is the maximum line length displayed. If the
line edited is longer than this length, the line scrolls horizontally,
while editing. The default value is 70.
.TP
.B -a
Ascii encoding: characters whose code is greater than 128 are displayed
with a backslash followed by their code.
.TP
.B -u
Unicode encoding: the terminal must have been set in unicode mode. See
commands \fBunicode_start\fP and \fBunicode_stop\fP. 
.TP
.B -m
Install only a \fBminimal\fP set of default keys (the navigation-arrow 
and deletion keys), leaving the user free to define the other keycodes
in an LEDITRC file.
.TP
.B -dk
Whenever the LEDITRC file is read, give an account of the
keyboard bindings and abbreviations that are made.
.TP
\fIcmd opts\fP
Runs the command, \fIcmd\fP, with its own options, \fIopts\fP. This
must be the last option of ledit. The default value is "cat".

.SH KEYS BINDINGS
When ledit starts, some default key bindings are defined. The can be
completed with a "leditrc" file. See the section \fBLEDITRC\fP.

In the following lines, the caret sign "^" means "control" and the
sequence "M-" means "meta" (either with the "meta" prefix, or by
pressing the "escape" key before). Examples:
.TP 1.0i
^a
press the "control" key, then press "a", then release "a", then
release "control".
.TP
M-a
press the "meta" key, then press "a", then release "a", then release
"meta", or: press and release the "escape" key, then press and release
"a" (the manipulation with "meta" may not work in some systems: in
this case, use the manipulation with "escape").
.PP

The default editing commands are:

.nf
      ^a   : beginning of line  (*)
      ^e   : end of line        (*)
      ^f   : forward char       (*)
      ^b   : backward char      (*)
      M-f  : forward word       (*)
      M-b  : backward word      (*)
      TAB  : complete file name 
      ^p   : previous line in history   (*)
      ^n   : next line in history       (*)
      M-<  : first line in history      (*)
      M->  : last line in history       (*)
      ^r   : reverse search in history (see below)      (*)
      ^d   : delete char (or EOF if the line is empty)  (*)
      ^h   : (or backspace) backward delete char
      ^t   : transpose chars    (*)
      M-c  : capitalize word    (*)
      M-u  : upcase word        (*)
      M-l  : downcase word      (*)
      M-d  : kill word          (*)
      M-^h : (or M-del or M-backspace) backward kill word       (*)
      ^q   : insert next char           (*)
      M-/  : expand abbreviation        (*)
      ^k   : cut until end of line      (*)
      ^y   : paste                      (*)
      ^u   : line discard
      ^l   : redraw current line
      ^g   : abort prefix               (*)
      ^c   : interrupt
      ^z   : suspend
      ^\\   : quit
      return : send line
      ^x     : send line and show next history line
      other  : insert char
.fi

Those marked with an asterisk are omitted when only the minimal set is installed (the -m option). 

The arrow keys can be used, providing your keyboard returns standard key
sequences:

.nf
      up arrow    : previous line in history
      down arrow  : next line in history
      right arrow : forward char
      left arrow  : backward char
.fi

Other keys:

.nf
      home        : beginning of line
      end         : end of line
      delete      : delete char
      page up     : previous line in history
      page down   : next line in history
      shift home  : beginning of history
      shift end   : end of history
.fi

.SH REVERSE SEARCH
The reverse search is incremental, i.e. \fIledit\fP backward searchs in the
history a line holding the characters typed. If you type "a", its search the
first line before the current line holding an "a" and displays it. If you then
type a "b", its search a line holding "ab", and so on. If you type ^h (or
backspace), it returns to the previous line found. To cancel the search,
type ^g. To find another line before holding the same string, type ^r.
To stop the editing and display the current line found, type "escape"
(other commands of the normal editing, different from ^h, ^g, and ^r stop
the editing too).

Summary of reverse search commands:

.nf
      ^g  : abort search
      ^r  : search previous same pattern
      ^h  : (or backspace) search without the last char
      del : search without the last char
      any other command : stop search and show the line found
.fi

.SH LEDITRC
If the environment variable LEDITRC is set, it contains the name of the
leditrc file. Otherwise it is the file named ".leditrc" in user's home
directory. When starting, ledit reads this file, if it exists, to modify
or complete the default bindings and \fIVISIBLE ABBREVIATION\fPs. If this file is changed while reading
lines, it is read again to take the new file into account.

Bindings lines are the ones which start with a string defining the key
sequence and follow with a colon and a binding. A binding is either a
string or a command. The other lines are ignored For example,the line:

.nf
    "\\C-a": beginning-of-line
.fi

binds the sequence "control-a" to the command "beginning-of-line".

The key sequence may contain the specific meta-sequences:

.nf
    \\C-   followed by a key: "control" of this key
    \\M-   followed by a key: "meta" of this key
    \\e    the "escape" key
    \\nnn  where nnn is one, two, or three octal digits, or:
    \\xnn  where nn is one or two hexadecimal digits:
            the binary representation of a byte
    \\a    bell = \\C-g
    \\b    backspace = \\C-h
    \\d    delete = \\277
    \\f    form feed = \\C-l
    \\n    newline = \\C-j
    \\r    carriage return = \\C-m
    \\t    tabulation = \\C-i
    \\v    vertical tabulation = \\C-k
.fi

The commands are:

.nf
  abort: do nothing
  accept-line: send the current line
  backward-char: move the cursor to the previous character
  backward-delete-char: delete the previous character
  backward-kill-word: delete the previous word
  backward-word: move the cursor before the previous word
  beginning-of-history: display the first line of the history
  beginning-of-line: move the cursor at the beginning of the line
  capitalize-word: uppercase the first char and lowercase the rest
  delete-char: delete the character under the cursor
  delete-char-or-end-of-file: same but eof if no character in the line
  downcase-word: lowercase whole word
  end-of-history: display the last line of the history
  end-of-line: move the cursor to the end of the line
  expand-abbrev: try to complete the word by looking at the history
  expand-visible-abbrev: if a visible \fIpat\fP is at the left of the cursor, then replace it with its \fIrep\fP 
  expand-to-file-name: try to complete the word from a file name
  forward-char: move the cursor after the next word
  forward-word: move the cursor to the next character
  interrupt: interrupt command (send control-C)
  kill-line: delete from the cursor to the end and save in buffer
  kill-word: delete the next word
  next-history: display the next line of the history
  operate-and-get-next: send line and display the next history line
  previous-history: display the previous line of the history
  quit: quit ledit
  quoted-insert: insert the next character as it is
  redraw-current-line: redisplay the current line
  reverse-search-history: backward search in the history
  suspend: suspend ledit (send control-Z)
  transpose-chars: exchange the last two characters
  unix-line-discard: kill current line
  upcase-word: uppercase whole word
  yank: insert kill buffer
.fi

.SH VISIBLE ABBREVIATIONS
Abbreviation definitions appear in the LEDITRC file and are of the form:

.nf
        /\fIpat\fP/\fIrep\fP/
.fi

Where the pattern, /\fIpat\fP/, \fBmust\fP consist of ascii characters. Its
replacement, \fIrep\fP, may consist of any (non-space) characters at all, including
characters in the utf-8, (which includes iso-latin-1) encoding. Both pattern and replacement
are interpreted literally (ie no escape characters), except that \/ and \\ 
mean / and \ respectively.  As a concession to readability, any space
before the first visible character of the \fIrep\fP is ignored, and the
rightmost "/" following it may be missing. 

When the "expand-visible-abbrev" command is invoked, by pressing a
key(-sequence) bound to it,  the list of visual abbreviations
is searched for the longest occurence of a \fIpat\fP that matches the text
directly to the left of the cursor. If one is found, then it is replaced by
its corresponding \fIrep\fB. 

.SH KNOWN BUGS
If \fIledit\fP has been launched in a shell script, the suspend command kills
it and its command... Use "exec ledit comm" instead of "ledit comm".
.br
The suspend command stops \fIledit\fP but not the called program. Do not
do this if the called program is not waiting on standard input.
.br
In some systems (e.g. alpha), pasting too many characters works bad and
may block the terminal. Probably a kernel problem. No solution.

.SH SEE ALSO

unicode_start(1), unicode_stop(1).

.SH AUTHOR
Daniel de Rauglaudre, at INRIA, france.
.br
daniel.de_rauglaudre@inria.fr


