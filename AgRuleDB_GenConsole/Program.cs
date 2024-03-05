using Serilog;
using Serilog.Extensions.Logging;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using AgRuleDB_Generated;

ConfigurationBuilder confBuilder = new();
confBuilder.SetBasePath(Directory.GetCurrentDirectory()).AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
IConfiguration configuration = confBuilder.Build();

Log.Logger = new LoggerConfiguration().ReadFrom.Configuration(configuration).CreateLogger();


RuleDBGenService ruleDB = new RuleDBGenService(new SerilogLoggerFactory(Log.Logger).CreateLogger(nameof(RuleDBGenService)));

var container = new ServiceCollection().AddLogging(a => a.AddSerilog()).BuildServiceProvider(true);

ruleDB.RunConsoleTest("");