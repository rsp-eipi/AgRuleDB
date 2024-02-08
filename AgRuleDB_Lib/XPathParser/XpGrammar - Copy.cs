using Sprache;
using System.Linq.Expressions;
using static AgRuleDB_Lib.RuleDBService;
using System.Xml;
using System.Net.Http.Headers;

namespace AgRuleDB_Lib.XPathParser;

// spec : https://www.w3.org/TR/xpath20/


internal static class XpGrammar
{
    static readonly string[] Keywords = new[]
    {
        "or", "and", "<=", ">=", "<", ">", "=", "!=", "if", "*", "div", "mod" 
    };

    public static Parser<string> XpAny =
        from res in Parse.AnyChar.Many().Text()
        select res;

    public static Parser<T> SkipTrailingWhiteSpaces<T>(this Parser<T> parser) =>
        (parser is null) ? throw new ArgumentNullException(nameof(parser)) :
            from item in parser
            from trailing in Parse.Chars(' ', '\t', '\n', '\r').Many()
            select item;

    public static Parser<T> Tokenize<T>(this Parser<T> parser) =>
        (parser is null) ? throw new ArgumentNullException(nameof(parser)) :
            from leading in Parse.Chars(' ', '\t', '\n', '\r').Many()
            from item in parser
            from trailing in Parse.Chars(' ', '\t', '\n', '\r').Many()
            select item;

    // [4] NameStartChar	   ::=   	":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] | [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] | [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
    // [4a] NameChar::=   	NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
    // here I will simplify as I don't give a toss about correctness and nobody uses diaeresis in schematron anyway
    static readonly Parser<XpIdentifier> XpIdentifier =
                from name in Parse.Identifier(Parse.Letter, Parse.LetterOrDigit.Or(Parse.Chars('_', '.', ':', '-'))).Tokenize()
                where !Keywords.Contains(name.ToLower())
                select new XpIdentifier(name);

    static readonly Parser<string> _StringContent =
            from result in Parse.String("\"\"").Return("\"\"").Or<IEnumerable<char>>(Parse.CharExcept('"').Once()).Text()
            select result;

    static readonly Parser<string> _String =
                    from open in Parse.Char('"')
                    from value in _StringContent.Many()
                    from close in Parse.Char('"')
                    select open + string.Concat(value) + close;

    //static readonly Parser<string> _Other = Parse.AnyChar.Except(Parse.Char('(').Then(_ => Parse.Char(':'))).Many().Text();
    static readonly Parser<string> _Other = Parse.AnyChar.Except(Parse.String("(:").Or(Parse.String(":)"))).Many().Text();

    static readonly Parser<string> _Comment =
            from open in Parse.String("(:")
            from comment in _Other
            from close in Parse.String(":)")
            select "";    

    static readonly Parser<string> _ContentUnit = _Comment.Or(_Other);

    static readonly Parser<string> _Content =
        from texts in _ContentUnit.Many()
        select string.Concat(texts);

    static readonly Parser<XpParenthesisExpression> XpParenthesisExpression =
        from open in Parse.Char('(').Tokenize()
        from arguments in
            (from _ in Parse.Char(',').Tokenize().Optional()
             from arg in Parse.Ref(() => XpExpression)
             select arg).Many()
        from close in Parse.Char(')').Tokenize()
        select new XpParenthesisExpression(arguments.ToArray());

    static readonly Parser<XpFunctionCallExpression> XpFunctionCallExpression =
            from name in XpIdentifier.Tokenize()
            from open in Parse.Char('(').Tokenize()
            from arguments in
                (from _ in Parse.Char(',').Tokenize().Optional()
                 from arg in Parse.Ref(() => XpExpression)
                 select arg).Many()
            from close in Parse.Char(')').Tokenize()
            select new XpFunctionCallExpression(name, arguments.ToArray());


    static readonly Parser<XpExpression> XpElseExpression =
        from elsekeyword in Parse.String("else").Tokenize()
        from elseexpression in Parse.Ref(() => XpExpression)
        select elseexpression;

    static readonly Parser<XpIfThenElse> XpIfExpression =
        from ifkeyword in Parse.String("if").Tokenize()
        from opencondition in Parse.Char('(').Tokenize()
        from condition in Parse.Ref(() => XpExpression)
        from closecondition in Parse.Char(')').Tokenize()
        from thenkeyword in Parse.IgnoreCase("then").Tokenize()
        from thenexpression in Parse.Ref(() => XpExpression)
        from elseExpression in XpElseExpression.Optional()
        select new XpIfThenElse(condition, thenexpression, elseExpression.GetOrDefault());


    static readonly Parser<XpExpression> XpExpressionTerm =
          XpFunctionCallExpression
        .Or<XpExpression>(XpIfExpression)
        .Or(XpParenthesisExpression)
        .Or(XpIdentifier);

    static readonly Parser<string> XpBinaryOperator =
          from op in Parse.Chars('+', '-', '/', '*', '=', '<', '>').AtLeastOnce()
              .Or(Parse.IgnoreCase("or ")).Or(Parse.IgnoreCase("and "))
              .Or(Parse.IgnoreCase("<=")).Or(Parse.IgnoreCase(">="))
              .Or(Parse.IgnoreCase("div ")).Or(Parse.IgnoreCase("!="))
              .Or(Parse.IgnoreCase("mod "))
              .Token().Text()
          select op;

