package bee.eval
{
  public class ParseError extends Error
  {
    public var data:Object;

    public static const NOT_FUNCTION:int = 10001; // "not.function"
    public static const UNEXPECTED_TOKEN:int = 10002; // "unexpected.token"
    public static const MISSING_TOKEN_RIGHTPAR:int = 10003; // "missing.token.rightpar"
    public static const MISSING_TOKEN_LEFTPAR:int = 10004; // "missing.token.leftpar"

    public function ParseError(message: String, id: int = 0, data:Object = null)
    {
      super(message, id);
      this.data = data;
    }

    public function get id():int
    {
      return this.errorID;
    }
  }
}