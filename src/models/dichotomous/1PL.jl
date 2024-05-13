abstract type OneParameterLogisticModel <: DichotomousItemResponseModel end

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
function irf(::Type{OnePL}, theta::Real, beta::Real, y)
    prob = logistic(theta - beta)
    return ifelse(y == 1, prob, 1 - prob)
end

function irf(::Type{OnePL}, theta, beta, y)
    return irf(FourPL, theta, merge(beta, (a = 1.0, c = 0.0, d = 1.0)), y)
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
function iif(M::Type{OnePL}, theta::Real, beta::Real, y)
    prob = irf(M, theta, beta, y)
    return prob * (1 - prob)
end

function iif(M::Type{OnePL}, theta, beta, y)
    return iif(FourPL, theta, merge(beta, (a = 1.0, c = 0.0, d = 1.0)), y)
end
