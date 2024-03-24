using AgRuleDB_Lib.XPathParser;
using static AgRuleDB_Lib.XPathRunner.XpLibrary;

namespace AgRuleDB_Lib.XPathRunner;
internal class TestRules
{
    public static class Rules<D, E> where D : IInput<D, E> where E : IInputElement<E>
    {
        public static readonly Xp<D, E> rule01 = Move<D, E>(Axis.DescendantOrSelf, "author");
        public static readonly Xp<D, E> rule02 = Root<D, E>().Move(Axis.DescendantOrSelf, "author");
        public static readonly Xp<D, E> rule03 = Root<D, E>().Move(Axis.Child, "test").Move(Axis.Child, "");
        public static readonly Xp<D, E> rule04 = Rule<D, E>("r04", "/book/@id").Root().Move(Axis.Child, "book").Move(Axis.Attribute, "id");
        public static readonly Xp<D, E> rule05 = Rule<D, E>("r05", "book/@id, 3")
            .Sequence(Move<D, E>(Axis.DescendantOrSelf, "book"), Lift<D, E>(3));
        public static readonly Xp<D, E> rule06 = Rule<D, E>("r06", "book/@id =  ('249' , '250')")
            .Binary(
                Child<D, E>("book").Attribute("id"),
                BinOp.GenEqual,
                Sequence(Lift<D, E>("249"), Lift<D, E>("bk101")));
        public static readonly Xp<D, E> rule07 = Rule<D, E>("r07", "")
            .Sequence(
          Binary<D, E>(
             Move<D, E>(Axis.DescendantOrSelf, "book")
             , BinOp.ValEqual
             , Lift<D, E>(5)
          )
          , Lift<D, E>(3)
       );
    }
}