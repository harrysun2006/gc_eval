package bee.eval
{
  import bee.eval.ast.CallExpression;
  import bee.eval.ast.IExpression;

  public class Ident
  {
    public static const V: IdentType = IdentType.VAR;
    public static const F: IdentType = IdentType.FUN;
    public static const U: IdentType = IdentType.UNDEF;

    private var _id: String;
    private var _value: *;
    private var _type: IdentType;
    private var _calls: Array;
    private var _count: int;

    public function Ident( type: IdentType, id: String, value: * = null )
    {
      _type = type;
      _id = id;
      _value = value;
      _calls = [];
      _count = 0;
    }

    public function get id():String
    {
      return _id;
    }

    public function get value():*
    {
      return _value;
    }

    public function set value( v: * ):void
    {
      _value = v;
    }

    public function get isV():Boolean
    {
      return _type == V;
    }

    public function get isF():Boolean
    {
      return _type == F;
    }

    public function get type():IdentType
    {
      return _type;
    }

    public function set type( v: IdentType ):void
    {
      _type = v;
    }

    public function get count():int
    {
      return isF ? _calls.length : _count;
    }

    public function get calls():Array
    {
      return _calls;
    }

    public function addRef( call: IExpression = null ):void
    {
      _count++;
      if (call is CallExpression && isF)
        _calls.push(call);
    }

    public function toString():String
    {
      return _id;
    }
  }
}