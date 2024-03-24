using AgRuleDB_Lib.XPathParser;
using System.Xml;

namespace AgRuleDB_Lib.XPathRunner;

public class XmlDocInput(XmlDocument input) : IInput<XmlDocInput, XmlElementInput>
{
    public XmlDocument Input { get; init; } = input;    
    public XmlElementInput Root { get => new XmlElementInput(Input.DocumentElement!); }
    public NodeSet<XmlElementInput> Move(XmlElementInput fromElement, Axis axis, string name)
    {
        return axis switch
        {
            Axis.Child => new NodeSet<XmlElementInput>(),
            Axis.DescendantOrSelf => throw new NotImplementedException(),
            _ => throw new NotImplementedException(),    
        };
    }
    public static XmlDocInput FromString(string xmlFragment)
    {
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(xmlFragment);
        return new XmlDocInput(doc);
    }
}

public class XmlElementInput(XmlElement element) : IInputElement<XmlElementInput>
{    
    public XmlElement Element { get; init; } = element;
    public string Name { get => Element.Name; }
    public string Value
    {
        get => Element.NodeType switch
        {
            XmlNodeType.Element => Element.InnerText,
            XmlNodeType.Attribute => Element.Value ?? string.Empty,
            _ => throw new NotImplementedException()
        };
    }
    public InputElementType ElementType => Element.NodeType switch
    {
        XmlNodeType.Element => InputElementType.Node,
        XmlNodeType.Attribute => InputElementType.Attribute,
        _ => throw new Exception($"Unexpected element type {Element.NodeType}")
    };           

    public static implicit operator XmlElementInput(XmlElement e) => new XmlElementInput(e);

    public static EqualityComparer<XmlElementInput> GetComparer() => EqualityComparer<XmlElementInput>.Create(
                (XmlElementInput? x, XmlElementInput? y) => x?.Element == y?.Element,
                (XmlElementInput Element) => Element.GetHashCode());
}

