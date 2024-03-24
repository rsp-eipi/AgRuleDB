namespace AgRuleDB_Generated;

[AttributeUsage(AttributeTargets.All)]
public class RuleAttribute : Attribute
{
    public string Id;
    public string Description;
    public RuleAttribute(string id, string description)
    {
        Id = id;
        Description = description;
    }
}
