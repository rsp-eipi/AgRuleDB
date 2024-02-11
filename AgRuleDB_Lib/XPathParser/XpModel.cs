using Sprache;
using System.Linq.Expressions;
using System.Security.AccessControl;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace AgRuleDB_Lib.XPathParser;


public abstract class ExprBase { }


// [1]    	XPath 	   ::=    	Expr
// [2]    	Expr 	   ::=    	ExprSingle ("," ExprSingle)*
public class Expr(ExprSingle first, IEnumerable<ExprSingle> tail) : ExprBase 
{
    public List<ExprSingle> Exprs { get; set; } = [first, .. tail];    
}

// [3]    	ExprSingle 	   ::=    	ForExpr | QuantifiedExpr | IfExpr | OrExpr
public abstract class ExprSingle : ExprBase { }

// [4]    	ForExpr 	   ::=    	SimpleForClause "return" ExprSingle
// [5]    	SimpleForClause::=    	"for" "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)*
public class ForExpr : ExprSingle
{
    public IEnumerable<InClause> ForClauses { get; init; }
    public ExprSingle ForExpression { get; init; }
    public ForExpr(IEnumerable<InClause> forClauses, ExprSingle forExpr)
    {
        ForClauses = forClauses;
        ForExpression = forExpr;
    }
}

public class InClause(string varName, ExprSingle exprSingle)
{
    public string VarName { get; init; } = varName;
    public ExprSingle ExprSingle { get; init; } = exprSingle;
}


// [6]    	QuantifiedExpr 	   ::=    	("some" | "every") "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle
public enum Quantifier { some, every }
public class QuantifiedExpr : ExprSingle
{
    public Quantifier Quantifier { get; init; }
    public IEnumerable<InClause> InClauses { get; init; }
    public ExprSingle SatisfyExpr { get; init; }
    public QuantifiedExpr(string quantifier, IEnumerable<InClause> inClauses, ExprSingle satisfyExpr)
    {
        Quantifier = Enum.Parse<Quantifier>(quantifier);
        InClauses = inClauses;
        SatisfyExpr = satisfyExpr;
    }
}

// [7]    	IfExpr 	   ::=    	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
public class IfExpr(Expr testExpr, ExprSingle thenExpr, ExprSingle elseExpr) : ExprSingle
{
    public Expr TestExpr { get; init; } = testExpr;
    public ExprSingle ThenExpr { get; init; } = thenExpr;
    public ExprSingle ElseExpr { get; init; } = elseExpr;
}




public enum BinaryOperator { Or, And, Concat, To, Add, Sub, Times, Div, IDiv, mod, union, intersect, except }

public class BinaryExpr(ExprSingle left, BinaryOperator op, ExprSingle right) : ExprSingle
{
    public ExprSingle Left { get; init; } = left;
    public BinaryOperator op { get; init; } = op;    
    public ExprSingle Right { get; init; } = right;

    public static ExprSingle BuildFromSequence(ExprSingle left, IEnumerable<(BinaryOperator op, ExprSingle right)> rights)
    {
        ExprSingle currentLeft = left;        
        foreach ((BinaryOperator op, ExprSingle right) right in rights)        
            currentLeft = new BinaryExpr(currentLeft, right.op, right.right);
        return currentLeft;
    }
}


// [8]    	OrExpr 	   ::=    	AndExpr ( "or" AndExpr )*
public class OrExpr : ExprSingle
{
    public OrExpr(ExprSingle left, IEnumerable<(BinaryOperator op, ExprSingle right)> rights)
    {
        
    }
}

//// [9]    	AndExpr 	   ::=    	ComparisonExpr ( "and" ComparisonExpr )*
//public class AndExpr(IEnumerable<ExprSingle> exprs) : BinaryExprSequence(BinaryOperator.And, exprs) { }

//// [10]    	ComparisonExpr 	   ::=    	RangeExpr ( (ValueComp | GeneralComp | NodeComp) RangeExpr )?
//public class ComparisonExpr(ExprSingle left, IEnumerable<(BinaryOperator op, ExprSingle right)> rights) : BinaryExprSequence(left, rights) { }

//// [11]    	RangeExpr 	   ::=    	AdditiveExpr ( "to" AdditiveExpr )?
//public class RangeExpr(ExprSingle left, ExprSingle right) : BinaryExprPair(BinaryOperator.To, left, right) { }

//// [12]    	AdditiveExpr 	   ::=    	MultiplicativeExpr ( ("+" | "-") MultiplicativeExpr )*
//public class AdditiveExpr(ExprSingle left, IEnumerable<(BinaryOperator op, ExprSingle right)> rights) : BinaryExprSequence(left, rights) { }

