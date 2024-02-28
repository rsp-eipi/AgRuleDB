using System.ComponentModel;
using System.Runtime.Intrinsics.X86;
using System.Xml;
using AgRuleDB_Lib;
using AgRuleDB_Lib.XPathParser;

namespace AgRuleDB_Generated;

/// <summary>
/// Variables hold the bindings created during XPath evaluations
/// </summary>
/// <typeparam name="TElt"></typeparam>
public class Variables<TElt> : Dictionary<string, XpValue> where TElt : IInputElement<TElt> { }

/// <summary>
/// NodeSet is a set of source nodes and one of the possible result value of evaluating an XPath expression
/// </summary>
public class NodeSet<TElt> : List<TElt> where TElt : IInputElement<TElt>
{
    private HashSet<TElt> _variables = new HashSet<TElt>(TElt.GetComparer());
    public NodeSet() : base() { }
    public NodeSet(TElt element) : base([element]) { }
    public NodeSet(IEnumerable<TElt> elements) : base(elements) { }

    public NodeSet<TElt> AddRange(NodeSet<TElt> nodes)
    {
        nodes.ForEach(n => this.Add(n));
        return this;
    }             
}


/// <summary>
/// Represents an input document for XPath evaluation.
/// </summary>
public class Context<TDoc, TElt>
                where TDoc : IInput<TDoc, TElt>
                where TElt : IInputElement<TElt>
                
{
    public TDoc Input { get; init; }
    public NodeSet<TElt> CurrentContext { get; init; } = new ();    
    public Variables<TElt> Variables { get; init; } = new ();

    /// <summary>
    /// Initializes a new instance of the <see cref="Context" /> class from a pre-loaded source document.
    /// </summary>
    /// <param name="inputDoc">The source document.</param>
    public Context(TDoc inputDoc, NodeSet<TElt>? initialNodeSet = null, Variables<TElt>? initialVariables = null)
    {
        if (inputDoc == null) throw new ArgumentNullException(nameof(inputDoc));        
        Input = inputDoc;

        if (initialNodeSet is null)
            CurrentContext.Add(Input.Root);
        else           
            CurrentContext.AddRange(initialNodeSet);

        if (initialVariables is not null)
            if (!initialVariables.All(kvp => Variables.TryAdd(kvp.Key, kvp.Value)))
                throw new Exception("Some bindings already exist");
    }
   
    public Context<TDoc, TElt> Change(NodeSet<TElt> newContextNodeSet) => new Context<TDoc, TElt>(Input, newContextNodeSet, Variables);

    
}