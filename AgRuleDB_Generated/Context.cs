using System.Xml;
using AgRuleDB_Lib;
using AgRuleDB_Lib.XPathParser;

namespace AgRuleDB_Generated;
/// <summary>
/// Represents an input document for XPath evaluation.
/// </summary>
public class Context<T> where T : class, IInput
{
    private readonly XmlDocument _source;
    private readonly NodeSet _currentContext = new NodeSet();
    /// <summary>
    /// The list of variables bound in current context.
    /// </summary>
    public IDictionary<string, XpValue> Variables { get; } = new Dictionary<string, XpValue>();

    /// <summary>
    /// Initializes a new instance of the <see cref="Context" /> class from a pre-loaded XML document.
    /// </summary>
    /// <param name="source">The source document.</param>
    public Context(XmlDocument source)
    {
        if (source == null) throw new ArgumentNullException("source");
        if (source.DocumentElement == null) throw new ArgumentNullException("source", "source document doesn't have root element");
        _source = source;        
        _currentContext.Add(_source.DocumentElement);
    }    

    public Context(XmlDocument source, NodeSet context)
    {
        _source = source;
        _currentContext.AddRange(context);        
    }

    /// <summary>
    /// Advances the context along some axis.
    /// </summary>
    /// <returns>A new <see cref="Context" /> that is advanced following the axis.</returns>
    /// <exception cref="System.InvalidOperationException">The input is already at the end of the source.</exception>
    public Context Move(Axis axis, string name)
    {
        NodeSet result = new NodeSet();
        foreach (XmlNode node in _currentContext)
        { 
            from node.ChildNodes where node.NodeType == XmlNodeType.Element && node.Name == name;               
        }
        XmlNode newNode = axis switch
            Axis.Child

        return new Context;
    }

    /// <summary>
    /// Gets the whole source.
    /// </summary>
    public string Source { get { return _source; } }

    /// <summary>
    /// Gets the current <see cref="System.Char" />.
    /// </summary>
    public XmlNode Current { get { return _Current; } }

    
    /// <summary>
    /// Returns a string that represents the current object.
    /// </summary>
    /// <returns>
    /// A string that represents the current object.
    /// </returns>
    public override string ToString()
    {
        return string.Format("Line {0}, Column {1}", _line, _column);
    }

    /// <summary>
    /// Serves as a hash function for a particular type.
    /// </summary>
    /// <returns>
    /// A hash code for the current <see cref="Context" />.
    /// </returns>
    public override int GetHashCode()
    {
        unchecked
        {
            return ((_source != null ? _source.GetHashCode() : 0) * 397) ^ _position;
        }
    }

    /// <summary>
    /// Determines whether the specified <see cref="T:System.Object"/> is equal to the current <see cref="Context" />.
    /// </summary>
    /// <returns>
    /// true if the specified <see cref="T:System.Object"/> is equal to the current <see cref="Context" />; otherwise, false.
    /// </returns>
    /// <param name="obj">The object to compare with the current object. </param>
    public override bool Equals(object obj)
    {
        return Equals(obj as IInput);
    }

    /// <summary>
    /// Indicates whether the current <see cref="Context" /> is equal to another object of the same type.
    /// </summary>
    /// <returns>
    /// true if the current object is equal to the <paramref name="other"/> parameter; otherwise, false.
    /// </returns>
    /// <param name="other">An object to compare with this object.</param>
    public bool Equals(IInput other)
    {
        if (ReferenceEquals(null, other)) return false;
        if (ReferenceEquals(this, other)) return true;
        return string.Equals(_source, other.Source) && _position == other.Position;
    }

    /// <summary>
    /// Indicates whether the left <see cref="Context" /> is equal to the right <see cref="Context" />.
    /// </summary>
    /// <param name="left">The left <see cref="Context" />.</param>
    /// <param name="right">The right <see cref="Context" />.</param>
    /// <returns>true if both objects are equal.</returns>
    public static bool operator ==(Context left, Context right)
    {
        return Equals(left, right);
    }

    /// <summary>
    /// Indicates whether the left <see cref="Context" /> is not equal to the right <see cref="Context" />.
    /// </summary>
    /// <param name="left">The left <see cref="Context" />.</param>
    /// <param name="right">The right <see cref="Context" />.</param>
    /// <returns>true if the objects are not equal.</returns>
    public static bool operator !=(Context left, Context right)
    {
        return !Equals(left, right);
    }
}