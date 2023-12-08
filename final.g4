grammar final;
main: (line)+ EOF;
line: (assign | control | ) '\n';


//TYPE
literal: int | float | char | bool | string | array;
int: DIGIT int | DIGIT;
float: int DOT int;
char: SIN_Q . SIN_Q;
bool: 'True' | 'False';
string: DBL_Q .*? DBL_Q;
array: O_BRACK (literal (APOS literal)*)? C_BRACK;


//DEFINITIONS
id: (UND | LET) (UND | LET | int)*;
operand: id | literal;

//DRIVERS
assign: id ASSIGN_OP arith;
control: if | while | for;

//TERMINATORS
arith: operand ARITH_OP arith | O_PAREN arith C_PAREN | operand;
truth: 'not'? (operand COMPAR_OP operand | O_PAREN truth C_PAREN | operand) (('and' | 'or') truth)?;

//CONTROL STATEMENTS
if: 'if' truth ':\n' statement_body ((elif | else))?;
elif: 'el' if;
else: 'else:\n' statement_body;
while: 'while' truth ':\n' statement_body else?; // CURSED PYTHON JANK
for: 'for' id 'in' (id | array | string | 'range' O_PAREN int APOS int C_PAREN) ':\n' statement_body;


statement_body: statement_line* statement_end;
statement_line: '\t' line | '\t' statement_line;
statement_end: '\t' (assign | control | ) | '\t' statement_end; //pseudo-line to prevent newline problems



//                 > LEXER <                \\

DIGIT: [0-9];

//IGNORE CHANNEL
WHITESPACE: [ \n] -> skip;
BLOCK_COMMENT: '\'\'\'' .*? '\'\'\'' -> skip;
COMMENT: '#' .*? '\n' -> skip;

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
