"""
    $(SIGNATURES)

Calculate the expected score of an item response model `M` at the ability value `theta`
given a vector of item parameters `betas`. The values of betas are considered item
parameters for different items.

Expected scores are calculated from the models [`irf`](@ref) function. For details on how
to pass item parameters to [`irf`](@ref), see the respective function documentation.

## Response scoring

The expected score is defined as the expected value of an observed response pattern `x`.
Thus, the expected value for an arbitrary function `f(x)` can also be defined.
We call the function `f` the `scoring_function` that maps responses to arbitrary values.

## Examples
### 1 Parameter Logistic Model
```jldoctest
julia> betas = fill(0.0, 10);

julia> expected_score(OnePL, 0.0, betas)
5.0

julia> expected_score(OnePL, 0.0, betas; scoring_function = x -> 2x)
10.0
```

### 2 Parameter Logistic Model
```jldoctest
julia> betas = fill((a = 1.5, b = 0.0), 5);

julia> expected_score(TwoPL, 0.0, betas)
2.5

julia> expected_score(TwoPL, 0.0, betas; scoring_function = x -> x + 1)
7.5
```

### 3 Parameter Logistic Model
```jldoctest
julia> betas = fill((a = 0.4, b = 0.5, c = 0.1), 6);

julia> expected_score(ThreePL, 0.0, betas)
3.030896414512619
```

### 4 Parameter Logistic Model
```jldoctest
julia> betas = fill((a = 1.4, b = 1.0, c = 0.15, d = 0.9), 7);

julia> expected_score(FourPL, 0.0, betas)
2.0885345850674453
```

"""
function expected_score(
    M::Type{<:DichotomousItemResponseModel},
    theta::T,
    betas::AbstractVector;
    scoring_function::F = identity,
) where {T<:Real,F}
    score = zero(T)

    for beta in betas, y in 0:1
        score += irf(M, theta, beta, y) * scoring_function(y)
    end

    return score
end
