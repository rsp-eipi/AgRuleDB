using Microsoft.Extensions.Logging.Abstractions;
using Microsoft.Extensions.Logging;
using AgRuleDB_Lib.XPathParser;
using static AgRuleDB_Generated.XpLibrary;

namespace AgRuleDB_Generated;
public class RuleDBGenService
{
    private static ILogger _logger = NullLogger.Instance;

    internal static ILogger Logger { get => _logger; }

    public RuleDBGenService(ILogger<RuleDBGenService> logger)
    {
        _logger = logger ?? (ILogger)NullLogger.Instance;
    }

    public RuleDBGenService(ILogger logger)
    {
        _logger = logger ?? NullLogger.Instance;
    }

    

    public void RunConsoleTest(string projectRootFolder)
    {
        string testDocument = """
            <xml>
              <title>xpath.playground.fontoxml.com</title>
              <summary>This is a learning tool for XML, XPath and XQuery.</summary>
              <tips>
                <tip id='edit'>You can edit everything on the left</tip>
                <tip id='examples'>You can access more examples from a menu in the top right</tip>
                <tip id='permalink'>Another button there lets you share your test using an URL</tip>
              </tips>
            </xml>
            """;

        

    }
}