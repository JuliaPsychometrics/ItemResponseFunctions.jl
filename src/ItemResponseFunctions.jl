module ItemResponseFunctions

using Reexport
using SimpleUnPack

@reexport import AbstractItemResponseModels:
    ItemResponseModel, irf, iif, expected_score, information

import AbstractItemResponseModels: response_type, Dichotomous

using LogExpFunctions: logistic

export OneParameterLogisticModel
export ThreeParameterLogisticModel
export FourParameterLogisticModel

abstract type DichotomousItemResponseModel <: ItemResponseModel end

response_type(::Type{<:DichotomousItemResponseModel}) = Dichotomous

include("models/dichotomous/4PL.jl")
include("models/dichotomous/3PL.jl")
include("models/dichotomous/2PL.jl")
include("models/dichotomous/1PL.jl")

"""
    expected_score
"""
function expected_score(
    M::Type{<:DichotomousItemResponseModel},
    theta::T,
    betas::AbstractVector,
) where {T<:Real}
    score = zero(T)

    for beta in betas
        for y in 0:1
            score += irf(M, theta, beta, y)
        end
    end

    return score
end

function information(
    M::Type{<:DichotomousItemResponseModel},
    theta::T,
    betas::AbstractVector,
) where {T<:Real}
    info = zero(T)

    for beta in betas
        for y in 0:1
            info += iif(M, theta, beta, y)
        end
    end

    return info
end

end
