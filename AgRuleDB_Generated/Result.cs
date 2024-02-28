using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Generated;

public abstract class Result<TDoc, TElt>(bool success) where TDoc : IInput<TDoc, TElt>
                                                       where TElt : IInputElement<TElt>
{
    public bool WasSuccessful { get; init; } = success;
    public bool WasFailed { get => !WasSuccessful; }    
}

/// <summary>
/// Sucessful result providing the evaluation Value and the new Context
/// </summary>
public class Success<TDoc, TElt>(XpValue value, Context<TDoc, TElt> newContext)
                : Result<TDoc, TElt>(true)
                where TDoc : IInput<TDoc, TElt>
                where TElt : IInputElement<TElt>
{    
    public XpValue Value { get; init; } = value;
    public Context<TDoc, TElt> Context { get; init; } = newContext;
}

/// <summary>
/// Failed evaluation
/// </summary>
public class Failure<TDoc, TElt>(string message, Context<TDoc, TElt> newContext)
                : Result<TDoc, TElt>(false)
                where TDoc : IInput<TDoc, TElt>
                where TElt : IInputElement<TElt>
{
    public string Message { get; init; } = message;
    public Context<TDoc, TElt> Context { get; init; } = newContext;
}


