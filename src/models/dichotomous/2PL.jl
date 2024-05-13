abstract type TwoParameterLogisticModel <: DichotomousItemResponseModel end

const TwoPL = TwoParameterLogisticModel

function irf(::Type{TwoPL}, theta, beta, y = 1)
    return irf(FourPL, theta, merge(beta, (; c = 0.0, d = 1.0)), y)
end

function iif(::Type{TwoPL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (; c = 0.0, d = 1.0)), y)
end
