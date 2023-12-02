grammar final;
main: (line '\n')+ EOF;
line: assign | control;

//DEFINITIONS
id: (UND | LET)(UND | LET | INT)*;
operand: id | LITERAL;

//DRIVERS
assign: id ASSIGN_OP arith;
control: if | while | for;

//TERMINATORS
arith: operand ARITH_OP arith | O_PAREN arith C_PAREN | operand;
truth: 'not'? (operand COMPAR_OP operand | O_PAREN truth C_PAREN | operand) (('and' | 'or') truth)?;

//CONTROL STATEMENTS
if: 'if' truth ':' ('\n\t' line)+ ('\n' (elif | else))?;
elif: 'el' if;
else: 'else:' ('\n\t' line)+;
while: 'while' truth ':' ('\n\t' line)+ else?; // CURSED PYTHON JANK
for: 'for' id 'in' (ARRAY | STRING | 'range' O_PAREN INT APOS INT C_PAREN) ':' ('\n\t' line)+;


//                 > LEXER <                \\

//IGNORE CHANNEL
WHITESPACE: [ \n] -> skip;
BLOCK_COMMENT: '\'\'\'' .*? '\'\'\'' -> skip;
COMMENT: '#' .*? '\n' -> skip;

//type
LITERAL: INT | FLOAT | CHAR | BOOL | STRING | ARRAY;
INT: [0-9]+;
FLOAT: INT DOT INT;
CHAR: SIN_Q . SIN_Q;
BOOL: 'True' | 'False';
STRING: DBL_Q .*? DBL_Q;
ARRAY: O_BRACK (LITERAL (SIN_Q LITERAL)*)? C_BRACK;

//specials
SIN_Q: '\'';
DBL_Q: '"';
APOS: ',';
UND: '_';
DOT: '.';
LET: [a-z] | [A-Z];

//precidence
O_BRACK: '[';
C_BRACK: ']';
O_BRACE: '{';
C_BRACE: '}';
O_PAREN: '(';
C_PAREN: ')';

//arithmatic
ARITH_OP: MOD | MUL | DIV | ADD | SUB;
MOD: '%';
MUL: '*';
DIV: '/';
ADD: '+';
SUB: '-';

//comparison
COMPAR_OP: EQ | NEQ | GT | GTE | LT | LTE;
EQ: '==';
NEQ: '!=';
GT: '>';
GTE: '>=';
LT: '<';
LTE: '<=';

//assignment
ASSIGN_OP: ARITH_OP? '=';
