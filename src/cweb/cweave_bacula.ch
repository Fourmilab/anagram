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

@x
    if (c=='\\') if (loc>=limit) continue;
      else if (++id_loc<=section_text_end) {
        *id_loc = '\\'; c=*loc++;
      }
@y
    if (c=='\\') { if (loc>=limit) continue;
      else if (++id_loc<=section_text_end) {
        *id_loc = '\\'; c=*loc++;
      }
    }
@z

@x
else if (c=='\\' && *loc!='@@')
  if (phase==2) app_tok(*(loc++)) else loc++;
@y
else if (c=='\\' && *loc!='@@') {
  if (phase==2) app_tok(*(loc++)) else loc++; }
@z

@x
    if (b=='\'' || b=='"')
      if (delim==0) delim=b;
      else if (delim==b) delim=0;
@y
    if (b=='\'' || b=='"') {
      if (delim==0) delim=b;
      else { if (delim==b) delim=0; }
    }
@z

@x
    if (out_ptr>out_buf+1)
      if (*(out_ptr-1)=='\\')
@.\\6@>
@.\\7@>
@.\\Y@>
        if (*out_ptr=='6') out_ptr-=2;
        else if (*out_ptr=='7') *out_ptr='Y';
    out_str("\\par"); finish_line();
  }
@y
    if (out_ptr>out_buf+1)
      if (*(out_ptr-1)=='\\') {
@.\\6@>
@.\\7@>
@.\\Y@>
        if (*out_ptr=='6') out_ptr-=2;
        else { if (*out_ptr=='7') *out_ptr='Y'; }
      }
    out_str("\\par"); finish_line();
  }
@z


