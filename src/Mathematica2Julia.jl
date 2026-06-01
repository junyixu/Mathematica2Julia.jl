module Mathematica2Julia

using MathLink

export weval, w2expr

# Mathematica head (String) → Julia operator/function (Symbol)
const HEAD2JL = Dict{String,Symbol}(
    "Plus"     => :+,   "Times" => :*,    "Power" => :^,
    "Rational" => ://,
    "Sin"  => :sin, "Cos" => :cos, "Tan" => :tan,
    "Exp"  => :exp, "Log" => :log, "Sqrt" => :sqrt, "Abs" => :abs,
)

# Mathematica symbol (String) → Julia value/symbol
const SYM2JL = Dict{String,Any}("Pi" => :π, "E" => :ℯ, "Infinity" => :Inf)

"""
    w2expr(w) -> Expr | Symbol | Number

Translate a `MathLink` expression tree into a native Julia `Expr`.
Unmapped heads raise an error instead of guessing silently.
"""
w2expr(x::Number)            = x
w2expr(x::MathLink.WInteger) = parse(BigInt,  x.value)   # only when a big integer is boxed
w2expr(x::MathLink.WReal)    = parse(Float64, x.value)
w2expr(s::MathLink.WSymbol)  = get(SYM2JL, s.name, Symbol(s.name))  # variables like h, x0, xm, xp

function w2expr(w::MathLink.WExpr)
    w.head isa MathLink.WSymbol || error("non-symbol head: $(w.head)")
    op = get(HEAD2JL, w.head.name, nothing)
    op === nothing && error("unmapped head: $(w.head.name)")  # fail loud, never guess
    Expr(:call, op, map(w2expr, w.args)...)
end

end # module
