using System.Diagnostics;
using System.Text;

namespace AgRuleDB_Lib.XPathParser;

public enum BinOp
{
    GenEqual, GenNotEqual, GenLessThan, GenLessThanOrEqual, GenGreaterThan, GenGreaterThanOrEqual,
    ValEqual, ValNotEqual, ValLessThan, ValLessThanOrEqual, ValGreaterThan, ValGreaterThanOrEqual,
    Is, NodeBefore, NodeAfter, And, Or,
    Add, Sub, Times, Div, IDiv, Mod,
    Union, Intersect, Except, Comma, Concat, To
}

public enum BinOpResultType
{
    Boolean, AtopmicValue, Sequence
}


public static class XpUtil
{
    public static string CanonizeIdentifier(this string s)
        => s.ToLower();

    public static Axis StringToAxis(string axis) =>
        axis.Replace("::", "") switch
        {
            "child" => Axis.Child,
            "descendant" => Axis.Descendant,
            "attribute" => Axis.Attribute,
            "self" => Axis.Self,
            "descendant-or-self" => Axis.DescendantOrSelf,
            "following-sibling" => Axis.FollowingSibling,
            "following" => Axis.Following,
            "namespace" => Axis.Namespace,
            "@" => Axis.Attribute,
            "parent" => Axis.Parent,
            "ancestor" => Axis.Ancestor,
            "preceding-sibling" => Axis.PrecedingSibling,
            "preceding" => Axis.Preceding,
            "ancestor-or-self" => Axis.AncestorOrSelf,
            "" => Axis.None,
            _ => throw new NotImplementedException()
        };

    public static BinOp StringToBinaryOperator(string op) => op.ToLower() switch
    {        
        "=" => BinOp.GenEqual,
        "!=" => BinOp.GenNotEqual,
        "<" => BinOp.GenLessThan,
        "<=" => BinOp.GenLessThanOrEqual,
        ">" => BinOp.GenGreaterThan,
        ">=" => BinOp.GenGreaterThanOrEqual,
        "eq" => BinOp.ValEqual,
        "neq" => BinOp.ValNotEqual,
        "lt" => BinOp.ValLessThan,
        "le" => BinOp.ValLessThanOrEqual,
        "gt" => BinOp.ValGreaterThan,
        "ge" => BinOp.ValGreaterThanOrEqual,
        "is" => BinOp.Is,
        "<<" => BinOp.NodeBefore,
        ">>" => BinOp.NodeAfter,
        "and" => BinOp.And,
        "or" => BinOp.Or,
        "+" => BinOp.Add,
        "-" => BinOp.Sub,
        "*" => BinOp.Times,
        "/" => BinOp.Div,
        "div" => BinOp.IDiv,
        "mod" => BinOp.Mod,
        "union" => BinOp.Union,
        "|" => BinOp.Union,
        "intersect" => BinOp.Intersect,
        "except" => BinOp.Except,
        "," => BinOp.Comma,
        "concat" => BinOp.Concat,
        "to" => BinOp.To,
        _ => throw new Exception($"Invalid operator {op}")
    };


    public static BinOpResultType GetBinOpResultType(this BinOp binOp) => binOp switch
    {
        BinOp.Or or 
        BinOp.And or 
        BinOp.GenEqual or 
        BinOp.ValEqual or 
        BinOp.ValNotEqual or 
        BinOp.GenNotEqual         
                            => BinOpResultType.Boolean,
        _                   => throw new UnreachableException()
    };

    /// <summary>
    /// Sets GenType display to true on the first expression of a sequence. 
    /// This is used when the sequence can be chained with '.' notation since type information is unnecessary after the first expression. 
    /// </summary>
    /// <param name="exprs">The expression sequence</param>
    /// <returns>The same expression sequence with first expression set to display generic type information</returns>
    public static IEnumerable<Expr> GenTypesOnFirst(this IEnumerable<Expr> exprs)
    {
        if (exprs.Any())
            exprs.First().DisplayGenTypes = true;
        return exprs;
    }

    /// <summary>
    /// Sets GenTypes display to true on all the expressions of a sequence. 
    /// This is used when expressions are not chained because they are part of a sequence of one or more.
    /// </summary>
    /// <param name="exprs">The expression sequence</param>
    /// <returns>The same expression sequence with all expressions set to display generic type information</returns>
    public static IEnumerable<Expr> GenTypesOnAll(this IEnumerable<Expr> exprs)
    {
        foreach (Expr e in exprs)
            e.DisplayGenTypes = true;
        return exprs;
    }

    /// <summary>
    /// Force display of GenTypes for the given expression (set DisplayGenTypes to true)
    /// </summary>
    /// <param name="expr">Expression for which to set DisplayGenTypes to true</param>
    /// <returns>The same expression with DisplayGenTypes set</returns>
    public static Expr GenTypesSet(this Expr expr)
    {
        expr.DisplayGenTypes = true;
        return expr;
    }

}


internal static class FunctionDictionary
{
    static readonly Dictionary<string, int> _Dic = new Dictionary<string, int>();

    public static void Add(string functionName)
    {
        if (!_Dic.ContainsKey(functionName))
            _Dic.Add(functionName, 1);
        else
            _Dic[functionName]++;
    }

    public static string Print()
    {        
        StringBuilder sb = new StringBuilder();
        foreach (string key in _Dic.Keys)
            sb.AppendLine($"{_Dic[key]} \t {key}");
        return sb.ToString();
    }
}



internal static class Tab
{
    static int _depth = 0;
    const string _tabString = "   ";

    public static string TabsNl { get => "\r\n" + Tabs; }
    public static string Tabs { get => string.Concat(Enumerable.Repeat(_tabString, _depth)); }
    static string _Tabs(int depth) => string.Concat(Enumerable.Repeat(_tabString, depth));

    public static string Push { get => _Tabs(++_depth); }
    public static string PushNl { get => $"\r\n{Push}"; }

    public static string Pop { get => _Tabs((_depth > 0) ? --_depth : 0); }
    public static string PopNl { get => $"\r\n{Pop}"; }

    /// <summary>
    /// Reset depth and produces the initial tabbing in a file
    /// </summary>
    /// <returns>a first tab</returns>
    public static string FirstPush()
    {
        _depth = 0;
        return Push;
    }
}