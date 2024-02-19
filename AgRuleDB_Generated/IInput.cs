using AgRuleDB_Lib.XPathParser;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Generated;
internal interface IInput
{
    public NodeSet Root { get; }
    public NodeSet Move(IInputElement from, Axis axis);
}

internal enum ElementType { Node, Attribute }

internal interface IInputElement
{
    public ElementType ElementType { get; }
    string Name { get; }
    string Value { get; }
}
