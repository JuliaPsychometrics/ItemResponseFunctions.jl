abstract type ThreeParameterLogisticModel <: DichotomousItemResponseModel end

const ThreePL = ThreeParameterLogisticModel

function irf(::Type{ThreePL}, theta, beta, y = 1)
    return irf(FourPL, theta, merge(beta, (; d = 1.0)), y)
end

function iif(::Type{ThreePL}, theta, beta, y = 1)
    return iif(FourPL, theta, merge(beta, (; d = 1.0)), y)
end
