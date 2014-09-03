package bee.eval.ast
{
  public class MulExpression implements IExpression
  {
    private var _left: IExpression;
    private var _right: IExpression;

    public function MulExpression( left: IExpression, right: IExpression )
    {
      _left = left;
      _right = right;
    }

    public function evaluate():*
    {
      return _left.evaluate() * _right.evaluate();
    }

    public function get left():IExpression
    {
      return _left;
    }

    public function get right():IExpression
    {
      return _right;
    }

    public function toString():String
    {
      return _left + " " + _right + " * ";
    }
  }
}