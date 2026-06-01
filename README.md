# Mathematica2Julia.jl

Translate a [MathLink](https://github.com/JuliaInterop/MathLink.jl) expression
tree into a native Julia `Expr`.

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
```

`weval` is re-exported from `MathLink`. `w2expr` maps Mathematica heads
(`Plus`, `Times`, `Sin`, …) to Julia operators/functions. Unmapped heads
raise an error rather than guessing silently.

## License

MIT
