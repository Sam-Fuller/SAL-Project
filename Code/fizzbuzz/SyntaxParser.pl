%check_imports(+Lexemes, -Lexemes)
%there is an import, import it
check_imports([str(FileName)|[special(;)|Lexemes]], NewLexemes):-
    open(FileName, 'read', InFile),
    lexical_parser(InFile, ImportLexemes),
    close(InFile),
    !,

    %check for other imports
    check_imports(Lexemes, CurrentLexemes),
    %check the imports in the imports
    check_imports(ImportLexemes, NewImportLexemes),
    append(CurrentLexemes, NewImportLexemes, NewLexemes).

%no imports, stop recursion
check_imports(Lexemes, Lexemes).








%syntax_parser(+Lexemes, -Functions)
%empty list, end case, stop recursion
syntax_parser([],[]):-
    !.

%get the name of the next function, find all elements with the same name, add them as a function, continue recursion
syntax_parser(Lexemes, [fun(CurrentName,CurrentFunction)|Functions]):-
    !,
    get_name(Lexemes,CurrentName),
    !,
    function_parser(CurrentName, Lexemes, NewLexemes, CurrentFunction),
    !,
    syntax_parser(NewLexemes, Functions).


%get_name(+Lexemes, -Name)
%name found, stop recursion
get_name([name(Name)|_],Name):-
    !.

%name not found, continue recursion
get_name([_|Lexemes],Name):-
    !,
    get_name(Lexemes,Name).


%function_parser(+FunctionName, +Lexemes, -NewLexemes, -Element)
%empty list, end case, stop recursion
function_parser(_,[],[],[]) :-
    !.

%documentation, add if infront of the correct function, continue recursion
function_parser(CurrentName, [doc(Doc)|Lexemes], NewLexemes, [doc(Doc)|CurrentFunction]):-
    get_name(Lexemes,CurrentName),
    !,
    function_parser(CurrentName, Lexemes, NewLexemes, CurrentFunction).

%comment, add if infront of the correct function, continue recursion
function_parser(CurrentName, [com(Com)|Lexemes], NewLexemes, [com(Com)|CurrentFunction]):-
    get_name(Lexemes,CurrentName),
    !,
    function_parser(CurrentName, Lexemes, NewLexemes, CurrentFunction).
    
%name, add element if its the correct name, continue recursion
function_parser(CurrentName, [name(CurrentName)|Lexemes], NewLexemes, [ele(Caching,NewInputs,NewOutput)|CurrentFunction]):-
    !, %get the next element
    element_parser(Lexemes, ChangedLexemes, Element),
    !, %seperate to input, cache, and output
    element_seperater(Element, Inputs, Caching, Output),
    !, %parse the inputs, and replace variable names
    input_parser(Inputs, Output, NewInputs, NewOutput),
    !,
    function_parser(CurrentName, ChangedLexemes, NewLexemes, CurrentFunction).

%documentation, does not match the function name, do not add, continue recursion
function_parser(CurrentName, [doc(Doc)|Lexemes], [doc(Doc)|NewLexemes], CurrentFunction):-
    !,
    function_parser(CurrentName, Lexemes, NewLexemes, CurrentFunction).

%comment, does not match the function name, do not add, continue recursion
function_parser(CurrentName, [com(Com)|Lexemes], [com(Com)|NewLexemes], CurrentFunction):-
    !,
    function_parser(CurrentName, Lexemes, NewLexemes, CurrentFunction).

%element, does not match the function name, do not add, continue recursion
function_parser(CurrentName, [name(New)|Lexemes], NewNewLexemes, CurrentFunction):-
    !,
    element_parser(Lexemes, ChangedLexemes, NewFunction),
    !,
    function_parser(CurrentName, ChangedLexemes, NewLexemes, CurrentFunction),
    append([name(New)|NewFunction],[special(';')|NewLexemes],NewNewLexemes).

