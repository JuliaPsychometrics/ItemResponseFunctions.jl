abstract type OneParameterLogisticModel{T<:EstimationType} <: ItemResponseModel end

const OnePL = Type{OneParameterLogisticModel}

response_type(::OnePL) = Dichotomous
person_dimensionality(::OnePL) = Univariate
item_dimensionality(::OnePL) = Univariate


# item response function
function irf(::OnePL, theta::Real, beta::Real, y)
    prob = logistic(theta - beta)
    return ifelse(y == 1, prob, 1 - prob)
end

function irf(T::OnePL, theta::U, beta::AbstractVector{U}, y) where {U<:Real}
    probs = zeros(U, length(beta))
    irf!(T, probs, theta, beta, y; scoring_function = one)
    return probs
end

function irf!(T::OnePL, probs, theta, beta, y; scoring_function::F = identity) where {F}
    for i in eachindex(beta)
        probs[i] += irf(T, theta, beta[i], y) * scoring_function(y)
    end
    return nothing
end

# item information function
function iif(
    T::OnePL,
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
    T::OnePL,
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
    T::OnePL,
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

# expected score
function expected_score(
    T::OnePL,
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
    T::OnePL,
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

# information
function information(
    T::OnePL,
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
    T::OnePL,
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
