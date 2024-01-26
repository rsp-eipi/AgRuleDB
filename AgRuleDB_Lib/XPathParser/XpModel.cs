using Sprache;
using System.Linq.Expressions;
using System.Xml.Linq;

namespace AgRuleDB_Lib.XPathParser;


public abstract class ExprBase { }



// [1] XPath::=   	Expr
// [2] ParamList      ::=   	Param ("," Param)*
// [3] Param      ::=   	"$" EQName TypeDeclaration?
// [4] FunctionBody::=   	EnclosedExpr
// [5] EnclosedExpr::=   	"{" Expr? "}"
public class EnclosedExpr : ExprBase 
{ 
    public Expr? Enclosed { get; set; }
    public bool HasValue { get => Enclosed is not null; }
    public EnclosedExpr(Expr? expr)
    {
        Enclosed = expr;
    }
}

// [6]   	Expr	   ::=   	ExprSingle ("," ExprSingle)*
public class Expr(ExprSingle first, IEnumerable<ExprSingle> tail) : ExprBase 
{
    public List<ExprSingle> Exprs { get; set; } = [first, .. tail];    
}

// [7]   	ExprSingle	   ::=   	ForExpr | LetExpr | QuantifiedExpr| IfExpr| OrExpr
public abstract class ExprSingle : ExprBase { }

// [8]   	ForExpr	   ::=   	SimpleForClause "return" ExprSingle
// [9] SimpleForClause::=   	"for" SimpleForBinding("," SimpleForBinding)*
public class ForExpr : ExprSingle
{
    public List<InClause> ForClause { get; init; }
    public ExprSingle ForExpression { get; init; }
    public ForExpr(InClause firstForClause, IEnumerable<InClause> tailForClauses, ExprSingle forExpr)
    {
        ForClause = [firstForClause, .. tailForClauses];
        ForExpression = forExpr;
    }
}


// [10] SimpleForBinding       ::=   	"$" VarName "in" ExprSingle   --> renamed inclause since the same is used in [14] QuantifiedExpr
public class InClause(string varName, ExprSingle exprSingle)
{
    public string VarName { get; init; } = varName;
    public ExprSingle ExprSingle { get; init; } = exprSingle;
}

// [11] LetExpr::=   	SimpleLetClause "return" ExprSingle
public class LetExpr(IEnumerable<SimpleLetBinding> bindings, ExprSingle returnExpr) : ExprSingle
{
    IEnumerable<SimpleLetBinding> Bindings { get; init; } = bindings;
    ExprSingle ReturnExpr { get; init; } = returnExpr;
}

// [12] SimpleLetClause         ::=   	"let" SimpleLetBinding("," SimpleLetBinding)*
// [13] SimpleLetBinding        ::=   	"$" VarName ":=" ExprSingle
public class SimpleLetBinding(string varName, ExprSingle exprSingle)
{
    public string VarName { get; init; } = varName;
    public ExprSingle ExprSingle { get; init; } = exprSingle;
}

//[14] QuantifiedExpr           ::=   	("some" | "every") "$" VarName "in" ExprSingle("," "$" VarName "in" ExprSingle)* "satisfies" ExprSingle
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

// [15] IfExpr          ::=   	"if" "(" Expr ")" "then" ExprSingle "else" ExprSingle
public class IfExpr(Expr testExpr, ExprSingle thenExpr, ExprSingle elseExpr) : ExprSingle
{
    public Expr TestExpr { get; init; } = testExpr;
    public ExprSingle ThenExpr { get; init; } = thenExpr;
    public ExprSingle ElseExpr { get; init; } = elseExpr;
}

// [16] OrExpr      ::=   	AndExpr( "or" AndExpr )*
public class OrExpr(AndExpr, AndExpr)

// [17] AndExpr     ::=   	ComparisonExpr ( "and" ComparisonExpr )*



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