%does not match any of the above, incorrect syntax
function_parser(_, [Incorrect|_], _, _):-
    !,
    write('Incorrect syntax '),
    write(Incorrect),
    nl,
    false.


%element_parser(+Lexemes, -NewLexemes, -Element)
%element ends in semicolon, stop recursion
element_parser([special(';')|Lexemes], Lexemes, []):-
    !.

%other lexeme, continue recursion
element_parser([Token|Lexemes], NewLexemes, [Token|CurrentElement]):-
    element_parser(Lexemes, NewLexemes, CurrentElement).


%assignment operator found, stop recursion
element_seperater([op(['<','-'])|Element], [], false, Element):-
    !.

%assignment operator found, stop recursion
element_seperater([op(['='])|Element], [], true, Element):-
    !.

%no assignment operator, continue recursion
element_seperater([Current|Element], [Current|Inputs], Caching, Output):-
    !,
    element_seperater(Element, Inputs, Caching, Output).


%input_parser(+Input, +Output, -NewInput, -NewOutput)
%empty list, no variables
input_parser([], Output, [], Output):-
    !.

%bracket, parse variables
input_parser([bra('(')|Inputs], Output, NewInputs, NewOutput):-
    variable_parser(Inputs, Output, NewInputs, NewOutput, 0).

%otherwise, unknown input
input_parser(Inputs,_,_,_):-
    !,
    write('Unknown Input '),
    write(Inputs),
    nl,
    false.
    

%variable_parser(+Input, +Output, -NewInput, -NewOutput, +VariableNumber)
%empty list, stop recursion
variable_parser([],Output,[],Output,_):-
    !.

%variable with no logic, continue recursion
variable_parser([name(VarName)|[special(',')|OldInputs]], OldOutput, NewInputs, NewOutput, VarNum):-
    !,
    variable_replace(VarName, OldInputs, Inputs, VarNum),
    variable_replace(VarName, OldOutput, Output, VarNum),
    !,
    NewVarNum is VarNum + 1,
    variable_parser(Inputs, Output, NewInputs, NewOutput, NewVarNum).

%variable, no logic, last varaible
variable_parser([name(VarName)|OldInputs], OldOutput, [other(true)], NewOutput, VarNum):-
    OldInputs = [bra(')')],
    !,
    variable_replace(VarName, OldOutput, NewOutput, VarNum).

%variable with logic, continue recursion
variable_parser([name(VarName)|OldInputs], OldOutput, [var(VarNum)|CurrentInputs], NewOutput, VarNum):-
    !,
    variable_replace(VarName, OldInputs, Inputs, VarNum),
    variable_replace(VarName, OldOutput, Output, VarNum),
    !,
    next_comma(Inputs, Before, After),
    NewVarNum is VarNum + 1,
    variable_parser(After, Output, NewInputs, NewOutput, NewVarNum),
    append(Before, NewInputs, CurrentInputs).

%logic with no variable, continue recursion
variable_parser([Current|PartInputs], OldOutput, [var(VarNum)|[op(['=','='])|[Current|CurrentInputs]]], NewOutput, VarNum):-
    !,
    next_comma(PartInputs, Before, After),
    append(Before, NewInputs, CurrentInputs),
    NewVarNum is VarNum + 1,
    variable_parser(After, OldOutput, NewInputs, NewOutput, NewVarNum).


%next_comma(Inputs, Before, After)
%comma found, replace with &&, stop recursion
next_comma([special(',')|Inputs], [op(['&','&'])], Inputs):-
    !.

%no comma found before end of variables, stop recursion
next_comma([bra(')')], [], []):-
    !.

%no comma or bracket found, error
next_comma([], [], []):-
    write('Unknown Input'),
    nl,
    false.

%none of the above, continue recursion
next_comma([Current|Inputs], [Current|Before], After):-
    !,
    next_comma(Inputs, Before, After).


