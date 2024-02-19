using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Generated;
/// <summary>
/// Contains helper functions to create <see cref="IResult&lt;T&gt;"/> instances.
/// </summary>
public class Result
{
    private readonly XpValue _result;
    private readonly Context _newContext;
    private readonly bool   _wasSuccessful;
    private readonly string _message;
    


    /// <summary>
    /// Creates a success result.
    /// </summary>
    /// <typeparam name="T">The type of the result (value).</typeparam>
    /// <param name="value">The sucessfully parsed value.</param>
    /// <param name="remainder">The remainder of the input.</param>
    /// <returns>The new <see cref="IResult&lt;T&gt;"/>.</returns>
    public static IResult<T> Success<T>(T value, IInput remainder)
    {
        return new Result<T>(value, remainder);
    }

    /// <summary>
    /// Creates a failure result.
    /// </summary>
    /// <typeparam name="T">The type of the result.</typeparam>
    /// <param name="remainder">The remainder of the input.</param>
    /// <param name="message">The error message.</param>
    ///d <param name="expectations">The parser expectations.</param>
    /// <returns>The new <see cref="IResult&lt;T&gt;"/>.</returns>
    public static IResult<T> Failure<T>(IInput remainder, string message, IEnumerable<string> expectations)
    {
        return new Result<T>(remainder, message, expectations);
    }
}

