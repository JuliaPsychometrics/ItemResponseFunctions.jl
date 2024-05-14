"""
    $(SIGNATURES)

Evaluate the item response function of an item response model `M` for response `y` at the
ability value `theta` given item parameters `beta`.

## Models with dichotomous responses
If `response_type(M) == Dichotomous`, then the item response function is evaluated for a
correct response (`y = 1`) by default.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> irf(OnePL, 0.0, 0.0)
0.5

julia> irf(OnePL, 0.0, (; b = 0.5))
0.37754066879814546
```

### 2 Parameter Logistic Model
```jldoctest
julia> beta = (; a = 1.5, b = 0.5);

julia> irf(TwoPL, 0.0, beta)
0.32082130082460697
```

### 3 Parameter Logistic Model
```jldoctest
julia> beta = (; a = 1.5, b = 0.5, c = 0.2);

julia> irf(ThreePL, 0.0, beta)
0.4566570406596856
```

### 4 Parameter Logistic Model
```jldoctest
julia> beta = (; a = 1.5, b = 0.5, c = 0.2, d = 0.8);

julia> irf(FourPL, 0.0, beta)
0.3924927804947642
```
"""
function irf(M::Type{OnePL}, theta::Real, beta::Real, y = 1)
    prob = logistic(theta - beta)
    return ifelse(y == 1, prob, 1 - prob)
end

function irf(M::Type{OnePL}, theta, beta, y = 1)
    return irf(FourPL, theta, merge(beta, (a = 1.0, c = 0.0, d = 1.0)), y)
end

function irf(M::Type{TwoPL}, theta, beta, y = 1)
    return irf(FourPL, theta, merge(beta, (; c = 0.0, d = 1.0)), y)
end

function irf(M::Type{ThreePL}, theta, beta, y = 1)
    return irf(FourPL, theta, merge(beta, (; d = 1.0)), y)
end

function irf(M::Type{FourPL}, theta::Real, beta::NamedTuple, y = 1)
    @unpack a, b, c, d = beta
    prob = c + (d - c) * logistic(a * (theta - b))
    return ifelse(y == 1, prob, 1 - prob)
end
