"""
    $(SIGNATURES)

Evaluate the item information function of an item response model `M` for response `y` at
the ability value `theta` given item parameters `beta`.

If `y` is omitted, the item category information functions for all categories are returned.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> iif(OnePL, 0.0, 0.0, 1)
0.125

julia> iif(OnePL, 0.0, (; b = 0.0))
2-element Vector{Float64}:
 0.125
 0.125
```

### 2 Parameter Logistic Model
```jldoctest
julia> iif(TwoPL, 0.0, (a = 1.3, b = 0.2))
2-element Vector{Float64}:
 0.2345721809921237
 0.1808672521393781
```

### 3 Parameter Logistic Model
```jldoctest
julia> iif(ThreePL, 0.0, (a = 1.5, b = 0.5, c = 0.15))
2-element Vector{Float64}:
 0.2830301834782102
 0.033256997107963204
```
### 4 Parameter Logistic Model
```jldoctest
julia> iif(FourPL, 0.0, (a = 2.1, b = -0.2, c = 0.15, d = 0.9))
2-element Vector{Float64}:
 0.1936328888005068
 0.3995140205278245
```

"""
function iif(M::Type{<:DichotomousItemResponseModel}, theta, beta, y)
    check_response_type(M, y)
    return _iif(M, theta, beta, y; scoring_function = one)
end

function iif(M::Type{<:DichotomousItemResponseModel}, theta, beta)
    info = zeros(2)
    return _iif!(M, info, theta, beta; scoring_function = one)
end

function _iif(
    M::Type{<:DichotomousItemResponseModel},
    theta,
    beta,
    y;
    scoring_function::F,
) where {F}
    prob, deriv, deriv2 = second_derivative_theta(M, theta, beta, y; scoring_function)
    prob == 0.0 && return 0.0  # early return to avoid NaNs
    info = deriv^2 / prob - deriv2
    return info
end

function _iif!(
    M::Type{<:DichotomousItemResponseModel},
    info,
    theta,
    beta;
    scoring_function::F,
) where {F}
    info[1] = _iif(M, theta, beta, 0; scoring_function)
    info[2] = _iif(M, theta, beta, 1; scoring_function)
    return info
end

# polytomous models
function iif(M::Type{<:PolytomousItemResponseModel}, theta, beta, y)
    pars = ItemParameters(M, beta)
    return iif(M, theta, pars)[y]
end

function iif(M::Type{<:PolytomousItemResponseModel}, theta, beta)
    pars = ItemParameters(M, beta)
    infos = zeros(length(beta.t) + 1)
    return _iif!(M, infos, theta, pars; scoring_function = one)
end

function _iif!(
    M::Type{<:PolytomousItemResponseModel},
    infos,
    theta,
    beta;
    scoring_function::F,
) where {F}
    @unpack a = beta

    derivs = similar(infos)
    derivs2 = similar(infos)
    second_derivative_theta!(M, infos, derivs, derivs2, theta, beta; scoring_function)

    for c in eachindex(infos)
        if iszero(derivs[c])
            infos[c] = 0.0
        else
            infos[c] = derivs[c]^2 / infos[c] - derivs2[c]
        end
    end

    return infos
end

"""
    $(SIGNATURES)

An in-place version of [`iif`](@ref).
Provides efficient computation of the item category information functions by mutating `infos`
in-place, thus avoiding allocation of an intermediate arrays and output vector.

## Examples
```jldoctest
julia> beta = (a = 0.3, b = 0.1, t = (0.2, -0.5));

julia> infos = zeros(length(beta.t) + 1);

julia> iif!(GPCM, infos, 0.0, beta)
3-element Vector{Float64}:
 0.019962114838441732
 0.020570051742573044
 0.0171815514677598

julia> infos
3-element Vector{Float64}:
 0.019962114838441732
 0.020570051742573044
 0.0171815514677598
```
"""
function iif!(M::Type{<:ItemResponseModel}, infos, theta, beta)
    pars = ItemParameters(M, beta)
    return _iif!(M, infos, theta, pars; scoring_function = one)
end
