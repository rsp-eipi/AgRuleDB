using AgRuleDB_Lib.XPathParser;
using System.Diagnostics;

namespace AgRuleDB_Lib.XPathRunner;

/// <summary>
/// Represents a fragment of XPath expression.
/// </summary>
/// <param name="input">The input XML Document to evaluate against.</param>
/// <returns>The result of evaluation the XPath fragment against that document as well as 
/// the context (variable bindings, dynamic context, etc.) as modified by the evaluation.</returns>
public delegate Result<TDoc, TElt> Xp<TDoc, TElt>(Context<TDoc, TElt> inputContext) where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>;

// Due to limitations in C#, type variables cannot be factored out in the static library because of the choice of relying on a "using static" in the rule definition (rules.cs). 
// At this moment, it is not possible to parameterize the library's usings neither is it to make these type parameters internal to the class and depending on the class parameters
// we therefore will have to repeat the type parameters and constraints on every single function definition here to make usage of these functions more convenient elsewhere
// that's what library ought to do: make usage as simple as possible, even if at the cost of some boilerplate
// Note that one (unsatisfying) way to address this (used heavily by MS in the framework source) is to just use object without any more type specification, thereby avoiding genericity.  

public static class XpLibrary
{

    #region Top level methods
    /// <summary>
    /// Set Rule metadata and, when used as first call, is also a standard way to set types for the following 
    /// expression thus simplifying the code generation from schematron.
    /// </summary>    
    public static Xp<TDoc, TElt> Rule<TDoc, TElt>(string? ruleId, string? description)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => new Success<TDoc, TElt>(context.SetRuleInfo(new RuleInfo(ruleId, description)));

    /// <summary>
    /// Set the context to the root node or the initial node if defined in the context.
    /// </summary>    
    public static Xp<TDoc, TElt> Root<TDoc, TElt>()
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => new Success<TDoc, TElt>(context.ToInitial());    

