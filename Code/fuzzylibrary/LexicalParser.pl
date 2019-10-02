%lexical_parser(+File, -Lexemes)
%returns the lexemes from a file
lexical_parser(File,[]) :-
   at_end_of_stream(File),
   !.

lexical_parser(File, Tokens) :-
   tokenise_line_dl(File, Tokens/Tail),
   lexical_parser(File, Tail).
   

% et.pl - M. Covington      2003 February 12
% tokenise_line_dl(+Stream,-Tokens/Tail)
%  Like tokenise_line, but uses a difference list.
%  This makes it easier to append the results of successive calls.

tokenise_line_dl(Stream,Dlist) :-
   get_char_and_type(Stream,Char,Type),
   tokenise_line_x(Type,Char,Stream,Dlist).


% et.pl - M. Covington      2003 February 12
% get_char_and_type(+Stream,-Char,-Type)
%  Reads a character, determines its type, and translates
%  it as specified in char_type_char.

get_char_and_type(Stream,Char,Type) :-
   get_char(Stream,C),
   char_type_char(C,Type,Char).


% et.pl - M. Covington      2003 February 12
% tokenise_line_x(+Type,+Char,+Stream,-Tokens/Tail)
%  tokenises (the rest of) a line of input.
%  Type and Char describe the character that has been read ahead.

tokenise_line_x(eol,_,_,Tail/Tail) :-               % end of line mark; terminate
   !.

tokenise_line_x(whitespace,_,Stream,Dlist) :-       % whitespace, skip it
   !,
   tokenise_line_dl(Stream,Dlist).


% et.pl - M. Covington      2003 February 12
%tokenises letters into names (functions and variables)
tokenise_line_x(letter,Char,Stream,[name(T)|Tokens]/Tail) :-
   !,
   tokenise_letters(letter,Char,Stream,T,NewType,NewChar),
   tokenise_line_x(NewType,NewChar,Stream,Tokens/Tail).

%checks for a comment or documentation
tokenise_line_x(operator,'/',Stream,[Comment|Tokens]/Tail) :-
   !,
   get_char_and_type(Stream,Char2,Type2),
   check_comments(Type2,Char2,Stream,Comment,NewType,NewChar),
   tokenise_line_x(NewType,NewChar,Stream,Tokens/Tail).

%tokenises operators
tokenise_line_x(operator,Char,Stream,[op(T)|Tokens]/Tail) :-
   !,
   tokenise_operators(operator,Char,Stream,T,NewType,NewChar),
   tokenise_line_x(NewType,NewChar,Stream,Tokens/Tail).

%tokenises strings
tokenise_line_x(string,Char,Stream,[str(T)|Tokens]/Tail) :-
   !,
   tokenise_string(string,Char,Stream,T,NewType,NewChar),
   tokenise_line_x(NewType,NewChar,Stream,Tokens/Tail).

% et.pl - M. Covington      2003 February 12
%tokenises numbers
tokenise_line_x(digit,Char,Stream,[num(T)|Tokens]/Tail) :-
   !,
   tokenise_digits(digit,Char,Stream,T,NewType,NewChar),
   tokenise_line_x(NewType,NewChar,Stream,Tokens/Tail).

% et.pl - M. Covington      2003 February 12
% A period is handled like a digit if it is followed by a digit.
% This handles numbers that are written with the decimal point first.
tokenise_line_x(_, '.', Stream,Dlist) :-
   peek_char(Stream,P),
   char_type_char(P,digit,_),
   !,
   % Start over, classifying '.' as a digit
   tokenise_line_x(digit, '.', Stream,Dlist).

%tokenises brackets
tokenise_line_x(bracket,Char,Stream,[bra(Char)|Tokens]/Tail) :-
   !,
   tokenise_line_dl(Stream,Tokens/Tail).

% et.pl - M. Covington      2003 February 12
% Special characters and unidentified characters are easy:
% they stand by themselves, and the next token begins with
% the very next character.
tokenise_line_x(special,Char,Stream,[special(Char)|Tokens]/Tail) :-   % special char
   !,
   tokenise_line_dl(Stream,Tokens/Tail).

% et.pl - M. Covington      2003 February 12
tokenise_line_x(_,Char,Stream,[other(Char)|Tokens]/Tail) :-     % unidentified char
   !,
   tokenise_line_dl(Stream,Tokens/Tail).

%check_comments(+Type, +Char, +Stream, -Lexeme, -NewType, -NewChar)
%returns either the documentation, comment or operator following a /
%check for documentation
check_comments(operator,'*',Stream,doc(Comment),NewType,NewChar):-
   peek_char(Stream,P),
   char_type_char(P,operator,'*'),
   !,
   get_char(Stream,_),
   get_char_and_type(Stream,Char2,Type2),
   tokenise_documentation(Type2,Char2,Stream,Comment,NewType,NewChar).

