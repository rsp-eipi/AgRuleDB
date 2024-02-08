namespace AgRuleDB_Lib.Schematron;

/* Schematron ref : 
https://github.com/Schematron/schema/blob/main/schematron.rnc

Doc: 
https://schematron.com/
*/

public class Pattern(string title, string description, Rule rule)
{
    public string Title { get; set; } = title;
    public string Description { get; set; } = description;
    public string Translation { get; set; } = description;
    public bool IsActive { get; set; } = true;
    public Rule Rule { get; set; } = rule;
}

public enum RuleType { Assert, Report }
public class Rule(RuleType ruleType, string context, string test, string errorMessage, List<Location> locations)
{
    public RuleType RuleType { get; set; } = ruleType;
    public string Context { get; set; } = context;    
    public string Test { get; set; } = test;
    public string ErrorMessage { get; set; } = errorMessage;

    public List<Location> Locations = locations;
}

public class Location(string locationName, string locationValue)
{
    public string LocationName { get; set; } = locationName;
    public string LocationPath { get; set; } = locationValue;
}



