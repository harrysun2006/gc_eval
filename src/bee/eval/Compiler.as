package bee.eval
{
  import bee.eval.ast.IExpression;

  public class Compiler
  {
    private var _expression: IExpression;
    private var _symbols: SymbolTable;

    public function Compiler( expression: IExpression, symbols: SymbolTable )
    {
      _expression = expression;
      _symbols = symbols;
    }

    public function execute( context: Object ):Number
    {
      for (var key:String in context)
      {
        var ident: Ident = _symbols.find( key );
        if (ident)
        {
          ident.value = context[ key ];
        }
      }
      return _expression.evaluate();
    }

    public function toString():String
    {
      return _expression.toString();
    }

    public function get expression():IExpression
    {
      return _expression;
    }

    public function get symbols():Array
    {
      return _symbols.symbols;
    }
  }
}