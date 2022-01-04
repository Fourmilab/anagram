@x
extern history; /* indicates how bad this run was */
extern err_print(); /* print error message and context */
extern wrap_up(); /* indicate |history| and exit */
@y
extern int history; /* indicates how bad this run was */
extern int err_print(); /* print error message and context */
extern int wrap_up(); /* indicate |history| and exit */
@z

@x
extern include_depth; /* current level of nesting */
@y
extern int include_depth; /* current level of nesting */
@z

@x
extern line[]; /* number of current line in the stacked files */
extern change_line; /* number of current line in change file */
@y
extern int line[]; /* number of current line in the stacked files */
extern int change_line; /* number of current line in change file */
@z

@x
extern reset_input(); /* initialize to read the web file and change file */
extern get_line(); /* inputs the next line */
extern check_complete(); /* checks that all changes were picked up */
@y
extern int reset_input(); /* initialize to read the web file and change file */
extern int get_line(); /* inputs the next line */
extern int check_complete(); /* checks that all changes were picked up */
@z

@x
  case '-': if (*loc=='-') {compress(minus_minus);}
    else if (*loc=='>') if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
@y
  case '-': if (*loc=='-') {compress(minus_minus);}
    else {if (*loc=='>') {if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt);}} break;
@z
