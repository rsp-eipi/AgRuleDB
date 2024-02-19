using Newtonsoft.Json.Linq;
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
public class ExprSequence(IEnumerable<Expr> exprs)  : Expr
{
    public IEnumerable<Expr> Exprs { get; init; } = exprs;
    public override string ToString() => Exprs.Count() > 0 ? $"[{String.Join(", ", Exprs)}]" : "[]";
}


// [3]    	ExprSingle 	   ::=    	ForExpr | QuantifiedExpr | IfExpr | OrExpr
public abstract class Expr { }


public class VarBinding(VarName varName, Expr expr)
{
    public VarName VarName { get; set; } = varName;
    public Expr Expr { get; set; } = expr;
    public override string ToString() => $"Bind({VarName}, {Expr})";
}


// [4]    	ForExpr 	   ::=    	SimpleForClause "return" ExprSingle
// [5]    	SimpleForClause::=    	"for" "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)*
public class ForExpr(IEnumerable<VarBinding> bindings, Expr returnExpr) : Expr
{
    public IEnumerable<VarBinding> Bindings { get; init; } = bindings;
    public Expr ReturnExpr { get; init; } = returnExpr;

    public override string ToString() => $"ForExpr([{String.Join(',', Bindings)}], {ReturnExpr})";
}

// [6]    	QuantifiedExpr 	   ::=    	("some" | "every") "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle
public enum Quantifier { All, Any }
public class QuantifiedExpr(string quantifier, IEnumerable<VarBinding> varBindings, Expr satisfyExpr) : Expr
{
    public Quantifier Quantifier { get; init; } = StringToQuantifier(quantifier);
    public IEnumerable<VarBinding> VarBindings { get; init; } = varBindings;
    public Expr SatisfyExpr { get; init; } = satisfyExpr;

    public static Quantifier StringToQuantifier(string s) => s switch
    {
        "every" => Quantifier.All,
        "some" => Quantifier.Any,
        _ => throw new Exception($"Unknown quantifier {s}")
    };
    public override string ToString() => $"{Quantifier}({String.Join(".", VarBindings)}.Eval({SatisfyExpr}))";
}

// [7]    	IfExpr 	   ::=    	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
public class IfExpr(ParenthesizedExpr condition, Expr thenExpr, Expr elseExpr) : Expr
{
    public ParenthesizedExpr Condition { get; init; } = condition;
    public Expr ThenExpr { get; init; } = thenExpr;
    public Expr ElseExpr { get; init; } = elseExpr;

    public override string ToString() => $"""
            ({Condition})
            {Tab.Push()}? {ThenExpr}
            {Tab.TabsNl}: {ElseExpr}{Tab.PopNl()}
        """;
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



// [16]    	InstanceofExpr 	   ::=    	TreatExpr ( "instance" "of" SequenceType )?
// [17]    	TreatExpr 	   ::=    	CastableExpr ( "treat" "as" SequenceType )?

// [18]    	CastableExpr 	   ::=    	CastExpr ( "castable" "as" SingleType )?

// [19]    	CastExpr 	   ::=    	UnaryExpr ( "cast" "as" SingleType )?

// [20]    	UnaryExpr 	   ::=    	("-" | "+")* ValueExpr
public enum UnaryOperator { Plus, Minus }
public class UnaryExpression : Expr
{
    public UnaryOperator Op { get; set; }
    public Expr Expr { get; set; }

    public UnaryExpression(string op, Expr expr)
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
public enum BinOp { GenEqual, GenNotEqual, GenLessThan, GenLessThanOrEqual, GenGreaterThan, GenGreaterThanOrEqual, 
                    ValEqual, ValNotEqual, ValLessThan, ValLessThanOrEqual, ValGreaterThan, ValGreaterThanOrEqual,
                    Is,  NodeBefore, NodeAfter, And, Or,
                    Add, Sub, Times, Div, IDiv, Mod, 
                    Union, Intersect, Except, Comma, Concat, To}

public class BinaryExpr(Expr left, string op, Expr right) : Expr
{
    public Expr Left { get; init; } = left;
    public BinOp Op { get; init; } = XpUtil.StringToBinaryOperator(op);
    public Expr Right { get; init; } = right;   
    public override string ToString() => $"Binary({Left}, BinOp.{Op}, {Right})";

}




// [25]    	PathExpr 	   ::=    	("/" RelativePathExpr?) | ("//" RelativePathExpr) | RelativePathExpr 	/* xgs: leading-lone-slash */
// [26]    	RelativePathExpr 	   ::=    	StepExpr (("/" | "//") StepExpr)*

public enum PathSeparator { None, Slash, DoubleSlash }

public class PathExpr(IEnumerable<PathStep> stepExprs) : Expr
{
    public IEnumerable<PathStep> PathSteps { get; set; } = stepExprs;

