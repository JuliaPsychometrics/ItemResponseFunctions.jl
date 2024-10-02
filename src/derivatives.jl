function second_derivative(f, x)
    return derivative(x -> derivative(f, x), x)
end

"""
    $(SIGNATURES)

Calculate the derivative of the item (category) response function with respect to `theta` of
model `M` given item parameters `beta` for all possible responses. This function overwrites
`probs` and `derivs` with the item category response probabilities and derivatives respectively.
"""
function derivative_theta!(
    M::Type{<:ItemResponseModel},
    probs,
    derivs,
    theta,
    beta;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    return _derivative_theta!(M, probs, derivs, theta, pars; scoring_function)
end

function _derivative_theta!(
    M::Type{<:ItemResponseModel},
    probs,
    derivs,
    theta,
    beta;
    scoring_function::F,
) where {F}
    f = (y, x) -> _irf!(M, y, x, beta; scoring_function)
    derivative!(derivs, f, probs, theta)
    return probs, derivs
end

# this is implemented for all except 5PL
const DichModelsWithDeriv = Union{OnePL,TwoPL,ThreePL,FourPL}

function _derivative_theta!(
    M::Type{<:DichModelsWithDeriv},
    probs,
    derivs,
    theta,
    beta;
    scoring_function::F,
) where {F}
    probs[1], derivs[1] = _derivative_theta(M, theta, beta, 0; scoring_function)
    probs[2], derivs[2] = _derivative_theta(M, theta, beta, 1; scoring_function)
    return probs, derivs
end

const PolyModelsWithDeriv = Union{GPCM,PCM,GRSM,RSM}

function _derivative_theta!(
    M::Type{<:PolyModelsWithDeriv},
    probs,
    derivs,
    theta,
    beta;
    scoring_function::F,
) where {F}
    @unpack a, b, t = beta
    score = _expected_score!(M, probs, theta, beta)
    _irf!(M, probs, theta, beta; scoring_function)

    for c in eachindex(probs)
        derivs[c] = a * probs[c] * (c - score)
    end

    return probs, derivs
end

"""
    $(SIGNATURES)

Calculate the derivative of the item (category) response function with respect to `theta` of
model `M` given item parameters `beta` for response `y`.
Returns the primal value and the first derivative.

If `y` is omitted, returns probabilities and derivatives for all possible responses (see
also [`derivative_theta!`](@ref)).
"""
function derivative_theta(
    M::Type{<:ItemResponseModel},
    theta,
    beta;
    scoring_function::F = one,
) where {F}
    ncat = M <: DichotomousItemResponseModel ? 2 : length(beta.t) + 1
    probs = zeros(ncat)
    derivs = similar(probs)
    return derivative_theta!(M, probs, derivs, theta, beta; scoring_function)
end

function derivative_theta(
    M::Type{OnePL},
    theta,
    beta::Real;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    return derivative_theta(M, theta, pars; scoring_function)
end

function derivative_theta(
    M::Type{<:PolytomousItemResponseModel},
    theta,
    beta,
    y;
    scoring_function::F = one,
) where {F}
    probs, derivs = derivative_theta(M, theta, beta; scoring_function)
    return probs[y], derivs[y]
end

function derivative_theta(
    M::Type{<:DichotomousItemResponseModel},
    theta,
    beta,
    y;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    f = x -> irf(M, x, pars, y) * scoring_function(y)
    prob = f(theta)
    deriv = derivative(f, theta)
    return prob, deriv
end

function derivative_theta(
    M::Type{<:DichModelsWithDeriv},
    theta,
    beta,
    y;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    return _derivative_theta(M, theta, pars, y; scoring_function)
end

# analytic first derivative implementations
function _derivative_theta(
    M::Type{<:DichModelsWithDeriv},
    theta,
    beta,
    y;
    scoring_function::F,
) where {F}
    @unpack a, c, d = beta
    score = scoring_function(y)
    prob = irf(M, theta, beta, y) * score

    # unconstrained response probabilities
    pu = irf(TwoPL, theta, beta, 1)
    qu = 1 - pu

    deriv = score * (d - c) * a * (pu * qu) * ifelse(y == 1, 1, -1)
    return prob, deriv
end

"""
    $(SIGNATURES)

Calculate the second derivative of the item (category) response function with respect to
`theta` of model `M` given item parameters `beta` for response `y`.
Returns the primal value, the first derivative, and the second derivative

If `y` is omitted, returns values and derivatives for all possible responses.

This function overwrites `probs`, `derivs` and `derivs2` with the respective values.
"""
function second_derivative_theta!(
    M::Type{<:ItemResponseModel},
    probs,
    derivs,
    derivs2,
    theta,
    beta;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    return _second_derivative_theta!(
        M,
        probs,
        derivs,
        derivs2,
        theta,
        pars;
        scoring_function,
    )
end

function _second_derivative_theta!(
    M::Type{<:DichotomousItemResponseModel},
    probs,
    derivs,
    derivs2,
    theta,
    beta;
    scoring_function::F,
) where {F}
    _derivative_theta!(M, probs, derivs, theta, beta; scoring_function)
    f0 = x -> irf(M, x, beta, 0) * scoring_function(0)
    f1 = x -> irf(M, x, beta, 1) * scoring_function(1)
    derivs2[1] = second_derivative(f0, theta)
    derivs2[2] = second_derivative(f1, theta)
    return probs, derivs, derivs2
end

function _second_derivative_theta!(
    M::Type{<:DichModelsWithDeriv},
    probs,
    derivs,
    derivs2,
    theta,
    beta;
    scoring_function::F,
) where {F}
    probs[1], derivs[1], derivs2[1] =
        _second_derivative_theta(FourPL, theta, beta, 0; scoring_function)
    probs[2], derivs[2], derivs2[2] =
        _second_derivative_theta(FourPL, theta, beta, 1; scoring_function)
    return probs, derivs, derivs2
end

function _second_derivative_theta!(
    M::Type{<:PolyModelsWithDeriv},
    probs,
    derivs,
    derivs2,
    theta,
    beta;
    scoring_function::F,
) where {F}
    @unpack a, b, t = beta
    score = _expected_score!(M, probs, theta, beta)
    score2 = sum(c^2 * probs[c] for c in eachindex(probs))

    _irf!(M, probs, theta, beta; scoring_function)

    for c in eachindex(probs)
        derivs[c] = a * probs[c] * (c - score)
        derivs2[c] = a^2 * probs[c] * (c^2 - 2 * c * score + 2 * score^2 - score2)
    end

    return probs, derivs, derivs2
end

"""
    $(SIGNATURES)

Calculate the second derivative of the item (category) response function with respect to
`theta` of model `M` given item parameters `beta` for response `y`.
Returns the primal value, the first derivative and the second derivative.

If `y` is omitted, returns primals and derivatives for all possible responses (see also
[`second_derivative_theta!`](@ref)).
"""
function second_derivative_theta(
    M::Type{<:ItemResponseModel},
    theta,
    beta;
    scoring_function::F = one,
) where {F}
    ncat = M <: DichotomousItemResponseModel ? 2 : length(beta.t) + 1
    probs = zeros(ncat)
    derivs = similar(probs)
    derivs2 = similar(probs)
    return second_derivative_theta!(
        M,
        probs,
        derivs,
        derivs2,
        theta,
        beta;
        scoring_function,
    )
end

function second_derivative_theta(
    M::Type{OnePL},
    theta,
    beta::Real;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    return second_derivative_theta(M, theta, pars; scoring_function)
end

function second_derivative_theta(M::Type{<:PolytomousItemResponseModel}, theta, beta, y)
    probs, derivs, derivs2 = second_derivative_theta(M, theta, beta)
    return probs[y], derivs[y], derivs2[y]
end

function second_derivative_theta(
    M::Type{<:DichotomousItemResponseModel},
    theta,
    beta,
    y;
    scoring_function::F = one,
) where {F}
    f = x -> irf(M, x, beta, y) * scoring_function(y)
    prob = f(theta)
    deriv = derivative(f, theta)
    deriv2 = second_derivative(f, theta)
    return prob, deriv, deriv2
end

function second_derivative_theta(
    M::Type{<:DichModelsWithDeriv},
    theta,
    beta,
    y;
    scoring_function::F = one,
) where {F}
    pars = ItemParameters(M, beta)
    return _second_derivative_theta(M, theta, pars, y; scoring_function)
end

# analytic implementations of second derivatives
function _second_derivative_theta(
    M::Type{<:DichModelsWithDeriv},
    theta,
    beta,
    y;
    scoring_function::F,
) where {F}
    @unpack a, c, d = beta
    prob, deriv = derivative_theta(M, theta, beta, y; scoring_function)
    score = scoring_function(y)
    pu = irf(TwoPL, theta, beta, 1)  # unconstrained probability
    qu = 1 - pu
    deriv2 = a^2 * score * (d - c) * (2 * (qu^2 * pu) - pu * qu) * ifelse(y == 1, 1, -1)
    return prob, deriv, deriv2
end
