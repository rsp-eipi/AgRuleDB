global using Microsoft.Extensions.Logging;
global using Microsoft.Extensions.Logging.Abstractions;
using AgRuleDB_Lib.XPathParser;

namespace AgRuleDB_Lib;
public class RuleDBService
{
    private static ILogger _logger = NullLogger.Instance;

    internal static ILogger Logger { get => _logger; }

    public RuleDBService(ILogger<RuleDBService> logger)
    {
        _logger = logger ?? (ILogger)NullLogger.Instance;
    }

    public RuleDBService(ILogger logger)
    {
        _logger = logger ?? NullLogger.Instance;
    }

    public void RunConsoleTest(string projectRootFolder)
    {
        // loading rules
        string ruleFolder = Path.Combine(projectRootFolder, @"Edifact\SpecEdifact\d20b\");
        string serviceSpecFolder = Path.Combine(projectRootFolder, @"Edifact\SpecEdifact\Service\");

        string testRule = """
if ((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) ))
    and (isTradeItemADespatchUnit  = 'true')
    and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') 
    and (gdsnTradeItemClassification/gpcCategoryCode!='10005845')
    and (tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode))
then  
    exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem)
    and (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem) 
    satisfies not ((empty($node)) ) ) 
else true()
""";

        XpGrammar.TestXpParser(testRule);


    }
}