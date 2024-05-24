module ItemResponseFunctions

using Reexport
using SimpleUnPack

@reexport import AbstractItemResponseModels:
    ItemResponseModel, irf, iif, expected_score, information

import AbstractItemResponseModels: response_type, Dichotomous

using LogExpFunctions: logistic, cumsum!, softmax!
using DocStringExtensions: SIGNATURES, TYPEDEF, METHODLIST

export DichotomousItemResponseModel,
    FourPL,
    FourParameterLogisticModel,
    OnePL,
    OneParameterLogisticModel,
    OnePLG,
    OneParameterLogisticPlusGuessingModel,
    ThreePL,
    ThreeParameterLogisticModel,
    TwoPL,
    TwoParameterLogisticModel,
    GPCM,
    GeneralizedPartialCreditModel,
    PCM,
    PartialCreditModel,
    RSM,
    RatingScaleModel,
    GRSM,
    GeneralizedRatingScaleModel,
    partial_credit,
    irf!

include("model_types.jl")
include("utils.jl")
include("irf.jl")
include("iif.jl")
include("expected_score.jl")
include("information.jl")
include("scoring_functions.jl")

end
