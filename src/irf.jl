"""
    $(SIGNATURES)

Evaluate the item response function of an item response model `M` for response `y` at the
ability value `theta` given item parameters `beta`.

If `y` is omitted, then the item response function is evaluated for all possible responses.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> irf(OnePL, 0.0, 0.0, 1)
0.5

julia> irf(OnePL, 0.0, (; b = 0.5), 1)
0.37754066879814546

julia> irf(OnePL, 0.0, 0.5)
2-element Vector{Float64}:
 0.6224593312018545
 0.3775406687981455
```

### 2 Parameter Logistic Model
```jldoctest
julia> beta = (a = 1.5, b = 0.5);

julia> irf(TwoPL, 0.0, beta, 1)
0.32082130082460697
```

### 3 Parameter Logistic Model
```jldoctest
julia> beta = (a = 1.5, b = 0.5, c = 0.2);

julia> irf(ThreePL, 0.0, beta, 1)
0.4566570406596856
```

### 4 Parameter Logistic Model
```jldoctest
julia> beta = (a = 1.5, b = 0.5, c = 0.2, d = 0.8);

julia> irf(FourPL, 0.0, beta, 1)
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
function irf(M::Type{<:DichotomousItemResponseModel}, theta, beta, y)
    checkresponsetype(response_type(M), y)
    pars = merge_pars(M, beta)
    return _irf(M, theta, pars, y; scoring_function = one)
end

function irf(M::Type{<:DichotomousItemResponseModel}, theta, beta)
    pars = merge_pars(M, beta)
    probs = zeros(2)
    return _irf!(M, probs, theta, pars; scoring_function = one)
end

function _irf(
    M::Type{<:DichotomousItemResponseModel},
    theta::Real,
    beta,
    y;
    scoring_function::F,
) where {F}
    checkpars(M, beta)
    @unpack a, b, c, d, e = beta
    prob = c + (d - c) * logistic(a * (theta - b))^e
    res = ifelse(y == 1, prob, 1 - prob) * scoring_function(y)
    return res
end

function _irf!(
    M::Type{<:DichotomousItemResponseModel},
    probs,
    theta,
    beta;
    scoring_function::F,
) where {F}
    probs[1] = _irf(M, theta, beta, 0; scoring_function)
    probs[2] = _irf(M, theta, beta, 1; scoring_function)
    return probs
end

# polytomous models
function irf(M::Type{<:PolytomousItemResponseModel}, theta, beta, y)
    checkresponsetype(response_type(M), y)
    return irf(M, theta, beta)[y]
end

function irf(M::Type{<:PolytomousItemResponseModel}, theta, beta)
    pars = merge_pars(M, beta)
    checkpars(M, pars)

    @unpack t = beta
    probs = zeros(length(t) + 1)

    return _irf!(M, probs, theta, pars)
end

function _irf!(M::Type{<:PolytomousItemResponseModel}, probs, theta, beta)
    checkpars(M, beta)
    @unpack a, b, t = beta
    probs[1] = 0.0
    @. probs[2:end] = a * (theta - b + t)
    cumsum!(probs, probs)
    softmax!(probs, probs)
    return probs
end

"""
    $(SIGNATURES)

An in-place version of [`irf`](@ref).
Provides efficient computation by mutating `probs` in-place, thus avoiding allocation of an
output vector.

## Examples
```jldoctest
julia> beta = (a = 1.2, b = 0.3, t = zeros(3));

julia> probs = zeros(length(beta.t) + 1);

julia> irf!(GPCM, probs, 0.0, beta)
4-element Vector{Float64}:
 0.3961927292844976
 0.2764142877832629
 0.19284770477416754
 0.13454527815807202

julia> probs
4-element Vector{Float64}:
 0.3961927292844976
 0.2764142877832629
 0.19284770477416754
 0.13454527815807202
```
"""
function irf!(M::Type{<:ItemResponseModel}, probs, theta, beta)
    pars = merge_pars(M, beta)
    return _irf!(M, probs, theta, pars)
end
