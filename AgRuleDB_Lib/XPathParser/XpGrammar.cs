using Sprache;
using System.Linq;
using System;
using System.Linq.Expressions;
using System.Xml.Linq;
using Xunit.Abstractions;
using static AgRuleDB_Lib.RuleDBService;

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


    // [1] XPath::=   	Expr
    // [2] ParamList      ::=   	Param ("," Param)*	
    // [3] Param::=   	"$" EQName TypeDeclaration?
    // [4] FunctionBody::=   	EnclosedExpr

    // [5] EnclosedExpr::=   	"{" Expr? "}"
    static readonly Parser<EnclosedExpr> EncloseExpr =
        from _open in Parse.Char('{').Tokenize()
        from expr in Expr.Optional()
        from _close in Parse.Char('}').Tokenize()
        select new EnclosedExpr(expr.GetOrDefault());


    // [6] Expr	   ::=   	ExprSingle ("," ExprSingle)* 
    static readonly Parser<Expr> Expr =
        from first in ExprSingle
        from others in
            (from _ in Parse.Char(',').Tokenize()
             from exprsingl in ExprSingle
             select exprsingl).Many()
        select new Expr(first, others);

    // [7] ExprSingle	   ::=   	ForExpr | LetExpr | QuantifiedExpr| IfExpr| OrExpr
    static readonly Parser<ExprSingle> ExprSingle =
        ForExpr
        .Or<ExprSingle>(IfExpr)
        .Or(LetExpr);

    // [8] ForExpr	   ::=   	SimpleForClause "return" ExprSingle
    // [9] SimpleForClause::=   	"for" SimpleForBinding("," SimpleForBinding)*
    static readonly Parser<ExprSingle> ForExpr =
        from _for in Parse.String("for").Tokenize()
        from firstforbindings in Parse.Ref(() => InClause)
        from otherforbindings in
            (from _comma in Parse.Char(',').Tokenize()
             from nextforbinding in Parse.Ref(() => InClause)
             select nextforbinding).Many()
        from _return in Parse.String("return").Tokenize()
        from forexpr in ExprSingle
        select new ForExpr(firstforbindings, otherforbindings, forexpr);


    // [10]   	SimpleForBinding	   ::=   	"$" VarName "in" ExprSingle  --> renamed InClause to serve in [14] QuantifierExpr
    static readonly Parser<InClause> InClause =
        from _dollar in Parse.Char('$')
        from name in EQName // [60] VarName = EQName    -  see [112] for EQName
        from _in in Parse.String("in").Token
        from expr in ExprSingle
        select new InClause(name, expr);

    // [11] LetExpr                 ::=   	SimpleLetClause "return" ExprSingle
    // [12] SimpleLetClause         ::=   	"let" SimpleLetBinding("," SimpleLetBinding)*
    static readonly Parser<LetExpr> LetExpr =
        from _let in Parse.String("let").Tokenize()
        from bindings in SimpleLetBinding.Many()
        from _return in Parse.String("return").Tokenize()
        from returnexpr in ExprSingle
        select new LetExpr(bindings, returnexpr);
    
    // [13] SimpleLetBinding        ::=   	"$" VarName ":=" ExprSingle
    static readonly Parser<SimpleLetBinding> SimpleLetBinding =
        from _dollar in Parse.Char('$')
        from name in EQName // [60] VarName = EQName    -  see [112] for EQName
        from _collonequal in Parse.String(":=").Token
        from expr in ExprSingle
        select new SimpleLetBinding(name, expr);

    // [14] QuantifiedExpr          ::=   	("some" | "every") "$" VarName "in" ExprSingle("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle
    static readonly Parser<QuantifiedExpr> QuantifiedExpr =
        from quantifier in Parse.String("some").Or(Parse.String("every")).Tokenize().Text()
        from bindings in InClause.Many()
        from _satisfies in Parse.String("satisfies").Tokenize()
        from satisfyExpr in ExprSingle
        select new QuantifiedExpr(quantifier, bindings, satisfyExpr);

    // [15] IfExpr                  ::=   	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
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