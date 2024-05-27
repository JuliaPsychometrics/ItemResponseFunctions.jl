"""
    $(SIGNATURES)

Calculate the derivative of the item response function with respect to theta.
Returns the primal value and the first derivative.
"""
function derivative_theta(M::Type{<:ItemResponseModel}, theta, beta, y)
    prob = irf(M, theta, beta, y)
    deriv = derivative(x -> irf(M, x, beta, y), AutoForwardDiff(), theta)
    return prob, deriv
end

function derivative_theta(M::Type{FourPL}, theta, beta, y)
    @unpack a, c, d = beta
    prob = irf(M, theta, beta, y)
    pu = irf(TwoPL, theta, beta, 1)  # unconstrained probability
    qu = 1 - pu
    deriv = (d - c) * a * (pu * qu) * ifelse(y == 1, 1, -1)
    return prob, deriv
end

function derivative_theta(M::Type{ThreePL}, theta, beta, y)
    pars = merge_pars(M, beta)
    return derivative_theta(FourPL, theta, pars, y)
end

function derivative_theta(M::Type{TwoPL}, theta, beta, y)
    pars = merge_pars(M, beta)
    return derivative_theta(FourPL, theta, pars, y)
end

function derivative_theta(M::Type{OnePLG}, theta, beta, y)
    pars = merge_pars(M, beta)
    return derivative_theta(FourPL, theta, pars, y)
end

function derivative_theta(M::Type{OnePL}, theta, beta, y)
    pars = merge_pars(M, beta)
    return derivative_theta(FourPL, theta, pars, y)
end

function derivative_theta(M::Type{OnePL}, theta, beta::Real, y)
    pars = merge_pars(M, (; b = beta))
    return derivative_theta(FourPL, theta, pars, y)
end

"""
    $(SIGNATURES)

Calculate the second derivative of the item response function with respect to theta.
Returns the primal value, the first and the second derivative.
"""
function second_derivative_theta(M::Type{<:ItemResponseModel}, theta, beta, y)
    prob, deriv = derivative_theta(M, theta, beta, y)
    deriv2 = second_derivative(x -> irf(M, x, beta, y), AutoForwardDiff(), theta)
    return prob, deriv, deriv2
end

function second_derivative_theta(M::Type{FourPL}, theta, beta, y)
    @unpack a, c, d = beta
    prob, deriv = derivative_theta(M, theta, beta, y)
    pu = irf(TwoPL, theta, beta, 1)
    qu = 1 - pu
    deriv2 = a^2 * (d - c) * (2 * (qu^2 * pu) - pu * qu) * ifelse(y == 1, 1, -1)
    return prob, deriv, deriv2
end

function second_derivative_theta(M::Type{ThreePL}, theta, beta, y)
    pars = merge_pars(M, beta)
    return second_derivative_theta(FourPL, theta, pars, y)
end

function second_derivative_theta(M::Type{TwoPL}, theta, beta, y)
    pars = merge_pars(M, beta)
    return second_derivative_theta(FourPL, theta, pars, y)
end

function second_derivative_theta(M::Type{OnePLG}, theta, beta, y)
    pars = merge_pars(M, beta)
    return second_derivative_theta(FourPL, theta, pars, y)
end

function second_derivative_theta(M::Type{OnePL}, theta, beta, y)
    pars = merge_pars(M, beta)
    return second_derivative_theta(FourPL, theta, pars, y)
end

function second_derivative_theta(M::Type{OnePL}, theta, beta::Real, y)
    pars = merge_pars(M, (; b = beta))
    return second_derivative_theta(FourPL, theta, pars, y)
end
