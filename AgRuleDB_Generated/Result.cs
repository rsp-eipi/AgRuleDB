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
public class Success<TDoc, TElt>(Context<TDoc, TElt> newContext, XpValue? value = null)
                : Result<TDoc, TElt>(true)
                where TDoc : IInput<TDoc, TElt>
                where TElt : IInputElement<TElt>
{    
    public XpValue Result { get; init; } = value ?? new XpValueNodeSet<TElt>(newContext.CurrentContext);
    public Context<TDoc, TElt> Context { get; init; } = newContext;
    public override string ToString() => $"{Context.RuleInfo}\nSuccess:\n\t{Result}";
    public static Success<TDoc, TElt> Create(Context<TDoc, TElt> newContext, XpValue? value = null) => new Success<TDoc, TElt>(newContext, value);
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
    public override string ToString() => $"Failure: {Message}";
}


