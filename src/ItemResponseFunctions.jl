module ItemResponseFunctions

using Reexport
using SimpleUnPack

@reexport import AbstractItemResponseModels:
    ItemResponseModel, irf, iif, expected_score, information

import AbstractItemResponseModels: response_type, Dichotomous

using LogExpFunctions: logistic
using DocStringExtensions: SIGNATURES, TYPEDEF, METHODLIST

export OneParameterLogisticModel, OnePL
export TwoParameterLogisticModel, TwoPL
export ThreeParameterLogisticModel, ThreePL
export FourParameterLogisticModel, FourPL

include("model_types.jl")
include("irf.jl")
include("iif.jl")
include("expected_score.jl")
include("information.jl")

end
