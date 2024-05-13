abstract type FourParameterLogisticModel <: DichotomousItemResponseModel end

const FourPL = FourParameterLogisticModel

"""
    irf(::Type{FourParameterLogisticModel}, theta, beta, y = 1)

Evaluate the item response function of a four parameter logistic (4PL) model for response `y`
at the ability value `theta` given model parameters `beta`.

`beta` must be a desctructurable object with the following fields:

- `a`: the item discrimination
- `b`: the item difficulty (location)
- `c`: the lower asymptote
- `d`: the upport asymptote
"""
function irf(::Type{FourPL}, theta::Real, beta::NamedTuple, y = 1)
    @unpack a, b, c, d = beta
    prob = c + (d - c) * logistic(a * (theta - b))
    return ifelse(y == 1, prob, 1 - prob)
end

"""
    iif
"""
function iif(M::Type{FourPL}, theta, beta::NamedTuple, y = 1)
    @unpack a, b, c, d = beta
    prob = irf(M, theta, beta, y)

    num = a^2 * (prob - c)^2 * (d - prob)^2
    num == 0 && return num

    denum = (d - c)^2 * prob * (1 - prob)
    info = num / denum

    return info
end
