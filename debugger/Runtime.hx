package debugger;

@:enum abstract VariableKind(Int) {
  var Var = 1;
  var Method = 2;
  var Class = 3;
  var Data = 4;
  var Event = 5;
  var BaseClass = 6;
  var Interface = 7;
  var Virtual = 8;

  inline public function int() {
    return this;
  }
}

@:enum abstract VariableAttributes(Int) {
  var Static = 0x10;
  var Constant = 0x20;
  var ReadOnly = 0x40;
  var Property = 0x80;

  inline public function int() {
    return this;
  }

  inline public function hasAny(v:VariableAttributes) {
    return this & v.int() != 0;
  }

  inline public function hasAll(v:VariableAttributes) {
    return this & v.int() == v.int();
  }

  @:op(A|B) inline public function add(v:VariableAttributes):VariableAttributes {
    return cast this | v.int();
  }
}

@:enum abstract VariableVisibility(Int) {
  var Public = 0x1000;
  var Private = 0x2000;
  var Protected = 0x3000;
  var Internal = 0x4000;
  var Final = 0x5000;

  inline public function int() {
    return this;
  }
}

@:enum abstract VariableProperties(Int) {
  public var kind(get,never):VariableKind;
  public var attributes(get,never):VariableAttributes;
  public var visibility(get,never):VariableVisibility;

  inline public function new(kind:VariableKind, attributes:VariableAttributes, visibility:VariableVisibility) {
    this = kind.int() | attributes.int() | visibility.int();
  }

  inline private function get_kind():VariableKind {
    return cast this & 0xF;
  }

  inline private function get_attributes():VariableAttributes {
    return cast this & 0xFF0;
  }

  inline private function get_visibility():VariableVisibility {
    return cast this & 0xF000;
  }
}

typedef ClassDef = {
  vars:haxe.DynamicAccess<VariableProperties>,
  // funcs:haxe.DynamicAccess<{}>
}

/**
    This class contains a few replacement for binary/unary operators that can be used while debugging
**/
class Runtime {
  public static function getDataFor(clsName:String):ClassDef {
    if (clsName == null || clsName == "cpp::Pointer" || clsName == "cpp.Pointer") {
      return null;
    }
    var cls = Type.resolveClass(clsName);
    return getDataForClass(cls);
  }

  private static function getDataForClass(cls:Class<Dynamic>):ClassDef {
    if (cls == null) {
      return null;
    }
    var meta = haxe.rtti.Meta.getType(cls);
    if (meta == null) {
      return getDataForClass(Type.getSuperClass(cls));
    }
    var arr = meta.runtimeDebugInfo;
    if (arr == null) {
      return getDataForClass(Type.getSuperClass(cls));
    }
    var ret:ClassDef = arr[0];
    var sup = getDataForClass(Type.getSuperClass(cls));
    if (sup != null) {
      for (v in sup.vars.keys()) {
        var sup:VariableProperties = sup.vars[v];
        ret.vars[v] = new VariableProperties(BaseClass, sup.attributes, sup.visibility);
      }
    }
    return ret;
  }

  public static function eq(a:Dynamic, b:Dynamic) {
    return a == b;
  }
  
  public static function neq(a:Dynamic, b:Dynamic) {
    return a != b;
  }

  public static function lt(a:Dynamic, b:Dynamic) {
    return a<b;
  }

  public static function lte(a:Dynamic, b:Dynamic) {
    return a<=b;
  }

  public static function gt(a:Dynamic, b:Dynamic) {
    return a>b;
  }

  public static function gte(a:Dynamic, b:Dynamic) {
    return a>=b;
  }

  public static function plus(a:Dynamic, b:Dynamic):Dynamic {
    return a + b;
  }

  public static function minus(a:Dynamic, b:Dynamic):Dynamic {
    return a - b;
  }

  public static function _and(a:Bool, b:Bool):Bool {
    return a && b;
  }

  public static function _or(a:Bool, b:Bool):Bool {
    return a || b;
  }

  public static function _not(a:Bool):Bool {
    return !a;
  }
}