module ItemResponseFunctions

using AbstractItemResponseModels: Dichotomous, Nominal, checkresponsetype
using DocStringExtensions: SIGNATURES, TYPEDEF, METHODLIST
using LogExpFunctions: logistic, cumsum!, softmax!
using Reexport: @reexport
using SimpleUnPack: @unpack

# TODO: explicit imports
using DifferentiationInterface
import ForwardDiff

# AbstractItemResponseModels interface extensions
@reexport import AbstractItemResponseModels:
    ItemResponseModel, irf, iif, expected_score, information

import AbstractItemResponseModels: response_type

export DichotomousItemResponseModel,
    FivePL,
    FiveParameterLogisticModel,
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
    PolytomousItemResponseModel,
    RSM,
    RatingScaleModel,
    ThreePL,
    ThreeParameterLogisticModel,
    TwoPL,
    TwoParameterLogisticModel,
    irf!,
    partial_credit,
    derivative_theta,
    derivative_theta!,
    second_derivative_theta,
    second_derivative_theta!

include("model_types.jl")
include("utils.jl")
include("irf.jl")
include("iif.jl")
include("expected_score.jl")
include("information.jl")
include("scoring_functions.jl")
include("derivatives.jl")

include("precompile.jl")

end
