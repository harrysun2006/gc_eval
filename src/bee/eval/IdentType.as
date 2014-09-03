package bee.eval
{

  [ExcludeClass]
  public class IdentType
  {
    public static const VAR:IdentType = new IdentType(1, singleton);
    public static const FUN:IdentType = new IdentType(2, singleton);
    public static const UNDEF:IdentType = new IdentType(0, singleton);
    public static const types:Array = [VAR, FUN, UNDEF];

    private static function singleton():void
    {
    }

    private var _type:int;

    public function IdentType( type: int, caller: Function = null )
    {
      if (caller != singleton)
        throw new Error("IdentType is an enum class, can not be instanced outside!!!");
      _type = type;
    }

    public function get type():int
    {
      return _type;
    }

    public function get uid():int
    {
      return _type;
    }

    public function toString():String
    {
      switch (_type)
      {
        case 1:
          return "variable";
        case 2:
          return "function";
        default:
          return "undefine";
      }
      return null;
    }

    public static function size():int
    {
      return types.length;
    }

    public static function item(v:int):IdentType
    {
      for each (var type:IdentType in types)
      {
        if (type._type == v)
          return type;
      }
      return UNDEF;
    }
  }
}