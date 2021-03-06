# Sum of the positive components

export SumPositive

"""
**Sum of the positive coefficients**

    SumPositive()

Returns the function
```math
f(x) = ∑_i \\max\\{0, x_i\\}.
```
"""
struct SumPositive <: ProximableFunction end

is_separable(f::SumPositive) = true
is_convex(f::SumPositive) = true

function (f::SumPositive)(x::AbstractArray{T}) where T <: Real
    return sum(xi -> max(xi, 0), x)
end

function prox!(y::AbstractArray{R}, f::SumPositive, x::AbstractArray{R}, gamma::R=R(1)) where R <: Real
    fsum = R(0)
    for i in eachindex(x)
        y[i] = x[i] < gamma ? (x[i] > 0 ? R(0) : x[i]) : x[i]-gamma
        fsum += y[i] > 0 ? y[i] : R(0)
    end
    return fsum
end

function gradient!(y::AbstractArray{R}, f::SumPositive, x::AbstractArray{R}) where R <: Real
    y .= max.(0, sign.(x))
    return sum(xi -> max(xi, 0), x)
end

fun_name(f::SumPositive) = "Sum of the positive coefficients"
fun_dom(f::SumPositive) = "AbstractArray{Real}"
fun_expr(f::SumPositive) = "x ↦ sum(max(0, x))"

function prox_naive(f::SumPositive, x::AbstractArray{R}, gamma::R=R(1)) where R <: Real
    y = copy(x)
    indpos = x .> 0
    y[indpos] = max.(R(0), x[indpos] .- gamma)
    return y, sum(max.(R(0), y))
end

# ######################### #
# Prox with multiple gammas #
# ######################### #

function prox!(y::AbstractArray{R}, f::SumPositive, x::AbstractArray{R}, gamma::AbstractArray{R}) where R <: Real
    fsum = R(0)
    for i in eachindex(x)
        y[i] = x[i] < gamma[i] ? (x[i] > 0 ? R(0) : x[i]) : x[i]-gamma[i]
        fsum += y[i] > 0 ? y[i] : R(0)
    end
    return fsum
end

function prox_naive(f::SumPositive, x::AbstractArray{R}, gamma::AbstractArray{R}) where R <: Real
    y = copy(x)
    indpos = x .> 0
    y[indpos] = max.(R(0), x[indpos] .- gamma[indpos])
    return y, sum(max.(R(0), y))
end