%variabile_replace(+VariableName, +Input, -Output, +VariableNumber)
%empty list, stop recursion
variable_replace(_,[],[],_):-
    !.

%if the variable appears, replace with variable number, continue recursion
variable_replace(VarName, [name(VarName)|Input], [var(VarNum)|Output], VarNum):-
    !,
    variable_replace(VarName, Input, Output, VarNum).

%otherwise, continue recursion
variable_replace(VarName, [Current|Input], [Current|Output], VarNum):-
    !,
    variable_replace(VarName, Input, Output, VarNum).








%function_list(+Syntax, -FunctionNames)
%empty list, stop recursion
function_list([],[]):-
    !.

%add the name to the list, continue recursion
function_list([fun(Name,_)|Syntax], [Name|Functions]) :-
    !,
    function_list(Syntax, Functions).


%check_operators(+FunctionList, -NewFunctionList)
%empty list, stop recursion
check_operators([],[]):-
    !.

%check operators for a single function, continue recursion
check_operators([fun(Name,CurrentFunction)|FunctionList], [fun(Name,NewFunction)|NewFunctionList]):-
    !,
    check_operators_functions(CurrentFunction, NewFunction),
    check_operators(FunctionList, NewFunctionList).


%check_operators_functions(+ElementList, -NewElementList)
%empty list, stop recursion
check_operators_functions([],[]):-
    !.

%skip documentation, continue recursion
check_operators_functions([doc(Documentation)|ElementList], [doc(Documentation)|NewElementList]):-
    !,
    check_operators_functions(ElementList, NewElementList).

%skip comments, continue recursion
check_operators_functions([com(Comment)|ElementList], [com(Comment)|NewElementList]):-
    !,
    check_operators_functions(ElementList, NewElementList).

%check element inputs and output, continue recursion
check_operators_functions([ele(Caching, Input, Output)|ElementList], [ele(Caching, NewInput, NewOutput)|NewElementList]):-
    !,
    check_operators_elements(Input, NewInput),
    check_operators_elements(Output, NewOutput),
    check_operators_functions(ElementList, NewElementList).


%check_operators_elements(Lexemes, NewLexemes)
%empty list, stop recursion
check_operators_elements([],[]).

%case for list generation
check_operators_elements([bra('[')|Lexemes], CurrentLexemes):-
    %check for [a..b] structure
    append(All, [bra(']')|Rest], Lexemes),
    append(Start, [op(['.','.'])|End], All),
    !,
    %check inside for structure
    check_operators_elements(Start, NewStart),
    check_operators_elements(End, NewEnd),
    !,
    %reattach structure ..(a,b)
    append([op(['.','.'])|[bra('(')|NewStart]], [special(',')|NewEnd], ListConstructor),
    !,
    check_operators_elements(Rest, NewLexemes),
    !,
    append(ListConstructor, [bra(')')|NewLexemes], CurrentLexemes).

