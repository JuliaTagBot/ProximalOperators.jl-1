# indicator of the probability simplex

"""
  IndSimplex()

Returns the function `g = ind{x : x ⩾ 0, sum(x) = 1}`.
"""

immutable IndSimplex <: IndicatorConvex end

@compat function (f::IndSimplex){T <: Real}(x::AbstractArray{T,1})
  if all(x .>= 0) && abs(sum(x)-1) <= 1e-14
    return 0.0
  end
  return +Inf
end

function prox!{T <: Real}(f::IndSimplex, x::AbstractArray{T,1}, gamma::Real, y::AbstractArray{T,1})
  n = length(x)
  p = sort(x, rev=true);
  s = 0
  for i = 1:n-1
    s = s + p[i]
    tmax = (s - 1)/i
    if tmax >= p[i+1]
      y[:] = max(x-tmax, 0)
      return 0.0
    end
  end
  tmax = (s + p[n] - 1)/n
  y[:] = max(x-tmax, 0)
  return 0.0
end

fun_name(f::IndSimplex) = "indicator of the probability simplex"
fun_type(f::IndSimplex) = "Array{Real,1} → Real ∪ {+∞}"
fun_expr(f::IndSimplex) = "x ↦ 0 if x ⩾ 0 and sum(x) = 1, +∞ otherwise"
fun_params(f::IndSimplex) = "none"

function prox_naive{T <: Real}(f::IndSimplex, x::AbstractArray{T,1}, gamma::Real=1.0)
  n = length(x)
  p = sort(x,rev=true);
  s = 0
  for i = 1:n-1
    s = s + p[i]
    tmax = (s - 1)/i
    if tmax >= p[i+1]
      return (max(x-tmax,0), 0.0)
    end
  end
  tmax = (s + p(n) - 1)/n
  return max(x-tmax,0), 0.0
end
