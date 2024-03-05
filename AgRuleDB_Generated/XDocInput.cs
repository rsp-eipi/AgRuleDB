using AgRuleDB_Lib.XPathParser;
using System.Xml.Linq;
using System.Xml;
using System;

namespace AgRuleDB_Generated;

public class XDocInput(XDocument input) : IInput<XDocInput, XElementInput>
{
    public XDocument Input { get; init; } = input;
    public XElementInput Root { get => new XElementInput(Input.Root!); }
    public NodeSet<XElementInput> Move(XElementInput fromElement, Axis axis, string name)
        => axis == Axis.Attribute ? MoveToAttribute(fromElement, axis, name) : MoveToNode(fromElement, axis, name);

    public NodeSet<XElementInput> MoveToNode(XElementInput fromElement, Axis axis, string name) =>
         ToNodeSet(axis switch
         {
             Axis.Child => IsEmptyOrWildcard(name) ? fromElement.Element.Elements() : fromElement.Element.Elements(name),
             Axis.Descendant => IsEmptyOrWildcard(name) ? Input.Descendants() : Input.Descendants(name),
             Axis.DescendantOrSelf => name == fromElement.Name
                                                 ? [fromElement.Element, .. IsEmptyOrWildcard(name) ? fromElement.Element.Descendants() : fromElement.Element.Descendants(name)]
                                                 : IsEmptyOrWildcard(name) ? Input.Descendants() : Input.Descendants(name),
             Axis.Parent => fromElement.Element.Parent is null ? [] : [fromElement.Element.Parent],
             _ => throw new NotImplementedException(),
         });    
    public NodeSet<XElementInput> MoveToAttribute(XElementInput fromElement, Axis axis, string name) =>
        IsEmptyOrWildcard(name) ? AttributesToNodeSet(fromElement.Element.Attributes()) : AttributesToNodeSet(fromElement.Element.Attribute(name));
    public static XDocInput FromString(string xmlFragment) => new XDocInput(XDocument.Parse(xmlFragment));
    public static NodeSet<XElementInput> ToNodeSet(IEnumerable<XElement> xElements) => new NodeSet<XElementInput>(from node in xElements select new XElementInput(node));
    public static NodeSet<XElementInput> AttributesToNodeSet(IEnumerable<XAttribute> attributes) => new NodeSet<XElementInput>(from attr in attributes select new XElementInput(attr.Parent!, attr));
    public static NodeSet<XElementInput> AttributesToNodeSet(XAttribute? attribute) 
        => attribute is null ? new NodeSet<XElementInput>() : new NodeSet<XElementInput>(new XElementInput(attribute.Parent!, attribute));
    public static NodeSet<XElementInput> ToNodeSet(XElement xElement) => new NodeSet<XElementInput>(xElement);
    private bool IsEmptyOrWildcard(string name) => name == string.Empty || name == "*";
}

public class XElementInput(XElement element, XAttribute? attr = null) : IInputElement<XElementInput>
{
    public XElement Element { get; init; } = element;
    public XAttribute? Attribute { get; init; } = attr;
    public string Name { get => Element.Name.LocalName; }
    public string Value
    {
        get => ElementType switch
        {
            InputElementType.Node => Element.Value,
            InputElementType.Attribute => Attribute?.Value ?? string.Empty,
            _ => throw new NotImplementedException()
        };
    }
    public InputElementType ElementType => Attribute is null ? InputElementType.Node : InputElementType.Attribute;

    public override string ToString() => ElementType switch
    {
        InputElementType.Node => Element.HasElements ? $"<{Name}>" : Value,
        InputElementType.Attribute => Attribute?.Value ?? string.Empty,
        _ => throw new NotImplementedException()
    };

    public static implicit operator XElementInput(XElement e) => new XElementInput(e);

    public static EqualityComparer<XElementInput> GetComparer() 
        => EqualityComparer<XElementInput>.Create(
                (XElementInput? x, XElementInput? y) => x?.Element == y?.Element,
                (XElementInput Element) => Element.GetHashCode());
}


