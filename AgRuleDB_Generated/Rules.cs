using AgRuleDB_Lib.XPathParser;
using static XpLibrary;

namespace AgRuleDB_Generated;
public  class Rules<TDoc, TElt> where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
{
    public static readonly Xp<TDoc, TElt> rule1 = Move(Axis.DescendantOrSelf, "tip");
}