    public string HandleFirst() =>
        PathSteps.First().PathSeparator == PathSeparator.Slash ? "Root()" : "Context()";

    public override string ToString() => $"{HandleFirst()}.{string.Join('.', PathSteps)}";
}

public enum Axis { None, Child, Descendant, Attribute, Self, DescendantOrSelf, FollowingSibling, Following, Namespace, 
    Attrib, Parent, Ancestor, PrecedingSibling, Preceding, AncestorOrSelf }

// [27]    	StepExpr 	   ::=    	FilterExpr | AxisStep
public class PathStep(PathSeparator separator, string axis, QName? name, IEnumerable<FilterExpr> filters)
{
    public PathSeparator PathSeparator { get; set; } = separator;
    public Axis Axis { get; set; } = XpUtil.StringToAxis(axis);
    public QName? Name { get; set; } = name;

    public IEnumerable<FilterExpr> Filters { get; set; } = filters;

    public static string PathSeparatorToString(PathSeparator sep)
        => sep switch
        {
            PathSeparator.None => String.Empty,
            PathSeparator.Slash => "/",
            PathSeparator.DoubleSlash => "//",
            _ => throw new Exception("Unknown separator")
        };

    

    public string GetAxis() =>
        Axis == Axis.None
            ? PathSeparator switch {
                PathSeparator.None          => $"""Move(Axis.Child, "{Name}")""",
                PathSeparator.Slash         => $"""Move(Axis.Child, "{Name}")""",
                PathSeparator.DoubleSlash   => $"""Move(Axis.DescendantOrSelf, "{Name}")""",
                _ => throw new Exception("Unknown path separator")
            }
            : $"""Move(Axis.{Axis}, "{Name}")""";
    

    public override string ToString() => $"{GetAxis()}{String.Concat(Filters)}";
        
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
// [39]    	PredicateList 	   ::=    	Predicate*
// [40]    	Predicate 	   ::=    	"// [" Expr "]"
public class FilterExpr(Expr expr) : Expr
{
    public Expr Expression { get; set; } = expr;
    public override string ToString() => $".Filter({Expression})";
}


// [41]    	PrimaryExpr 	   ::=    	Literal | VarRef | ParenthesizedExpr | ContextItemExpr | FunctionCall
// [42]    	Literal 	   ::=    	NumericLiteral | StringLiteral

public abstract class Literal<TValue>(TValue value) : Expr
{
    public TValue Value { get; } = value;

    public T GetValue<T>() => (T)Convert.ChangeType(Value, typeof(T))!;
}

// "foo bar"
public class StringLiteral(string value) : Literal<string>(value)
{
    public override string ToString() => $"\"{Value}\"";
}

// [43]    	NumericLiteral 	   ::=    	IntegerLiteral | DecimalLiteral | DoubleLiteral
public class NumericLiteral(double value) : Literal<double>(value)
{
    public override string ToString() => Value.ToString();
}



// [44]    	VarRef 	   ::=    	"$" VarName
// [45]    	VarName 	   ::=    	QName
public class VarName(string prefix, string name) : QName(prefix, name) 
{
    public override string ToString() => $"""Var("@{Name}")""";
}


// [46]    	ParenthesizedExpr 	   ::=    	"(" Expr? ")"
public class ParenthesizedExpr(ExprSequence expr) : Expr 
{ 
    ExprSequence Exprs = expr;

    public override string ToString() => $"({Exprs})";
}

// [47]    	ContextItemExpr 	   ::=    	"."
public class ContextItemExpr : Expr { }

// [48]    	FunctionCall 	   ::=    	QName "(" (ExprSingle ("," ExprSingle)*)? ")" 	/* xgs: reserved-function-names */ 				/* gn: parens */
public class FunctionCall(QName name, ParenthesizedExpr param) : Expr
{
    QName Name {  get; set; } = name;
    ParenthesizedExpr Param { get; set; } = param;

    public override string ToString() => $"Call(\"{Name}\", {Param})";
}

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
public class QName(string prefix, string name) : Expr
{
    public string Prefix { get; set; } = prefix;
    public string Name { get; set; } = name;

    public override string ToString() => string.IsNullOrEmpty(Prefix) || true ? $"{Name}" : $"{Prefix}:{Name}";

}
// [79] NCName::=   	[http://www.w3.org/TR/REC-xml-names/#NT-NCName]Names	/* xgs: xml-version */
// [80] Char::=   	[http://www.w3.org/TR/REC-xml#NT-Char]XML	/* xgs: xml-version */
// [81] Digits::=   	[0-9]+
// [82] CommentContents::=   	(Char+ - (Char* ('(:' | ':)') Char*))



