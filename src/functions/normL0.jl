# L0 pseudo-norm (times a constant)

"""
  NormL0(λ::Real=1.0)

Returns the function `g(x) = λ*countnz(x)`, for a nonnegative parameter `λ ⩾ 0`.
"""

immutable NormL0 <: ProximableFunction
  lambda::Real
  NormL0(lambda::Real=1.0) =
    lambda < 0 ? error("parameter λ must be nonnegative") : new(lambda)
end

@compat function (f::NormL0){T <: RealOrComplex}(x::AbstractArray{T})
  return f.lambda*countnz(x)
end

function prox!{T <: RealOrComplex}(f::NormL0, x::AbstractArray{T}, gamma::Real, y::AbstractArray{T})
  countnzy = 0;
  gl = gamma*f.lambda
  for i in eachindex(x)
    over = abs(x[i]) > sqrt(2*gl);
    y[i] = over*x[i];
    countnzy += over;
  end
  return f.lambda*countnzy
end

fun_name(f::NormL0) = "weighted L0 pseudo-norm"
fun_type(f::NormL0) = "Array{Complex} → Real"
fun_expr(f::NormL0) = "x ↦ λ countnz(x)"
fun_params(f::NormL0) = "λ = $(f.lambda)"

function prox_naive{T <: RealOrComplex}(f::NormL0, x::AbstractArray{T}, gamma::Real=1.0)
  over = abs(x) .> sqrt(2*gamma*f.lambda);
  y = x.*over;
  return y, f.lambda*countnz(y)
end
