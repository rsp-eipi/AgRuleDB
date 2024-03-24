using AgRuleDB_Lib.XPathParser;
using AgRuleDB_Lib.XPathRunner;
using static AgRuleDB_Lib.XPathRunner.XpLibrary;

namespace AgRuleDB_Generated;
public static class Rules<D,E> where D : IInput<D,E> where E : IInputElement<E>
{
    public static readonly Xp<D,E> rule01 = Move<D,E>(Axis.DescendantOrSelf, "author");
    public static readonly Xp<D,E> rule02 = Root<D,E>().Move(Axis.DescendantOrSelf, "author");
    public static readonly Xp<D,E> rule03 = Root<D,E>().Move(Axis.Child, "test").Move(Axis.Child,"");
    public static readonly Xp<D,E> rule04 = Rule<D,E>("r04", "/book/@id").Root().Move(Axis.Child, "book").Move(Axis.Attribute, "id");
    public static readonly Xp<D,E> rule05 = Rule<D,E>("r05", "book/@id, 3")
        .Sequence(Move<D,E>(Axis.DescendantOrSelf, "book"), Lift<D,E>(3));
    public static readonly Xp<D,E> rule06 = Rule<D,E>("r06", "book/@id =  ('249' , '250')")
        .Binary(
            Child<D,E>("book").Attribute("id"),
            BinOp.GenEqual,
            Sequence(Lift<D,E>("249"), Lift<D,E>("bk101")));
    public static readonly Xp<D, E> rule07 = Rule<D, E>("r07", "")
        .Sequence(
      Binary<D, E>(
         Move<D, E>(Axis.DescendantOrSelf, "book")
         , BinOp.ValEqual
         , Lift<D, E>(5)
      )
      , Lift<D, E>(3)
   );
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
