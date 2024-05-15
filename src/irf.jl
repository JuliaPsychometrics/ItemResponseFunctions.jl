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
julia> beta = (a = 1.5, b = 0.5);

julia> irf(TwoPL, 0.0, beta)
0.32082130082460697
```

### 3 Parameter Logistic Model
```jldoctest
julia> beta = (a = 1.5, b = 0.5, c = 0.2);

julia> irf(ThreePL, 0.0, beta)
0.4566570406596856
```

### 4 Parameter Logistic Model
```jldoctest
julia> beta = (a = 1.5, b = 0.5, c = 0.2, d = 0.8);

julia> irf(FourPL, 0.0, beta)
0.3924927804947642
```

### Partial Credit Model
```jldoctest
julia> beta = (b = -0.3, t = [-0.5, 1.3, -0.2]);

julia> irf(PCM, 0.0, beta)
4-element Vector{Float64}:
 0.09656592461423529
 0.07906149218108449
 0.3915941342939724
 0.4327784489107078

julia> irf(PCM, 0.0, beta, 3)
0.3915941342939724
```

### Generalized Partial Credit Model
```jldoctest
julia> beta = (a = 1.3, b = 0.25, t = [0.0, 1.0]);

julia> irf(GPCM, 0.0, beta)
3-element Vector{Float64}:
 0.27487115408319557
 0.1986019275522736
 0.5265269183645309

julia> irf(GPCM, 0.0, beta, 1)
0.27487115408319557
```

### Rating Scale Model
```jldoctest
julia> beta = (b = 0.0, t = zeros(2));

julia> irf(RSM, 0.0, beta)
3-element Vector{Float64}:
 0.3333333333333333
 0.3333333333333333
 0.3333333333333333

julia> irf(RSM, 0.0, beta, 3)
0.3333333333333333
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

function irf(M::Type{GPCM}, theta, beta)
    @unpack a, b, t = beta
    extended = zeros(length(t) + 1)
    @. extended[2:end] = a * (theta - b + t)
    cumsum!(extended, extended)
    softmax!(extended, extended)
    return extended
end

irf(M::Type{GPCM}, theta, beta, y) = irf(M, theta, beta)[y]
irf(M::Type{PCM}, theta, beta) = irf(GPCM, theta, merge(beta, (; a = 1.0)))
irf(M::Type{PCM}, theta, beta, y) = irf(GPCM, theta, merge(beta, (; a = 1.0)), y)
irf(M::Type{RSM}, theta, beta) = irf(PCM, theta, beta)
irf(M::Type{RSM}, theta, beta, y) = irf(PCM, theta, beta, y)
