using AgRuleDB_Lib.XPathParser;

namespace AgRuleDB_Generated;
public interface IInput<TDoc, TElt> where TElt : IInputElement<TElt>
{    
    public TElt Root { get; }
    public NodeSet<TElt> Move(TElt fromElement, Axis axis, string name);    
}

public enum InputElementType { Node, Attribute }

public interface IInputElement<TElt> 
{    
    public InputElementType ElementType { get; }
#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider declaring as nullable.
    public string Name { get; }
    public string Value { get; }
#pragma warning restore CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider declaring as nullable.
    public static abstract EqualityComparer<TElt> GetComparer();
}