    // For the example, here are two versions of the move function (fonctional and imperative style)
    // This function is a rare case where an imperative style is prefered due to IDE limitations of not
    // being able to set breakpoints between function calls of a same expression. 
    public static Xp<TDoc, TElt> Move_funcStyle<TDoc, TElt>(Axis axis, string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => new Success<TDoc, TElt>(
            context.Change(
                context.CurrentContext.Aggregate(
                    new NodeSet<TElt>(),
                    (result, node) => result.Add(context.Input.Move(node, axis, name)))));

    /// <summary>
    /// Produces a new context following the axis and possible name filter. 
    /// Also sets the result to the new context NodeSet
    /// </summary>    
    public static Xp<TDoc, TElt> Move<TDoc, TElt>(Axis axis, string name) 
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context =>
        {
            NodeSet<TElt> resultNodeSet = new NodeSet<TElt>();
            foreach (var node in context.CurrentContext)
            {
                var nodeMove = context.Input.Move(node, axis, name);
                resultNodeSet.Add(nodeMove);
            }
            return new Success<TDoc, TElt>(context.Change(resultNodeSet));
        };
    

    /// <summary>
    /// Move context to the child nodes of given name
    /// </summary>    
    public static Xp<TDoc, TElt> Child<TDoc, TElt>(string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => Move<TDoc, TElt>(Axis.Child, name)(context);
    /// <summary>
    /// Move context to the attribute nodes of given name
    /// </summary>    
    public static Xp<TDoc, TElt> Attribute<TDoc, TElt>(string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => Move<TDoc, TElt>(Axis.Attribute, name)(context);

    public static Xp<TDoc, TElt> Binary<TDoc, TElt>(Xp<TDoc, TElt> left, BinOp binOp, Xp<TDoc, TElt> right)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context =>
        {
            var leftResult = left(context);
            if (leftResult.WasFailed) return leftResult;            
            var rightResult = right(context);
            if (rightResult.WasFailed) return rightResult;
            var leftValue = leftResult.XpValue;
            var rightValue = rightResult.XpValue;
            switch (binOp.GetBinOpResultType())
            {
                case BinOpResultType.Boolean:
                    bool b = binOp switch
                    {
                        BinOp.GenEqual => rightValue.Equals(leftValue),
                        BinOp.GenNotEqual => !rightValue.Equals(leftValue),
                        BinOp.Or => leftValue.AsBool || rightValue.AsBool,
                        BinOp.And => leftValue.AsBool && rightValue.AsBool,
                        BinOp.ValEqual => leftValue is XpValueAtomic && rightValue is XpValueAtomic,
                        _ => throw new UnreachableException()
                    };
                    return new Success<TDoc, TElt>(context, new XpValueBool(b));
                default :
                    throw new UnreachableException();
                                    
            };            
        };
    

    // here is another case where C# lakes discriminated union types...
    //public static Xp<TDoc, TElt> Lit<TDoc, TElt>(string s) where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    //    => context => new Success<TDoc, TElt>(context, new XpValueString(s));
    //public static Xp<TDoc, TElt> Lit<TDoc, TElt>(int i) where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    //    => context => new Success<TDoc, TElt>(context, new XpValueInt(i));
    //public static Xp<TDoc, TElt> Lit<TDoc, TElt>(int i) where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    //    => context => new Success<TDoc, TElt>(context, new XpValueInt(i));

    public static Xp<TDoc, TElt> Lift<TDoc, TElt>(XpValue v) where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => new Success<TDoc, TElt>(context, v);
        

    public static Xp<TDoc, TElt> Sequence<TDoc, TElt>(params Xp<TDoc, TElt>[] items)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    => context =>
        {
            var results = from item in items select item(context);
            return (results.Any(r => r.WasFailed)) 
                ? results.First(r => r.WasFailed)
                : new Success<TDoc, TElt>(context, results.AsValue());
        };
    



            #endregion

    #region Extension methods
            // ---------------------------------  Extension Methods
            // Here are two C# limitations:
            //
            // 1) Extension methods require the extended type to appear as a first parameter. 
            // As a result, we can't have a same method definition be used for both extension and primitive
            // method in a combinator library. A way to overcome this limitation would be to generate the
            // missing code but current metaprogramming is still too immature for this to actually simplify things. 
            //
            // 2) It is not possible to define constant (names) for delegates with generic types without
            // specifying the type parameter at constant definition. What would be great is
            // a const<TDoc, TElt> Xp<TDoc, TElt> SomeName = .... but nope.
            // Thus the need to create a new anonymous function when calling Compose.
            //
            // Conclusion : everything hereafter is plain boilerplate. I'll probably automate at some later point. 


            /// <summary>
            /// Basic composition operator
            /// </summary>    
            /// <param name="first">The first function to apply</param>
            /// <param name="second">The second function to apply</param>
            /// <returns>A function that applies the first function and, if successful, apply the second function</returns>    
            public static Xp<TDoc, TElt> Compose<TDoc, TElt>(this Xp<TDoc, TElt> first, Xp<TDoc, TElt> second)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => context => first(context) switch
        {
            Success<TDoc, TElt> success => second(success.Context),
            Failure<TDoc, TElt> failure => failure,
            _ => throw new NotImplementedException()
        };

    /// <summary>
    /// Can be used as a shorthand to eval a rule against a document. 
    /// All it does is setting the initial context
    /// </summary>    
    public static Result<TDoc, TElt> Eval<TDoc, TElt>(this Xp<TDoc, TElt> xp, TDoc doc)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp(new Context<TDoc, TElt>(doc));

    /// <summary>
    /// Set the context to the root node or the initial node if defined in the context.
    /// </summary>   
    public static Xp<TDoc, TElt> Root<TDoc, TElt>(this Xp<TDoc, TElt> xp)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp.Compose(context => Root<TDoc, TElt>()(context));

    /// <summary>
    /// Produces a new context following the axis and possible name filter. 
    /// Also sets the result to the new context NodeSet
    /// </summary>    
    public static Xp<TDoc, TElt> Move<TDoc, TElt>(this Xp<TDoc, TElt> xp, Axis axis, string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp.Compose(context => Move<TDoc, TElt>(axis, name)(context));

    /// <summary>
    /// Move context to the child nodes of given name
    /// </summary>    
    public static Xp<TDoc, TElt> Child<TDoc, TElt>(this Xp<TDoc, TElt> xp, string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp.Compose(context => Child<TDoc, TElt>(name)(context));

    /// <summary>
    /// Move context to the attributes of given name
    /// </summary>    
    public static Xp<TDoc, TElt> Attribute<TDoc, TElt>(this Xp<TDoc, TElt> xp, string name)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp.Compose(context => Attribute<TDoc, TElt>(name)(context));

    public static Xp<TDoc, TElt> Binary<TDoc, TElt>(this Xp<TDoc, TElt> xp, Xp<TDoc, TElt> left, BinOp binOp, Xp<TDoc, TElt> right)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp.Compose(context => Binary(left, binOp, right)(context));

    public static Xp<TDoc, TElt> Sequence<TDoc, TElt>(this Xp<TDoc, TElt> xp, params Xp<TDoc, TElt>[] items)
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
        => xp.Compose(context => Sequence(items)(context));

    #endregion
}