//// [13]    	MultiplicativeExpr 	   ::=    	UnionExpr ( ("*" | "div" | "idiv" | "mod") UnionExpr )*
//public class MultiplicativeExpr(BinaryOperator op, IEnumerable<ExprSingle> exprs) : BinaryExprSequence(op, exprs) { }

//// [14]    	UnionExpr 	   ::=    	IntersectExceptExpr ( ("union" | "|") IntersectExceptExpr )*
//public class UnionExpr(IEnumerable<ExprSingle> exprs) : BinaryExprSequence(BinaryOperator.union, exprs) { }

//// [15]    	IntersectExceptExpr 	   ::=    	InstanceofExpr ( ("intersect" | "except") InstanceofExpr )*
//public class IntersectExpr(IEnumerable<ExprSingle> exprs) : BinaryExprSequence(BinaryOperator.intersect, exprs) { }
//public class ExceptExpr(IEnumerable<ExprSingle> exprs) : BinaryExprSequence(BinaryOperator.except, exprs) { }

// -------------- type expressions

public abstract class xpType { }
public class SequenceType(ExprSingle qname) : xpType
{
    ExprSingle QName { get; init; } = qname;
}

public class SingleType(ExprSingle qname) : xpType
{
    ExprSingle QName { get; init; } = qname;
}



// [16]    	InstanceofExpr 	   ::=    	TreatExpr ( "instance" "of" SequenceType )?
public class InstanceofExpr(ExprSingle expr, SequenceType seqtype)
{
    public ExprSingle Expr { get; set; } = expr;
    public SequenceType SequenceType { get; set; } = seqtype;
}
// [17]    	TreatExpr 	   ::=    	CastableExpr ( "treat" "as" SequenceType )?
public class TreatExpr(ExprSingle expr, SequenceType seqtype)
{
    public ExprSingle Expr { get; set; } = expr;
    public SequenceType SequenceType { get; set; } = seqtype;
}

// [18]    	CastableExpr 	   ::=    	CastExpr ( "castable" "as" SingleType )?
public class CastableExpr(ExprSingle expr, SingleType singletype)
{
    public ExprSingle Expr { get; set; } = expr;
    public SingleType SingleType { get; set; } = singletype;
}

// [19]    	CastExpr 	   ::=    	UnaryExpr ( "cast" "as" SingleType )?
public class CastExpr(ExprSingle expr, SingleType singletype)
{
    public ExprSingle Expr { get; set; } = expr;
    public SingleType SingleType { get; set; } = singletype;
}

// [20]    	UnaryExpr 	   ::=    	("-" | "+")* ValueExpr
public enum UnaryOperator { Plus, Minus }
public class UnaryExpression : ExprSingle
{
    public UnaryOperator Op { get; set; }
    public ExprSingle Expr { get; set; }

    public UnaryExpression(string op, ExprSingle expr)
    {
        Op = op switch
        {
            "+" => UnaryOperator.Plus,
            "-" => UnaryOperator.Minus,
            _ => throw new Exception($"Unknown unary operator {op}")
        };
        Expr = expr;
    }    
}
// [21]    	ValueExpr 	   ::=    	PathExpr
// [22]    	GeneralComp 	   ::=    	"=" | "!=" | "<" | "<=" | ">" | ">="
// [23]    	ValueComp 	   ::=    	"eq" | "ne" | "lt" | "le" | "gt" | "ge"
// [24]    	NodeComp 	   ::=    	"is" | "<<" | ">>"

// [25]    	PathExpr 	   ::=    	("/" RelativePathExpr?) | ("//" RelativePathExpr) | RelativePathExpr 	/* xgs: leading-lone-slash */
// [26]    	RelativePathExpr 	   ::=    	StepExpr (("/" | "//") StepExpr)*

public enum PathSeparator { None, Slash, DoubleSlash }

public class PathExpr(IEnumerable<PathStep> stepExprs)
{
    public IEnumerable<PathStep> PathSteps { get; set; } = stepExprs;

    public override string ToString() => $"\n{{\n {string.Join('\n', stepExprs)} \n}}";    
}
// [27]    	StepExpr 	   ::=    	FilterExpr | AxisStep
public enum StepDirection { Reverse, Forward }
public class PathStep(PathSeparator separator, string axis, QName? name, IEnumerable<FilterExpr> filters)
{
    public PathSeparator PathSeparator { get; set; } = separator;
    public string Axis { get; set; } = axis;
    public QName? Name { get; set; } = name;

