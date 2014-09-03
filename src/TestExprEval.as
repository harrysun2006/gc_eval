package
{
  import flash.display.Sprite;
  import flash.utils.getTimer;

  import bee.eval.Compiler;
  import bee.eval.Parser;
  import bee.eval.Scanner;
  import bee.eval2.Vars;

  public class TestExprEval extends Sprite
  {
    public static const ITERATIONS: int = 10000;
    public static const EXPRESSION: String = "sin( x / ( 4 / 2.0 * 2 + (- 2.12345 + 2.12345) * x / x ) ) * 100 - ( sin( x / ( 4 / 2.0 * 2 + (- 2.12345 + 2.12345) * x / x ) ) * 100 )";

    public function TestExprEval()
    {
      runTests();
    }

    private function runTests():void
    {
      trace( "Running tests (this may take a while)" );

      runTopDown();
      runBottomUp();
    }

    private function runTopDown():void
    {
      var sum: Number = 0;

      for (var i: int = 0; i < ITERATIONS; ++i)
      {
        var t: Number = getTimer();

        var scanner: Scanner = new Scanner( EXPRESSION );
        var parser: Parser = new Parser( scanner );

        var compiled: Compiler = parser.parse();
        compiled.execute( {
            'x'		: Math.random(),
            'sin'	: Math.sin,
            'cos'	: Math.cos
          } );

        sum += ( getTimer() - t );
      }

      trace( "Top Down parser:", sum / ITERATIONS );
    }

    private function runBottomUp():void
    {
      var sum: Number = 0;

      Vars.symbolTable.sin = Math.sin;

      for (var i: int = 0; i < ITERATIONS; ++i)
      {
        Vars.symbolTable.x = Math.random();

        var t: Number = getTimer();
        var myparser: TestBottomUpParser = new TestBottomUpParser();

        myparser.yyparse()

        sum += ( getTimer() - t );
      }

      trace( "Bottom Up parser:", sum / ITERATIONS );
    }
  }
}

import bee.eval2.BottomUpParser;
import bee.eval2.Lexer;

class TestBottomUpParser extends BottomUpParser
{
  private var _lexer: Lexer;

  public function TestBottomUpParser()
  {
    super();

    _lexer = new Lexer( TestExprEval.EXPRESSION );
  }

  override public function yylex():int
  {
    var value: Object = _lexer.scan();

    if (value == null)
    {
      return 0;
    }

    set_yylval( value.val );

    return value.type;
  }
}