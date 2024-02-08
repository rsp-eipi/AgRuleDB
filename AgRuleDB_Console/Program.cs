using Serilog;
using Serilog.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using AgRuleDB_Lib;
using AgRuleDB_Lib.Schematron;


ConfigurationBuilder confBuilder = new();
confBuilder.SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
IConfiguration configuration = confBuilder.Build();

Log.Logger = new LoggerConfiguration().ReadFrom.Configuration(configuration).CreateLogger();


RuleDBService ruleDB = new RuleDBService(new SerilogLoggerFactory(Log.Logger).CreateLogger(nameof(RuleDBService)));

var container = new ServiceCollection().AddLogging(a => a.AddSerilog()).BuildServiceProvider(true);

const string AgRuleDB_Lib_RootFolder = @"..\..\..\..\AgRuleDB_Lib\";
const string RuleFrPath = @"D:\A3\Code_RSPL\AgRuleDB\TestFiles\rules\fr";

Log.Information("------------------------ START ------------------------");

ruleDB.RunConsoleTest(AgRuleDB_Lib_RootFolder);
//List<Pattern> patterns = SchematronParser.LoadDB(RuleFrPath);
//Log.Information($"Loaded {patterns.Count} patterns in rule database");

Log.Information("------------------------ DONE ------------------------");



