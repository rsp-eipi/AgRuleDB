using AgRuleDB_Lib.XPathParser;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Generated;
public interface IInput<TDoc, TElt> where TElt : IInputElement<TElt>
{
    public TDoc Input { get; }
    public TElt Root { get; }
    public NodeSet<TElt> Move(TElt from, Axis axis, string name);
    
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


