package debugger;

/**
    This class contains a few replacement for binary/unary operators that can be used while debugging
**/
class Runtime {
    public static function eq(a:Dynamic, b:Dynamic) {
        return a == b;
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

    public static function and(a:Bool, b:Bool):Bool {
        return a && b;
    }

    public static function or(a:Bool, b:Bool):Bool {
        return a || b;
    }

    public static function not(a:Bool):Bool {
        return !a;
    }
}