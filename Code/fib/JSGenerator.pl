%code_generator(+Function List, +Function Names, +File)
%writes a list of functions to a file
%changes each element to code and writes to the file
code_generator([],_,_).

code_generator([fun(Name,Function)|Syntax], FunctionNames, File):-
    !,
    write('Compiling '),

    %element list
    write(File, 'const '),write_name(File, Name),write(File, 'elements = ['),nl(File),
    code_generator_element(Function, FunctionNames, File, Documentation),write(File, '];'),nl(File),nl(File),
    
    %cache
    write(File, 'var '),code_generator_list(File, Name),write(File, 'cache = [];'),nl(File),nl(File),

    %main function
    write(File, '/**'),code_generator_list(File, Documentation),write(File, '*/'),nl(File),
    write(File, 'function '),code_generator_list(File, Name),write(File, '(variables){'),nl(File),
    write(File, '   if(typeof(variables) != "object") variables = [variables];'),nl(File),
    write(File, '   return salfunction(variables, '), code_generator_list(File, Name), write(File, 'elements, '),code_generator_list(File, Name), write(File, 'cache);'),nl(File),
    write(File, '}'),nl(File),nl(File),

    %map function
    write(File, 'function map'),code_generator_list(File, Name),write(File, '(variables){'),nl(File),
    write(File, '   return variables.shift().map(variable => {'),nl(File),
    write(File, '      var currentVariables = variables;'),nl(File),
    write(File, '      currentVariables.unshift(variable);'),nl(File),
    write(File, '      return '),code_generator_list(File, Name),write(File, '(currentVariables);'),nl(File),
    write(File, '   }).filter(x => x != null);'),nl(File),
    write(File, '}'),nl(File),nl(File),

    %html function
    write(File, 'function html'),code_generator_list(File, Name),write(File, '(HTMLelement, variables) {'),nl(File),
    write(File, '   HTMLelement.innerHTML = '),code_generator_list(File, Name),write(File, '(variables);'),nl(File),
    write(File, '}'),nl(File),nl(File),nl(File),
    
    write('   Success'),nl,
    code_generator(Syntax, FunctionNames, File).


%write_name(+File, +Name)
%writes a name to file and the console
write_name(_, []).
write_name(File, [Letter|Name]):-
    write(File, Letter),
    write(Letter),
    write_name(File, Name).


%code_generator_element(+Function, + FunctionNames, +File, -Documentation)
%writes an element to a file
%empty list, end case
code_generator_element([],_,_,_):-
    !.

%documentation, return documentation, continue with the rest of the function
code_generator_element([doc(Documentation)|Function], FunctionNames, File, Documentation):-
    !,
    code_generator_element(Function, FunctionNames, File, _).

%comment, save comment to file, continue with the rest of the function
code_generator_element([com(Comment)|Function], FunctionNames, File, Documentation):-
    !,
    write(File,'/*'),
    code_generator_list(File, Comment),
    write(File,'*/'),
    nl(File),
    code_generator_element(Function, FunctionNames, File, Documentation).

%element, save to file, continue with the rest of the function
code_generator_element([ele(Caching, Inputs, Output)|Function], FunctionNames, File, Documentation):-
    !,
    write(File, '   ['),
    write(File, Caching),
    write(File, ',   (vars)=>{return '),
    %write inputs to file
    code_generator_input(File, Inputs),
    write(File, '},   (vars)=>{return '),
    %write outputs to file
    code_generator_output(File, Output),
    write(File, '}],'),
    nl(File),
    code_generator_element(Function, FunctionNames, File, Documentation).


%code_generator_list(File, Name)
%write name to file
code_generator_list(_, []).
code_generator_list(File, [Letter|Name]):-
    !,
    write(File, Letter),
    code_generator_list(File, Name).


%code_generator_input(+File, +Inputs)
%writes the inputs of an element to a list
%empty list, no inputs, write true
code_generator_input(File, []):-
    !,
    write(File, true).

%last input, write to file, end recursion
code_generator_input(File, [Current|[]]):-
    !,
    code_generator_lexeme(File, Current),
    !.

%where operator special case, ignore, continue recursion
code_generator_input(File, [var(_)|[op(['|'])|Inputs]]):-
    !,
    code_generator_input(File, Inputs).

%default case, write to file, continue recursion
code_generator_input(File, [Current|Inputs]):-
    !,
    code_generator_lexeme(File, Current),
    !,
    code_generator_input(File, Inputs).