    static readonly Parser<XpExpression> XpExpression =
           from compositeexpression in Parse.ChainOperator(XpBinaryOperator, XpExpressionTerm, (op, left, right) => new XpBinaryOperator(left, op, right))
           select compositeexpression;


    // [1]    	XPath 	   ::=    	Expr
    // [2]    	Expr 	   ::=    	ExprSingle ("," ExprSingle)*
    static readonly Parser<Expr> Expr =
        from first in ExprSingle
        from others in
            (from _ in Parse.Char(',').Tokenize()
             from exprsingl in ExprSingle
             select exprsingl).Many()
        select new Expr(first, others);

    // [3]    	ExprSingle 	   ::=    	ForExpr | QuantifiedExpr | IfExpr | OrExpr
    static readonly Parser<ExprSingle> ExprSingle =
        Parse.Ref(() => ForExpr)
        .Or<ExprSingle>(Parse.Ref(() => IfExpr))
        .Or(Parse.Ref(() => OrExpr))
    ;

    // [4]    	ForExpr 	        ::=    	SimpleForClause "return" ExprSingle
    // [5]    	SimpleForClause     ::=    	"for" "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)*
    static readonly Parser<ExprSingle> ForExpr =
        from _for in Parse.String("for").Tokenize()
        from firstforbindings in Parse.Ref(() => InClause)
        from otherforbindings in
            (from _comma in Parse.Char(',').Tokenize()
             from nextforbinding in Parse.Ref(() => InClause)
             select nextforbinding).Many()
        from _return in Parse.String("return").Tokenize()
        from forexpr in ExprSingle
        select new ForExpr([firstforbindings, .. otherforbindings], forexpr);
 
    static readonly Parser<InClause> InClause =
        from _dollar in Parse.Char('$')
        from name in Parse.Ref(() => QName) 
        from _in in Parse.String("in").Tokenize()
        from expr in ExprSingle
        select new InClause(name.Name, expr);

    // [6]    	QuantifiedExpr 	   ::=    	("some" | "every") "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle
    static readonly Parser<QuantifiedExpr> QuantifiedExpr =
        from quantifier in Parse.String("some").Or(Parse.String("every")).Tokenize().Text()
        from bindings in InClause.Many()
        from _satisfies in Parse.String("satisfies").Tokenize()
        from satisfyExpr in ExprSingle
        select new QuantifiedExpr(quantifier, bindings, satisfyExpr);

    // [7]    	IfExpr 	   ::=    	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
    static readonly Parser<IfExpr> IfExpr =
        from _if in Parse.String("if").Tokenize()
        from _open in Parse.Char('(').Tokenize()
        from testexpr in Expr
        from _close in Parse.Char(')').Tokenize()
        from _then in Parse.String("then").Tokenize()
        from thenexpr in ExprSingle
        from _else in Parse.String("else").Tokenize()
        from elseexpr in ExprSingle
        select new IfExpr(testexpr, thenexpr, elseexpr);

    // [8]    	OrExpr 	   ::=    	AndExpr ( "or" AndExpr )*
    static Parser<ExprSingle> ParseBinary(Parser<IEnumerable<Char>> operatorParser, Parser<ExprSingle> nextParser) => i =>
    {
        var left = nextParser(i);
        var remainder = left.Remainder;
        if (left.WasSuccessful)
        {
            remainder = left.Remainder;
            var op = operatorParser(remainder);
            if (op.WasSuccessful)
            {
                remainder = op.Remainder;
            }
        }
        return Result.Success<ExprSingle>(null, remainder);
    };
        //from left in nextParser
        //from rights in
        //    (from op in operatorParser.Tokenize().Text()
        //     from right in nextParser
        //     select (op: XpUtil.StringToBinaryOperator(op), right: right)
        //     ).Many()
        //select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);
    
    

