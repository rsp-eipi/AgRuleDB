using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Lib.XPathParser;
internal static class XpUtil
{
    public static string CanonizeIdentifier(this string s)
        => s.ToLower();
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