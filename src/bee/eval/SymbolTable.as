package bee.eval
{
  import flash.utils.Dictionary;

  public class SymbolTable
  {
    private var _symbols: Array;

    public function SymbolTable()
    {
      _symbols = new Array();
    }

    public function find( s: String ):Ident
    {
      for each (var ident:Ident in _symbols)
      {
        if (ident.id == s)
        {
          return ident;
        }
      }

      return null;
    }

    public function add( ident: Ident ):void
    {
      _symbols.push( ident );
    }

    public function findAndAdd( s: String ):Ident
    {
      var ident: Ident = find( s );
      if (ident == null)
      {
        ident = new Ident( Ident.U, s );
        add( ident );
      }
      ident.addRef();

      return ident;
    }

    public function get symbols():Array
    {
      return _symbols;
    }
  }
}