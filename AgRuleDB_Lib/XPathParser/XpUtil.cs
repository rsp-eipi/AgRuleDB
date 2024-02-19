using Sprache;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit.Sdk;

namespace AgRuleDB_Lib.XPathParser;
internal static class XpUtil
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
            "@" => Axis.Attrib,
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
    const string _tabString = "  ";

    public static string TabsNl { get => "\r\n" + Tabs; }
    public static string Tabs { get => string.Concat(Enumerable.Repeat(_tabString, _depth)); }
    static string _Tabs(int depth) => string.Concat(Enumerable.Repeat(_tabString, depth));

    public static string Push() => _Tabs(++_depth);
    public static string PushNl() => $"\r\n{Push()}";

    public static string Pop() => _Tabs((_depth > 0) ? --_depth : 0);
    public static string PopNl() => $"\r\n{Pop()}";

    /// <summary>
    /// Reset depth and produces the initial tabbing in a file
    /// </summary>
    /// <returns>a first tab</returns>
    public static string FirstPush()
    {
        _depth = 0;
        return Push();
    }
}