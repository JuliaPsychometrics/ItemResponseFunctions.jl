"""
    $(SIGNATURES)

Calculate the derivative of the item (category) response function with respect to `theta` of
model `M` given item parameters `beta` for all possible responses. This function overwrites
`probs` and `derivs` with the item category response probabilities and derivatives respectively.
"""
function derivative_theta!(M::Type{<:ItemResponseModel}, probs, derivs, theta, beta)
    pars = merge_pars(M, beta)
    return _derivative_theta!(M, probs, derivs, theta, pars)
end

function _derivative_theta!(M::Type{<:ItemResponseModel}, probs, derivs, theta, beta)
    derivative!((y, x) -> _irf!(M, y, x, beta), probs, derivs, AutoForwardDiff(), theta)
    return probs, derivs
end

# this is implemented for all except 5PL
const DichModelsWithDeriv = Union{OnePL,TwoPL,ThreePL,FourPL}

function _derivative_theta!(M::Type{<:DichModelsWithDeriv}, probs, derivs, theta, beta)
    probs[2], derivs[2] = _derivative_theta(FourPL, theta, beta, 1)
    probs[1] = 1 - probs[2]
    derivs[1] = -derivs[2]
    return probs, derivs
end

const PolyModelsWithDeriv = Union{GPCM,PCM,GRSM,RSM}

function _derivative_theta!(M::Type{<:PolyModelsWithDeriv}, probs, derivs, theta, beta)
    @unpack a, b, t = beta
    _irf!(M, probs, theta, beta)

    @show num = vcat(0.0, @. a * (theta - b + t))
    @show den = sum(num)

    for c in eachindex(probs)
        derivs[c] = c * probs[c] * (1 - probs[c])
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
function derivative_theta(M::Type{<:ItemResponseModel}, theta, beta)
    ncat = M <: DichotomousItemResponseModel ? 2 : length(beta.t) + 1
    probs = zeros(ncat)
    derivs = similar(probs)
    return derivative_theta!(M, probs, derivs, theta, beta)
end

function derivative_theta(M::Type{<:Union{OnePL,OnePLG}}, theta, beta::Real)
    pars = merge_pars(M, beta)
    return derivative_theta(M, theta, pars)
end

function derivative_theta(M::Type{<:PolytomousItemResponseModel}, theta, beta, y)
    probs, derivs = derivative_theta(M, theta, beta)
    return probs[y], derivs[y]
end

function derivative_theta(M::Type{<:DichotomousItemResponseModel}, theta, beta, y)
    prob, deriv = value_and_derivative(x -> irf(M, x, beta, y), AutoForwardDiff(), theta)
    return prob, deriv
end

function derivative_theta(M::Type{<:DichModelsWithDeriv}, theta, beta, y)
    pars = merge_pars(M, beta)
    return _derivative_theta(M, theta, pars, y)
end

# analytic first derivative implementations
function _derivative_theta(M::Type{<:DichModelsWithDeriv}, theta, beta, y)
    @unpack a, c, d = beta
    prob = irf(M, theta, beta, y)
    pu = irf(TwoPL, theta, beta, 1)  # unconstrained response probability
    qu = 1 - pu
    deriv = (d - c) * a * (pu * qu) * ifelse(y == 1, 1, -1)
    return prob, deriv
end

function _derivative_theta(M::Type{<:PolyModelsWithDeriv}, theta, beta)
    @unpack a, probs = irf()
end

"""
    $(SIGNATURES)

Calculate the second derivative of the item (category) response function with respect to
`theta` of model `M` given item parameters `beta` for response `y`.
Returns the primal value, the first derivative, and the second derivative

If `y` is omitted, returns values and derivatives for all possible responses.

This function overwrites `probs`, `derivs` and `derivs2` with the respective values.
"""
function second_derivative_theta!(M, probs, derivs, derivs2, theta, beta)
    pars = merge_pars(M, beta)
    return _second_derivative_theta!(M, probs, derivs, derivs2, theta, pars)
end

function _second_derivative_theta!(
    M::Type{<:DichotomousItemResponseModel},
    probs,
    derivs,
    derivs2,
    theta,
    beta,
)
    _derivative_theta!(M, probs, derivs, theta, beta)
    return probs, derivs, derivs2
end

function _second_derivative_theta!(
    M::Type{<:DichModelsWithDeriv},
    probs,
    derivs,
    derivs2,
    theta,
    beta,
)
    probs[2], derivs[2], derivs2[2] = _second_derivative_theta(FourPL, theta, beta, 1)
    probs[1] = 1 - probs[2]
    derivs[1] = -derivs[2]
    derivs2[1] = -derivs2[2]
    return probs, derivs, derivs2
end

# TODO: polytomous models
function _second_derivative_theta!(M::Type{<:PolytomousItemResponseModel}, args...)
    error("Not implemented yet")
    return nothing
end

"""
    $(SIGNATURES)
"""
function second_derivative_theta(M, theta, beta) end
function second_derivative_theta(M, theta, beta, y) end


"""
    $(SIGNATURES)

Calculate the second derivative of the item response function with respect to theta.
Returns the primal value, the first and the second derivative.
"""
function second_derivative_theta(M::Type{<:ItemResponseModel}, theta, beta)
    ncat = M <: DichotomousItemResponseModel ? 2 : length(beta.t) + 1
    probs = zeros(ncat)
    derivs = similar(probs)
    derivs2 = similar(probs)
    return second_derivative_theta!(M, probs, derivs, derivs2, theta, beta)
end

function second_derivative_theta(M::Type{<:Union{OnePL,OnePLG}}, theta, beta::Real)
    pars = merge_pars(M, beta)
    return second_derivative_theta(M, theta, pars)
end

function second_derivative_theta(M::Type{<:PolytomousItemResponseModel}, theta, beta, y)
    probs, derivs, derivs2 = second_derivative_theta(M, theta, beta)
    return probs[y], derivs[y], derivs2[y]
end

function second_derivative_theta(M::Type{<:DichotomousItemResponseModel}, theta, beta, y)
    adtype = AutoForwardDiff()
    prob, deriv = value_and_derivative(x -> irf(M, x, beta, y), adtype, theta)
    deriv2 = second_derivative(x -> irf(M, x, beta, y), adtype, theta)
    return prob, deriv, deriv2
end

function second_derivative_theta(M::Type{<:DichModelsWithDeriv}, theta, beta, y)
    pars = merge_pars(M, beta)
    return _second_derivative_theta(M, theta, pars, y)
end

# analytic implementations of second derivatives
function _second_derivative_theta(M::Type{<:DichModelsWithDeriv}, theta, beta, y)
    @unpack a, c, d = beta
    prob, deriv = derivative_theta(M, theta, beta, y)
    pu = irf(TwoPL, theta, beta, 1)  # unconstrained probability
    qu = 1 - pu
    deriv2 = a^2 * (d - c) * (2 * (qu^2 * pu) - pu * qu) * ifelse(y == 1, 1, -1)
    return prob, deriv, deriv2
end
