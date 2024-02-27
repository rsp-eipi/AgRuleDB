using AgRuleDB_Lib.XPathParser;
using Sprache;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

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
    /// <summary>
    /// Advances the context along some axis.
    /// </summary>
    /// <returns>A new <see cref="Context" /> that is advanced following the axis.</returns>
    /// <exception cref="System.InvalidOperationException">The move couldn't be performed.</exception>
    public static Xp<TDoc, TElt> Move<TDoc, TElt>(this Xp<TDoc, TElt> xp, Axis axis, string name) 
        where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
    {
        if (xp is null) throw new ArgumentNullException(nameof(xp));

        return context =>
        {
            Context<TDoc, TElt> newContext = new();
            var r = xp(context);
            switch(r)
            {
                case Success<TDoc, TElt> s:
                    if (s.Value.XpType != XpType.NodeSet)
                        return new Failure("Cannot move from an atomic result", context);
                    foreach(var v in s.Value.)
                        return new Success<TDoc, TElt>(v);
            }
        };
    }
}
