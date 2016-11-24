# Separable sum

immutable SlicedSeparableSum <: ProximableFunction
	fs::Array
	is::Array
	dim::Integer

	function SlicedSeparableSum(a::Array, b::Array, dim::Integer=1)
		if size(a) != size(b)
			error("size(fs) must coincide with size(is)")
		else
			new(a, b, dim)
		end
	end

	function SlicedSeparableSum(ps::Array, dim::Integer=1)
		a = Array{ProximableFunction}(length(ps))
		b = Array{AbstractArray}(length(ps))
		for i in eachindex(ps)
			a[i] = ps[i].first
			b[i] = ps[i].second
		end
		new(a, b, dim)
	end
end

function prox!{T <: RealOrComplex}(f::SlicedSeparableSum, x::AbstractArray{T}, y::AbstractArray{T}, gamma::Real=1.0)
  v = 0.0
  nd = ndims(x)

  for i in eachindex(f.fs)
	  z = slicedim(y,f.dim,f.is[i])
	  g = prox!(f.fs[i],slicedim(x,f.dim,f.is[i]),z,gamma)
	  y[[ n==f.dim ? f.is[i] : indices(y,n) for n in 1:nd ]...] = z
	  v += g
  end
  return v

end

fun_name(f::SlicedSeparableSum) = "sliced separable sum"
function fun_dom(f::SlicedSeparableSum)
	# s = ""
	# for k in eachindex(f.fs)
	# 	s = string(s, fun_dom(f.fs[k]), " × ")
	# end
	# return s
	return "n/a" # for now
end
fun_expr(f::SlicedSeparableSum) = "hard to explain"
function fun_params(f::SlicedSeparableSum)
	# s = "r = $(size(f.fs)), "
	# for k in eachindex(f.fs)
	# 	s = string(s, "f[$(k)] = $(typeof(f.fs[k])), ")
	# end
	# return s
	return "n/a" # for now
end