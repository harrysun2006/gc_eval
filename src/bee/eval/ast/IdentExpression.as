package bee.eval.ast
{
  import bee.eval.Ident;

  public class IdentExpression implements IExpression
  {
    private var _value: Ident;

    public function IdentExpression( value: Ident )
    {
      _value = value;
    }

    public function get id():Ident
    {
      return _value;
    }

    public function evaluate():*
    {
      return _value.value;
    }

    public function toString():String
    {
      return "" + _value;
    }

  }
}