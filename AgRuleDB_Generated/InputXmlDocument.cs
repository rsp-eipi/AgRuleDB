using AgRuleDB_Lib.XPathParser;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace AgRuleDB_Generated;
internal class InputXmlDocument : IInput
{
    private readonly XmlDocument _doc;

    public InputXmlDocument(XmlDocument doc)
    {
        _doc = doc;
    }

    NodeSet IInput.Root => new NodeSet(new InputXmlElement())    

    NodeSet IInput.Move(IInputElement from, Axis axis) => throw new NotImplementedException();
}


internal class InputXmlElement : IInputElement
{
    private XmlElement _element;
    public InputXmlElement(XmlElement element)
    {
        _element = element;
    }

    public string Name { get => _element.Name; }

    public string Value
    {
        get => _element.NodeType switch
        {
            XmlNodeType.Element => _element.InnerText,
            XmlNodeType.Attribute => _element.Value ?? string.Empty,
            _ => throw new NotImplementedException()
        };
    }

}