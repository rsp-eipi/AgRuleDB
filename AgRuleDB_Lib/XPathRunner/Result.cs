namespace AgRuleDB_Lib.XPathRunner;

public abstract class Result<TDoc, TElt>(bool success, Context<TDoc, TElt> newContext, XpValue? value = null) 
    where TDoc : IInput<TDoc, TElt>
    where TElt : IInputElement<TElt>
{
    public bool WasSuccessful { get; init; } = success;
    public bool WasFailed { get => !WasSuccessful; }
    public Context<TDoc, TElt> Context { get; init; } = newContext;
    public XpValue XpValue { get; init; } = value ?? new XpValueNodeSet<TElt>(newContext.CurrentContext);    
}

/// <summary>
/// Sucessful result providing the evaluation Value and the new Context
/// </summary>
public class Success<TDoc, TElt>(Context<TDoc, TElt> newContext, XpValue? value = null)
    : Result<TDoc, TElt>(true, newContext, value)
    where TDoc : IInput<TDoc, TElt>
    where TElt : IInputElement<TElt>
{           
    public override string ToString() => $"{Context.RuleInfo}\nSuccess:\n\t{XpValue}";    
}

/// <summary>
/// Failed evaluation
/// </summary>
public class Failure<TDoc, TElt>(string message, Context<TDoc, TElt> newContext)
    : Result<TDoc, TElt>(false, newContext, new XpValueError(message))
    where TDoc : IInput<TDoc, TElt>
    where TElt : IInputElement<TElt>
{
    public string Message { get; init; } = message;    
    public override string ToString() => $"Failure: {Message}";
}


public static class ResultExtensions
{
    public static XpValue AsValue<TDoc, TElt>(this IEnumerable<Result<TDoc, TElt>> results)
        where TDoc : IInput<TDoc, TElt>
        where TElt : IInputElement<TElt>
    {
        if (results.Any(r => r.WasFailed)) 
            return results.First(r => r.WasFailed).XpValue;
        if (results.Count() == 1)
            return results.First().XpValue;
        var values = from r in results select r.XpValue; // we checked above that there is no error in results
        return new XpValueSequence<TElt>(new ValueSequence<TElt>(values));
    }
}


