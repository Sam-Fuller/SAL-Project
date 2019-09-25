:- ['LexicalParser.pl','SyntaxParser.pl','JSGenerator.pl'].

compile(InFileName, OutFileName) :-

   %lexical analysis, read in lexemes from file
   open(InFileName, 'read', InFile),
   lexical_parser(InFile, Lexemes),
   close(InFile),
   !,
   check_imports(Lexemes, ImportLexemes),

   %syntax analysis
   %turn into functions
   syntax_parser(ImportLexemes, Syntax),
   %get the list of all function names
   function_list(Syntax, Functions),
   %fix operators and brackets
   check_operators(Syntax, OpFixedSyntax),
   %fix the function calls
   fix_function_calls(Functions, OpFixedSyntax, FixedSyntax),
   !,

   %generate code, write to file
   open(OutFileName, 'write', OutFile),
   code_generator(FixedSyntax, Functions, OutFile),
   close(OutFile),

   %success
   write('Program Compiled Succesfully').