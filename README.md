# Mathematica2Julia.jl

Translate a Mathematica expression tree
into a native Julia `Expr`.

## Install

```julia
pkg> add https://github.com/junyixu/Mathematica2Julia.jl
```

## Usage

```sh
export JULIA_MATHKERNEL=$(which WolframKernel)
```

```julia
using Mathematica2Julia

w_tree = weval(W`
    Integrate[Sin[\[Pi] x] (x - x₋) / h, {x, x₋, x₀}] +
    Integrate[Sin[\[Pi] x] (x₊ - x) / h, {x, x₀, x₊}] // Simplify
`)

ex = w2expr(w_tree)   # native Julia Expr
# :(-1 * h ^ -1 * π ^ -2 * (-1 * π * (-2x₀ + x₊ + x₋) * cos(π * x₀) + -2 * sin(π * x₀) + sin(π * x₊) + sin(π * x₋)))

makefun(w, vars::Symbol...) = eval(Expr(:->, Expr(:tuple, vars...), w2expr(w)))
f = makefun(w_tree, :h, :x₀, :x₋, :x₊)

f(1.0, 0.5, 0.0, 1.0)
# 0.20264236728467555
```

`weval` is re-exported from `MathLink`. `w2expr` maps Mathematica heads
(`Plus`, `Times`, `Sin`, …) to Julia operators/functions. Unmapped heads
raise an error rather than guessing silently.

## License

MIT