%check for comments
check_comments(operator,'*',Stream,com(Comment),NewType,NewChar):-
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_comment(Type2,Char2,Stream,Comment,NewType,NewChar).

%its neither of these, tokenise as an operator
check_comments(Type,Char,Stream,op(['/'|T]),NewType,NewChar):-
   !,
   tokenise_operators(Type,Char,Stream,T,NewType,NewChar).


%tokenise_comment(+Type, +Char, +Stream, -Comment, -NewType, -NewChar)
%end of a comment, * has to be followed by /, stop recursion
tokenise_comment(operator,'*',Stream,[],NewType,NewChar):-
   peek_char(Stream,P),
   char_type_char(P,operator,'/'),
   !,
   get_char(Stream,_),
   get_char_and_type(Stream,NewChar,NewType).

%comment content, continue recursion
tokenise_comment(_,Char,Stream,[Char|Comment],NewType,NewChar):-
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_comment(Type2,Char2,Stream,Comment,NewType,NewChar).


%tokenise_documentation(+Type, +Char, +Stream, -Documentation, -NewType, -NewChar)
%end of documentation, * has to followed by /, stop recursion
tokenise_documentation(operator,'*',Stream,[],NewType,NewChar):-
   peek_char(Stream,P),
   char_type_char(P,operator,'/'),
   !,
   get_char(Stream,_),
   get_char_and_type(Stream,NewChar,NewType).

%documentation content, continue recursion
tokenise_documentation(_,Char,Stream,[Char|Comment],NewType,NewChar):-
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_documentation(Type2,Char2,Stream,Comment,NewType,NewChar).


% et.pl - M. Covington      2003 February 12
% tokenise_letters(+Type,+Char,+Stream,-Token,-NewType,-NewChar)
%   Completes a word token beginning with Char, which has
%   been read ahead and identified as type Type.
%   When the process ends, NewChar and NewType are the
%   character that was read ahead after the token.
tokenise_letters(letter,Char,Stream,[Char|Rest],NewType,NewChar) :-
   % It's a letter, so process it, read another character ahead, and recurse.
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_letters(Type2,Char2,Stream,Rest,NewType,NewChar).

tokenise_letters(digit,Char,Stream,[Char|Rest],NewType,NewChar) :-
   % It's a digit, so process it, read another character ahead, and recurse.
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_letters(Type2,Char2,Stream,Rest,NewType,NewChar).

tokenise_letters(Type,Char,_,[],Type,Char).
   % It's not a letter, so don't process it; pass it to the calling procedure.


%tokenise_operators(+Type, +Char, +Stream, -Token, -NewType, -NewChar)
%char is an operator, continue recursion
tokenise_operators(operator,Char,Stream,[Char|Rest],NewType,NewChar) :-
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_operators(Type2,Char2,Stream,Rest,NewType,NewChar).

%char is not an operator, this is the end of the operator, stop recursion
tokenise_operators(Type,Char,_,[],Type,Char).


%tokenise_string(+Type, +Char, +Stream, -Token, -NewType, -NewChar)
%start of a string, process the rest of the stream
tokenise_string(string,_,Stream,Rest,NewType,NewChar) :-
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_string_end(Type2,Char2,Stream,Rest,NewType,NewChar).

%tokenise_string_end(+Type, +Char, +Stream, +String, +NewType, +NewChar)
%if there is an \ operator, add next char without processing, continue recursion
tokenise_string_end(operator,'\\',Stream,[Char|[Char2|Rest]],NewType,NewChar) :-
   !,
   get_char_and_type(Stream,Char2,Type2),
   get_char_and_type(Stream,Char3,Type3),
   tokenise_string_end(Type3,Char3,Stream,Rest,NewType,NewChar).

%end case, another ", stop recursion
tokenise_string_end(string,Char,_,[],_,Char).

%continue recursion
tokenise_string_end(_,Char,Stream,[Char|Rest],NewType,NewChar) :-
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_string_end(Type2,Char2,Stream,Rest,NewType,NewChar).


% et.pl - M. Covington      2003 February 12
% tokenise_digits(+Type,+Char,+Stream,-Token,-NewChar,-NewType)
%   Like tokenise_letters, but completes a number token instead.
%   Additional subtleties for commas and decimal points.

tokenise_digits(digit,Char,Stream,[Char|Rest],NewType,NewChar) :-
   % It's a digit, so process it, read another character ahead, and recurse.
   !,
   get_char_and_type(Stream,Char2,Type2),
   tokenise_digits(Type2,Char2,Stream,Rest,NewType,NewChar).

