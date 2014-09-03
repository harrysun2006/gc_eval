package bee.eval2
{
  public class Lexer
  {
    private var _pos: int;
    private var _pool: Array;
    private var _source: String;

    public function Lexer( source: String )
    {
      _pos = 0;
      _source = source;
      _pool = new Array();
    }

    public function scan():Object
    {
      if (_pool.length > 0)
      {
        return _pool.shift();
      }

      skipWhites();

      if (isEOF())
      {
        return null;
      }

      var c: String = _source.charAt( _pos++ );

      switch (c)
      {
        case '+':
        case '-':
        case '*':
        case '/':
        case '(':
        case ')':
        case ',':
          return { type: c.charCodeAt( 0 ), val: c };

        default:

          var buf: String = "";
          var code: int = c.charCodeAt( 0 );

          if (isNumber( code ))
          {
            var num: Number;

            while (isNumber( code ))
            {
              buf += c;

              if (isEOF())
              {
                ++_pos;
                break;
              }

              c  = _source.charAt( _pos++ );
              code = c.charCodeAt( 0 );
            }

            if (c == '.')
            {
              buf += c;
              c  = _source.charAt( _pos++ );
              code = c.charCodeAt( 0 );

              while (isNumber( code ))
              {
                buf += c;

                if (isEOF())
                {
                  ++_pos;
                  break;
                }

                c  = _source.charAt( _pos++ );
                code = c.charCodeAt( 0 );
              }

              num = parseFloat( buf );
            }
            else
            {
              num = parseInt( buf );
            }

            --_pos;
            return { type: Token.NUMBER, val: num };
          }

          if (isAlpha( code ) || ( c == '_' ))
          {

            while (isAlpha( code ) || ( c == '_' ) || isNumber( code ))
            {
              buf += c;

              if (isEOF())
              {
                ++_pos;
                break;
              }

              c  = _source.charAt( _pos++ );
              code = c.charCodeAt( 0 );
            }

            --_pos;
            return { type: Token.SYMBOL, val: buf };
          }

          break;
      }

      return null;
    }

    public function pushBack( token: Token ):void
    {
      _pool.push( token );
    }

    protected function isNumber( c: int ):Boolean
    {
      return ( c >= 48 ) && ( c <= 57 );
    }

    protected function isAlpha( c: int ):Boolean
    {
      return ( ( c >= 97 ) && ( c <= 122 ) ) || ( ( c >= 65 ) && ( c <= 90 ) );
    }

    protected function isEOF():Boolean
    {
      return ( _pos >= _source.length );
    }

    protected function skipWhites():void
    {
      while (!isEOF())
      {
        var c: String = _source.charAt( _pos++ );
        if (( c != " " ) && ( c != "\t" ))
        {
          --_pos;
          break;
        }
      }
    }
  }
}