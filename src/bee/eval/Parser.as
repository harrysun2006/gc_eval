package bee.eval
{
  import bee.eval.ast.AddExpression;
  import bee.eval.ast.CallExpression;
  import bee.eval.ast.DivExpression;
  import bee.eval.ast.IExpression;
  import bee.eval.ast.IdentExpression;
  import bee.eval.ast.MulExpression;
  import bee.eval.ast.NumberExpression;
  import bee.eval.ast.SubExpression;
  import bee.eval.ast.UnaryMinusExpression;
  import bee.eval.ast.UnaryPlusExpression;

  public class Parser
  {
    private var _scanner: Scanner;
    private var _symbols: SymbolTable;
    private var _token: Token;

    public function Parser( scanner: Scanner )
    {
      _scanner = scanner;
      _symbols = new SymbolTable();
    }

    public function parse():Compiler
    {
      _token = _scanner.nextToken();
      var expr: IExpression = parseExpression();
      switch (_token.type)
      {
        case TokenType.EOF:
          return new Compiler( expr, _symbols );
        case TokenType.RIGHT_PAR:
          throw new ParseError( "Unexpected token '" + _token + "', expecting '('!", ParseError.MISSING_TOKEN_LEFTPAR, _token );
          break;
        default:
          throw new ParseError( "Unexpected token '" + _token + "'!", ParseError.UNEXPECTED_TOKEN, _token );
          break;
      }
    }

    private function parseExpression():IExpression
    {
      var operator: int;
      var left: IExpression;
      var right: IExpression;
      left = parseTerm();
      while (( _token.type == TokenType.ADD ) || ( ( _token.type == TokenType.SUB ) ))
      {
        operator = _token.type;
        _token = _scanner.nextToken();
        right = parseTerm();
        if (operator == TokenType.ADD)
        {
          left = new AddExpression( left, right );
        }
        else
        {
          left = new SubExpression( left, right );
        }
      }
      return left;
    }

    private function parseFactor():IExpression
    {
      var tree: IExpression;
      var unary: Array = new Array();
      while (( _token.type == TokenType.ADD ) || ( ( _token.type == TokenType.SUB ) ))
      {
        unary.push( _token );
        _token = _scanner.nextToken();
      }
      switch (_token.type)
      {
        case TokenType.NUM:
          tree = new NumberExpression( _token.value );
          _token = _scanner.nextToken();
          break;
        case TokenType.IDENT:
          var ident_name: String = _token.value;
          var ident: Ident = _symbols.findAndAdd( ident_name );
          tree = new IdentExpression( ident );
          _token = _scanner.nextToken();
          if (_token.type == TokenType.LEFT_PAR)
          {
            var arguments: Array = new Array();
            var expr: Object;
            _token = _scanner.nextToken();
            if (_token.type != TokenType.RIGHT_PAR)
            {
              do
              {
                expr = parseExpression();
                arguments.push( expr );
                if (_token.type == TokenType.COMMA)
                  _token = _scanner.nextToken();
                else
                  break;
              } while (_token.type != TokenType.EOF);
              if (_token.type != TokenType.RIGHT_PAR)
              {
                throw new ParseError( "Unexpected token '" + _token + "', expecting ')'!", ParseError.MISSING_TOKEN_RIGHTPAR, _token );
              }
              else
              {
                _token = _scanner.nextToken();
              }
            }
            else
            {
              _token = _scanner.nextToken();
            }
            ident.type = Ident.F;
            tree = new CallExpression( ident, arguments );
            ident.addRef(tree);
          }
          else
          {
            ident.type = Ident.V;
          }
          break;
        case TokenType.LEFT_PAR:
          _token = _scanner.nextToken();
          tree = parseExpression();
          if (_token.type == TokenType.RIGHT_PAR)
          {
            _token = _scanner.nextToken();
          }
          else
          {
            throw new ParseError( "Unexpected token '" + _token + "', expecting ')'!", ParseError.MISSING_TOKEN_RIGHTPAR, _token );
          }
          break;
        case TokenType.RIGHT_PAR:
          throw new ParseError( "Unexpected token '" + _token + "', expecting '('!", ParseError.MISSING_TOKEN_LEFTPAR, _token );
          break;
        default:
          throw new ParseError( "Unexpected token '" + _token + "'!", ParseError.UNEXPECTED_TOKEN, _token );
          break;
      }
      while (unary.length > 0)
      {
        if (unary.pop().type == TokenType.ADD)
        {
          tree = new UnaryPlusExpression( tree );
        }
        else
        {
          tree = new UnaryMinusExpression( tree );
        }
      }
      return tree;
    }

    private function parseTerm():IExpression
    {
      var operator: int;
      var left: IExpression;
      var right: IExpression;
      left = parseFactor();
      while (( _token.type == TokenType.MUL ) || ( ( _token.type == TokenType.DIV ) ))
      {
        operator = _token.type;
        _token = _scanner.nextToken();
        right = parseFactor();
        if (operator == TokenType.MUL)
        {
          left = new MulExpression( left, right );
        }
        else
        {
          left = new DivExpression( left, right );
        }
      }
      return left;
    }
  }
}