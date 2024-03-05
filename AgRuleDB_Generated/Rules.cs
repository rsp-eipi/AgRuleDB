using AgRuleDB_Lib.XPathParser;
using static AgRuleDB_Generated.XpLibrary;

namespace AgRuleDB_Generated;
public static class Rules<TDoc, TElt> where TDoc : IInput<TDoc, TElt> where TElt : IInputElement<TElt>
{
    public static readonly Xp<TDoc, TElt> rule1 = Move<TDoc, TElt>(Axis.DescendantOrSelf, "author");
    public static readonly Xp<TDoc, TElt> rule2 = Root<TDoc, TElt>().Move(Axis.DescendantOrSelf, "author");
    public static readonly Xp<TDoc, TElt> rule3 = Root<TDoc, TElt>().Move(Axis.Child, "test").Move(Axis.Child,"");
    public static readonly Xp<TDoc, TElt> rule4 = Rule<TDoc, TElt>("r04", "/book/@id").Root().Move(Axis.Child, "book").Move(Axis.Attribute, "id");
    public static readonly Xp<TDoc, TElt> rule5 = Rule<TDoc, TElt>("r04", "book/@id =  ('249' , '250')")
        .Binary(
            Child<TDoc, TElt>("book").Attribute("id"),
            BinOp.GenEqual,
            (["249", "250"]));

    //    public static readonly Xp<TDoc, TElt> ruleGdsn01 = Rule<TDoc, TElt>("r04", """
    //if ((targetMarket/targetMarketCountryCode =  ('249' , '250'))
    //    and (isTradeItemADespatchUnit  = 'true')
    //    and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') 
    //    and (gdsnTradeItemClassification/gpcCategoryCode!='10005845')
    //    and (tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode))
    //then  
    //    true()
    //else
    //exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem)
    //    and (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem) 
    //    satisfies not ((empty($node)) ) ) 
    //""")
    //        (([Binary(
    //            Binary(
    //                Binary(
    //                    Binary(
    //                        ([Binary(
    //                            Move(Axis.Child, "targetMarket").Move(Axis.Child, "targetMarketCountryCode"),
    //                            BinOp.GenEqual,
    //                            (["249", "250"]))]),
    //                        BinOp.And,
    //                        ([Binary(
    //                            Move(Axis.Child, "isTradeItemADespatchUnit"),
    //                            BinOp.GenEqual,
    //                            "true")])),
    //                    BinOp.And,
    //                    ([Binary(
    //                        Move(Axis.Child, "gdsnTradeItemClassification").Move(Axis.Child, "gpcCategoryCode"),
    //                        BinOp.GenNotEqual,
    //                        "10005844")])),
    //                BinOp.And,
    //                ([Binary(
    //                    Move(Axis.Child, "gdsnTradeItemClassification").Move(Axis.Child, "gpcCategoryCode"),
    //                    BinOp.GenNotEqual,
    //                    "10005845")])),
    //            BinOp.And,
    //            ([Move(Axis.Child, "tradeItemInformation").Move(Axis.Child, "extension").Move(Axis.Child, "packagingInformationModule").Move(Axis.Child, "packaging").Move(Axis.Child, "platformTypeCode")]))]))
    //        ? Call("true", ([]))
    //        : Binary(
    //            Call("exists", 
    //                ([Move(Axis.Child, "tradeItemInformation").Move(Axis.Child, "extension").Move(Axis.Child, "tradeItemHierarchyModule").Move(Axis.Child, "tradeItemHierarchy").Move(Axis.Child, "quantityOfCompleteLayersContainedInATradeItem")])), 
    //            BinOp.And, 
    //            ([All(
    //                Bind(Var("@node"), 
    //                    ([Move(Axis.Child, "tradeItemInformation").Move(Axis.Child, "extension").Move(Axis.Child, "tradeItemHierarchyModule").Move(Axis.Child, "tradeItemHierarchy").Move(Axis.Child, "quantityOfCompleteLayersContainedInATradeItem")])).Eval(
    //                    Call("not", 
    //                        ([([Call("empty", ([Var("@node")]))])]))))]));
}