    public IEnumerable<FilterExpr> Filters { get; set; } = filters;
    public override string ToString() => $"\t{PathSeparator}\t{Axis} \t\t\t\t {Name}";
        
}



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

public class FilterExpr(string s) : ExprSingle
{
    public string Expression { get; set; } = s;
}

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
public class QName(string prefix, string name) : ExprSingle
{
    public string Prefix { get; set; } = prefix;
    public string Name { get; set; } = name;

    public override string ToString() => string.IsNullOrEmpty(prefix) ? $"{Name}" : $"{Prefix}:{Name}";

}
// [79] NCName::=   	[http://www.w3.org/TR/REC-xml-names/#NT-NCName]Names	/* xgs: xml-version */
// [80] Char::=   	[http://www.w3.org/TR/REC-xml#NT-Char]XML	/* xgs: xml-version */
// [81] Digits::=   	[0-9]+
// [82] CommentContents::=   	(Char+ - (Char* ('(:' | ':)') Char*))




public abstract class XpEntity
{
}

public class XpExpression : XpEntity { }

public class XpIdentifier : XpExpression
{
    public string Name { get; }
    public XpIdentifier(string name)
    {
        Name = name.CanonizeIdentifier();
    }
    public XpIdentifier(XpIdentifier identifier)
    {
        Name = identifier.Name.CanonizeIdentifier();
    }
    public override string ToString() => Name;
}


public class XpParenthesisExpression : XpExpression
{
    public IReadOnlyList<XpExpression> Expression { get; }

    public XpParenthesisExpression(IReadOnlyList<XpExpression> expression)
    {
        Expression = expression;
    }

    public override string ToString() => $"( {String.Join(',', Expression)} )";
}


public class XpBinaryOperation : XpExpression
{
    XpExpression Left { get; }
    XpExpression Right { get; }
    string Op { get; }

    public XpBinaryOperation(XpExpression left, string op, XpExpression right)
    {
        Left = left;
        Right = right;
        Op = op.Trim().ToLower() switch
        {
            "=" => "==",
            "<>" => "!=",
            "le" => "||",
            "or" => "||",            
            "and" => "&&",
            "et" => "&&",
            _ => op
        };
    }

    public override string ToString() => Op switch
    {
        "[=" => $"{Left}.StartsWith({Right})",
        _ => $"{Left} {Op} {Right}"
    };
}



public class XpFunctionCallExpression : XpExpression
{
    string FunctionName { get; }
    IReadOnlyCollection<XpExpression> Arguments { get; }

    public XpFunctionCallExpression(XpIdentifier functionName, IReadOnlyCollection<XpExpression> arguments)
    {
        FunctionName = functionName.Name;
        Arguments = arguments;
        FunctionDictionary.Add(FunctionName);
    }

    public override string ToString() => $"{FunctionName}({string.Join(',', Arguments)})";   
}

public class XpIfThenElse : XpExpression
{
    XpExpression Condition { get; }
    XpExpression ThenExpression { get; }
    XpExpression? ElseExpression { get; }    
    public XpIfThenElse(XpExpression condition, XpExpression thenExpression, XpExpression? elseExpression = null)
    {
        Condition = condition;
        ThenExpression = thenExpression;        
        ElseExpression = elseExpression;
    }

    public override string ToString()
    {
        string s = $"{Tab.TabsNl}if ({Condition}){Tab.TabsNl}{{{Tab.Push()}{Tab.TabsNl}{ThenExpression}{Tab.Pop()}";        
        if (ElseExpression is not null)
            s += $"{Tab.TabsNl}}}{Tab.TabsNl}else{Tab.TabsNl}{{{Tab.Push()}{Tab.TabsNl}{ElseExpression}{Tab.Pop()}";
        s += $"{Tab.TabsNl}}}";
        return s;
    }
}


public class XpBinaryOperator : XpExpression
{
    XpExpression Left { get; }
    XpExpression Right { get; }
    string Op { get; }

    public XpBinaryOperator(XpExpression left, string op, XpExpression right)
    {
        Left = left;
        Right = right;
        Op = op.Trim().ToLower() switch
        {
            "=" => "==",
            "<>" => "!=",
            "ou" => "||",
            "or" => "||",
            "and" => "&&",
            "et" => "&&",
            _ => op
        };
    }

    public override string ToString() => Op switch
    {
        "[=" => $"{Left}.StartsWith({Right})",
        _ => $"{Left} {Op} {Right}"
    };
}

