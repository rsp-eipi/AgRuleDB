
namespace AgRuleDB_Generated;

enum XpType { Int, String, Boolean, NodeSet }


public class XpAtomicValue
{
    

    
}


/// <summary>
/// NodeSet is one of the possible result value of evaluating an XPath expression
/// </summary>
public class NodeSet : List<IInputElement> { }

/// <summary>
/// A "dynamic" type representing XPath evaluation results. Results may have various types and each is provided with implicite cast operations following XPath semantics
/// </summary>
/// <typeparam name="T">The type of underlying source structure</typeparam>
public class XpValue 
{
    private readonly int i;
    private readonly string s = string.Empty;
    private readonly bool b;
    private readonly DateTime d = new DateTime();
    private readonly NodeSet ns = new();
    private readonly XpType XpType;

    public XpValue(int i) { XpType = XpType.Int; this.i = i; }
    public XpValue(string s) { XpType = XpType.String; this.s = s; }
    public XpValue(bool b) { XpType = XpType.Boolean; this.b = b; }
    public XpValue(NodeSet ns) {  XpType = XpType.NodeSet; this.ns.AddRange(ns); }

    public T Apply<T>(Func<int,T> f_int, Func<string, T> f_string) =>    
        XpType switch
        {
            XpType.Int => f_int(i),
            XpType.String => f_string(s),
            _ => throw new Exception("Undefined type")
        };

    public static implicit operator int(XpValue v) => v.XpType switch
    {
        XpType.Int => v.i,
        XpType.Boolean => v.b ? 1 : 0,
        XpType.NodeSet => v.ns.Count(),
        XpType.String => throw new Exception("string can't be cast into int"),
        _ => throw new Exception("Undefined type")
    };
    

}

