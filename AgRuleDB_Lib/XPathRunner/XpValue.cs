using System.Collections;
using System.Diagnostics;

namespace AgRuleDB_Lib.XPathRunner;

// XPath implements loads of types with very strange casting rules
// https://www.w3.org/TR/xquery-operators/#casting
// not everything is covered here, we can add to these as needed
public enum XpType { None, Error, Node, Sequence, Int, String, Bool, DateTime }
public abstract record XpValue(XpType XpType)
{
    // see https://www.w3.org/TR/xpath20/#dt-ebv
    public virtual bool AsBool { get => false; }
    public static implicit operator XpValue(string input) => new XpValueString(input);
    public static implicit operator XpValue(int input) => new XpValueInt(input);
    public static implicit operator XpValue(bool input) => new XpValueBool(input);
}
public abstract record XpValueAtomic(XpType XpType) : XpValue(XpType);
public record XpValueNone() : XpValue(XpType.None);
public record XpValueError(string Value) : XpValue(XpType.Error);
public record XpValueInt(int Value) : XpValueAtomic(XpType.Int)
{
    public override bool AsBool => Value != 0;
}
public record XpValueString(string Value) : XpValueAtomic(XpType.String)
{
    // If its operand is a singleton value of type xs:string, xs:anyURI, xs:untypedAtomic, or a type derived from one of these,
    // fn:boolean returns false if the operand value has zero length; otherwise it returns true https://www.w3.org/TR/xpath20/#dt-ebv
    public override bool AsBool => !string.IsNullOrEmpty(Value);
    public static implicit operator XpValueString(string input) => new XpValueString(input);    
}
public record XpValueBool(bool Value) : XpValueAtomic(XpType.Bool)
{
    public override bool AsBool => Value;    
}
public record XpValueDateTime(DateTime Value) : XpValueAtomic(XpType.DateTime);
public record XpValueNode<TElt>(TElt Value) : XpValue(XpType.Node) where TElt : IInputElement<TElt>;
public record XpValueNodeSet<TElt>(NodeSet<TElt> Value) : XpValue(XpType.Node) where TElt : IInputElement<TElt>
{
    public override string ToString() => $"{Value}";
}
public record XpValueSequence<TElt>(ValueSequence<TElt> Value) : XpValue(XpType.Sequence) where TElt : IInputElement<TElt>
{
    // If its operand is an empty sequence, fn:boolean returns false https://www.w3.org/TR/xpath20/#dt-ebv
    // If its operand is a sequence whose first item is a node, fn:boolean returns true https://www.w3.org/TR/xquery-operators/#func-boolean
    public override bool AsBool 
        => Value.Count() > 0
        && Value.First().GetType().IsGenericType
        && Value.First().GetType().GetGenericTypeDefinition() == typeof(XpValueNode<>);
}

public class ValueSequence<TElt> : IEnumerable<XpValue> where TElt : IInputElement<TElt>
{
    private List<XpValue> _sequence = new List<XpValue>();
    public ValueSequence(IEnumerable<XpValue> values) => this.Append(values);
    public ValueSequence(XpValue value) => this.Append(value);
    public void Append(IEnumerable<XpValue> values)
    {
        foreach (XpValue v in values)
            this.Append(v);
    }
    public void Append(XpValue value)
    {
        switch (value)
        {
            case XpValueNone: break;
            case XpValueAtomic xpValueAtomic: _sequence.Add(xpValueAtomic); break;
            case XpValueNode<TElt> node: _sequence.Add(node); break;
            case XpValueNodeSet<TElt> nodeset:
                foreach (var item in nodeset.Value)
                    _sequence.Add(new XpValueNode<TElt>(item));
                break;
            default: throw new UnreachableException();
        }
    }   
    public IEnumerator<XpValue> GetEnumerator() => _sequence.GetEnumerator();
    IEnumerator IEnumerable.GetEnumerator() => _sequence.GetEnumerator();
}




/// Note : I initially tried to implement the XpValue as a Dynamic value (c# dynamic or, e.g., any PHP or JS variable). This makes it easier to write individual functions
/// but it makes it impossible to use typed-based pattern matching. Also, anytime the value needs to be accessed, a cast would have been called. 
/// After having a spin with it, I found it didn't fly well with the rest, so I ditched it in favore of the above representation. 
/// The outline is kept below for reference
//public class XpValue<TElt> where TElt : IInputElement<TElt>
//{
//    private readonly int i;
//    private readonly string s = string.Empty;
//    private readonly bool b;
//    private readonly DateTime d = new DateTime();
//    private readonly NodeSet<TElt> ns = new();
//    public readonly XpType XpType;

//    public XpValue(int i) { XpType = XpType.Int; this.i = i; }
//    public XpValue(string s) { XpType = XpType.String; this.s = s; }
//    public XpValue(bool b) { XpType = XpType.Boolean; this.b = b; }
//    public XpValue(NodeSet<TElt> ns) {  XpType = XpType.NodeSet; this.ns.AddRange(ns); } 

//    public static implicit operator int(XpValue<TElt> v) => v.XpType switch
//    {
//        XpType.Int => v.i,
//        XpType.Boolean => v.b ? 1 : 0,
//        XpType.NodeSet => v.ns.Count(),
//        XpType.String => throw new Exception("string can't be cast into int"),
//        _ => throw new Exception("Undefined type")
//    };       
//}


