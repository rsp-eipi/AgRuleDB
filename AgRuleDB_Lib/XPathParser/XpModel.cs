namespace AgRuleDB_Lib.XPathParser;

// [3]    	ExprSingle 	   ::=    	ForExpr | QuantifiedExpr | IfExpr | OrExpr
public abstract class Expr
{
    public bool DisplayGenTypes { get; set; } = false;
    public string GenTypes { get => DisplayGenTypes ? "<D, E>" : ""; }
}

// [1]    	XPath 	   ::=    	Expr
// [2]    	Expr 	   ::=    	ExprSingle ("," ExprSingle)*
public class ExprSequence(IEnumerable<Expr> exprs) : Expr
{
    public IEnumerable<Expr> Exprs { get; init; } = exprs;
    public override string ToString() 
        => Exprs.Any() 
        ? $"Sequence{GenTypes}({Tab.PushNl}{String.Join($"{Tab.TabsNl}, ", Exprs.GenTypesOnAll())}{Tab.PopNl})" 
        : $"Sequence{GenTypes}()";
}

public class RuleExpr(int id, string description, Expr expr) : Expr
{
    public int Id { get; init; } = id;
    public string Description { get; init; } = description;
    public Expr Expr { get; init; } = expr;
    public override string ToString() => $"""""
            public static readonly Xp<D,E> rule{Id:000} = Rule<D, E>("R{Id:000}", """
            {Tab.Tabs}{Description}
            """ //-------------------------------------)            
            {Tab.Tabs}.{Expr};
        """"";

}


public class VarBinding(VarName varName, Expr expr) : Expr
{
    public VarName VarName { get; set; } = varName;
    public Expr Expr { get; set; } = expr;
    public override string ToString() => $"Bind{GenTypes}({VarName}, {Expr})";
}


// [4]    	ForExpr 	   ::=    	SimpleForClause "return" ExprSingle
// [5]    	SimpleForClause::=    	"for" "$" VarName "in" ExprSingle ("," "$" VarName "in" ExprSingle)*
public class ForExpr(IEnumerable<VarBinding> bindings, Expr returnExpr) : Expr
{
    public IEnumerable<VarBinding> Bindings { get; init; } = bindings;
    public Expr ReturnExpr { get; init; } = returnExpr;
    public override string ToString() => $"ForExpr{GenTypes}([{String.Join(',', Bindings.GenTypesOnAll())}], {ReturnExpr})";
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
    public override string ToString() => $"{Quantifier}{GenTypes}({String.Join(".", VarBindings.GenTypesOnFirst())}.Eval({SatisfyExpr}))";
}

// [7]    	IfExpr 	   ::=    	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
public class IfExpr(ParenthesizedExpr condition, Expr thenExpr, Expr elseExpr) : Expr
{
    public Expr Condition { get; init; } = condition.Expr.GenTypesSet();
    public Expr ThenExpr { get; init; } = thenExpr.GenTypesSet();
    public Expr ElseExpr { get; init; } = elseExpr.GenTypesSet();
    public override string ToString() => $"IfExpr{GenTypes}({Tab.PushNl}{Condition}{Tab.TabsNl}, {ThenExpr}{Tab.TabsNl}, {ElseExpr}{Tab.PopNl})";            
}





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


public class BinaryExpr(Expr left, string op, Expr right) : Expr
{
    public Expr Left { get; init; } = left;
    public BinOp Op { get; init; } = XpUtil.StringToBinaryOperator(op);
    public Expr Right { get; init; } = right;   
    public override string ToString() 
        => $"Binary{GenTypes}({Tab.PushNl}{Left.GenTypesSet()}{Tab.TabsNl}, BinOp.{Op}{Tab.TabsNl}, {Right.GenTypesSet()}{Tab.PopNl})";

}




