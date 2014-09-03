//### This file created by byacc 1.8 / ActionScript 3 extension 0.1)
//### ActionScript support added 2 May 2008, Gabriele Farina
//### Please send bug reports to gabriele@alittleb.it
//### private yysccsid = "@(#)yaccpar	1.8 (Berkeley +Cygnus.28) 01/20/91";



package bee.eval2
{



// #line 2 "cal.y"

// #line 11 "Parser.as"



/*
 * Encapsulates yacc() parser functionality in an ActionScript 3 class
 */
public class BottomUpParser
{
	private var yydebug: Boolean;	// debug output desired ?
	private var yynerrs: int;		// number of errors so far
	private var yyerrflag: int;		// was there an error ?
	private var yychar: int;		// the current working character


	public function debug( msg: String ): void
	{
		if( yydebug )
		{
			trace( msg );
		}
	}

	public function yyerror( msg: String ): void
	{
	    trace( "ERROR: " + msg );
	}

	private var statestk: Array;	// state stack
	private var stateptr: int;          
	private var stateptrmax: int; 		// highest index of stackptr
	private var statemax: int;			// state when highest index reached

	public function state_push( state: int ): void
	{
		statestk[ int( ++stateptr ) ] = state;

		if( stateptr > statemax )
		{
			statemax = state;
			stateptrmax = stateptr;
		}
	}

	public function state_pop(): int
	{
		if( stateptr < 0 )                 //underflowed?
		{
			return -1;
		}

		return statestk[ int( stateptr-- ) ];
	}

	public function state_drop( cnt: int ): void
	{
		var ptr: int = ( stateptr - cnt );

		if( ptr >= 0 )
		{
			stateptr = ptr;
		}
	}

	public function state_peek( relative: int ): int
	{
		var ptr: int = ( stateptr - relative );

		if( ptr < 0 )
		{
			return -1;
		}

		return statestk[ ptr ];
	}

	public function init_stacks(): Boolean
	{
		statestk = new Array( 100 );
		stateptr = -1;
		statemax = -1;
		stateptrmax = -1;
		val_init();

		return true;
	}

	public function yylex(): int
	{
		trace("cascjaskjhcajkshgcjkcs");
		return 0;
	}

	public function dump_stacks( count: int ): void
	{
		trace( "=index==state====value=     s:" + stateptr + "  v:" + get_valptr() );

		for( var i: int = 0; i < count; ++i )
		{
			trace( " " + i + "    " + statestk[ i ] + "      " + get_valstk()[ i ] );
		}

		trace( "======================" );
	}

//########## SEMANTIC VALUES ##########

private var yytext: String;		// user variable to return contextual strings
private var yyval: *;		// used to return semantic vals from action routines
private var yylval: *; 		// the 'lval' (result) got from method yylexlocal valstk;
private var valstk: Array;
private var valptr: int;

public function get_valptr(): int
{
	return valptr;
}

public function get_valstk(): Array
{
	return valstk;
}

public function set_yylval( val: * ): void
{
	yylval = val;
}

public function set_yydebug( val: Boolean ): void
{
	yydebug = val;
}

public function BottomUpParser()
{
	yydebug     = false;        // debug
	yynerrs     = 0;			// number of errors so far
	yyerrflag   = 0;        // was there an error ?
	yychar      = -1;        // current working character
	statestk    = new Array( 100 );         // state stack
	stateptr    = -1;          // state stack pointer
	statemax    = -1;          // state when highest index is reached
	stateptrmax = -1;          // highest index of stackptr
	yytext      = null;        // user variable to return contextual strings
	yyval       = null;        // used to return semantic values from actions
	yylval      = null;        // the 'lval' result got from yylex
	valstk      = new Array( 100 );
	valptr      = -1;

	init_stacks();
}

public function val_init(): void
{
	valstk = new Array( 100 );
	yyval  = null;
	yylval = null;
	valptr = -1;
}

public function val_push( val: * ): void
{
	valstk[ int( ++valptr ) ] = val;
}

public function val_pop(): *
{
	if( valptr < 0 )
	{
		return null; /* false ??? */
	}
	
	return valstk[ int( valptr-- ) ];
}

public function val_drop( cnt: int ): void
{
	var ptr: int = ( valptr - cnt );
	
	if( ptr >= 0 )
	{
		valptr = ptr;
	}
}

public function val_peek( relative: int ): *
{
	var ptr: int = ( valptr - relative );
	
	if( ptr >= 0 )
	{
		return valstk[ ptr ];
	}
	
    return null; /* false ??? */
}

//#### end semantic value section ####
public static const YYERRCODE: int = 256;
public static const yylhs: Array = [                            -1,
    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,];
public static const yylen: Array = [                            2,
    1,    3,    3,    3,    3,    2,    3,    4,    1,    1,];
public static const yydefred: Array = [                          0,
   10,    0,    0,    0,    0,    0,    0,    6,    0,    0,
    0,    0,    0,    0,    7,    0,    0,    4,    5,    8,];
public static const yydgoto: Array = [                          5,
    6,];
public static const yysindex: Array = [                       -40,
    0,  -38,  -40,  -40,    0,  -11,  -40,    0,  -24,  -40,
  -40,  -40,  -40,  -17,    0,  -39,  -39,    0,    0,    0,]
;
public static const yyrindex: Array = [                         0,
    0,    1,    0,    0,    0,   11,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    4,    9,    0,    0,    0,]
;
public static const yygindex: Array = [                         0,
    3,];
public static const YYTABLESIZE: int = 218;
public static const yytable: Array = [                          4,
    9,    7,   12,    2,    3,    8,    9,   13,    3,   14,
    1,    0,   16,   17,   18,   19,   15,   12,   10,    0,
   11,    0,   13,   20,   12,   10,    0,   11,    0,   13,
   12,   10,    0,   11,    0,   13,    0,    0,    0,    0,
    0,    9,    9,    9,    2,    9,    2,    9,    2,    3,
    0,    3,    0,    3,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    1,    2,];
public static const yycheck: Array = [                          40,
    0,   40,   42,    0,   45,    3,    4,   47,    0,    7,
    0,   -1,   10,   11,   12,   13,   41,   42,   43,   -1,
   45,   -1,   47,   41,   42,   43,   -1,   45,   -1,   47,
   42,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,
   -1,   41,   42,   43,   41,   45,   43,   47,   45,   41,
   -1,   43,   -1,   45,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,];
public static const YYFINAL: int = 5;
public static const YYMAXTOKEN: int = 259;
public static const yyname : Array = [,
"end-of-file",null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,"'('","')'","'*'","'+'",null,,
"'-'",null,"'/'",null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,,
null,null,null,null,null,"NUMBER","SYMBOL","NEG",];
public static const yyrule: Array = [
"$accept : program",
"program : expr",
"expr : expr '+' expr",
"expr : expr '-' expr",
"expr : expr '*' expr",
"expr : expr '/' expr",
"expr : '-' expr",
"expr : '(' expr ')'",
"expr : SYMBOL '(' expr ')'",
"expr : SYMBOL",
"expr : NUMBER",
];

public function yylexdebug( state: int , ch: int): void
{
	var s: String;
	
	if( ch < 0 )
	{
		ch = 0;
	}
	
	if( ch <= YYMAXTOKEN ) //check index bounds
	{
		s = yyname[ ch ];		//now get it
	}
	
	if( s == null )
	{
		s = "illegal-symbol";
	}

	debug( "state " + state + ", reading " + ch + " (" + s + ")" );
}

private var yyn: int;		// next next thing to do
private var yym: int;
private var yystate: int;	// current parsing state from state table
private var yys: String;	// current token string

public function yyparse(): int
{
	var doaction: Boolean = false;
	
	init_stacks();
	
	yynerrs = 0;
	yyerrflag = 0;
	yychar = -1;	// impossible char forces a read
	yystate = 0;	// initial state
	
	state_push( yystate );	//save it
	
	while( true )	// until parsing is done, either correctly, or w/error
	{
		doaction = true;
		
		if( yydebug )
		{
			debug( "loop" );
		}
		
		//#### NEXT ACTION (from reduction table)
		yyn = yydefred[ yystate ];
		while( yyn == 0 )
		{
			if( yydebug )
			{
				debug( "yyn: " + yyn + "	state: " + yystate + "	yychar: " + yychar );
			}
			
			if( yychar < 0 )	//we want a char?
			{
				yychar = yylex();	//get next token
				if( yydebug )
				{
					debug( " next yychar: " + yychar );
				}
				
				// #### ERROR CHECK ####
				if( yychar < 0 )	//it it didn't work/error
				{
					yychar = 0;		//change it to default string (no -1!)
					
					if( yydebug )
					{
						yylexdebug( yystate, yychar );
					}
				}
			}
			
			yyn = yysindex[ yystate ];	//get amount to shift by (shift index)
			
			if( ( yyn != 0 ) && ( yyn += yychar ) >= 0 && yyn <= YYTABLESIZE && yycheck[ yyn ] == yychar )
			{
				if( yydebug )
				{
					debug( "state " + yystate + ", shifting to state " + yytable[ yyn ] );
				}
				
				//#### NEXT STATE ####
				yystate = yytable[ yyn ];	//we are in a new state
				state_push( yystate );		//save it
				val_push( yylval );			//push our lval as the input for next rule
				yychar = -1;				//since we have 'eaten' a token, say we need another
				
				if( yyerrflag > 0 )			//have we recovered an error?
				{
					--yyerrflag;			//give ourselves credit
				}
				
				doaction = false;			//but don't process yet
				break;
			}

			yyn = yyrindex[ yystate ];	//reduce
			if( ( yyn !=0 ) && ( yyn += yychar ) >= 0 && yyn <= YYTABLESIZE && yycheck[ yyn ] == yychar )
			{	 //we reduced!
				if( yydebug )
				{
					debug( "reduce" );
				}
				
				yyn = yytable[ yyn ];
				doaction = true; 		//get ready to execute
				break;					//drop down to actions
			}else //ERROR RECOVERY
			{
				if( yyerrflag == 0 )
				{
					yyerror( "syntax error" );
					yynerrs++;
				}
				
				if ( yyerrflag < 3 )	//low error count?
				{
					yyerrflag = 3;
					while( true )	 //do until break
					{
						if( stateptr < 0 )	 //check for under & overflow here
						{
							yyerror( "stack underflow. aborting..." );	//note lower case 's'
							return 1;
						}
						
						yyn = yysindex[ int( state_peek( 0 ) ) ];
						if ( ( yyn != 0 ) && ( yyn += YYERRCODE ) >= 0 && yyn <= YYTABLESIZE && yycheck[ yyn ] == YYERRCODE )
						{
							if( yydebug )
							{
								debug( "state " + state_peek( 0 ) + ", error recovery shifting to state " + yytable[ yyn ] + " " );
							}
							
							yystate = yytable[ yyn ];
							state_push( yystate );
							val_push( yylval );
							doaction = false;
							break;
						}else
						{
							if( yydebug )
							{
								debug( "error recovery discarding state " + state_peek( 0 ) + " " );
							}
								
							if( stateptr < 0 )	 //check for under & overflow here
							{
								yyerror( "Stack underflow. aborting..." );	//capital 'S'
								return 1;
							}
							
							state_pop();
							val_pop();
						}
					}
				}else						//discard this token
				{
					if( yychar == 0 )
					{
						return 1; //yyabort
					}
					
					if( yydebug )
					{
						yys = "illegal-symbol";
						
						if( yychar <= YYMAXTOKEN )
						{
							yys = yyname[ yychar ];
						}
						
						debug( "state " + yystate + ", error recovery discards token " + yychar + " (" + yys + ")" );
					}
					
					yychar = -1;	//read another
				}
			}
			
			yyn = yydefred[ yystate ];
		}
		
		if ( !doaction )	 		//any reason not to proceed?
		{
			continue;				//skip action
		}
		
		yym = yylen[ yyn ];			//get count of terminals on rhs
		
		if( yydebug )
		{
			debug( "state " + yystate + ", reducing " + yym + " by rule " + yyn + " (" + yyrule[ yyn ] + ")" );
		}
		
		if( yym > 0 )				//if count of rhs not 'nil'
		{
			yyval = val_peek( yym - 1 ); //get current semantic value
		}
		
		/* switch(yyn) */
		{
			//########## USER-SUPPLIED ACTIONS ##########
if( yyn == 1 )
// #line 12 "cal.y"
{ Vars.result = val_peek( 0 ); }
if( yyn == 2 )
// #line 16 "cal.y"
{ yyval = val_peek( 2 ) + val_peek( 0 ); }
if( yyn == 3 )
// #line 17 "cal.y"
{ yyval = val_peek( 2 ) - val_peek( 0 ); }
if( yyn == 4 )
// #line 18 "cal.y"
{ yyval = val_peek( 2 ) * val_peek( 0 ); }
if( yyn == 5 )
// #line 19 "cal.y"
{ yyval = val_peek( 2 ) / val_peek( 0 ); }
if( yyn == 6 )
// #line 20 "cal.y"
{ yyval = -val_peek( 0 ); }
if( yyn == 7 )
// #line 21 "cal.y"
{ yyval = val_peek( 1 ); }
if( yyn == 8 )
// #line 22 "cal.y"
{
							if( Vars.symbolTable[ val_peek( 3 ) ] )
							{
								yyval = Vars.symbolTable[ val_peek( 3 ) ]( val_peek( 1 ) );
							} else
							{
								trace( "can't find function" );
							}
						}
if( yyn == 9 )
// #line 31 "cal.y"
{ 
							if( Vars.symbolTable[ val_peek( 0 ) ] )
							{
								yyval = Vars.symbolTable[ val_peek( 0 ) ];
							} else
							{
								trace( "can't find symbol" );
							}
						}
if( yyn == 10 )
// #line 40 "cal.y"
{ yyval = yyval; }
// #line 485 "Parser.as"
		//########## END OF USER-SUPPLIED ACTIONS ##########
		}
		
		//#### Now let's reduce... ####
		if( yydebug )
		{
			debug( "reduce" );
		}
		
		state_drop( yym );					//we just reduced yylen states
		yystate = state_peek( 0 );		 	//get new state
		val_drop( yym );				   	//corresponding value drop
		yym = yylhs[ yyn ];					//select next TERMINAL(on lhs)
		
		if( yystate == 0 && yym == 0 )		//done? 'rest' state and at first TERMINAL
		{
			debug( "After reduction, shifting from state 0 to state " + YYFINAL );
			
		  	yystate = YYFINAL;				//explicitly say we're done
		  	state_push( YYFINAL );			//and save it
			val_push( yyval );				//also save the semantic value of parsing
			
		  	if( yychar < 0 )				//we want another character?
			{
				yychar = yylex();			//get next character
				if( yychar < 0 )
				{
					yychar = 0;				//clean, if necessary
				}
				
				if( yydebug )
				{
					yylexdebug( yystate, yychar );
				}
			}
			
			if( yychar == 0 )				//Good exit (if lex returns 0 ;-)
			{
				break;				 		//quit the loop--all DONE
			}
		} else								//else not done yet
		{						 			//get next state and push, for next yydefred[]
			yyn = yygindex[ yym ];			//find out where to go
			if( ( yyn != 0 ) && ( yyn += yystate ) >= 0 && yyn <= YYTABLESIZE && yycheck[ yyn ] == yystate )
			{
				yystate = yytable[ yyn ];	//get new state
			}else
			{
				yystate = yydgoto[ yym ];	//else go to new defred
			}
			
			debug( "after reduction, shifting from state " + state_peek( 0 ) + " to state " + yystate );
		  	state_push( yystate );			//going again, so push state & val...
		  	val_push( yyval );				//for next action
		}
	}//main loop
	
	return 0;//yyaccept!!
}

}
}
