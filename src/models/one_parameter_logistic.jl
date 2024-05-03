abstract type OneParameterLogisticModel <: ItemResponseModel end

const OnePL = OneParameterLogisticModel

"""
    irf(::Type{OneParameterLogisticModel}, theta, beta, y = 1)

Evaluate the item response function of a one parmaeter logistic (1PL) model for response `y`
at the ability value `theta` and time difficulty `beta`.

If the response value `y` is omitted, the item response probability for a correct response
`y = 1` is returned.

## Examples
```jldoctest
julia> irf(OneParameterLogisticModel, 0.0, 0.0, 1)
0.5

julia> irf(OneParameterLogisticModel, 0.0, -Inf, 1)
1.0

julia> irf(OneParameterLogisticModel, 0.0, Inf, 1)
0.0

```
"""
function irf(::Type{OnePL}, theta::Real, beta::Real, y = 1)
    prob = logistic(theta - beta)
    return ifelse(y == 1, prob, 1 - prob)
end

function irf(T::Type{OnePL}, theta::U, beta::AbstractVector{U}, y = 1) where {U<:Real}
    probs = zeros(U, length(beta))
    irf!(T, probs, theta, beta, y; scoring_function = one)
    return probs
end

function irf!(
    T::Type{OnePL},
    probs,
    theta,
    beta,
    y = 1;
    scoring_function::F = identity,
) where {F}
    for i in eachindex(beta)
        probs[i] += irf(T, theta, beta[i], y) * scoring_function(y)
    end
    return nothing
end

"""
    iif(::Type{OneParameterLogisticModel}, theta, beta, y = 1)

Evaluate the item information function of the one parameter logistic model for response `y`
at the ability value `theta` and item difficulty `beta`.

If the response value `y` is omitted, the item response probability for a correct response
`y = 1` is returned.

## Examples
```jldoctest
julia> iif(OneParameterLogisticModel, 0.0, 0.0, 1)
0.25

julia> iif(OneParameterLogisticModel, 0.0, -Inf, 1)
0.0

julia> iif(OneParameterLogisticModel, 0.0, Inf, 1)
0.0
```

"""
function iif(
    T::Type{OnePL},
    theta::U,
    beta::U,
    y;
    scoring_function::F = identity,
) where {F,U<:Real}
    expected = irf(T, theta, beta, 1) * scoring_function(1)
    info = zero(U)

    for y in 0:1
        prob = irf(T, theta, beta, y)
        info += (scoring_function(y) - expected)^2 * prob
    end

    return info
end

function iif(
    T::Type{OnePL},
    theta::U,
    beta::AbstractVector{U},
    y;
    scoring_function::F = identity,
) where {F,U<:Real}
    info = zeros(U, length(beta))
    iif!(T, info, theta, beta, y; scoring_function)
    return info
end

function iif!(
    T::Type{OnePL},
    info,
    theta::U,
    beta::AbstractVector{U},
    y;
    scoring_function::F = identity,
) where {F,U<:Real}
    for i in eachindex(beta)
        info[i] += iif(T, theta, beta[i], y; scoring_function)
    end
    return nothing
end

"""
    expected_score(::Type{OneParameterLogisticModel}, theta, betas; scoring_function)

Calculate the expected score of a one parameter logistic model for multiple items given
an ability value `theta` and an array of item difficulties `betas`.

`scoring_function` can be used to add weights to the resulting expected scores (see Examples
for details).

## Examples
```jldoctest
julia> expected_score(OneParameterLogisticModel, 0.0, zeros(3))
1.5

julia> expected_score(OneParameterLogisticModel, 0.0, fill(-Inf, 3))
3.0
```

### Using the scoring function
Using the `scoring_function` keyword argument allows to weigh response probabilities by
a value depending on the response `y`. It is of the form `f(y) = x`, assigning a scalar
value to every possible reponse value `y`.

For the one parameter logistic model the valid responses are 0 and 1. If we want to
calculate expected scores doubling the weight for `y = 1`, the weighted responses are 0 and
2. The corresponding `scoring_function` is `y -> 2y`,

```jldoctest
julia> expected_score(OneParameterLogisticModel, 0.0, zeros(3), scoring_function = y -> 2y)
3.0

```
"""
function expected_score(
    T::Type{OnePL},
    theta::U,
    betas;
    scoring_function::F = identity,
) where {U,F}
    score = zero(U)

    for beta in betas
        for y in 0:1
            score += irf(T, theta, beta, y) * scoring_function(y)
        end
    end

    return score
end

function expected_score(
    T::Type{OnePL},
    theta::U,
    betas::AbstractVector{<:AbstractVector{U}};
    scoring_function::F = identity,
) where {U,F}
    score = zeros(U, length(first(betas)))

    for beta in betas
        for y in 0:1
            irf!(T, score, theta, beta, y; scoring_function)
        end
    end

    return score
end

"""
    information(::Type{OneParameterLogisticModel}, theta, betas; scoring_function)

Calculate the information of a one parameter logistic model for multiple items given
an ability value `theta` and an array of item difficulties `betas`.

`scoring_function` can be used to add weights to the resulting expected scores (see Examples
for details).

## Examples
```jldoctest
julia> information(OneParameterLogisticModel, 0.0, zeros(3))
0.75

julia> information(OneParameterLogisticModel, 0.0, fill(Inf, 3))
0.0
```

### Using the scoring function
Using the `scoring_function` keyword argument allows to weigh response probabilities by
a value depending on the response `y`. It is of the form `f(y) = x`, assigning a scalar
value to every possible reponse value `y`.

For the one parameter logistic model the valid responses are 0 and 1. If we want to
calculate information doubling the weight for `y = 1`, the weighted responses are 0 and
2. The corresponding `scoring_function` is `y -> 2y`,

```jldoctest
julia> information(OneParameterLogisticModel, 0.0, zeros(3), scoring_function = y -> 2y)
3.0

```
"""
function information(
    T::Type{OnePL},
    theta::U,
    betas::AbstractVector{U};
    scoring_function::F = identity,
) where {U,F}
    info = zero(U)
    for beta in betas
        info += iif(T, theta, beta, 1; scoring_function)
    end
    return info
end

function information(
    T::Type{OnePL},
    theta::U,
    betas::AbstractVector{<:AbstractVector{U}};
    scoring_function::F = identity,
) where {U,F}
    info = zeros(U, length(first(betas)))

    for beta in betas
        for y in 0:1
            iif!(T, info, theta, beta, y; scoring_function)
        end
    end

    return info
end
