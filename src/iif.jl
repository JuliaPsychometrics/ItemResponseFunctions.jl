"""
    $(SIGNATURES)

Evaluate the item information function of an item response model `M` for response `y` at
the ability value `theta` given item parameters `beta`.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> iif(OnePL, 0.0, 0.0)
0.25

julia> iif(OnePL, 0.0, (; b = 0.0))
0.25
```

### 2 Parameter Logistic Model
```jldoctest
julia> iif(TwoPL, 0.0, (a = 1.3, b = 0.2))
0.4154394331315018
```

### 3 Parameter Logistic Model
```jldoctest
julia> iif(ThreePL, 0.0, (a = 1.5, b = 0.5, c = 0.15))
0.3162871805861734

```
### 4 Parameter Logistic Model
```jldoctest
julia> iif(FourPL, 0.0, (a = 2.1, b = -1.5, c = 0.15, d = 0.9))
0.03387157823313065
```

"""
function iif(M::Type{<:DichotomousItemResponseModel}, theta, beta::NamedTuple)
    info = zero(theta)
    for y in 0:1
        info += _iif(M, theta, beta, y)
    end
    return info
end

function iif(M::Type{<:DichotomousItemResponseModel}, theta, beta::NamedTuple, y)
    return _iif(M, theta, beta, y)
end

iif(M::Type{OnePL}, theta, beta::Real, y) = iif(M, theta, (; b = beta), y)
iif(M::Type{OnePL}, theta, beta::Real) = iif(M, theta, (; b = beta))

function _iif(M::Type{<:DichotomousItemResponseModel}, theta, beta, y)
    adtype = AutoForwardDiff()
    f = x -> irf(M, x, beta, y)
    prob, deriv = value_and_derivative(f, adtype, theta)
    iszero(prob) && return 0.0
    deriv2 = second_derivative(f, adtype, theta)
    return deriv^2 / prob - deriv2
end

function iif(M::Type{GPCM}, theta, beta; scoring_function::F = identity) where {F}
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
    prob = irf(M, theta, beta, y)
    return prob * iif(M, theta, beta; scoring_function)
end
