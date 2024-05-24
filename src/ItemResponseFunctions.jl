module ItemResponseFunctions

using DocStringExtensions: SIGNATURES, TYPEDEF, METHODLIST
using LogExpFunctions: logistic, cumsum!, softmax!
using Reexport: @reexport
using SimpleUnPack: @unpack

# AbstractItemResponseModels interface extensions
@reexport import AbstractItemResponseModels:
    ItemResponseModel, irf, iif, expected_score, information

import AbstractItemResponseModels: response_type, Dichotomous

export DichotomousItemResponseModel,
    FourPL,
    FourParameterLogisticModel,
    GPCM,
    GRSM,
    GeneralizedPartialCreditModel,
    GeneralizedRatingScaleModel,
    OnePL,
    OnePLG,
    OneParameterLogisticModel,
    OneParameterLogisticPlusGuessingModel,
    PCM,
    PartialCreditModel,
    RSM,
    RatingScaleModel,
    ThreePL,
    ThreeParameterLogisticModel,
    TwoPL,
    TwoParameterLogisticModel,
    irf!,
    partial_credit

include("model_types.jl")
include("utils.jl")
include("irf.jl")
include("iif.jl")
include("expected_score.jl")
include("information.jl")
include("scoring_functions.jl")

end
