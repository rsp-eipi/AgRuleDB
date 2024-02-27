using AgRuleDB_Generated;

namespace AgRuleDB_Generated.Rules;

internal class Rule01
{
    //ForExpr(
    //    [Bind(
    //      Var("@a"), Call("distinct-values",
    //          ([Context().Move(Axis.Child, "book").Move(Axis.Child, "author")])))], ([Context().Move(Axis.Child, "book").Move(Axis.Child, "author").Filter(Binary(AgRuleDB_Lib.XPathParser.ContextItemExpr, BinOp.GenEqual, Var("@a"))).Filter(1), Context().Move(Axis.Child, "book").Filter(Binary(Context().Move(Axis.Child, "author"), BinOp.GenEqual, Var("@a"))).Move(Axis.Child, "title")]))

    

}
