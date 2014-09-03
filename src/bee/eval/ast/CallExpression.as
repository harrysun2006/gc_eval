package bee.eval.ast
{
  import bee.eval.Ident;
  import bee.eval.ParseError;

  public class CallExpression implements IExpression
  {
    private var _name: Ident;
    private var _arguments: Array;

    public function CallExpression( name: Ident, arguments: Array )
    {
      _name = name;
      _arguments = arguments;
    }

    public function get id():Ident
    {
      return _name;
    }

    public function evaluate():*
    {
      var args: Array = new Array();

      for each (var argument:IExpression in _arguments)
      {
        args.push( argument.evaluate() );
      }

      if (!(_name.value is Function))
      {
        throw new ParseError( "Not function " + _name.id, ParseError.NOT_FUNCTION, _name);
      }

      return ( _name.value as Function ).apply( null, args );
    }

    public function get args():Array
    {
      return _arguments;
    }

    public function toString():String
    {
      var args: Array = new Array();

      for each (var argument:IExpression in _arguments)
      {
        args.push( argument.toString() );
      }

      return "( " + args.join( ", " ) + " ) " + _name;
    }

  }
}