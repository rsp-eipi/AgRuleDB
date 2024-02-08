global using AgRuleDB_Lib.Schematron;

namespace AgRuleDB_Explorer;

public static class Common
{
    public static List<Pattern> Patterns {  get; set; }

    static Common()
    {
        Patterns = SchematronParser.LoadDB(@"D:\A3\Code_RSPL\AgRuleDB\TestFiles\rules\fr");
    }

}
