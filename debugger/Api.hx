package debugger;
import debugger.Runtime;

class Api {
    public static function debugBreak() {
    }

    public static function refreshCppiaDefinitions() {
    }

    public static function setClassPaths(classpaths:Array<String>) {
      lastClasspaths = classpaths;
    }

    private static var lastClasspaths = null;

    public macro static function setMyClassPaths() {
        var cps = haxe.macro.Context.getClassPath();
        cps.push(Sys.getCwd());
        return macro debugger.Api.setClassPaths($v{[ for (cp in cps) (haxe.io.Path.isAbsolute(cp) ? cp : Sys.getCwd() + '/' + cp) ]});
    }

    public macro static function addRuntimeClassData() {
      haxe.macro.Context.onGenerate(function(types) {
        for (t in types) {
          switch(t) {
          case TInst(c,tl):
            var cl = c.get();
            if (cl.isExtern) {
              continue;
            }
            var data:ClassDef = { vars: {} };
            if (cl.meta.has('runtimeDebugInfo') || cl.meta.has(':nativeGen') || cl.meta.has(':unreflective')) {
              continue;
            }
            function visitField(cf:haxe.macro.Type.ClassField, isStatic:Bool) {
              if (cf.kind.match(FMethod(_))) {
                return;
              }
              var kind:VariableKind = Var;
              var att:VariableAttributes = cast 0;
              if (isStatic) {
                att = att | Static;
              }
              if (!cf.kind.match(FVar(AccNormal,AccNormal))) {
                att = att | Property;
                if (cf.kind.match(FVar(_,AccNo|AccNever))) {
                  att = att | ReadOnly;
                }
              }
              data.vars[cf.name] = new VariableProperties(kind, att, cf.isPublic ? Public : Protected);
            }
            for (field in cl.fields.get()) {
              visitField(field, false);
            }
            for (field in cl.statics.get()) {
              visitField(field, true);
            }
            cl.meta.add('runtimeDebugInfo', [macro $v{data}], cl.pos);
          case _:
          }
        }
      });
      return macro null;
    }
}