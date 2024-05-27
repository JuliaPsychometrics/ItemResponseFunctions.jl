"""
    $(SIGNATURES)

Calculate the derivative of the item response function with respect to theta.
Returns the primal value and the first derivative.
"""
function derivative_theta(M::Type{<:ItemResponseModel}, theta, beta, y)
    adtype = AutoForwardDiff()
    prob, deriv = value_and_derivative(x -> irf(M, x, beta, y), adtype, theta)
    return prob, deriv
end

"""
    $(SIGNATURES)

Calculate the second derivative of the item response function with respect to theta.
Returns the primal value, the first and the second derivative.
"""
function second_derivative_theta(M::Type{<:ItemResponseModel}, theta, beta, y)
    adtype = AutoForwardDiff()
    prob, deriv = derivative_theta(M, theta, beta, y)
    deriv2 = second_derivative(x -> irf(M, x, beta, y), adtype, theta)
    return prob, deriv, deriv2
end
