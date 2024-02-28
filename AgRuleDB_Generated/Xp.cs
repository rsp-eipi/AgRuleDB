using AgRuleDB_Lib.XPathParser;


namespace AgRuleDB_Generated;




/// <summary>
/// Represents a fragment of XPath expression.
/// </summary>
/// <typeparam name="T">The type of the result.</typeparam>
/// <param name="input">The input XML Document to evaluate against.</param>
/// <returns>The result of evaluation the XPath fragment against that document.</returns>
public delegate Result<TDoc, TElt> Xp<TDoc, TElt>(Context<TDoc, TElt> inputContext) 
    where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>;

public static class XpLibrary
{
    public static Result<TDoc, TElt> Eval<TDoc, TElt>(this Xp<TDoc, TElt> xp, TDoc doc)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp(new Context<TDoc, TElt>(doc));    


    public static Xp<TDoc, TElt> Move<TDoc, TElt>(Axis axis, string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    {
        return context =>
        {
            NodeSet<TElt> resultNodeSet = new NodeSet<TElt>();
            foreach (var node in context.CurrentContext)
                resultNodeSet.AddRange(context.Input.Move(node, axis, name));
            return new Success<TDoc, TElt>(new XpValueNodeSet<TElt>(resultNodeSet), context.Change(resultNodeSet));            
        };
    }

    public static Xp<TDoc, TElt> Move<TDoc, TElt>(this Xp<TDoc, TElt> xp, Axis axis, string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    {
        return context =>
        {
            switch (xp(context))
            {
                case Success<TDoc, TElt> success:
                    switch (success.Value)
                    {
                        case NodeSet<TElt> nodes:
                            NodeSet<TElt> resultNodeSet = new NodeSet<TElt>();
                            foreach (var node in nodes)
                                resultNodeSet.AddRange(context.Input.Move(node, axis, name));
                            return new Success<TDoc, TElt>(new XpValueNodeSet<TElt>(resultNodeSet), success.Context.Change(resultNodeSet));
                        default: return new Failure<TDoc, TElt>("Trying to apply Move to something else than a node", context);
                    }
                case Failure<TDoc, TElt> failure:
                    return failure;
                default: return new Failure<TDoc, TElt>("Unreachable case", context);
            }
        };
    }
}
