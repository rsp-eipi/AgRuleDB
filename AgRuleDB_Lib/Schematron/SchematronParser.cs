using System.Xml;

namespace AgRuleDB_Lib.Schematron;

public static class SchematronParser
{

    public static List<Pattern> LoadDB(string folderPath)
    {        
        List<Pattern> patterns = new List<Pattern>();
        foreach (string file in Directory.GetFiles(folderPath).Where(f => Path.GetFileName(f).StartsWith("rule-")))
            patterns.AddRange(ParseSchematronFile(file));

        string translationFile = Path.Combine(folderPath, "translations.xml");
        if (File.Exists(translationFile))
            ParseTranslation(translationFile, patterns);
        return patterns;
    }

    

    public static IEnumerable<Pattern> ParseSchematronFile(string xmlFilename)
    {
        using (var reader = new XmlTextReader(xmlFilename))
            while (reader.ReadToFollowing("pattern"))
                yield return ParsePattern(reader);
    }

    private static Pattern ParsePattern(XmlTextReader reader)
    {
        string currentNode = string.Empty;
        string currentTitle = string.Empty;
        string currentDescription = string.Empty;
        Rule? currentRule = null;
        while (reader.Read())
        {
            if (reader.NodeType == XmlNodeType.Whitespace)
                continue;
            if (reader.NodeType == XmlNodeType.EndElement && reader.Name == "pattern")
                break;
            if (reader.NodeType == XmlNodeType.Element)
                currentNode = reader.Name;
            if ((reader.NodeType == XmlNodeType.Text) && (currentNode == "title"))
                currentTitle = reader.Value;
            if ((reader.NodeType == XmlNodeType.Text) && currentNode.EndsWith("doc:description"))
                currentDescription = reader.Value;
            if ((reader.NodeType == XmlNodeType.Element) && (currentNode == "rule"))
                currentRule = ParseRule(reader);
        }
        return new Pattern(currentTitle, currentDescription, currentRule);
    }

    private static Rule ParseRule(XmlTextReader reader)
    {
        string currentElement = string.Empty;
        RuleType currentRuleType = RuleType.Assert;
        string currentContext = reader.GetAttribute("context") ?? string.Empty;
        string currentErrorMessage = string.Empty;
        string currentTest = string.Empty;
        List<Location> currentLocations = new List<Location>();
        while (reader.Read())
        {
            if (reader.NodeType == XmlNodeType.Whitespace)
                continue;
            if (reader.NodeType == XmlNodeType.EndElement && reader.Name == "rule")
                break;
            if (reader.NodeType == XmlNodeType.Element)
                currentElement = reader.Name;
            if (currentElement == "assert")
            {
                currentRuleType = RuleType.Assert;
                currentTest = reader.GetAttribute("test") ?? string.Empty;
            }
            if (currentElement == "report")
            {
                currentRuleType = RuleType.Report;
                currentTest = reader.GetAttribute("test") ?? string.Empty;
            }
            if (reader.NodeType == XmlNodeType.Element && reader.Name == "rule")
                currentContext = reader.GetAttribute("context") ?? string.Empty;
            if (reader.NodeType == XmlNodeType.Text && currentElement == "errorMessage")
                currentErrorMessage = reader.Value;
            if (reader.NodeType == XmlNodeType.Element && currentElement == "location")
                currentLocations.AddRange(ParseLocations(reader));
        }
        return new Rule(currentRuleType, currentContext, currentTest, currentErrorMessage, currentLocations);
    }

    private static IEnumerable<Location> ParseLocations(XmlTextReader reader)
    {
        string locationName = string.Empty;
        string locationValue = string.Empty;
        string currentNode = string.Empty;
        while (reader.Read())
        {
            if (reader.NodeType == XmlNodeType.Whitespace || reader.NodeType == XmlNodeType.Comment)
                continue;
            if (reader.NodeType == XmlNodeType.EndElement && reader.Name == "location")
                break;
            if (reader.NodeType == XmlNodeType.Element)
                currentNode = reader.Name;
            if (currentNode != "xsl:value-of")
                locationName = currentNode;
            if (reader.NodeType == XmlNodeType.Element && currentNode == "xsl:value-of")
                locationValue = reader.GetAttribute("select") ?? string.Empty;
            if (reader.NodeType == XmlNodeType.EndElement && reader.Name == locationName)
                yield return new Location(locationName, locationValue);
        }
    }

    private static void ParseTranslation(string translationFile, List<Pattern> patterns)
    {
        using (var reader = new XmlTextReader(translationFile))
        {
            string currentRule = string.Empty;
            while (reader.Read())
            {
                if (reader.NodeType == XmlNodeType.Comment || reader.NodeType == XmlNodeType.Comment)
                    continue;
                if (reader.NodeType == XmlNodeType.Element)
                    if (reader.Name.StartsWith("FR_"))
                        currentRule = "Rule "+reader.Name;
                if (reader.NodeType == XmlNodeType.Text)
                {
                    Pattern? p = patterns.FirstOrDefault(p => p.Title == currentRule);
                    if (p is not null)
                        p.Translation = reader.Value;
                }

            }
        }                
    }
}

