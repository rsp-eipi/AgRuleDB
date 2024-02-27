using static System.Net.Mime.MediaTypeNames;

namespace AgRuleDB_Generated;

public enum XpType { Int, String, Boolean, NodeSet }

/// <summary>
/// A "dynamic" type representing XPath evaluation results. 
/// Results may have various types and each is provided with implicite cast operations following XPath semantics
/// Some result types are atomic (datetime, bool, int, string) while another is NodeSet<T> where T is the base document model
/// <typeparamref name="T">The base element type</typeparamref>
/// </summary>
public class XpValue<TElt> where TElt : IInputElement<TElt>
{
    private readonly int i;
    private readonly string s = string.Empty;
    private readonly bool b;
    private readonly DateTime d = new DateTime();
    private readonly NodeSet<TElt> ns = new();
    public readonly XpType XpType;

    public XpValue(int i) { XpType = XpType.Int; this.i = i; }
    public XpValue(string s) { XpType = XpType.String; this.s = s; }
    public XpValue(bool b) { XpType = XpType.Boolean; this.b = b; }
    public XpValue(NodeSet<TElt> ns) {  XpType = XpType.NodeSet; this.ns.AddRange(ns); } 

    public static implicit operator int(XpValue<TElt> v) => v.XpType switch
    {
        XpType.Int => v.i,
        XpType.Boolean => v.b ? 1 : 0,
        XpType.NodeSet => v.ns.Count(),
        XpType.String => throw new Exception("string can't be cast into int"),
        _ => throw new Exception("Undefined type")
    };       
}