    static readonly Parser<ExprSingle> OrExpr = 
        from left in Parse.Ref(() => AndExpr)
        from rights in
            (from op in Parse.String("or").Tokenize().Text()
             from right in Parse.Ref(() => AndExpr)
             select (op: XpUtil.StringToBinaryOperator(op), right: right)
             ).Many()
        select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);
        
    // [9]    	AndExpr 	   ::=    	ComparisonExpr ( "and" ComparisonExpr )*
    static readonly Parser<ExprSingle> AndExpr =
        from left in Parse.Ref(() => ComparisonExpr)
        from rights in
            (from op in Parse.String("and").Tokenize().Text()
             from right in Parse.Ref(() => ComparisonExpr)
             select (op: BinaryOperator.And, right: right)
             ).Many()
        select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);

    // [10]    	ComparisonExpr 	   ::=    	RangeExpr ( (ValueComp | GeneralComp | NodeComp) RangeExpr )?
    static readonly Parser<ExprSingle> ComparisonExpr =
        from left in Parse.Ref(() => RangeExpr)
        from rights in
            (from op in ValueComp.Or(GeneralComp).Or(NodeComp).Tokenize().Text()
             from right in Parse.Ref(() => RangeExpr)
             select (op: XpUtil.StringToBinaryOperator(op), right: right)
             ).Optional()
        select rights.IsDefined ? left : new BinaryExpr(left, rights.Get().op, rights.Get().right);

    // [11]    	RangeExpr 	   ::=    	AdditiveExpr ( "to" AdditiveExpr )?
    static readonly Parser<ExprSingle> RangeExpr =
        from left in Parse.Ref(() => AdditiveExpr)
        from rights in
            (from op in Parse.String("to").Tokenize().Text()
             from right in Parse.Ref(() => AdditiveExpr)
             select (op: XpUtil.StringToBinaryOperator(op), right: right)
             ).Optional()
        select rights.IsDefined ? left : new BinaryExpr(left, rights.Get().op, rights.Get().right);

    // [12]    	AdditiveExpr 	   ::=    	MultiplicativeExpr ( ("+" | "-") MultiplicativeExpr )*
    static readonly Parser<ExprSingle> AdditiveExpr =
         from left in Parse.Ref(() => MultiplicativeExpr)
         from rights in
             (from op in Parse.String("+").Or(Parse.String("-")).Tokenize().Text()
              from right in Parse.Ref(() => MultiplicativeExpr)
              select (op: XpUtil.StringToBinaryOperator(op), right: right)
              ).Many()
         select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);

    // [13]    	MultiplicativeExpr 	   ::=    	UnionExpr ( ("*" | "div" | "idiv" | "mod") UnionExpr )*
    static readonly Parser<ExprSingle> MultiplicativeExpr =
        from left in Parse.Ref(() => UnionExpr)
        from rights in
            (from op in Parse.String("*").Or(Parse.String("div")).Or(Parse.String("idiv")).Or(Parse.String("mod")).Tokenize().Text()
             from right in Parse.Ref(() => UnionExpr)
             select (op: XpUtil.StringToBinaryOperator(op), right: right)
             ).Many()
        select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);
    

    // [14]    	UnionExpr 	   ::=    	IntersectExceptExpr ( ("union" | "|") IntersectExceptExpr )*
    static readonly Parser<ExprSingle> UnionExpr =
        from left in Parse.Ref(() => IntersectExceptExpr)
        from rights in
            (from op in Parse.String("union").Or(Parse.String("|")).Tokenize().Text()
             from right in Parse.Ref(() => IntersectExceptExpr)
             select (op: XpUtil.StringToBinaryOperator(op), right: right)
             ).Many()
        select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);

    

    // [15]    	IntersectExceptExpr 	   ::=    	InstanceofExpr ( ("intersect" | "except") InstanceofExpr )*
    static readonly Parser<ExprSingle> IntersectExceptExpr =
        from left in Parse.Ref(() => InstanceofExpr)
        from rights in (
            from op in Parse.String("intersect").Or(Parse.String("except")).Tokenize().Text()
            from right in Parse.Ref(() => InstanceofExpr)
            select (op: XpUtil.StringToBinaryOperator(op), right: right)
        ).Many()
        select rights.Count() == 0 ? left : BinaryExpr.BuildFromSequence(left, rights);
   
    // [16]    	InstanceofExpr 	   ::=    	TreatExpr ( "instance" "of" SequenceType )?
    static readonly Parser<ExprSingle> InstanceofExpr =
        from left in Parse.Ref(() => TreatExpr)
        from rights in
            (from _instance in Parse.String("instance").Tokenize()
             from _of in Parse.String("of").Tokenize()
             from right in Parse.String("stuff").Text()// TODO: replace by SequenceType once defined
             select right).Many()
        select rights.Count() > 0 ? new InstanceofExpr(left, new SequenceType(new QName(string.Empty, rights.First()))) : left;

    // [17]    	TreatExpr 	   ::=    	CastableExpr ( "treat" "as" SequenceType )?
    static readonly Parser<ExprSingle> TreatExpr =
        from left in Parse.Ref(() => CastableExpr)
        from mayberight in
            (from _instance in Parse.String("treat").Tokenize()
             from _of in Parse.String("as").Tokenize()
             from right in Parse.Ref(() => QName) // TODO: replace by SequenceType once defined
             select right).Optional()
        select mayberight.IsDefined ? new TreatExpr(left, new SequenceType(mayberight.Get())) : left;

    // [18]    	CastableExpr 	   ::=    	CastExpr ( "castable" "as" SingleType )?
    static readonly Parser<ExprSingle> CastableExpr =
        from left in Parse.Ref(() => CastExpr)
        from mayberight in
            (from _instance in Parse.String("castable").Tokenize()
             from _of in Parse.String("as").Tokenize()
             from right in Parse.Ref(() => QName)  // TODO: replace by SingleType once defined
             select right).Optional()
        select mayberight.IsDefined ? new CastableExpr(left, new SingleType(mayberight.Get())) : left;

    // [19]    	CastExpr 	   ::=    	UnaryExpr ( "cast" "as" SingleType )?
    static readonly Parser<ExprSingle> CastExpr=
        from left in Parse.Ref(() => UnaryExpr)
        from mayberight in
            (from _instance in Parse.String("cast").Tokenize()
             from _of in Parse.String("as").Tokenize()
             from right in Parse.Ref(() => UnaryExpr)
             select right).Optional()
        select mayberight.IsDefined ? new CastExpr(left, new SingleType(mayberight.Get())) : left;

    // [20]    	UnaryExpr 	   ::=    	("-" | "+")* ValueExpr    
    // [21]    	ValueExpr 	   ::=    	PathExpr
    static readonly Parser<ExprSingle> UnaryExpr =        
        from op in Parse.String("-").Or(Parse.String("+")).Tokenize().Text().Optional() // TODO : Should be .Many() but it is not expected to be of actual usage
        from left in Parse.Ref(() => ExprSingle)
        select op.IsDefined ? left : new UnaryExpression(op.Get(), left);

    // [22]    	GeneralComp 	   ::=    	"=" | "!=" | "<" | "<=" | ">" | ">=" 
    static readonly Parser<string> GeneralComp =
        from op in Parse.String("=").Or(Parse.String("!=")).Or(Parse.String("<")).Or(Parse.String("<=")).Or(Parse.String(">")).Or(Parse.String(">=")).Tokenize().Text()
        select op.ToString();

    // [23]    	ValueComp 	   ::=    	"eq" | "ne" | "lt" | "le" | "gt" | "ge"
    static readonly Parser<string> ValueComp =
        from op in Parse.String("eq").Or(Parse.String("ne")).Or(Parse.String("lt")).Or(Parse.String("le")).Or(Parse.String("gt")).Or(Parse.String("ge")).Tokenize().Text()
        select op.ToString();

    // [24]    	NodeComp 	   ::=    	"is" | "<<" | ">>"
    static readonly Parser<string> NodeComp =
        from op in Parse.String("is").Or(Parse.String("<<")).Or(Parse.String(">>")).Tokenize().Text()
        select op.ToString();

    // [25]    	PathExpr 	   ::=    	("/" RelativePathExpr?) | ("//" RelativePathExpr) | RelativePathExpr 	/* xgs: leading-lone-slash */
    // [26]    	RelativePathExpr 	   ::=    	StepExpr (("/" | "//") StepExpr)*
    static readonly Parser<PathStep> PathStep =
        from slash in Parse.Char('/').Optional()
        from doubleslash in Parse.Char('/').Optional()
        from step in QName
        select new PathStep("", step.Name);

    // [27]    	StepExpr 	   ::=    	FilterExpr | AxisStep
    // [28]    	AxisStep 	   ::=    	(ReverseStep | ForwardStep) PredicateList
    // [29]    	ForwardStep 	   ::=    	(ForwardAxis NodeTest) | AbbrevForwardStep
    // [30]    	ForwardAxis 	   ::=    	("child" "::") | ("descendant" "::") | ("attribute" "::") | ("self" "::") | ("descendant-or-self" "::") | ("following-sibling" "::") | ("following" "::") | ("namespace" "::")
    // [31]    	AbbrevForwardStep 	   ::=    	"@"? NodeTest
    // [32]    	ReverseStep 	   ::=    	(ReverseAxis NodeTest) | AbbrevReverseStep
    // [33]    	ReverseAxis 	   ::=    	("parent" "::") | ("ancestor" "::") | ("preceding-sibling" "::") | ("preceding" "::") | ("ancestor-or-self" "::")
    // [34]    	AbbrevReverseStep 	   ::=    	".."
    // [35]    	NodeTest 	   ::=    	KindTest | NameTest
    // [36]    	NameTest 	   ::=    	QName | Wildcard
    // [37]    	Wildcard 	   ::=    	"*" | (NCName ":" "*") | ("*" ":" NCName) 	/* ws: explicit */
    // [38]    	FilterExpr 	   ::=    	PrimaryExpr PredicateList
    // [39]    	PredicateList 	   ::=    	Predicate*
    // [40]    	Predicate 	   ::=    	"// [" Expr "]"
    // [41]    	PrimaryExpr 	   ::=    	Literal | VarRef | ParenthesizedExpr | ContextItemExpr | FunctionCall
    // [42]    	Literal 	   ::=    	NumericLiteral | StringLiteral
    // [43]    	NumericLiteral 	   ::=    	IntegerLiteral | DecimalLiteral | DoubleLiteral
    // [44]    	VarRef 	   ::=    	"$" VarName
    // [45]    	VarName 	   ::=    	QName
    // [46]    	ParenthesizedExpr 	   ::=    	"(" Expr? ")"
    // [47]    	ContextItemExpr 	   ::=    	"."
    // [48]    	FunctionCall 	   ::=    	QName "(" (ExprSingle ("," ExprSingle)*)? ")" 	/* xgs: reserved-function-names */ 				/* gn: parens */
    // [49]    	SingleType 	   ::=    	AtomicType "?"?
    // [50]    	SequenceType 	   ::=    	("empty-sequence" "(" ")") | (ItemType OccurrenceIndicator?)
    // [51]    	OccurrenceIndicator 	   ::=    	"?" | "*" | "+" 	/* xgs: occurrence-indicators */
    // [52]    	ItemType 	   ::=    	KindTest | ("item" "(" ")") | AtomicType
    // [53]    	AtomicType 	   ::=    	QName
    // [54]    	KindTest 	   ::=    	DocumentTest | ElementTest | AttributeTest | SchemaElementTest | SchemaAttributeTest | PITest | CommentTest | TextTest | AnyKindTest
    // [55]    	AnyKindTest 	   ::=    	"node" "(" ")"
    // [56]    	DocumentTest 	   ::=    	"document-node" "(" (ElementTest | SchemaElementTest)? ")"
    // [57]    	TextTest 	   ::=    	"text" "(" ")"
    // [58]    	CommentTest 	   ::=    	"comment" "(" ")"
    // [59]    	PITest 	   ::=    	"processing-instruction" "(" (NCName | StringLiteral)? ")"
    // [60]    	AttributeTest 	   ::=    	"attribute" "(" (AttribNameOrWildcard ("," TypeName)?)? ")"
    // [61]    	AttribNameOrWildcard 	   ::=    	AttributeName | "*"
    // [62]    	SchemaAttributeTest 	   ::=    	"schema-attribute" "(" AttributeDeclaration ")"
    // [63]    	AttributeDeclaration 	   ::=    	AttributeName
    // [64]    	ElementTest 	   ::=    	"element" "(" (ElementNameOrWildcard ("," TypeName "?"?)?)? ")"
    // [65]    	ElementNameOrWildcard 	   ::=    	ElementName | "*"
    // [66]    	SchemaElementTest 	   ::=    	"schema-element" "(" ElementDeclaration ")"
    // [67]    	ElementDeclaration 	   ::=    	ElementName
    // [68]    	AttributeName 	   ::=    	QName
    // [69]    	ElementName 	   ::=    	QName
    // [70]    	TypeName 	   ::=    	QName
    // [71] IntegerLiteral::=   	Digits
    // [72] DecimalLiteral     ::=   	("." Digits) | (Digits "." [0-9]*)	/* ws: explicit */
    // [73] DoubleLiteral::=   	(("." Digits) | (Digits ("." [0-9]*)?)) [eE] [+-]? Digits	/* ws: explicit */
    // [74]    StringLiteral::=   	('"' (EscapeQuot | [^"])* '"') | ("'" (EscapeApos | [^'])* "'")	/* ws: explicit */
    // [75] EscapeQuot::=   	'""'
    // [76] EscapeApos::=   	"''"
    // [77] Comment::=   	"(:" (CommentContents | Comment)* ":)"	/* ws: explicit */ /* gn: comments */

    // [78] QName::=   	[http://www.w3.org/TR/REC-xml-names/#NT-QName]Names	/* xgs: xml-version */
    //          [7]   	QName	        ::=   	PrefixedName | UnprefixedName
    //          [8]     PrefixedName    ::=   	Prefix ':' LocalPart
    //          [9]     UnprefixedName  ::=   	LocalPart
    //          [10]    Prefix	        ::=   	NCName
    //          [11]    LocalPart	    ::=   	NCName
    static readonly Parser<Char> NameChar =
        from name in Parse.LetterOrDigit.Or(Parse.Chars('_', '-', '.'))
        select name;

    static readonly Parser<QName> QName =
        from prefix in
            (from prefixname in NameChar.AtLeastOnce().Text()
             from separator in Parse.Char(':')
             select prefixname
             ).Optional()
        from local in Parse.LetterOrDigit.AtLeastOnce().Text()
        select new QName(local, prefix.IsDefined ? prefix.Get() : string.Empty);

    // [79] NCName::=   	[http://www.w3.org/TR/REC-xml-names/#NT-NCName]Names	/* xgs: xml-version */
    // [80] Char::=   	[http://www.w3.org/TR/REC-xml#NT-Char]XML	/* xgs: xml-version */
    // [81] Digits::=   	[0-9]+
    // [82] CommentContents::=   	(Char+ - (Char* ('(:' | ':)') Char*))
























    public static void ParseFromContent(string scriptContent)
    {
        string uncommentedScript = _Content.Parse(scriptContent);
        Logger.LogDebug(uncommentedScript);
        XpExpression parsed = XpExpressionTerm.Parse(uncommentedScript);
        Logger.LogDebug("---------- parsed ---------------");
        Logger.LogDebug(parsed.ToString());
    }

    public static void TestXpParser(string scriptContent)
    {

        string testScript01 = """
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
        string testScript02 = """
            not(gtin = ('44444444444442', '00000000000000','01111111111116','11111111111113','22222222222226','33333333333339','55555555555555','66666666666668','77777777777771','88888888888884','99999999999997')) and
            not(nextLowerLevelTradeItemInformation/childTradeItem/gtin = ('44444444444442', '00000000000000','01111111111116','11111111111113','22222222222226','33333333333339','55555555555555','66666666666668','77777777777771','88888888888884','99999999999997'))
            """;

        bool useParam = false;
        string toParse = useParam ? scriptContent : testScript01;

        ParseFromContent(toParse);
    }


}




/*
-----------------------------------------------------------------------------------------------------------------------------------------------
XPATH 3.1 grammar : 
https://www.w3.org/TR/xpath-3/#id-grammar
XPATH 3 / XQuery 3 functions :
https://www.w3.org/TR/xpath-functions-30/

[1]   	XPath	   ::=   	Expr	
[2]   	ParamList	   ::=   	Param ("," Param)*	
[3]   	Param	   ::=   	"$" EQName TypeDeclaration?	
[4]   	FunctionBody	   ::=   	EnclosedExpr	
[5]   	EnclosedExpr	   ::=   	"{" Expr? "}"	
[6]   	Expr	   ::=   	ExprSingle ("," ExprSingle)*	
[7]   	ExprSingle	   ::=   	ForExpr
| LetExpr
| QuantifiedExpr
| IfExpr
| OrExpr	
[8]   	ForExpr	   ::=   	SimpleForClause "return" ExprSingle	
[9]   	SimpleForClause	   ::=   	"for" SimpleForBinding ("," SimpleForBinding)*	
[10]   	SimpleForBinding	   ::=   	"$" VarName "in" ExprSingle	
[11]   	LetExpr	   ::=   	SimpleLetClause "return" ExprSingle	
[12]   	SimpleLetClause	   ::=   	"let" SimpleLetBinding ("," SimpleLetBinding)*	
[13]   	SimpleLetBinding	   ::=   	"$" VarName ":=" ExprSingle	
[14]   	QuantifiedExpr	   ::=   	("some" | "every") "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle	
[15]   	IfExpr	   ::=   	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle	
[16]   	OrExpr	   ::=   	AndExpr ( "or" AndExpr )*	
[17]   	AndExpr	   ::=   	ComparisonExpr ( "and" ComparisonExpr )*	
[18]   	ComparisonExpr	   ::=   	StringConcatExpr ( (ValueComp
| GeneralComp
| NodeComp) StringConcatExpr )?	
[19]   	StringConcatExpr	   ::=   	RangeExpr ( "||" RangeExpr )*	
[20]   	RangeExpr	   ::=   	AdditiveExpr ( "to" AdditiveExpr )?	
[21]   	AdditiveExpr	   ::=   	MultiplicativeExpr ( ("+" | "-") MultiplicativeExpr )*	
[22]   	MultiplicativeExpr	   ::=   	UnionExpr ( ("*" | "div" | "idiv" | "mod") UnionExpr )*	
[23]   	UnionExpr	   ::=   	IntersectExceptExpr ( ("union" | "|") IntersectExceptExpr )*	
[24]   	IntersectExceptExpr	   ::=   	InstanceofExpr ( ("intersect" | "except") InstanceofExpr )*	
[25]   	InstanceofExpr	   ::=   	TreatExpr ( "instance" "of" SequenceType )?	
[26]   	TreatExpr	   ::=   	CastableExpr ( "treat" "as" SequenceType )?	
[27]   	CastableExpr	   ::=   	CastExpr ( "castable" "as" SingleType )?	
[28]   	CastExpr	   ::=   	ArrowExpr ( "cast" "as" SingleType )?	
[29]   	ArrowExpr	   ::=   	UnaryExpr ( "=>" ArrowFunctionSpecifier ArgumentList )*	
[30]   	UnaryExpr	   ::=   	("-" | "+")* ValueExpr	
[31]   	ValueExpr	   ::=   	SimpleMapExpr	
[32]   	GeneralComp	   ::=   	"=" | "!=" | "<" | "<=" | ">" | ">="	
[33]   	ValueComp	   ::=   	"eq" | "ne" | "lt" | "le" | "gt" | "ge"	
[34]   	NodeComp	   ::=   	"is" | "<<" | ">>"	
[35]   	SimpleMapExpr	   ::=   	PathExpr ("!" PathExpr)*	
[36]   	PathExpr	   ::=   	("/" RelativePathExpr?)
| ("//" RelativePathExpr)
| RelativePathExpr	/* xgc: leading-lone-slash */
/*
[37] RelativePathExpr::=   	StepExpr(("/" | "//") StepExpr)*
[38] StepExpr       ::=   	PostfixExpr | AxisStep
[39] AxisStep	   ::=   	(ReverseStep | ForwardStep) PredicateList
[40] ForwardStep    ::=   	(ForwardAxis NodeTest) | AbbrevForwardStep
[41] ForwardAxis	   ::=   	("child" "::")
| ("descendant" "::")
| ("attribute" "::")
| ("self" "::")
| ("descendant-or-self" "::")
| ("following-sibling" "::")
| ("following" "::")
| ("namespace" "::")	
[42] AbbrevForwardStep::=   	"@"? NodeTest
[43]    ReverseStep::=   	(ReverseAxis NodeTest) | AbbrevReverseStep
[44] ReverseAxis    ::=   	("parent" "::")
| ("ancestor" "::")
| ("preceding-sibling" "::")
| ("preceding" "::")
| ("ancestor-or-self" "::")	
[45] AbbrevReverseStep::=   	".."	
[46] NodeTest::=   	KindTest | NameTest
[47] NameTest       ::=   	EQName | Wildcard
[48] Wildcard	   ::=   	"*"
| (NCName ":*")
| ("*:" NCName)
| (BracedURILiteral "*")	/* ws: explicit */
/*
[49] PostfixExpr::=   	PrimaryExpr(Predicate | ArgumentList | Lookup)*
[50] ArgumentList       ::=   	"(" (Argument ("," Argument)*)? ")"	
[51] PredicateList::=   	Predicate*
[52] Predicate      ::=   	"[" Expr "]"	
[53] Lookup::= "?" KeySpecifier
[54] KeySpecifier	   ::=   	NCName | IntegerLiteral | ParenthesizedExpr | "*"	
[55]    ArrowFunctionSpecifier     ::=      EQName | VarRef | ParenthesizedExpr
[56]    PrimaryExpr::= Literal
| VarRef
| ParenthesizedExpr
| ContextItemExpr
| FunctionCall
| FunctionItemExpr
| MapConstructor
| ArrayConstructor
| UnaryLookup
[57]    Literal::= NumericLiteral | StringLiteral
[58]    NumericLiteral::= IntegerLiteral | DecimalLiteral | DoubleLiteral
[59]    VarRef::= "$" VarName
[60] VarName	   ::=   	EQName
[61] ParenthesizedExpr	   ::=   	"(" Expr? ")"	
[62]    ContextItemExpr    ::=      "."
[63]    FunctionCall::= EQName ArgumentList	/* xgc: reserved-function-names */
/* gn: parens */
/*
[64] Argument	   ::=   	ExprSingle | ArgumentPlaceholder
[65] ArgumentPlaceholder	   ::=   	"?"	
[66]    FunctionItemExpr       ::=      NamedFunctionRef | InlineFunctionExpr
[67]    NamedFunctionRef::= EQName "#" IntegerLiteral	/* xgc: reserved-function-names */
/*
[68] InlineFunctionExpr	   ::=   	"function" "(" ParamList? ")" ("as" SequenceType)? FunctionBody
[69]    MapConstructor::=   	"map" "{" (MapConstructorEntry ("," MapConstructorEntry)*)? "}"	
[70] MapConstructorEntry::=   	MapKeyExpr ":" MapValueExpr
[71] MapKeyExpr     ::=   	ExprSingle
[72] MapValueExpr	   ::=   	ExprSingle
[73] ArrayConstructor	   ::=   	SquareArrayConstructor | CurlyArrayConstructor
[74] SquareArrayConstructor	   ::=   	"[" (ExprSingle ("," ExprSingle)*)? "]"	
[75] CurlyArrayConstructor::=   	"array" EnclosedExpr
[76] UnaryLookup    ::=   	"?" KeySpecifier
[77] SingleType	   ::=   	SimpleTypeName "?"?	
[78] TypeDeclaration::= "as" SequenceType
[79] SequenceType	   ::=   	("empty-sequence" "(" ")")
| (ItemType OccurrenceIndicator?)	
[80] OccurrenceIndicator::=   	"?" | "*" | "+"	/* xgc: occurrence-indicators */
/*
[81] ItemType::=   	KindTest | ("item" "(" ")") | FunctionTest | MapTest | ArrayTest | AtomicOrUnionType | ParenthesizedItemType
[82] AtomicOrUnionType      ::=   	EQName
[83] KindTest	   ::=   	DocumentTest
| ElementTest
| AttributeTest
| SchemaElementTest
| SchemaAttributeTest
| PITest
| CommentTest
| TextTest
| NamespaceNodeTest
| AnyKindTest
[84] AnyKindTest	   ::=   	"node" "(" ")"	
[85] DocumentTest::= "document-node" "(" (ElementTest | SchemaElementTest)? ")"	
[86] TextTest::=   	"text" "(" ")"	
[87] CommentTest::=   	"comment" "(" ")"	
[88] NamespaceNodeTest::=   	"namespace-node" "(" ")"	
[89] PITest::=   	"processing-instruction" "(" (NCName | StringLiteral)? ")"	
[90] AttributeTest::=   	"attribute" "(" (AttribNameOrWildcard ("," TypeName)?)? ")"	
[91] AttribNameOrWildcard::=   	AttributeName | "*"	
[92] SchemaAttributeTest::=   	"schema-attribute" "(" AttributeDeclaration ")"	
[93] AttributeDeclaration::=   	AttributeName
[94] ElementTest    ::=   	"element" "(" (ElementNameOrWildcard ("," TypeName "?"?)?)? ")"	
[95] ElementNameOrWildcard::=   	ElementName | "*"	
[96] SchemaElementTest::=   	"schema-element" "(" ElementDeclaration ")"	
[97] ElementDeclaration::=   	ElementName
[98] AttributeName      ::=   	EQName
[99] ElementName	   ::=   	EQName
[100] SimpleTypeName	   ::=   	TypeName
[101] TypeName	   ::=   	EQName
[102] FunctionTest	   ::=   	AnyFunctionTest
| TypedFunctionTest
[103] AnyFunctionTest	   ::=   	"function" "(" "*" ")"	
[104] TypedFunctionTest::= "function" "(" (SequenceType ("," SequenceType)*)? ")" "as" SequenceType
[105] MapTest    ::=   	AnyMapTest | TypedMapTest
[106] AnyMapTest	   ::=   	"map" "(" "*" ")"	
[107] TypedMapTest::= "map" "(" AtomicOrUnionType "," SequenceType ")"	
[108]       ArrayTest      ::=      AnyArrayTest | TypedArrayTest
[109]       AnyArrayTest::= "array" "(" "*" ")"	
[110] TypedArrayTest::= "array" "(" SequenceType ")"	
[111] ParenthesizedItemType::= "(" ItemType ")"	
[112]       EQName     ::=      QName | URIQualifiedName





-----------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------
XPATH 2.0 grammar : 


-----------------------------------------------------------------------------------------------------------------------------------------------
grammar xpath;


XPath 1.0 grammar.Should conform to the official spec at
http://www.w3.org/TR/1999/REC-xpath-19991116. The grammar
rules have been kept as close as possible to those in the
spec, but some adjustmewnts were unavoidable.These were
mainly removing left recursion (spec seems to be based on
LR), and to deal with the double nature of the '*' token
(node wildcard and multiplication operator). See also
section 3.7 in the spec.These rule changes should make
no difference to the strings accepted by the grammar.
Written by Jan-Willem van den Broek
Version 1.0
Do with this code as you will.


    Ported to Antlr4 by Tom Everett <tom@khubla.com>



main  :  expr
  ;

locationPath 
  :  relativeLocationPath
  |  absoluteLocationPathNoroot
  ;

absoluteLocationPathNoroot
  :  '/' relativeLocationPath
  |  '//' relativeLocationPath
  ;

relativeLocationPath
  :  step(('/'|'//') step)*
  ;

step  :  axisSpecifier nodeTest predicate*
  |  abbreviatedStep
  ;

axisSpecifier
  :  AxisName '::'
  |  '@'?
  ;

nodeTest:  nameTest
  |  NodeType '(' ')'
  |  'processing-instruction' '(' Literal ')'
  ;

predicate
  :  '[' expr ']'
  ;

abbreviatedStep
  :  '.'
  |  '..'
  ;

expr  :  orExpr
  ;

primaryExpr
  :  variableReference
  |  '(' expr ')'
  |  Literal
  |  Number  
  |  functionCall
  ;

functionCall
  :  functionName '(' (expr ( ',' expr )* )? ')'
  ;

unionExprNoRoot
  :  pathExprNoRoot('|' unionExprNoRoot)?
  |  '/' '|' unionExprNoRoot
  ;

pathExprNoRoot
  :  locationPath
  |  filterExpr(('/'|'//') relativeLocationPath)?
  ;

filterExpr
  :  primaryExpr predicate*
  ;

orExpr  :  andExpr('or' andExpr)*
  ;

andExpr  :  equalityExpr('and' equalityExpr)*
  ;

equalityExpr
  :  relationalExpr(('='|'!=') relationalExpr)*
  ;

relationalExpr
  :  additiveExpr(('<'|'>'|'<='|'>=') additiveExpr)*
  ;

additiveExpr
  :  multiplicativeExpr(('+'|'-') multiplicativeExpr)*
  ;

multiplicativeExpr
  :  unaryExprNoRoot(('*'|'div'|'mod') multiplicativeExpr)?
  |  '/' (('div'|'mod') multiplicativeExpr)?
  ;

unaryExprNoRoot
  :  '-'* unionExprNoRoot
;

qName  :  nCName(':' nCName)?
  ;

functionName
  :  qName  // Does not match nodeType, as per spec.
  ;

variableReference
  :  '$' qName
  ;

nameTest:  '*'
  |  nCName ':' '*'
  |  qName
  ;

nCName  :  NCName
  |  AxisName
  ;

NodeType:  'comment'
  |  'text'
  |  'processing-instruction'
  |  'node'
  ;

Number  :  Digits('.' Digits?)?
  |  '.' Digits
  ;

fragment
Digits  :  ('0'..'9')+
  ;

AxisName:  'ancestor'
  |  'ancestor-or-self'
  |  'attribute'
  |  'child'
  |  'descendant'
  |  'descendant-or-self'
  |  'following'
  |  'following-sibling'
  |  'namespace'
  |  'parent'
  |  'preceding'
  |  'preceding-sibling'
  |  'self'
  ;


  PATHSEP 
       :'/';
  ABRPATH   
       : '//';
  LPAR   
       : '(';
  RPAR   
       : ')';
  LBRAC   
       :  '[';
  RBRAC   
       :  ']';
  MINUS   
       :  '-';
  PLUS   
       :  '+';
  DOT   
       :  '.';
  MUL   
       : '*';
  DOTDOT   
       :  '..';
  AT   
       : '@';
  COMMA  
       : ',';
  PIPE   
       :  '|';
  LESS   
       :  '<';
  MORE_ 
       :  '>';
  LE   
       :  '<=';
  GE   
       :  '>=';
  COLON   
       :  ':';
  CC   
       :  '::';
  APOS   
       :  '\'';
  QUOT   
       :  '\"';

Literal  :  '"' ~'"'* '"'
  |  '\'' ~'\''* '\''
  ;

Whitespace
  :  (' '|'\t'|'\n'|'\r')+ ->skip
  ;

NCName  :  NCNameStartChar NCNameChar*
  ;

fragment
NCNameStartChar
  :  'A'..'Z'
  |   '_'
  |  'a'..'z'
  |  '\u00C0'..'\u00D6'
  |  '\u00D8'..'\u00F6'
  |  '\u00F8'..'\u02FF'
  |  '\u0370'..'\u037D'
  |  '\u037F'..'\u1FFF'
  |  '\u200C'..'\u200D'
  |  '\u2070'..'\u218F'
  |  '\u2C00'..'\u2FEF'
  |  '\u3001'..'\uD7FF'
  |  '\uF900'..'\uFDCF'
  |  '\uFDF0'..'\uFFFD'
// Unfortunately, java escapes can't handle this conveniently,
// as they're limited to 4 hex digits. TODO.
//  |  '\U010000'..'\U0EFFFF'
  ;

fragment
NCNameChar
  :  NCNameStartChar | '-' | '.' | '0'..'9'
  |  '\u00B7' | '\u0300'..'\u036F'
  |  '\u203F'..'\u2040'
  ;

*/