tokenise_digits(_, '.', Stream,['.'|Rest],NewType,NewChar) :-
   peek_char(Stream,P),
   char_type_char(P,digit,Char2),
   !,
   % It's a period followed by a digit, so include it and continue.
   get_char(Stream,_),
   tokenise_digits(digit,Char2,Stream,Rest,NewType,NewChar).

tokenise_digits(Type,Char,_,[],Type,Char).
   % It's not any of those, so don't process it;
   % pass it to the calling procedure.

% et.pl - M. Covington      2003 February 12
% char_type_char(+Char,-Type,-TranslatedChar)
%   Classifies all characters as letter, digit, special, etc.,
%   and also translates each character into the character that
%   will represent it, converting upper to lower case.

char_type_char(Char,Type,Tr) :-
   char_table(Char,Type,Tr),
   !.

char_type_char(Char,special,Char).

% et.pl - M. Covington      2003 February 12
% End of line marks
char_table(end_of_file, eol, end_of_file).
char_table('\n',        eol, '\n'       ).

% et.pl - M. Covington      2003 February 12
% Whitespace characters
char_table(' ',     whitespace,  ' ').     % blank
char_table('\t',    whitespace,  ' ').     % tab
char_table('\r',    whitespace,  ' ').     % return

%operators
char_table('+',   operator,   '+').
char_table('-',   operator,   '-').
char_table('*',   operator,   '*').
char_table('/',   operator,   '/').
char_table('%',   operator,   '%').

char_table('&',   operator,   '&').
char_table('|',   operator,   '|').
char_table('\\',  operator,   '\\').
char_table('!',   operator,   '!').
char_table('^',   operator,   '^').
char_table('~',   operator,   '~').

char_table('<',   operator,   '<').
char_table('>',   operator,   '>').
char_table('=',   operator,   '=').

char_table('.',   operator,   '.').
char_table('#',   operator,   '#').
char_table(':',   operator,   ':').

%string
char_table('"',   string,   '"').

% Brackets
char_table('(',   bracket,   '(').
char_table(')',   bracket,   ')').
char_table('[',   bracket,   '[').
char_table(']',   bracket,   ']').
char_table('{',   bracket,   '{').
char_table('}',   bracket,   '}').

% et.pl - M. Covington      2003 February 12
% Letters 
char_table(a,     letter,    a ).
char_table(b,     letter,    b ).
char_table(c,     letter,    c ).
char_table(d,     letter,    d ).
char_table(e,     letter,    e ).
char_table(f,     letter,    f ).
char_table(g,     letter,    g ).
char_table(h,     letter,    h ).
char_table(i,     letter,    i ).
char_table(j,     letter,    j ).
char_table(k,     letter,    k ).
char_table(l,     letter,    l ).
char_table(m,     letter,    m ).
char_table(n,     letter,    n ).
char_table(o,     letter,    o ).
char_table(p,     letter,    p ).
char_table(q,     letter,    q ).
char_table(r,     letter,    r ).
char_table(s,     letter,    s ).
char_table(t,     letter,    t ).
char_table(u,     letter,    u ).
char_table(v,     letter,    v ).
char_table(w,     letter,    w ).
char_table(x,     letter,    x ).
char_table(y,     letter,    y ).
char_table(z,     letter,    z ).
char_table('A',   letter,    'A' ).
char_table('B',   letter,    'B' ).
char_table('C',   letter,    'C' ).
char_table('D',   letter,    'D' ).
char_table('E',   letter,    'E' ).
char_table('F',   letter,    'F' ).
char_table('G',   letter,    'G' ).
char_table('H',   letter,    'H' ).
char_table('I',   letter,    'I' ).
char_table('J',   letter,    'J' ).
char_table('K',   letter,    'K' ).
char_table('L',   letter,    'L' ).
char_table('M',   letter,    'M' ).
char_table('N',   letter,    'N' ).
char_table('O',   letter,    'O' ).
char_table('P',   letter,    'P' ).
char_table('Q',   letter,    'Q' ).
char_table('R',   letter,    'R' ).
char_table('S',   letter,    'S' ).
char_table('T',   letter,    'T' ).
char_table('U',   letter,    'U' ).
char_table('V',   letter,    'V' ).
char_table('W',   letter,    'W' ).
char_table('X',   letter,    'X' ).
char_table('Y',   letter,    'Y' ).
char_table('Z',   letter,    'Z' ).

% et.pl - M. Covington      2003 February 12
% Digits
char_table('0',   digit,     '0' ).
char_table('1',   digit,     '1' ).
char_table('2',   digit,     '2' ).
char_table('3',   digit,     '3' ).
char_table('4',   digit,     '4' ).
char_table('5',   digit,     '5' ).
char_table('6',   digit,     '6' ).
char_table('7',   digit,     '7' ).
char_table('8',   digit,     '8' ).
char_table('9',   digit,     '9' ).