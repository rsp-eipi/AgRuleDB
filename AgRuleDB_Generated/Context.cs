namespace AgRuleDB_Generated;

/// <summary>
/// Variables hold the bindings created during XPath evaluations
/// </summary>
/// <typeparam name="TElt"></typeparam>
public class Variables<TElt> : Dictionary<string, XpValue> where TElt : IInputElement<TElt> { }

/// <summary>
/// NodeSet is a set of source nodes and one of the possible result value of evaluating an XPath expression
/// </summary>
public class NodeSet<TElt> : HashSet<TElt> where TElt : IInputElement<TElt>
{    
    public NodeSet() : base(TElt.GetComparer()) { }
    public NodeSet(TElt element) : base([element], TElt.GetComparer()) { }
    public NodeSet(IEnumerable<TElt> elements) : base(elements, TElt.GetComparer()) { }
    public NodeSet<TElt> Add(NodeSet<TElt> nodes)
    {
        this.UnionWith(nodes);
        return this;
    }
    public override string ToString() => $"[ {string.Join(", ", this)} ]";
}

/// <summary>
/// Provides metadata about the rule being evaluated. 
/// Use primitive Xp.Rule() to set its value and define generic types in the same time. 
/// </summary>
/// <param name="RuleId"></param>
/// <param name="Description"></param>
public record RuleInfo(string? RuleId = null, string? Description = null);

/// <summary>
/// Represents an input document for XPath evaluation.
/// </summary>
public class Context<TDoc, TElt>
                where TDoc : IInput<TDoc, TElt>
                where TElt : IInputElement<TElt>
                
{
    public TDoc Input { get; init; }
    public NodeSet<TElt> InitialNodeSet { get; init; }
    public NodeSet<TElt> CurrentContext { get; init; } = new ();    
    public Variables<TElt> Variables { get; init; } = new ();
    public RuleInfo RuleInfo { get; private set; } 
    /// <summary>
    /// Initializes a new instance of the <see cref="Context" /> class from a pre-loaded source document.
    /// </summary>
    /// <param name="inputDoc">The source document.</param>
    public Context(TDoc inputDoc, NodeSet<TElt>? initialNodeSet = null, Variables<TElt>? initialVariables = null, RuleInfo? ruleInfo = null)
    {
        if (inputDoc == null) throw new ArgumentNullException(nameof(inputDoc));        
        Input = inputDoc;

        InitialNodeSet = initialNodeSet ?? new NodeSet<TElt>(Input.Root);
        CurrentContext.Add(InitialNodeSet);        

        if (initialVariables is not null)
            if (!initialVariables.All(kvp => Variables.TryAdd(kvp.Key, kvp.Value)))
                throw new Exception("Some bindings already exist");
        RuleInfo = ruleInfo ?? new();
    }

    public Context<TDoc, TElt> ToInitial() => new Context<TDoc, TElt>(Input, InitialNodeSet , Variables, RuleInfo);
    public Context<TDoc, TElt> Change(NodeSet<TElt> newContextNodeSet) => new Context<TDoc, TElt>(Input, newContextNodeSet, Variables, RuleInfo);
    public Context<TDoc, TElt> Change(TElt newContextNode) => new Context<TDoc, TElt>(Input, new NodeSet<TElt>(newContextNode), Variables, RuleInfo);
    public Context<TDoc, TElt> SetRuleInfo(RuleInfo newRuleInfo)
    {
        RuleInfo = newRuleInfo;
        return this;
    }

    
}






