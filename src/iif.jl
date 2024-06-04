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
    checkresponsetype(response_type(M), y)
    return _iif(M, theta, beta, y)
end

function iif(M::Type{<:DichotomousItemResponseModel}, theta, beta)
    info = zeros(2)
    return _iif!(M, info, theta, beta)
end

function _iif!(M::Type{<:DichotomousItemResponseModel}, info, theta, beta)
    info[1] = _iif(M, theta, beta, 0)
    info[2] = _iif(M, theta, beta, 1)
    return info
end

function _iif(M::Type{<:DichotomousItemResponseModel}, theta, beta, y)
    prob, deriv, deriv2 = second_derivative_theta(M, theta, beta, y)
    prob == 0.0 && return 0.0  # early return to avoid NaNs
    return deriv^2 / prob - deriv2
end

# polytomous models
function iif(M::Type{GPCM}, theta, beta; scoring_function::F = identity) where {F}
    checkpars(M, beta)
    @unpack a = beta

    probs = irf(M, theta, beta)
    score = expected_score(M, theta, beta)

    info = zero(theta)

    for (category, prob) in enumerate(probs)
        info += (scoring_function(category) - score)^2 * prob
    end

    info *= a^2

    return info
end

function iif(
    M::Type{<:PolytomousItemResponseModel},
    theta,
    beta;
    scoring_function::F = identity,
) where {F}
    pars = merge_pars(GPCM, beta)
    return iif(GPCM, theta, pars; scoring_function)
end

function iif(
    M::Type{<:PolytomousItemResponseModel},
    theta,
    beta,
    y;
    scoring_function::F = identity,
) where {F}
    checkresponsetype(response_type(M), y)
    prob = irf(M, theta, beta, y)
    return prob * iif(M, theta, beta; scoring_function)
end
