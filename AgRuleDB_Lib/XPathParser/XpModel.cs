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
}


// [3]    	ExprSingle 	   ::=    	ForExpr | QuantifiedExpr | IfExpr | OrExpr
public abstract class Expr { }




// [4]    	ForExpr 	   ::=    	SimpleForClause "return" ExprSingle
// [5]    	SimpleForClause::=    	"for" "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)*
public class ForExpr : Expr
{
    public IEnumerable<InClause> ForClauses { get; init; }
    public Expr ForExpression { get; init; }
    public ForExpr(IEnumerable<InClause> forClauses, Expr forExpr)
    {
        ForClauses = forClauses;
        ForExpression = forExpr;
    }
}

public class InClause(string varName, Expr expr)
{
    public string VarName { get; init; } = varName;
    public Expr Expr { get; init; } = expr;
}


// [6]    	QuantifiedExpr 	   ::=    	("some" | "every") "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle
public enum Quantifier { some, every }
public class QuantifiedExpr : Expr
{
    public Quantifier Quantifier { get; init; }
    public IEnumerable<InClause> InClauses { get; init; }
    public Expr SatisfyExpr { get; init; }
    public QuantifiedExpr(string quantifier, IEnumerable<InClause> inClauses, Expr satisfyExpr)
    {
        Quantifier = Enum.Parse<Quantifier>(quantifier);
        InClauses = inClauses;
        SatisfyExpr = satisfyExpr;
    }
}

// [7]    	IfExpr 	   ::=    	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
public class IfExpr(ParenthesizedExpr condition, Expr thenExpr, Expr elseExpr) : Expr
{
    public ParenthesizedExpr Condition { get; init; } = condition;
    public Expr ThenExpr { get; init; } = thenExpr;
    public Expr ElseExpr { get; init; } = elseExpr;

    public override string ToString() => $"{Tab.TabsNl}if ({Condition}){Tab.TabsNl}{{{Tab.Push()}{ThenExpr}{Tab.Pop()}else {{{Tab.TabsNl}{Tab.Push()}{ElseExpr}{Tab.PopNl}}}";
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
public class SequenceType(Expr qname) : xpType
{
    Expr QName { get; init; } = qname;
}

public class SingleType(Expr qname) : xpType
{
    Expr QName { get; init; } = qname;
}



// [16]    	InstanceofExpr 	   ::=    	TreatExpr ( "instance" "of" SequenceType )?
public class InstanceofExpr(Expr expr, SequenceType seqtype)
{
    public Expr Expr { get; set; } = expr;
    public SequenceType SequenceType { get; set; } = seqtype;
}
// [17]    	TreatExpr 	   ::=    	CastableExpr ( "treat" "as" SequenceType )?
public class TreatExpr(Expr expr, SequenceType seqtype)
{
    public Expr Expr { get; set; } = expr;
    public SequenceType SequenceType { get; set; } = seqtype;
}

// [18]    	CastableExpr 	   ::=    	CastExpr ( "castable" "as" SingleType )?
public class CastableExpr(Expr expr, SingleType singletype)
{
    public Expr Expr { get; set; } = expr;
    public SingleType SingleType { get; set; } = singletype;
}

// [19]    	CastExpr 	   ::=    	UnaryExpr ( "cast" "as" SingleType )?
public class CastExpr(Expr expr, SingleType singletype)
{
    public Expr Expr { get; set; } = expr;
    public SingleType SingleType { get; set; } = singletype;
}

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
public enum BinOp { Or, And, Concat, To, Add, Sub, Times, Div, IDiv, Mod, Union, Intersect, Except, Comma }

public class BinaryExpr(Expr left, string op, Expr right) : Expr
{
    public Expr Left { get; init; } = left;
    public string Op { get; init; } = op;
    public Expr Right { get; init; } = right;

    public static BinOp StringToBinaryOperator(string op) => op.ToLower() switch
    {
        "or" => BinOp.Or,
        "and" => BinOp.And,
        "" => BinOp.Concat,
        "to" => BinOp.To,
        "+" => BinOp.Add,
        "-" => BinOp.Sub,
        "*" => BinOp.Times,
        "div" => BinOp.Div,
        "idiv" => BinOp.IDiv,
        "mod" => BinOp.Mod,
        "union" => BinOp.Union,
        "|" => BinOp.Union,
        "xxx" => BinOp.Intersect,
        "dxxx" => BinOp.Except,
        "," => BinOp.Comma,
        _ => throw new Exception($"Invalid operator {op}")
    };

    public override string ToString() => $"-{Op}-({Left},{Right})";

}




// [25]    	PathExpr 	   ::=    	("/" RelativePathExpr?) | ("//" RelativePathExpr) | RelativePathExpr 	/* xgs: leading-lone-slash */
// [26]    	RelativePathExpr 	   ::=    	StepExpr (("/" | "//") StepExpr)*

public enum PathSeparator { None, Slash, DoubleSlash }

public class PathExpr(IEnumerable<PathStep> stepExprs) : Expr
{
    public IEnumerable<PathStep> PathSteps { get; set; } = stepExprs;

    public override string ToString() => $"\n{{\n {string.Join('\n', PathSteps)} \n}}";    
}
// [27]    	StepExpr 	   ::=    	FilterExpr | AxisStep

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
// [39]    	PredicateList 	   ::=    	Predicate*
// [40]    	Predicate 	   ::=    	"// [" Expr "]"
public class FilterExpr(string s) : Expr
{
    public string Expression { get; set; } = s;
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
public class VarName(string prefix, string name) : QName(prefix, name) { }

// [46]    	ParenthesizedExpr 	   ::=    	"(" Expr? ")"
public class ParenthesizedExpr(ExprSequence expr) : Expr 
{ 
    ExprSequence Exprs = expr;
}

// [47]    	ContextItemExpr 	   ::=    	"."
public class ContextItemExpr : Expr { }

// [48]    	FunctionCall 	   ::=    	QName "(" (ExprSingle ("," ExprSingle)*)? ")" 	/* xgs: reserved-function-names */ 				/* gn: parens */
public class FunctionCall(QName name, ParenthesizedExpr param) : Expr
{
    QName name {  get; set; } = name;
    ParenthesizedExpr param { get; set; } = param;
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

    public override string ToString() => string.IsNullOrEmpty(Prefix) ? $"{Name}" : $"{Prefix}:{Name}";

}
// [79] NCName::=   	[http://www.w3.org/TR/REC-xml-names/#NT-NCName]Names	/* xgs: xml-version */
// [80] Char::=   	[http://www.w3.org/TR/REC-xml#NT-Char]XML	/* xgs: xml-version */
// [81] Digits::=   	[0-9]+
// [82] CommentContents::=   	(Char+ - (Char* ('(:' | ':)') Char*))