%code_generator_output(+File, Outputs)
%writes the outputs of an element to a list
%empty list, no outputs, write null
code_generator_output(File, []):-
    !,
    write(File, null).

%last input, write to file, end recursion
code_generator_output(File, [Current|[]]):-
    !,
    code_generator_lexeme(File, Current),
    !.

%default case, write to file, continue recursion
code_generator_output(File, [Current|Inputs]):-
    !,
    code_generator_lexeme(File, Current),
    !,
    code_generator_output(File, Inputs).


%code_generator_lexeme(+File, Lexeme)
%writes a lexeme to file
%writes a variable name to file
code_generator_lexeme(File, var(Variable)):-
    write(File, 'vars['),
    write(File, Variable),
    write(File, ']').

%writes a special char to file
code_generator_lexeme(File, special(SpecialChar)):-
    write(File, SpecialChar).

%writes other characters to file
code_generator_lexeme(File, other(OtherChar)):-
    write(File, OtherChar).

%writes brackets to file
code_generator_lexeme(File, bra(Bracket)):-
    write(File, Bracket).

%writes numbers to file
code_generator_lexeme(File, num(Number)):-
    code_generator_list(File, Number).

%writes strings to file
code_generator_lexeme(File, str(String)):-
    write(File, '\"'),
    code_generator_list(File, String),
    write(File, '\"').

%writes function names to file
code_generator_lexeme(File, name(Name)):-
    code_generator_list(File, Name).

%writes . operator to file
code_generator_lexeme(File, op(['.'])):-
    !,
    write(File, '.').

%writes + operator to file
code_generator_lexeme(File, op(['+'])):-
    !,
    write(File, '+').

%writes - operator to file
code_generator_lexeme(File, op(['-'])):-
    !,
    write(File, '-').

%writes * operator to file
code_generator_lexeme(File, op(['*'])):-
    !,
    write(File, '*').

%writes / operator to file
code_generator_lexeme(File, op(['/'])):-
    !,
    write(File, '/').

%writes % operator to file
code_generator_lexeme(File, op(['%'])):-
    !,
    write(File, '%').

%writes ** operator to file
code_generator_lexeme(File, op(['*','*'])):-
    !,
    write(File, '**').

%writes && operator to file
code_generator_lexeme(File, op(['&','&'])):-
    !,
    write(File, '&&').

%writes || operator to file
code_generator_lexeme(File, op(['|','|'])):-
    !,
    write(File, '||').

%writes ! operator to file
code_generator_lexeme(File, op(['!'])):-
    !,
    write(File, '!').

%writes < operator to file
code_generator_lexeme(File, op(['<'])):-
    !,
    write(File, '<').

%writes > operator to file
code_generator_lexeme(File, op(['>'])):-
    !,
    write(File, '>').

%writes <= operator to file
code_generator_lexeme(File, op(['<','='])):-
    !,
    write(File, '<=').

%writes >= operator to file
code_generator_lexeme(File, op(['>','='])):-
    !,
    write(File, '>=').

%writes == operator to file
code_generator_lexeme(File, op(['=','='])):-
    !,
    write(File, '==').

%writes != operator to file
code_generator_lexeme(File, op(['!','='])):-
    !,
    write(File, '!=').

%writes .. function to file
code_generator_lexeme(File, op(['.','.'])):-
    !,
    write(File, 'salListGenerator').

%writes : function to file
code_generator_lexeme(File, op([':'])):-
    !,
    write(File, '.concat').

%writes # function to file
code_generator_lexeme(File, op(['#'])):-
    !,
    write(File, 'salLength').

%writes :: function to file
code_generator_lexeme(File, op([':',':'])):-
    !,
    write(File, 'salJoin').

%writes :+ function to file
code_generator_lexeme(File, op([':','+'])):-
    !,
    write(File, 'salSum').

%writes :* function to file
code_generator_lexeme(File, op([':','*'])):-
    !,
    write(File, 'salProduct').

%writes :& function to file
code_generator_lexeme(File, op([':','&'])):-
    !,
    write(File, 'salAll').

%writes:| function to file
code_generator_lexeme(File, op([':','|'])):-
    !,
    write(File, 'salAny').

%if unknown operator is detected, report to programmer
code_generator_lexeme(_, op(Operator)):-
    !,
    nl,
    write('Unknown Operator '),
    write(Operator),
    nl.