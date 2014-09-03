package bee.eval.ast
{
  import bee.eval.Ident;

  public class UnaryMinusExpression implements IExpression
  {
    private var _value: IExpression;

    public function UnaryMinusExpression( value: IExpression )
    {
      _value = value;
    }

    public function evaluate():*
    {
      return ( - _value.evaluate() );
    }

    public function toString():String
    {
      return _value + " - ";
    }

  }
}