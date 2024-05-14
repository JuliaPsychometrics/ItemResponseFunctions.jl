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
0.3162871805861735

```
### 4 Parameter Logistic Model
```jldoctest
julia> iif(FourPL, 0.0, (a = 2.1, b = -1.5, c = 0.15, d = 0.9))
0.033871578233130605
```

"""
function iif(M::Type{OnePL}, theta::Real, beta::Real, y = 1)
    prob = irf(M, theta, beta, y)
    return prob * (1 - prob)
end

function iif(M::Type{OnePL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (a = 1.0, c = 0.0, d = 1.0)), y)
end

function iif(M::Type{TwoPL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (; c = 0.0, d = 1.0)), y)
end

function iif(M::Type{ThreePL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (; d = 1.0)), y)
end

function iif(M::Type{FourPL}, theta, beta::NamedTuple, y = 1)
    @unpack a, b, c, d = beta
    prob = irf(M, theta, beta, y)

    num = a^2 * (prob - c)^2 * (d - prob)^2

    # return early to avoid NaN cases when 0/0
    num == 0 && return num

    denum = (d - c)^2 * prob * (1 - prob)
    info = num / denum

    return info
end
