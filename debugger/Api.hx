package debugger;

class Api {
    public static function debugBreak() {
    }

    public static function refreshCppiaDefinitions() {
    }

    public static function setClassPaths(classpaths:Array<String>) {
    }

    public macro static function setMyClassPaths() {
        var cps = haxe.macro.Context.getClassPath();
        cps.push(Sys.getCwd());
        return macro debugger.Api.setClassPaths($v{[ for (cp in cps) (haxe.io.Path.isAbsolute(cp) ? cp : Sys.getCwd() + '/' + cp) ]});
    }
}