namespace AgRuleDB_Generated;

// XPath implements loads of types with very strange casting rules
// https://www.w3.org/TR/xquery-operators/#casting
// not everything is covered here, we can add to these as needed
public enum XpType { None, Node, Sequence, Int, String, Bool, DateTime }
public abstract record XpValue(XpType XpType);
public abstract record XpValueAtomic(XpType XpType) : XpValue(XpType);
public record XpValueNone() : XpValue(XpType.None);
public record XpValueInt(int Value) : XpValueAtomic(XpType.Int);
public record XpValueString(string Value) : XpValueAtomic(XpType.String)
{
    // If its operand is a singleton value of type xs:string, xs:anyURI, xs:untypedAtomic, or a type derived from one of these,
    // fn:boolean returns false if the operand value has zero length; otherwise it returns true https://www.w3.org/TR/xpath20/#dt-ebv
    public static implicit operator bool(XpValueString s) => s.Value.Length > 0;
}
public record XpValueBool(bool Value) : XpValueAtomic(XpType.Bool);
public record XpValueDateTime(DateTime Value) : XpValueAtomic(XpType.DateTime);
public record XpValueNode<TElt>(TElt Value) : XpValue(XpType.Node) where TElt : IInputElement<TElt>;
public record XpValueNodeSet<TElt>(NodeSet<TElt> Value) : XpValue(XpType.Node) where TElt : IInputElement<TElt>
{
    public override string ToString() => $"{Value}";
}
public record XpValueSequence(XpValue[] Value) : XpValue(XpType.Sequence)
{    
    // If its operand is an empty sequence, fn:boolean returns false https://www.w3.org/TR/xpath20/#dt-ebv
    // If its operand is a sequence whose first item is a node, fn:boolean returns true https://www.w3.org/TR/xquery-operators/#func-boolean
    public static implicit operator bool(XpValueSequence sequence) 
        => sequence.Value.Length > 0 
        && sequence.Value[0].GetType().IsGenericType 
        && sequence.Value[0].GetType().GetGenericTypeDefinition() == typeof(XpValueNode<>);    
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


