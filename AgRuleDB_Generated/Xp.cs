using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Generated;

/// <summary>
/// Represents a fragment of XPath expression.
/// </summary>
/// <typeparam name="T">The type of the result.</typeparam>
/// <param name="input">The input XML Document to evaluate against.</param>
/// <returns>The result of evaluation the XPath fragment against that document.</returns>
public delegate XpValue Xp<out T>(Context<T> input);

internal class Xp
{
}
