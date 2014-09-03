package bee.eval
{

  import mx.utils.StringUtil;

  public class Util
  {

    public static const ERROR_WRONG_IDS:int = 20001; // "eval.error.wrong.ids"
    public static const ERROR_RECURSIVE:int = 20002; // "eval.error.recursive"
    public static const ERROR_INVALID_EXPRS:int = 21001; // "eval.error.invalid.exprs"
    public static const ERROR_NOT_DEFINED:int = 21002; // "not.defined"
    public static const ERROR_NOT_NUMBER:int = 21003; // "not.number"
    public static const ERROR_DIVIDE_ZERO:int = 21004; // "divide.zero"

    private static function singleton():void
    {
    }

    public function Util(caller:Function=null)
    {
      if (caller != singleton)
        throw new Error("Util is a non-instance class!!!");
    }

    /**
     * validate if the expr list(exprs) is valid or not.
     * @exprs: Object, e.g. {a:V, b:V, c:V, d:V, abs:F, x:"a*(b+3)", y:"c/(d-7)", z:"x+y"}
     *  or    Object, e.g. {a:true, b:true, c:true, d:true, abs:true, x:"a*(b+3)", y:"c/(d-7)", z:"x+y"}
     *  or    String, e.g. "(3+3)*(7-3)/(1+2+1)"
     * @callback: used to format error message, syntax: function(obj:Object):Boolean
     *  - obj: {id:id, expr:expr, error:error, eobj:eobj, eid:eid, edata:edata, dep:dep, miss:miss, comp:comp}
     *    -- id: String, id at left of =
     *    -- expr: String, expression at right of =
     *    -- error: String, return formatted error message
     *    -- eobj: Object, the error object
     *    -- eid: int, the error id
     *    -- edata: Object, error related object
     *    -- dep: Object, {a:Ident, b:Ident, ...}, ids this expr depends on
     *    -- ids: Array, ["a", "b", ...], order by its occurence in the expr
     *    -- miss: Array, ["a", "b", ...], ids this expr required but missing
     *    -- comp: Compiler, contains parsed expression object
     *    -- sylla: Object, container for the validate session
     *  - return true, then continue to parse other exprs; false to break.
     * @return: Object {expr:{a:.., b:.., y:.., z:..}, error:{y:.., z:..}, dep:{y:{}, z:{}},
     * 		valid:true, queue:["a","b","c","d","x","y","z"], miss:{y:["abs"], z:["abs"]}
     * 		flag:singleton, comp:{y:.., z:..}, sylla:{}}
     *  - expr: Object, all exprs input from exprs
     *  - error: Object, parse errors for expressions
     *  - dep: Object, symbols for expression to depend on
     *  - valid: Boolean, if error is null then true, otherwise false
     *  - queue: Array, orders to evaluation expressions
     *  - miss: Object, missing vars or functions for expression
     *  - flag: Function, indicate to this object(r) is returned by validate, used in evaluate
     *  - comp: Object, compiler for expression for quick evaluation later
     *  - sylla: Object, container for the validate session
     **/
    public static function validate(exprs:Object, callback:Function=null):Object
    {
      var r:Object={expr:{}, error:null, dep:{}, valid:true, queue:[],
          miss:{}, flag:singleton, comp:{}, sylla:{}};
      if (exprs is String)
        return validate({"$":exprs}, callback);
      var vfs:Object=new Object(); // vfs: {a:true, b:true, c:true, d:true, sqrt:true}
      var es:Object=new Object(); // es: {x:"a*(b+3)", y:"c/(d-7)", z:"x+y"}
      var ref:Object=new Object();
      var fer:Object=new Object();
      var n:String, obj:Object;

      // basic error message format function
      var f0:Function=function(_obj:Object):Boolean
        {
          if (!_obj.error)
          {
            var _n:String, _s1:String="", _s2:String="", _id:Ident;
            if (_obj.eobj is ParseError)
            {
              if (_obj.eid == ParseError.NOT_FUNCTION) _obj.error=StringUtil.substitute("[{2}] in expression[{0}={1}] is not a function!", [_obj.id, _obj.expr, _obj.edata]);
              else if (_obj.eid == ParseError.UNEXPECTED_TOKEN) _obj.error=StringUtil.substitute("Expression[{0}={1}] contains inparsable symbol[{2}]!", [_obj.id, _obj.expr, _obj.edata]);
              else if (_obj.eid == ParseError.MISSING_TOKEN_RIGHTPAR) _obj.error=StringUtil.substitute("Right parenthesis is missing in expression[{0}={1}]!", [_obj.id, _obj.expr, _obj.edata]);
              else if (_obj.eid == ParseError.MISSING_TOKEN_LEFTPAR) _obj.error=StringUtil.substitute("Left parenthesis is missing in expression[{0}={1}]!", [_obj.id, _obj.expr, _obj.edata]);
            }
            else if (_obj.eobj is Error)
            {
            }
            else
            {
              if (_obj.eid == ERROR_WRONG_IDS)
              {
                for each (_id in _obj.edata) _s1+=_id.id+", ";
                if (_s1.length > 0) _obj.error=StringUtil.substitute("Expression [{0}={1}] refers to unsupported symbol[{2}], only number typed vars or functions are supported!", [_obj.id, _obj.expr, _s1.substr(0, _s1.length-2)]);
              }
              else if (_obj.eid == ERROR_RECURSIVE) _obj.error=StringUtil.substitute("Expression [{0}={1}] recursively calls itself or another expression!", [_obj.id, _obj.expr]);
            }
            if (_obj.miss.length > 0)
            {
              for each (_n in _obj.miss)
              {
                _id=_obj.dep[_n];
                if (_id && _id.isF) _s2+=_n+", ";
                else _s1+=_n+", ";
              }
              if (_s1.length > 0) _obj.error=StringUtil.substitute("Expression [{0}={1}] refers to undefined vars[{2}]!", [_obj.id, _obj.expr, _s1.substr(0, _s1.length-2)]);
              else if (_s2.length > 0) _obj.error=StringUtil.substitute("Expression [{0}={1}] refers to undefined functions[{2}]!", [_obj.id, _obj.expr, _s2.substr(0, _s2.length-2)]);
            }
          }
          if (_obj.error)
          {
            if (!r.error) r.error=new Object();
            r.error[_obj.id]=_obj.error;
            r.valid=false;
          }
          return true;
        };
      // compile function, set: _obj.comp
      var f1:Function=function(_obj:Object):void
        {
          var _n:String=_obj.id;
          var _e:String=_obj.expr;
          var _s:Scanner=new Scanner(_e);
          var _p:Parser=new Parser(_s);
          try {
            var _c:Compiler=_p.parse();
            var _id:Ident;
            for each (_id in _c.symbols)
            {
              if (vfs.hasOwnProperty(_id.id) && !vfs[_id.id])
              {
                _obj.eid=ERROR_WRONG_IDS;
                if (!_obj.edata) _obj.edata=[];
                _obj.edata.push(_id);
              }
              _obj.dep[_id.id]=_id;
              _obj.ids.push(_id.id);
            }
            _obj.comp=_c;
          } catch (pe:ParseError) {
            _obj.eobj=pe;
            _obj.eid=pe.id;
            _obj.edata=pe.data;
          }
        };
      // check references, set: _obj.miss
      var f2:Function=function(_rr:Object, _nn:String, _obj:Object, _direct:Boolean=true):void
        {
          var _n1:String, _n2:String, _ids:Array=[];
          if (!_rr.hasOwnProperty(_nn)) _rr[_nn]=new Object();
          for each (_n1 in _obj.ids)
          {
            if (_nn == _n1)
            {
              _obj.eid=ERROR_RECURSIVE;
              _obj.edata=_n1;
              return;
            }
            if (_direct && !exprs.hasOwnProperty(_n1))
            {
              if (_obj.miss.indexOf(_n1) < 0 && _n1 != "null") _obj.miss.push(_n1);
            }
            _rr[_nn][_n1]=true;	// rr.z.x=true
            // case 1: x before z, rr={x:{a:true, b:true}, ...}, nn=z, ss={x:true, y:true}, n1=x
            if (_rr.hasOwnProperty(_n1))
            {
              for (_n2 in _rr[_n1]) 
              {
                if (_nn == _n2)
                {
                  _obj.eid=ERROR_RECURSIVE;
                  _obj.edata=_n2;
                  return;
                }
                _rr[_nn][_n2]=true;
              }
            }
          }
        };
      // create reversed references
      var f3:Function=function(_ff:Object, _obj:Object):void
        {
          var _nn:String=_obj.id;
          var _n3:String;
          for each (_n3 in _obj.ids)
          {
            if (!es.hasOwnProperty(_n3)) continue;
            if (!_ff.hasOwnProperty(_n3)) _ff[_n3]=new Object();
            _ff[_n3][_nn]=true; // _nn:z, _n3:x, ff={x:{z:true}, ...}
          }
        };
      // populate references
      var f4:Function=function(_rr:Object, _ff:Object, _obj:Object):void
        {
          var _nn:String=_obj.id;
          var _n4:String;
          // case 2: z before x, rr={z:{x:true, y:true}, ...}, nn=x, ss={a:true, b:true}
          if (_ff.hasOwnProperty(_nn))
          {
            for (_n4 in _ff[_nn])
            {
              // _n4:z, _obj.id=x, _obj.ids=["a", "b"]
              if (_rr.hasOwnProperty(_n4)) f2(_rr, _n4, _obj, false);
            }
          } 
        };
      // set r's properties from _obj: dep, miss, comp
      var f5:Function=function(_obj:Object):void
        {
          if (_obj.comp) r.comp[_obj.id]=_obj.comp;
          if (_obj.miss.length > 0) r.miss[_obj.id]=_obj.miss;
          if (_obj.dep) r.dep[_obj.id]=_obj.dep;
        };
      var f$:Function=callback is Function ? function(obj:Object):Boolean
        {
          var b1:Boolean=callback(obj);
          var b2:Boolean=f0(obj);
          return b1 && b2;
        } : f0;
      // use ref to decide the queue of es items
      var qq:Function=function(_rr:Object):void
        {
          var _n1:String, _n2:String, _nrr:Object, _bb:Boolean, _cc:int, _qq:Object={};
          do {
            _cc=0;
            _nrr=new Object();
            for (_n1 in _rr) // _n1: GZ,GZZW,JDJ,JDJ1,...
            {
              _bb=false;
              for (_n2 in _rr[_n1]) // _n2: [GZJB,GZXS,GZZW],[...],[JDJ1,JDJ2,JDJ3,...],[avg,JJXS,xx001],...
              {
                if (es.hasOwnProperty(_n2) && !(_qq.hasOwnProperty(_n2)))
                {
                  _bb=true;
                  if (!_nrr[_n1]) _nrr[_n1]={};
                  _nrr[_n1][_n2]=true;
                }
              }
              if (!_bb)
              {
                r.queue.push(_n1);
                _qq[_n1]=true;
                _cc++;
              }
            }
            _rr=_nrr;
          } while(_cc > 0);
        };

      for (n in exprs)
      {
        if (exprs[n] is String)
        {
          es[n]=exprs[n];
        }
        // if (exprs[n] == true || exprs[n] == Ident.U
        //  || exprs[n] is Number || exprs[n] == Ident.V 
        //  || exprs[n] is Function || exprs[n] == Ident.F)
        else // allow object typed vars as parameters in a function call
        {
          vfs[n]=true;
          r.queue.push(n); // r.queue: ["a", "b", "c", "d", "sqrt"]
        }
        r.expr[n]=exprs[n];
      }
      for (n in es)
      {
        obj={id:n, expr:es[n], error:null, eobj:null, eid:null, edata:null, dep:{}, ids:[], miss:[], comp:null, sylla:r.sylla};
        f1(obj); // obj.dep: {x:Ident, y:Ident}  {a:Ident, b:Ident}
        f2(ref, n, obj); // ref: {z:{x:true, y:true}}  {x:{a:true, b:true}}
        f3(fer, obj); // fer: {x:{z:true}, y:{z:true}}
        f4(ref, fer, obj); // ref: {z:{x:true, y:true, a:true, b:true}}
        if (!(f$(obj)) && r.error)
          break;
        f5(obj);
      }
      qq(ref);
      return r;
    }

    /**
     * evaludate the expr list(exprs).
     * @exprs: Object, returned by validate function
     *  or    Object, e.g. {a:V, b:V, c:V, d:V, abs:F, x:"a*(b+3)", y:"c/(d-7)", z:"x+y"}
     *  or    Object, e.g. {a:true, b:true, c:true, d:true, abs:true, x:"a*(b+3)", y:"c/(d-7)", z:"x+y"}
     *  or    String, e.g. "(3+3)*(7-3)/(1+2+1)"
     * @context: Object, context object used in evaludation, e.g. {a:3, b:5, c:7, d:9, abs:Math.abs}
     * @callback: used to format error message, syntax: function(obj:Object):Boolean
     *  - obj: {id:id, expr:expr, error:error, eobj:eobj, eid:eid, edata:edata}
     *    -- id: String, id at left of =
     *    -- expr: String, expression at right of =
     *    -- error: String, return formatted error message
     *    -- eobj: Object, the error object
     *    -- eid: int, the error id
     *    -- edata: Object, error related object
     *    -- sylla: Object, container for the evaluate session
     *  - return true, then continue to parse other exprs; false to break.
     * @return: Object {value:{a:.., b:.., y:.., z:..}, error:{y:.., z:..}, valid:true, sylla:{}}
     *  - value: Object, all evaluated values for all expressions in exprs.expr
     *  - error: Object, evaluation errors for expressions
     *  - valid: Boolean, if error is null then true, otherwise false
     *  - sylla: Object, container for the evaluate session
     **/
    public static function evaluate(exprs:Object, context:Object=null, callback:Function=null):Object
    {
      var r:Object={value:{}, error:null, valid:true, sylla:{}};
      var n:String, obj:Object, cc:Object;
      var f0:Function=function(_obj:Object):Boolean
        {
          if (!_obj.error)
          {
            if (_obj.eobj is Error) _obj.error=StringUtil.substitute("Evaluate [{0}={1}] failed! {2}", [_obj.id, _obj.expr, _obj.edata]);
            else
            {
              if (_obj.eid == ERROR_INVALID_EXPRS) _obj.error="Expressions is null or invalid!";
              else if (_obj.eid == ERROR_NOT_DEFINED) _obj.error=StringUtil.substitute("[{0}] is not defined!", [_obj.id]);
              else if (_obj.eid == ERROR_NOT_NUMBER) _obj.error=StringUtil.substitute("[{0}] is not a number!", [_obj.id]);
              else if (_obj.eid == ERROR_DIVIDE_ZERO) _obj.error=StringUtil.substitute("Evaluate [{0}={1}] failed, cause by dividing zero!", [_obj.id, _obj.expr]);
            }
          }
          if (_obj.error)
          {
            if (!r.error) r.error=new Object();
            r.error[_obj.id]=_obj.error;
            r.valid=false;
          }
          return true;
        };
      var f1:Function=function(_obj:Object):Number
        {
          try {
            var _nn:String=_obj.id;
            var _c:Compiler, _v:Number;
            if (exprs.comp.hasOwnProperty(_nn))
            {
              _c=exprs.comp[_nn];
              _v=_c.execute(cc);
            }
            else
            {
              if (!(cc.hasOwnProperty(_nn)))
              {
                _obj.eid=ERROR_NOT_DEFINED;
              }
              else if (cc[_nn] is Number) _v=cc[_nn];
              else _v=NaN;
            }
            if (isNaN(_v)) {
              _obj.eid=ERROR_NOT_NUMBER;
              _obj.edata=cc[_nn];
            }
            else if (_v == Number.NEGATIVE_INFINITY || _v == Number.POSITIVE_INFINITY) {
              _obj.eid=ERROR_DIVIDE_ZERO;
              _obj.edata=cc[_nn];
            }
          } catch (err:Error) {
            _obj.eobj=err;
            _obj.eid=err.errorID;
            _obj.edata=err.message;
          }
          return _v;
        };
      var f$:Function=callback is Function ? function(obj:Object):Boolean
        {
          var b1:Boolean=callback(obj);
          var b2:Boolean=f0(obj);
          return b1 && b2;
        } : f0;
      var p1:Function=function(_obj1:Object, _obj2:Object=null):Object
        {
          var _n:String;
          if (!_obj2) _obj2=new Object();
          for (_n in _obj1)
          {
            if (_obj2[_n] is Number || _obj2[_n] is Function)
              continue;
            // if (_obj1[_n] is Number || _obj1[_n] is Function)
            if (!(_obj1[_n] is String))
              _obj2[_n]=_obj1[_n];
          }
          return _obj2;
        };

      if (exprs is String)
        return evaluate({"$":exprs}, context, callback);
      else if (exprs)
      {
        if (exprs.flag != singleton)
        {
          p1(context, exprs);
          return evaluate(validate(exprs), context, callback);
        }
        else if (!exprs.valid)
        {
          r.error=exprs.error;
          r.valid=exprs.valid;
          return r;
        }
      }
      else // exprs == null
        return r;

      // combine constants in exprs.expr & input context
      cc=p1(context);
      p1(exprs.expr, cc);

      for each (n in exprs.queue)
      {
        if (exprs.expr[n] is Number || exprs.expr[n] is String)
        {
          obj={id:n, expr:exprs.expr[n], error:null, eobj:null, eid:null, edata:null, sylla:r.sylla};
          cc[n]=r.value[n]=f1(obj);
          if (!(f$(obj)) && r.error)
            break;
        }
      }
      return r;
    }
  }
}