// [25]    	PathExpr 	   ::=    	("/" RelativePathExpr?) | ("//" RelativePathExpr) | RelativePathExpr 	/* xgs: leading-lone-slash */
// [26]    	RelativePathExpr 	   ::=    	StepExpr (("/" | "//") StepExpr)*

public enum PathSeparator { None, Slash, DoubleSlash }

public class PathExpr(IEnumerable<PathStep> stepExprs) : Expr
{
    public IEnumerable<PathStep> PathSteps { get; set; } = stepExprs;    
    public override string ToString()
        => PathSteps.First().PathSeparator == PathSeparator.Slash
        ? $"Root{GenTypes}().{string.Join('.', PathSteps)}"
        : $"{string.Join('.', PathSteps.GenTypesOnFirst())}";
}

public enum Axis { None, Child, Descendant, Attribute, Self, DescendantOrSelf, FollowingSibling, Following, Namespace, 
    Parent, Ancestor, PrecedingSibling, Preceding, AncestorOrSelf }

// [27]    	StepExpr 	   ::=    	FilterExpr | AxisStep
public class PathStep(PathSeparator separator, string axis, QName? name, IEnumerable<FilterExpr> filters) : Expr
{
    public PathSeparator PathSeparator { get; init; } = separator;
    public Axis Axis { get; init; } = XpUtil.StringToAxis(axis);
    public QName? Name { get; init; } = name;
    public IEnumerable<FilterExpr> Filters { get; init; } = filters;

    public static string PathSeparatorToString(PathSeparator sep)
        => sep switch
        {
            PathSeparator.None => String.Empty,
            PathSeparator.Slash => "/",
            PathSeparator.DoubleSlash => "//",
            _ => throw new Exception("Unknown separator")
        };

    private string _NameAsString { get => Name is null ? string.Empty : Name.ToString(); }

    public string GetAxis() =>
        Axis == Axis.None
            ? PathSeparator switch {
                PathSeparator.None          => $"""Move{GenTypes}(Axis.Child, "{_NameAsString}")""",
                PathSeparator.Slash         => $"""Move{GenTypes}(Axis.Child, "{_NameAsString}")""",
                PathSeparator.DoubleSlash   => $"""Move{GenTypes}(Axis.DescendantOrSelf, "{_NameAsString}")""",
                _ => throw new Exception("Unknown path separator")
            }
            : $"""Move(Axis.{Axis}, "{_NameAsString}")""";
    

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

    // Filter expressions shall follow another expression such as a step or a sequence, therefore, there is no need for a GenTypes
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
    public override string ToString() => $"Lift{GenTypes}(\"{Value}\")";
}

// [43]    	NumericLiteral 	   ::=    	IntegerLiteral | DecimalLiteral | DoubleLiteral
public class NumericLiteral(double value) : Literal<double>(value)
{
    public override string ToString() => $"Lift{GenTypes}({Value})";
}



// [44]    	VarRef 	   ::=    	"$" VarName
// [45]    	VarName 	   ::=    	QName
public class VarName(string prefix, string name) : QName(prefix, name) 
{
    public override string ToString() => $"""Var{GenTypes}("@{Name}")""";
}


// [46]    	ParenthesizedExpr 	   ::=    	"(" Expr? ")"
public class ParenthesizedExpr(Expr expr) : Expr 
{ 
    public Expr Expr { get; init; } = expr;
    public override string ToString() => $"({Expr})";
}

// [47]    	ContextItemExpr 	   ::=    	"."
public class ContextItemExpr : Expr { }

// [48]    	FunctionCall 	   ::=    	QName "(" (ExprSingle ("," ExprSingle)*)? ")" 	/* xgs: reserved-function-names */ 				/* gn: parens */
public class FunctionCall(QName name, ParenthesizedExpr param) : Expr
{
    QName Name {  get; set; } = name;
    Expr Param { get; set; } = param.Expr;
    public override string ToString() => $"Call{GenTypes}(\"{Name}\", {Param})";
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