%cases for :
%case for :(x) -> :(x)
check_operators_elements([op([':'])|[bra(Bracket)|Lexemes]], [op([':'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%case for :function(x) -> :(function(x))
check_operators_elements([op([':'])|[name(Function)|[bra('(')|Lexemes]]], [op([':'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

%case for :function -> :(function)
check_operators_elements([op([':'])|[name(Function)|Lexemes]], [op([':'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%case for :x -> :(x)
check_operators_elements([op([':'])|[Item|Lexemes]], [op([':'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%cases for # operator
check_operators_elements([op(['#'])|[bra(Bracket)|Lexemes]], [op(['#'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op(['#'])|[name(Function)|[bra('(')|Lexemes]]], [op(['#'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

check_operators_elements([op(['#'])|[name(Function)|Lexemes]], [op(['#'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op(['#'])|[Item|Lexemes]], [op(['#'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%cases for :: operator
check_operators_elements([op([':',':'])|[bra(Bracket)|Lexemes]],[op([':',':'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':',':'])|[name(Function)|[bra('(')|Lexemes]]], [op([':',':'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

check_operators_elements([op([':',':'])|[name(Function)|Lexemes]], [op([':',':'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':',':'])|[Item|Lexemes]],[op([':',':'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).
    
%cases for :+ operator
check_operators_elements([op([':','+'])|[bra(Bracket)|Lexemes]],[op([':','+'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','+'])|[name(Function)|[bra('(')|Lexemes]]], [op([':','+'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

check_operators_elements([op([':','+'])|[name(Function)|Lexemes]], [op([':','+'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','+'])|[Item|Lexemes]],[op([':','+'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%cases for :* operator
check_operators_elements([op([':','*'])|[bra(Bracket)|Lexemes]],[op([':','*'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','*'])|[name(Function)|[bra('(')|Lexemes]]], [op([':','*'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

check_operators_elements([op([':','*'])|[name(Function)|Lexemes]], [op([':','*'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','*'])|[Item|Lexemes]],[op([':','*'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%cases for :& operator
check_operators_elements([op([':','&'])|[bra(Bracket)|Lexemes]],[op([':','&'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','&'])|[name(Function)|[bra('(')|Lexemes]]], [op([':','&'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

check_operators_elements([op([':','&'])|[name(Function)|Lexemes]], [op([':','&'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','&'])|[Item|Lexemes]],[op([':','&'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%cases for :| operator
check_operators_elements([op([':','|'])|[bra(Bracket)|Lexemes]],[op([':','|'])|[bra(Bracket)|CurrentLexemes]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','|'])|[name(Function)|[bra('(')|Lexemes]]], [op([':','|'])|[bra('(')|[name(Function)|[bra('(')|CurrentLexemes]]]]):-
    !,
    skip_bracket(Lexemes, Before, After),
    append(Before, [bra(')')|After], NewLexemes),
    check_operators_elements(NewLexemes, CurrentLexemes).

check_operators_elements([op([':','|'])|[name(Function)|Lexemes]], [op([':','|'])|[bra('(')|[name(Function)|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

check_operators_elements([op([':','|'])|[Item|Lexemes]],[op([':','|'])|[bra('(')|[Item|[bra(')')|CurrentLexemes]]]]):-
    !,
    check_operators_elements(Lexemes, CurrentLexemes).

%cases for everything else
check_operators_elements([Other|Lexemes], [Other|NewLexemes]):-
    !,
    check_operators_elements(Lexemes, NewLexemes).








%fix_function_calls(+FunctionNameList, +FunctionList, -NewFunctionList)
%empty list, stop recursion
fix_function_calls(_,[],[]):-
    !.

%fix the calls for each function
fix_function_calls(FunctionNames, [fun(Name,CurrentFunction)|Functions], [fun(Name,NewFunction)|NewFunctions]):-
    !,
    fix_function_calls_function(FunctionNames, CurrentFunction, NewFunction),
    fix_function_calls(FunctionNames, Functions, NewFunctions).


%fix_function_calls_function(+FunctionNameList, +Function, -NewFunction)
%empty list, stop recursion
fix_function_calls_function(_,[],[]):-
    !.

%for each element, fix the inputs and outputs, continue recursion
fix_function_calls_function(FunctionNames, [ele(Caching,Inputs,Output)|Elements], [ele(Caching,NewInputs,NewOutput)|NewElements]):-
    !,
    fix_function_calls_names(FunctionNames, Inputs, NewInputs),
    fix_function_calls_names(FunctionNames, Output, NewOutput),
    fix_function_calls_function(FunctionNames, Elements, NewElements).

%skip comments and documentation, continue recursion
fix_function_calls_function(FunctionNames, [CurrentElement|Functions], [CurrentElement|NewFunctions]):-
    !,
    fix_function_calls_function(FunctionNames, Functions, NewFunctions).


%fix_function_calls_names(+FunctionNameList, +Input, -Output)
%empty list, stop recursion
fix_function_calls_names([],Function,Function):-
    !.

%for each function name, fix the inputs and outputs, continue recursion
fix_function_calls_names([CurrentName|FunctionNames], CurrentFunction, NewFunction2):-
    !,
    fix_function_calls_lexemes(CurrentName, CurrentFunction, NewFunction),
    fix_function_calls_names(FunctionNames, NewFunction, NewFunction2).


%fix_function_calls_lexemes(+FunctionName, +Lexemes, -NewLexemes)
%empty list, stop recursion
fix_function_calls_lexemes(_,[],[]):-
    !.

%if currrent lexeme is an internal function call, fix the brackets
fix_function_calls_lexemes(FunctionName, [name(FunctionName)|Lexemes], [name(FunctionName)|NewFunction]):-
    !,
    fix_function_calls_first_bracket(Lexemes, NewLexemes),
    fix_function_calls_lexemes(FunctionName, NewLexemes, NewFunction).

%if currrent lexeme is an internal map function call, fix the brackets
fix_function_calls_lexemes(FunctionName, [name(OtherName)|Lexemes], [name(OtherName)|NewFunction]):-
    append(['m','a','p'], FunctionName, OtherName),
    !,
    fix_function_calls_first_bracket(Lexemes, NewLexemes),
    fix_function_calls_lexemes(FunctionName, NewLexemes, NewFunction).

%otherwise, skip and recurse
fix_function_calls_lexemes(FunctionName, [Other|Lexemes], [Other|NewFunction]):-
    !,
    fix_function_calls_lexemes(FunctionName, Lexemes, NewFunction).


%fix_function_calls_first_bracket(+Lexemes, -NewLexemes)
%fix calls with variables
fix_function_calls_first_bracket([bra('(')|Lexemes], [bra('(')|[bra('[')|NewFunction]]):-
    !,
    fix_function_calls_second_bracket(Lexemes, NewFunction).

%fix empty calls
fix_function_calls_first_bracket(Other, [bra('(')|[bra('[')|[bra(']')|[bra(')')|Other]]]]).


%fix_function_calls_second_bracket(+Lexemes, -NewLexemes)
%empty list means function not closed, error
fix_function_calls_second_bracket([],[]):-
    !,
    write('Function call not closed'),
    false.

%if open bracket found, skip next bracket, continue recursion
fix_function_calls_second_bracket([bra('(')|Lexemes], [bra('(')|CurrentFunction]):-
    !,
    skip_bracket(Lexemes, Before, NewLexemes),
    fix_function_calls_second_bracket(NewLexemes, NewFunction),
    append(Before, NewFunction, CurrentFunction).

%if close bracket found, stop recursion
fix_function_calls_second_bracket([bra(')')|Lexemes], [bra(']')|[bra(')')|Lexemes]]):-
    !.

%otherwise continue recursion
fix_function_calls_second_bracket([Other|Lexemes], [Other|NewFunction]):-
    !,
    fix_function_calls_second_bracket(Lexemes, NewFunction).


%skip_bracket(+Lexemes, -Before, -After)
%empty list, unclosed bracket
skip_bracket([],_,_):-
    write('Error unclosed bracket').

%open bracket found, skip next bracket, continue recursion
skip_bracket([bra('(')|Lexemes], [bra('(')|Before], NewLexemes):-
    !,
    skip_bracket(Lexemes, Before1, CurrentLexemes),
    skip_bracket(CurrentLexemes, Before2, NewLexemes),
    append(Before1, Before2, Before).

%close bracket found, stop recursion
skip_bracket([bra(')')|Lexemes], [bra(')')], Lexemes):-
    !.

%no bracket, contine recursion
skip_bracket([Other|Lexemes], [Other|Before], NewLexemes):-
    !,
    skip_bracket(Lexemes, Before, NewLexemes).