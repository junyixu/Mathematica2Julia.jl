using Mathematica2Julia
using MathLink
using Test

@testset "Mathematica2Julia" begin
    w_tree = weval(W`
        Integrate[ Sin[\[Pi] x] (x - x₋) / h, {x,x₋, x₀}]+Integrate[ Sin[\[Pi] x] (x₊-x) / h, {x, x₀,x₊}]//Simplify
    `)

    ex = w2expr(w_tree)

    @test ex isa Expr
    @test ex.head === :call
end
