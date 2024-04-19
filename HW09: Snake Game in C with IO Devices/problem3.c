/*********************************************************
 * file name   : problem3.c                              *
 * author      : Thomas Farmer
 * description : C program to call LC4-Assembly TRAP_PUTS
 *               TRAP_GETC, TRAP_PUTC, to read chars
 *               from the keyboard & output them         *
 *********************************************************
*
*/

int main() {
  char my_string [] = {'T', 'y', 'p', 'e', ' ', 'H', 'e', 'r', 'e', '>', '\0'} ;  /* a NULL terminated string in C */
  lc4_puts (my_string);

	/*  TODO:
		create a loop that will:
			read a character from the keyboard (using lc4_getc)
			echo that character to the ASCII display (using lc4_putc)
		end loop - once the "enter" key is pressed
	*/

	while (1) {
		char c = lc4_getc();

		if (c == '\n') {
			break;
		}

		lc4_putc(c);
	}

  return (0) ;
}
