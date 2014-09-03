package bee.eval.ast
{
  public class NumberExpression implements IExpression
  {
    private var _value: Number;

    public function NumberExpression( value: Number )
    {
      _value = value;
    }

    public function get value():Number
    {
      return _value;
    }

    public function evaluate():*
    {
      return _value;
    }

    public function toString():String
    {
      return "" + _value;
    }

  }
}