package bee.eval
{
  public final class TokenType
  {
    public static const ADD: int = 1;
    public static const SUB: int = 2;
    public static const MUL: int = 3;
    public static const DIV: int = 4;
    public static const NUM: int = 5;
    public static const IDENT: int = 6;
    public static const LEFT_PAR: int = 7;
    public static const RIGHT_PAR: int = 8;
    public static const COMMA: int = 9;
    public static const QUOTE: int = 10;
    public static const NULL: int = 0;
    public static const EOF: int = -1;

    /**
       public static const ADD:TokenType = new TokenType(1, singleton);
       public static const SUB:TokenType = new TokenType(2, singleton);
       public static const MUL:TokenType = new TokenType(3, singleton);
       public static const DIV:TokenType = new TokenType(4, singleton);
       public static const NUM:TokenType = new TokenType(5, singleton);
       public static const IDENT:TokenType = new TokenType(6, singleton);
       public static const LEFT_PAR:TokenType = new TokenType(7, singleton);
       public static const RIGHT_PAR:TokenType = new TokenType(8, singleton);
       public static const COMMA:TokenType = new TokenType(9, singleton);
       public static const NULL:TokenType = new TokenType(0, singleton);
       public static const EOF:TokenType = new TokenType(-1, singleton);
     **/

    public static function typeToString( type: int ):String
    {
      switch (type)
      {
        case 0:
          return "NULL";
        case 1:
          return "+";
        case 2:
          return "-";
        case 3:
          return "*";
        case 4:
          return "/";
        case 5:
          return "NUM";
        case 6:
          return "IDENT";
        case 7:
          return "(";
        case 8:
          return ")";
        case 9:
          return ",";
        case 10:
          return "'";
        default:
          return "EOF";
      }

      return null;
    }
  }
}