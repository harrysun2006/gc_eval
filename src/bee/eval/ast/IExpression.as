package bee.eval.ast
{
  public interface IExpression
  {
    function evaluate():*;
    function toString():String;
  }
}